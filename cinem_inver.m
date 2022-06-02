%Elaborado por:
%   Javier Caicedo Pedrozo.
%   Julián Luna.
%% Cinemática inversa del robot Phantom X:

%Definimos la longitud de los eslabones.
l = [14.5, 10.7, 10.7, 9]; 
% Definicion del robot RTB
L(1) = Link('revolute','alpha',pi/2,'a',0,   'd',l(1),'offset',0,   'qlim',[-3*pi/4 3*pi/4]);
L(2) = Link('revolute','alpha',0,   'a',l(2),'d',0,   'offset',pi/2,'qlim',[-3*pi/4 3*pi/4]);
L(3) = Link('revolute','alpha',0,   'a',l(3),'d',0,   'offset',0,   'qlim',[-3*pi/4 3*pi/4]);
L(4) = Link('revolute','alpha',0,   'a',0,   'd',0,   'offset',0,   'qlim',[-3*pi/4 3*pi/4]);
PhantomX = SerialLink(L,'name','Px');
x=8.166;
y=19.715;
z=16.095;
pos = [1 0 1 x; 0 -1 1 y; 1 0 1 z; 0 0 0 1];
%PhantomX.tool = pos;
%% Determinamos la cinemática inversa

%Definimos la pose de la herramienta.

% Desacople
    T = pos;
    Posw = T(1:3,4) - l(4)*T(1:3,3); % MTH Wrist

% Solucion q1
    q1 = atan2(Posw(2),Posw(1));
    rad2deg(q1);
% Solución 2R
    h = Posw(3) - l(1);
    r = sqrt(Posw(1)^2 + Posw(2)^2);
% Codo abajo
    the3 = acos((r^2+h^2-l(2)^2-l(3)^2)/(2*l(2)*l(3)));
    the2 = atan2(h,r) - atan2(l(3)*sin(the3),l(2)+l(3)*cos(the3));

    q2d = -(pi/2-the2);
    q3d = the3;
% Codo arriba
    the2 = atan2(h,r) + atan2(l(3)*sin(the3),l(2)+l(3)*cos(the3));
    q2u = -(pi/2-the2);
    q3u = -the3;
% Solucion de q4
    Rp = (rotz(q1))'*T(1:3,1:3);
    pitch = atan2(Rp(3,1),Rp(1,1));
    
    q4d = pitch - q2d - q3d;
    q4u = pitch - q2u - q3u;
    if q4u>(7/6)*pi
        q4u = q4u-2*pi;
    end
    q_out=zeros(2,4);
    q_out(1,1:4) = [q1 q2u q3u q4u]; %solución codo arriba.
    q_out(2,1:4) = [q1 q2d q3d q4d]; %solución codo abajo.

    disp('Àngulos de salida de la cinemática inversa');
    disp('Solución codo arriba')
    disp(q_out(1,:))
    disp('Solución codo abajo')
    disp(q_out(2,:))

    %Graficamos el robot en los ángulos obtenidos.
    ws = [-50 50];
    %PhantomX.tool = pos;
    %Graficaciòn de la solución codo arriba.
    PhantomX.plot(q_out(1,:),'notiles','noname');
    hold on
    trplot(eye(4),'rgb','arrow','length',15,'frame','0')
    axis([repmat(ws,1,2) 0 60])
    PhantomX.teach()