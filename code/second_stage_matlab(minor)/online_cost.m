function [b,k]=online_cost(L,F,S,T,d,p,beta1,beta2,w,W,dy,dx,f0)
ff=zeros(F,F,T);
fff=zeros(F,T);
for t=1:T
    for i=1:F
        for j=1:F
            if t==1
                ff(j,i,t)=f0;
            else
                ff(j,i,t)=ff(j,i,t-1)+f0;
            end
        end
    end
end
for t=1:T
    for i=1:F
        for j=1:F  
            if i==j
                ff(j,i,t)=0;
            end
        end
    end
end 
for t=1:T
    for f=1:F
        if f==1
        fff(f,t)=ff(f,f+1,t);
        else
            fff(f,t)=ff(f,f-1,t);
        end
    end
end

Y=doptoffovera( ff,L,S,F,T,d,p,beta1,beta2,w,W,dy,dx );
x=fff';
x1=ones(T,1);
x2=[x1,x];
Y1=zeros(S*F,T);

for t=1:T
    for i=1:F
        Y1(((i-1)*S+1):(i*S),t)=Y(:,i,t);
    end
end

b=zeros(S*F,1);
k=zeros(S*F,F);

for i=1:F*S
    z1=Y1(i,:)';
    [a]=regress(z1,x2);
    b(i)=a(1);
    for j=1:F
        k(i,j)=a(j+1);
    end
end
end
