library(shiny)
library(shinydashboard)
library(dplyr)
library(maps)
library(ggplot2)
library(ggthemes)
library(treemap)


copts <- unique(breachdata$Category)
jsfile <- './breachdata.js';

dashboardPage(
  skin='green',
  dashboardHeader(title="Data Breaches"),
  dashboardSidebar(    sidebarMenu(
    menuItem("Maps", tabName = "tab_maps", icon = icon("map")),
    menuItem("Other Graphs", tabName = "tab_other", icon = icon("line-chart")),
    menuItem("Final Report", tabName='tab_report',icon=icon('file-text-o')),
    menuItem('Source Code', tabName='tab_code', icon=icon('code')),
    menuItem('Contributors',tabName='tab_people',icon=icon('user-circle'))
  )),
  dashboardBody(
    tags$head(
      tags$script(src = jsfile),
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
      ),
    tabItems(
    # First tab content
    tabItem(tabName = "tab_maps",
            fluidRow(
              box(width=12,plotOutput("plot_maps",height='600px'),
                #checkboxInput("allyrs", "All Years?",value=TRUE),
                checkboxGroupInput(inputId = "opts", label = "", choices=c('All Years','Per Capita'),selected=c('All Years'),inline=TRUE),
                conditionalPanel(
                  condition = "!input.opts.includes('All Years')",
                  sliderInput("year",
                              "What year:",
                              sep='',
                              min = min(breachdata$Year),
                              max = max(breachdata$Year),
                              value = max(breachdata$Year),
                              dragRange = TRUE)
                ),
                radioButtons("maptype", "Distribution type:",
                             c("Heatmap" = "map_heat",
                               "Category Map" = "map_cat"),inline=TRUE),
                conditionalPanel(
                  condition = "input.maptype == 'map_heat'",
                   checkboxGroupInput(inputId = "category", label = "", choices=copts,selected=copts,inline=TRUE)
                  
                )
              )
            )
    ),
    
    # Second tab content
    tabItem(tabName = "tab_other",
            fluidRow(
              box(id='box_loess',onclick="clickBox('loess')",plotOutput('plot_loess')),
              box(id='box_tree',onclick="clickBox('tree')",plotOutput('plot_tree')),
              box(id='box_months',onclick="clickBox('months')",plotOutput('plot_months')),
              box(id='box_bar',onclick="clickBox('bar')",plotOutput('plot_bar'))
            )
            ),
    tabItem(tabName='tab_report',fluidPage(id='reportDiv')),
    tabItem(tabName='tab_code'),
    tabItem(tabName='tab_people',fluidRow(
      box(id='box_nigel'),
      box(id='box_paul'),
      box(id='box_shaun'),
      box(id='box_eli')
    ))
  )
 )
)