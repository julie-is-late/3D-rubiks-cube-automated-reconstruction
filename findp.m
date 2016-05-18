function [ P1, X ] = findp( P1full, P2, ps1, ps2, K )

    [~,numpoints] = size(ps1);
    X = zeros(4, numpoints);
    foundX = false;

    for i=1:4
        if foundX
            continue
        end

        currentP = K*P1full(:,:,i);
        A = [];
        tempX = zeros(4, numpoints);
        for j=1:numpoints
            A(1,:) = ps1(1,j) * currentP(3,:) - currentP(1,:);
            A(2,:) = ps1(2,j) * currentP(3,:) - currentP(2,:);
            A(3,:) = ps2(1,j) * P2(3,:) - P2(1,:);
            A(4,:) = ps2(2,j) * P2(3,:) - P2(2,:);

            [~, ~, v] = svd(A);
            uncalx = v(:,4);
            tempX(:,j) = (uncalx / uncalx(4));
        end

        okvals = true;
        for j=1:numpoints
            % yes I realize this is redundant but it helps me understand it
            % better
            if foundX
                continue
            end 
            if ~okvals
                continue
            end
            R = P1full(:,1:3,i);
            T = P1full(:,4,i);
            
            if (tempX(3, j) < 0)
                okvals = false;
                continue
            end
            
            otherZ = R(3,:)*[eye(3) T]*tempX(:, j);
            if (otherZ < 0)
                okvals = false;
                continue
            end
            %tempX(3, j)
            %otherZ
        end
        if okvals
            X = tempX;
            P1 = currentP;
            foundX = true;
            disp(['it was the ' num2str(i) 'th P1'])
            disp(P1)
        end
    end

end























