function cargasLineales()
    % Proyecto Final
    
    % Hecho por:
    % David Josu� Marcial Quero 
    % Diego Solis Higuera 
    % Carlos Augusto Pluma Seda 
    
    close all; 
    clc; % Se limpia la ventana de comandos y se cierran cualquier otro figure que se ten�a previamente
    
    [nPuntos, minX, maxX, minY, maxY, anchoC, xCargas, yCargas, k, cargasFinales, eleccionPosicion] = variablesIniciales(); %Funci�n que sirve para 
    % obtener los valores iniciales seg�n los inputs del usuario.
    
    [campoElectricoX, campoElectricoY, xPuntosMalla,yPuntosMalla] = ...
    puntosCampoElectrico(nPuntos, minX, maxX, minY, maxY); % Funci�n que sirve para crear los puntos que representaran al campo el�ctrico
    
    [campoElectricoX, campoElectricoY, magnitudCampoETotal] = obtenerCampoElectrico...
    (xPuntosMalla, yPuntosMalla, xCargas, yCargas, k, campoElectricoX, campoElectricoY, cargasFinales, eleccionPosicion); %Funci�n que sirve para 
    % calcular los valores del campo el�ctrico
    
    graficaCampoElectrico(xPuntosMalla, yPuntosMalla, campoElectricoX,campoElectricoY, magnitudCampoETotal, anchoC, xCargas, yCargas, cargasFinales, minX, maxX, minY, maxY, eleccionPosicion); 
    % Funci�n que sirve para graficar el campo el�ctrico y el dipolo el�ctrico.
end

function [nPuntos, minX, maxX, minY, maxY, anchoC, xCargas, yCargas, k, cargasFinales, eleccionPosicion] = variablesIniciales()
    nPuntos = 50; % Puntos para representar el campo el�ctrico
    
    % Se recibe informaci�n primoridal del usuario como la magnitud de las
    %cargas, la cantidad de cargas y la posici�n que ocupar�n
    fprintf("Al ser dos cargas lineales (misma magnitud de carga el�ctrica pero de signo opuesto), solo es necesario ingresar un numero \n")
    carga = input("Ingrese la magnitud de las cargas (un numero positivo) (C): "); %Se ingresa la magnitud de las cargas lineales
    % Ingresa la posici�n de las cargas de l�nea
    eleccionPosicion = input("Ingrese el n�mero de la opci�n correspondiente de la representaci�n de los grupos de cargas que desea: 1) Vertical 2) Horizontal: "); %Se
    
    % El usuario ingresar� la distnacia que habr� entre los dos grupos de cargas
    dis = ((input("Ingrese la distnacia entre las dos cargas lineales (m): "))/2); %Distancia entre las cargas lineales
    lonCargaPos = input("Ingrese la longitud que tendr� la carga lineal positiva (m): "); %Longitud de la carga lineal positiva
    lonCargaNeg = input("Ingrese la longitud que tendr� la carga lineal negativa (m): "); %Longitud de la carga lineal negativa
    
    % Se calculan las coordenadas de los extremos de las cargas de l�nea
    disPos1 = (lonCargaPos)/-2; 
    disPos2 = (lonCargaPos)/2;
    disNeg1 = (lonCargaNeg)/-2;
    disNeg2 = (lonCargaNeg)/2;
    
    % Condicionales para saber en qu� posici�n se desea tener las cargas positivas y negativas
    if eleccionPosicion == 1
        posicion = input("�En qu� posici�n desea que est�n las cargas positivas? (Ingrese el n�mero de la opci�n correspondiente) 1) Izquierda 2) Derecha: ");
        yCargas = [disPos1, disPos2; disNeg1, disNeg2];%Valor de las posiciones de las cargas lineales en "Y"
        xCargas = [-dis,dis]; % Valor de las posiciones de las cargas lineales en "X"
        if posicion == 1
            cargasFinales = [carga, -carga]; % Son dos cargas de diferente signo
        elseif posicion == 2
            cargasFinales = [-carga, carga]; % Son dos cargas de diferente signo
        end
    elseif eleccionPosicion == 2
        posicion = input("�En qu� posici�n desea que est�n las cargas positivas? (Ingrese el n�mero de la opci�n correspondiente) 1) Abajo 2) Arriba: ");
        xCargas = [disPos1, disPos2; disNeg1, disNeg2];
        yCargas = [-dis,dis];
        if posicion == 1
            cargasFinales = [carga, -carga]; % Son dos cargas de diferente signo
        elseif posicion == 2
            cargasFinales = [-carga, carga]; % Son dos cargas de diferente signo
        end
    end
   
    % Determinar la distancia m�s grande entre las cargas para establecer
    %los l�mites del campo el�ctrico y al mismo tiempo determina la
    %distancia m�s corta para saber el tama�o m�ximo que pueden tener el
    %ancho de los rect�ngulos que representar�n a las cargas lineales
    if dis >= disPos2 && dis >= disNeg2
        distancia = dis;
        if disPos2 > disNeg2
            rango = disNeg2;
        else
            rango = disPos2;
        end
    elseif disPos2 >= dis && disPos2 >= disNeg2
        distancia = disPos2;
        if dis > disNeg2
            rango = disNeg2;
        else
            rango = dis;
        end
    elseif disNeg2 >= dis && disNeg2 >= disPos2
        distancia = disNeg2;
        if dis > disPos2
            rango = disPos2;
        else
            rango = dis;
        end
    end
    
    anchoC = rango / 12; % Radio de la carga
    
    maxX = distancia + (distancia/3);
    minX = -distancia - (distancia/3); % L�mites del campo el�ctrico en X
    maxY = distancia + (distancia/3);
    minY = -distancia - (distancia/3); % L�mites del campo el�ctrico en Y
    
    eps = 8.854e-12; % C�lculo del valor de la constante el�ctrica en el vac�o
    k = 1/(4*pi*eps);
