library(shiny)
library(ggplot2)
library(data.table)
library(maps)
library(rCharts)
library(reshape2)
library(markdown)
library(mapproj)

states_map <- map_data("state")
##dt <- fread('data/repdata-data-StormData.csv')
reduced.storm.data <- read.csv(bzfile("repdata-data-StormData.csv.bz2"), header = TRUE,nrows=10000)
##dt <- dt[1:1000,c("EVTYPE", "FATALITIES", "INJURIES", "PROPDMG", "CROPDMG","PROPDMGEXP", "CROPDMGEXP","STATE")]



dt$EVTYPE <- tolower(dt$EVTYPE)
evtypes <- sort(unique(reduced.storm.data$EVTYPE))





  agg.fatalities.data <- aggregate(
    reduced.storm.data$FATALITIES, 
    by=list(reduced.storm.data$EVTYPE), FUN=sum, na.rm=TRUE)
  
  colnames(agg.fatalities.data) = c("event.type", "fatality.total")
  
  #Filter only event types selected at frontend
  #agg.fatalities.data <- agg.fatalities.data[event.type %in% c("tornado","hail") ]
  
  fatalities.sorted <- 
    agg.fatalities.data[order(-agg.fatalities.data$fatality.total),] 
  
  top.fatalities <- fatalities.sorted[1:10,]
  
  top.fatalities$event.type <- 
    factor(
      top.fatalities$event.type, levels=top.fatalities$event.type, 
      ordered=TRUE)
  top.fatalities
  