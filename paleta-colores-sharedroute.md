# Paleta de Colores — SharedRoute

> Paleta de colores derivada del logo de **SharedRoute**, app de transporte compartido.
> Documento de referencia para diseño UI/UX e implementación en código.

---

## 1. Colores de marca (Primarios)

| Nombre | Hex | RGB | Uso |
|---|---|---|---|
| Púrpura Principal | `#7C4DC4` | `124, 77, 196` | Color de marca, header, botones primarios, navegación activa |
| Azul Secundario | `#4A7FE8` | `74, 127, 232` | Acciones secundarias, links, estados activos, mapa/ruta |
| Coral / Rosa | `#F0626B` | `240, 98, 107` | Acentos, ubicación actual, CTAs importantes, alertas |
| Naranja / Ámbar | `#F5A623` | `245, 166, 35` | Acento secundario, ratings, badges, notificaciones |

## 2. Colores de fondo

| Nombre | Hex | RGB | Uso |
|---|---|---|---|
| Celeste Claro | `#E0F4FB` | `224, 244, 251` | Fondo general de la app |
| Blanco | `#FFFFFF` | `255, 255, 255` | Cards, superficies elevadas, modales |
| Gris Claro | `#F2F6F8` | `242, 246, 248` | Fondo alternativo, separadores sutiles |

## 3. Colores de texto

| Nombre | Hex | RGB | Uso |
|---|---|---|---|
| Verde Petróleo (texto principal) | `#1B4D52` | `27, 77, 82` | Títulos, texto principal (igual al wordmark del logo) |
| Gris Azulado (texto secundario) | `#5C7A80` | `92, 122, 128` | Subtítulos, texto secundario, placeholders |
| Gris Claro (texto deshabilitado) | `#A0B4B8` | `160, 180, 184` | Texto deshabilitado, inputs vacíos |

## 4. Colores funcionales (Estados)

| Nombre | Hex | RGB | Uso |
|---|---|---|---|
| Éxito | `#3FAE6E` | `63, 174, 110` | Viaje confirmado, conductor en camino, pago exitoso |
| Error | `#E84855` | `232, 72, 85` | Cancelaciones, errores, validaciones fallidas |
| Advertencia | `#F5A623` | `245, 166, 35` | Esperas, demoras, avisos importantes |
| Información | `#4A7FE8` | `74, 127, 232` | Mensajes informativos, tips |

## 5. Variantes de marca (tints/shades) — opcional

| Nombre | Hex | Uso |
|---|---|---|
| Púrpura Claro | `#D9C8F0` | Fondos de chips/tags, estados hover suaves |
| Púrpura Oscuro | `#5A3490` | Texto sobre fondo claro, estados pressed |
| Azul Claro | `#C9DBFA` | Fondos de chips/tags |
| Azul Oscuro | `#2E5BC0` | Estados pressed, texto sobre fondo claro |
| Coral Claro | `#FBD0D3` | Fondos de alertas suaves |
| Ámbar Claro | `#FCE3B8` | Fondos de badges suaves |

---

## 6. Variables CSS

```css
:root {
  /* Colores de marca */
  --color-primary: #7C4DC4;
  --color-secondary: #4A7FE8;
  --color-accent-coral: #F0626B;
  --color-accent-amber: #F5A623;

  /* Fondos */
  --color-bg: #E0F4FB;
  --color-bg-white: #FFFFFF;
  --color-bg-alt: #F2F6F8;

  /* Texto */
  --color-text-primary: #1B4D52;
  --color-text-secondary: #5C7A80;
  --color-text-disabled: #A0B4B8;

  /* Estados */
  --color-success: #3FAE6E;
  --color-error: #E84855;
  --color-warning: #F5A623;
  --color-info: #4A7FE8;

  /* Variantes */
  --color-primary-light: #D9C8F0;
  --color-primary-dark: #5A3490;
  --color-secondary-light: #C9DBFA;
  --color-secondary-dark: #2E5BC0;
  --color-accent-coral-light: #FBD0D3;
  --color-accent-amber-light: #FCE3B8;
}
```

## 7. Tokens para React Native / Flutter (JSON)

```json
{
  "colors": {
    "primary": "#7C4DC4",
    "secondary": "#4A7FE8",
    "accentCoral": "#F0626B",
    "accentAmber": "#F5A623",
    "background": "#E0F4FB",
    "backgroundWhite": "#FFFFFF",
    "backgroundAlt": "#F2F6F8",
    "textPrimary": "#1B4D52",
    "textSecondary": "#5C7A80",
    "textDisabled": "#A0B4B8",
    "success": "#3FAE6E",
    "error": "#E84855",
    "warning": "#F5A623",
    "info": "#4A7FE8",
    "primaryLight": "#D9C8F0",
    "primaryDark": "#5A3490",
    "secondaryLight": "#C9DBFA",
    "secondaryDark": "#2E5BC0",
    "accentCoralLight": "#FBD0D3",
    "accentAmberLight": "#FCE3B8"
  }
}
```

---

### Notas de uso
- El **púrpura** y **azul** funcionan bien como gradiente para headers o splash screens, replicando el efecto del logo.
- El **coral** y **ámbar** deben usarse con moderación, como acentos (botones de acción, badges), no como colores dominantes.
- Mantener buen contraste: usar `--color-text-primary` sobre fondos claros y blanco sobre los colores de marca saturados.
- Verificar accesibilidad (contraste AA mínimo) en combinaciones de texto sobre color, especialmente con el ámbar `#F5A623`.
