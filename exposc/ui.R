#editado em 06-fev-2018 
shinyUI (   navbarPage("Exportações/Importações Catarinenses (2016)",
  tabPanel('Página em desenvolvimento',
  # Give the page a title  
  titlePanel('Painel dinâmico'),
   fluidRow(
   selectInput("xm", "Selecionar opção:", 
                  choices= c('Exportação','Importação'), selected="Exportação")),
   fluidRow( 
   column(2, 
    selectInput("municipio", "Municipio:", 
                  choices= c(unique(export$NOME)), selected="Florianópolis")),       
    # Define the sidebar with one input
   column(3,
    selectInput('produto',"Produto SH2:",
                  choices = c('Tudo',unique(export$Prod.SH4)))) ,
   column(2,   
      selectInput('pais',"País Origem/Destino:",
                  choices = c('Tudo', unique((export$NO_PAIS))), selected = 'Tudo')),
   column(2,
      selectInput('porto',"Município Porto:",
                  choices = c('Tudo', unique((export$NO_MUN_MIN))), selected = 'Tudo')),
   column(4,
      sliderInput("fob", "Valor:",
                  min = min(export$VL_FOB), max = max(export$VL_FOB),
                  value = c(min(export$VL_FOB),max(export$VL_FOB)), step = 100),
                   helpText("Fonte: MDIC 2017"))
   ),   
  # column(3, 
   #   downloadButton("downloadData", "Download"))
   # ),   
    hr(),      
    # Create a spot for the barplot
    fluidRow(tabsetPanel( tabPanel('Mapa',plotlyOutput('trendPlot')),
                         tabPanel('Tabela', DT::dataTableOutput("table"))
             )),
    fluidRow(
      column(6,checkboxInput("checkporto", label = h4("Volume"), value = FALSE),plotlyOutput("gplot")),
      column(6,checkboxInput("checkpais", label = h4("Volume"), value = FALSE),plotlyOutput('gplotII'))),
    fluidRow(checkboxInput("checkproduto", label = h4("Volume"), value = FALSE),plotlyOutput('gplotIII')),
    fluidRow( column(4,h4("Quadro Resumo:"), tableOutput("view")),column(8,plotlyOutput('ggplotIV')))
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
