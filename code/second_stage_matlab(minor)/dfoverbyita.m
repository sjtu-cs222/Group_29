function [ maxa ] = dfoverbyita( CR,Afuture,cofrobust_t,c_rhc,yita1,byita1,Y1,gama1,L,S,F,T,t,beta1,beta2,d,p,w,W,dy,dx )
% Initialize the Interior Point Method with feasible decisions
a0=ones(L,F,T);
a0(:,:,1:t)=Afuture(:,:,1:t,1);
a0(:,:,t+1:T)=Afuture(:,:,t+1:T,1)-0.1*rand(L,F,T-t);
a1=a0;
doptoffa=doptoffovera( a0,L,S,F,T,d,p,beta1,beta2,w,W,dy,dx );

alpha1a = 10;                                          % step-size parameters
inc = 3;
dec = 2;

theta=1e3;                                             % Interior Point Method parameter
   
% start the iteration
while theta < 1e+10                                    % Interior Point Method condition
    
    fdiff1=20;
    
    while fdiff1>10 || fdiff1<0
        
        %update a
        for l=1:L
            for f=1:F
                for tt=t+1:T
                    a0(l,f,tt)=a1(l,f,tt)-alpha1a*(CR*doptoffa(l,f,tt)-sum(d(l,:).*byita1(l,:,f,tt-t))+...
                        1/(theta*(Afuture(l,f,tt,1)-a1(l,f,tt)))-...
                        1/(theta*(a1(l,f,tt)-Afuture(l,f,tt,2))));
                end
            end
        end
        
        if min(min(min(a0(:,:,t+1:T)-Afuture(:,:,t+1:T,2))))>=0 && min(min(min(Afuture(:,:,t+1:T,1)-a0(:,:,t+1:T))))>=0
            % update the improvement of the objective value
            f0=updatekesai11( CR,doptoffa,cofrobust_t,c_rhc,L,S,F,T,p,d,beta1,beta2,yita1,byita1,gama1,Y1,a0,a1,t );
            fdiff1=f0(1,2)-f0(1,1);
            if fdiff1>=0
                fprintf('update')
                % save latest X,Y
                a1=a0;
                doptoffa=doptoffovera( a0,L,S,F,T,d,p,beta1,beta2,w,W,dy,dx );
                if fdiff1 < 1e-6
                    alpha1a = alpha1a * inc;
                end
            else
                fprintf('go back')
                a0=a1;
                alpha1a=alpha1a/dec;
            end
        else
            fprintf('reset fdiff')
            fdiff1=20;
            a0=a1;
            alpha1a=alpha1a/dec;
        end
    end
            
    % update Interior Point Method parameter
    theta=10*theta;
end
maxa=ones(L,F,T+1);
maxa(:,:,t+1:T)=a0(:,:,t+1:T);
maxa(1,1,T+1)=doptoffa(L+1,1,1);
fprintf('finish dfoverbyita')
end