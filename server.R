library(ggplot2)
library(xtable)
library(mvtnorm)
library(MASS)

data(galton)

generateData <- function(mu,Sigma,size){
    generatedDF <- as.data.frame(rownames = NULL, mvrnorm(n = size, mu, Sigma))
    names(generatedDF) <- c("x1","x2")
    return(generatedDF)

    }

shinyServer(
    function(input, output) {
        
        rand <- eventReactive(
                    input$actionButton,{
                        Sigma <- matrix(c(input$id3,input$id5,input$id5,input$id4),2,2)
                        mu <- c(input$id1,input$id2)
                        generateData <- generateData(mu,Sigma, as.numeric(input$setSize))
                    return(generateData)
                    }
        )

        output$plot1 <- renderPlot({
                            generateData <- rand()
                            if(is.null(generateData)){
                                return(NULL)
                            }
                            else{
                                ggplot(data = generateData,aes(x = x1,y = x2)) + 
                                    geom_point() + 
                                    stat_ellipse(color="red", size = 3,level = as.numeric(input$confLevel))
                            }
                        })

        output$table1 <- renderTable({
                            generateData <- rand()
                            
                            if(is.null(generateData)){
                                return(NULL)
                            }
                            else{
                                scaledDF <- as.data.frame(scale(generateData))
                                names(scaledDF) <- c("z1","z2")
                                S <- cov(scaledDF)
                                density <- dmvnorm(scaledDF,mean = c(0,0),sigma = S)
                                return(as.data.frame(cbind(generateData,scaledDF,density)))
                            }
                        });
        
        output$summary1 <- renderPrint({
                                generateData <- rand()
                                
                                if(is.null(generateData)){
                                    return(NULL)
                                }else{
                                    MyList = list(
                                        Mu = c(input$id1,input$id2),
                                        Sigma = matrix(c(input$id3,input$id5,input$id5,input$id4),2,2)
                                        )
                                    return(MyList)
                                    }
                            })
        
        output$summary2 <- renderPrint({
                                generateData <- rand()
                                if(is.null(generateData)){
                                    return(NULL)
                                }
                                else{
                                    MyList = list(
                                        mu = c(mean(generateData$x1),mean(generateData$x2)),
                                        Sigma = cov(generateData)
                                    )
                                    return(MyList)
                                }
                            })
    }
)