end

function [campoElectricoX, campoElectricoY, xPuntosMalla,yPuntosMalla] = ...
    puntosCampoElectrico(nPuntos, minX, maxX, minY, maxY)

    % Definir espacio para guardar campo electrico en los componentes x y y
    campoElectricoX = zeros(nPuntos);
    campoElectricoY = zeros(nPuntos);

    % Creamos vectores para trabajar con el meshgrid
    X = linspace(minX,maxX,nPuntos);
    Y = linspace(minY,maxY,nPuntos);
    
    % Creamos la malla con las coordenadas "X" y "Y" del campo el�ctrico
    [xPuntosMalla,yPuntosMalla] = meshgrid(X,Y);
end

function [campoElectricoX, campoElectricoY, magnitudCampoETotal] = obtenerCampoElectrico...
    (xPuntosMalla, yPuntosMalla, xCargas, yCargas, k, campoElectricoX,...
    campoElectricoY, cargasFinales, eleccionPosicion)
    syms L
    % Recorrido de las cargas para calcular campo electrico
    for i = 1:1:2
        if eleccionPosicion == 1 % Si elige esta opci�n, las cargas aparecer�n verticalmente
            syms L
            distanciaX = xPuntosMalla - xCargas(i); % Matriz con los componentes "X" del vector de traslaci�n que va desde la carga lineal hasta un punto
            lambda = cargasFinales(i) / (yCargas(i,2) - yCargas(i,1)); % Se calcula la densidad de l�nea de carga
            integralX = ((k * lambda) .* (L - yPuntosMalla)) ./ (distanciaX .* ((distanciaX.^2 + (yPuntosMalla - L).^2)).^(1/2)); % Integral
            %de la componente "X" del campo el�ctrico 
            integralY = (k * lambda) ./ (distanciaX.^2 + (yPuntosMalla - L).^2).^(1/2); %Integral de la componente "Y" del campo el�ctrico
            campoElectricoX = campoElectricoX + (subs(integralX, yCargas(i,2)) - subs(integralX, yCargas(i,1))); %Se eval�a la integral y se obtiene el componente en "X" del vector del campo el�ctrico
            campoElectricoY = campoElectricoY + (subs(integralY, yCargas(i,2)) - subs(integralY, yCargas(i,1))); %Se eval�a la integral y se obtiene el componente en "Y" del vector del campo el�ctrico
        elseif eleccionPosicion == 2 % Si elige esta opci�n, las cargas aparecer�n horizontalmente
            distanciaY = yPuntosMalla - yCargas(i); % Matriz con los componentes "Y" del vector de traslaci�n que va desde la carga lineal hasta un punto
            lambda = cargasFinales(i) / (xCargas(i,2) - xCargas(i,1)); % Se calcula la densidad de l�nea de carga
            integralX = (k * lambda) ./ (distanciaY.^2 + (xPuntosMalla - L).^2).^(1/2); % Integral de la componente "X" del campo el�ctrico 
            integralY = ((k * lambda) .* (L - xPuntosMalla)) ./ (distanciaY .* ((distanciaY.^2 + (xPuntosMalla - L).^2)).^(1/2)); % Integral de la componente "Y"
            %del campo el�ctrico
            campoElectricoX = campoElectricoX + (subs(integralX, xCargas(i,2)) - subs(integralX, xCargas(i,1))); % Se calcula el componente en "X" del vector del campo el�ctrico
            campoElectricoY = campoElectricoY + (subs(integralY, xCargas(i,2)) - subs(integralY, xCargas(i,1))); % Se calcula el componente en "Y" del vector del campo el�ctrico
        end  
    end
    magnitudCampoETotal = sqrt(campoElectricoX .^2 + campoElectricoY .^2); % Se calcula la magnitud del campo magn�tico en base al vector del campo electrico.
