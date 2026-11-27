// ============================================================================
// PROYECTO 13: CHICKEN HEALTHY - SISTEMA DE ALIMENTACIÓN AUTOMATIZADA
// PARALELO C - GRUPO 3 | UTMACH
// ============================================================================
// --- FUNCIONES (Devuelven un valor) ---
// Función 1: Valida si la edad y peso están dentro de los rangos biológicos admitidos
Funcion esValido <- ValidarRangoDatos(edad, peso)
Definir esValido Como Logico;
Si (edad >= 1 Y edad <= 6) Y (peso >= 100.0 Y peso <= 3200.0) Entonces
esValido <- Verdadero;
SiNo
esValido <- Falso;
FinSi
FinFuncion
// Función 2: Calcula la porción objetivo usando la matriz de referencia técnica
Funcion porcion <- CalcularPorcionObjetivo(edad, peso, tabla)
Definir porcion Como Real;
Definir i Como Entero;
Definir encontrado Como Logico;
porcion <- 0.0;
encontrado <- Falso;
// Condicional Doble al evaluar si los datos están dentro del rango de la matriz
Si (edad >= 1 Y edad <= 6) Entonces
Para i <- 1 Hasta 6 Con Paso 1 Hacer
Si tabla[i,1] == edad Entonces
porcion <- tabla[i,3];
encontrado <- Verdadero;
FinSi
FinPara
SiNo
Escribir "ERROR: Los datos ingresados estan fuera de la tabla técnica.";
FinSi
FinFuncion
// Función 3: Calcula la diferencia o desperdicio entre la dosis servida y la objetivo
Funcion diff <- CalcularDiferencia(servida, objetivo)
Definir diff Como Real;
diff <- servida - objetivo;
FinFuncion
// --- SUBPROCESOS (Tareas operativas que no devuelven valor) ---
// Subproceso 1: Despliega el Menú Principal
SubProceso MostrarMenu
Escribir "====================================================";
Escribir " CHICKEN HEALTHY - CONTROL DE ALIMENTACIÓN ";
Escribir "====================================================";
Escribir "1. Registrar / Actualizar datos del lote de aves";
Escribir "2. Consultar edad y peso registrados";
Escribir "3. Calcular porcion objetivo de alimento";
Escribir "4. Simular dispensacion de alimento";
Escribir "5. Consultar historial de dispensaciones";
Escribir "6. Mostrar resumen de alimento administrado";Escribir "7. Finalizar el programa";
Escribir "====================================================";
Escribir "Seleccione una opcion (1-7): ";
FinSubProceso
// Subproceso 2: Registrar / Actualizar datos con ciclo Repetir...Hasta Que
SubProceso RegistrarDatosLote(edad Por Referencia, peso Por Referencia, aves Por
Referencia)
Definir e, a Como Entero;
Definir p Como Real;
Definir valido Como Logico;
// Ciclo Repetir...Hasta Que para garantizar lectura válida de datos
Repetir
Escribir "Ingrese la edad del lote (en semanas, de 1 a 6): ";
Leer e;
Escribir "Ingrese el peso promedio por ave (en gramos, 100 a 3200): ";
Leer p;
Escribir "Ingrese la cantidad de aves en el lote: ";
Leer a;
valido <- ValidarRangoDatos(e, p);
Si NO valido O a <= 0 Entonces
Escribir "====================================================";
Escribir "¡ERROR! Datos fuera de rango. Reintente de nuevo.";
Escribir "====================================================";
FinSi
Hasta Que valido Y a > 0;
edad <- e;
peso <- p;
aves <- a;
Escribir "-> Datos registrados correctamente.";
FinSubProceso
// Subproceso 3: Consultar Datos Registrados
SubProceso ConsultarDatosRegistrados(edad, peso, aves)
Si edad == 0 Entonces
Escribir "-> No hay datos de lote registrados aun.";
SiNo
Escribir "====================================================";
Escribir " DATOS DEL LOTE REGISTRADOS ";
Escribir "====================================================";
Escribir "Edad del lote : ", edad, " semanas";
Escribir "Peso promedio/ave : ", peso, " gramos";
Escribir "Cantidad de aves : ", aves, " pollos";
Escribir "====================================================";
FinSi
FinSubProceso
// Subproceso 4: Simular Dispensación de Alimento
SubProceso SimularDispensacion(edad, peso, aves, tabla, cantReg Por Referencia, hServ Por Referencia, hObj Por Referencia, hDif Por Referencia)
Definir pObj, pServ, diff Como Real;
Si edad == 0 Entonces
Escribir "-> Primero debe registrar los datos del lote (Opcion 1).";SiNo
pObj <- CalcularPorcionObjetivo(edad, peso, tabla);
Escribir "Porcion ideal calculada por ave: ", pObj, " g/dia.";
Escribir "Porcion total requerida para el lote: ", (pObj * aves) / 1000, "kg/dia.";
Escribir "Ingrese la cantidad de alimento que el dispensador entrego (g/ave):";
Leer pServ;
diff <- CalcularDiferencia(pServ, pObj);
// Condicional Simple: registrar alerta solo si la entrega difiere del objetivo
Si pServ <> pObj Entonces
Escribir "[ALERTA] La cantidad servida (", pServ, "g) difiere de la meta(", pObj, "g). Diferencia: ", diff, "g.";
FinSi
cantReg <- cantReg + 1;
hServ[cantReg] <- pServ;
hObj[cantReg] <- pObj;
hDif[cantReg] <- diff;
Escribir "-> Dispensacion efectuada y registrada con exito en el evento #",cantReg;
FinSi
FinSubProceso
// Subproceso 5: Consultar Historial de Dispensaciones
SubProceso ConsultarHistorialDispensaciones(cantReg, hServ, hObj, hDif)
Definir i Como Entero;
Si cantReg == 0 Entonces
Escribir "-> No existen registros de dispensacion en el historial.";
SiNo
Escribir"==========================================================================";
Escribir " HISTORIAL DE DISPENSACIONES";
Escribir"==========================================================================";
Escribir "Evento | Porcion Objetivo (g) | Porcion Servida (g) | Diferencia /
Desperdicio";
Escribir"--------------------------------------------------------------------------";
// Ciclo Para para recorrer los arreglos unidimensionales
Para i <- 1 Hasta cantReg Con Paso 1 Hacer
Escribir " ", i, " | ", hObj[i], " g | ", hServ[i]," g | ", hDif[i], " g";
FinPara
Escribir"==========================================================================";
FinSi
FinSubProceso
// Subproceso 6: Mostrar Resumen Estadístico
SubProceso MostrarResumenAlimento(cantReg, hServ, hObj, hDif, aves)
Definir i Como Entero;Definir sumServ, sumObj, sumDif Como Real;
Si cantReg == 0 Entonces
Escribir "-> No hay datos suficientes para generar estadísticas.";
SiNo
sumServ <- 0.0;
sumObj <- 0.0;
sumDif <- 0.0;
// Ciclo Para para procesar el acumulado de los arreglos
Para i <- 1 Hasta cantReg Con Paso 1 Hacer
sumServ <- sumServ + hServ[i];
sumObj <- sumObj + hObj[i];
sumDif <- sumDif + hDif[i];
FinPara
Escribir"==========================================================================";
Escribir " RESUMEN ESTADÍSTICO DE ALIMENTACIÓN
";
Escribir"==========================================================================";
Escribir "Total de eventos de alimentacion ejecutados: ", cantReg;
Escribir "Total alimento servido acumulado (por ave) : ", sumServ, " gramos";
Escribir "Total alimento objetivo teorico (por ave) : ", sumObj, " gramos";
Escribir "Desperdicio / Desviacion total acumulada : ", sumDif, " gramos";
Escribir "Consumo total estimado para el lote completo: ", (sumServ * aves) /
1000, " kg";
Escribir"==========================================================================";
FinSi
FinSubProceso
// --- ALGORITMO PRINCIPAL ---
Algoritmo ChickenHealthy
Definir edadLote, numAvesLote, op, totalRegistros Como Entero;
Definir pesoLote Como Real;
// Declaración de Arreglos Unidimensionales
Definir historialServida, historialObjetivo, historialDiferencia Como Real;
Dimension historialServida[100];
Dimension historialObjetivo[100];
Dimension historialDiferencia[100];
// Declaración de Matriz Bidimensional (Tabla Nutricional)
Definir tablaNutricional Como Real;
Dimension tablaNutricional[6, 3];
// Inicialización de la Matriz Técnica (6 Semanas x 3 Parámetros)
tablaNutricional[1,1] <- 1; tablaNutricional[1,2] <- 160.0;
tablaNutricional[1,3] <- 25.0;
tablaNutricional[2,1] <- 2; tablaNutricional[2,2] <- 400.0;
tablaNutricional[2,3] <- 50.0;
tablaNutricional[3,1] <- 3; tablaNutricional[3,2] <- 850.0;
tablaNutricional[3,3] <- 85.0;
tablaNutricional[4,1] <- 4; tablaNutricional[4,2] <- 1400.0;
tablaNutricional[4,3] <- 120.0;
tablaNutricional[5,1] <- 5; tablaNutricional[5,2] <- 2100.0;
tablaNutricional[5,3] <- 150.0;
tablaNutricional[6,1] <- 6; tablaNutricional[6,2] <- 2900.0;
tablaNutricional[6,3] <- 175.0;
edadLote <- 0;
pesoLote <- 0.0;
numAvesLote <- 0;
totalRegistros <- 0;
op <- 0;
// Ciclo Mientras para el Menú Principal
Mientras op <> 7 Hacer
MostrarMenu;
Leer op;
// Estructura Condicional Múltiple Segun
Segun op Hacer
1:
RegistrarDatosLote(edadLote, pesoLote, numAvesLote);
2:
ConsultarDatosRegistrados(edadLote, pesoLote, numAvesLote);
3:
Definir pTemp Como Real;
Si edadLote == 0 Entonces
Escribir "-> Primero debe registrar los datos del lote (Opcion1).";
SiNo
pTemp <- CalcularPorcionObjetivo(edadLote, pesoLote,tablaNutricional);
Escribir "====================================================";
Escribir " RESULTADO DEL CÁLCULO NUTRICIONAL ";
Escribir "====================================================";
Escribir "Edad evaluada : ", edadLote, " semanas";
Escribir "Porcion objetivo por ave: ", pTemp, " gramos/dia";
Escribir "Porcion objetivo lote : ", (pTemp * numAvesLote) /1000.0, " kg/dia";
Escribir "====================================================";
FinSi
4:
SimularDispensacion(edadLote, pesoLote, numAvesLote, tablaNutricional,
totalRegistros, historialServida, historialObjetivo, historialDiferencia);
5:
ConsultarHistorialDispensaciones(totalRegistros, historialServida,
historialObjetivo, historialDiferencia);
6:
MostrarResumenAlimento(totalRegistros, historialServida,
historialObjetivo, historialDiferencia, numAvesLote);
7:
Escribir "====================================================";
Escribir " Finalizando simulación Chicken Healthy. ¡Hasta luego!";
Escribir "====================================================";
De Otro Modo:
Escribir "¡OPCION INVALIDA! Por favor elija una opcion del 1 al 7.";
FinSegun
Escribir "";
FinMientras
FinAlgoritmo
