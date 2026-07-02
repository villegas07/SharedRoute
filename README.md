# SharedRoute 🚗

> Plataforma móvil de viajes compartidos — Flutter + Material Design 3

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

SharedRoute es una aplicación móvil para Android e iOS que conecta pasajeros y conductores para compartir viajes de forma segura, rápida y elegante.

---

## 📱 Capturas de pantalla

> _Agrega aquí screenshots de la app cuando estén disponibles._

---

## 🏗️ Arquitectura

El proyecto sigue **Clean Architecture** con separación por capas:

```
lib/
├── core/                    # Código compartido
│   ├── constants/           # Colores, strings, rutas
│   ├── errors/              # Failures y excepciones
│   ├── network/             # Dio client, interceptores
│   ├── router/              # GoRouter y rutas nombradas
│   ├── services/            # TokenService (almacenamiento seguro)
│   ├── themes/              # Tema Material Design 3
│   ├── utils/               # Helpers (extractList, etc.)
│   └── widgets/             # Widgets reutilizables
│
├── features/                # Módulos de negocio
│   ├── auth/                # Login, registro, perfil
│   ├── bookings/            # Reservas de viajes
│   ├── geolocation/         # Ubicación y mapas
│   ├── home/                # Pantalla principal
│   ├── profile/             # Perfil de usuario
│   ├── reviews/             # Reseñas
│   ├── sos/                 # Emergencias y contactos
│   ├── support/             # Soporte y tickets
│   ├── trip_history/        # Historial de viajes
│   └── trips/               # Búsqueda y detalle de viajes
│
├── injection_container.dart # Inyección de dependencias (GetIt)
└── main.dart
```

Cada feature sigue la estructura:
```
feature/
├── data/
│   ├── datasources/         # Llamadas a la API (Dio)
│   ├── models/              # DTOs con fromJson/toJson
│   └── repositories/        # Implementaciones
├── domain/
│   ├── entities/            # Modelos de negocio puros
│   ├── repositories/        # Contratos (interfaces)
│   └── usecases/            # Casos de uso individuales
└── presentation/
    ├── viewmodels/          # ChangeNotifier (MVVM)
    ├── views/               # Screens
    └── widgets/             # Widgets específicos del feature
```

---

## 🛠️ Stack tecnológico

| Categoría | Paquete |
|---|---|
| Estado | `provider` + `ChangeNotifier` |
| Inyección de dependencias | `get_it` |
| Navegación | `go_router` |
| HTTP | `dio` + interceptores personalizados |
| Almacenamiento seguro | `flutter_secure_storage` |
| Tipografía | `google_fonts` (Inter) |
| Internacionalización | `intl` |
| Imágenes de red | `cached_network_image` |
| Programación funcional | `dartz` (Either/Failure) |
| Diseño | Material Design 3 |

---

## 🚀 Cómo empezar

### Requisitos previos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `>=3.x`
- Dart `^3.11.5`
- Android Studio / VS Code con extensión Flutter
- Dispositivo físico o emulador

### 1. Clonar el repositorio

```bash
git clone https://github.com/villegas07/SharedRoute.git
cd SharedRoute
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Configurar variables de entorno

Crea el archivo `lib/core/constants/app_config.dart` con la URL de tu backend:

```dart
abstract final class AppConfig {
  static const String baseUrl = 'https://tu-backend.com/api/v1';
}
```

> ⚠️ Este archivo **no se sube al repositorio**. Cada colaborador debe crearlo localmente.

### 4. Ejecutar la app

```bash
# Debug en dispositivo conectado
flutter run

# Debug en emulador específico
flutter run -d emulator-5554

# Release APK
flutter build apk --release
```

---

## 🤝 Cómo colaborar

### Flujo de trabajo Git

Usamos el modelo **Feature Branch**:

```
main          ← producción estable
└── develop   ← integración continua
    ├── feat/nombre-feature
    ├── fix/descripcion-bug
    └── chore/tarea-tecnica
```

### Pasos para contribuir

```bash
# 1. Crear rama desde develop
git checkout develop
git pull origin develop
git checkout -b feat/nombre-de-tu-feature

# 2. Desarrollar y commitear (ver convenciones abajo)
git add .
git commit -m "feat(auth): agregar validación de correo en registro"

# 3. Subir y abrir Pull Request
git push origin feat/nombre-de-tu-feature
```

Luego abre un **Pull Request** a `develop` en GitHub.

### Convención de commits

Seguimos [Conventional Commits](https://www.conventionalcommits.org/):

| Prefijo | Uso |
|---|---|
| `feat:` | Nueva funcionalidad |
| `fix:` | Corrección de bug |
| `ui:` | Cambios de UI/UX |
| `refactor:` | Refactorización sin cambio funcional |
| `chore:` | Tareas técnicas (deps, config) |
| `docs:` | Documentación |
| `test:` | Pruebas |

**Ejemplos:**
```
feat(trips): agregar filtro por fecha en búsqueda
fix(auth): corregir crash al hacer logout
ui(home): mejorar animación de bienvenida
chore(deps): actualizar flutter_secure_storage a 10.x
```

---

## 📐 Reglas de código

Para mantener consistencia en el proyecto:

| Regla | Límite |
|---|---|
| Líneas por función/método | Máx. 20 |
| Parámetros por método | Máx. 3 |
| Niveles de anidación | Máx. 2 |
| Widgets por archivo | 1 público + sus privados |

### Antes de hacer commit

```bash
# Análisis estático (debe pasar sin errores)
flutter analyze

# Formateo automático
dart format lib/

# Tests
flutter test
```

---

## 🔑 Convenciones de la API

El backend envuelve **todas** las respuestas en:

```json
{
  "data": { ... },
  "success": true,
  "timestamp": "2026-07-02T00:00:00.000Z"
}
```

El `ResponseInterceptor` en `lib/core/network/response_interceptor.dart` desenvuelve automáticamente el campo `data` antes de que llegue a los datasources.

Las listas paginadas usan el helper `extractList()` en `lib/core/utils/response_helpers.dart`.

---

## 📁 Archivos a no subir al repositorio

Asegúrate de que tu `.gitignore` incluya:

```
lib/core/constants/app_config.dart   # URL del backend
*.env
```

---

## 📄 Licencia

MIT © [villegas07](https://github.com/villegas07)

