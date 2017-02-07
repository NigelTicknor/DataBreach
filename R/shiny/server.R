library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  output$plot_maps <- renderPlot({
    
    yrs <- c(input$year)
    if('All Years' %in% input$opts){
      yrs <- unique(breachdata$Year)
    }
    cats <- c(input$cat_fin,input$cat_bus,input$cat_gov,input$cat_edu,input$cat_med)
    
    if(input$maptype=='map_heat'){
      drawHeatMap(yrs,input$category,'Per Capita' %in% input$opts)}
    else{
      drawCatMap(yrs)
    }
    
  })
  
  output$plot_loess <- renderPlot({
    drawLoess()
  })
  output$plot_tree <- renderPlot({
    drawTree()
  })
  output$plot_months <- renderPlot({
    drawMonths()
  })
  output$plot_bar <- renderPlot({
    drawBar()
  })
})