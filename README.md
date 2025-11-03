# Food App - Flutter

Aplicación móvil de comidas con arquitectura limpia, MVVM y Material You.

## Características

### Arquitectura
- **Clean Architecture**: Separación de capas (data, domain, presentation)
- **MVVM**: ViewModels con Provider para gestión de estado
- **Feature-First**: Organización por características
- **SOLID**: Principios aplicados en toda la arquitectura
- **Repository Pattern**: Abstracción de fuentes de datos
- **Dependency Injection**: Manual en main.dart

### UI/UX
- **Material You**: Diseño moderno con temas claro y oscuro
- **Responsive**: Adaptable a móviles y tablets
- **Atomic Design**: Componentes reutilizables (atoms, molecules, organisms)

### Navegación
- **go_router**: Navegación declarativa v2.0
- **Rutas tipadas**: Seguridad en tiempo de compilación
- **Redirección automática**: Según estado de autenticación

### API
- **TheMealDB**: API gratuita de comidas
- **Endpoints**:
    - Búsqueda de comidas
    - Categorías
    - Detalle de comida
    - Filtrado por categoría

### Almacenamiento Local
- **SharedPreferences**: Caché de usuario autenticado
- **Persistencia**: Datos del usuario entre sesiones

## Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.5          # Estado global
  go_router: ^14.6.2        # Navegación
  dio: ^5.7.0               # HTTP cliente
  shared_preferences: ^2.5.3 # Almacenamiento local
  equatable: ^2.0.7         # Comparación de objetos
  dartz: ^0.10.1            # Either pattern
  intl: ^0.20.2             # Internacionalización
```

## Configuración

1. Clonar el repositorio
2. Instalar dependencias:
```bash
flutter pub get
```

3. Ejecutar:
```bash
flutter run
```

## Flujo de Autenticación

1. **Splash**: Verifica estado de autenticación
2. **Login/Register**: Autenticación local (sin API)
3. **Home**: Acceso a funcionalidades principales
4. **Protección**: Rutas protegidas con redirección automática

## Logs

Formato estandarizado para eventos críticos:
```
[YYYY-MM-DD HH:MM:SS] [MODULO] [ERROR] Descripción (Code: XXX)
```

Solo se registran:
- Errores de red
- Fallos del servidor
- Excepciones críticas

