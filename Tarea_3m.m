% a) Cada imagen por clase convertir en matriz–vector y disponer las 
%    20 imágenes de cada clase en una matriz, con renglón por imagen, tal 
%    que la matriz resultante tenga 20 renglones.

%%
% Definir la ruta de la carpeta que contiene las imágenes
% carpeta = 'C:\Users\harun\OneDrive\Documentos\25-P\IA_introduccion\DB_tornillos\';
carpeta = 'C:\Users\Aaron\Documents\25-P\IA\DB_tornillos\';
clases = {'Alcayata', 'Armella', 'Cola de pato', 'Rondana', 'Tornillo'};
no_clases = length(clases);
no_imagenes = 20;

matriz_temp = [];
matriz_imagenes = {}; 
%
for i=1 : no_clases
    % Obtener la lista de archivos en la carpeta
    direccion = strcat(carpeta, clases{i});
    imagenes = dir(fullfile(direccion, '*.bmp'));
    
    matriz_temp =[];
    % Iterar sobre cada archivo
    for j = 1: no_imagenes
        % Cargar la imagen actual
        imagen = imread(fullfile(direccion, imagenes(j).name));
        % Bajar resolución
        img_red = imresize(imagen, [32 32]);     
        % Convertir la imagen en un vector fila
        vector_fila = reshape(img_red, 1, []);
        
        % Agregar vector fila a una matriz
        matriz_temp(j, :) = double(vector_fila);
        
    end
    matriz_imagenes{end+1} = matriz_temp;
end
mostrar_estadisticos(matriz_imagenes, no_clases, clases, no_imagenes);

clasificador_bayes(matriz_imagenes, no_clases, no_imagenes);


%% Tratamiento para encontrar y aislar el objeo de interés

funciones = {@segmentAlcayata, @segmentArmella, @segmentColaPato, @segmentRondana, @segmentTornillo};

matriz_temp = [];
matriz_imagenes = {}; 

disp('================================LEYENDO IMAGENES==========================================');

for i=1 : no_clases
    % Obtener la lista de archivos en la carpeta
    direccion = strcat(carpeta, clases{i});
    imagenes = dir(fullfile(direccion, '*.bmp'));
    
    matriz_temp =[];
    % Iterar sobre cada archivo
    for j = 1: no_imagenes
        % Cargar la imagen actual
        fprintf('Clase %d imagen  %d : %s.', i, j, imagenes(j).name);
        imagen = imread(fullfile(direccion, imagenes(j).name));
        mask = funciones{i}(imagen);
        % imshow(mask);
        % input('');
        % Bajar resolución
        % img_red = imresize(mask, [32 32]);     
        % Convertir la imagen en un vector fila
        vector_fila = reshape(mask, 1, []);
        
        % Agregar vector fila a una matriz
        matriz_temp(j, :) = double(vector_fila);
        
    end
    matriz_imagenes{end+1} = matriz_temp;
end
mostrar_estadisticos(matriz_imagenes, no_clases, clases, no_imagenes);

clasificador_bayes(matriz_imagenes, no_clases, no_imagenes);

%%
function clasificador_bayes(matriz_imagenes, no_clases, no_imagenes )
    %% ===================== PASO E: CLASIFICADOR DE BAYES =====================
    % Dividir en entrenamiento (15) y prueba (5)
    X = [];
    Y = [];
    
    for c=1: no_clases
        clase = matriz_imagenes{c};
    
        for i=1 : no_imagenes
            img = clase(i,:);
            % Calculo de la entropia
            h = histcounts(img, 256, 'Normalization', 'probability');
            h(h==0)=[];
            entropia = -sum(h .* log2(h));
    
            % Vector de caractarísticas
            X(end+1, :) = [mean(img), var(img), std(img), sum(img.^2)/1e9, entropia];
            Y(end+1, 1) = c;
        end
    end
    
    % Dividir en entrenamiento y prueba:
    X_train=[];
    Y_train=[];
    X_test=[];
    Y_test=[];
    
    for c = 1:no_clases
        idx = find(Y==c);
        
        X_train = [X_train; X(idx(1:15), :)];
        Y_train = [Y_train; Y(idx(1:15), :)];
    
        X_test = [X_test; X(idx(16:20), :)];
        Y_test = [Y_test; Y(idx(16:20), :)];
    end
    
    % Entrenar y evaluar
    modelo = fitcdiscr(X_train, Y_train);
    Y_pred = predict(modelo, X_test);
    
    % Evaluar el rendimiento
    figure;
    confusionchart(Y_test, Y_pred);
    conf_mat = confusionmat(Y_test, Y_pred);
    precision_total = sum(diag(conf_mat)) / sum(conf_mat(:));
    
    fprintf('Precisión del clasificador: %.2f%%\n', precision_total * 100);
end

