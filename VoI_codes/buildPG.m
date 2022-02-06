function [beta] = buildPG(alpha, actions, Tr, Obs2, m_B)


% works for four-state policy
m_B_nodes = zeros(size(m_B,1),1);
for i = 1: size(m_B, 1)
    temp = m_B(i,:) * alpha;
    [~, idx] = max(temp);
    
    % assign each node number to each discrete belief.
    m_B_nodes(i) = idx;
    
end 


% construct policy graph
% by selecting the average belief among each belief domain
% controlled by each node/alpha vector

% ave_belief = zeros(size(alpha'));

% beta = zeros( size(Tr, 1), size(Obs2(:,:,1), 2) ); %%% WRONG

% actions is the action assigned for each node
for i = 1: length(actions)
    
%     sum(m_B_nodes == i)
    
    % maybe two seperate domain? % That's the problem!
    belief =  mean( m_B(m_B_nodes == i, :), 1 );
    
%     % find an arbitary point in the same domain.
%     temp = m_B(m_B_nodes == i, :);
%     belief = temp(randi(size(temp, 1)), :);
%     belief
    
    
    
    
    
%     size(belief)
%     size(alpha)
    
    % check if the mean is still belonging to that domain
    temp = belief * alpha;
    [~, idx2] = max(temp);
    
    if idx2 ~= i
        display('The mean state is not in the dominated domain')
        display(i)
    end
    
    
    
%     % random pick up a node
%     Bdomain = m_B(m_B_nodes == i, :);
%     
%     size(Bdomain)
%     randi(size(Bdomain, 1) )
%     
%     belief = Bdomain(randi( size(Bdomain, 1) ), :);
    
    % don't inlcude the failure state --> belief
%     belief = [belief 0];
%     ave_belief(i, :) = belief;
    
    % take an action and get an observation
    [~, bf] = updateBelief(belief * Tr(:,:, actions(i)), Obs2(:,:,actions(i)));
   
%     size(bf, 2)
    % find which belief domain uI belongs to
    for j = 1: size(bf, 2)
        
%         bf(:, j)
        if sum(bf(:, j)) < 0.0001
            idx = 0;
        else  
            temp = bf(:, j)' * alpha(1:end, :);
            [~, idx] = max(temp);
        end 
        
    beta(i, j) = idx;    
    end
    

    
end
end