
library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$distPlot <- renderPlot({
        
        seed <- input$seed
        rho <- input$rho
        sigma <- input$sigma
        N <- input$N
        beta <- input$beta
        alpha <- input$alpha
        omega <- input$omega
        
        set.seed(seed)
        par(mfrow = c(3,3), mar = c(4,4,2,2))
        
        pow <- abs(outer(1:N, 1:N, "-")) + 1
        Sigma <- sigma^2/(1-rho^2) * rho^pow
        Sigma.inv <- solve(Sigma)
        image(Sigma[N:1,1:N], main = "epsilon covariance matrix")
        
        upsilon <- rnorm(N, mean = 0, sd = sigma)
        epsilon <- numeric(N)
        epsilon[1] <- upsilon[1]
        
        for (i in 2:N) {
            epsilon[i] <- rho * epsilon[i-1] + upsilon[i]
        }
        
        plot(epsilon, type = "b", main = "epsilon", xlab = "")
        
        aod <- rnorm(N)
        plot(aod, type = "b", main = "aod", xlab = "")
        
        pm <- beta * aod + epsilon
        plot(pm, type = "b", main = "pm", xlab = "")
        
        X <- cbind(1,aod)
        
        beta.ols <- solve(t(X) %*% X) %*% (t(X) %*% pm)
        pmh.ols <- X %*% beta.ols

        beta.gls <- solve(t(X) %*% Sigma.inv %*% X) %*% (t(X) %*% Sigma.inv %*% pm)
        pmh.gls <- X %*% beta.gls

        plot(pm~aod, main = "environmental model: pm~aod", xlab = "")
        abline(0, beta)
        abline(beta.ols, col = "blue")
        abline(beta.gls, col = "red")
        legend("topleft",
               legend = c("real","ols","gls"), 
               col = c("black", "blue", "red"),
               lty = 1)
        
        nu <- rnorm(N, mean = 0, sd = omega)
        z <- alpha * pm + nu
        plot(z, type = "b", main = "health", xlab = "")
        
        PMH.ols <- cbind(1,pmh.ols)
        PMH.gls <- cbind(1,pmh.gls)
        
        alpha.ols <- solve(t(PMH.ols) %*% PMH.ols) %*% t(PMH.ols) %*% z
        alpha.gls <- solve(t(PMH.gls) %*% PMH.gls) %*% t(PMH.gls) %*% z
        
        plot(z~pm, main = "epidemiological model: z~pm", 
             ylab = "helth", xlab = "real pm")
        abline(0,alpha)
        abline(alpha.ols, col = "blue")
        abline(alpha.gls, col = "red")
        legend("bottomleft",
               legend = c("real","ols based","gls based"), 
               col = c("black", "blue", "red"),
               lty = 1)
    },
    width = 700, height = 800)
    
})
