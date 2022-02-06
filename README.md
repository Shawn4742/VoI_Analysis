# Tutorials for VoI Analysis
This tutorial demonstrate the techniques to compute the VoI without and with external constraints.


## Get Started

You need to install MATLAB and R. The POMDP solver (SARSOP) is required and it is available [here](https://github.com/boettiger-lab/sarsop).

Then clone this repo:

```
git clone https://github.com/Shawn4742/VoI_Analysis.git
```

## Problem Definition
An illuistrative POMDP tutorial can be found [here](http://www.pomdp.org/tutorial/). 

Our problem is defined by a state space, representing the condition of an infrastructure component, and an action space, representing the available maintenance actions on that component. For simplicity, we limit the number of states as 3, including intact, damaged and failure conditions, actions as 2, for example, do-nothing and repair. The problem definition is implemented by MATLAB in the following.

The transition matrix T can be defined as

```
p12 = 0.04;
p23 = p12 * 3;

T_dn = [1-p12   p12   0;
        0           p23   1 - p23;
        0           0     1];   
    
T_rp = ones(size(T_dn, 1), 1) * T_dn(1, :);
Tr(:,:,1) = T_dn; 
Tr(:,:,2) = T_rp; 
```

For the observations, we define the ones without monitoring efforts, 

```
e_NoSHM = 0.5;
Obs_NoSHM = [1-e_NoSHM     e_NoSHM       0;
                           e_NoSHM       1-e_NoSHM    0;
                           0                      0                     1];
```

and with monitoring efforts,

```
e_SHM = 0.2;
Obs_SHM = [1-e_SHM     e_SHM          0;
                       e_SHM      1-e_SHM        0;
                       0                0                     1];
```

Next, we assign the observations into the emission matrix for each action,

```
for i = 1: size(Tr,3)
    % No SHM
    ObsE1(:,:,i) = Obs_NoSHM;
    % SHM
    ObsE2(:,:,i) = Obs_SHM;
end
```

Then cost function is defined as

```
Cf = -1; % failure cost
Cr_A = -0.05; % repair cost

Cost_A = [  0        Cr_A;
                  0         Cr_A;
                 Cf        Cr_A + Cf];
```

The discount factor is set as
```
discount = 0.95
```

We save the defined parameters by commond

```
save(‘POMDP_Input', 'Tr', 'n_s_full', 'Cost_A', 'Cost_S', 'ObsE1', 'ObsE2', 'discount');
```
where Cost_S is used for constrained setting later. The code for problem definition is in file XXX.

## POMDP Solving
The POMDP is solved by R package. 

Load the R package first,

```
library(appl)
library(R.matlab)
setwd("C:/Users/shuol2/paper3/codes_for_paper3/IA/codes")

# input data
input <- readMat("POMDP_Input.mat")
```

Solve the problem by 

```
# without monitoring
out_A_NoSHM <- sarsop(input$Tr, input$Obs, input$C.A,
	         input$discount, state_prior=initial_b, precision = acc, timeout = time_out)

# with monitoring
out_A_SHM <- sarsop(input$Tr, input$ObsTest, input$C.A,
	         input$discount, state_prior=initial_b, precision = acc, timeout = time_out)
```

where state_prior, precision and timeout are the optional inputs in SARSOP, and they are not related to the our engineering problem. The output contains two variables, “out_XXX$vectors” and “out_XXX$action”, representing the alpha-vectors and the corresponding actions, respectively.

Save the outputs by

```
writeMat("OutputSARSOP_info6.mat", 
alpha_S_NoSHM = out_S_NoSHM$vectors, actions_S_NoSHM = out_S_NoSHM$action, 
alpha_S_SHM   = out_S_SHM$vectors,   actions_S_SHM   = out_S_SHM$action,
alpha_A_NoSHM = out_A_NoSHM$vectors, actions_A_NoSHM = out_A_NoSHM$action, 
alpha_A_SHM   = out_A_SHM$vectors,  actions_A_SHM   = out_A_SHM$action)
```
where “out_S_XXX” parameters are used for constrained settings later. 


## VoI Analysis

