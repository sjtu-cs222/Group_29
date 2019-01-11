function [ Y0 ] = doptoffovera( a0,L,S,F,T,d,p,beta1,beta2,w,W,dy,dx )
% Initialize the Interior Point Method with feasible decisions
X0=ones(L,S,F,T);
Y0=ones(S,F,T);
for t=1:T
    for l=1:L
        for f=1:F
            X0(l,:,f,t)=max(a0(l,:,t))*0.1001*ones(S,1);
        end  
    end
    for s=1:S
        for f=1:F
            Y0(s,f,t)=max(a0(:,f,t))*10.1;
        end
    end
end
theta1=1e3;                                                                % Interior Point Method parameter
X1=X0;
Y1=Y0;

% start the iteration
while theta1 < 1e3                                                         % Interior Point Method condition
    fdiff=200;
    alpha1x=abs(fdiff)/100;                                                % step size for variable X
    alpha1y=alpha1x*10;                                                    % step size for variable Y
    while fdiff > 100 || fdiff<0
        %update X
        for t=1:T
            for l=1:L
                for s=1:S
                    for f=1:F
                        if t==1
                            X0(l,s,f,t)=X1(l,s,f,t)-alpha1x*(d(l,s)+beta1(l,s,f)*...
                                (1+sign(X1(l,s,f,t+1)-X1(l,s,f,t)))-1/(theta1*...
                                (sum(X1(l,:,f,t))-a0(l,f,t)))+1/(theta1*(Y1(s,f,t)-...
                                sum(X1(:,s,f,t))))+1/(theta1*(dx(l,s,f)-X1(l,s,f,t)))-...
                                1/(theta1*(dx(l,s,f)-X1(l,s,f,t+1)+...
                                X1(l,s,f,t)))-1/(theta1*(X1(l,s,f,t)+...
                                dx(l,s,f)))+1/(theta1*X1(l,s,f,t+1)-X1(l,s,f,t)+...
                                dx(l,s,f)));
                        elseif t==T
                            X0(l,s,f,t)=X1(l,s,f,t)-alpha1x*(d(l,s)+beta1(l,s,f)*...
                                (sign(X1(l,s,f,t)-X1(l,s,f,t-1)))-1/(theta1*...
                                (sum(X1(l,:,f,t))-a0(l,f,t)))+1/(theta1*(Y1(s,f,t)-...
                                sum(X1(:,s,f,t))))+1/(theta1*(dx(l,s,f)-X1(l,s,f,t)+...
                                X1(l,s,f,t-1)))-1/(theta1*(X1(l,s,f,t)-X1(l,s,f,t-1)+...
                                dx(l,s,f))));
                        else
                            X0(l,s,f,t)=X1(l,s,f,t)-alpha1x*(d(l,s)+beta1(l,s,f)*...
                                (sign(X1(l,s,f,t)-X1(l,s,f,t-1))+sign(X1(l,s,f,t+1)-...
                                X1(l,s,f,t)))-1/(theta1*(sum(X1(l,:,f,t))-a0(l,f,t)))+...
                                1/(theta1*(Y1(s,f,t)-sum(X1(:,s,f,t))))+1/(theta1*...
                                (dx(l,s,f)-X1(l,s,f,t)+X1(l,s,f,t-1)))-1/(theta1*...
                                (dx(l,s,f)-X1(l,s,f,t+1)+X1(l,s,f,t)))-1/(theta1*...
                                (X1(l,s,f,t)-X1(l,s,f,t-1)+dx(l,s,f)))+1/(theta1*...
                                X1(l,s,f,t+1)-X1(l,s,f,t)+dx(l,s,f)));
                        end
                    end
                end
            end
            
            %update Y
            for s=1:S
                for f=1:F
                    if t==1
                        Y0(s,f,t)=Y1(s,f,t)-alpha1y*(p(s,f)+beta2(s,f)*...
                            (1+sign(Y1(s,f,t+1)-Y1(s,f,t)))-1/(theta1*(Y1(s,f,t)-...
                            sum(X1(:,s,f,t))))+1/(theta1*(dy(s,f)-Y1(s,f,t)))-...
                            1/(theta1*(dy(s,f)-Y1(s,f,t+1)+Y1(s,f,t)))-1/...
                            (theta1*(Y1(s,f,t)+dy(s,f)))+1/(theta1*Y1(s,f,t+1)-Y1(s,f,t)+...
                            dy(s,f))+w(s,f)/(theta1*(W(s,1)-sum(Y1(s,:,t).*w(s,:)))));
                    elseif t==T
                        Y0(s,f,t)=Y1(s,f,t)-alpha1y*(p(s,f)+beta2(s,f)*...
                            (sign(Y1(s,f,t)-Y1(s,f,t-1)))-1/(theta1*(Y1(s,f,t)-...
                            sum(X1(:,s,f,t))))+1/(theta1*(dy(s,f)-Y1(s,f,t)+...
                            Y1(s,f,t-1)))-1/(theta1*(Y1(s,f,t)-Y1(s,f,t-1)+...
                            dy(s,f)))+w(s,f)/(theta1*(W(s,1)-sum(Y1(s,:,t).*w(s,:)))));
                    else
                        Y0(s,f,t)=Y1(s,f,t)-alpha1y*(p(s,f)+beta2(s,f)*...
                            (sign(Y1(s,f,t)-Y1(s,f,t-1))+sign(Y1(s,f,t+1)-...
                            Y1(s,f,t)))-1/(theta1*(Y1(s,f,t)-sum(X1(:,s,f,t))))+...
                            1/(theta1*(dy(s,f)-Y1(s,f,t)+Y1(s,f,t-1)))-1/(theta1*...
                            (dy(s,f)-Y1(s,f,t+1)+Y1(s,f,t)))-1/(theta1*...
                            (Y1(s,f,t)-Y1(s,f,t-1)+dy(s,f)))+1/(theta1*...
                            Y1(s,f,t+1)-Y1(s,f,t)+dy(s,f))+w(s,f)/(theta1*(W(s,1)-...
                            sum(Y1(s,:,t).*w(s,:)))));
                    end
                end
            end
        end
        
        if min(min(min(min(X0))))>0 && min(min(min(Y0)))>0
            % update the improvement of the objective value
            f0=optcost_off( S,F,T,p,d,beta1,beta2,X0,Y0,X1,Y1 )
            fdiff=f0(1,2)-f0(1,1)
            if fdiff>=0
            % save latest X,Y
            X1=X0;
            Y1=Y0;
            alpha1x=abs(fdiff)/10;                                         % step size for variable X
            alpha1y=alpha1x*10;                                            % step size for variable Y
            else
                X0=X1;
                Y0=Y1;
                alpha1x=alpha1x/10;                                        % step size for variable X
                alpha1y=alpha1x*10;                                        % step size for variable Y
            end
        else
            fdiff=200;
            X0=X1;
            Y0=Y1;
            alpha1x=alpha1x/10;                                            % step size for variable X
            alpha1y=alpha1x*10;                                            % step size for variable Y
        end
    end
            
    % update Interior Point Method parameter
    theta1=10*theta1
end

%disp(Y0);

%{
fudual=f0(1,1)*ones(L+1,F,T);
for l=1:L
    for f=1:F
        for t=1:T
            fudual(l,f,t)=1/(theta1*(a0(l,f,t)-sum(X0(:,s,f,t))));
        end
    end
end
fprintf('finish doptoffovera')
%}
%end
