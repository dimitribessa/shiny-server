#mapa versao 0.1

library('shiny')
library('plotly')
library('dplyr')
library('reshape2')
library('stringr')

load('data.RData')
#options(encoding = 'UTF-8')

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
