clear all, close all, clc;

% Defina numero de imagenes y numero de puntos
sequence_length = 4;
points_number = 12;

%%--------------------------------------------------------------------
% Importe la informacion de los puntos de las imagenes de acuerdo al formato dado por el archivo getPoints.m

%---- Escriba aqui su codigo. El vector de celdas 'ip' debe contener la informacion
ip = getPoints(sequence_length, points_number);

% Remover media de los datos
ipnorm = cell(1,sequence_length);
af = ones(1,sequence_length);
bf = ones(1,sequence_length);
D = [];

for i = 1 : sequence_length
    af(i) = mean(ip{i}(:,1));
    bf(i) = mean(ip{i}(:,2));
    ipnorm{i} = ip{i}(:,:)' - (diag(mean(ip{i}(:,:)',2))*ones(2,points_number));
    D = [D; ipnorm{i}];
end

%% -------------------------------------------------
% Hacer factorizacion de la matriz de datos D utilizando singular value decomposition

%---- Escriba aqui su codigo. Las matrices A0 y P0 deben ser el resultado de la factorizacion,
% donde D0=A0P0 es la matriz de rango 3 mas cercana a D de acuerdo a la norma Frobenius
clc
% Descomposición de Valores Singulares (Función de Matlab)
[T,W,Q] = svd(D);
T3 = T(:,1:3); % Primeras 3 Columnas de T (k = 3)
Q3 = Q(:,1:3); % Primeras 3 Columnas de Q (k = 3)
W3 = W(1:3,1:3); % Matriz diagonal con los 3 primeros valores de W

% min ||D - A_star*X_star||^2 s.a. rank(A_star*X_star) = 3
A_star = T3*sqrtm(W3);
X_star = sqrtm(W3)*Q3';

% Utilizando la nomenclatura indicada
A0 = A_star;
P0 = X_star;

%% ----------------------------------------------------- 
% Hacer el Euclidean upgrade. La estructura resultante se llama 'invCP0'

dFdD = [];
nondFdD = [];

for k = 1 : sequence_length
    a11 = A0(2*k-1,1);
    a12 = A0(2*k-1,2);
    a13 = A0(2*k-1,3);
    a21 = A0(2*k,1);
    a22 = A0(2*k,2);
    a23 = A0(2*k,3);
    
    dFdD = [dFdD; a11*a21 a11*a22+a12*a21 a11*a23+a13*a21  a12*a22 a12*a23+a13*a22 a13*a23];
    nondFdD = [nondFdD; a11*a21 a11*a22+a12*a21 a11*a23+a13*a21  a12*a22 a12*a23+a13*a22 a13*a23];
    temp1 = [ a11*a11 a11*a12+a12*a11 a11*a13+a13*a11  a12*a12 a12*a13+a13*a12 a13*a13  ];
    temp2 = [ a21*a21 a21*a22+a22*a21 a21*a23+a23*a21  a22*a22 a22*a23+a23*a22 a23*a23  ];
    
    a1k(:,k) =  [a11 a12 a13]';
    a2k(:,k) =  [a21 a22 a23]';
    
    dFdD = [dFdD; temp1-temp2];
    nondFdD = [nondFdD; temp1; temp2];
end

