function [Result,OnLine,OffLine,MinMaxMeanAdapt]=PsoProcess(SwarmSize,ParticleSize,ParticleScope,InitFunc,StepFindFunc,AdaptFunc,IsStep,IsDraw,LoopCount,IsPlot)
%功能描述：一个循环n次的PSO算法完整过程，返回这次运行的最小与最大的平均适应度,以及在线性能与离线性能
%[Result,OnLine,OffLine,MinMaxMeanAdapt]=PsoProcess(SwarmSize,ParticleSize,ParticleScope,InitFunc,StepFindFunc,AdaptFunc,IsStep,IsDraw,LoopCount,IsPlot)
%输入参数：SwarmSize:种群大小的个数
%输入参数：ParticleSize：一个粒子的维数
%输入参数：ParticleScope:一个粒子在运算中各维的范围；
%         ParticleScope格式:
%           3维粒子的ParticleScope格式:
%                                   [x1Min,x1Max
%                                    x2Min,x2Max
%                                    x3Min,x3Max]
%
%输入参数:InitFunc:初始化粒子群函数
%输入参数:StepFindFunc:单步更新速度，位置函数
%输入参数：AdaptFunc：适应度函数
%输入参数：IsStep：是否每次迭代暂停；IsStep＝0，不暂停，否则暂停。缺省不暂停
%输入参数：IsDraw：是否图形化迭代过程；IsDraw＝0，不图形化迭代过程，否则，图形化表示。缺省不图形化表示
%输入参数：LoopCount：迭代的次数；缺省迭代100次
%输入参数：IsPlot：控制是否绘制在线性能与离线性能的图形表示；IsPlot=0,不显示；
%                 IsPlot=1；显示图形结果。缺省IsPlot=1
%
%返回值：Result为经过迭代后得到的最优解
%返回值：OnLine为在线性能的数据
%返回值：OffLine为离线性能的数据
%返回值：MinMaxMeanAdapt为本次完整迭代得到的最小与最大的平均适应度
%
%用法[Result,OnLine,OffLine,MinMaxMeanAdapt]=PsoProcess(SwarmSize,ParticleSize,ParticleScope,InitFunc,StepFindFunc,AdaptFunc,IsStep,IsDraw,LoopCount,IsPlot);
%
%异常：首先保证该文件在Matlab的搜索路径中，然后查看相关的提示信息。
%
%编制人：XXX
%编制时间：2007.3.26
%参考文献：XXXXX%

%修改记录：
%添加MinMaxMeanAdapt，以得到性能评估数据
%修改人：XXX
%修改时间：2007.3.27
%参考文献：XXX.

%容错控制
if nargin<4
    error('输入的参数个数错误。')
end

[row,colum]=size(ParticleSize);
if row>1||colum>1
    error('输入的粒子的维数错误，是一个1行1列的数据。');
end
[row,colum]=size(ParticleScope);
if row~=ParticleSize||colum~=2
    error('输入的粒子的维数范围错误。');
end

%设置缺省值
if nargin<7
    IsPlot=1;
    LoopCount=100;
    IsStep=0;
    IsDraw=0;
end
if nargin<8
    IsPlot=1;
    IsDraw=0;
    LoopCount=100;
end
if nargin<9
    LoopCount=100;
    IsPlot=1;
end
if nargin<10
    IsPlot=1;
end

%控制是否显示2维以下粒子维数的寻找最优的过程
if IsDraw~=0
    DrawObjGraphic(ParticleSize,ParticleScope,AdaptFunc);
end

%初始化种群       
[ParSwarm,OptSwarm]=InitFunc(SwarmSize,ParticleSize,ParticleScope,AdaptFunc);

%在测试函数图形上绘制初始化群的位置
if IsDraw~=0
    if 1==ParticleSize
        for ParSwarmRow=1:SwarmSize
            plot([ParSwarm(ParSwarmRow,1),ParSwarm(ParSwarmRow,1)],[ParSwarm(ParSwarmRow,3),0],'r*-','markersize',8);
            text(ParSwarm(ParSwarmRow,1),ParSwarm(ParSwarmRow,3),num2str(ParSwarmRow));
        end
    end

    if 2==ParticleSize
        for ParSwarmRow=1:SwarmSize
            stem3(ParSwarm(ParSwarmRow,1),ParSwarm(ParSwarmRow,2),ParSwarm(ParSwarmRow,5),'r.','markersize',8);
        end
    end
end
    
%暂停让抓图
if IsStep~=0
    disp('开始迭代，按任意键：')
    pause
end

%开始更新算法的调用
for k=1:LoopCount
    %显示迭代的次数：
    disp('----------------------------------------------------------')
    TempStr=sprintf('第 %g 此迭代',k);
    disp(TempStr);
    disp('----------------------------------------------------------')
    
    %调用一步迭代的算法
    [ParSwarm,OptSwarm]=StepFindFunc(ParSwarm,OptSwarm,AdaptFunc,ParticleScope,0.95,0.4,LoopCount,k);
    
    %在目标函数的图形上绘制2维以下的粒子的新位置
    if IsDraw~=0
        if 1==ParticleSize
            for ParSwarmRow=1:SwarmSize
                plot([ParSwarm(ParSwarmRow,1),ParSwarm(ParSwarmRow,1)],[ParSwarm(ParSwarmRow,3),0],'r*-','markersize',8);
                text(ParSwarm(ParSwarmRow,1),ParSwarm(ParSwarmRow,3),num2str(ParSwarmRow));
            end
        end

        if 2==ParticleSize
            for ParSwarmRow=1:SwarmSize
                stem3(ParSwarm(ParSwarmRow,1),ParSwarm(ParSwarmRow,2),ParSwarm(ParSwarmRow,5),'r.','markersize',8);
            end
        end
    end
    
    XResult=OptSwarm(SwarmSize+1,1:ParticleSize);
    YResult=AdaptFunc(XResult);    
    if IsStep~=0
        XResult=OptSwarm(SwarmSize+1,1:ParticleSize);
        YResult=AdaptFunc(XResult);    
        str=sprintf('%g步迭代的最优目标函数值%g',k,YResult);
        disp(str);
        disp('下次迭代，按任意键继续');
        pause
    end
    
    %记录每一步的平均适应度
    MeanAdapt(1,k)=mean(ParSwarm(:,2*ParticleSize+1));
end
%for循环结束标志

%记录最小与最大的平均适应度
MinMaxMeanAdapt=[min(MeanAdapt),max(MeanAdapt)];
%计算离线与在线性能
for k=1:LoopCount
    OnLine(1,k)=sum(MeanAdapt(1,1:k))/k;
    OffLine(1,k)=max(MeanAdapt(1,1:k));
end

for k=1:LoopCount
    OffLine(1,k)=sum(OffLine(1,1:k))/k;
end

%绘制离线性能与在线性能曲线
if 1==IsPlot
    figure
    hold on
    title('离线性能曲线图')
    xlabel('迭代次数');
    ylabel('离线性能');
    grid on
    plot(OffLine);

    figure
    hold on
    title('在线性能曲线图')
    xlabel('迭代次数');
    ylabel('在线性能');
    grid on
    plot(OnLine);
end

%记录本次迭代得到的最优结果
XResult=OptSwarm(SwarmSize+1,1:ParticleSize);
YResult=AdaptFunc(XResult);
Result=[XResult,YResult];