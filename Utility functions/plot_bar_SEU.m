function [output_OLcontrol,output_OLexp,output_Unpaired,aver] = plot_bar_SEU(a)

  output = struct('ID',[],'Age',[],'Task',[],'DataQuality',[],...
  'PITime_Baseline',[],'PITime_Training',[],'PITime_Test',[],...
  'PITurn_Baseline',[],'PITurn_Training',[],'PITurn_Test',[],...
  'NumShock',[],'PIShock',[]);

   begin_idx = 1;
   end_idx = 0;
   num = length(a);

  for j = 1:num

  t = 0;
  begin_idx = end_idx+1;
  end_idx = end_idx + length(a(j).FishStack);
  for i = begin_idx:end_idx% number of fish in the fishStack
       t = t+1;
        a(j).FishStack(t).ratePerformance();
      % Assign values to output
      output(i).ID = a(j).FishStack(t).ID;
      output(i).Age = a(j).FishStack(t).Age;
      output(i).Task = a(j).FishStack(t).ExpTask;

      output(i).DataQuality = a(j).FishStack(t).Res.DataQuality;
      % PItime
      output(i).PITime_Baseline = a(j).FishStack(t).Res.PItime(1).PIfish;
      output(i).PITime_Training = a(j).FishStack(t).Res.PItime(2).PIfish;
      output(i).PITime_Test = a(j).FishStack(t).Res.PItime(4).PIfish;

      % PIturn
      output(i).PITurn_Baseline = a(j).FishStack(t).Res.PIturn(1).PIfish;
      output(i).PITurn_Training = a(j).FishStack(t).Res.PIturn(2).PIfish;
      output(i).PITurn_Test = a(j).FishStack(t).Res.PIturn(4).PIfish;

      % PIshock
      output(i).NumShock = a(j).FishStack(t).Res.PIshock.NumShocks;
      output(i).PIshock = a(j).FishStack(t).Res.PIshock.PIfish;
      disp(i);

  end
  end

 C=zeros();
  a=1;
  for i=1:length(output)
    if (output(i).Task=="OLexp")||(output(i).Task=="UPexp")||(output(i).Task=="UPcontrol")
      C(a)=i;
      a=a+1;
     end
 end
  E=zeros();
 a=1;
 for i=1:length(output)
   if (output(i).Task=="OLcontrol")||(output(i).Task=="UPexp")||(output(i).Task=="UPcontrol")
     E(a)=i;
     a=a+1;
    end
end
a=1;
for i=1:length(output)
  if (output(i).Task=="OLexp")||(output(i).Task=="OLcontrol")||(output(i).Task=="UPcontrol")
    U(a)=i;
    a=a+1;
   end
end
  output_OLcontrol=output;
  output_OLexp=output;
  output_Unpaired=output;
  t=0;
  for i=1:length(C)
   q=C(i)-t;
   t=t+1;
   output_OLcontrol(q)=[];
  end
  t=0;
  for i=1:length(E)
   q=E(i)-t;
   t=t+1;
   output_OLexp(q)=[];
  end
  t=0;
  for i=1:length(U)
   q=U(i)-t;
   t=t+1;
   output_Unpaired(q)=[];
  end

  Bad=zeros();
  a=1;

 numPairs=length(output_OLexp);
  for i=1:numPairs

       if (output_OLexp(i).DataQuality < 0.95) || (output_OLcontrol(i).DataQuality < 0.95)
           Bad_P(a)=i;
           a=a+1;
       end
  end

   a=1;
   for i=1:length(output_Unpaired)

        if output_Unpaired(i).DataQuality < 0.95
            Bad_U(a)=i;
            a=a+1;
        end
   end

  t=0;
  for i=1:length(Bad_P)
   q=Bad_P(i)-t;
   t=t+1;
   output_OLcontrol(q)=[];
   output_OLexp(q)=[];
  end

  t=0;
  for i=1:length(Bad_U)
   q=Bad_U(i)-t;
   t=t+1;
   output_Unpaired(q)=[];

  end

  aver = struct('Task',[],'PITime_Baseline',[],'PITime_Test',[],'PITurn_Baseline',[],'PITurn_Test',[]);
  aver(1).Task="OLcontrol";
  aver(2).Task="OLexp";
  aver(3).Task="Unpaired";

  num = length(output_OLcontrol);
  sum = 0;
  for i = 1:num
    sum = sum + output_OLcontrol(i).PITime_Baseline;
  end
  aver(1).PITime_Baseline = sum / num;

  sum = 0;
  for  i = 1:num
    sum = sum + output_OLcontrol(i).PITime_Test;
  end
  aver(1).PITime_Test = sum / num;

  sum = 0;
  for  i = 1:num
    sum = sum + output_OLcontrol(i).PITurn_Baseline;
  end
  aver(1).PITurn_Baseline = sum / num;

  sum = 0;
  for  i = 1:num
    sum = sum + output_OLcontrol(i).PITurn_Test;
  end
  aver(1).PITurn_Test = sum / num;


  sum = 0;
  for  i = 1:num
    sum = sum + output_OLexp(i).PITime_Baseline;
  end
  aver(2).PITime_Baseline = sum / num;

  sum = 0;
  for  i = 1:num
    sum = sum + output_OLexp(i).PITime_Test;
  end
  aver(2).PITime_Test = sum / num;

  sum = 0;
  for i = 1:num
    sum = sum + output_OLexp(i).PITurn_Baseline;
  end
  aver(2).PITurn_Baseline = sum / num;

  sum = 0;
  for  i = 1:num
    sum = sum + output_OLexp(i).PITurn_Test;
  end
  aver(2).PITurn_Test = sum / num;

  num = length(output_Unpaired);
  sum = 0;
  for i = 1:num
    sum = sum + output_Unpaired(i).PITime_Baseline;
  end
  aver(3).PITime_Baseline = sum / num;

  sum = 0;
  for  i = 1:num
    sum = sum + output_Unpaired(i).PITime_Test;
  end
  aver(3).PITime_Test = sum / num;

  sum = 0;
  for  i = 1:num
    sum = sum + output_Unpaired(i).PITurn_Baseline;
  end
  aver(3).PITurn_Baseline = sum / num;

  sum = 0;
  for  i = 1:num
    sum = sum + output_Unpaired(i).PITurn_Test;
  end
  aver(3).PITurn_Test = sum / num;

