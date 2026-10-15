# Estado de la Etapa 1 (E1) — Área Educación

Checklist de la sección 9 del protocolo, con corte al 2026-10-15.

| Ítem | Estado | Qué falta |
|---|---|---|
| Protocolo completo, exportado a PDF (`docs/protocolo_E1.pdf`) | **Pendiente** | Los roles y el coordinador de datos ya están definidos en `docs/bitacora_decisiones.md` (sección E): falta copiarlos a la sección 1 del documento del protocolo; actualizar la sección 10 (declaración de IA); incorporar los cambios de `docs/bitacora_decisiones.md`; exportar a PDF. |
| Registro de búsqueda completo | **Parcial** | `docs/registro_busqueda_EDU.md` ya tiene la fecha (8 de octubre de 2026) y el N total (91.185). Hora (21:54, hora de Chile) y responsable (Martín) ya registrados. Falta lo que solo se ve en WoS: consulta exacta, ajustes de sintaxis y N por año de la pantalla. |
| Universo exportado en `data/raw/wos_edu/` | **Listo** | 92 lotes, 91.185 registros únicos. |
| Script de muestreo ejecutado sin errores desde cero | **Listo** | `R/01_muestreo_EDU.R` se ejecutó en Windows (Martín) y se volvió a ejecutar en Linux: misma lista, mismos conteos. |
| `lista_ordenada_EDU.csv`, `cuotas_EDU.csv`, `flujo_EDU.csv` | **Listo** | Nombres ajustados al protocolo. La lista incluye la columna `A08_sugerido`. |
| Suma de lotes = N del registro de búsqueda | **Listo** | La suma de los lotes es 91.185 (`output/lotes_EDU.csv`) y el N de WoS informado por el equipo es 91.185. |
| README que permita reproducir la lista | **Listo** | `README.md`. |
| Repositorio privado | **Pendiente** | El repositorio es público. Ver sección "Repositorio" del README. |

## Resultados clave del muestreo

- Universo WoS tras depurar duplicados: 91.185 (2025: 50.362; 2026: 40.823).
- Compartidos con otras áreas, eliminados: 5.574 (Salud 4.164; Computación/Ingeniería 1.410; ambas 0).
- Universo exclusivo de Educación: 85.611 (2025: 47.257; 2026: 38.354).
- Muestra n = 300: 166 artículos de 2025 y 134 de 2026 (asignación proporcional).
- Semilla 2026.
