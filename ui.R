library(shiny)
library(shinydashboard)
library(leaflet)

dashboardPage(
  skin = c("yellow") ,
  dashboardHeader(title = "Philadelphia Indego Bike", titleWidth = 300),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Map of Philadelphia", tabName = "map", icon = icon("map")),
      menuItem("Date", tabName = "graphs1", icon = icon("calendar", lib = "glyphicon")),
      menuItem("Stations", tabName = "graphs2", icon = icon("signal", lib = "glyphicon")),
      menuItem("About", tabName = "about", icon = icon("bicycle")),
      menuItem("Source Code", href = "https://github.com/Echohoho/shiny_homework", icon = icon("window-maximize"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "map",
              fluidRow(
                column(width = 8,
                       box(width = NULL,
                           leafletOutput("indego_map", height = 500))
                ),
                column(width = 3,
                       box(width = NULL,
                           dateRangeInput("date1", "Select dates to visualize.",
                                          start = "2017-01-01", end = "2017-03-31",
                                          min = min(indego$indegodate), max = max(indego$indegodate))
                       ),
                       box(width = NULL,
                           h3("Total Trips"),
                           h4(textOutput("total_trips"))),
                       box(width = NULL,
                           h3("Most Popular Station"),
                           h4(textOutput("most_popular_station")))
                )
              )
      ),
      tabItem(tabName = "graphs1",
              fluidRow(
                column(width = 12,
                       box(width = NULL,
                           plotOutput("daily_plot")))
              ),
              fluidRow(
                column(width = 3,
                       box(width = NULL,
                           dateRangeInput("date2", "Select dates to visualize.",
                                          start = "2017-01-01", end = "2017-03-31",
                                          min = min(indego$indegodate), max = max(indego$indegodate))
                       )
                )
              )),
      tabItem(tabName = "graphs2",
              fluidRow(
                column(width = 12,
                       box(width = NULL,
                           plotOutput("stat_plot_start"))),
                column(width = 12,
                       box(width = NULL,
                           plotOutput("stat_plot_end")))
              )
            ),
      
      tabItem(tabName = "about",
              fluidRow(
                column(width = 6,
                       box(width = NULL,
                           includeMarkdown("about.md")
                       ))
              )
      )
    )
  )
)