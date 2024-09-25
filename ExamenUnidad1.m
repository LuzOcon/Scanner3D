clc
 if ~isempty(instrfind)        %verifica conexiones al puerto serial
     fclose(instrfind);    
     delete(instrfind);        %cierra y elimina las conexiones abiertas
end

numDatos=1000;                 %número de elementos que tendra nuestro vector  
Puertoserial = 'COM5';         

L1 = 20;                       % Longitud del primer brazo
L2 = 20;                       % Longitud del segundo brazo
L3 = 19;                       % Longitud del tercer brazo
                     
x = zeros(1, numDatos);        %vectores de ceros
y = zeros(1, numDatos);
z = zeros(1, numDatos);

i=1; 
 
s = serial(Puertoserial);   
set(s, 'BaudRate', 9600);   
fopen(s);                   
disp('Presiona enter para continuar');   
pause();                                %pausa y espera a que el usuario presione cualquier tecla

while (i<numDatos) 
     datos = fscanf(s, '%f,%f,%f\n');  %espera una cadena de caracteres que comience con el carácter '$' y tenga 3 datos float
                      
     angulo1 = datos(1);                %ángulos recibidos desde arduino
     angulo2 = datos(2);
     angulo3 = datos(3);
     
c1=cosd(angulo1);                        %operaciones cos y seno de cada angulo 
s1=sind(angulo1);
c2=cosd(angulo2);
s2=sind(angulo2);
c3=cosd(angulo3);
s3=sind(angulo3);
c90=cosd(90);
s90=sind(90);

%%Brazo 1
RT1z = [c1 -s1 0 0;                     %matriz transformacion de rotacion y traslacion en z 
        s1 c1 0 0;
        0 0 1 L1;
        0 0 0 1];    
 
 R1x = [1 0 0 0;                        %matriz rotacion en x 90 grados
       0 c90 -s90 0;
       0 s90  c90 0;
       0 0 0 1];
   
 M1= RT1z*R1x;                      

% Brazo 2
R2z = [c2 -s2 0 0;                      %matriz de rotacion en z
        s2 c2 0 0;
        0 0 1 0;
        0 0 0 1];
   
T2x = [1 0 0 L2;                        %matriz traslacion en x
       0 1 0 0;
       0 0 1 0;
       0 0 0 1];
   
M2 = R2z * T2x;

% Brazo 3
R3z = [c3 -s3 0 0;                      %matriz rotacion en z
        s3 c3 0 0;
        0 0 1 0;
        0 0 0 1];
   
T3x = [1 0 0 L3;                        %matriz traslacion en x
       0 1 0 0;
       0 0 1 0;
      0 0 0 1];
  
M3 = R3z * T3x;


    M = M1 * M2 * M3 *[0; 0; 0; 1];    %obtenemos el punto final despues de las transformaciones
    MF=M;
    
x(i)=MF(1);                            %almacenamos los datos para visualizarlos
y(i)=MF(2);
z(i)=MF(3);

figure(1)
plot3(x,y,z)                           %grafica x y z
drawnow;                               %actualiza la grafica
     
     i=i+1;                            %aumenta el bucle
        
end
figure(2)
pcshow([x(:),y(:),z(:)],[1, 0, 0.5]);  %grafica nube de datos 
set(gca,'color','w');

fclose(s);                             %cierra la conexion
delete(s);
clear s;
