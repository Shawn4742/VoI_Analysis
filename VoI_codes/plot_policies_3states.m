alpha = alpha_S_NoSHM;
actions = actions_S_NoSHM;
alpha2 = alpha_S_SHM;
actions2 = actions_S_SHM;
figure_idx = 134;
figure_title = 'Optimal policy under society constraints ';
plot_policy_3states;

alpha = alpha_A_NoSHM;
actions = actions_A_NoSHM;
alpha2 = alpha_A_SHM;
actions2 = actions_A_SHM;
figure_idx = figure_idx + 1;
figure_title = 'Optimal policy for agents';
plot_policy_3states;