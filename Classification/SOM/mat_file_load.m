clear all;
close all;

%% READ then transpose
Train_label = zeros(1, 750 * 6);

%% read 1
train_one=readall_mat('D:\NUS\MSC\ME5405\Project\Classification\SOM\Sample1');
TS_one=ones(750,676);

for i=1:750
    TS_one(i,1:end)=reshape(train_one{i},[1,676]);
    Train_label(1, i) = 1;
end

%% read 2
train_two=readall_mat('D:\NUS\MSC\ME5405\Project\Classification\SOM\Sample2');
TS_two=ones(750,676);
for i=1:750
    TS_two(i,1:end)=reshape(train_two{i},[1,676]);
    Train_label(1, i + 750) = 2;
end

%% read 3
train_three=readall_mat('D:\NUS\MSC\ME5405\Project\Classification\SOM\Sample3');
TS_three=ones(750,676);
for i=1:750
    TS_three(i,1:end)=reshape(train_three{i},[1,676]);
    Train_label(1, i + 750*2) = 3;
end

%% read 4
train_A=readall_mat('D:\NUS\MSC\ME5405\Project\Classification\SOM\SampleA');
TS_A=ones(750,676);
for i=1:750
    TS_A(i,1:end)=reshape(train_A{i},[1,676]);
    Train_label(1, i + 750*3) = 4;
end

%% read 5
train_B=readall_mat('D:\NUS\MSC\ME5405\Project\Classification\SOM\SampleB');
TS_B=ones(750,676);
for i=1:750
    TS_B(i,1:end)=reshape(train_B{i},[1,676]);
    Train_label(1, i + 750*4) = 5;
end

%% read 6
train_C=readall_mat('D:\NUS\MSC\ME5405\Project\Classification\SOM\SampleC');
TS_C=ones(750,676);
for i=1:750
    TS_C(i,1:end)=reshape(train_C{i},[1,676]);
    Train_label(1, i + 750*5) = 6;
end

%% combine 6 train_dataset
Train_data = [TS_one.',TS_two.',TS_three.',TS_A.',TS_B.',TS_C.'];

%% testing set
label1 = ones(1,266);
label2 = 2*ones(1,266);
label3 = 3*ones(1,266);
label4 = 4*ones(1,266);
label5 = 5*ones(1,266);
label6 = 6*ones(1,266);
Test_label = [label1,label2,label3,label4,label5,label6];

Test_set=readall_mat('D:\NUS\MSC\ME5405\Project\Classification\SOM\TestingSet');
Test_all=ones(1596,676);
for i=1:1596
    Test_all(i,:)=reshape(Test_set{i},[1,676]);
end
Test_data = Test_all.';

