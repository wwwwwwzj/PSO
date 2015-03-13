function [Result,OnLine,OffLine,MinMaxMeanAdapt,BestofStep]=HybirdPsoProcessByCircle(SwarmSize,ParticleSize,ParticleScope,InitFunc,StepFindFunc,AdaptFunc,IsStep,IsDraw,LoopCount,IsPlot)  
% ����������һ��ѭ��n�εľֲ�PSO�㷨�������̣�����������е���С������ƽ����Ӧ��,�Լ�������������������  
%[Result,OnLine,OffLine,MinMaxMeanAdapt]=PsoProcess(SwarmSize,ParticleSize,ParticleScope,InitFunc,StepFindFunc,AdaptFunc,IsStep,IsDraw,LoopCount,IsPlot)  
% ���������SwarmSize:��Ⱥ��С�ĸ���  
%���������ParticleSize��һ�����ӵ�ά��  
%���������ParticleScope:һ�������������и�ά�ķ�Χ��  
%         ParticleScope��ʽ:  
%           3ά���ӵ�ParticleScope��ʽ:  
%                                   [x1Min,x1Max  
%                                    x2Min,x2Max  
%                                    x3Min,x3Max]  
%  
% �������:InitFunc:��ʼ������Ⱥ����  
%�������:StepFindFunc:���������ٶȣ�λ�ú���  
%���������AdaptFunc����Ӧ�Ⱥ���  
%���������IsStep���Ƿ�ÿ�ε�����ͣ��IsStep��0������ͣ��������ͣ��ȱʡ����ͣ  
%���������IsDraw���Ƿ�ͼ�λ��������̣�IsDraw��0����ͼ�λ��������̣�����ͼ�λ���ʾ��ȱʡ��ͼ�λ���ʾ  
%���������LoopCount�������Ĵ�����ȱʡ����100��  
%���������IsPlot�������Ƿ���������������������ܵ�ͼ�α�ʾ��IsPlot=0,����ʾ��  
%                 IsPlot=1����ʾͼ�ν����ȱʡIsPlot=1  
%  
%����ֵ��BestofStep:ÿ�ε�����ȫ������ֵ.  
% ����ֵ��ResultΪ����������õ������Ž�  
%����ֵ��OnLineΪ�������ܵ�����  
%����ֵ��OffLineΪ�������ܵ�����  
% ����ֵ��MinMaxMeanAdaptΪ�������������õ�����С������ƽ����Ӧ��  
%  
%�÷�[Result,OnLine,OffLine,MinMaxMeanAdapt]=PsoProcess(SwarmSize,ParticleSize,ParticleScope,InitFunc,StepFindFunc,AdaptFunc,IsStep,IsDraw,LoopCount,IsPlot);  
%  
%�쳣�����ȱ�֤���ļ���Matlab������·���У�Ȼ��鿴��ص���ʾ��Ϣ��  
%  
%�����ˣ�XXX  
% ����ʱ�䣺2007.3.26  
%�ο����ף�XXXXX%  
  
%�޸ļ�¼��  
%����MinMaxMeanAdapt���Եõ�������������  
%�޸��ˣ�XXX  
%�޸�ʱ�䣺2007.3.27  
%�ο����ף�XXX.  
  
%�ݴ�����  
if nargin<4  
    error(' ����Ĳ�����������')  
end  
  
[row,colum]=size(ParticleSize);  
if row>1||colum>1  
    error('��������ӵ�ά��������һ��1��1�е����ݡ�');  
end  
[row,colum]=size(ParticleScope);  
if row~=ParticleSize||colum~=2  
    error('��������ӵ�ά����Χ���� ');  
end  
  
%����ȱʡֵ  
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
  
%�����Ƿ���ʾ2ά��������ά����Ѱ�����ŵĹ���  
if IsDraw~=0   
    figure  
    clf  
    DrawObjGraphic(ParticleSize,ParticleScope,AdaptFunc);  
    view(0,90);  
end  
  
%��ʼ����Ⱥ         
[ParSwarm,OptSwarm]=InitFunc(SwarmSize,ParticleSize,ParticleScope,AdaptFunc);  
  
