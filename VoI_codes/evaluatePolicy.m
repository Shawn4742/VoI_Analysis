function [Vpi] = evaluatePolicy(CostB, actions, T2r, discount, n_s_full)

K = length(actions);
r = zeros(n_s_full, K);

for i = 1: K
    r(:, i) = CostB(:, actions(i));
end
R = reshape(r, [], 1);

%%%% Policy evaluation %%%%
% Vpi --> follow policy pi_0 under cost c1
Vpi = (eye(size(T2r)) - discount * T2r) \ R;

end