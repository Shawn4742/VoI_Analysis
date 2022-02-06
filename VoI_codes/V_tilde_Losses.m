function [V_tilde, V_tilde_F, V_tilde_w, V_tilde_w_F] = V_tilde_Losses(m_B, S, ObsI, alpha_S_NoSHM, Vpi_S_NoSHM, alpha_S_SHM, Vpi_S_SHM)

V_tilde = zeros(size(m_B, 1), 1);
for i = 1: size(m_B, 1)
    temp = [m_B(i,:) 0]* alpha_S_NoSHM;
    [~, ida] = max(temp);
    V_tilde(i) = -[m_B(i, :) 0] * Vpi_S_NoSHM( (ida-1)*S + 1: ida*S );
end

V_tilde_F = zeros(size(m_B, 1), 1);
for i = 1: size(m_B, 1)
    temp = [m_B(i,:) 0 ] * alpha_S_SHM;
    [~, ida] = max(temp);
    V_tilde_F(i) = -[m_B(i, :) 0] * Vpi_S_SHM( (ida-1)*S + 1: ida*S );
end

V_tilde_w = zeros(size(m_B, 1), 1);
for i = 1: size(m_B, 1) 
    [Pr_beliefs, updated_beliefs] = updateBelief( [m_B(i,:) 0], ObsI );
    
    temp2 = 0;
    for j = 1: length(Pr_beliefs)
        b = updated_beliefs(:, j)';
        temp = b * alpha_S_NoSHM;
        [~, ida] = max(temp);
        temp2 = temp2 + Pr_beliefs(j) * b * Vpi_S_NoSHM( (ida-1)*S + 1: ida*S );
    end
    V_tilde_w(i) = -temp2;
end

V_tilde_w_F = zeros(size(m_B, 1), 1);
for i = 1: size(m_B, 1)
    [Pr_beliefs, updated_beliefs] = updateBelief( [m_B(i,:) 0], ObsI );
    
    temp2 = 0;
    for j = 1: length(Pr_beliefs)
        b = updated_beliefs(:, j)';
        temp = b * alpha_S_SHM;
        [~, ida] = max(temp);
        temp2 = temp2 + Pr_beliefs(j) * b * Vpi_S_SHM( (ida-1)*S + 1: ida*S );
    end
    V_tilde_w_F(i) = -temp2;
end


end