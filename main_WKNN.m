clc
clear
close all
%% data
load ('fisheriris')
data=meas(1:end,:);
labels=species(1:100:end);
test=meas(2:100,1);
testl=species(2:100);
%% Classification results



label=WKNN(data, labels,test, 2)
%Class=WKNN(data,labels,test,2);
plotconfusion(categorical(Class),categorical(testl))