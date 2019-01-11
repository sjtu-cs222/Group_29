function [cost]=optcost_off( S,F,T,p,d,beta1,beta2,X0,Y0,X1,Y1 )

cost1=0;
cost2=0;

for t=1:T
    for s=1:S
        for f=1:F
            if t==1
                cost1=cost1+p(s,f)*Y0(s,f,t)+beta2(s,f)*abs(Y0(s,f,t));
            else
                cost1=cost1+p(s,f)*Y0(s,f,t)+beta2(s,f)*abs(Y0(s,f,t)-Y0(s,f,t-1));
            end
        end
    end
end
   

for t=1:T
    for s=1:S
        for f=1:F
            if t==1
                cost2=cost2+p(s,f)*Y1(s,f,t)+beta2(s,f)*abs(Y1(s,f,t));
            else
                cost2=cost2+p(s,f)*Y1(s,f,t)+beta2(s,f)*abs(Y1(s,f,t)-Y1(s,f,t-1));
            end
        end
    end
end

cost(1,1)=cost2;
cost(1,2)=cost1;

end