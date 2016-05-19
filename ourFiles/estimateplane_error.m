function [ E, T_noise_squared, d ] = estimateplane_error( Theta, X, sigma, P_inlier )
%3DPLANE_ERROR Summary of this function goes here
%   Detailed explanation goes here


E = [];
if ~isempty(Theta) && ~isempty(X)
    
    den = Theta(1)^2 + Theta(2)^2 + Theta(3)^2 + Theta(4)^2;
    
    E = ( ...
        Theta(1)*X(1,:) + ...
        Theta(2)*X(2,:) + ...
        Theta(3)*X(3,:) + ...
        Theta(4)*X(4,:)...
        ).^2 / den;
                
end;

% compute the error threshold
if (nargout > 1)
    
    if (P_inlier == 0)
        T_noise_squared = sigma;
    else
        % Assumes the errors are normally distributed. Hence the sum of
        % their squares is Chi distributed (with 3 DOF since we are 
        % computing the distance of a 3D point to a plane)
        d = 3;
        
        % compute the inverse probability
        T_noise_squared = sigma^2 * chi2inv_LUT(P_inlier, d);

    end;
    
end;

return;