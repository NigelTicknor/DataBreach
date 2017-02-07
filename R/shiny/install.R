list.of.packages <- c('shiny','shinydashboard','rmarkdown','dplyr','maps','ggplot2', 'ggthemes')
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)>0) install.packages(new.packages)