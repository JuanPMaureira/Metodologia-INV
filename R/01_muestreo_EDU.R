# =============================================================================
# 01_muestreo_EDU.R
# Trabajo IA-WoS (Magíster en Data Science, UCM) — Área Educación
# Entrega E1: depuración del universo y orden aleatorio para el componente A
#
# Procedimiento (sección 6.3 del enunciado):
#   1. Lee los lotes exportados desde WoS (texto plano, registro completo).
#   2. Deduplica el universo por UT.
#   3. Excluye los registros Article; Review y los fuera de rango (PY o idioma),
#      contándolos aparte, y verifica los criterios de delimitación (sección 4).
#   4. Elimina los registros compartidos con Salud y Computación/Ingeniería.
#   5. Genera un orden aleatorio completo del universo con set.seed(2026).
#   6. Calcula la asignación proporcional de n = 300 por año (estrato).
#   7. Exporta la lista ordenada y los conteos para el diagrama de flujo.
#
# Salidas (carpeta output/): lista_ordenada_EDU.csv, cuotas_EDU.csv,
#   flujo_EDU.csv, lotes_EDU.csv y sessionInfo_EDU.txt.
# La columna A08_sugerido reparte las posiciones de cada estrato: impares a
# MSC (Martín Soto Cabezas) y pares a JPM (Juan Pablo Maureira Sanhueza).
#
# Solo usa R base. Ejecutar desde la raíz del proyecto:
#   Rscript R/01_muestreo_EDU.R
# =============================================================================

# ---- 0. Configuración -------------------------------------------------------
dir_wos    <- "data/raw/wos_edu"     # lotes savedrecs*.txt sin modificar
dir_out    <- "output"
semilla    <- 2026
n_muestra  <- 300
archivo_ut_otras <- "data/ut_otras_areas.csv"  # opcional: columna UT con los
                                               # registros de Salud y CIN

dir.create(dir_out, showWarnings = FALSE, recursive = TRUE)

cat_edu <- c("Education & Educational Research", "Education, Scientific Disciplines",
             "Education, Special", "Psychology, Educational")
cat_sal <- c("Medicine, General & Internal", "Public, Environmental & Occupational Health",
             "Nursing", "Health Care Sciences & Services")
cat_cin <- c("Computer Science, Information Systems", "Computer Science, Software Engineering",
             "Computer Science, Interdisciplinary Applications",
             "Computer Science, Theory & Methods", "Engineering, Electrical & Electronic")

campos <- c("UT", "DI", "TI", "SO", "SN", "EI", "PU", "PY", "EA", "DT",
            "LA", "WC", "WE", "OA", "DA")

# ---- 1. Lectura de los lotes WoS --------------------------------------------
leer_wos <- function(f) {
  x <- readLines(f, encoding = "UTF-8", warn = FALSE)
  x[1] <- sub("^\ufeff", "", x[1])            # quita BOM
  tag  <- substr(x, 1, 2)
  val  <- substring(x, 4)
  cont <- tag == "  "                         # líneas de continuación
  tag  <- tag[cummax(seq_along(tag) * !cont)] # hereda la etiqueta anterior
  rec  <- cumsum(tag == "PT" & !cont)         # cada registro empieza en PT
  ok   <- rec > 0 & tag %in% campos
  m <- tapply(val[ok], list(rec[ok], tag[ok]), paste, collapse = "\u0001")
  d <- as.data.frame(m, stringsAsFactors = FALSE)
  for (cc in setdiff(campos, names(d))) d[[cc]] <- NA_character_
  d <- d[, campos]
  # WE es multilínea con un índice por línea; el resto se une con espacio
  d$WE <- gsub("\u0001", "; ", d$WE)
  for (cc in setdiff(campos, "WE")) d[[cc]] <- gsub("\u0001", " ", d[[cc]])
  d$archivo <- basename(f)
  d
}

if (!dir.exists(dir_wos))
  stop("No existe la carpeta '", dir_wos, "' desde el directorio de trabajo actual: ",
       getwd(), ". Abre la carpeta del proyecto o ajusta dir_wos.")
lotes <- list.files(dir_wos, pattern = "^savedrecs.*\\.txt$", full.names = TRUE)
if (length(lotes) == 0)
  stop("No se encontraron archivos savedrecs*.txt en '", normalizePath(dir_wos), "'.")
cat("Lotes encontrados:", length(lotes), "\n")
lotes <- lotes[order(as.integer(sub(".*\\((\\d+)\\).*", "\\1",
                                    ifelse(grepl("\\(", lotes), lotes, "(0)"))))]
bruto <- do.call(rbind, lapply(lotes, leer_wos))
rownames(bruto) <- NULL

# Lotes idénticos (mismo conjunto de UT), por si quedó alguna descarga repetida
firma <- tapply(bruto$UT, bruto$archivo, function(u) paste(sort(u), collapse = ""))
lotes_rep <- names(firma)[duplicated(firma)]

