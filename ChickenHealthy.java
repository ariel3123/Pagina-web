import java.util.Scanner;

/**
 * PROYECTO 13: CHICKEN HEALTHY - SISTEMA DE ALIMENTACION AUTOMATIZADA
 * PARALELO C - GRUPO 3 | UTMACH
 *
 * Version de consola traducida desde PSeInt.
 * Los valores de porcion son los de la tabla academica incluida en el programa.
 */
public class ChickenHealthy {
    private static final Scanner TECLADO = new Scanner(System.in);
    private static final int MAX_REGISTROS = 100;

    // Columnas de cada fila: edad en semanas, peso de referencia y porcion g/ave/dia.
    private static final double[][] TABLA_NUTRICIONAL = {
        {1, 160.0, 25.0},
        {2, 400.0, 50.0},
        {3, 850.0, 85.0},
        {4, 1400.0, 120.0},
        {5, 2100.0, 150.0},
        {6, 2900.0, 175.0}
    };

    private static final double[] HISTORIAL_SERVIDA = new double[MAX_REGISTROS];
    private static final double[] HISTORIAL_OBJETIVO = new double[MAX_REGISTROS];
    private static final double[] HISTORIAL_DIFERENCIA = new double[MAX_REGISTROS];

    private static int edadLote = 0;
    private static double pesoLote = 0.0;
    private static int numAvesLote = 0;
    private static int totalRegistros = 0;

    public static void main(String[] args) {
        int opcion;
        do {
            mostrarMenu();
            opcion = leerEntero("Seleccione una opcion (1-7): ");

            switch (opcion) {
                case 1:
                    registrarDatosLote();
                    break;
                case 2:
                    consultarDatosRegistrados();
                    break;
                case 3:
                    mostrarCalculoObjetivo();
                    break;
                case 4:
                    simularDispensacion();
                    break;
                case 5:
                    consultarHistorialDispensaciones();
                    break;
                case 6:
                    mostrarResumenAlimento();
                    break;
                case 7:
                    System.out.println("====================================================");
                    System.out.println(" Finalizando simulacion Chicken Healthy. Hasta luego!");
                    System.out.println("====================================================");
                    break;
                default:
                    System.out.println("OPCION INVALIDA. Elija un numero del 1 al 7.");
            }
            System.out.println();
        } while (opcion != 7);
    }

    private static void mostrarMenu() {
        System.out.println("====================================================");
        System.out.println(" CHICKEN HEALTHY - CONTROL DE ALIMENTACION");
        System.out.println("====================================================");
        System.out.println("1. Registrar / Actualizar datos del lote de aves");
        System.out.println("2. Consultar edad, peso y cantidad registrados");
        System.out.println("3. Calcular porcion objetivo de alimento");
        System.out.println("4. Simular dispensacion de alimento");
        System.out.println("5. Consultar historial de dispensaciones");
        System.out.println("6. Mostrar resumen de alimento administrado");
        System.out.println("7. Finalizar el programa");
        System.out.println("====================================================");
    }

    private static boolean validarRangoDatos(int edad, double peso) {
        return edad >= 1 && edad <= 6 && peso >= 100.0 && peso <= 3200.0;
    }

    private static double calcularPorcionObjetivo(int edad) {
        if (edad < 1 || edad > TABLA_NUTRICIONAL.length) {
            System.out.println("ERROR: La edad esta fuera del rango de la tabla tecnica.");
            return 0.0;
        }
        // La porcion se busca por edad, igual que en el programa PSeInt original.
        return TABLA_NUTRICIONAL[edad - 1][2];
    }

    private static double calcularDiferencia(double servida, double objetivo) {
        return servida - objetivo;
    }

    private static void registrarDatosLote() {
        int edad;
        double peso;
        int aves;
        do {
            edad = leerEntero("Ingrese la edad del lote (semanas, de 1 a 6): ");
            peso = leerDecimal("Ingrese el peso promedio por ave (g, de 100 a 3200): ");
            aves = leerEntero("Ingrese la cantidad de aves del lote: ");
            if (!validarRangoDatos(edad, peso) || aves <= 0) {
                System.out.println("====================================================");
                System.out.println("Datos fuera de rango. Intentelo de nuevo.");
                System.out.println("====================================================");
            }
        } while (!validarRangoDatos(edad, peso) || aves <= 0);

        edadLote = edad;
        pesoLote = peso;
        numAvesLote = aves;
        System.out.println("Datos registrados correctamente.");
    }

    private static void consultarDatosRegistrados() {
        if (edadLote == 0) {
            System.out.println("No hay datos de lote registrados aun.");
            return;
        }
        System.out.println("====================================================");
        System.out.println(" DATOS DEL LOTE REGISTRADOS");
        System.out.println("====================================================");
        System.out.println("Edad del lote: " + edadLote + " semanas");
        System.out.printf("Peso promedio por ave: %.1f gramos%n", pesoLote);
        System.out.println("Cantidad de aves: " + numAvesLote + " pollos");
        System.out.println("====================================================");
    }

