#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(shinyjs)

sidebar <- dashboardSidebar(
    sidebarMenu(
      sliderInput("date", "Select Date:",
                  min = as.Date("2020-01-10"), max = as.Date("2020-04-10"), value = as.Date("2020-04-10"), timeFormat = "%Y-%m-%d"),
        menuItem("Dashboard", tabName = "1", icon = icon("dashboard")),
        
        menuItem("Plots", tabName = "2", icon = icon("chart-line"))  
    )
  
    )

body <- dashboardBody(
    tabItems(
        tabItem(tabName = "1",
                fluidRow(
                  box(title = "Select Options to Plot", width = 4, solidHeader = TRUE, color="purple", "BOx"),
                  infoBoxOutput(width=4, "nrows"),
                  infoBoxOutput(width=4, "ncol")
                ),
                fluidRow(
                    box(title = "COVID-19 Florida Map by County", plotOutput("mymap")),
                    box(title = "Data Frame", 
                        status = "warning", solidHeader = TRUE,
                            tableOutput("mydata")
                    )
                )
                
                ),
                
        tabItem(tabName = "2",
                fluidRow(column(4, selectizeInput("state", label=h5("State"), choices=NULL, width="100%")
                  ),
                  column(4, selectizeInput("county", label=h5("County"), choices=NULL, width="100%")
                  ),
                fluidRow(
                    box(title = "Time Series Graph", solidHeader = TRUE,
                        plotOutput("myplot")),
                    box(title = "Forecasting", solidHeader = TRUE, plotOutput("myplot2"))
                    
                        
                    
                ))
    ))
    

    )

dashboardPage(
    dashboardHeader(title = "My Dashboard"),
    sidebar,
    body
)

