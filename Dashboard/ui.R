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

dashboardPage(
    dashboardHeader(title = "My Dashboard"),
    dashboardSidebar(
        sliderInput("size", "Size of Points:", min=0.2, max=5, value=2)
    ),
    dashboardBody(
        # Boxes need to be put in a row (or column)
        fluidRow(
            box(width=6, 
                status="info", 
                title="Myplot",
                solidHeader = TRUE,
                plotOutput("myplot")
            ),
            box(width=6, 
                status="warning", 
                title = "Data Frame",
                solidHeader = TRUE, 
                collapsible = TRUE, 
                footer="Read Remotely from File",
                tableOutput("mydata")
            )
        ),
        ## Add some more info boxes
        fluidRow(
            valueBoxOutput(width=4, "nrows"),
            infoBoxOutput(width=6, "ncol")
        )
    )
)
