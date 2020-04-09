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
        menuItem("Dashboard", tabName = "1", icon = icon("dashboard")
        ),
        menuItem("Plot", tabName = "2")  
    )
  
    )

body <- dashboardBody(
    tabItems(
        tabItem(tabName = "1",
                fluidRow(
                    box(title = "COVID-19 Florida Map by County", plotOutput("mymap")),
                    box(title = "Data Frame", status = "warning", solidHeader = TRUE,
                            tableOutput("mydata"),
                        
                    )
                  
                )
                
                ),
        tabItem(tabName = "2", h2("Plot tab content"))
    )
    
        # Boxes need to be put in a row (or column)
    # fluidRow(
    #     
    #     box(width=6,
    #         status="warning",
    #         title = "Data Frame",
    #         solidHeader = TRUE,
    #         collapsible = TRUE,
    #         footer="Read Remotely from File",
    #         tableOutput("mydata")
    #         )
    #     ),
    #     ## Add some more info boxes
    # fluidRow(
    #     valueBoxOutput(width=4, "nrows"),
    #     infoBoxOutput(width=6, "ncol")
    #     )
    )

dashboardPage(
    dashboardHeader(title = "My Dashboard"),
    sidebar,
    body
)

