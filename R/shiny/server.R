###
# server.R - Shiny Server
# Author: Nigel Ticknor
##

library(shiny)

#Server Function
shinyServer(function(input, output) {
  output$plot_maps <- renderPlot({
    
    #Year Value Selector
    yrs <- c(input$year)
    if('All Years' %in% input$opts){
      yrs <- unique(breachdata$Year)
    }
    cats <- c(input$cat_fin,input$cat_bus,input$cat_gov,input$cat_edu,input$cat_med)
    
    #Heatmap Options
    if(input$maptype=='map_heat'){
      drawHeatMap(yrs,input$category,'Per Capita' %in% input$opts)}
    else{
      drawCatMap(yrs)
    }
    
  })
  
  #Plot Outputs - Pulled from Graphs.R
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
  output$plot_anal_bar <- renderPlot({
    drawBar()
  })
  output$plot_anal_bar2 <- renderPlot({
    drawBar2()
  })
  output$plot_anal_loess <- renderPlot({
    drawLoess()
  })
  output$plot_anal_months <- renderPlot({
    drawMonths()
  })
  
  output$sub_loess <- renderText('The amount of breaches is steadily increasing, after a dip caused by the Cyber Security Act of 2010.')
  output$sub_tree <- renderText('Focus more on securing your electronic data, as there is a greater chance from an external attack. Click on the graph to learn more.')
  output$sub_months <- renderText('January, March, July, and October are your riskiest months.')
  output$sub_bar <- renderText('Banks are the most secure entities; businesses and hospitals are the most breached. Click on the graph to learn more.')
  
})