ooi = [0;1;1];
V9 = inv((nondFdD')*nondFdD)*(nondFdD')*(repmat(ooi,sequence_length,1)) ;
CCT = [ V9(1) V9(2) V9(3); V9(2) V9(4) V9(5); V9(3) V9(5) V9(6);]';
[U,S,V] = svd(CCT);
[aa,bb] = eig(CCT);

if(sum(diag(S)<=0)>0||trace(CCT)<0||sum(diag(bb)<=0)>0)
    posi = 0;
    Cli = U*sqrt(S);
else
    posi = 1;
    Cli = chol(CCT);
end
Cli = Cli';

c11 = Cli(1,1);
c12 = Cli(1,2);
c13 = Cli(1,3);
c21 = Cli(2,1);
c22 = Cli(2,2);
c23 = Cli(2,3);
c31 = Cli(3,1);
c32 = Cli(3,2);
c33 = Cli(3,3);
C = [c11 c12 c13; c21 c22 c23; c31 c32 c33; ];


iteration_number = 100;
for nonl_times = 1 : iteration_number
    dDdC = [];
    dDdC = [dDdC; 2*c11 2*c12  2*c13 0 0 0 0 0 0];    % dD1/dC
    dDdC = [dDdC; c21 c22 c23  c11 c12 c13 0 0 0];    % dD2/dC
    dDdC = [dDdC; c31 c32 c33  0 0 0 c11 c12 c13];    % dD3/dC
    dDdC = [dDdC; 0 0 0 2*c21 2*c22 2*c23 0 0 0];     % dD4/dC
    dDdC = [dDdC; 0 0 0 c31 c32 c33  c21 c22 c23];    % dD5/dC
    dDdC = [dDdC; 0 0 0 0 0 0 2*c31 2*c32  2*c33 ];   % dD6/dC
    
    df = nondFdD * dDdC;
    
    fx = [];
    for k = 1 : sequence_length
        fx = [fx;  a1k(:,k)'*C*C'*a2k(:,k);  (a1k(:,k)'*C*C'*a1k(:,k))-1; (a2k(:,k)'*C*C'*a2k(:,k))-1];
    end
    
    norm(fx);
    beta = 10^2;   % step size = 1/beta;
    delta_k = beta * eye(size(df'*df,1));
    dx = -inv(df'*df + delta_k )*df'*fx/1;
    
    c11 = c11 + dx(1,1);
    c12 = c12 + dx(2,1);
    c13 = c13 + dx(3,1);
    c21 = c21 + dx(4,1);
    c22 = c22 + dx(5,1);
    c23 = c23 + dx(6,1);
    c31 = c31 + dx(7,1);
    c32 = c32 + dx(8,1);
    c33 = c33 + dx(9,1);
    C = [c11 c12 c13; c21 c22 c23; c31 c32 c33; ];
end

InvCP0 = inv(C)*P0;

Ahat = cell(1,sequence_length);
for i = 1: sequence_length
    a1 = A0(2*i-1,:)*C;
    a2 = A0(2*i,:)*C;
    a1 = a1/norm(a1);
    a2 = a2/norm(a2);
    Ahat{i} = [ a1; a2; cross(a1, a2)];
end
A1c = Ahat{1};
InvCP0 = A1c*InvCP0;
for i = 1: sequence_length
    %Ahat{i} = Ahat{i}*inv(A1c);
    Ahat{i} = Ahat{i}/A1c;
    a1 = Ahat{i}(1,:)/norm(Ahat{i}(1,:));
    a2 = Ahat{i}(2,:)/norm(Ahat{i}(2,:));
    Ahat{i} = [ a1; a2; cross(a1, a2)];
end

%% ---------------------------------------
% Grafique la reconstriccion 3D 
close all, clc
%---- Escriba aqui su codigo. Grafique la estructura antes del Euclidean upgrade (es decir, P0),
% y la estructura despues del Euclidean upgrade (es decir, invCP0).

labels = cellstr(num2str([1:12]'));

x = P0(1,:);
y = P0(2,:);
z = P0(3,:);

xe = InvCP0(1,:); 
ye = -InvCP0(2,:);
ze = InvCP0(3,:);

figure
text(x, y, z, labels)
title('Estructura antes del Euclidean upgrade')
hold on
for i = 1: points_number-1
    plot3(x(1,i:i+1), y(1,i:i+1), z(1,i:i+1), 'blue');
    hold on
end
plot3([x(1,1),x(1,11)], [y(1,1),y(1,11)], [z(1,1),z(1,11)], 'blue' );
plot3([x(1,1),x(1,4)], [y(1,1),y(1,4)], [z(1,1),z(1,4)], 'blue');
plot3([x(1,2),x(1,10)], [y(1,2),y(1,10)], [z(1,2),z(1,10)], 'blue');
plot3([x(1,6),x(1,12)], [y(1,6),y(1,12)], [z(1,6),z(1,12)], 'blue');
plot3([x(1,8),x(1,12)], [y(1,8),y(1,12)], [z(1,8),z(1,12)], 'blue');

figure
text(xe, ye, ze, labels)
title('Estructura despues del Euclidean upgrade')
hold on
for i = 1: points_number-1
    plot3(xe(1,i:i+1), ye(1,i:i+1), ze(1,i:i+1), 'blue');
    hold on
end
plot3([xe(1,1),xe(1,11)], [ye(1,1),ye(1,11)], [ze(1,1),ze(1,11)], 'blue' );
plot3([xe(1,1),xe(1,4)] , [ye(1,1),ye(1,4)], [ze(1,1),ze(1,4)], 'blue');
plot3([xe(1,2),xe(1,10)], [ye(1,2),ye(1,10)], [ze(1,2),ze(1,10)], 'blue');
plot3([xe(1,6),xe(1,12)], [ye(1,6),ye(1,12)], [ze(1,6),ze(1,12)], 'blue');
plot3([xe(1,8),xe(1,12)], [ye(1,8),ye(1,12)], [ze(1,8),ze(1,12)], 'blue');


