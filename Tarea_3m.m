% a) Cada imagen por clase convertir en matriz–vector y disponer las 
%    20 imágenes de cada clase en una matriz, con renglón por imagen, tal 
%    que la matriz resultante tenga 20 renglones.

% Definir la ruta de la carpeta que contiene las imágenes
carpeta = 'C:\Users\harun\OneDrive\Documentos\25-P\IA_introduccion\DB_tornillos\';
% carpeta = 'C:\Users\Aaron\Documents\IA\DB_tornillos'

clases = {'Tornillo', 'Alcayata', 'Armella', 'Cola de pato', 'Rondana'};
no_clases = length(clases);

matriz_temp = [];
matriz_imagenes = {}; 
for i=1 : no_clases
    % Obtener la lista de archivos en la carpeta
    direccion = strcat(carpeta, clases{i});
    archivos = dir(fullfile(direccion, '*.bmp'));
    
    % Iterar sobre cada archivo
    for j = 1: length(archivos)
        % Cargar la imagen actual
        imagen = imread(fullfile(direccion, archivos(j).name));
            
        % Convertir la imagen en un vector fila
        vector_fila = reshape(imagen, 1, []);
        
        % Agregar vector fila a una matriz
        matriz_temp(j, :) = double(vector_fila);
        
    end
    matriz_imagenes{end+1} = matriz_temp;
end
% <<<<<<<<<<<<<<<<<< a) <<<<<<<<<<<<<<<<<<<

% b) Por clase, vista cada imagen como señal, calcular la media, 
% varianza y desviación estándar.
media = zeros(no_clases,1);
varianza = zeros(no_clases,1);
desv_estandar = zeros(no_clases,1);

for c=1: no_clases
    media(c) = mean(matriz_imagenes{c}, 'all');
    varianza(c) = mean(var(matriz_imagenes{c}, 0, 2));
    desv_estandar(c) = mean(std(matriz_imagenes{c}, 0, 2));
end

% <<<<<<<<<<<<<<<<<< a) <<<<<<<<<<<<<<<<<<<
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
subplot(1,3,3); bar(desv_est); title('Desv. Est.');   xticklabels(clases);