    private static void mostrarCalculoObjetivo() {
        if (!hayLoteRegistrado()) return;

        double porcion = calcularPorcionObjetivo(edadLote);
        System.out.println("====================================================");
        System.out.println(" RESULTADO DEL CALCULO NUTRICIONAL");
        System.out.println("====================================================");
        System.out.println("Edad evaluada: " + edadLote + " semanas");
        System.out.printf("Porcion objetivo por ave: %.1f gramos/dia%n", porcion);
        System.out.printf("Porcion objetivo para el lote: %.3f kg/dia%n",
                (porcion * numAvesLote) / 1000.0);
        System.out.println("====================================================");
    }

    private static void simularDispensacion() {
        if (!hayLoteRegistrado()) return;
        if (totalRegistros >= MAX_REGISTROS) {
            System.out.println("El historial alcanzo su limite de " + MAX_REGISTROS + " eventos.");
            return;
        }

        double objetivo = calcularPorcionObjetivo(edadLote);
        System.out.printf("Porcion de referencia por ave: %.1f g/dia.%n", objetivo);
        System.out.printf("Cantidad de referencia para el lote: %.3f kg/dia.%n",
                (objetivo * numAvesLote) / 1000.0);
        double servida = leerDecimal("Ingrese el alimento servido (g por ave): ");
        double diferencia = calcularDiferencia(servida, objetivo);

        if (Math.abs(diferencia) > 0.000001) {
            System.out.printf("[AVISO] Diferencia respecto a la meta: %.1f g por ave.%n", diferencia);
        }

        HISTORIAL_SERVIDA[totalRegistros] = servida;
        HISTORIAL_OBJETIVO[totalRegistros] = objetivo;
        HISTORIAL_DIFERENCIA[totalRegistros] = diferencia;
        totalRegistros++;
        System.out.println("Dispensacion simulada y registrada en el evento #" + totalRegistros + ".");
    }

    private static void consultarHistorialDispensaciones() {
        if (totalRegistros == 0) {
            System.out.println("No existen registros de dispensacion en el historial.");
            return;
        }

        System.out.println("==========================================================================");
        System.out.println(" HISTORIAL DE DISPENSACIONES");
        System.out.println("==========================================================================");
        System.out.println("Evento | Objetivo (g) | Servido (g) | Diferencia (g)");
        System.out.println("--------------------------------------------------------------------------");
        for (int i = 0; i < totalRegistros; i++) {
            System.out.printf("%6d | %12.1f | %11.1f | %14.1f%n",
                    i + 1, HISTORIAL_OBJETIVO[i], HISTORIAL_SERVIDA[i], HISTORIAL_DIFERENCIA[i]);
        }
        System.out.println("==========================================================================");
    }

    private static void mostrarResumenAlimento() {
        if (totalRegistros == 0) {
            System.out.println("No hay datos suficientes para generar estadisticas.");
            return;
        }

        double sumaServida = 0.0;
        double sumaObjetivo = 0.0;
        double sumaDiferencia = 0.0;
        for (int i = 0; i < totalRegistros; i++) {
            sumaServida += HISTORIAL_SERVIDA[i];
            sumaObjetivo += HISTORIAL_OBJETIVO[i];
            sumaDiferencia += HISTORIAL_DIFERENCIA[i];
        }

        System.out.println("==========================================================================");
        System.out.println(" RESUMEN ESTADISTICO DE ALIMENTACION");
        System.out.println("==========================================================================");
        System.out.println("Total de eventos de alimentacion: " + totalRegistros);
        System.out.printf("Total servido acumulado (por ave): %.1f gramos%n", sumaServida);
        System.out.printf("Total objetivo teorico (por ave): %.1f gramos%n", sumaObjetivo);
        System.out.printf("Diferencia acumulada (servido - objetivo): %.1f gramos%n", sumaDiferencia);
        System.out.printf("Consumo estimado del lote actual: %.3f kg%n",
                (sumaServida * numAvesLote) / 1000.0);
        System.out.println("==========================================================================");
    }

    private static boolean hayLoteRegistrado() {
        if (edadLote == 0) {
            System.out.println("Primero debe registrar los datos del lote (opcion 1).");
            return false;
        }
        return true;
    }

    private static int leerEntero(String mensaje) {
        while (true) {
            System.out.print(mensaje);
            String entrada = TECLADO.nextLine().trim();
            try {
                return Integer.parseInt(entrada);
            } catch (NumberFormatException e) {
                System.out.println("Ingrese un numero entero valido.");
            }
        }
    }

    private static double leerDecimal(String mensaje) {
        while (true) {
            System.out.print(mensaje);
            String entrada = TECLADO.nextLine().trim().replace(',', '.');
            try {
                return Double.parseDouble(entrada);
            } catch (NumberFormatException e) {
                System.out.println("Ingrese un numero valido; puede usar punto o coma decimal.");
            }
        }
    }
}
