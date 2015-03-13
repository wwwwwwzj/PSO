function [ParSwarm,OptSwarm]=LocalStepPsoByCircle(ParSwarm,OptSwarm,AdaptFunc,ParticleScope,MaxW,MinW,LoopCount,CurCount)  
% 功能描述：局部版本：采用环形邻域的方法。基本的粒子群算法的单步更新位置,速度的算法  
%  
%[ParSwarm,OptSwarm]=LocalStepPsoByCircle(ParSwarm,OptSwarm,AdaptFunc,ParticleScope,MaxW,MinW,LoopCount,CurCount)  
%  
% 输入参数：ParSwarm:粒子群矩阵，包含粒子的位置，速度与当前的目标函数值  
%输入参数：OptSwarm：包含粒子群个体最优解与全局最优解的矩阵  
%输入参数：ParticleScope:一个粒子在运算中各维的范围；  
% 输入参数：AdaptFunc：适应度函数  
%输入参数：LoopCount：迭代的总次数  
%输入参数：CurCount：当前迭代的次数  
%  
% 返回值：含意同输入的同名参数  
%  
%用法：[ParSwarm,OptSwarm]=LocalStepPsoByCircle(ParSwarm,OptSwarm,AdaptFunc,ParticleScope,MaxW,MinW,LoopCount,CurCount)  
%  
% 异常：首先保证该文件在Matlab的搜索路径中，然后查看相关的提示信息。  
%  
%编制人：XXX  
%编制时间：2010.5.6  
%参考文献：XXX  
%参考文献：XXX  
%  
%修改记录  
%----------------------------------------------------------------  
%2010.5.6  
%修改人：XXX  
% 添加2*unifrnd(0,1).*SubTract1(row,:)中的unifrnd(0,1)随机数，使性能大为提高  
%参照基于MATLAB的粒子群优化算法程序设计  
%  
% 总体评价：使用这个版本的调节系数，效果比较好  
%  
  
%容错控制  
if nargin~=8  
    error('输入的参数个数错误。')  
end  
if nargout~=2  
    error('输出的个数太少，不能保证循环迭代。')  
end  
  
%开始单步更新的操作  
  
%*********************************************  
%***** 更改下面的代码，可以更改惯性因子的变化*****  
%---------------------------------------------------------------------  
% 线形递减策略  
w=MaxW-CurCount*((MaxW-MinW)/LoopCount);  
%---------------------------------------------------------------------  
%w 固定不变策略  
%w=0.7;  
%---------------------------------------------------------------------  
% 参考文献：陈贵敏，贾建援，韩琪，粒子群优化算法的惯性权值递减策略研究，西安交通大学学报，2006，1  
%w 非线形递减，以凹函数递减  
%w=(MaxW-MinW)*(CurCount/LoopCount)^2+(MinW-MaxW)*(2*CurCount/LoopCount)+MaxW;  
%---------------------------------------------------------------------  
%w 非线形递减，以凹函数递减  
%w=MinW*(MaxW/MinW)^(1/(1+10*CurCount/LoopCount));  
%*****更改上面的代码，可以更改惯性因子的变化*****  
%*********************************************  
  
% 得到粒子群群体大小以及一个粒子维数的信息  
[ParRow,ParCol]=size(ParSwarm);  
  
