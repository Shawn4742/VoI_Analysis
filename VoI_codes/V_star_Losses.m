function [V_star, V_star_F, V_star_w, V_star_w_F] = V_star_Losses(m_B, ObsI, alpha_A_NoSHM, alpha_A_SHM)

V_star = zeros(size(m_B, 1), 1);
for i = 1: size(m_B, 1)
    temp = m_B(i,:) * alpha_A_NoSHM(1:end-1, :);
    V_star(i) = -max(temp);
end

 V_star_w = zeros(size(m_B, 1), 1);
for i = 1: size(m_B, 1)
    [Pr_beliefs, updated_beliefs] = updateBelief( [m_B(i,:) 0], ObsI );
  
    temp2 = 0;
    for j = 1: length(Pr_beliefs)
        b = updated_beliefs(:, j)';
        temp2 = temp2 + Pr_beliefs(j) * max(b * alpha_A_NoSHM);
    end
     V_star_w(i) = -temp2;
end


V_star_F = zeros(size(m_B, 1), 1);
for i = 1: size(m_B, 1)
    temp = [m_B(i,:) 0] * alpha_A_SHM;
    V_star_F(i) = -max(temp);
end

 V_star_w_F = zeros(size(m_B, 1), 1);
for i = 1: size(m_B, 1)
    [Pr_beliefs, updated_beliefs] = updateBelief( [m_B(i,:) 0], ObsI );
  
    temp2 = 0;
    for j = 1: length(Pr_beliefs)
        b = updated_beliefs(:, j)';
        temp2 = temp2 + Pr_beliefs(j) * max(b * alpha_A_SHM);
    end
     V_star_w_F(i) = -temp2;
end

end
