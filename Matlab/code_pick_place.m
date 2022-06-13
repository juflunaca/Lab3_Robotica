%Implementación Pick and Place
%Elaborado por:
%Javier Caicedo Pedrozo
%Julián Luna.

%Definimos la longitud de los eslabones:
l= [14.5, 10.7, 10.7, 9]; % Longitudes eslabones

rosinit; %Conexion con nodo maestro. Correr solo una vez despues de iniciar el .launch apropiado.
motorSvcClient = rossvcclient('/dynamixel_workbench/dynamixel_command'); %Creación de cliente de pose y posición
motorCommandMsg = rosmessage(motorSvcClient); %Creación de mensaje
% Definicion del robot RTB
L(1) = Link('revolute','alpha',pi/2,'a',0,   'd',l(1),'offset',0,   'qlim',[-3*pi/4 3*pi/4]);
L(2) = Link('revolute','alpha',0,   'a',l(2),'d',0,   'offset',pi/2,'qlim',[-3*pi/4 3*pi/4]);
L(3) = Link('revolute','alpha',0,   'a',l(3),'d',0,   'offset',0,   'qlim',[-3*pi/4 3*pi/4]);
L(4) = Link('revolute','alpha',0,   'a',0,   'd',0,   'offset',0,   'qlim',[-3*pi/4 3*pi/4]);
PhantomX = SerialLink(L,'name','Px');
PhantomX.tool = [0 0 1 l(4); -1 0 0 0; 0 -1 0 0; 0 0 0 1];

%%
ws = [-50 50];
n=15;%número de puntos para definir la trayectoria.
inic = transl(0,0,sum(l)); %home.

MTH_L0 = transl(0,-l(1),l(1))*trotx(-pi)*trotz(-pi/2); %MTH posicion izq inicial
MTH_L1 = transl(0,-l(1),l(1)/3)*trotx(-pi)*trotz(-pi/2); %MTH posicion iz final
MTH_C0 = transl(l(1),0,l(1))*troty(pi); %MTH posición centro inicial
MTH_C1 = transl(l(1),0,l(1)/2)*troty(pi); %MTH posición ccentro final
MTH_R0 = transl(0,l(1),l(1))*trotx(-pi)*trotz(pi/2); %MTH posición der inicial
MTH_R1 = transl(0,l(1),l(1)/3)*trotx(-pi)*trotz(pi/2); %MTH posicion de final


%Definimos el vector de trayectorias.
tray=[MTH_L0 MTH_L1 MTH_C0 MTH_C1 MTH_R0 MTH_R1];
Tray_INR0 = ctraj(inic,MTH_R0,n); %Pos home a der inicial.
Tray_R1R0 = ctraj(MTH_R0,MTH_R1,n); %Pos der final a inicial.
Tray_R1C0 = ctraj(MTH_R1,MTH_C0,n); %Pos der final a Centro inicial.
Tray_C0C1 = ctraj(MTH_C0,MTH_C1,n); %Pos centro inicial a centro final.
Tray_C1L0 = ctraj(MTH_C1,MTH_L0,n); %Pos centro final a izquierda inicial.
Tray_L0L1 = ctraj(MTH_L0,MTH_L1,n); %Pos izq inicial a izquierda final.
Tray_L1C0 = ctraj(MTH_L1,MTH_C0,n); %Pos izq inicial a centro inicial.
Tray_C1C0 = ctraj(MTH_C1,MTH_C0,n); %Pos centro final a centro inicial.
Tray_C1IN  = ctraj(MTH_C1,inic,n); %Pos centro final a home.
num_tray=9;

%%
    for h=1:num_tray
        switch (h)
            case 1
                for g=1:n
                    move_tray_n(Tray_INR0(:,:,g),g);
                end

            case 2
                for g=1:n
                    move_tray_2n(Tray_R1R0(:,:,g),g);
                end
            case 3
                for g=1:n
                    move_tray_n(Tray_R0C0(:,:,g),g);
                end
            case 4
                for g=1:n
                    move_tray_2n(Tray_C0C1(:,:,g),g);
                end
            case 5
                for g=1:n
                    move_tray_n(Tray_C1L0(:,:,g),g);
                end
            case 6
                for g=1:n
                    move_tray_2n(Tray_L0L1(:,:,g),g);
                end
            case 7
                for g=1:n
                    move_tray_n(Tray_L1C0(:,:,g),g);
                end
            case 8
                for g=1:n
                    move_tray_2n(Tray_C0C1(:,:,g),g);
                end
%                 motorCommandMsg.AddrName="Goal_Position";
%                 motorCommandMsg.Id=5;
            case 9
                for g=1:n
                    move_tray(Tray_C0IN(:,:,g),g);
                end
            otherwise
                break;
        end
   
    end


hold on
trplot(eye(4),'rgb','arrow','frame',num2str(1),'length',15)
axis([repmat(ws,1,2) 0 60])

function move_tray_n(tray_matrix,p)
    
    motorCommandMsg.AddrName="Goal_Position";
    motorCommandMsg.Id=5;
    motorCommandMsg.Value=round(mapfun(50,-150,150,0,1023));
    call(motorSvcClient,motorCommandMsg);
    pause(0.01)
    qinv = rad2deg(cin_Inv(tray_matrix(:,:,p)));
    PhantomX.plot(qinv(1,:),'notiles','noname')
        for k=1:length(qinv(1,:))
            motorCommandMsg.AddrName="Goal_Position";
            motorCommandMsg.Id=k;
            motorCommandMsg.Value=round(mapfun(qinv(1,k),-150,150,0,1023));
            call(motorSvcClient,motorCommandMsg);
            pause(0.03);
        end
end

function move_tray_2n(tray_matrix,p)
    qinv = rad2deg(cin_Inv(tray_matrix(:,:,p)));
    PhantomX.plot(qinv(1,:),'notiles','noname')
        for k=1:length(qinv(1,:))
            motorCommandMsg.AddrName="Goal_Position";
            motorCommandMsg.Id=k;
            motorCommandMsg.Value=round(mapfun(qinv(1,k),-150,150,0,1023));
            call(motorSvcClient,motorCommandMsg);
            pause(0.03);
        end
end