clc
clear all


tic
%The path needs to be changed if run on different computer
train_one=readall_mat('C:\Users\70483\Desktop\KNN\p_dataset_26\p_dataset_26\Sample1');
TS_one=ones(750,677);
for i=1:750
    TS_one(i,1:end-1)=reshape(imbinarize(train_one{i}),[1,676]);
    TS_one(i,end)=1;
end

train_two=readall_mat('C:\Users\70483\Desktop\KNN\p_dataset_26\p_dataset_26\Sample2');
TS_two=ones(750,677);
for i=1:750
    TS_two(i,1:end-1)=reshape(imbinarize(train_two{i}),[1,676]);
    TS_two(i,end)=2;
end

train_three=readall_mat('C:\Users\70483\Desktop\KNN\p_dataset_26\p_dataset_26\Sample3');
TS_three=ones(750,677);
for i=1:750
    TS_three(i,1:end-1)=reshape(imbinarize(train_three{i}),[1,676]);
    TS_three(i,end)=3;
end

train_A=readall_mat('C:\Users\70483\Desktop\KNN\p_dataset_26\p_dataset_26\SampleA');
TS_A=ones(750,677);
for i=1:750
    TS_A(i,1:end-1)=reshape(imbinarize(train_A{i}),[1,676]);
    %LABEL A AS 4
    TS_A(i,end)=4;
end

train_B=readall_mat('C:\Users\70483\Desktop\KNN\p_dataset_26\p_dataset_26\SampleB');
TS_B=ones(750,677);
for i=1:750
    TS_B(i,1:end-1)=reshape(imbinarize(train_B{i}),[1,676]);
    %LABEL B AS 5
    TS_B(i,end)=5;
end

train_C=readall_mat('C:\Users\70483\Desktop\KNN\p_dataset_26\p_dataset_26\SampleC');
TS_C=ones(750,677);
for i=1:750
    TS_C(i,1:end-1)=reshape(imbinarize(train_C{i}),[1,676]);
    %LABEL C AS 6
    TS_C(i,end)=6;
end

%load testing set
Test_set=readall_mat('C:\Users\70483\Desktop\KNN\p_dataset_26\p_dataset_26\TestingSet');
Test_all=ones(1596,676);
for i=1:1596
    Test_all(i,:)=reshape(imbinarize(Test_set{i}),[1,676]);
    %Label all testing .mat file as 0
    %Test_all(i,end)=0;
end


train_sample=[TS_one;TS_two;TS_three;TS_A;TS_B;TS_C];
class=fitcknn(train_sample(:,1:end-1),train_sample(:,end));
%Change k to 17
class.NumNeighbors = 7;
resubloss=resubLoss(class)


label=predict(class,Test_all);


label1=ones(266,1);
label2=2*ones(266,1);
label3=3*ones(266,1);
labelA=4*ones(266,1);
labelB=5*ones(266,1);
labelC=6*ones(266,1);
correct_label=[label1;label2;label3;labelA;labelB;labelC];

count=0;

for i=1:1596
    if correct_label(i) ~= label(i)
        count = count + 1;
        end
    end

CorrectRatio_of_test_file=1-count/1596

M=load('rearranged.mat');
M=M.new_arrange_image;
MAT1=M(1:26,1:26);
MAT2=M(1:26,27:52);
MAT3=M(1:26,53:78);
MATA=M(1:26,79:104);
MATB=M(1:26,105:130);
MATC=M(1:26,131:156);
MAT1=reshape(MAT1,[1,676]);
MAT2=reshape(MAT2,[1,676]);
MAT3=reshape(MAT3,[1,676]);
MATA=reshape(MATA,[1,676]);
MATB=reshape(MATB,[1,676]);
MATC=reshape(MATC,[1,676]);
MAT1=~MAT1;
MAT2=~MAT2;
MAT3=~MAT3;
MATA=~MATA;
MATB=~MATB;
MATC=~MATC;
MAT1=double(MAT1);
MAT2=double(MAT2);
MAT3=double(MAT3);
MATA=double(MATA);
MATB=double(MATB);
MATC=double(MATC);
%The classificated lable of ABC123 in the previous task 
label_test1=predict(class,MAT1);
label_test2=predict(class,MAT2);
label_test3=predict(class,MAT3);
label_testA=predict(class,MATA);
label_testB=predict(class,MATB);
label_testC=predict(class,MATC);
 
toc

