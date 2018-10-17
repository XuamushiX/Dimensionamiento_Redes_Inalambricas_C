% Creado por: MSc. Esteban Inga Ortega
% 29-10-2017
% Dimensionamiento de redes inalambricas cosiderando restricciones de
% capacidad cobertura e interferencia, se dispone de numero k de canales 
% para evitar la interferencia
% Solver empleado LPSolve
%==========================================================================
clc; clear all; close all;
warning('off','all');
fid = fopen('cob_cap_inter.lp', 'w');
Cap=8;  %Capacidad del AP
Porc=0.90;   %Porcentaje de usuarios a cubrir
K=4; %K representa el nu½mero de canales disponibles.
flag=0; num=0;
R=5;
x=[24.9285714285714 29.6428571428571 24.5000000000000 24.0714285714286 24.9285714285714 34.2142857142857 30.3571428571429 25.7857142857143 25.3571428571429 30.3571428571429 30.3571428571429 34.7857142857143 34.9285714285714 33.6428571428571 30.0714285714286 34.2142857142857];
y=[20.4897959183673 21.6326530612245 21.7959183673469 23.2653061224490 24.8979591836735 23.5918367346939 19.6734693877551 19.0204081632653 17.5510204081633 18.3673469387755 16.5714285714286 20.4897959183673 19.3469387755102 25.2244897959184 24.2448979591837 22.1224489795918];
N=length(x);
xs=[24.2142857142857 21.0714285714286 25.2142857142857 29.3571428571429 34.3571428571429 37.7857142857143 38.3571428571429 39.3571428571429 33.6428571428571 28.5000000000000];
ys=[30.9387755102041 31.9183673469388 32.5714285714286 33.3877551020408 30.7755102040816 28.0000000000000 21.9591836734694 19.0204081632653 18.8571428571428 22.7755102040816];
M=length(xs);
Rs=R*ones(M,1);
Ds=2*Rs;        %Distancia de interferencia
M=length(xs);
for i=1:M
    for j=1:N
        dist(i,j)=sqrt((xs(i)-x(j))^2+(ys(i)-y(j))^2);
    end
end
for i=1:M
    for k=1:M
        distAP(i,k)=sqrt((xs(i)-xs(k))^2+(ys(i)-ys(k))^2);
    end
end
escenario.xs=xs; escenario.ys=ys; escenario.x=x; escenario.y=y; escenario.R=Rs; escenario.dist=dist;
graficar_escenario_wlan3(escenario);
clc
fprintf(fid, 'min: X1');
for j=2:M
    fprintf(fid, '+X%d',j);
end
fprintf(fid, ';\n');
%1. RESTRICCION DEL NUMERO DE USUARIOS CONECTADOS
fprintf(fid, 'CONECTIVIDAD: Y1');
for j=2:N
    fprintf(fid, '+Y%d',j);
end
fprintf(fid, '>=%f;\n',Porc*N);
%2. RESTRICCION DE QUE CADA USUARIO ESTA CONECTADO SI SE CONECTA A ALGUN AP EN
%ALGUN CANAL
for j=1:N
    %Ecuacion de restriccion de conexion de cada usuario
    fprintf(fid, 'CONECTIVIDAD_USUARIO%d: Y%d=',j,j);
    for i=1:M
        for k=1:K
            fprintf(fid, '+X_%d_%d_%d',i,k,j);
        end
    end
    fprintf(fid, ';\n');
end
%3. RESTRICCION DE CAPACIDAD DE LAS ESTACIONES BASE
for i=1:M
    for k=1:K
        fprintf(fid, 'CAPACIDAD_AP_%d_%d: ',i,k);
        for j=1:N
            fprintf(fid, '+X_%d_%d_%d',i,k,j);
        end
        fprintf(fid, '<=%f * X_%d_%d;\n',Cap,i,k);
    end
end
%4. RESTRICCION DE ACTIVIDAD DE LAS ESTACIONES BASE
for i=1:M
    for k=1:K
        fprintf(fid, 'ACTIVIDAD_AP_%d_CH%d: X_%d_%d<=X%d;\n',i,k,i,k,i);
    end
end
%5. RESTRICCION DE CONECTIVIDAD SI EXISTE COBERTURA Y ACTIVIDAD EN EL SITIO i
for i=1:M
    for k=1:K
        for j=1:N
            if dist(i,j)<=Rs(i)
                fprintf(fid, 'REST_%d_%d_%d: X_%d_%d_%d<=X_%d_%d;\n',i,k,j,i,k,j,i,k);
            else
                fprintf(fid, 'REST_%d_%d_%d: X_%d_%d_%d<=0;\n',i,k,j,i,k,j);
            end
        end
    end
end
%6. RESTRICCION DE INTERFERENCIA ENTRE LOS AP MUY CERCANOS ENTRE SI
for k=1:K
    for i=1:(M-1)
        for j=(i+1):M
            if distAP(i,j)<=max(Ds(i),Ds(j))    %Los dos AP no se pueden encender simultï¿½neamente.
                fprintf(fid, 'REST_INTERF%d_%d_CH%d: X_%d_%d+X_%d_%d<=1;\n',i,j,k,i,k,j,k);
            end
        end
    end
end
fprintf(fid, 'binary ');
for i=1:M
    for j=1:N
        for k=1:N
            fprintf(fid, 'X_%d_%d_%d, ',i,j,k);
        end
    end
end
for i=1:N
    fprintf(fid, 'Y%d, ',i);
end
for i=1:M
    for k=1:K
        fprintf(fid, 'X_%d_%d, ',i,k);
    end
end
for i=1:(M-1)
    fprintf(fid, 'X%d, ',i);
end
fprintf(fid, 'X%d;\n',M);
fclose(fid);
save escenario3.mat escenario