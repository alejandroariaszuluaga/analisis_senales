function [norma] = frob_norm(h_comps) 
    % Definir Kernel cuya segunda fila son ceros
    % Se reciben solo los 6 parámetros faltantes
    h = [h_comps(1), h_comps(2), h_comps(3); 0, 0, 0; h_comps(4), h_comps(5), h_comps(6)];
    % Cargar matriz U
    U=imread('ladron.jpg');
    U=double(U)/256; % Valor de pixeles queda entre 0 y 1
    % Cargar matriz V
    V=imread('ladronborroso.jpg');
    V=double(V)/256; % Valor de pixeles queda entre 0 y 1
    % Filtrar
    H_U = imfilter(U, h);
    % Norma frobenius
    norma = norm(V-H_U, 'fro')^2;
end

