

function [Delay_status_for_all_features, Delay_status_per_feature]=gen_pack_delay_seq_synthetic_dataset.......
(len, features, delay_threshold)

for z=1:features
%v=load('ENDTOEND2.txt');
%^d=v';
% Delay_status_per_feature=rand(1, 1:len);

 Delay_status_per_feature=rand(1, 1000);
% Delay_data=Delay_dataset'
 
 
 for i=1:len


   if Delay_status_per_feature(i)>=delay_threshold
       
       Delay_status_per_feature(i)=0;
   else
  Delay_status_per_feature(i)=1; 
   end
end
Delay_status_for_all_features(:,z)=Delay_status_per_feature;
%end

end


 
 
 


 
 
 
 
