# =============================================================================
# 02_descarga_textos_EDU.R
# Trabajo IA-WoS (Magíster en Data Science, UCM) — Área Educación
#
# Descarga los textos completos en acceso abierto de los primeros candidatos
# de cada estrato, respetando el orden de la lista aleatoria.
#   - Consulta la API de Unpaywall con el DOI de cada artículo.
#   - Si hay un PDF en acceso abierto, lo descarga en pdfs/.
#   - Si no, deja el enlace DOI para buscarlo con la suscripción UCM.
#   - Se puede volver a correr: salta los artículos ya procesados.
#
# Los PDF NO se suben al repositorio (agregar "pdfs/" al .gitignore).
# Requiere: jsonlite
# Ejecutar desde la raíz del proyecto:  Rscript R/02_descarga_textos_EDU.R
# =============================================================================

if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("jsonlite")

# ---- Configuración -----------------------------------------------------------
email      <- "martin.soto.01@alumnos.ucm.cl"   # exigido por la API de Unpaywall
candidatos <- c("2025" = 250, "2026" = 200)     # primeros N por estrato (n_h + margen)
dir_pdf    <- "pdfs"
f_lista    <- "output/lista_ordenada_EDU.csv"
f_log      <- "output/descarga_textos_EDU.csv"
pausa      <- 0.3                               # segundos entre consultas

dir.create(dir_pdf, showWarnings = FALSE)
options(timeout = 60)

# ---- Candidatos en el orden de la lista --------------------------------------
lista <- read.csv(f_lista, stringsAsFactors = FALSE, encoding = "UTF-8")
cand <- do.call(rbind, lapply(names(candidatos), function(e) {
  x <- lista[lista$A04_estrato == as.integer(e), ]
  x <- x[order(x$posicion_estrato), ]
  head(x, candidatos[[e]])
}))
cand <- cand[order(cand$A03_posicion), ]

# Log previo (para retomar sin repetir)
if (file.exists(f_log)) {
  log <- read.csv(f_log, stringsAsFactors = FALSE, encoding = "UTF-8")
} else {
  log <- data.frame()
}
hechos <- if (nrow(log)) log$B01_UT[log$estado != "error"] else character(0)

# ---- Funciones -----------------------------------------------------------------
consultar_unpaywall <- function(doi) {
  url <- sprintf("https://api.unpaywall.org/v2/%s?email=%s",
                 utils::URLencode(doi, reserved = FALSE), email)
  tryCatch(suppressWarnings(jsonlite::fromJSON(url, simplifyVector = FALSE)),
           error = function(e) NULL)
}

es_pdf <- function(f) {
  if (!file.exists(f) || file.size(f) < 1000) return(FALSE)
  identical(readBin(f, "raw", 4), charToRaw("%PDF"))
}

descargar_pdf <- function(url, destino) {
  ok <- tryCatch({
    utils::download.file(url, destino, mode = "wb", quiet = TRUE,
                         headers = c("User-Agent" = paste0("Mozilla/5.0 (", email, ")")))
    TRUE
  }, error = function(e) FALSE, warning = function(w) FALSE)
  if (ok && es_pdf(destino)) return(TRUE)
  if (file.exists(destino)) file.remove(destino)
  FALSE
}

# ---- Proceso -------------------------------------------------------------------
pendientes <- cand[!cand$B01_UT %in% hechos, ]
cat("Candidatos:", nrow(cand), "| ya procesados:", nrow(cand) - nrow(pendientes),
    "| por procesar:", nrow(pendientes), "\n")

nuevos <- vector("list", nrow(pendientes))
for (i in seq_len(nrow(pendientes))) {
  r <- pendientes[i, ]
  doi <- trimws(r$B02_DOI)
  archivo <- sprintf("EDU_%s_%04d_%s.pdf", r$A04_estrato, r$posicion_estrato,
                     sub("WOS:", "", r$B01_UT))
  fila <- data.frame(A03_posicion = r$A03_posicion, A04_estrato = r$A04_estrato,
                     posicion_estrato = r$posicion_estrato, B01_UT = r$B01_UT,
                     B02_DOI = doi, is_oa = NA, version = NA, licencia = NA,
                     url_pdf = NA, url_landing = NA,
                     enlace_doi = ifelse(doi == "" | is.na(doi), NA, paste0("https://doi.org/", doi)),
                     estado = NA, archivo = NA, stringsAsFactors = FALSE)

  if (is.na(doi) || doi == "") {
    fila$estado <- "sin_DOI"
  } else {
    up <- consultar_unpaywall(doi)
    if (is.null(up)) {
      fila$estado <- "error"
    } else {
      fila$is_oa <- isTRUE(up$is_oa)
      loc <- up$best_oa_location
      if (!is.null(loc)) {
        fila$version     <- if (is.null(loc$version)) NA else loc$version
        fila$licencia    <- if (is.null(loc$license)) NA else loc$license
        fila$url_pdf     <- if (is.null(loc$url_for_pdf)) NA else loc$url_for_pdf
        fila$url_landing <- if (is.null(loc$url_for_landing_page)) NA else loc$url_for_landing_page
      }
      if (!fila$is_oa) {
        fila$estado <- "no_OA_buscar_UCM"
      } else if (!is.na(fila$url_pdf) &&
                 descargar_pdf(fila$url_pdf, file.path(dir_pdf, archivo))) {
        fila$estado  <- "descargado"
        fila$archivo <- archivo
      } else {
        fila$estado <- "OA_descarga_manual"
      }
    }
  }
  nuevos[[i]] <- fila
  cat(sprintf("[%d/%d] %s %s -> %s\n", i, nrow(pendientes), r$A04_estrato,
              r$B01_UT, fila$estado))
  Sys.sleep(pausa)

  # guarda el avance cada 25 artículos
  if (i %% 25 == 0 || i == nrow(pendientes)) {
    tmp <- rbind(log[log$B01_UT %in% hechos, , drop = FALSE],
                 do.call(rbind, nuevos[seq_len(i)]))
    tmp <- tmp[order(tmp$A03_posicion), ]
    write.csv(tmp, f_log, row.names = FALSE, fileEncoding = "UTF-8", na = "")
  }
}

# ---- Resumen ---------------------------------------------------------------------
log <- read.csv(f_log, stringsAsFactors = FALSE, encoding = "UTF-8")
cat("\nResumen por estrato y estado:\n")
print(table(log$A04_estrato, log$estado))