# ---- 2. Deduplicación por UT -------------------------------------------------
univ <- bruto[!duplicated(bruto$UT), ]
univ$PY <- as.integer(univ$PY)
n_unicos <- nrow(univ)
py_unicos <- univ$PY

# ---- 3. Exclusiones del protocolo y verificación de criterios (sección 4) ---
# Article; Review se excluye; los registros fuera de rango (PY distinto de
# 2025-2026, sin PY o idioma distinto de inglés/español) se cuentan aparte.
es_review   <- grepl("Review", univ$DT)
fuera_rango <- !(univ$PY %in% 2025:2026) | !(univ$LA %in% c("English", "Spanish"))
n_review <- sum(es_review)
n_fuera  <- sum(!es_review & fuera_rango)
n_sin_PY <- sum(is.na(univ$PY))
univ <- univ[!es_review & !fuera_rango, ]

# Conteos informativos del universo WoS (antes de quitar compartidos)
n_SCIE <- c(sum(grepl("Science Citation Index Expanded", univ$WE)),
            sum(grepl("Science Citation Index Expanded", univ$WE) & univ$PY == 2025),
            sum(grepl("Science Citation Index Expanded", univ$WE) & univ$PY == 2026))
n_SSCI <- c(sum(grepl("Social Science Citation Index", univ$WE)),
            sum(grepl("Social Science Citation Index", univ$WE) & univ$PY == 2025),
            sum(grepl("Social Science Citation Index", univ$WE) & univ$PY == 2026))
n_ESCI <- c(sum(grepl("Emerging Sources Citation Index", univ$WE)),
            sum(grepl("Emerging Sources Citation Index", univ$WE) & univ$PY == 2025),
            sum(grepl("Emerging Sources Citation Index", univ$WE) & univ$PY == 2026))
es_EA <- !is.na(univ$EA) & nzchar(univ$EA)      # registros Early Access

cats <- strsplit(univ$WC, "; ")
tiene <- function(lista) vapply(cats, function(c) any(c %in% lista), logical(1))

verif <- c(
  PY_2025_2026     = all(univ$PY %in% 2025:2026),
  DT_Article       = all(grepl("^Article", univ$DT)),
  DT_sin_Review    = !any(grepl("Review", univ$DT) & !grepl("Retracted", univ$DT)),
  LA_ingles_espanol= all(univ$LA %in% c("English", "Spanish")),
  WC_educacion     = all(tiene(cat_edu)),
  WE_indices       = all(grepl("Science Citation Index Expanded|Social Science Citation Index|Emerging Sources Citation Index", univ$WE))
)
print(verif)
if (!all(verif)) warning("Hay registros que no cumplen los criterios: revisar antes de muestrear.")

# ---- 4. Registros compartidos con otras áreas -------------------------------
# Un registro con categorías de Salud o CIN aparece también en esos universos,
# porque las tres consultas usan los mismos filtros de año, tipo e idioma.
univ$comparte_SAL <- tiene(cat_sal)
univ$comparte_CIN <- tiene(cat_cin)

# Cruce adicional con los UT exportados por los otros equipos (si existe)
univ$comparte_UT <- FALSE
if (file.exists(archivo_ut_otras)) {
  ut_otras <- read.csv(archivo_ut_otras, stringsAsFactors = FALSE)$UT
  univ$comparte_UT <- univ$UT %in% ut_otras
}
univ$compartido <- univ$comparte_SAL | univ$comparte_CIN | univ$comparte_UT

edu <- univ[!univ$compartido, ]

# Marcas útiles para la revisión (no se eliminan: se registran al revisar)
edu$retractado  <- grepl("Retracted", edu$DT)        # criterio E4
edu$proceedings <- grepl("Proceedings Paper", edu$DT)

# ---- 5. Orden aleatorio completo con semilla fija ---------------------------
RNGkind(kind = "Mersenne-Twister", normal.kind = "Inversion", sample.kind = "Rejection")
edu <- edu[order(edu$UT, method = "radix"), ]  # orden base reproducible (independiente de lotes y de la configuración regional)
set.seed(semilla)
edu <- edu[sample.int(nrow(edu)), ]
edu$A03 <- seq_len(nrow(edu))        # posición aleatoria global
edu$A04 <- edu$PY                    # estrato = año de publicación
edu$pos_estrato <- ave(edu$A03, edu$A04, FUN = seq_along)
edu$A08_sugerido <- ifelse(edu$pos_estrato %% 2 == 1, "MSC", "JPM")  # impares MSC, pares JPM (sección 7 del protocolo)

# ---- 6. Asignación proporcional por estrato ---------------------------------
N_h <- table(edu$A04)
cuota <- n_muestra * N_h / sum(N_h)
n_h <- floor(cuota)
faltan <- n_muestra - sum(n_h)                       # mayor resto
if (faltan > 0) {
  idx <- order(cuota - n_h, decreasing = TRUE)[seq_len(faltan)]
  n_h[idx] <- n_h[idx] + 1
}
asignacion <- data.frame(estrato = names(N_h), N_h = as.integer(N_h),
                         W_h = round(as.numeric(N_h / sum(N_h)), 4),
                         n_h = as.integer(n_h))
