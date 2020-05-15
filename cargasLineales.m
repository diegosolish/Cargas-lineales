function cargasLineales()
    % Proyecto Final
    
    % Hecho por:
    % David Josué Marcial Quero 
    % Diego Solis Higuera 
    % Carlos Augusto Pluma Seda 
    
    close all; 
    clc; % Se limpia la ventana de comandos y se cierran cualquier otro figure que se tenía previamente
    
    [nPuntos, minX, maxX, minY, maxY, anchoC, xCargas, yCargas, k, cargasFinales, eleccionPosicion] = variablesIniciales(); %Función que sirve para 
    % obtener los valores iniciales según los inputs del usuario.
    
    [campoElectricoX, campoElectricoY, xPuntosMalla,yPuntosMalla] = ...
    puntosCampoElectrico(nPuntos, minX, maxX, minY, maxY); % Función que sirve para crear los puntos que representaran al campo eléctrico
    
    [campoElectricoX, campoElectricoY, magnitudCampoETotal] = obtenerCampoElectrico...
    (xPuntosMalla, yPuntosMalla, xCargas, yCargas, k, campoElectricoX, campoElectricoY, cargasFinales, eleccionPosicion); %Función que sirve para 
    % calcular los valores del campo eléctrico
    
    graficaCampoElectrico(xPuntosMalla, yPuntosMalla, campoElectricoX,campoElectricoY, magnitudCampoETotal, anchoC, xCargas, yCargas, cargasFinales, minX, maxX, minY, maxY, eleccionPosicion); 
    % Función que sirve para graficar el campo eléctrico y el dipolo eléctrico.
end

function [nPuntos, minX, maxX, minY, maxY, anchoC, xCargas, yCargas, k, cargasFinales, eleccionPosicion] = variablesIniciales()
    nPuntos = 50; % Puntos para representar el campo eléctrico
    
    % Se recibe información primoridal del usuario como la magnitud de las
    %cargas, la cantidad de cargas y la posición que ocuparán
    fprintf("Al ser dos cargas lineales (misma magnitud de carga eléctrica pero de signo opuesto), solo es necesario ingresar un numero \n")
    carga = input("Ingrese la magnitud de las cargas (un numero positivo) (C): "); %Se ingresa la magnitud de las cargas lineales
    % Ingresa la posición de las cargas de línea
    eleccionPosicion = input("Ingrese el número de la opción correspondiente de la representación de los grupos de cargas que desea: 1) Vertical 2) Horizontal: "); %Se
    
    % El usuario ingresará la distnacia que habrá entre los dos grupos de cargas
    dis = ((input("Ingrese la distnacia entre las dos cargas lineales (m): "))/2); %Distancia entre las cargas lineales
    lonCargaPos = input("Ingrese la longitud que tendrá la carga lineal positiva (m): "); %Longitud de la carga lineal positiva
    lonCargaNeg = input("Ingrese la longitud que tendrá la carga lineal negativa (m): "); %Longitud de la carga lineal negativa
    
    % Se calculan las coordenadas de los extremos de las cargas de línea
    disPos1 = (lonCargaPos)/-2; 
    disPos2 = (lonCargaPos)/2;
    disNeg1 = (lonCargaNeg)/-2;
    disNeg2 = (lonCargaNeg)/2;
    
    % Condicionales para saber en qué posición se desea tener las cargas positivas y negativas
    if eleccionPosicion == 1
        posicion = input("¿En qué posición desea que estén las cargas positivas? (Ingrese el número de la opción correspondiente) 1) Izquierda 2) Derecha: ");
        yCargas = [disPos1, disPos2; disNeg1, disNeg2];%Valor de las posiciones de las cargas lineales en "Y"
        xCargas = [-dis,dis]; % Valor de las posiciones de las cargas lineales en "X"
        if posicion == 1
            cargasFinales = [carga, -carga]; % Son dos cargas de diferente signo
        elseif posicion == 2
            cargasFinales = [-carga, carga]; % Son dos cargas de diferente signo
        end
    elseif eleccionPosicion == 2
        posicion = input("¿En qué posición desea que estén las cargas positivas? (Ingrese el número de la opción correspondiente) 1) Abajo 2) Arriba: ");
        xCargas = [disPos1, disPos2; disNeg1, disNeg2];
        yCargas = [-dis,dis];
        if posicion == 1
            cargasFinales = [carga, -carga]; % Son dos cargas de diferente signo
        elseif posicion == 2
            cargasFinales = [-carga, carga]; % Son dos cargas de diferente signo
        end
    end
   
    % Determinar la distancia más grande entre las cargas para establecer
    %los límites del campo eléctrico y al mismo tiempo determina la
    %distancia más corta para saber el tamaño máximo que pueden tener el
    %ancho de los rectángulos que representarán a las cargas lineales
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
    minX = -distancia - (distancia/3); % Límites del campo eléctrico en X
    maxY = distancia + (distancia/3);
    minY = -distancia - (distancia/3); % Límites del campo eléctrico en Y
    
    eps = 8.854e-12; % Cálculo del valor de la constante eléctrica en el vacío
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
    
    % Creamos la malla con las coordenadas "X" y "Y" del campo eléctrico
    [xPuntosMalla,yPuntosMalla] = meshgrid(X,Y);
end

