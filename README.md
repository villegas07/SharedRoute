# 🚗 Aplicativo Móvil de Transporte Compartido para Instituciones de Educación Superior

## 🧩 Tecnologías Utilizadas

<p align="center">
  <a href="https://flutter.dev" target="_blank">
    <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/flutter/flutter-original.svg" width="120" alt="Flutter Logo" />
  </a>
</p>

<p align="center">
  <strong>Aplicación Móvil Profesional para Transporte Compartido (SharedRoute)</strong><br>
  <em>Conecta conductores y pasajeros con tracking GPS, códigos de verificación y calificaciones bidireccionales</em>
</p>

<p align="center">
  <a href="#"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter" alt="Flutter" /></a>
  <a href="#"><img src="https://img.shields.io/badge/NestJS-11.0.1-E0234E?style=for-the-badge&logo=nestjs" alt="NestJS" /></a>
  <a href="#"><img src="https://img.shields.io/badge/Prisma-6.17.1-2D3748?style=for-the-badge&logo=prisma" alt="Prisma" /></a>
  <a href="#"><img src="https://img.shields.io/badge/PostgreSQL-15%2B-316192?style=for-the-badge&logo=postgresql" alt="PostgreSQL" /></a>
  <a href="#"><img src="https://img.shields.io/badge/Google%20Maps%20API-Enabled-4285F4?style=for-the-badge&logo=googlemaps" alt="Google Maps API" /></a>
  <a href="#"><img src="https://img.shields.io/badge/Status-Production%20Ready-success?style=for-the-badge" alt="Status" /></a>
</p>

---

## 📝 Descripción del Proyecto

Este aplicativo móvil está diseñado para **facilitar el transporte compartido entre estudiantes y personal de instituciones de educación superior**.  
La plataforma permite a los usuarios **ofrecer y solicitar viajes**, asegurando que todos los participantes pertenezcan a la misma institución.  

A través de la **geolocalización en tiempo real** y **notificaciones push**, los usuarios pueden conectarse de manera eficiente, optimizando los recursos y fomentando la comunidad universitaria.

---

## 🌟 Características Principales

- **Registro de Usuarios:** Permite el registro mediante correo institucional para garantizar la pertenencia a la institución.  
- **Geolocalización:** Mapa interactivo con disponibilidad de vehículos y seguimiento en tiempo real.  
- **Notificaciones Push:** Alertas sobre proximidad de vehículos y recordatorios de horarios.  
- **Reserva de Viajes:** Interfaz intuitiva para solicitar y confirmar trayectos.  
- **Pasarela de Pagos:** Integración con métodos de pago seguros y confiables.  
- **Calificaciones y Comentarios:** Sistema de reseñas que mejora la calidad del servicio.  
- **Soporte y Ayuda:** Sección dedicada a preguntas frecuentes y asistencia directa.

---
## Descripción de la Arquitectura

**mejores prácticas de Flutter** con una arquitectura escalable y mantenible.

```
lib/
├── main.dart                          # Punto de entrada de la aplicación
├── config/                             # Configuración global
│   ├── app_colors.dart                # Definición de colores
│   └── app_theme.dart                 # Tema de la aplicación
├── models/                             # Modelos de datos
│   ├── trip.dart                      # Modelo de Viaje
│   ├── user.dart                      # Modelo de Usuario
│   └── index.dart                     # Exportaciones
├── screens/                            # Pantallas principales
│   ├── splash/
│   │   └── splash_screen.dart         # Pantalla de inicio
│   ├── login/
│   │   └── login_screen.dart          # Pantalla de login
│   └── home/
│       ├── home_screen.dart           # Pantalla principal
│       └── widgets/                   # Widgets específicos del home
│           ├── home_header.dart
│           ├── user_type_toggle.dart
│           ├── passenger_search_section.dart
│           ├── custom_drawer.dart
│           └── index.dart
├── shared/                             # Componentes reutilizables
│   └── widgets/
│       ├── trip_card.dart             # Card de viaje (pasajero)
│       ├── driver_trip_card.dart      # Card de viaje (conductor)
│       └── index.dart
└── utils/                              # Utilidades y constantes
    └── constants.dart                 # Constantes de la app
```

## Componentes Principales

