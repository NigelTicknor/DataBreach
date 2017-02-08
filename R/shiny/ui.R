###
# ui.R - Shiny Client
# Author: Nigel Ticknor
##

library(shiny)
library(shinydashboard)
library(dplyr)
library(maps)
library(ggplot2)
library(ggthemes)
library(treemap)

#Category Options
copts <- unique(breachdata$Category)

#Main Page
dashboardPage(title="Data Breaches",
  skin='green',
  dashboardHeader(title="Data Breaches"),
  dashboardSidebar(    sidebarMenu(
    #Setting up the tabs
    menuItem("Maps", tabName = "tab_maps", icon = icon("map")),
    menuItem("General Dashboard", tabName = "tab_other", icon = icon("tachometer")),
    menuItem('Analyses',icon=icon('area-chart'),
             menuItem('Analysis of Category',tabName='tab_anal_cat',icon=icon('bar-chart')),
             menuItem('Analysis of Year & Month',tabName='tab_anal_line',icon=icon('line-chart'))
    ),
    menuItem("Final Report", tabName='tab_report',icon=icon('file-text-o')),
    menuItem("Final Presentation", icon=icon('desktop'),newtab = TRUE,
             href='https://docs.google.com/presentation/d/1gPf4JkG8-u0crACBrKArQGh2UPtQ6mCiKxXlXoYXA5A/embed?start=false&loop=false&delayms=10000'),
    menuItem('Source Code', tabName='tab_code', icon=icon('code')),
    menuItem('Contributors',tabName='tab_people',icon=icon('user-circle'))
  )),
  dashboardBody( #Main body of the page
    tags$head(
      tags$script(src = 'breachdata.js'),
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
      tags$head(tags$link(rel="shortcut icon", href="favicon.ico"))
      ),
    tabItems(
    # Maps Tab
    tabItem(tabName = "tab_maps",title='DataBreach Maps',
            fluidRow(
              box(width=12,plotOutput("plot_maps",height='600px'),
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
    # Other Graphs Tab
    tabItem(tabName = "tab_other",title='DataBreach Dashboard',
            fluidRow(
              box(id='box_loess',onclick="goBox(1)",plotOutput('plot_loess'),uiOutput('sub_loess')),
              box(id='box_tree',onclick="goBox(0)",plotOutput('plot_tree'),uiOutput('sub_tree')),
              box(id='box_months',onclick="goBox(1)",plotOutput('plot_months'),uiOutput('sub_months')),
              box(id='box_bar',onclick="goBox(0)",plotOutput('plot_bar'),uiOutput('sub_bar'))
            )),
    # Report Tab
    tabItem(tabName='tab_report',title='DataBreach Report',
           fluidPage(box(id='reportDiv',width=10))),
    # Code Tab
    tabItem(tabName='tab_code',title='DataBreach Code',
            box(width=12,id='codeDiv')
            ),
    # Contributors Tab
    tabItem(tabName='tab_people',title='DataBreach Contributors',
        fluidRow(
          box(id='box_nigel',d_name='Nigel Ticknor',d_desc='Nigel is a Computer Science major in the 2019 graduating class of Cornell College. His main contributions to this project were the data cleaning, Shiny Dashboard, and PowerPoint slides. In his free time, Nigel likes to write short films and flirt with Nobuki Harata. A little known fact about Nigel is that his favorite color is green.'),
          box(id='box_paul',d_name='Paul DeMange',d_desc='Paul is a Computer Science major in the 2019 graduating class of Cornell College. His main contributions to this project were data scraping, line graphs, and PowerPoint slides. In his free time, Paul likes to add on to the list of national data breaches. A little known fact about Paul is that his favorite Linux distribution is Kali Linux.')),
        fluidRow(
          box(id='box_shaun',d_name='Shaun Boerner',d_desc='Shaun is a Computer Science major with an Economics & Business minor in the 2018 graduating class of Cornell College. His main contributions to this project were heatmaps, other miscellaneous graphs, and his work on the papers. In his free time he likes to stare blankly at a screen. A little known fact about Shaun is that he is not in Kansas anymore.'),
          box(id='box_eli',d_name='Eli Hartman',d_desc='Eli is a Math and Data Analytics double major in the 2019 graduating class of Cornell College. His main contribution to the project was his writing for the papers. In his free time he likes to play with expensive pieces of cardboard. A little known fact about Eli is that he loves his dogs.')
    )),
    #Analysis of Category & Paper Data
    tabItem(tabName = 'tab_anal_cat',title='DataBreach Analyzation: Category',
        fluidRow(
          box(id='box_anal_bar',onclick="clickBox('anal_bar')",plotOutput('plot_anal_bar')),
          box(id='box_anal_bar2',onclick="clickBox('anal_bar2')",plotOutput('plot_anal_bar2'))
        ),
        fluidRow(                                  #This basically builds a placement div for ajax
          box(width=12,id='anal_content_category',uiOutput('fullanal_cat',style='font-size:18px;'))
        )),
    #Analysis of Yearly & Monthly data
    tabItem(tabName = 'tab_anal_line',title='DataBreach Analyzation: Yearly & Monthly',
        fluidRow(
          box(id='box_anal_loess',onclick="clickBox('anal_loess')",plotOutput('plot_anal_loess')),
          box(id='box_anal_months',onclick="clickBox('anal_months')",plotOutput('plot_anal_months'))
        ),
        fluidRow(
          box(width=12,id='anal_content_yearmonth',uiOutput('fullanal_line',style='font-size:18px;'))
        ))
  )
 )
)