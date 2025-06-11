% Dos puntos en el plano cartesiano
centroide_1 = [0,5];
centroide_2 = [5,0];
sigma = 1; 

% Generando puntos aleatorios
cantidad_puntos = 100;
conjunto_1 = sigma * randn(cantidad_puntos, 2) + centroide_1;
conjunto_2 = sigma * randn(cantidad_puntos, 2) + centroide_2;

% Calculando las medias de cada conjunto
media_con_1 = mean(conjunto_1);
media_con_2 = mean(conjunto_2);

% Calculando las matrices de covarianza para cada conjunto
cov_con_1 = cov(conjunto_1);
cov_con_2 = cov(conjunto_2);

figure;
hold on;

% Graficando todos los puntos
scatter(conjunto_1(:,1), conjunto_1(:,2), 15,  'filled') % Conjunto 1
scatter(conjunto_2(:,1), conjunto_2(:,2), 15, 'filled') % Conjunto 2

% Graficando los centroides
% plot(centroide_1(1), centroide_1(2),'kx', 'MarkerSize', 12, 'LineWidth', 4);
% plot(centroide_2(1), centroide_2(2), 'kx', 'MarkerSize', 12, 'LineWidth', 4);

% Graficado las medias
plot(media_con_1(1), media_con_1(2),'bx', 'MarkerSize', 12, 'LineWidth', 1);
plot(media_con_2(1), media_con_2(2), 'rx', 'MarkerSize', 12, 'LineWidth', 1);

% Graficado círculos de radio = sigma
% viscircles(centroide_1, sigma, 'Color', 'k', 'LineWidth', 1); 
% viscircles(centroide_2, sigma, 'Color', 'k', 'LineWidth', 1); 

% Graficado círculos de media con sus propias varianzas
viscircles(media_con_1, cov_con_1(1,1), 'Color', 'b', 'LineWidth', 1, 'LineStyle', '--'); % Círculo azul
viscircles(media_con_2, cov_con_2(1,1), 'Color', 'r', 'LineWidth', 1, 'LineStyle', '--'); % Círculo rojo


legend('Conjunto 1', 'Conjunto 2', 'Media del Conjunto 1', 'Media del Conjunto 2');
xlabel('X'); ylabel('Y');
title('Distribuciones Gaussianas en ℝ^2');
axis equal;
grid on;
hold off;


% Mostrando resultados
disp('Media clase 1:'); disp(media_con_1);
disp('Matriz de Covarianza para la clase 1:'); disp(cov_con_1);
disp('Media clase 2:'); disp(media_con_2);
disp('Matriz de Covarianza para la clase 2:'); disp(cov_con_2);

% Calcular las distancias y contar las que son menores a la desviación
% estándar para el grupo 1
distancias = sqrt(sum((conjunto_1 - media_con_1).^2, 2)); % Distancia euclidiana
sigma1 = sqrt(cov_con_1(1,1));
cantidadMenores = sum(distancias < sigma1); % Contar las distancias menores a R1

% Mostrar el resultado
disp(['Cantidad de coordenadas menores a 1 Sigma para el Conjunto 1: ', num2str(cantidadMenores)]);