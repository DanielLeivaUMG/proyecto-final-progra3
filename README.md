# proyecto_final_progra3

PokéPlanner es una app Flutter que consume PokéAPI.

## Configuracion de entorno

1. Crea `.env` en la raiz del proyecto con base en `.env.example`.
2. Ejecuta la app con:
   `flutter run --dart-define-from-file=.env`

Si falta alguna variable requerida, la app fallara al iniciar con un error claro.

## Nota de seguridad

PokéAPI no requiere API key y este proyecto no maneja secretos reales.

El archivo `.env` se usa para evitar versionar configuracion local, pero no oculta secretos dentro de una app movil compilada.

Si en el futuro existieran API keys privadas, deben moverse a un backend propio y no incluirse en Flutter.
