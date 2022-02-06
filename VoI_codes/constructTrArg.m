function [T2r] = constructTrArg(beta2, n_s_full, actions, Tr)
% construct pair <nodes, state>
% e.g. <node 1 , state 1>, <node 2 , state 1>, ....
K = length(actions);
ns = n_s_full * K;

T2r = zeros(ns, ns);
for i = 1: ns
    for j = 1: ns
        
        % a --> state, b --> node
        [a, b] = ind2sub([ n_s_full K], i);
        [a2, b2] = ind2sub([ n_s_full K], j);
        
        T2r(i, j) = Tr(a, a2, actions(b)) * beta2(b, b2, a2);
        
    end
end

end