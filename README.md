# Metodologia-INV — Área Educación

Uso y declaración de inteligencia artificial generativa en artículos científicos indexados en Web of Science (2025-2026).
Trabajo del Magíster en Data Science (Universidad Católica del Maule). Equipo de Educación: Juan Pablo Maureira Sanhueza (JPM) y Martín Eduardo Soto Cabezas (MSC).

Este repositorio contiene la Entrega 1 (E1): universo exportado de WoS, script de muestreo y lista ordenada del componente A.

## Estructura

```
R/01_muestreo_EDU.R          depuración del universo, orden aleatorio y cuotas
R/02_descarga_textos_EDU.R   descarga de textos en acceso abierto (Unpaywall), en el orden de la lista
data/raw/wos_edu/            lotes exportados de WoS, sin modificar (texto plano, registro completo)
output/lista_ordenada_EDU.csv  universo exclusivo de Educación en orden aleatorio (85.611 filas)
output/cuotas_EDU.csv          asignación proporcional por año (n = 300)
output/flujo_EDU.csv           conteos para el diagrama de flujo
output/lotes_EDU.csv           registros y huella md5 de cada lote
output/sessionInfo_EDU.txt     versión de R y paquetes de la ejecución en Windows
docs/                          registro de búsqueda, bitácora de decisiones y estado de la E1
```

## Cómo reproducir la lista

1. Instalar R (el script usa solo R base).
2. Abrir la carpeta del proyecto como directorio de trabajo.
3. Ejecutar:

```
Rscript R/01_muestreo_EDU.R
```

El script lee los lotes `savedrecs*.txt`, deduplica por UT, excluye `Article; Review` y registros fuera de rango, elimina los registros compartidos con Salud y Computación/Ingeniería (por categorías WC y, si existe, por `data/ut_otras_areas.csv`), ordena el universo por UT y lo permuta con `set.seed(2026)`, y calcula la asignación proporcional de 300 artículos por año.

Si R está configurado en una codificación distinta de UTF-8 (por ejemplo, en Linux sin `LANG` definido), los títulos con caracteres especiales salen mal escritos. En ese caso ejecutar con `LC_ALL=C.UTF-8 Rscript R/01_muestreo_EDU.R`.

## Columnas de `lista_ordenada_EDU.csv`

`A03_posicion` (posición global), `A04_estrato` (año), `posicion_estrato`, `A08_sugerido` (MSC en posiciones impares, JPM en pares), `B01_UT`, `B02_DOI`, `B03_titulo`, `B07_revista`, ISSN, eISSN, editorial, índice WoS, categorías WC, idioma, acceso abierto, tipo de documento y marcas de retractado y Proceedings Paper.

Los artículos se revisan en el orden de `posicion_estrato` dentro de cada año. No se puede elegir un artículo fuera de ese orden.

## Estado de la E1

Índice de resultados por entrega: [docs/bitacora_etapas.md](docs/bitacora_etapas.md). Checklist de la E1: [docs/estado_E1.md](docs/estado_E1.md). Cambios y decisiones: [docs/bitacora_decisiones.md](docs/bitacora_decisiones.md). Registro de búsqueda: [docs/registro_busqueda_EDU.md](docs/registro_busqueda_EDU.md).

## Repositorio

El enunciado pide un repositorio privado (GitHub privado u OSF) y prohíbe redistribuir textos completos. Por eso `pdfs/` y los archivos `.rar` están en `.gitignore`: los PDF descargados quedan solo en el computador de quien los descargó.

## Declaración de uso de IA

Pendiente de completar con la herramienta, la versión, el propósito, la extensión y la supervisión humana efectivos (sección 10 del protocolo).
