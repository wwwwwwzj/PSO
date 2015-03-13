Scope=[-10 10;-10 10];%粒子每维的限制范围  
qun=20;%粒子群的规模  
lizi=2;%每个粒子的维数  
[Result,OnLine,OffLine,MinMaxMeanAdapt,BestofStep]=HybirdPsoProcessByCircle(qun,lizi,Scope,@HybirdInitSwarm,@HybirdStepPso,@Rastrigin,0,0,1000,0);  