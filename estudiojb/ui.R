#mapa versao 0.1

library('shiny')
library('plotly')
library('dplyr')
library('reshape2')
library('stringr')
#setwd('D:\\Dimitri\\Docs 17-out-15\\Ju html\\Treino OnLine')
#treino <- read.xlsx('08nov2017.xlsx', sheetIndex = 3, encoding = 'UTF-8')
load('data.RData')

# Use a fluid Bootstrap layout
shinyUI ( fluidPage(    
  
  # Give the page a title
  fluidRow(
    column(2,tags$img(height = 100,
                    width = 100,
                    src = "JB_quad.jpg")),
    column(3,titlePanel('Selecione o treino'))
    ),
  fluidRow(
       column(4,
      selectInput("treino", "Treino:", 
                  choices= unique(treino$Treino), selected=unique(treino$Treino)[1]),
      hr(),
      helpText("Período: 02 a 12 de janeiro de 2018.")
    ),
    
      #Tabela com as informações
      fluidRow(
        DT::dataTableOutput("table"))   
    ))
)