%得到粒子的维数  
ParCol=(ParCol-1)/2;  
SubTract1=OptSwarm(1:ParRow,:)-ParSwarm(:,1:ParCol);%粒子自身历史最优解位置减去粒子当前位置  
SubTract2=OptSwarm(ParRow+1:end-1,:)-ParSwarm(:,1:ParCol); %粒子领域最优解位置减去粒子当前位置 
%*********************************************  
%***** 更改下面的代码，可以更改c1,c2的变化*****  
c1=2.05;  
c2=2.05;  
%---------------------------------------------------------------------  
%con=1;  
%c1=4-exp(-con*abs(mean(ParSwarm(:,2*ParCol+1))-AdaptFunc(OptSwarm(ParRow+1,:))));  
%c2=4-c1;  
%----------------------------------------------------------------------  
%***** 更改上面的代码，可以更改c1,c2的变化*****  
%*********************************************  
for row=1:ParRow     
   TempV=w.*ParSwarm(row,ParCol+1:2*ParCol)+c1*unifrnd(0,1).*SubTract1(row,:)+c2*unifrnd(0,1).*SubTract2(row,:);  
   %限制速度的代码  
   for h=1:ParCol  
       if TempV(:,h)>ParticleScope(h,2)/2.0  
           TempV(:,h)=ParticleScope(h,2)/2.0;  
       end  
       if TempV(:,h)<-ParticleScope(h,2)/2.0  
           TempV(:,h)=(-ParticleScope(h,2)+1e-10)/2.0;  
           %加1e-10防止适应度函数被零除  
       end  
   end    
     
   % 更新速度  
   ParSwarm(row,ParCol+1:2*ParCol)=TempV;  
     
   %*********************************************  
   %***** 更改下面的代码，可以更改约束因子的变化*****  
   %---------------------------------------------------------------------  
   %a=1;  
   %---------------------------------------------------------------------  
   a=0.729;  
   %***** 更改上面的代码，可以更改约束因子的变化*****  
   %*********************************************  
     
   % 限制位置的范围  
   TempPos=ParSwarm(row,1:ParCol)+a*TempV;  
   for h=1:ParCol  
       if TempPos(:,h)>ParticleScope(h,2)  
           TempPos(:,h)=ParticleScope(h,2);  
       end  
       if TempPos(:,h)<=ParticleScope(h,1)  
           TempPos(:,h)=ParticleScope(h,1)+1e-10;             
       end  
   end  
  
   %更新位置   
   ParSwarm(row,1:ParCol)=TempPos;  
     
   % 计算每个粒子的新的适应度值  
   ParSwarm(row,2*ParCol+1)=AdaptFunc(ParSwarm(row,1:ParCol));  
   if ParSwarm(row,2*ParCol+1)>AdaptFunc(OptSwarm(row,1:ParCol))  
       OptSwarm(row,1:ParCol)=ParSwarm(row,1:ParCol);  
   end  
end  
%for循环结束  
%确定邻域的范围  
linyurange=fix(ParRow/2);  
%确定当前迭代的邻域范围  
jiange=ceil(LoopCount/linyurange);  
linyu=ceil(CurCount/jiange);  
for row=1:ParRow
    if row-linyu>0&&row+linyu<=ParRow
        tempM =[ParSwarm(row-linyu:row-1,:);ParSwarm(row+1:row+linyu,:)];
        
        [maxValue,linyurow]=max(tempM(:,2*ParCol+1));
        if maxValue>AdaptFunc(OptSwarm(ParRow+row,:))
            OptSwarm(ParRow+row,:)=tempM(linyurow,1:ParCol);
        end
    else
        if row-linyu<=0
            %该行上面的部分突出了边界，下面绝对不会突破边界
            if row==1
                tempM=[ParSwarm(ParRow+row-linyu:end,:);ParSwarm(row+1:row+linyu,:)];
                [maxValue,linyurow]=max(tempM(:,2*ParCol+1));
                if maxValue>AdaptFunc(OptSwarm(ParRow+row,:))
                    OptSwarm(ParRow+row,:)=tempM(linyurow,1:ParCol);
                end
            else
                tempM=[ParSwarm(1:row-1,:);ParSwarm(ParRow+row-linyu:end,:);ParSwarm(row+1:row+linyu,:)];
                [maxValue,linyurow]=max(tempM(:,2*ParCol+1));
                if maxValue>AdaptFunc(OptSwarm(ParRow+row,:))
                    OptSwarm(ParRow+row,:)=tempM(linyurow,1:ParCol);
                end
            end
        else
            %该行下面的部分突出了边界，上面绝对不会突破边界
            if row==ParRow
                tempM=[ParSwarm(ParRow-linyu:row-1,:);ParSwarm(1:linyu,:)];
                [maxValue,linyurow]=max(tempM(:,2*ParCol+1));
                if maxValue>AdaptFunc(OptSwarm(ParRow+row,:))
                    OptSwarm(ParRow+row,:)=tempM(linyurow,1:ParCol);
                end
            else
                tempM=[ParSwarm(row-linyu:row-1,:);ParSwarm(row+1:end,:);ParSwarm(1:linyu-(ParRow-row),:)];
                [maxValue,linyurow]=max(tempM(:,2*ParCol+1));
                if maxValue>AdaptFunc(OptSwarm(ParRow+row,:))
                    OptSwarm(ParRow+row,:)=tempM(linyurow,1:ParCol);
                end
            end
        end
    end
end
%for循环结束
%寻找适应度函数值最大的解在矩阵中的位置(行数)，进行全局最优的改变
[maxValue,row]=max(ParSwarm(:,2*ParCol+1));  
if AdaptFunc(ParSwarm(row,1:ParCol))>AdaptFunc(OptSwarm(ParRow*2+1,:))  
    OptSwarm(ParRow*2+1,:)=ParSwarm(row,1:ParCol);  
end  