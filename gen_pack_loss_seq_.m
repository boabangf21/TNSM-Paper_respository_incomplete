function [percent_packet, r]=gen_pack_loss_seq(len, features, pl)

for z=1:features
v=load('ENDTOEND.txt');
data=v';
r=data(1, len);
   
for i=1:len


   if r(i)>=pl
       
       r(i)=1;
   else
   r(i)=0; 
   end
end
percent_packet(:,z)=r;
end

end
