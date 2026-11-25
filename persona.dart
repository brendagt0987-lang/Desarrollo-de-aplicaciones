// Actividad Dart - Clases, constructores e interpolación de strings

void main() {
  // Prueba 1: constructor normal
  Estudiante e1 = Estudiante(
    codigo: 'EST-2026-014',
    nombreCompleto: 'Brenda Gaviria',
    programa: 'Ingeniería de Sistemas',
    semestre: 5,
    universidad: 'UNITECNAR',
  );
  e1.mostrarInfo();

  // Prueba 2: constructor desde JSON
  Map<String, dynamic> datosJson = {
    'codigo': 'EST-2026-055',
    'nombreCompleto': 'Yajaira Rodríguez',
    'programa': 'Ingeniería de Sistemas',
    'semestre': null,
    'universidad': 'UNITECNAR',
  };
  Estudiante e2 = Estudiante.desdeJson(datosJson);
  e2.mostrarInfo();

  // Funciones tradicionales
  print(mensajeBienvenida());
  print(calcularPromedio(4.5, 3.8, 4.0));

  // Funciones flecha
  print(despedida());
  print(esAprobado(3.2));
}

class Estudiante {
  String codigo;
  String nombreCompleto;
  String programa;
  int semestre;
  String universidad;

  // Constructor principal usando parámetros nombrados
  Estudiante({
    required this.codigo,
    required this.nombreCompleto,
    required this.programa,
    required this.semestre,
    required this.universidad,
  });

  // Constructor con nombre personalizado que recibe un JSON
  Estudiante.desdeJson(Map<String, dynamic> data)
      : codigo = data['codigo'] ?? 'SIN-CODIGO',
        nombreCompleto = data['nombreCompleto'] ?? 'Nombre no registrado',
        programa = data['programa'] ?? 'Programa no definido',
        semestre = data['semestre'] ?? 1,
        universidad = data['universidad'] ?? 'No especificada';

  // Método que imprime usando interpolación de strings
  void mostrarInfo() {
    print('Código: $codigo');
    print('Nombre: $nombreCompleto');
    print('Programa: $programa - Semestre: $semestre');
    print('Universidad: $universidad');
  }
}

// Función tradicional sin parámetros
String mensajeBienvenida() {
  return 'Bienvenido al sistema académico';
}

// Función tradicional con parámetros
double calcularPromedio(double n1, double n2, double n3) {
  return (n1 + n2 + n3) / 3;
}

// Función flecha sin parámetros
String despedida() => 'Gracias por usar el sistema';

// Función flecha con parámetros
bool esAprobado(double nota) => nota >= 3.0;