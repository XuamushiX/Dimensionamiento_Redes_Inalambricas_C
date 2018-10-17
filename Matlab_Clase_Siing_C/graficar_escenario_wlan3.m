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
%=====================================================================
grid on;
% Graficar circunferencias de Cobertura de cada AP
xc=cos(0:0.01:2*pi+0.01); yc=sin(0:0.01:2*pi+0.01);
M=length(escenario.xs); % Longitud de muestras de AP
N=length(escenario.x);  % Longitus de muestras de usuarios
for i=1:M
    z1=plot(xc*escenario.R(i)+escenario.xs(i), yc*escenario.R(i)+escenario.ys(i),'--m','linewidth',1);
    %fill(xc*escenario.R(i)+escenario.xs(i), yc*escenario.R(i)+escenario.ys(i),[0 0.92 0.98],'facealpha',0.1);
    text(escenario.xs(i), escenario.ys(i),sprintf('  AP%d',i),'fontsize',7); %Texto id
    for j=1:N
        if escenario.dist(i,j)<=escenario.R(i)
            z2=plot([escenario.xs(i) escenario.x(j)],[escenario.ys(i) escenario.y(j)],'-.','color',[0.8 0.8 0.8],'linewidth',1);
        end
    end
end
z3=plot(escenario.x,escenario.y,'.r','markersize',15);
hold on
z4=plot(escenario.xs,escenario.ys,'s','markerfacecolor',[1 0.4 0.2],'markeredgecolor',[0 1 0],'linewidth',1.45,'markersize',6);
hold off;
xlabel('Coordenadas en X','FontName','Times New Roman','FontUnits','points','FontSize',11,'FontWeight','normal','FontAngle','normal');
ylabel('Coordenadas en Y','FontName','Times New Roman','FontUnits','points','FontSize',11,'FontWeight','normal','FontAngle','normal');
leyenda=legend([z1 z2 z3 z4],'Radio de Cobertura','Enlaces Factibles','Usuarios','APs','Location','SO');
set(leyenda,'FontName','Times New Roman','FontUnits','points','FontSize',11,'FontWeight','normal','FontAngle','normal')
print -dpdf -r500 grafo1
print -depsc -r500 grafo1
