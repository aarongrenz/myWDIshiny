library(WDI)
library(shiny)
library(datasets)
library(dplyr)
library(ggplot2)
suppressPackageStartupMessages(library(googleVis))
shinyServer(function(input, output) {

  output$choroplethplot <- renderGvis({
    df=WDI(country = "all", indicator =input$indicator ,
           start = input$Year, end = input$Year, extra = FALSE, cache = NULL)
    
    myData=na.omit(df)
    colnames(myData)=c("iso2c","country","Indicator","year")
    gvisGeoChart(myData,locationvar="country",colorvar="Indicator")
  })
  
  #############################################
  
  output$lowHigh <- renderPlot({
    df2=WDI(country = "all", indicator =input$indicator ,
           start = input$Year, end = input$Year, extra = FALSE, cache = NULL)

    myData2=na.omit(df2)
    colnames(myData2)=c("iso2c","country","Indicator","year")
    
    ass1=myData2 %>%
      arrange(-Indicator) %>%
      head(5)
    
    ass2=myData2 %>%
      arrange(Indicator) %>%
      head(5)
    
    ass3 <- rbind(ass1,ass2)
    
    ggplot(ass3, aes(x=reorder(country,-Indicator), y=Indicator, fill=country)) + geom_bar(stat="identity") + theme_bw() + xlab("Country") + ggtitle("Top 5 versus Bottom 5") + theme(axis.text.x = element_text(angle=-90), axis.text.y = element_blank()) + theme(legend.position="none")
  })
  
  #############################################
  
  output$motion <- renderGvis({
    df3=WDI(country = "all", indicator = "SP.DYN.LE00.FE.IN",
            start = "1980", end = "2010", extra = FALSE, cache = NULL)
    
    myData3=na.omit(df3)
    colnames(myData3)=c("iso2c","country","Female","year")
    
    df4=WDI(country = "all", indicator = "SP.DYN.LE00.MA.IN" ,
            start = "1980", end = "2010", extra = FALSE, cache = NULL)
    
    myData4=na.omit(df4)
    colnames(myData4)=c("iso2c","country","Male","year")
    
    initial <- myData3 %>%
      mutate(myData4$Male) 
    
    colnames(initial)=c("iso2c","country","Female","year","Male")
    
    combined <- initial %>%
      select(country,year,Female,Male)
    
    gvisMotionChart(combined, "country", "year", options=list(width=1000, height=500))
    
  })
  
  #############################################
  
  output$scatter <- renderPlot({
    df5=WDI(country=c("XD","XP","XM"), indicator = "SP.POP.BRTH.MF",
            start = "1982", end = "2010", extra = FALSE, cache = NULL)
    
    myData5=na.omit(df5)
    colnames(myData5)=c("iso2c","country","SexRatio","year")
    
    ggplot(myData5, aes(x=year, y=SexRatio, color=country)) + geom_line() + geom_point() + 
      theme_bw() +   xlab("Economic Class") + ylab("Sex Ratio") + 
      ggtitle("Sex Ratio for Economic Class")
    
  })
 

})