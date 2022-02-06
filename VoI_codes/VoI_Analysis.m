%%%% 

%%%% MC: see info6_trajectory.m



% load from SARSOP
load('POMDP_Input.mat');


%%% -------------------- %%%
% m_B_actions does not inlcude Failure state.
num_beliefs = 1500;
delta_s = 1./ num_beliefs;
m_B_s2 = 0: delta_s: 1;
m_B = horzcat(1-m_B_s2', m_B_s2');

% m_Certainty = eye(n_s) * m_T';
m_B_full = m_B;
m_B_full(end+1, end+1) = 1;

% If pruning alpha sets
prune_flag = 1;
if prune_flag == 1
    [alpha_S_NoSHM, actions_S_NoSHM] = PruneAlpha(alpha_S_NoSHM, actions_S_NoSHM, m_B);
    [alpha_S_SHM, actions_S_SHM]     = PruneAlpha(alpha_S_SHM, actions_S_SHM, m_B);
    [alpha_A_NoSHM, actions_A_NoSHM] = PruneAlpha(alpha_A_NoSHM, actions_A_NoSHM, m_B);
    [alpha_A_SHM, actions_A_SHM]     = PruneAlpha(alpha_A_SHM, actions_A_SHM, m_B);
end
%%% -------------------- %%%


%%% -------------------- %%%
% Plot policies for agents ans society
plot_policies_3states;
%%% -------------------- %%%

%%% -------------------- %%%
% Cross-product MDPs
% constrct beta and beta2, beta2(k1, k2, state) = sum_obs Obs(state, obs) * Pr[k1, k2 | obs];
beta_S_NoSHM  = buildPG(alpha_S_NoSHM, actions_S_NoSHM, Tr, ObsE1, m_B_full);
beta2_S_NoSHM = constrcutBeta2(int8(beta_S_NoSHM), size(alpha_S_NoSHM, 2), n_s_full, ObsE1, actions_S_NoSHM);

beta_S_SHM  = buildPG(alpha_S_SHM, actions_S_SHM, Tr, ObsE2, m_B_full);
beta2_S_SHM = constrcutBeta2(int8(beta_S_SHM), size(alpha_S_SHM, 2), n_s_full, ObsE2, actions_S_SHM);

% construct argumented transition in cross-product MDPs
Tr_Arg_S_NoSHM = constructTrArg(beta2_S_NoSHM, n_s_full, actions_S_NoSHM, Tr);
Tr_Arg_S_SHM   = constructTrArg(beta2_S_SHM, n_s_full, actions_S_SHM, Tr);

% evaluate policy
Vpi_S_NoSHM = evaluatePolicy(Cost_A, actions_S_NoSHM, Tr_Arg_S_NoSHM, discount, n_s_full);
Vpi_S_SHM   = evaluatePolicy(Cost_A, actions_S_SHM, Tr_Arg_S_SHM, discount, n_s_full);
%%% -------------------- %%%


%%% -------------------- %%%
% Compute Loss and VoI
[V_tilde, V_tilde_F, V_tilde_w, V_tilde_w_F]  =   V_tilde_Losses(m_B, n_s_full, Obs_SHM, alpha_S_NoSHM, Vpi_S_NoSHM, alpha_S_SHM, Vpi_S_SHM);
[V_star,  V_star_F,  V_star_w,  V_star_w_F]   =   V_star_Losses(m_B, Obs_SHM, alpha_A_NoSHM, alpha_A_SHM);

VoI_plus =      V_tilde - V_tilde_w_F;
VoI_C_plus =    V_tilde - V_tilde_w;
VoI =           V_star - V_star_w_F;
VoI_C =         V_star - V_star_w_F;
%%% -------------------- %%%



%%% -------------------- %%%
% Plot Loss and VoI
figure(12112)
set(gcf,'color','white')
l10 = plot(m_B(:,2), VoI_plus, '.-', 'markersize', marker_s,  'LineWidth', line_w);
hold on
l11 = plot(m_B(:,2), VoI, '.-','markersize',marker_s,  'LineWidth', line_w);
hold on
l13 =  plot(m_B(:,2), VoI_C_plus, '.-','markersize',marker_s,  'LineWidth', line_w);

title(['VoI^+_{curr}, range in [', num2str( min(VoI_C_plus) ), ', ', num2str( max(VoI_C_plus) ), ']'],  'LineWidth', line_w)
set(gca,'FontSize',label_size)
ylabel('flow of information')
xlabel('{b} = [1-b b 0]^{T}')
set(gca,'FontSize',label_size)
leg = legend( [l10 l11 l13], 'VoI^+_F', 'VoI*_F', 'VoI^+_C', 'location', 'northwest'); 
leg.FontSize = 15.5;
hold off


figure(1512)
set(gcf,'color','white')
plot(m_B(:,2), V_star, ':','markersize',marker_s, 'LineWidth', line_w);
hold on
plot(m_B(:,2), V_star_w_F, '^-','markersize',marker_s, 'LineWidth', line_w);
hold on
plot(m_B(:,2), V_star_F, '-','markersize',marker_s, 'LineWidth', line_w);
hold on
plot(m_B(:,2), V_star_w, '^--','markersize',marker_s, 'LineWidth', line_w);
hold on

plot(m_B(:,2), V_tilde, '^-.','markersize',marker_s, 'LineWidth', line_w);
hold on
plot(m_B(:,2), V_tilde_w_F, '*-','markersize',marker_s, 'LineWidth', line_w);
hold on
plot(m_B(:,2), V_tilde_F, ':','markersize',marker_s, 'LineWidth', line_w);
hold on
plot(m_B(:,2), V_tilde_w, '^-','markersize',marker_s, 'LineWidth', line_w);


% ylim([4 5])


title('Loss',  'LineWidth', line_w)
set(gca,'FontSize',label_size)
ylabel('Loss')
xlabel('{b} = [1-b b 0]^{T}')
% legend( 'V^*$', 'V^*_{w,F}', '$V^*_{F}$', '$\tilde{V}$', '$V_{w,F}', 'V_F', 'location', 'northwest'); 
leg2 = legend('$V^*$', '$V^*_{w,F}$', '$V^*_{F}$', '$V^*_{w}$', '$\tilde{V}$', '$\tilde{V}_{w,F}$', '$\tilde{V}_F$', '$\tilde{V}_w$');
set(leg2,  'location', 'southeast') 
set(leg2, 'Interpreter','latex')
set(leg2, 'FontSize', lgd_size)
hold off
%%% -------------------- %%%