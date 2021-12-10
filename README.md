# Graficas-clima-organizacional
Este repositorio contiene los códigos y herramientas necesarias para generar las gráficas y resultados del cuestionario de clima organizacional.

## Contenido
- **Ejemplo de base de datos.** El archivo "Respuestas-prueba.xlsx" en la carpeta "01_datos_brutos" tiene un ejemplo sobre cómo deben estar organizadas las respuestas al cuestionario para que este este código funcione. **Es importante que los resultados finales estén en la misma carpeta y formato que este ejemplo.**
- **Ejemplo de gráficas.** La carpeta "02_graficas" contiene ejemplos de cómo deben quedar las gráficas tras generar los resultados. 
- **Script/código.** El Rscript llamado "Graficas-clima-organizacional.R" contenido en la carpeta de "03_codigos" tiene el código necesario para generar las gráficas presenten en la carpeta "02_graficas".
- **Libro de códigos.** El documento "Libro de códigos.xlsx" de la carpeta "05_documentos" contiene la pregunta o definición del Ejemplo de bases de datos. Este archivo es necesario para generar las gráficas también. 


## Prerequisitos 
- Tener [R con una versión posterior a la 3.6](https://cran.r-project.org/mirrors.html)
- Es muy recomendable instalar [RStudio Desktop](https://www.rstudio.com/products/rstudio/download/)

## Cómo usarlo
Para generar las gráficas es importante tener el archivo de resultados del cuestionario en el formato y ubicación correspondiente, así como tener instalados los programas antes señalados. Teniendo listo todo ello, hay que seguir los siguientes pasos. 
1. En caso de haber instalado RStudio, abrir el proyecto con el proyecto "Graficas-clima-organizacional.Rproj" suelto en esta carpeta. Si no tener Rstudio, abrir directamente la versión instalada de R. 
2. Abrir el Rscript "Graficas-clima-organizacional.R" con R o RStudio. 
3. Una ves abierto el archivo, se va a reemplazar las secciones que indican el [Nombre del documento] con el nombre del archivo con los resultados finales del cuestionario.
4. Ejecutar el script "Graficas-clima-organizacional.R".