function mostrar_estadisticos(matriz, no_clases, clases, no_imagenes)
    %% b) Por clase, vista cada imagen como señal, calcular la media, 
    % varianza y desviación estándar.
    media = zeros(no_clases,1);
    varianza = zeros(no_clases,1);
    desv_estandar = zeros(no_clases,1);
    
    for c=1: no_clases
        media(c) = mean(matriz{c}, 'all');
        varianza(c) = mean(var(matriz{c}, 0, 2));
        desv_estandar(c) = mean(std(matriz{c}, 0, 2));
    end
    
    % c) Graficar los datos del paso anterior en una sola figura, 
    % indicando los valores por clase. Describa cómo son los datos 
    % por cada clase.
    figure;
    hold on;
    bar(media, 'FaceColor', 'b');
    errorbar(1:no_clases, media, desv_estandar, 'k', 'linestyle', 'none');
    xticks(1:no_clases);
    xticklabels(clases);
    xlabel('Clases');
    ylabel('Valores');
    title('Media y Desviación Estándar por Clase');
    hold off;
    
    figure;
    subplot(1,3,1); bar(media);    title('Media');        xticklabels(clases);
    subplot(1,3,2); bar(varianza); title('Varianza');     xticklabels(clases);
    subplot(1,3,3); bar(desv_estandar); title('Desv. Est.');   xticklabels(clases);
    
    %% ------------------- ENERGÍA Y ENTROPÍA --------------------------------
    % d) Calcule la energía y la entropía por clase y de el valor promedio 
    % por clase. Graficar los valores.
    
    energia = zeros(no_clases, 1);
    entropia= zeros(no_clases, 1);
    
    for c=1: no_clases
        energia(c) = sum(matriz{c}.^2, 'all');
        entropias_imag = zeros(no_imagenes,1);
    
        for i=1 : no_imagenes
            img_vector = matriz{c}(i,:);
            h = histcounts(img_vector, 256, 'Normalization', 'probability');
            h(h==0)=[];
            entropias_imag(i) = -sum(h .* log2(h));
        end
        entropia(c) = mean(entropias_imag);
    end
    
    figure;
    subplot(1,2,1); bar(energia);  title('Energía por clase');  xticklabels(clases);
    subplot(1,2,2); bar(entropia); title('Entropía por clase'); xticklabels(clases);
end

function [BW,maskedImage] = segmentAlcayata(X)
%segmentImage Segment image using auto-generated code from Image Segmenter app
%  [BW,MASKEDIMAGE] = segmentImage(X) segments image X using auto-generated
%  code from the Image Segmenter app. The final segmentation is returned in
%  BW, and a masked image is returned in MASKEDIMAGE.

% Auto-generated by imageSegmenter app on 10-Jul-2025
%----------------------------------------------------
fprintf(' - funcion Alcayata\n');

% Adjust data to span data range.
X = imadjust(X);

% Threshold image with manual threshold
BW = im2gray(X) > 2.524500e+02;

% Open mask with square
width = 3;
se = strel('square', width);
BW = imopen(BW, se);

% Create masked image.
maskedImage = X;
maskedImage(~BW) = 0;
end

function [BW,maskedImage] = segmentArmella(X)
%segmentImage Segment image using auto-generated code from Image Segmenter app
%  [BW,MASKEDIMAGE] = segmentImage(X) segments image X using auto-generated
%  code from the Image Segmenter app. The final segmentation is returned in
%  BW, and a masked image is returned in MASKEDIMAGE.

% Auto-generated by imageSegmenter app on 15-Jul-2025
%----------------------------------------------------
fprintf(' - funcion Armella\n');

% Adjust data to span data range.
X = imadjust(X);

% Threshold image with manual threshold
BW = im2gray(X) > 2.524500e+02;

% Create masked image.
maskedImage = X;
maskedImage(~BW) = 0;
end

function [BW,maskedImage] = segmentColaPato(X)
%segmentImage Segment image using auto-generated code from Image Segmenter app
%  [BW,MASKEDIMAGE] = segmentImage(X) segments image X using auto-generated
%  code from the Image Segmenter app. The final segmentation is returned in
%  BW, and a masked image is returned in MASKEDIMAGE.

% Auto-generated by imageSegmenter app on 15-Jul-2025
%----------------------------------------------------
fprintf(' - funcion Cola de Pato\n');

% Adjust data to span data range.
X = imadjust(X);

% Threshold image with global threshold
BW = imbinarize(im2gray(X));

% Create masked image.
maskedImage = X;
maskedImage(~BW) = 0;
end

function [BW,maskedImage] = segmentRondana(X)
%segmentImage Segment image using auto-generated code from Image Segmenter app
%  [BW,MASKEDIMAGE] = segmentImage(X) segments image X using auto-generated
%  code from the Image Segmenter app. The final segmentation is returned in
%  BW, and a masked image is returned in MASKEDIMAGE.

% Auto-generated by imageSegmenter app on 15-Jul-2025
%----------------------------------------------------
fprintf(' - funcion Rondana\n');

% Threshold image with global threshold
BW = imbinarize(im2gray(X));

% Create masked image.
maskedImage = X;
maskedImage(~BW) = 0;
end

function [BW,maskedImage] = segmentTornillo(X)
%segmentImage Segment image using auto-generated code from Image Segmenter app
%  [BW,MASKEDIMAGE] = segmentImage(X) segments image X using auto-generated
%  code from the Image Segmenter app. The final segmentation is returned in
%  BW, and a masked image is returned in MASKEDIMAGE.

% Auto-generated by imageSegmenter app on 15-Jul-2025
%----------------------------------------------------
fprintf(' - funcion Tornillo\n');

% Adjust data to span data range.
X = imadjust(X);

% Threshold image with manual threshold
BW = im2gray(X) > 2.524500e+02;

% Create masked image.
maskedImage = X;
maskedImage(~BW) = 0;
end