x=[1,2,3,4,5,6,7,8];
sigSyms = ["n.s.",... % P > 0.05
            "*",...   % P < 0.05
            "**",...  % P < 0.01
            "***",... % P < 0.001
            "****"];  % P < 0.0001 % occassionally use
A=[cat(1,output_OLcontrol.PITime_Baseline),cat(1,output_OLcontrol.PITime_Test)];
B=[cat(1,output_OLexp.PITime_Baseline),cat(1,output_OLexp.PITime_Test)];
C=[cat(1,output_OLcontrol.PITurn_Baseline),cat(1,output_OLcontrol.PITurn_Test)];
D=[cat(1,output_OLexp.PITurn_Baseline),cat(1,output_OLexp.PITurn_Test)];
E=[cat(1,output_Unpaired.PITime_Baseline),cat(1,output_Unpaired.PITime_Test)];
F=[cat(1,output_Unpaired.PITurn_Baseline),cat(1,output_Unpaired.PITurn_Test)];
std_A=[std(A),0,std(B),0,std(E)];
std_C=[std(C),0,std(D),0,std(F)];

y1=[aver(1).PITime_Baseline,aver(1).PITime_Test,0,aver(2).PITime_Baseline,aver(2).PITime_Test,0,aver(3).PITime_Baseline,aver(3).PITime_Test];
y11=diag(y1);
y2=[aver(1).PITurn_Baseline,aver(1).PITurn_Test,0,aver(2).PITurn_Baseline,aver(2).PITurn_Test,0,aver(3).PITurn_Baseline,aver(3).PITurn_Test];
y22=diag(y2);
figure;
b=bar(y11,'stack');
hold on;
e=errorbar(x,y1,std_A,'.');
e.Color=[0.5 0.5 0.5];

b(1).FaceColor = [0.9,0.9,0.9];
b(2).FaceColor = [0,0,0];
b(4).FaceColor = [0.9,0.9,0.9];
b(5).FaceColor = [0,0,0];
b(7).FaceColor = [0.9,0.9,0.9];
b(8).FaceColor = [0,0,0];

ylim([0,1]);
set(gca,'xtick',-inf:inf:inf);
ylabel('Poisitional Index');
xlabel('    Self-Control                 Experiment             Unpaired Control');
for i=1:length(output_OLcontrol)
    P(i)=output_OLcontrol(i).PITime_Baseline;
    Q(i)=output_OLcontrol(i).PITime_Test;
end
[~,p] = ttest(P,Q);
line([1,2],[0.8,0.8],'Color',[0,0,0]);
if p > 0.05 % n.s.
   text(1.3,0.83,'n.s.','FontSize',14);
elseif p < 0.05 % "*"
   text(1.4,0.81,'*','FontSize',20);
elseif p < 0.01 % "**"
   text(1.3,0.81,'**','FontSize',20);
elseif p < 0.001 % "***"
   text(1.2,0.81,'***','FontSize',20);
elseif p < 0.0001 % "****"
   text(1.1,0.81,'****','FontSize',20);
end