### 1. **Config** (`lib/config/`)
Define los estilos globales de la aplicación:
- **app_colors.dart**: Paleta de colores centralizada
- **app_theme.dart**: Tema Material Design (tipografía, botones, etc.)

### 2. **Models** (`lib/models/`)
Define las estructuras de datos:
- **trip.dart**: Datos de un viaje
- **user.dart**: Datos de un usuario

### 3. **Screens** (`lib/screens/`)
Pantallas principales organizadas por características:
- **splash/**: Pantalla de bienvenida
- **login/**: Pantalla de autenticación
- **home/**: Pantalla principal con sus propios widgets

### 4. **Shared Widgets** (`lib/shared/widgets/`)
Componentes reutilizables en toda la app:
- **trip_card.dart**: Tarjeta de viaje para pasajeros
- **driver_trip_card.dart**: Tarjeta de viaje para conductores

### 5. **Utils** (`lib/utils/`)
Constantes, funciones auxiliares, etc.

## Ventajas de Esta Arquitectura

✅ **Escalabilidad**: Fácil agregar nuevas pantallas y features  
✅ **Mantenibilidad**: Código organizado y fácil de encontrar  
✅ **Reutilización**: Widgets compartidos sin duplicación  
✅ **Testing**: Componentes aislados facilitan pruebas unitarias  
✅ **Consistencia**: Tema centralizado en toda la app  
✅ **Colaboración**: Otros desarrolladores entienden la estructura rápidamente

## Próximos Pasos Recomendados

### 1️⃣ Agregar Gestor de Estado (Provider o Riverpod)
```dart
// Ejemplo con Provider
final tripListProvider = FutureProvider((ref) async {
  // Obtener lista de viajes
});
```

### 2️⃣ Crear Servicios (API, Base de Datos)
```
lib/services/
├── trip_service.dart      # Lógica de viajes
├── auth_service.dart      # Autenticación
└── api_client.dart        # Cliente HTTP
```

### 3️⃣ Agregar Validación y Manejo de Errores
```dart
// Crear validadores
abstract class Validator {
  String? validate(String value);
}
```

### 4️⃣ Implementar Logging y Analytics
```dart
// Rastrear eventos de usuario
final analytics = FirebaseAnalytics.instance;
```

### 5️⃣ Agregar Pruebas Unitarias
```
test/
├── models/
├── widgets/
└── screens/
```

## Cómo Usar Esta Estructura

### Crear una nueva pantalla:
1. Crear carpeta en `lib/screens/nombre_pantalla/`
2. Crear `nombre_pantalla_screen.dart`
3. Importar en `main.dart`
4. Agregar ruta en `routes`

### Agregar un nuevo widget reutilizable:
1. Crear en `lib/shared/widgets/nuevo_widget.dart`
2. Actualizar `lib/shared/widgets/index.dart`
3. Importar desde `shared/widgets/index.dart` en otras pantallas

### Modificar colores:
Ir a `lib/config/app_colors.dart` y actualizar una sola vez para que se refleje en toda la app.

---

## 🌿 Rama de Desarrollo

Se ha creado una rama llamada `daniel` para el desarrollo de nuevas características y correcciones.  
Los colaboradores deben realizar sus cambios en esta rama antes de fusionarlos con la rama principal (`main`).

---

## 🤝 Cómo Contribuir

Si deseas contribuir a este proyecto, sigue estos pasos:

1. **Clona el repositorio:**
    ```bash
    git clone https://github.com/tuusuario/tu-repo.git
2. **Crea y cambia a la rama daniel**
    ```bash
    git checkout daniel
    ```
3. **Realiza tus cambios en el código.**
4. **Agrega los cambios al área de preparación:**
    ```bash
    git add .
    ```
5. **Haz un commit de tus cambios:**
    ```bash
    git commit -m "Descripción de los cambios realizados"
    ```
6. Sube tus cambios a la rama daniel en el repositorio remoto:
    ```bash
    git push origin daniel
    ```
7. **Crea un Pull Request:**
* Ve a la página del repositorio en GitHub.
* Haz clic en "Pull requests".
* Haz clic en "New pull request".
* Selecciona tu rama daniel y la rama principal (por lo general, main o master).
* Añade una descripción y haz clic en "Create pull request".
