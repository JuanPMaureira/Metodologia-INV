# =============================================================================
# 01_muestreo_EDU.R
# Trabajo IA-WoS (Magíster en Data Science, UCM) — Área Educación
# Entrega E1: depuración del universo y orden aleatorio para el componente A
#
# Procedimiento (sección 6.3 del enunciado):
#   1. Lee los lotes exportados desde WoS (texto plano, registro completo).
#   2. Deduplica el universo por UT.
#   3. Verifica los criterios de delimitación (sección 4).
#   4. Elimina los registros compartidos con Salud y Computación/Ingeniería.
#   5. Genera un orden aleatorio completo del universo con set.seed(2026).
#   6. Calcula la asignación proporcional de n = 300 por año (estrato).
#   7. Exporta la lista ordenada y los conteos para el diagrama de flujo.
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

# ---- 3. Verificación de criterios (sección 4) -------------------------------
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
edu <- edu[order(edu$UT), ]          # orden base reproducible, independiente de los lotes
set.seed(semilla)
edu <- edu[sample.int(nrow(edu)), ]
edu$A03 <- seq_len(nrow(edu))        # posición aleatoria global
edu$A04 <- edu$PY                    # estrato = año de publicación
edu$pos_estrato <- ave(edu$A03, edu$A04, FUN = seq_along)

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
lista <- edu[, c("A03", "A04", "pos_estrato", "UT", "DI", "TI", "SO", "SN", "EI",
                 "PU", "WE", "WC", "LA", "OA", "DT", "retractado", "proceedings")]
names(lista) <- c("A03_posicion", "A04_estrato", "posicion_estrato", "B01_UT", "B02_DOI",
                  "B03_titulo", "B07_revista", "ISSN", "eISSN", "editorial_WoS",
                  "indice_WoS", "B11_categorias_WoS", "idioma", "acceso_abierto_WoS",
                  "tipo_documento", "marca_retractado", "marca_proceedings")
write.csv(lista, file.path(dir_out, "lista_ordenada_EDU.csv"),
          row.names = FALSE, fileEncoding = "UTF-8", na = "")
write.csv(asignacion, file.path(dir_out, "asignacion_EDU.csv"), row.names = FALSE)

flujo <- c(
  sprintf("Fecha de ejecución del script: %s", format(Sys.time(), "%Y-%m-%d %H:%M")),
  sprintf("Lotes leídos: %d", length(lotes)),
  sprintf("Lotes repetidos detectados: %d %s", length(lotes_rep), paste(lotes_rep, collapse = ", ")),
  sprintf("Registros leídos: %d", nrow(bruto)),
  sprintf("Registros únicos por UT (universo WoS): %d", nrow(univ)),
  sprintf("  2025: %d | 2026: %d", sum(univ$PY == 2025), sum(univ$PY == 2026)),
  sprintf("Compartidos con Salud: %d", sum(univ$comparte_SAL)),
  sprintf("Compartidos con Computación/Ingeniería: %d", sum(univ$comparte_CIN)),
  sprintf("Compartidos con ambas: %d", sum(univ$comparte_SAL & univ$comparte_CIN)),
  sprintf("Compartidos solo por cruce de UT: %d", sum(univ$comparte_UT & !univ$comparte_SAL & !univ$comparte_CIN)),
  sprintf("Total eliminados por compartidos: %d", sum(univ$compartido)),
  sprintf("Universo exclusivo de Educación: %d", nrow(edu)),
  sprintf("  2025: %d | 2026: %d", N_h[["2025"]], N_h[["2026"]]),
  sprintf("  Marcados como retractados (E4 al revisar): %d", sum(edu$retractado)),
  sprintf("  Marcados como Proceedings Paper: %d", sum(edu$proceedings)),
  sprintf("Asignación n = %d: 2025 = %d | 2026 = %d", n_muestra, n_h[["2025"]], n_h[["2026"]]),
  sprintf("Semilla: set.seed(%d); RNGkind: %s", semilla, paste(RNGkind(), collapse = ", "))
)
writeLines(flujo, file.path(dir_out, "flujo_EDU.txt"))
cat(flujo, sep = "\n")

writeLines(capture.output(sessionInfo()), file.path(dir_out, "sessionInfo_01_muestreo.txt"))