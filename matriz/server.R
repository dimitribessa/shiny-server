#mapa versao 0.1

library('shiny')
library('dplyr')
library('reshape2')
library('igraph')
library('intergraph')
library('ggnetwork')
library('ggplot2')
library('network')
library('networkD3')
#options(encoding = 'UTF-8')

shinyServer(function(input, output, session) {
    ds3 <- reactive({if(input$checkbox){
                  BO <- BO
                  Li <- matriz(input$input, input$output, input$num)}else{
                  Li    <- L}})
       #funcao reactiva para o 
    ds  <- reactive({ 
                  Lii <- ds3()  
                  Lmelt  <- melt(Lii, id.vars = c('Setor')) 
                  lteste <- Lmelt[Lmelt$value >= input$range[1] & Lmelt$value <= input$range[2]  ,] %>%                                                   graph_from_data_frame(., vertices = Setor) %>% 
                  simplify(., remove.multiple = F, remove.loops = T) %>% 
                   igraph_to_networkD3(., group = grupo)
                   lteste
                  })
  
  output$rede <- renderForceNetwork({
    ds2 <- ds()
    forceNetwork(Links = ds2$links, Nodes = ds2$nodes,
    Source = 'source', Target = 'target', NodeID = 'name',
    Group = 'group', zoom = T, legend = T, arrows = F, charge = -80,
    fontSize = 10,opacityNoHover = 1.5)
  }) 
  output$table  <- DT::renderDataTable(DT::datatable({ds3()}))
})

  
