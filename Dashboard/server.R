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
library(broom)
library(deSolve)

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
         corona1 <- corona() %>% group_by(county) %>% summarize(Cases=sum(cases)) %>% mutate(County=tolower(county)) %>% mutate(County = fct_recode(County, `miami-dade` = "dade", `st johns` = "st. johns", `st lucie` = "st. lucie"))
    
         covidmap <- left_join(corona1, counties, by=c("County"="subregion"))
    
         p1 <- ggplot(covidmap, aes(x = long, y = lat, group = group, fill = Cases)) +
             geom_polygon(color = "black", size = 0.5) + theme_minimal() +
             scale_fill_viridis_c() +
             labs(fill="Number of Cases")
    
         return(p1)
     })

    output$mydata <- renderTable({
        
        corona2 <- corona() %>% filter(state == "Florida") %>%
            filter(date==input$date) %>%
            group_by(county) %>% summarise(Cases=as.integer(sum(cases)), Deaths=as.integer(sum(deaths)))
        return(corona2)
    })
    
     # output$mapchart <- renderPlot({
     #     maps <- switch(input$options, cases=hg, death=fgf, cases)
     # })
    
    data = reactive({
        d = corona() %>%
            filter(state == input$state)
        if(input$county != "<all>") {
            d = d %>% 
                filter(county == input$county) 
        } else {
            d = corona()
        }
    })
    
    observeEvent(input$state, {
        counties = corona() %>%
            filter(state == input$state) %>% 
            pull(county)
        counties = c("<all>", sort(unique(counties)))
        updateSelectInput(session, "county", choices=counties, selected=counties[1])
    })
    
    observeEvent(input$county, {
        corona <- corona()
        states = sort(unique(corona$state))
        updateSelectInput(session, "state", choices=states, selected="Alabama") 
    })


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
         #cutoff <- "2020/04/01"
         corona3 <- corona3 %>% filter(date<=input$date)
         plotdata <- pivot_longer(corona3, col=3:4, names_to="Type", values_to="values")

         ggplot(data=plotdata, aes(x=date, y=values)) +
             geom_point(size=1.1) +
             geom_line() +
             facet_wrap(vars(Type), scales = "free_y") + theme_minimal()

     })
     
     # output$myplot2 <- renderPlot({
     #     corona1 <- corona() %>% 
     #         group_by(date) %>%
     #         summarize(sumcases=sum(cases)) %>%
     #         select(date,sumcases) %>% 
     #         mutate(
     #             time=c(0,cumsum(as.numeric(diff(date)))),
     #             logsumcases = log(sumcases)
     #         ) %>%
     #         select(date, time, sumcases, logsumcases)
     #     
     #     colnames(corona1) <- c("date", "time", "cases", "logcases")
     #     fit.lm <- lm(logcases ~ time, data=corona1)
     #     gamma <- 1/8
     #     beta <- as.numeric(tidy(fit.lm)[2,2]) + gamma
     #     alpha <- exp(as.numeric(tidy(fit.lm)[1,2]))
     #     times <- seq(0,40,1)
     #     initial.parameters <- c(beta  = 0.5, gamma = 1/10 )
     #     
     #     initial.group <- c(S = 100000, I = 1, R = 0)
     #     
     #     times <- seq(0, 90, 0.5)
     #     
     #     SIRmodel <- function(time, group, parameters) {
     #         S <- group[1]; I <- group[2];  R <- group[3]
     #         N <- S + I + R
     #         beta <- parameters[1]; gamma <- parameters[2]
     #         dS <- -beta*S*I/N
     #         dI <- +beta*S*I/N - gamma*I
     #         dR <- gamma*I
     #         list(c(dS, dI, dR))
     #     }
     #     
     #     solution <- lsoda(
     #         y = c(S=800000, I=alpha, R=0),
     #         times = times,
     #         func = SIRmodel,
     #         parms = c(beta=beta, gamma=gamma))
     #     result <- data.frame(solution)[,c(1,3)]
     #     result <- result %>% mutate(date = seq(as.Date(corona1$date[1]), by = "day", length.out = length(time)))
     #     
     #     ggplot(data=result, aes(x=date, y=I)) + 
     #         geom_line(size=1.0, col="blue") +
     #         geom_point(data=corona1, aes(x=date, y=cases), col="red", inherit.aes = FALSE) +
     #         scale_x_date(date_breaks="5 days", date_label="%b %d") +
     #         labs(subtitle="Recovery Period is assumed as 8 days", x="Day", y="Number Infected")
     #     
     # })


    output$nrows <- renderInfoBox({
        val1 <- corona() %>% filter(state == "Florida") %>%
            group_by(county) %>% summarize(Deaths=as.integer(sum(deaths)))
        nr <- sum(val1$Deaths)
        infoBox(
            value = nr,
            title = "Total Deaths",
            icon = icon("ambulance"),
            color = "red",
            fill = TRUE
        )
    })

    output$ncol <- renderInfoBox({
        val <- corona() %>% filter(state == "Florida") %>%
            group_by(county) %>% summarize(Cases=as.integer(sum(cases)))
        nc <- sum(val$Cases)
        infoBox(
            value = nc,
            title = "Total Cases",
            icon = icon("heartbeat"),
            color = "purple",
            fill=TRUE)
    })
    
})
