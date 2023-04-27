 %C=100e6;
 function [ totalTime] = EPON_WIFI(C)

[Rw, T_s_wifi,   T_c_wifi,T_s_fiber,T_c_fiber, T_e] = wifi(1, 56e5 )
packetTime1=1*(T_s_wifi + T_c_wifi + T_e) + (T_s_fiber + T_c_fiber + T_e );
SIFS = 28e-6; %16 mircos
DIFS = 128e-6; %50micros
PSDULength=100;
slotTime = T_e;    % slot time
maxReTx = 10;   
alpha=1;
Niter = 1000000;
PER=0.1;
rTransmit = zeros(Niter,1);
rPktDropCnt = zeros(Niter,1);
rTotalTime = zeros(Niter,1);

switch PSDULength
    case 100
        packetTime = 500e-6;
    case 200
        packetTime = 1500e-6;
    case 300
        packetTime = 2000e-6;
    case 400
        packetTime = 2500e-6;
    case 500
        packetTime = 3000e-6;
    case 600
        packetTime = 4000e-6;
end




for iter = 1 : Niter
    transmitSuccess = false;
    contentionWindow = 15 * slotTime;
    %contentionWindow= 15* packetTime;
    packetDropCounter = 0;
    transmitCounter = 0;
    totalTime = 0;

    while ( ~transmitSuccess && transmitCounter <= maxReTx )
        backoffTime = alpha*(rand(1, 1) * contentionWindow);
        totalTime = totalTime + packetTime + packetTime1 +  alpha*DIFS + SIFS + backoffTime;
        randNumber = rand(1,1);
        if(randNumber >= PER)
            transmitSuccess = true;
        end
        contentionWindow = contentionWindow * 2;
        transmitCounter = transmitCounter + 1;
    end

    if(transmitCounter > maxReTx)
       % The packet is dropped. It doesn't have an effect on the time
        packetDropCounter = packetDropCounter + 1;
        rTotalTime(iter) = NaN;
        rTransmit(iter) = NaN;
    else
        rTotalTime(iter) = totalTime;
        rTransmit(iter) = transmitCounter;
    end
	rPktDropCnt(iter) = packetDropCounter;
end
end