end

function graficaCampoElectrico(xPuntosMalla, yPuntosMalla, campoElectricoX, campoElectricoY, magnitudCampoETotal, anchoC, xCargas, yCargas, cargasFinales, minX, maxX, minY, maxY, eleccionPosicion)
    % Graficaci�n con quiver
    quiver(xPuntosMalla, yPuntosMalla, campoElectricoX ./ magnitudCampoETotal, campoElectricoY ./ magnitudCampoETotal)
    % Se divide para normalizar el tama�o
    hold on

    xlim([minX, maxX])
    ylim([minY, maxY])
    xlabel("X[m]");
    ylabel("Y[m]");
    axis square
    % Para pos_ xCargas(1) es el centro de la carga, y para dibujar la carga,
    % queremos la esquina inferior derecha, por eso se le resta radioC
    for i = 1:1:2
        if eleccionPosicion == 1 % Con esta opci�n se graficar�n las cargas verticalmente
            pos_x = xCargas(i) - anchoC; % Calcula el punto en el que se iniciar� a graficar la carga lineal en "X"            
            if cargasFinales(i) < 0 % Si la carga es negativa, se graficar� un rect�ngulo rojo con el s�mbolo negativo 
                rectangle('Position',[pos_x, yCargas(i,1), (anchoC*2), (2*yCargas(i,2))],'Curvature',0.2,'FaceColor', 'r' ,'EdgeColor',[0 0 1])
                text(pos_x, 0,'-','Color','white','FontSize',30)
            else % Si la carga es positiva, se graficar� un rect�ngulo az�l con el s�mbolo de positivo
                rectangle('Position',[pos_x, yCargas(i,1), (anchoC*2), (2*yCargas(i,2))],'Curvature',0.2,'FaceColor', 'b' ,'EdgeColor',[0 0 1])
                text(pos_x, 0,'+','Color','white','FontSize',30)
            end
        elseif eleccionPosicion == 2 % Con esta opci�n se graficar�n las cargas horizontalmente
            pos_y = yCargas(i) - anchoC; % Calcula el punto en el que se iniciar� a graficar la carga en "Y"
            if cargasFinales(i) < 0 % Si la carga es negativa, se graficar� un rect�ngulo rojo con el s�mbolo de negativo
                rectangle('Position',[ xCargas(i,1), pos_y, (2*xCargas(i,2)), (anchoC*2)],'Curvature',0.2,'FaceColor', 'r' ,'EdgeColor',[0 0 1])
                text(0, pos_y,'-','Color','white','FontSize',30)
            else % Si la carga es positiva, se graficar� un rect�ngulo az�l con el s�mbolo de positivo
                rectangle('Position',[xCargas(i,1), pos_y, (2*xCargas(i,2)), (anchoC*2)],'Curvature',0.2,'FaceColor', 'b' ,'EdgeColor',[0 0 1])
                text(0, pos_y,'+','Color','white','FontSize',30)
            end
        end
    end
end
