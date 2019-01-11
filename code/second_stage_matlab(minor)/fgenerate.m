function [f]=f_generate( f0,e,F,T )
f=zeros(F,F,T);
for t=1:T
    for i=1:F
        for j=1:F
            x=f0*(1-e)+2*f0*e*rand();
            if t==1
                f(j,i,t)=x;
            else
                f(j,i,t)=f(j,i,t-1)+x;
            end
        end
    end
end
for t=1:T
    for i=1:F  
        for j=1:F
            if i==j
                f(j,i,t)=0;
            end
        end
    end
end 
end
