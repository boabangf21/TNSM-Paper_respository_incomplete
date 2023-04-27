% demo_gpr

for iRealize=60:10:70
for idxd=1:10
X=load('.\Knot_Tying\kinematics\AllGestures\Knot_Tying_E001.txt');
[percent_packet, r]=gen_pack_loss_seq(iRealize, 3, 0.4);
X_1=X(1:iRealize,:);
X=full(X(1:iRealize,:));
%y=full(y(1:200,1));
n = size(X, 1);
n_1=size(X_1, 1);
%y=ones(1,n)';
y_1=ones(1,n_1)';
% --------------------- parameters --------------------- %
sigma = 1.0; % scaling parameter of the RBF kernel
alpha = 1.0; % indicating the noise in the observation

% ------- randomly partition training-test data ------- %
ntrain = ceil(n * 0.8); % number of training data;
idx = randperm(n);
X = X(idx, :);
y = y(idx, :);
Xtrain = X(1: ntrain, :);
ytrain = y(1: ntrain);
Xtest = X(ntrain + 1:end, :);
ytest = y(ntrain + 1:end);


ntrain_1 = ceil(n_1 * 0.8); % number of training data;
idx = randperm(n_1);
X_1 = X_1(idx, :);
y_1 = y_1(idx, :);
Xtrain_1 = X_1(1: ntrain_1, :);
ytrain_1 = y_1(1: ntrain_1);
Xtest_1 = X_1(ntrain_1 + 1:end, :);
ytest_1 = y_1(ntrain_1 + 1:end);




% ----------------- GPR predictive mean ----------------- %
Z_1=zeros(1,10);
for z_1tic=1:10
    tic
w = gprTrain(Xtrain, ytrain, sigma, alpha);
Z_1(z_1tic)=toc;
end


Z_2=zeros(1,10);
for z_2tic=1:10
    tic
   w_random = gprTrain_random(Xtrain_1, ytrain_1, sigma, alpha);
%w_random = gprTrain_random(Xtrain, ytrain, sigma, alpha);
Z_2(z_2tic)=toc;
end
%TMul_random_train_novice_knot_Tying=mean(Z_2);



%w_random = gprTrain_random(Xtrain, ytrain, sigma, alpha);
Z_3=zeros(1,10);
for itic=1:10
tic
w_rpca = gprTrain_RPCA(Xtrain, ytrain, sigma, alpha);
Z_3(itic)=toc;
end
%labels_proper=gprTest(Xtrain, Xtest, sigma, w_proper);
w_proper=gprTrain_proper(Xtrain, ytrain, sigma, alpha);
Z_4=zeros(1,10);
for i_4tic=1:10
tic
%w_rpca = gprTrain_RPCA(Xtrain, ytrain, sigma, alpha);
labels = gprTest(Xtrain, Xtest, sigma, w);
Z_4(i_4tic)=toc;
end

labels_proper=gprTest(Xtrain, Xtest, sigma, w_proper);

Z_5=zeros(1,10);
for i_5tic=1:10
tic
%w_rpca = gprTrain_RPCA(Xtrain, ytrain, sigma, alpha);
labels_random=gprTest_random(Xtrain, Xtest, sigma, w_random);
Z_5(i_5tic)=toc;
end

%labels = gprTest(Xtrain, Xtest, sigma, w);

Z_6=zeros(1,10);
for i_6tic=1:10
tic
%w_rpca = gprTrain_RPCA(Xtrain, ytrain, sigma, alpha);
labels_rpca=gprTest_rpca(Xtrain, Xtest, sigma, w_rpca);
Z_6(i_6tic)=toc;
end
Z_1_mean(:,idxd)=mean(Z_1);
Z_2_mean(:,idxd)=mean(Z_2);
Z_3_mean(:,idxd)=mean(Z_3);
Z_4_mean(:,idxd)=mean(Z_4);
Z_5_mean(:,idxd)=mean(Z_5);
Z_6_mean(:,idxd)=mean(Z_6);



%error_rpca=gprTest(Xtrain, Xtest, sigma, w);
%labels = gprTestCUR(Xtrain, Xtest, sigma, w); % use CUR to speedup
error_Godec(:, idxd) = (norm(labels - ytest))/ norm(ytest);
%error_Godec(:, idxd)=sqrt(mean(abs(labels-ytest).^2));
error_rpca(:, idxd)=(norm(labels_rpca-ytest))/norm(ytest);
%error_rpca(:, idxd)=sqrt(mean(abs(labels_rpca-ytest).^2));
error_proper(:, idxd)=(norm(labels_proper-ytest))/norm(ytest);
error_random(:, idxd)=(norm(labels_random-ytest_1))/norm(ytest_1);
%error_random(:, idxd)=sqrt(mean(abs(labels_random-ytest_1).^2));
end
TMul_direct_train_novice_knot_Tying(:, iRealize)=mean(Z_1_mean);
TMul_random_train_novice_knot_Tying(:, iRealize)=mean(Z_2_mean);
TMul_rpca_train_novice_knot_Tying(:, iRealize)=mean(Z_3_mean);
TMul_test_direct_novice_knot_Tying(:, iRealize)=mean(Z_4_mean);
TMul_test_random_novice_knot_Tying(:, iRealize)=mean(Z_5_mean);
TMul_test_rpca_novice_knot_Tying(:, iRealize)=mean(Z_6_mean);
%(:, iRealize)
error_rpca_realize__novice_knot_Tying_relative_error(:, iRealize)=mean(abs(error_rpca));
error_Godec_realize_novice_knot_Tying_relative_error(:, iRealize)=(mean(abs(error_Godec)));
error_random_realize_novice_knot_Tying_relative_error(:, iRealize)=(mean(abs(error_random)));
error_proper_realize_novice_knot_Tying_relative_error(:, iRealize)=(mean(abs(error_proper)));
%error_rpca_realize__novice_knot_Tying_mean_error(:, iRealize)=(mean(abs(error_rpca_mean)));
%error_Godec_realize_novice_knot_Tying_mean_error(:, iRealize)=(mean(abs(error_Godec_mean)));
%error_random_realize_novice_knot_Tying_mean_error(:, iRealize)=(mean(abs(error_random_mean)));
end

%error_Godec=(mean(abs(labels-ytest)));
%display(['error ratio: ', num2str(error)]);

%end
%Godec=mean(error_rpca_realize);
%RPCA=mean(error_Godec_realize);
