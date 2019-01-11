
f0=20;
e=0.1;
F=50;
L=F;
S=50;
T=100;

W0=200*F;   eW=e;
p0=3;     ep=e;
b0=1.5;   eb=e;
w0=5;   ew=e;
dy0=0.1;
ft=fgenerate(f0,e,F,T);

X0=ones(L,S,F,T);
X1=X0;
Y1=ones(S,F,T);

beta1=zeros(L,F,S);
dx=zeros(L,F,S);
d=zeros(L,S);  


for i=1:S
    for j=1:F
        p(i,j)=p0*(1-ep)+2*p0*ep*rand();
    end
end
for i=1:S
    for j=1:F
        beta2(i,j)=b0*(1-eb)+2*b0*eb*rand();
    end
end
for i=1:S
    for j=1:F
        w(i,j)=w0*(1-ew)+2*w0*ew*rand();
    end
end
for i=1:S
    W(i)=W0*(1-eW)+2*W0*eW*rand();
end

dy=dy0*ones(S,F);


result=doptoffovera( ft,F,S,F,T,d,p,beta1,beta2,w,W,dy,dx );
cost=optcost_off( S,F,T,p,d,beta1,beta2,X0,result,X1,Y1 );
off_cost=cost(1,2);
disp(off_cost);

[b1,k1]=online_cost(L,F,S,T,d,p,beta1,beta2,w,W,dy,dx,f0);

y_opt=zeros(S*F,T);
Y_opt=zeros(S,F,T);

for t=1:T
    y_opt(:,t)=b1+k1*ft(:,t);
    for i=1:F
        Y_opt(:,i,t)=y_opt((1+S*(i-1)):i*S,t);
    end
end

Cost=optcost_off( S,F,T,p,d,beta1,beta2,X0,Y_opt,X1,Y1 );
on_cost=Cost(1,2);
disp(60*on_cost);

cr=on_cost/off_cost;
disp(60*cr)