% experiment group: compare mean of PIs between Baseline and Test
for i=1:length(output_OLexp)
    P(i)=output_OLexp(i).PITime_Baseline;
    Q(i)=output_OLexp(i).PITime_Test;
end
[~,p] = ttest(P,Q);
line([4,5],[0.8,0.8],'Color',[0,0,0]);
if p > 0.05 % n.s.
   text(4.3,0.83,'n.s.','FontSize',14);
elseif p < 0.05 % "*"
   text(4.4,0.81,'*','FontSize',20);
elseif p < 0.01 % "**"
   text(4.3,0.81,'**','FontSize',20);
elseif p < 0.001 % "***"
   text(4.2,0.81,'***','FontSize',20);
elseif p < 0.0001 % "****"
   text(4.1,0.81,'****','FontSize',20);
end

for i=1:length(output_Unpaired)
    P(i)=output_Unpaired(i).PITime_Baseline;
    Q(i)=output_Unpaired(i).PITime_Test;
end
[~,p] = ttest(P,Q);
line([7,8],[0.8,0.8],'Color',[0,0,0]);
if p > 0.05 % n.s.
   text(7.3,0.83,'n.s.','FontSize',14);
elseif p < 0.05 % "*"
   text(7.4,0.81,'*','FontSize',20);
elseif p < 0.01 % "**"
   text(7.3,0.81,'**','FontSize',20);
elseif p < 0.001 % "***"
   text(7.2,0.81,'***','FontSize',20);
elseif p < 0.0001 % "****"
   text(7.1,0.81,'****','FontSize',20);
end

legend([b(1) b(2)],'Before training','After training');


figure;
b=bar(y22,'stack');
hold on;
e=errorbar(x,y2,std_C,'.');
e.Color=[0.5 0.5 0.5];

b(1).FaceColor = [0.9,0.9,0.9];
b(2).FaceColor = [0,0,0];
b(4).FaceColor = [0.9,0.9,0.9];
b(5).FaceColor = [0,0,0];
b(7).FaceColor = [0.9,0.9,0.9];
b(8).FaceColor = [0,0,0];
ylim([0,1]);
set(gca,'xtick',-inf:inf:inf);
ylabel('Turning Index');
xlabel('    Self-Control                 Experiment             Unpaired Control');
for i=1:length(output_OLcontrol)
    P(i)=output_OLcontrol(i).PITurn_Baseline;
    Q(i)=output_OLcontrol(i).PITurn_Test;
end
[~,p] = ttest(P,Q);
line([1,2],[0.8,0.8],'Color',[0,0,0]);
if p > 0.05 % n.s.
    text(1.3,0.83,'n.s.','FontSize',14);
elseif p < 0.05 % "*"
   text(1.4,0.81,'*','FontSize',20);
elseif p < 0.01 % "**"
   text(1.3,0.81,'**','FontSize',20);
elseif p < 0.001 % "***"
   text(1.2,0.81,'***','FontSize',20);
elseif p < 0.0001 % "****"
   text(1.1,0.81,'****','FontSize',20);
end

% experiment group: compare mean of PIs between Baseline and Test
for i=1:length(output_OLexp)
    P(i)=output_OLexp(i).PITurn_Baseline;
    Q(i)=output_OLexp(i).PITurn_Test;
end
[~,p] = ttest(P,Q);
line([4,5],[0.8,0.8],'Color',[0,0,0]);
if p > 0.05 % n.s.
    text(4.2,0.83,'n.s.','FontSize',14);
elseif p < 0.05 % "*"
   text(4.4,0.81,'*','FontSize',20);
elseif p < 0.01 % "**"
   text(4.3,0.81,'**','FontSize',20);
elseif p < 0.001 % "***"
   text(4.2,0.81,'***','FontSize',20);
elseif p < 0.0001 % "****"
   text(4.1,0.81,'****','FontSize',20);
end

for i=1:length(output_Unpaired)
    P(i)=output_Unpaired(i).PITurn_Baseline;
    Q(i)=output_Unpaired(i).PITurn_Test;
end
[~,p] = ttest(P,Q);
line([7,8],[0.8,0.8],'Color',[0,0,0]);
if p > 0.05 % n.s.
   text(7.3,0.83,'n.s.','FontSize',14);
elseif p < 0.05 % "*"
   text(7.4,0.81,'*','FontSize',20);
elseif p < 0.01 % "**"
   text(7.3,0.81,'**','FontSize',20);
elseif p < 0.001 % "***"
   text(7.2,0.81,'***','FontSize',20);
elseif p < 0.0001 % "****"
   text(7.1,0.81,'****','FontSize',20);
end


legend([b(1) b(2)],'Before training','After training');




% control group: compare mean of PIs between Baseline(C) and Test(C)



end
