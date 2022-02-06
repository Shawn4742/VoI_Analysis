function [alpha2, actions2] = PruneAlpha(alpha, actions, m_B)

% Prune the alpha vectors, because some do not dominate the triangular domain
% Only keep the alpha vectors that have an impact on the triangular domain
% + failure point

m_B_nodes = zeros(size(m_B,1),1);
for i = 1: size(m_B, 1)
    
%     temp = m_B(i,:) * alpha(1:end-1, :);
    
    temp = m_B(i,:) * alpha(1:end-1, :);
    [~, idx] = max(temp);
    
    % assign each node number to each discrete belief.
    m_B_nodes(i) = idx;
    
end 


% plus the index of the alpha vector for failure point.
[~, idx] = max( alpha(end, :) );
m_B_nodes(end+1) = idx;


% start to prune the alpha vectors
record_emptysets = [];
for i = 1: length(actions)
    
    if sum(m_B_nodes == i) == 0
        
        record_emptysets(end+1) = i;
        
    end
    
end

alpha2 = alpha;
actions2 = actions;

alpha2(:, record_emptysets) = [];
actions2(record_emptysets) = [];

end