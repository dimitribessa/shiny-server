#mapa versao 0.1

library('shiny')
library('dplyr')
library('reshape2')
library('igraph')
library('intergraph')
library('ggnetwork')
library('ggplot2')
library('networkD3')
load('data.RData')
# Use a fluid Bootstrap layout

# Use a fluid Bootstrap layout
shinyUI ( fluidPage(    
  
  # Give the page a title
  titlePanel('Gerador de Impacto',),        
  tabsetPanel(type = 'tabs',
              tabPanel('Grafo',forceNetworkOutput("rede")),
              tabPanel('Matriz',DT::dataTableOutput("table"))),
  hr(), 
  fluidRow(
    column(4, 
           h4('Filtros de Relações Setoriais'),
           # actionButton(inputId = 'vai',
           #            label   = 'Atualizar'),
           # Input: Specification of range within an interval ----
           sliderInput("range", "Intervalo:",
                       min = 0.00, max = 1,
                       value = c(0.05,1)),
           helpText("Fonte: IBGE")),
    column(4,
           h4('Opções para Impacto:'),                    
           # Copy the line below to make a checkbox
           checkboxInput("checkbox", label = "Selecionar para Impacto:", value = FALSE),
           hr(),        
           selectInput("input", "Input:", 
                       choices= c(levels(Setor[,1])), selected="Agropec"),
           selectInput('output',"Output:",
                       choices= c(levels(Setor[,1])), selected="Agropec"),
           numericInput("num", label = 'Intensidade (E):', value = 0.05))
  )))