print(asignacion)

# ---- 7. Salidas --------------------------------------------------------------
lista <- edu[, c("A03", "A04", "pos_estrato", "A08_sugerido", "UT", "DI", "TI", "SO", "SN", "EI",
                 "PU", "WE", "WC", "LA", "OA", "DT", "retractado", "proceedings")]
names(lista) <- c("A03_posicion", "A04_estrato", "posicion_estrato", "A08_sugerido", "B01_UT", "B02_DOI",
                  "B03_titulo", "B07_revista", "ISSN", "eISSN", "editorial_WoS",
                  "indice_WoS", "B11_categorias_WoS", "idioma", "acceso_abierto_WoS",
                  "tipo_documento", "marca_retractado", "marca_proceedings")
write.csv(lista, file.path(dir_out, "lista_ordenada_EDU.csv"),
          row.names = FALSE, fileEncoding = "UTF-8", na = "")
write.csv(asignacion, file.path(dir_out, "cuotas_EDU.csv"), row.names = FALSE)

# Registro de lotes: respalda el control "suma de lotes = N del registro de búsqueda".
# El orden sigue el número del nombre del archivo; no prueba por sí solo que los
# rangos exportados de WoS sean consecutivos (eso lo respalda el registro de búsqueda).
reg_lote <- as.integer(table(factor(bruto$archivo, levels = basename(lotes))))
fecha_lote <- tapply(bruto$DA, factor(bruto$archivo, levels = basename(lotes)),
                     function(x) paste(sort(unique(x)), collapse = "/"))
lotes_tab <- data.frame(orden = seq_along(lotes), archivo = basename(lotes),
                        registros = reg_lote,
                        fecha_exportacion_DA = as.character(fecha_lote),
                        md5 = as.character(tools::md5sum(lotes)))
write.csv(lotes_tab, file.path(dir_out, "lotes_EDU.csv"), row.names = FALSE, fileEncoding = "UTF-8")

# Conteos para el diagrama de flujo (una fila por paso)
fila <- function(paso, N, n25 = NA, n26 = NA) data.frame(paso = paso, N = N, N_2025 = n25, N_2026 = n26)
py_ok <- function(x) c(sum(x == 2025, na.rm = TRUE), sum(x == 2026, na.rm = TRUE))
flujo <- rbind(
  fila("lotes_leidos", length(lotes)),
  fila("lotes_identicos_detectados", length(lotes_rep)),
  fila("registros_leidos", nrow(bruto)),
  fila("registros_unicos_por_UT", n_unicos, py_ok(py_unicos)[1], py_ok(py_unicos)[2]),
  fila("excluidos_Article_Review", n_review),
  fila("excluidos_fuera_de_rango_PY_o_idioma", n_fuera),
  fila("registros_sin_PY", n_sin_PY),
  fila("universo_WoS_tras_criterios", nrow(univ), py_ok(univ$PY)[1], py_ok(univ$PY)[2]),
  fila("informativo_indice_SCIE", n_SCIE[1], n_SCIE[2], n_SCIE[3]),
  fila("informativo_indice_SSCI", n_SSCI[1], n_SSCI[2], n_SSCI[3]),
  fila("informativo_indice_ESCI", n_ESCI[1], n_ESCI[2], n_ESCI[3]),
  fila("informativo_Early_Access", sum(es_EA), sum(es_EA & univ$PY == 2025), sum(es_EA & univ$PY == 2026)),
  fila("compartidos_con_Salud", sum(univ$comparte_SAL)),
  fila("compartidos_con_Computacion_Ingenieria", sum(univ$comparte_CIN)),
  fila("compartidos_con_ambas", sum(univ$comparte_SAL & univ$comparte_CIN)),
  fila("compartidos_solo_por_cruce_UT", sum(univ$comparte_UT & !univ$comparte_SAL & !univ$comparte_CIN)),
  fila("total_eliminados_por_compartidos", sum(univ$compartido),
       py_ok(univ$PY[univ$compartido])[1], py_ok(univ$PY[univ$compartido])[2]),
  fila("universo_exclusivo_Educacion", nrow(edu), N_h[["2025"]], N_h[["2026"]]),
  fila("informativo_marcados_retractados_E4", sum(edu$retractado)),
  fila("informativo_marcados_Proceedings_Paper", sum(edu$proceedings)),
  fila("muestra_n_asignada", n_muestra, n_h[["2025"]], n_h[["2026"]]),
  fila("semilla", semilla)
)
write.csv(flujo, file.path(dir_out, "flujo_EDU.csv"), row.names = FALSE, fileEncoding = "UTF-8")
print(flujo, row.names = FALSE)

writeLines(c(sprintf("Fecha de ejecución del script: %s", format(Sys.time(), "%Y-%m-%d %H:%M")),
             sprintf("RNGkind: %s", paste(RNGkind(), collapse = ", ")),
             "",
             capture.output(sessionInfo())),
           file.path(dir_out, "sessionInfo_EDU.txt"))
