% Creado por: MSc. Esteban Inga Ortega
% 29-10-2017
% Dimensionamiento de redes inalambricas cosiderando restricciones de
% capacidad cobertura e interferencia, se dispone de numero k de canales 
% para evitar la interferencia
% Solver empleado LPSolve
%==========================================================================
clc; clear all; close all
warning('off','all');
load escenario3.mat
fid = fopen('cob_cap_inter.csv', 'r');
tline = fgetl(fid); 
tline = fgetl(fid);
ind=1;
%Reading of the results from LPSOLVE
while 1
    tline = fgetl(fid);
    if ~ischar(tline),
        break,
    end
    array=split(tline,';');% Símbolo de Tabulación
    if str2num(array{end})>0
        data{ind}=array{1};
        value(ind)=str2num(array{end});
        ind=ind+1;
    end
end
fclose(fid);
%====================================================================
for i=1:length(value)
    temp=split(data{i},'_');% Símbolo de división luego de la letra "X"
    n1=str2num(char(temp(2)));
    n2=str2num(char(temp(3)));
    sln(i,:)=[n1 n2];
end
load escenario3;
escenario.sln=sln;
graficar_escenario_wlan2(escenario);

