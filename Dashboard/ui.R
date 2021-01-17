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
library(lubridate)

sidebar <- dashboardSidebar(
    sidebarMenu(
      sliderInput("date", "Select Date:",
                  min = as.Date("2020-03-1"), max = today(), value = as.Date("2020-04-2"), timeFormat = "%Y-%m-%d"),
        menuItem("Dashboard", tabName = "1", icon = icon("dashboard")),
        
        menuItem("Plots", tabName = "2", icon = icon("chart-line"))  
    )
  
    )

body <- dashboardBody(
    tabItems(
        tabItem(tabName = "1",
                fluidRow(
                  box(title = "What to Plot", width = 4, height=5, solidHeader = FALSE, color="purple",
                      radioButtons("options", "Select Output:", c("Cases"="cases", "Deaths"="deaths"), inline = TRUE), plotOutput("mapchart")),
                  infoBoxOutput(width=4, "nrows"),
                  infoBoxOutput(width=4, "ncol")
                ),
                fluidRow(
                    box(title = "COVID-19 Florida Map by County", plotOutput("mymap")),
                    box(title = "Cases and Deaths by County", 
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
                    box(title = "Coronavirus Cases Over Time", solidHeader = TRUE, status = "primary",
                        plotOutput("myplot")),
                    box(title = "Fitted Model", solidHeader = TRUE, status="info", plotOutput("myplot2"))
                    
                        
                    
                ))
    ))
    

    )

dashboardPage(
    dashboardHeader(title = "COVID-19 Dashboard"),
    sidebar,
    body
)

