figure(1); plot(0,0); 
img=imread('Quito.png'); K=0.15;
H=size(img,1); W=size(img,2); 
image([0 W*K],[0 H*K], img);
% set(gca,'YDir','normal')
axis([0 62 0 56]);
x=[]; y=[];
boton=1;
while boton==1
    [xo,yo,boton]=ginput(1);
    x=[x xo]; y=[y yo];
    image([0 W*K],[0 H*K], img); hold on; 
    plot(x,y,'.'); grid on;
    axis([0 62 0 56]);
    title(sprintf('Van %d', length(x))); hold off;
end
fprintf('x=[');
for i=1:length(x)-1
    fprintf('%f, ',x(i));
end
fprintf('%f];\n', x(end));


fprintf('y=[');
for i=1:length(y)-1
    fprintf('%f, ',y(i));
end
fprintf('%f];\n', y(end));
