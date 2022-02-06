function [beta2] = constrcutBeta2(beta, K, n, Obs2, actions)

Obs = Obs2(:,:,1);


% node, node, obs
yita = zeros(K, K, size(Obs, 2));

% node, node, state,
beta2 = zeros(K, K, n);


for i = 1: size(beta, 1)
    for j = 1: size(beta, 2)
        
        % some entries are 0 in beta, 
        % indicating there is no that observation 
        if beta(i, j) < 1
            continue
        end
        
        yita(i, beta(i, j), j) = 1;        
        
    end
end


for i = 1: K
    for j = 1: K
                
        for s = 1: n
            
            temp = 0;
            for idx_obs = 1: size(Obs, 2)
                temp = temp + Obs2(s, idx_obs, actions(i)) * yita(i, j, idx_obs);
            end
            
            beta2(i, j, s) = temp;            
        end
                
    end
end



end