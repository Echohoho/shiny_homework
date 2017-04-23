# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(dplyr)
library(leaflet)
library(ggplot2)
library(lubridate)
# use lubridate to manipulate with time


shinyServer(function(input, output, session) {
  filtered_indego <- reactive({
    input$date1
    
    isolate({
      indego %>%
        filter(indegodate >= input$date1[1]) %>%
        filter(indegodate <= input$date1[2])
    })
  })
  
  observe({
    input$date1
    
    updateDateRangeInput(session, "date2",
                         "Select dates to visualize.",
                         start = input$date1[1],
                         end = input$date1[2],
                         min = min(indego$indegodate), max = max(indego$indegodate))
  })
  
  observe({
    input$date2
    
    updateDateRangeInput(session, "date1",
                         "Select dates to visualize.",
                         start = input$date2[1],
                         end = input$date2[2],
                         min = min(indego$indegodate), max = max(indego$indegodate))
  })
  
  output$indego_map <- renderLeaflet({
    filtered_indego() %>%
      leaflet() %>%
      setView(lng = "-75.163487", lat = "39.952494", zoom = 12) %>%
      addTiles() %>%
      addMarkers(clusterOptions = markerClusterOptions()
      )
    
  })
  output$total_trips <- renderText({
    as.character(nrow(filtered_indego()))
  })
  
    output$most_popular_station <- renderText({
    names(tail(sort(table(filtered_indego()$start_station)), 1))
    })
    
    output$daily_plot <- renderPlot({
      daily_indego <- filtered_indego() %>%
        group_by(indegodate) %>%
        summarize(trips_per_day = n())
      
      ggplot(daily_indego, aes(indegodate, trips_per_day)) + geom_bar(stat = "identity") + scale_fill_brewer(palette = "blues")
    })
    
    output$stat_plot_start <- renderPlot({
      stat_num <- filtered_indego() %>%
        group_by(start_station_id) %>%
        summarize(Total_start = n())
      
      ggplot(stat_num, aes(start_station_id, Total_start)) + geom_bar(stat = "identity", fill="#9ad71f") 
    })
 
    output$stat_plot_end <- renderPlot({
      stat_num <- filtered_indego() %>%
        group_by(end_station_id) %>%
        summarize(Total_start = n())
      
      ggplot(stat_num, aes(end_station_id, Total_start)) + geom_bar(stat = "identity", fill="#ff7651") 
    })
})