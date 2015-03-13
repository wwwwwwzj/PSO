function [ParSwarm,OptSwarm]=HybirdInitSwarm(SwarmSize,ParticleSize,ParticleScope,AdaptFunc)  
%功能描述：局部版本的粒子群算法，初始化粒子群，限定粒子群的位置以及速度在指定的范围内  
%[ParSwarm,OptSwarm,BadSwarm]=LocalInitSwarm(SwarmSize,ParticleSize,ParticleScope,AdaptFunc)  
%  
%输入参数：SwarmSize:种群大小的个数  
%输入参数：ParticleSize：一个粒子的维数  
%输入参数：ParticleScope:一个粒子在运算中各维的范围；  
%         ParticleScope格式:  
%           3维粒子的ParticleScope格式:  
%                                   [x1Min,x1Max  
%                                    x2Min,x2Max  
%                                    x3Min,x3Max]  
%  
%输入参数：AdaptFunc：适应度函数  
%  
%输出：ParSwarm初始化的粒子群  
%输出：OptSwarm粒子群当前最优解与每个粒子邻域的最优解，第一次初始化，邻域的区域为0，即为粒子本身  
%  
%用法 [ParSwarm,OptSwarm,BadSwarm]=LocalInitSwarm(SwarmSize,ParticleSize,ParticleScope,AdaptFunc);  
%  
%异常：首先保证该文件在Matlab的搜索路径中，然后查看相关的提示信息。  
%  
%编制人：XXX  
%编制时间：2010.5.6  
%参考文献：无  
%  
  
%容错控制  
if nargin~=4  
    error('输入的参数个数错误。')  
end  
if nargout<2  
    error('输出的参数的个数太少，不能保证以后的运行。');  
end  
  
[row,colum]=size(ParticleSize);  
if row>1||colum>1  
    error('输入的粒子的维数错误，是一个1行1列的数据。');  
end  
[row,colum]=size(ParticleScope);  
if row~=ParticleSize||colum~=2  
    error('输入的粒子的维数范围错误。');  
end  
  
%初始化粒子群矩阵  
  
%初始化粒子群矩阵，全部设为[0-1]随机数  
%rand('state',0);  
ParSwarm=rand(SwarmSize,2*ParticleSize+1);  
  
%对粒子群中位置,速度的范围进行调节  
for k=1:ParticleSize  
    ParSwarm(:,k)=ParSwarm(:,k)*(ParticleScope(k,2)-ParticleScope(k,1))+ParticleScope(k,1);  
    %调节速度，使速度与位置的范围一致  
    ParSwarm(:,ParticleSize+k)=ParSwarm(:,ParticleSize+k)*(ParticleScope(k,2)-ParticleScope(k,1))+ParticleScope(k,1);  
end  
      
%对每一个粒子计算其适应度函数的值  
  
for k=1:SwarmSize  
    ParSwarm(k,2*ParticleSize+1)=AdaptFunc(ParSwarm(k,1:ParticleSize));  
end  
  
%初始化粒子群最优解矩阵,共SwarmSize*2行，其中前SwarmSize行记录粒子自己历史最优解，后SwarmSize行记录邻域最优解  
OptSwarm=zeros(SwarmSize*2+1,ParticleSize);  
%粒子群最优解矩阵全部设为零  
OptSwarm(1:SwarmSize,:)=ParSwarm(1:SwarmSize,1:ParticleSize);  
%计算粒子邻域为1的最优解  
linyu=1;  
    for row=1:SwarmSize  
        if row-linyu>0&&row+linyu<=SwarmSize  
            tempM =[ParSwarm(row-linyu:row-1,:);ParSwarm(row+1:row+linyu,:)];              
            [maxValue,linyurow]=max(tempM(:,2*ParticleSize+1));             
            OptSwarm(SwarmSize+row,:)=tempM(linyurow,1:ParticleSize);             
        else  
            if row-linyu<=0  
                %该行上面的部分突出了边界，下面绝对不会突破边界  
                if row==1  
                    tempM=[ParSwarm(SwarmSize+row-linyu:end,:);ParSwarm(row+1:row+linyu,:)];  
                    [maxValue,linyurow]=max(tempM(:,2*ParticleSize+1));                       
                    OptSwarm(SwarmSize+row,:)=tempM(linyurow,1:ParticleSize);                     
                else  
                    tempM=[ParSwarm(1:row-1,:);ParSwarm(SwarmSize+row-linyu:end,:);ParSwarm(row+1:row+linyu,:)];  
                    [maxValue,linyurow]=max(tempM(:,2*ParticleSize+1));                      
                    OptSwarm(SwarmSize+row,:)=tempM(linyurow,1:ParticleSize);                    
                end  
            else  
                %该行下面的部分突出了边界，上面绝对不会突破边界  
                if row==SwarmSize  
                    tempM=[ParSwarm(SwarmSize-linyu:row-1,:);ParSwarm(1:linyu,:)];  
                    [maxValue,linyurow]=max(tempM(:,2*ParticleSize+1));                       
                    OptSwarm(SwarmSize+row,:)=tempM(linyurow,1:ParticleSize);  
                else  
                    tempM=[ParSwarm(row-linyu:row-1,:);ParSwarm(row+1:end,:);ParSwarm(1:linyu-(SwarmSize-row),:)];    
                    [maxValue,linyurow]=max(tempM(:,2*ParticleSize+1));                      
                    OptSwarm(SwarmSize+row,:)=tempM(linyurow,1:ParticleSize);                      
                end  
            end  
        end  
    end%for  

%寻找适应度函数值最大的解在矩阵中的位置(行数)  
[maxValue,row]=max(ParSwarm(:,2*ParticleSize+1));  
OptSwarm(SwarmSize*2+1,:)=ParSwarm(row,1:ParticleSize);  