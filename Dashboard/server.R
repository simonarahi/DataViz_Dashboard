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
library(forcats)
library(tidyr)

shinyServer(function(input, output, session) {
    
    states <- reactiveFileReader(
        intervalMillis = 10000, 
        session = session,
        filePath = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv',
        readFunc = read_csv)
    
    corona <-  reactiveFileReader(
        intervalMillis = 10000, 
        session = session,
        filePath = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv',
        readFunc = read_csv)


    output$mymap <- renderPlot({
        counties <- map_data("county") %>% filter(region=="florida")
        corona1 <- corona() %>% group_by(county) %>% summarise(Cases=sum(cases)) %>% mutate(County=tolower(county)) %>% mutate(County = fct_recode(County, `miami-dade` = "dade", `st johns` = "st. johns", `st lucie` = "st. lucie"))
        
        covidmap <- left_join(corona1, counties, by=c("County"="subregion"))
        
        p1 <- ggplot(covidmap, aes(x = long, y = lat, group = group, fill = Cases)) + 
            geom_polygon(color = "black", size = 0.5) + theme_minimal() +
            scale_fill_viridis_c() +
            labs(fill="Number of Cases")
        
        return(p1)
    })
    
    output$mydata <- renderTable({
        
        corona2 <- corona() %>% filter(state == "Florida") %>%
            #filter(date==)
            group_by(county) %>% summarise(Cases=as.integer(sum(cases)), Deaths=as.integer(sum(deaths)))
        return(corona2)
    })
    
    observeEvent(input$state, {
        counties = corona() %>%
            filter(state == input$state) %>% 
            pull(county)
        counties = c("<all>", sort(unique(counties)))
        updateSelectInput(session, "county", choices=counties, selected=counties[1])
    })
    
    # states = sort(unique(allData$`Country/Region`))
    # 
    # updateSelectInput(session, "country", choices=countries, selected="China")
    

    output$myplot <- renderPlot({
        corona3 <- corona() %>% 
            group_by(date) %>%
            summarize(sumcases=sum(cases)) %>%
            select(date,sumcases) %>% 
            mutate(
                time=c(0,cumsum(as.numeric(diff(date)))),
                logsumcases = log(sumcases)
            ) %>%
            select(date, time, sumcases, logsumcases)
        
        colnames(corona3) <- c("date", "time", "cases", "logcases")
        cutoff <- "2020/04/01"
        corona3 <- corona3 %>% filter(date<=cutoff)
        plotdata <- pivot_longer(corona3, col=3:4, names_to="Type", values_to="values")
        
        ggplot(data=plotdata, aes(x=date, y=values)) +
            geom_point(size=1.1) +
            geom_line() +
            facet_wrap(vars(Type), scales = "free_y")
        
    })
    
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
