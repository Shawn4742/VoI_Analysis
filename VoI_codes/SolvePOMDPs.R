rm( list = ls( all=TRUE ) )

library(appl)
library(R.matlab)
setwd("C:/Users/shuol2/paper3/codes_for_paper3/IA/codes")
#getwd()

# input data
input <- readMat("input_TryPOMDPs.mat")

### input variables
# number of states
num_states <- input$n

initial_b <- seq(0, 0, length.out=num_states)
initial_b[1] <- 1


discount <- input$discount

# transition matrix
T1 <- input$Tr

time_out = 1000
acc = 1e-5

initial_b = c(0.86, 0.14, 0)
out_S_NoSHM <- sarsop(input$Tr, input$Obs, input$C.S,
	         input$discount, state_prior=initial_b, precision = acc, timeout = time_out)
	         
out_S_SHM <- sarsop(input$Tr, input$ObsTest, input$C.S,
	         input$discount, state_prior=initial_b, precision = acc, timeout = time_out)

out_A_NoSHM <- sarsop(input$Tr, input$Obs, input$C.A,
	         input$discount, state_prior=initial_b, precision = acc, timeout = time_out)
	         
out_A_SHM <- sarsop(input$Tr, input$ObsTest, input$C.A,
	         input$discount, state_prior=initial_b, precision = acc, timeout = time_out)
	         
print(beta_S_NoSHM)
print(length(beta_S_NoSHM$action))
print(beta_S_SHM)
print(length(beta_S_SHM$action))

print(beta_A_NoSHM)
print(length(beta_S_NoSHM$action))
print(beta_A_SHM)
print(length(beta_A_SHM$action))


writeMat("OutputSARSOP_info6.mat", 
alpha_S_NoSHM = out_S_NoSHM$vectors, actions_S_NoSHM = out_S_NoSHM$action, 
alpha_S_SHM   = out_S_SHM$vectors,   actions_S_SHM   = out_S_SHM$action,
alpha_A_NoSHM = out_A_NoSHM$vectors, actions_A_NoSHM = out_A_NoSHM$action, 
alpha_A_SHM   = out_A_SHM$vectors,  actions_A_SHM   = out_A_SHM$action)
