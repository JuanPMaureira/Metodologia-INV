# =============================================================================
# 03_seleccion_calibracion_EDU.R
# Trabajo IA-WoS (Magíster en Data Science, UCM) — Área Educación — Etapa 2
#
# Arma los 20 artículos de calibración:
#   - 8 con declaración de IA: buscados en las plataformas de las revistas
#     (data/calibracion/con_declaracion_EDU.csv) y verificados contra la lista.
#   - 12 por sorteo, con set.seed(2026), entre los artículos de la lista con
#     posicion_estrato > 250 (2025) o > 200 (2026), es decir, fuera de los
#     candidatos de la muestra del componente A. Se sortea un orden y se toman
#     los primeros 12 que pasan el filtro de títulos; el resto queda de reserva.
#
# Requiere: R base. Ejecutar desde la raíz:  Rscript R/03_seleccion_calibracion_EDU.R
# =============================================================================
lista <- read.csv("output/lista_ordenada_EDU.csv", stringsAsFactors = FALSE, encoding = "UTF-8")
decl  <- read.csv("data/calibracion/con_declaracion_EDU.csv", stringsAsFactors = FALSE, encoding = "UTF-8")
corte <- c("2025" = 250, "2026" = 200)

lista$fuera <- lista$posicion_estrato > corte[as.character(lista$A04_estrato)]
elegible <- lista$fuera & lista$tipo_documento == "Article" &
  lista$marca_retractado != "TRUE" & nzchar(lista$B02_DOI)

# Filtro de títulos: la IA debe ser herramienta, no objeto de estudio
patron <- "\\b(AI|artificial intelligence|ChatGPT|GPT|generative|large language|LLMs?|chatbots?|machine learning|algorithms?)\\b"
sin_ia <- !grepl(patron, lista$B03_titulo, ignore.case = TRUE, perl = TRUE)

# --- 8 con declaración ---
a <- lista[match(tolower(decl$B02_DOI), tolower(lista$B02_DOI)), ]
stopifnot(!anyNA(a$B01_UT), all(a$fuera), nrow(a) == 8)
a$via <- "con_declaracion"; a$plataforma <- decl$plataforma; a$cadena_busqueda <- decl$cadena_busqueda

# --- 12 por sorteo (+ reserva) ---
set.seed(2026)
pool <- which(elegible & sin_ia & !(lista$B01_UT %in% a$B01_UT))
orden <- sample(pool)[1:30]
b <- lista[orden, ]
b$via <- c(rep("sorteo", 12), rep("reserva", 18))
b$plataforma <- ""; b$cadena_busqueda <- ""

cols <- c("via", "A04_estrato", "posicion_estrato", "B01_UT", "B02_DOI", "B03_titulo",
          "B07_revista", "editorial_WoS", "idioma", "acceso_abierto_WoS", "plataforma", "cadena_busqueda")
res <- rbind(a[, cols], b[, cols])
res <- cbind(orden = seq_len(nrow(res)), res, asignado_a = "", estado = "por codificar")
write.csv(res, "data/calibracion/seleccion_calibracion_EDU.csv", row.names = FALSE, fileEncoding = "UTF-8")
cat("Con declaración:", sum(res$via == "con_declaracion"), "| Sorteo:", sum(res$via == "sorteo"),
    "| Reserva:", sum(res$via == "reserva"), "\n")
