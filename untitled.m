% Cargar el dataset Iris
load fisheriris
X = meas;            % 150x4 matriz de características
Y = species;         % 150x1 celda con etiquetas de clase

gscatter(X(:,1), X(:,2), Y, 'rgb', 'o', 8)
xlabel('Sepal Length')
ylabel('Sepal Width')
title('Iris Dataset - Sepal Length vs Width')
legend('Location', 'best')

% Convertir las clases a grupos numéricos para scattermatrix
G = grp2idx(Y);

% Crear matriz de dispersión
figure
gplotmatrix(X, [], Y, 'rgb', '.', [], 'on', '', {'Sepal L','Sepal W','Petal L','Petal W'})
title('Matriz de Dispersión del Dataset Iris')

figure
scatter3(X(:,1), X(:,2), X(:,3), 50, G, 'filled')
xlabel('Sepal Length')
ylabel('Sepal Width')
zlabel('Petal Length')
title('Iris Dataset - 3D Visualization')
grid on
legend(unique(Y), 'Location', 'best')

[coeff, score, ~] = pca(X);
figure
gscatter(score(:,1), score(:,2), Y, 'rgb', 'o', 8)
xlabel('PC1')
ylabel('PC2')
title('PCA del Iris Dataset')
legend('Location', 'best')