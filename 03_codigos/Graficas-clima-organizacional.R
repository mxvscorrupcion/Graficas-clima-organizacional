############################################################################
##   Proyecto: Generar gráficas del cuestionario de clima organizacional  ##
############################################################################
##
## Descripción:    Este código es para generar las gráficas de los resultados
##                 del cuestionario sobre clima organizacional.
##
## Autor:          Javier Mtz.  
##
## Fecha creac.:   2021-12-09
##
## Email:          javier.martinez@contralacorrupcion.mx
##
## ---------------------------
## Notas:          
## ---------------------------

# Setup ----
## Paquetes a utilizar ----
#' En caso de no tener previamente instalado la librería {pacman}, se tiene
#' que instalar con la siguiente línea (que para estos efectos está comentada)
# install.packages("pacman")

pacman::p_load(tidyverse, janitor, writexl, readxl, scales, ggrepel)

## Especificar locale ----
Sys.setlocale("LC_ALL", "es_ES.UTF-8")

## Desabilitar notación científica.----
options(scipen = 999)

## Funciones importantes ----
### Mi tema ----
#' Estas funciones sirven para establecer un 
tema <- function(...) {
  theme_minimal() +
    theme(text = element_text(family = "Lato"),
          axis.line = element_line(size = 0.3),
          plot.title = element_text(hjust = 0.5, 
                                    size = 14, face = "bold", 
                                    color = "grey20"),
          plot.subtitle = element_text(hjust = 0.5,
                                       size = 12,
                                       color = "gray50"),
          plot.caption =  element_text(color = "gray50",
                                       size = 10, 
                                       hjust = 0),
          panel.grid = element_line(linetype = 2,
                                    size = 0.3,
                                    color = "gray90"),
          # panel.grid = element_blank(),
          panel.grid.minor = element_blank(),
          strip.background = element_rect(fill = "gray95", 
                                          linetype = "blank"),
          panel.border = element_rect(color = "gray95",
                                      fill = NA),
          rect = element_rect(fill = "transparent")) +
    theme(...)
}



# Cargar base de datos de resultados -----
## Generar base de datos de ejemplo -----
#' Ya que aún no existen resultados sobre la encuesta de clima organizacional, 
#' esta sección genera una base de datos de prueba. Para esto se supone que 
#' hay una base de datos de 500 respuestas. En caso de no usarse este documento
#' de prueba, se recomiendo omitirlo. 

set.seed(1234)

bd <- tibble(id_respuesta = sprintf("%05d", 1:500),
             p_1 = sample(c("Muy robustas","Robustas",
                            "Débiles", "Muy débiles"), 
                          size = 500, replace = T, prob = c(.15,.45, .35, .5)),
             p_2 = sample(c("Sí","No"), 
                          size = 500, replace = T, prob = c(.25,.75)),
             p_3 = sample(c("Sí","No"), 
                          size = 500, replace = T, prob = c(.35,.65)),
             p_4 = sample(c("Sí","No"), 
                          size = 500, replace = T, prob = c(.55,.45)),
             p_5 = sample(c("Totalmente de acuerdo","De acuerdo",
                            "Desacuerdo", "Totalmente desacuerdo"), 
                          size = 500, replace = T, prob = c(.25,.45, .25, .5)),
             p_6 = sample(c("Sí","No"), 
                          size = 500, replace = T, prob = c(.25,.75)),
             p_7 = sample(c("Sí","No"), 
                          size = 500, replace = T, prob = c(.55,.45)),
             p_8 = sample(c("Castigados","Impunes"), 
                          size = 500, replace = T, prob = c(.55,.45)),
             p_9 = ".",
             p_10 = sample(c("Sí","No"), 
                           size = 500, replace = T, prob = c(.55,.45)))

write_xlsx(bd, "01_datos_brutos/Respuestas-prueba.xlsx")


## Cargar base de datos real ----
#' Para cargar los resultados del cuestionario de clima organizacional,
#' se recomienda que tenga la misma estructura que el documento generado 
#' en 01_datos_brutos/Respuestas-prueba.xlsx
#' Se recomienda que el archivo con los resultados esté en la carpeta
#' 01_datos_brutos para que sólo se coloque el nombre del archivo en la
#' siguiente línea.
#' Es importante que los resultados estén se manera uniforme para que los
#' resultados no muestren errores. Por ejemplo, debe evitar codificarse 
#' "Sí" con y sin acento en la misma colúmna. 

bd <- read_excel("01_datos_brutos/[Nombre del documento].xlsx") %>%  # Colocar el nombre y ubicación del archivo 
  mutate(across(c(p_1:p_8, p_10), str_to_sentence))

## Cargar codificación de las preguntas ----
lib_codigos <- read_excel("05_documentos/Libro de códigos.xlsx") %>% 
  clean_names()

# Loop para generar gráficas -----
lista_preguntas <- c("p_1",
                     "p_2",
                     "p_3",
                     "p_4",
                     "p_5",
                     "p_6",
                     "p_7",
                     "p_8",
                     "p_10")

for (i in lista_preguntas) {
  
  bd %>% 
    count_(i) %>% 
    rename(pregunta = contains(i)) %>% 
    arrange(n) %>% 
    mutate(fraccion = n/sum(n),
           ymax = cumsum(fraccion),
           ymin = ymax-fraccion,
           pregunta = reorder(pregunta, -n)) %>% 
    ggplot(aes(ymax = ymax, ymin = ymin, 
               xmax = 4, xmin = 3, 
               fill = pregunta)) +
    coord_polar(theta="y") +
    geom_rect() +
    geom_text_repel(aes(label = as.character(paste0("atop(bold(",
                                                    "\"",
                                                    percent(fraccion), 
                                                    "\"",
                                                    "),",
                                                    "\"(",
                                                    comma(n, 
                                                          accuracy = 1L),
                                                    ")\"",
                                                    ")")),
                        x = 4, y = ymin+((ymax-ymin)/2),
                        color = pregunta),
                    parse = T,
                    segment.color = "grey65",
                    segment.size = 0.35,
                    segment.curvature = 0.1,
                    nudge_x = 0.5,
                    nudge_y = 0.04) +
    xlim(c(2, 4.5)) +
    ylim(c(0, 1)) +
    theme_void() +
    theme(legend.position = "top",
          plot.title = element_text(hjust = 0.5, 
                                    size = 14, face = "bold", 
                                    color = "grey20"),
          plot.subtitle = element_text(hjust = 0.5,
                                       size = 12,
                                       color = "gray50"),
          plot.caption =  element_text(color = "gray50",
                                       size = 10, 
                                       hjust = 0.5)) +
    scale_fill_manual(values = c("#c5002a", "#a1d7a3", "#22243c", "#0E9A9D")) +
    scale_color_manual(values =  c("#c5002a", "#a1d7a3", "#22243c", "#0E9A9D")) +
    labs(title = lib_codigos[lib_codigos$codificacion == i,]$tema,
         subtitle = str_wrap(lib_codigos[lib_codigos$codificacion == i,]$pregunta_definicion, 80),
         fill = element_blank(),
         color = element_blank())
  
  ggsave(paste0("02_graficas/",
                i, "_",
                make_clean_names(lib_codigos[lib_codigos$codificacion == i,]$tema),
                ".png"),
         bg = "transparent",
         width = 200,                  # Ancho de la gráfica
         height = 150,
         units = "mm") 
  
}


