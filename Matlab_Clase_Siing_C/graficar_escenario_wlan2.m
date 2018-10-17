function graficar_escenario_wlan2(escenario)
figure(1);
% ======================================================================
img=imread('Quito.png'); K=0.15;
H=size(img,1); W=size(img,2);
image([0 W*K],[0 H*K], img);
% set(gca,'YDir','normal')%En caso de requerir invertir el eje y sus
% valores
axis([0 62 0 56]);
if length(escenario.R)==1
    escenario.R=escenario.xs*0+escenario.R;
end
hold on;
% =====================================================================
grid on;
hold on;
xc=cos(0:0.01:2*pi+0.01); yc=sin(0:0.01:2*pi+0.01);
M=length(escenario.xs); % Longitud de muestras de AP
N=length(escenario.x);  % Longitus de muestras de usuarios
% Graficar circunferencias de Cobertura de cada AP
for i=1:M
    z1=plot(xc*escenario.R(i)+escenario.xs(i), yc*escenario.R(i)+escenario.ys(i),'--r','linewidth',1);
    %fill(xc*escenario.R(i)+escenario.xs(i), yc*escenario.R(i)+escenario.ys(i),[0 0.92 0.98],'facealpha',0.1);
    text(escenario.xs(i), escenario.ys(i),sprintf('  \nAP%d',i),'fontsize',7); %Texto id
    for j=1:N
        if escenario.dist(i,j)<=escenario.R(i)
            z2=plot([escenario.xs(i) escenario.x(j)],[escenario.ys(i) escenario.y(j)],'-.b','linewidth',1);
        end
    end
end
z3=plot(escenario.x,escenario.y,'o','markerfacecolor',[0.84 0.38 0.85],'markeredgecolor','k','linewidth',1.15,'markersize',5);
hold on
z4=plot(escenario.xs,escenario.ys,'s','markerfacecolor',[1 0.4 0.2],'markeredgecolor',[0 1 0],'linewidth',1.15,'markersize',6);
hold off;
xlabel('Coordenadas en X','FontName','Times New Roman','FontUnits','points','FontSize',11,'FontWeight','normal','FontAngle','normal');
ylabel('Coordenadas en Y','FontName','Times New Roman','FontUnits','points','FontSize',11,'FontWeight','normal','FontAngle','normal');
leyenda=legend([z1 z2 z3 z4],'Cobertura','Enlaces Factibles','Usuarios','APs','Location','SW');
set(leyenda,'FontName','Times New Roman','FontUnits','points','FontSize',11,'FontWeight','normal','FontAngle','normal')
print -dpdf -r800 grafo1
print -depsc -r800 grafo1
%===================================================================================================================================
% Escenario Solución
%===================================================================================================================================
if isfield(escenario, 'sln')
    figure(2);
    img=imread('Quito.png'); K=0.15;
    H=size(img,1); W=size(img,2);
    image([0 W*K],[0 H*K], img);
    % set(gca,'YDir','normal')%En caso de requerir invertir el eje y sus
    % valores
    axis([0 62 0 56]); hold on;
    %==========================================================================
    grid on; hold on;
    xc=cos(0:0.01:2*pi+0.01); yc=sin(0:0.01:2*pi+0.01);
    M=length(escenario.xs(escenario.sln)); % Longitud de muestras de AP en la solución LPSolve
    N=length(escenario.x);  % Longitud de muestras de usuarios
    K=length(escenario.xs); % Longitud de muestras de AP
    % Graficar circunferencias de Cobertura de cada AP
    for k=1:K
        for i=1:M
            z5=plot(xc*escenario.R(k)+escenario.xs((escenario.sln(i))), yc*escenario.R(k)+escenario.ys((escenario.sln(i))),'--r','linewidth',1);
            hold on;
            %         z3=fill(escenario.R(k)*1.01*xc+escenario.xs((escenario.sln(i))),escenario.R(k)*1.01*yc+escenario.ys((escenario.sln(i))),[0.77 1 1],'facealpha',0.1);
            text(escenario.xs((escenario.sln(i))), escenario.ys((escenario.sln(i))),sprintf('       \n     AP%d',(escenario.sln(i))),'fontsize',7); %Texto id
            for j=1:N
                if escenario.dist(escenario.sln(i),j)<=escenario.R
                    z6=plot([escenario.xs((escenario.sln(i))) escenario.x(j)],[escenario.ys((escenario.sln(i))) escenario.y(j)],'-.b','linewidth',1);
                end
            end
        end
    end
    z7=plot(escenario.x,escenario.y,'o','markerfacecolor',[0.84 0.38 0.85],'markeredgecolor','k','linewidth',1.15,'markersize',5);
    hold on;
    z8=plot(escenario.xs(escenario.sln(:,1)),escenario.ys(escenario.sln(:,1)),'s','markerfacecolor',[1 0.4 0.2],'markeredgecolor',[0 1 0],'linewidth',1.45,'markersize',6);
    hold off;
end
xlabel('Coordenadas en X','FontName','Times New Roman','FontUnits','points','FontSize',11,'FontWeight','normal','FontAngle','normal');
ylabel('Coordenadas en Y','FontName','Times New Roman','FontUnits','points','FontSize',11,'FontWeight','normal','FontAngle','normal');
leyenda=legend([z5 z6 z7 z8],'Cobertura','Enlace Inalámbrico','Usuarios','APs','Location','SW');
set(leyenda,'FontName','Times New Roman','FontUnits','points','FontSize',11,'FontWeight','normal','FontAngle','normal')
print -dpdf -r800 grafo2
print -depsc -r800 grafo2