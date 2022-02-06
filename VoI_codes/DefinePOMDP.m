clear;

% number of physical state
n_s_full = 3;


% Define the transition matrix T
p12 = 0.04;
p13 = 0.0;
p23 = p12 * 3;

% Cost for society
Cf   = -1;
Cr_A = -0.05;
Cr_S = -0.25;

T_dn = [1-p12   p12   0;
        0       p23   1 - p23;
        0       0     1];   
    
T_rp = ones(size(T_dn, 1), 1) * T_dn(1, :);
Tr(:,:,1) = T_dn; 
Tr(:,:,2) = T_rp; 
    
    
% Define Observations
e_NoSHM = 0.5;
e_SHM = 0.1;
e_SHM2 = e_SHM;
  
Obs_SHM = [1-e_SHM   e_SHM     0;
           e_SHM2    1-e_SHM2   0;
           0     0    1];

Obs_NoSHM = [1-e_NoSHM   e_NoSHM     0;
             e_NoSHM    1-e_NoSHM   0;
             0     0    1];

Cost_S = [ 0 Cr_S;
           0 Cr_S;
          Cf Cr_S + Cf];


% % Cost for agents.
Cost_A = [ 0 Cr_A;
           0 Cr_A;
           Cf Cr_A+Cf];


discount = 0.95;    

for i = 1: size(Tr,3)
    % No SHM
    ObsE1(:,:,i) = Obs_NoSHM;

    % SHM
    ObsE2(:,:,i) = Obs_SHM;
end

% run tryPOMDPs.R
save('POMDP_Input', 'Tr', 'n_s_full', 'Cost_A', 'Cost_S', 'ObsE1', 'ObsE2', 'discount');
