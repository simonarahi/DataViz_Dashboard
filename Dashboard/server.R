#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(ggplot2)
library(readr)
library(maps)
library(mapproj)
library(dplyr)

shinyServer(function(input, output, session) {
    
    states <- reactiveFileReader(
        intervalMillis = 10000, 
        session = session,
        filePath = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv',
        readFunc = read_csv)
    
    counties <-  reactiveFileReader(
        intervalMillis = 10000, 
        session = session,
        filePath = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv',
        readFunc = read_csv)
    
    
    output$mydata <- renderTable({states()})
    # 
    # 
    # output$myplot <- renderPlot({
    #     df <- df()
    #     covidmap <- covidmap()
    #     p <- ggplot(covidmap, aes(x=long, y=lat, group=group, fill=covidmap$n)) +
    #         geom_polygon(color="black", size=0.5) + theme_minimal() +
    #         coord_map(projection = "mercator", xlim=c(-90, -77), ylim=c(23, 33)) +
    #         labs(fill="Number of Cases")
    #     return(p)
    # })
    # 
    # output$nrows <- renderValueBox({
    #     nr <- nrow(df())
    #     valueBox(
    #         value = nr,
    #         subtitle = "Number of Rows",
    #         icon = icon("table"),
    #         color = if (nr <=6) "yellow" else "aqua"
    #     )
    # })
    # 
    # output$ncol <- renderInfoBox({
    #     nc <- ncol(df())
    #     infoBox(
    #         value = nc,
    #         title = "Colums",
    #         icon = icon("list"),
    #         color = "purple",
    #         fill=TRUE)
    # })
    
})
