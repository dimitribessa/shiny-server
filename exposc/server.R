#mapa versao 0.1

library('shiny')
library('plotly')

library('xtable')       #Exportar Arquivos
library('ggplot2')      #Gráficos (mais usado)
library('psych')        #algumas funções de data.frame
library('reshape2')     #para remodular data.frames
library('plyr')        #manipulação de dados - tydiverse
library('dplyr')        #manipulação de dados - tydiverse
library('stringr')      #funções de string  - tydiverse
library('downloader')	  # downloads and then runs the source() function on scripts from github
library('magrittr')     #para mudar nome de colunas

library('maps') #carregar mapas padrao
library('maptools') #Para confecção de mapas
library('ggmap') # Para confecção de mapas
library('rgeos') #leitura de mapas
library('rgdal') #leitra de mapas
library('rworldmap') #leitra de mapas
library('geosphere') #to beatifull arches

load('data.RData')
#options(encoding = 'UTF-8')

shinyServer(function(input, output, session) {
  
  ds <- reactive({data1 <- export[complete.cases(export),] %>% .[.$NOME == input$municipio,]              
                 if(input$pais != 'Tudo' ){data1   <- data1[data1$NO_PAIS    == input$pais,]}
                 if(input$porto != 'Tudo'){data1   <- data1[data1$NO_MUN_MIN == input$porto,]}
                 if(input$produto != 'Tudo'){data1 <- data1[data1$Prod.SH4 == input$produto,]}                                 
                 data1}) 
                    
    #menu interativo de pais e porto
    observe({
    hei1<-input$pais
    hei2<-input$porto
    hei3<-input$fob[1]
    hei4<-input$fob[2]
    #hei5<-input$municipio
    hei6<-input$produto
    dado<-ds()

    choice1<-c('Tudo', unique((dado$NO_PAIS)))
    choice2<-c('Tudo',unique((dado$NO_MUN_MIN)))
   # choice3<-c(unique(dado$NOME))
    choice4<-c('Tudo',unique(dado$Prod.SH4))

    updateSelectInput(session,"pais",choices=choice1,selected=hei1)
    updateSelectInput(session,"porto",choices=choice2,selected=hei2)
    #updateSelectInput(session,"municipio",choices=choice3,selected=hei5)
    updateSelectInput(session,"produto",choices=choice4,selected=hei6)
    updateSliderInput(session,"fob",value = c(hei3,hei4), min = min(dado$VL_FOB), max = max(dado$VL_FOB))

   #delimitador do tamanho das barras

     })
            
    ds2<- reactive({data1 <- ds()   
                   data1 <- data1[data1$VL_FOB >= input$fob[1] & data1$VL_FOB <= input$fob[2],]               
                 data1}) 

   #para os dados de gráfico barra
    #gráfico ranking
    dg <- reactive({data1 <- ds2()
                    graf <- aggregate(as.numeric(VL_FOB) ~ NO_MUN_MIN, data = data1, FUN = sum, na.rm= T) %>% setNames(., c('Porto', 'Soma_expo'))%>% arrange(., desc(Soma_expo)) %>% mutate(., Porto = Porto, Ranking = c(1:nrow(.)), Prop = (Soma_expo/sum(Soma_expo, na.rm = T)*100)%>% round(2))
                    graf})
                    
    dg2 <- reactive({data1 <- ds2()
                    graf <-  aggregate(as.numeric(VL_FOB) ~ NO_PAIS, data = data1, FUN = sum, na.rm= T) %>% setNames(., c('País', 'Soma_expo'))%>% arrange(., desc(Soma_expo)) %>% mutate(., País =  País, Ranking = c(1:nrow(.)), Prop = (Soma_expo/sum(Soma_expo, na.rm = T)*100)%>% round(2))
                    graf})
    
    dg3 <- reactive({data1 <- ds2()
                    graf <-  aggregate(as.numeric(VL_FOB) ~ Prod.SH4, data = data1, FUN = sum, na.rm= T) %>% setNames(., c('Produto.SH2', 'Soma_expo'))%>% arrange(., desc(Soma_expo)) %>% mutate(., Produto.SH2 =  paste0(substr(Produto.SH2,1,25),'(...)'), Ranking = c(1:nrow(.)), Prop = (Soma_expo/sum(Soma_expo, na.rm = T)*100)%>% round(2))
                    graf})
    
  dg4 <- reactive({data1 <- ds2()
                    graf <-  aggregate(as.numeric(VL_FOB) ~ NOME, data = data1, FUN = sum, na.rm= T) %>% setNames(., c('Município', 'Soma_expo'))%>% arrange(., desc(Soma_expo)) %>% mutate(., Município =  Município, Ranking = c(1:nrow(.)), Prop = (Soma_expo/sum(Soma_expo, na.rm = T)*100)%>% round(2))
                    graf})

#tabela resumo dos dados (26-dez-17, 17:42h)   
     dt1 <- reactive({tabprop <- export
                      if(input$produto != 'Tudo'){tabprop <- tabprop[tabprop$Prod.SH4 == input$produto,]}
                      tabprop <- aggregate(as.numeric(VL_FOB) ~ NOME, data = tabprop, FUN = sum, na.rm = T) %>% 
                      setNames(., c('Município', 'Soma_expo'))%>% arrange(., desc(Soma_expo)) %>% 
                      mutate(., Ranking = c(1:nrow(.)), Prop = (Soma_expo/sum(Soma_expo, na.rm = T)*100)%>% round(2))
                      tabprop <- tabprop[tabprop == input$municipio,]
                      resumo <- data.frame('Variáveis' = c('Município', 'Produto SH2', '% Estado','Ranking Estado','Valor Total (US$)'),
                                           'Valores'   = c(input$municipio, input$produto, tabprop[1,'Prop'],tabprop[1,'Ranking'],tabprop[1,'Soma_expo']))
                     resumo  
     })                 

    
  output$trendPlot <- renderPlotly({
   data2 <- ds2()
   # a simple map
    mapaII <- # map_data("world","brazil") %>%
  #group_by(group)   %>%
  plot_geo() %>%
  add_markers(
    data = data2, x = ~x.orig, y = ~y.orig, text = ~NOME, color = I('red'),
    size = 10, hoverinfo = all, alpha = 0.5, name = 'Município Origem'
  ) %>%
  add_markers(
    data = data2, x = ~x.country, y = ~y.country,  
    size = ~VL_FOB,  alpha = 0.5, color = I('orange'),
    text = ~paste('Pais Destino:',NO_PAIS, '<br>Total Exportado:', VL_FOB,'<br>Porto Origem:', NO_MUN_MIN,
                        '<br>Distância Percorrida (km):', round(sum.dist,1)),
    hoverinfo = all, name = 'País Destino'
  ) %>%
  add_markers(
    data = data2, x = ~x.dest, y = ~y.dest, name = 'Município Saída', 
     text = ~NO_MUN_MIN,alpha = 0.5,  hoverinfo = all, size = 3
  ) %>%
   add_segments(
    data = data2, 
    xend = ~x.orig, x = ~x.dest,
    yend = ~y.orig, y  = ~y.dest, 
    alpha = 0.3, size = I(1), name = 'Origem>>Porto')  %>%
  add_segments(
    data = data2,  
    x = ~x.dest, xend = ~x.country,
    y = ~y.dest, yend = ~y.country, 
    alpha = 0.3, size = I(1), name = 'Porto>>País') %>%   
     layout(
    title = 'Rede de Exportações',
    geo = list(
    showocean = TRUE,
    showland = TRUE,
    landcolor ="#090D2A",
    countrycolor = toRGB("grey80"),
    oceancolor =  '#00001C'))
  })
  
 
  
   output$gplot   <- renderPlotly({
                    theme_set(theme_minimal())
                    data1 <- dg()
                    graf1 <- ggplot(data1, aes(x = reorder(Porto,Soma_expo), y = Soma_expo, group = Porto)) + geom_col(aes(text = paste('Porto: ',Porto,'<br>Soma_expo (US$):', Soma_expo, '<br>Proporção:', Prop,'%', '<br>Ranking: ',Ranking)),alpha = .7, fill = '#a6bddb',width = if(input$porto == 'Tudo'){NULL}else{.5})+  xlab('') + ylab('') + coord_flip() 
 
                    ggplotly(graf1, tooltip = 'text') %>% layout(title = 'Ranking dos Portos por Exportação',
                    dragmode = 'pan')})
   
   output$gplotII <- renderPlotly({                 
                     theme_set(theme_minimal())
                     data1 <- dg2()
                      graf2 <- ggplot(data1, aes(x = reorder(País,Soma_expo), y = Soma_expo, group = País)) +
                       geom_col(aes(text = paste('País: ',País,'<br>Soma_expo (US$):', Soma_expo, '<br>Proporção:', Prop,'%', '<br>Ranking: ',Ranking)), alpha = .7, fill = '#de2d26', width = if(input$pais == 'Tudo'){NULL}else{.5}) +  xlab('') + ylab('') +
                       coord_flip() +  theme(axis.text.x = element_text(hjust = 1, size = 1))
                       
                      ggplotly(graf2, tooltip = 'text') %>%layout(title = 'Ranking dos países destinos das exportações')})
                      
      output$gplotIII <- renderPlotly({                 
                     theme_set(theme_minimal())
                     data1 <- dg3()
                      graf2 <- ggplot(data1, aes(x = reorder(Produto.SH2,Soma_expo), y = Soma_expo, group = Produto.SH2)) +
                       geom_col(aes(text = paste('Produto: ',Produto.SH2,'<br>Soma_expo:', Soma_expo, '<br>Proporção:', Prop,'%', '<br>Ranking: ',Ranking)), alpha = .7, fill = '#de2d26', width = if(input$produto == 'Tudo'){NULL}else{.5}) +  xlab('') + ylab('') +
                       coord_flip() +  theme(axis.text.x = element_text(hjust = 1, size = 1))
                       
                      ggplotly(graf2, tooltip = 'text') %>%layout(title = 'Ranking dos produtos exportados')})
                      
     # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- ds()
    data <- data[,c(14,11,20,21,9)] %>% setNames(.,c('Origem','Porto_Origem', 'País_Destino','Produto.SH2','Soma_FOB'))
    data
  }))
   
   output$view <- renderTable({
    ds()
  })
  
   # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$municipio, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(ds(), file, row.names = FALSE)
    }
  )                 
})
