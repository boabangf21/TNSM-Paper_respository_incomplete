function [avTotalTime, avTransmit, avPktDropCnt] = throughputSimulation_WIFI(PER, PSDULength, alpha,w)

% 802.11n MAC parameters. Do not modify
%DIFS = 34e-6;       % DIFS time
%SIFS = 16e-6;       % SIFS time
slotTime = 9e-6;    % slot time
maxReTx = 7;        % Maximum retransmissions before dropping a Pkt

C = 1.0e6; % Channel bit rate 1Mbit/s 
C_pon=130.0e6; % fiber
CW_min = 32;
CW_max = 1024;
PHY_header = 20e-6;  %192bits
MAC_header = 36e-6; %224 bits
T_delta = 1.0e-6; % 20micros = delta = e^-6; % the propagation delay
delta = T_delta;
SIFS = 16e-6; %16 mircos
DIFS = 36e-6; %50micros
RTS = 160 + PHY_header;
CTS = 112 + PHY_header;
ACK = 112 + PHY_header;
w=1;
%calculate stationary probability uptau - x2 (the station traansmit a
%packet in a generic slot time), p(x1)
%is the conditional collision probability
BackOff_W = CW_min;
m = log2(CW_max/BackOff_W);

fun = @(x)Wuptau(x,BackOff_W,m,w);
x0 = [0,0];
x = fsolve(fun,x0);
uptau = x(2);
E_P = 8224; %bits

T_e = 50.0e-6; %slot time
T_s = RTS/C + SIFS + delta + CTS/C + SIFS + delta + (PHY_header + MAC_header + E_P)/C + SIFS + delta + ACK/C + DIFS + delta;
T_s_pon  = RTS/C_pon + SIFS + delta + CTS/C_pon + SIFS + delta + (PHY_header + MAC_header + E_P)/C_pon + SIFS + delta + ACK/C_pon + DIFS + delta;
T_c_pon = RTS/C_pon + DIFS + delta;
T_c = RTS/C + DIFS + delta;

% T_s = RTS + SIFS + delta + CTS + SIFS + delta + (PHY_header + MAC_header + E_P) + SIFS + delta + ACK + DIFS + delta;
%T_c = RTS + DIFS + delta;


%T_sc=T_s-T_c;
%uptau = 2/(CW_min + 1); %transmission probability
P_tr = 1 - (1-uptau)^w;
P_s = w*uptau*(1-uptau)^(w-1)/P_tr;
total_time_1=((1-P_tr)*T_e + P_tr*P_s*T_s + P_tr*(1-P_s)*T_c);
total_time_2=((1-P_tr)*T_e + P_tr*P_s*T_s_pon + P_tr*(1-P_s)*T_c_pon);


%switch PSDULength
 %   case 100
   %     packetTime = 270e-6;
   % case 200
   %     packetTime = 394e-6;
    %case 300
    %    packetTime = 518e-6;
    %case 400
    %    packetTime = 638e-6;
    %case 500
    %    packetTime = 762e-6;
    %case 600
    %    packetTime = 886e-6;
%end

Niter = 100000;

rTransmit = zeros(Niter,1);
rPktDropCnt = zeros(Niter,1);
rTotalTime = zeros(Niter,1);

for iter = 1 : Niter
    transmitSuccess = false;
    contentionWindow = 15 * slotTime;
    packetDropCounter = 0;
    transmitCounter = 0;
    totalTime = 0;

    while ( ~transmitSuccess && transmitCounter <= maxReTx )
        backoffTime = alpha*(rand(1, 1) * contentionWindow);
        totalTime = totalTime + packetTime + total_time_1 + total_time_2 + backoffTime;
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

%rTotalTime1 = rTotalTime(~isnan(rTotalTime));    % Get ride of NaN
%rTransmit1  = rTransmit(~isnan(rTransmit));      % Get ride of NaN

%avTotalTime = mean(rTotalTime1)*1e3;             % In ms
%avTransmit = mean(rTransmit1);                   % In Pkt
%avPktDropCnt = 100*sum(rPktDropCnt)/Niter;       % In %