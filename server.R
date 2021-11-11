library(ggplot2)
library(shiny)
library(plotly)
library(DT)
library(rworldmap)
library(rworldxtra)
library(leaflet)

function(input, output,session) {
  
  Data = read.csv2("Terremotos.csv")
  
  Data_subset_table = reactive({
    a1 = subset(Data, Date == input$year_table)
    return(a1)
  })
  
  Data_subset_summary = reactive({
    a2 <- subset(Data, Date == input$year_summary)
    return(a2)
  })
  
  Data_subset_boxplot = reactive({
    a3 <- subset(Data, Date == input$year_boxplot)
    return(a3)
  })
  
  Data_subset_scatter = reactive({
    a4 = subset(Data, Date == input$year_scatter)
    return(a4)
  })
  
  Data_subset_map = reactive({
    a5 = subset(Data, Date == input$year_map)
    return(a5)
  })
  
  
  # Generate a summary of the dataset
  output$summary2 = renderText({
    Fecha = Data_subset_summary()$Date[1]
    Num = dim(Data_subset_summary())[1]
    Largest = max(Data_subset_summary()$Magnitude)
    Deepest = max(Data_subset_summary()$Depth)
    MeanLarge = mean(Data_subset_summary()$Magnitude)
    MeanDeep = mean(Data_subset_summary()$Depth)
    
    paste(" In the year",Fecha,"were registered at least",Num,"earthquakes of magnitude 5.5 or higher.\n",
          "The largest earthquake that was measured had",Largest,"degrees.\n",
          "The deepest earthquake had its epicenter at",Deepest,"units.\n",
          "The average magnitude of those earthquakes was",round(MeanLarge,1),"degrees.\n",
          "The average depth of those earthquakes was",round(MeanDeep,1),"units.")
  })
  
  output$summary1 = renderPrint({
    D = Data_subset_summary()
    D = D[,c(4,5,6)]
    summary(D)
  })

  output$BPlot1 = renderPlotly({
    plot_ly(Data_subset_boxplot(), y = Data_subset_boxplot()$Magnitude, 
            color = Data_subset_boxplot()$Type, type = "box") %>% 
      layout(title = "BoxPlot by Type",yaxis=list(title = "Magnitude",range = c(5.5, 9.2)))
  })
  
  output$depth_magnitude = renderPlot({
    ggplot(Data_subset_scatter(), aes(x=Depth , y=Magnitude, 
                                        color = Type)) +
      xlim(0,700) + ylim(5.4,9.2) +
      geom_point(size = 2) + ggtitle("Depth vs. Magnitude")
  })
  
  output$brush_info = renderPrint({
    brushedPoints(Data_subset_scatter(), input$plot1_brush)
  })
  
  output$table = DT::renderDataTable({
    datatable(Data_subset_table(), rownames = TRUE )
  })
  
  output$MapPlot = renderLeaflet({

    Data = Data_subset_map();
    
    qpal <- colorNumeric("RdYlBu", c(5.5,10), n = 6)
        
    leaflet(Data) %>% addTiles() %>%
      addCircleMarkers(lng =Data$Longitude,lat = Data$Latitude,
                       radius = Data$Magnitude,color = qpal(Data$Magnitude),stroke = F,
                 fill = T, label = as.character(Data$Magnitude),fillOpacity = 1) %>%
      addLegend(pal = qpal, values = Data$Magnitude, opacity = 1)
     
  }) 

}