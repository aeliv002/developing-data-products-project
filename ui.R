library(shiny)
library(xtable)

appTitle <- "Multinormal distribution x \\(\\in R^2\\) data generation";

meanInput1 <- numericInput("id1", 
                           "$$mean \\ of \\ x_1$$", 
                           0, min = -10, max = 10, step = 1)
meanInput2 <- numericInput("id2",
                           "$$mean \\ of \\ x_2$$", 
                           0, min = -10, max = 10, step = 1)
standartDevInput1 <- numericInput("id3", 
                                  "$$std. \\ of \\ x_1$$", 
                                  1, min = 0, max = 20, step = 1)
standartDevInput2 <- numericInput("id4",
                                  "$$std. \\ of \\ x_2$$", 
                                  1, min = 0, max = 20, step = 1)
covarianceInput <- numericInput("id5", 
                                "$$corelation \\ of \\ x_1 \\ x_2$$", 
                                0, min = 0, max = 5, step = 1)
confidenceIntervalList <- c("0.9" = "0.9",
                            "0.95" = "0.95",
                            "0.975" = "0.975",
                            "0.99" = "0.99",
                            "0.999" = "0.999"
                            )
setSizeList <- c("10" = "10",
                 "20" = "20",
                 "50" = "50",
                 "100" = "100",
                 "200" = "200",
                 "500" = "500"
                 )

confidenceIntervalSelect <- selectInput("confLevel",
                                        "Confidence level", 
                                        confidenceIntervalList )
setSizeRadioButtons <- radioButtons("setSize", 
                                    "Number of observations", 
                                    setSizeList)

helpTextElement <- helpText(
        "This generates multinormal set of data. In this example x\\(\\in R^2\\).
         You can see how x is distributed among parameters.
         You can choose mu and Sigma, corelation between x1 and x2, 
         number of observations and confidence level."
    )


tabPanel1 <- tabPanel("Graphical reprensentation", 
                      plotOutput("plot1"))

tabPanel2 <- tabPanel("Summary of distribution", 
                        "Given values",
                        verbatimTextOutput("summary1"),
                        "Calculated values",
                        verbatimTextOutput("summary2"))

tabPanel3 <- tabPanel("Generated values", 
                      tableOutput("table1"))

actionButton <- actionButton("actionButton", 
                             "Generate data")


shinyUI(
    fluidPage(
        withMathJax(),
        titlePanel(appTitle),
        
        sidebarLayout(
            fluid=TRUE,
            
            sidebarPanel(
                helpTextElement,
                hr(),            
                fluidRow(
                    column(5, 
                           meanInput1),
                    column(5, 
                           standartDevInput1)
                    ),
                fluidRow(
                    column(5, 
                           meanInput2),
                    column(5, 
                           standartDevInput2)
                ),
                fluidRow(
                    column(6, opffset = 1,covarianceInput)
                ),
                fluidRow(
                    column(5, opffset = 1,confidenceIntervalSelect),
                    column(5, opffset = 1,setSizeRadioButtons)
                ),
                actionButton
            ),
    
            mainPanel(
                
                tabsetPanel(
                    tabPanel1,
                    tabPanel2,
                    tabPanel3
                )
            )
        )
    )
)
        
