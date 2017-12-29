#mapa versao 0.1

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
