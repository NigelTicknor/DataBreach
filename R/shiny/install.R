##
#install.R - Installs all packages
#!!!!!! MUST RUN AS ROOT !!!!!!
##

plist <- c('shiny','shinydashboard','rmarkdown','dplyr','maps','ggplot2', 'ggthemes','treemap')
npac <- plist[!(plist %in% installed.packages()[,"Package"])]
if(length(npac)>0) install.packages(npac)