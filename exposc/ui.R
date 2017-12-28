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

# Use a fluid Bootstrap layout
shinyUI (  navbarPage("Exportações Catarinenses (2016)",
  tabPanel('Página em desenvolvimento',
  # Give the page a title
  titlePanel('Painel dinâmico das exportações'),
   fluidRow( 
   column(2, 
    selectInput("municipio", "Municipio:", 
                  choices= c(unique(export$NOME)), selected="Florianópolis")),       
    # Define the sidebar with one input
   column(3,
    selectInput('produto',"Produto SH2:",
                  choices = c('Tudo',unique(export$Prod.SH4)))) ,
   column(2,   
      selectInput('pais',"País Destino:",
                  choices = c('Tudo', unique((export$NO_PAIS))), selected = 'Tudo')),
   column(2,
      selectInput('porto',"Município Porto:",
                  choices = c('Tudo', unique((export$NO_MUN_MIN))), selected = 'Tudo')),
   column(4,
      sliderInput("fob", "Valor das Exportações:",
                  min = min(export$VL_FOB), max = max(export$VL_FOB),
                  value = c(min(export$VL_FOB),max(export$VL_FOB)), step = 100),
                   helpText("Fonte: MDIC 2017")),
      
   column(3, 
      downloadButton("downloadData", "Download"))
    ),   
    hr(),      
    # Create a spot for the barplot
    fluidRow(tabsetPanel( tabPanel('Mapa',plotlyOutput('trendPlot')),
                         tabPanel('Tabela', DT::dataTableOutput("table"))
             )),
    fluidRow(
      column(6,plotlyOutput("gplot")),
      column(6,plotlyOutput('gplotII'))),
    fluidRow(5,plotlyOutput('gplotIII')),
    fluidRow( h4("Quadro Resumo:"), tableOutput("view"))
    ),
   tabPanel('Contato',
   fluidRow(column(3,'Dimitri Bessa',tags$em('(Pesquisador associado pela Secretaria de Estado do Planejamento de Santa Catarina (dimitri@spg.sc.gov.br));'))),
   br(),
   hr(),
  fluidRow( column(5,'Agradeço as colaborações de:')),  
   br(),
  fluidRow(column(3,'Flávio Victoria,', tags$em('(Gerente de Planejamento Urbano e Territorial da Secretaria de Estado do Planejamento de Santa Catarina)'))),  
   br(),
  fluidRow( column(3,'Liana Bohn,', tags$em('(Pesquisadora pela Federação das Indústrias de Santa Catarina (FIESC))'))), br(),
   fluidRow(column(3,'Eva Yamila,', tags$em('(Professora pelo departamento de Economia e Relações Internacionais pela Universidade Federal de Santa Catarina)')))
   )
   ))
