% Definir la ruta de la carpeta que contiene las imágenes
carpeta = {'C:\Users\Aaron\Documents\IA\DB_tornillos\Tornillos\', 
    'C:\Users\Aaron\Documents\IA\DB_tornillos\Alcayata\', 
    'C:\Users\Aaron\Documents\IA\DB_tornillos\Armella\', 
    'C:\Users\Aaron\Documents\IA\DB_tornillos\Cola_de_pato\', 
    'C:\Users\Aaron\Documents\IA\DB_tornillos\Rondana\'};
matriz_temp = [];
matriz_imagenes = {}; 
for i=1 : length(carpeta)
    % Obtener la lista de archivos en la carpeta
    archivos = dir(fullfile(carpeta{i}, '*.bmp'));
    
    % Iterar sobre cada archivo
    for j = 1: length(archivos)
        % Cargar la imagen actual
        imagen = imread(fullfile(carpeta{i}, archivos(j).name));
            
        % Convertir la imagen en un vector fila
        vector_fila = reshape(imagen, 1, []);
        
        % Agregar vector fila a una matriz
        matriz_temp(j, :) = double(vector_fila);
        
    end
    matriz_imagenes{end+1} = matriz_temp;
end

% Obtener las dimensiones de la imagen
[alto, ancho, ~] = size(imagen);

% Convertir la imagen en un vector columna
vector_columna = reshape(imagen, [], 1);

% Convertir la imagen en un vector fila
vector_fila = reshape(imagen, 1, []);

% Mostrar el tamaño de los vectores
disp(['Tamaño del vector columna: ', num2str(size(vector_columna))]);
disp(['Tamaño del vector fila: ', num2str(size(vector_fila))]);

% Si quieres convertir la imagen a una matriz de doble precisión
imagen_double = im2double(imagen);

% Opcionalmente, puedes convertir la matriz a escala de grises
if size(imagen,3) == 3 % Si es una imagen a color
  imagen_gris = rgb2gray(imagen);
  vector_gris = reshape(imagen_gris, [], 1);
  disp(['Tamaño del vector columna en escala de grises: ', num2str(size(vector_gris))]);
end