%%% Plot the policy. 
%%% Define alpha, alpha2, actions, actions2, figure_idx

m_B_actions = zeros(size(m_B,1),1);
for i = 1: size(m_B, 1)
    
    temp = [m_B(i,:) 0]  * alpha;
    [~, idx] = max(temp);
    m_B_actions(i) = actions(idx);
    
end 

m_dn = m_B(m_B_actions == 1, :);
m_rp = m_B(m_B_actions == 2, :);

temp = [0 0 1]  * alpha;
[~, idx] = max(temp);
m_B_actions_failure = actions(idx);


figure(figure_idx)
clf
hold on;
l1 = plot(m_dn(:,2), 0.2 * ones(size(m_dn,1),1), '.','color',[0.95, 0.85, 0.05],...
    'markersize',14);
hold on
l4 = plot(m_rp(:,2), 0.2 * ones(size(m_rp,1),1), '.','color',[0.8, 0.3840, 0.5560],...
    'markersize',14);

hold on
if m_B_actions_failure == 1
    plot(1, 0.25, '.','color',[0.95, 0.85, 0.05],...
    'markersize',45);
elseif m_B_actions_failure == 2
    plot(1, 0.25, '.','color',[0.8, 0.3840, 0.5560],...
    'markersize',25);
end
text(0.8, 0.25, 'failure\rightarrow','FontSize',14)
% leg = legend( [l1 l4], 'DN', 'Rp', 'location', 'northwest'); 
hold off


m_B_actions2 = zeros(size(m_B,1),1);
for i = 1: size(m_B, 1)
    
    temp = [m_B(i,:) 0]  * alpha2;
%     [minCost(i), idx] = max(temp);
    [~, idx] = max(temp);
    m_B_actions2(i) = actions2(idx);
    
end 

m_dn = m_B(m_B_actions2 == 1, :);
m_rp = m_B(m_B_actions2 == 2, :);

temp = [0 0 1]  * alpha2;
[~, idx] = max(temp);
m_B_actions_failure = actions2(idx);

%%% Plot the policy. %%%
figure(figure_idx)
hold on;
l1 = plot(m_dn(:,2), 0.4 * ones(size(m_dn,1),1), '.','color',[0.95, 0.85, 0.05],...
    'markersize',14);
hold on
l4 = plot(m_rp(:,2), 0.4 * ones(size(m_rp,1),1), '.','color',[0.8, 0.3840, 0.5560],...
    'markersize',14);

hold on
if m_B_actions_failure == 1
    plot(1, 0.45, '.','color',[0.95, 0.85, 0.05],...
    'markersize',45);
elseif m_B_actions_failure == 2
    plot(1, 0.45, '.','color',[0.8, 0.3840, 0.5560],...
    'markersize',25);
end
text(0.8, 0.45, 'failure\rightarrow','FontSize',14)


axis([0 1 0 0.6])
set(gca,'YTick',[])
leg = legend( [l1 l4], 'DN', 'Rp', 'location', 'northwest'); 
leg.FontSize = 15.5;
yl = ylabel('Lower: w/o monitoring, Upper: with monitoring');
yl.FontSize = 12;
set(gcf,'color','white')
title(figure_title)
set(gca,'FontSize',label_size)
hold off


