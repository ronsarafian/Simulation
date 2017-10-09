
library(shiny)

shinyUI(fluidPage(
    
    titlePanel("PM Modeling Simlation with AR(1) noise"), 
    
    withMathJax(),
    
    helpText("In this simulation we demonstrate the consequences of estimating 
             the effect of PM expusure on health in the \\( \\textbf{
             epidemiological stage} \\) using PM measurment as covariates that
             are generated in the \\( \\textbf{environmental stage} \\) using 
             AOD measurments."),
    
    helpText("We consider two estimation alternative for the environmental 
             stage: (i) Ordinary Least Squares - \\( \\textbf{OLS} \\), and (ii) 
             Generalized Least Squares - \\( \\textbf{GLS} \\). For the 
             epidemiological model we assume linear relationship and an OLS 
             estimation."),
    
    helpText("To describe a real temporal process, we intruduce an AR(1) noise 
             in the relationship between PM and AOD for a day \\( j \\in (1,...,
             T) \\):"),
    
    helpText("$$ y_j = x_j'\\beta + \\varepsilon_j ,$$"),
    
    helpText("where \\( y \\) is PM expusure, \\( x \\) is a \\( m \\times 1 \\)
             vector of  AOD mesurments, and \\( \\varepsilon \\) is the AR(1)
             noise which follow:"),
    
    helpText("$$ \\varepsilon_j = \\rho\\varepsilon_{j-1} + \\upsilon_j ,$$"),
    
    helpText("where \\( \\rho \\) is the autocorrelation parameter and \\(
             \\upsilon \\) is a white noise that follows: \\( \\upsilon \\sim 
             \\mathcal{N}(0,\\sigma^2) \\)"),
    
    helpText("The OLS estimator for \\( \\beta \\) is:"),
    
    helpText("$$ \\hat{\\beta}_{OLS} = (X'X)^{-1}X'y ,$$"),
    
    helpText("where \\( X \\) is the \\(T \\times m \\) matrix of AOD predictors 
             and \\( y \\) is the response \\(T \\times 1 \\) PM vector."),
    
    helpText("The GLS estimator for \\( \\beta \\) is:"),
    
    helpText("$$ \\hat{\\beta}_{GLS} = (X'\\Sigma^{-1}X)^{-1}X'\\Sigma^{-1}y ,$$"),
    
    helpText("where \\( \\Sigma \\) is the covariance matrix of \\( \\varepsilon 
             \\) that follow:"),
    
    helpText("$$ 
             \\Sigma = \\frac{\\sigma}{1-\\rho^2}  \\begin{bmatrix}
            1          & \\rho       & \\rho^2     &        & \\rho^{T-1}  \\\\
            \\rho      & 1           & \\rho       & \\dots & \\rho^{T-2}  \\\\
            \\rho^2    & \\rho       & 1           &        & \\rho^{T-3}  \\\\
                       & \\vdots     &             & \\ddots& \\vdots      \\\\
            \\rho^{T-1}& \\rho^{T-2} & \\rho^{T-3} & \\dots & 1
                \\end{bmatrix} . $$"),
    
    helpText("In the epidemiological study, the environmental PM predictions \\( 
             \\hat{y} \\) serves as covariates. We define by \\( \\hat{y}_{OLS} 
             \\) the PM predictions that were generated using OLS, and by \\( 
             \\hat{y}_{GLS} \\) those were generated using GLS, in the 
             environmental stage"),
    
    helpText("The epidemiological regression is:"),
    
    helpText("$$ z_i = \\alpha \\hat{y_i} + \\nu_i ,$$"),
    
    helpText("where \\( \\nu \\) is a white noise process that follows: \\( nu
             \\sim \\mathcal{N}(0,\\omega^2) \\)."),
    
    helpText("We are interested in the reliability of the estimator \\( 
             \\hat{\\alpha} \\) w.r.t \\( \\alpha \\)"),
    
    
    
    helpText(""),
    
    sidebarLayout(
        sidebarPanel(
            sliderInput("seed",
                        "Set a seed:",
                        min = 1,
                        max = 100,
                        step = 1,
                        value = 1),
            sliderInput("N",
                        "Number of observations:",
                        min = 10,
                        max = 100,
                        step = 1,
                        value = 50),
            sliderInput("rho",
                        "rho:",
                        min = 0.1,
                        max = 1,
                        step = 0.01,
                        value = 0.75),
            sliderInput("sigma",
                        "sigma:",
                        min = 0.1,
                        max = 3,
                        step = 0.01,
                        value = 1),
            sliderInput("omega",
                        "omega:",
                        min = 0.1,
                        max = 3,
                        step = 0.01,
                        value = 1),
            sliderInput("beta",
                        "beta:",
                        min = -3,
                        max = 3,
                        step = 0.01,
                        value = 1),
            sliderInput("alpha",
                        "alpha:",
                        min = -3,
                        max = 3,
                        step = 0.01,
                        value = -2)
        ),
        
        mainPanel(
            plotOutput("distPlot")
        )
    )
))