function [campoElectricoX, campoElectricoY, magnitudCampoETotal] = obtenerCampoElectrico...
    (xPuntosMalla, yPuntosMalla, xCargas, yCargas, k, campoElectricoX,...
    campoElectricoY, cargasFinales, eleccionPosicion)
    syms L
    % Recorrido de las cargas para calcular campo electrico
    for i = 1:1:2
        if eleccionPosicion == 1 % Si elige esta opción, las cargas aparecerán verticalmente
            syms L
            distanciaX = xPuntosMalla - xCargas(i); % Matriz con los componentes "X" del vector de traslación que va desde la carga lineal hasta un punto
            lambda = cargasFinales(i) / (yCargas(i,2) - yCargas(i,1)); % Se calcula la densidad de línea de carga
            integralX = ((k * lambda) .* (L - yPuntosMalla)) ./ (distanciaX .* ((distanciaX.^2 + (yPuntosMalla - L).^2)).^(1/2)); % Integral
            %de la componente "X" del campo eléctrico 
            integralY = (k * lambda) ./ (distanciaX.^2 + (yPuntosMalla - L).^2).^(1/2); %Integral de la componente "Y" del campo eléctrico
            campoElectricoX = campoElectricoX + (subs(integralX, yCargas(i,2)) - subs(integralX, yCargas(i,1))); %Se evalúa la integral y se obtiene el componente en "X" del vector del campo eléctrico
            campoElectricoY = campoElectricoY + (subs(integralY, yCargas(i,2)) - subs(integralY, yCargas(i,1))); %Se evalúa la integral y se obtiene el componente en "Y" del vector del campo eléctrico
        elseif eleccionPosicion == 2 % Si elige esta opción, las cargas aparecerán horizontalmente
            distanciaY = yPuntosMalla - yCargas(i); % Matriz con los componentes "Y" del vector de traslación que va desde la carga lineal hasta un punto
            lambda = cargasFinales(i) / (xCargas(i,2) - xCargas(i,1)); % Se calcula la densidad de línea de carga
            integralX = (k * lambda) ./ (distanciaY.^2 + (xPuntosMalla - L).^2).^(1/2); % Integral de la componente "X" del campo eléctrico 
            integralY = ((k * lambda) .* (L - xPuntosMalla)) ./ (distanciaY .* ((distanciaY.^2 + (xPuntosMalla - L).^2)).^(1/2)); % Integral de la componente "Y"
            %del campo eléctrico
            campoElectricoX = campoElectricoX + (subs(integralX, xCargas(i,2)) - subs(integralX, xCargas(i,1))); % Se calcula el componente en "X" del vector del campo eléctrico
            campoElectricoY = campoElectricoY + (subs(integralY, xCargas(i,2)) - subs(integralY, xCargas(i,1))); % Se calcula el componente en "Y" del vector del campo eléctrico
        end  
    end
    magnitudCampoETotal = sqrt(campoElectricoX .^2 + campoElectricoY .^2); % Se calcula la magnitud del campo magnético en base al vector del campo electrico.
end

function graficaCampoElectrico(xPuntosMalla, yPuntosMalla, campoElectricoX, campoElectricoY, magnitudCampoETotal, anchoC, xCargas, yCargas, cargasFinales, minX, maxX, minY, maxY, eleccionPosicion)
    % Graficación con quiver
    quiver(xPuntosMalla, yPuntosMalla, campoElectricoX ./ magnitudCampoETotal, campoElectricoY ./ magnitudCampoETotal)
    % Se divide para normalizar el tamaño
    hold on

    xlim([minX, maxX])
    ylim([minY, maxY])
    xlabel("X[m]");
    ylabel("Y[m]");
    axis square
    % Para pos_ xCargas(1) es el centro de la carga, y para dibujar la carga,
    % queremos la esquina inferior derecha, por eso se le resta radioC
    for i = 1:1:2
        if eleccionPosicion == 1 % Con esta opción se graficarán las cargas verticalmente
            pos_x = xCargas(i) - anchoC; % Calcula el punto en el que se iniciará a graficar la carga lineal en "X"            
            if cargasFinales(i) < 0 % Si la carga es negativa, se graficará un rectángulo rojo con el símbolo negativo 
                rectangle('Position',[pos_x, yCargas(i,1), (anchoC*2), (2*yCargas(i,2))],'Curvature',0.2,'FaceColor', 'r' ,'EdgeColor',[0 0 1])
                text(pos_x, 0,'-','Color','white','FontSize',30)
            else % Si la carga es positiva, se graficará un rectángulo azúl con el símbolo de positivo
                rectangle('Position',[pos_x, yCargas(i,1), (anchoC*2), (2*yCargas(i,2))],'Curvature',0.2,'FaceColor', 'b' ,'EdgeColor',[0 0 1])
                text(pos_x, 0,'+','Color','white','FontSize',30)
            end
        elseif eleccionPosicion == 2 % Con esta opción se graficarán las cargas horizontalmente
            pos_y = yCargas(i) - anchoC; % Calcula el punto en el que se iniciará a graficar la carga en "Y"
            if cargasFinales(i) < 0 % Si la carga es negativa, se graficará un rectángulo rojo con el símbolo de negativo
                rectangle('Position',[ xCargas(i,1), pos_y, (2*xCargas(i,2)), (anchoC*2)],'Curvature',0.2,'FaceColor', 'r' ,'EdgeColor',[0 0 1])
                text(0, pos_y,'-','Color','white','FontSize',30)
            else % Si la carga es positiva, se graficará un rectángulo azúl con el símbolo de positivo
                rectangle('Position',[xCargas(i,1), pos_y, (2*xCargas(i,2)), (anchoC*2)],'Curvature',0.2,'FaceColor', 'b' ,'EdgeColor',[0 0 1])
                text(0, pos_y,'+','Color','white','FontSize',30)
            end
        end
    end
end