% �ڲ��Ժ���ͼ���ϻ��Ƴ�ʼ��Ⱥ��λ��  
if IsDraw~=0  
    if 1==ParticleSize  
        for ParSwarmRow=1:SwarmSize  
            plot([ParSwarm(ParSwarmRow,1),ParSwarm(ParSwarmRow,1)],[ParSwarm(ParSwarmRow,3),0],'r*-','markersize',8);  
            text(ParSwarm(ParSwarmRow,1),ParSwarm(ParSwarmRow,3),num2str(ParSwarmRow));  
        end  
    end  
  
    if 2==ParticleSize  
        for ParSwarmRow=1:SwarmSize  
            hold on  
            stem3(ParSwarm(ParSwarmRow,1),ParSwarm(ParSwarmRow,2),ParSwarm(ParSwarmRow,5),'white*','markersize',8);  
        end           
    end  
end  
      
%��ͣ��ץͼ  
if IsStep~=0  
    disp(' ��ʼ���������������')  
    pause  
end  
  
%��ʼ�����㷨�ĵ���  
for k=1:LoopCount  
    %��ʾ�����Ĵ�����  
    disp('----------------------------------------------------------')  
    TempStr=sprintf(' �� %g �ε���',k);  
    disp(TempStr);  
    disp('----------------------------------------------------------')  
      
    % ����һ���������㷨  
    [ParSwarm,OptSwarm]=StepFindFunc(ParSwarm,OptSwarm,AdaptFunc,ParticleScope,0.95,0.4,LoopCount,k);  
      
    % ��Ŀ�꺯����ͼ���ϻ���2ά���µ����ӵ���λ��  
    if IsDraw~=0  
        if 1==ParticleSize  
            for ParSwarmRow=1:SwarmSize  
                plot([ParSwarm(ParSwarmRow,1),ParSwarm(ParSwarmRow,1)],[ParSwarm(ParSwarmRow,3),0],'r*-','markersize',8);  
                text(ParSwarm(ParSwarmRow,1),ParSwarm(ParSwarmRow,3),num2str(ParSwarmRow));  
            end  
        end  
  
        if 2==ParticleSize  
            for ParSwarmRow=1:SwarmSize  
                stem3(ParSwarm(ParSwarmRow,1),ParSwarm(ParSwarmRow,2),ParSwarm(ParSwarmRow,5),'white.','markersize',8);  
            end  
        end  
    end  
      
    XResult=OptSwarm(SwarmSize*2+1,1:ParticleSize);  
    YResult=AdaptFunc(XResult);      
    if IsStep~=0  
        XResult=OptSwarm(SwarmSize*2+1,1:ParticleSize);  
        YResult=AdaptFunc(XResult);      
        str=sprintf('%g������������Ŀ�꺯��ֵ%g',k,YResult);  
        disp(str);  
        disp(' �´ε����������������');  
        pause  
    end  
      
    %��¼ÿһ����ƽ����Ӧ��  
    MeanAdapt(1,k)=mean(ParSwarm(:,2*ParticleSize+1));  
    BestofStep(1,k)=YResult;  
end  
%forѭ��������־  
  
%��¼��С������ƽ����Ӧ��  
MinMaxMeanAdapt=[min(MeanAdapt),max(MeanAdapt)];  
% ������������������  
for k=1:LoopCount  
    OnLine(1,k)=sum(MeanAdapt(1,1:k))/k;  
    OffLine(1,k)=max(MeanAdapt(1,1:k));  
end  
  
for k=1:LoopCount  
    OffLine(1,k)=sum(OffLine(1,1:k))/k;  
end  
  
%��������������������������  
if 1==IsPlot  
    figure  
    hold on  
    title('������������ͼ')  
    xlabel(' ��������');  
    ylabel('��������');  
    grid on  
    plot(OffLine);  
  
    figure  
    hold on  
    title(' ������������ͼ')  
    xlabel('��������');  
    ylabel('��������');  
    grid on  
    plot(OnLine);  
end  
  
%��¼���ε����õ������Ž��  
XResult=OptSwarm(SwarmSize*2+1,1:ParticleSize);  
YResult=AdaptFunc(XResult);  
Result=[XResult,YResult]