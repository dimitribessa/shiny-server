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

navbarPage("Página em Desenvolvimento",

  tabPanel("Mapa Interativo",

      # If not using custom CSS, set height of leafletOutput to a number instead of percent
      leafletOutput("map",width="100%",height="750px"),

      # Shiny versions prior to 0.11 should use class = "modal" instead.
      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
        draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
        width = 330, height = "auto",

        h2("Explorador de Dados"),

        selectInput("color", "Variável", vars),
        textInput("text", "Busca Item \n(exemplo: escola, hospital, barbearia...)", value = ""),
        actionButton('atualizar',label = 'Atualizar')
        )

   ),# fechamento do tabpanel do mapa interativo
   
   tabPanel("Descrição das Variáveis",
    DT::dataTableOutput("descVariaveis") ),
     tabPanel('Contato',
   fluidRow(column(3,'Dimitri Bessa',tags$em('(Pesquisador associado pela Secretaria de Estado do Planejamento de Santa Catarina (dimitri@spg.sc.gov.br));'))),
   br(),
  fluidRow(column(3,'Flávio Victoria,', tags$em('(Gerente de Planejamento Urbano e Territorial da Secretaria de Estado do Planejamento de Santa Catarina)')))  
 )
    )
