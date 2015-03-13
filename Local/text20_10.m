Scope=[-10 10;-10 10;-10 10;-10 10;-10 10;-10 10;-10 10;-10 10;-10 10;-10 10];%粒子的维数限制范围  
qun=20;%粒子群种群规模  
lizi=10;%粒子的维数  
[Result,OnLine,OffLine,MinMaxMeanAdapt,BestofStep]=LocalPsoProcessByCircle(qun,lizi,Scope,@LocalInitSwarm,@LocalStepPsoByCircle,@Rastrigin,0,0,4000,0);  