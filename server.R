library(shiny)
library(ggplot2)
library(data.table)
library(maps)
library(rCharts)
library(reshape2)   
library(markdown)
library(mapproj)


dt<- read.csv(bzfile("repdata-data-StormData.csv.bz2"), header = TRUE)
reduced.storm.data <- dt[,c("EVTYPE", "FATALITIES", "INJURIES", "PROPDMG", "CROPDMG","PROPDMGEXP", "CROPDMGEXP","STATE")]




shinyServer(function(input, output) 
{
  
  #Identify fatalities caused by each event type.
  
  agg.fatalities.data <-reactive({ 
    agg.fatalities.data <- aggregate(
      reduced.storm.data$FATALITIES, 
      by=list(reduced.storm.data$EVTYPE), FUN=sum, na.rm=TRUE)
    
  colnames(agg.fatalities.data) = c("event.type", "fatality.total")
  
  
     fatalities.sorted <- agg.fatalities.data[order(agg.fatalities.data$fatality.total,decreasing = TRUE),] 
  
  top.fatalities <- fatalities.sorted[input$range[1]:input$range[2],]
  
  top.fatalities$event.type <- 
    factor(
      top.fatalities$event.type, levels=top.fatalities$event.type, 
      ordered=TRUE)
  top.fatalities
  
  })
  

  output$populationImpactByState <- renderPlot(
    {
      top.fatalities <- agg.fatalities.data()
      ggplot(data=top.fatalities, aes(x=event.type, y=fatality.total)) + 
        geom_bar(stat="identity") + xlab("Event type") + ylab("Total fatalities") + 
        ggtitle("Fatalities By Event Type") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    })
  

 
})