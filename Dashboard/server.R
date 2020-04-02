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

shinyServer(function(input, output, session) {
    
    df <- reactiveFileReader(
        intervalMillis = 10000, 
        session = session,
        filePath = 'https://raw.githubusercontent.com/simonarahi/DataViz_Dashboard/master/counties.csv',
        readFunc = read_csv)
    
    output$mydata <-renderTable({df()})
    #countydata <- map_data("county") %>% filter(region=="florida") %>% drop_na()
    #output$mydata <-renderTable({df()})
  
    # countydata <- map_data("county") %>% filter(region=="florida") %>% drop_na()
    # covidmap <- left_join(counties.cases, countydata, by=c("County"="subregion"))
    # 
    # output$myplot <- renderPlot({
    #     df <- df()
    #     p <- ggplot(covidmap, aes(x=long, y=lat, group=group, fill=wbmap$n)) + 
    #         geom_polygon(color="black", size=0.5) + theme_minimal() + 
    #         coord_map(projection = "mercator", xlim=c(-90, -77), ylim=c(23, 33)) + 
    #         labs(title="COVID-19 Cases in Florida by County", fill="Number of Cases") 
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
