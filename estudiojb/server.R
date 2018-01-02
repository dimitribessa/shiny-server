#mapa versao 0.1

library('shiny')
library('plotly')
library('dplyr')
library('reshape2')
library('stringr')
#setwd('D:\\Dimitri\\Docs 17-out-15\\Ju html\\Treino OnLine')
#treino <- read.xlsx('08nov2017.xlsx', sheetIndex = 3, encoding = 'UTF-8')
load('/data.RData')


shinyServer(function(input, output) {
  
  ds<- reactive({
    data1 <- treino[treino$Treino == input$treino,] 
    data1})              
  
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- ds()
    data
  }))                 
})                 
