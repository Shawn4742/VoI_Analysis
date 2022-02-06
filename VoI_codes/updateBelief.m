% b = [0.7 0.2 0.1];
% 
% % Observations
% e = 0.05;
% Obs = [1-e   e   0;
%         e   1-e  0;
%         0    0   1];

function [eI, uI] = updateBelief(b, Obs)

% Probability of each observation based on the current belief.
eI = zeros(size(Obs,2), 1);

for j = 1: size(Obs,2)
    for l = 1: length(b)
         eI(j) = eI(j) + Obs(l,j) * b(l);
    end
end


% update belief after each observation.
uI = zeros(length(b),1);

for i = 1: length(b)
    for j = 1: size(Obs,2)
        uI(i,j) = Obs(i,j) * b(i) / eI(j);
        
        % Set NaN --> 0, which means this observation doesn't exist.
        if eI(j) == 0
            uI(i,j) = 0;
        end
        
    end
end

end