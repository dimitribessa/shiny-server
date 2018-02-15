# Carregando os pacotes

library(shiny)
library(tibble)
library(magrittr)
library(dplyr)
library(stringr)
library(purrr)
library(RCurl)
library(jsonlite)
library(leaflet)
library(knitr)

library('maptools') #Para confecção de mapas
library('ggmap') # Para confecção de mapas
library('rgeos') #leitura de mapas
library('rgdal') #leitra de mapas
library('RColorBrewer') #funçaõ para paleta de cores

shinyServer(function(input, output, session) {
  
  #função para busca dos pontos
  df_places <- eventReactive(input$atualizar,{ input$text %>% 
      purrr::map_df(.f = get_googlemaps_data, radius = 60000) })
  
  # Plotando no mapa os dados pesquisados na etapa acima
  output$map <-
    renderLeaflet({ dado <- df_places()
    dado %>% leaflet() %>%
      addProviderTiles(providers$OpenStreetMap)  %>%  
      addTiles(attribution = 'Maps by Secretaria de Estado do Planejamento') %>% setView(lng =  -48.5512765, lat = -27.5947736, zoom = 12) %>%
      addCircles(lng = ~long, lat = ~lat, weight = 5,
                 radius = 15, color = c('blue'), fillOpacity = 0.8)})  
  
  observe({
    bins <- seq(min(municipiopoly@data[,input$color]),max(municipiopoly@data[,input$color]),length  =8)
    pal <- colorBin("YlOrRd", domain = municipiopoly@data[,input$color], bins = bins)
    colorData <- pal(municipiopoly@data[,input$color])
    
    labells <- sprintf(
      "<strong>%s</strong><br/> %s: %g", #  people / mi<sup>2</sup>",
      municipiopoly$NOME_UDH, input$color, municipiopoly@data[,input$color]
    ) %>% lapply(htmltools::HTML)
    
    leafletProxy('map', data = municipiopoly) %>%  addPolygons(color = "#444444", fillColor =  colorData, stroke = T, smoothFactor = 0.5, fillOpacity = 0.3,
                                                               weight = 1.5,highlight = highlightOptions(
                                                                 weight = 5,
                                                                 color = "#666",
                                                                 dashArray = "",
                                                                 fillOpacity = 0.7,
                                                                 bringToFront = TRUE),
                                                               label = labells,
                                                               labelOptions = labelOptions(
                                                                 style = list("font-weight" = "normal", padding = "3px 8px"),
                                                                 textsize = "12px",
                                                                 maxWidth = '200px',
                                                                 direction = "auto")) %>% 
      addLegend(pal = pal, values = colorData, opacity = 0.7, title = input$color,
                position = "bottomright",
                layerId="colorLegend")  })
  
  #dicionário de variáveis
  output$descVariaveis <- DT::renderDataTable({dicionario})
  
})
