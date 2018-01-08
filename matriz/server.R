#mapa versao 0.1

library('shiny')
library('dplyr')
library('reshape2')
library('igraph')
library('intergraph')
library('ggnetwork')
library('ggplot2')
library('network')

load('rdata.RData')
#options(encoding = 'UTF-8')

shinyServer(function(input, output, session) {
  ds3 <- reactive({if(input$checkbox){
      Li <- matriz(input$input, input$output, input$num)}else{
      Li    <- L}})
  #funcao reactiva para o 
  ds  <- reactive({set.seed(1234) 
    Lii <- ds3()  
    Lmelt  <- melt(Lii, id.vars = c('Setor')) 
    lteste <- Lmelt[Lmelt$value >= input$range[1] & Lmelt$value <= input$range[2]  ,] %>%                                                   graph_from_data_frame(., vertices = Setor) %>% 
      simplify(., remove.multiple = F, remove.loops = T)  %>% fortify(.,weights = 'value',arrow.gap = 0.01)
    
    #corrigindo o BUG          
    lteste$x <- lteste$x[,1]
    lteste$y <- lteste$y[,1]
    lteste$xend <- lteste$xend[,1]
    lteste$yend <- lteste$yend[,1]
    lteste}
  )
  
  output$rede <- renderPlot({
    ds2 <- ds()
    grafico <-  ggplot(ds2, aes(x = x,  y = y, xend = xend, yend = yend)) +
      geom_edges(aes(colour = Segmento),arrow = arrow(length = unit(3, "pt"), type = "closed"), curvature = 0.1, alpha = .5)  +
      geom_nodes(aes(colour = Segmento),size = 3, alpha = .9) +
      geom_nodetext_repel(aes(label =  vertex.names ), color = 'white') +
      theme(axis.text = element_blank(),
            axis.title = element_blank(),
            panel.background = element_rect(fill = "black"),
            plot.background = element_rect(fill = "black"),
            legend.background = element_rect(fill="black", colour = 'black'),
            legend.key = element_rect(fill = "black", colour = 'black'),
            legend.position = 'bottom',
            legend.text = element_text(size = 8, colour = "white"),
            panel.grid = element_blank())
    print(grafico)       
  }) 
  output$table  <- DT::renderDataTable(DT::datatable({ds3()}))
})

  