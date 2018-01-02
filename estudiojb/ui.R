#mapa versao 0.1

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
      helpText("Período: 27 de novembro a 8 de dezembro de 2017.")
    ),
    
      #Tabela com as informações
      fluidRow(
        DT::dataTableOutput("table"))   
    ))
)
