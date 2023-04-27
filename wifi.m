% Calculate the throughput of WIFI mode
% ALl paratmere base on Rethinking Mobile Data Offloading for LTE in Unlicensed Spectrum paper. More detail you can refer to paper 23 or 25 in this paper
% Input: w - the number of competing station
% Ouput: Rw () - the per-user saturation throughput

%WIFI throughput mode
function [ Rw] = wifi(w)
%function [total_time] = wifi(w)

C = 130.0e1; % Channel bit rate 1Mbit/s
%C = 1.0e1; % Channel bit rate 1Mbit/s
CW_min = 32;
CW_max = 1024;
PHY_header = 128;  %192bits
MAC_header = 272; %224 bits
T_delta = 1.0e-6; % 20micros = delta = e^-6; % the propagation delay
delta = T_delta;
SIFS = 28e-6; %16 mircos
DIFS = 128e-6; %50micros
RTS = 160 + PHY_header;
CTS = 112 + PHY_header;
ACK = 112 + PHY_header;

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
T_c = RTS/C + DIFS + delta;

%total_time = (T_e + T_s + T_c);

% T_s = RTS + SIFS + delta + CTS + SIFS + delta + (PHY_header + MAC_header + E_P) + SIFS + delta + ACK + DIFS + delta;
% T_c = RTS + DIFS + delta;

%uptau = 2/(CW_min + 1); %transmission probability
P_tr = 1 - (1-uptau)^w;
P_s = w*uptau*(1-uptau)^(w-1)/P_tr;

Rw = P_tr*P_s*E_P / ((1-P_tr)*T_e + P_tr*P_s*T_s + P_tr*(1-P_s)*T_c);
% a = E_P / (T_s-T_c + ((T_e.*(1-P_tr))/P_tr + T_c)/P_s)
end

%function between stationary probability x2 and conditional collision
%probability x1 (7), (9) , m is the maximum the backoff stage , n is the competing user
function F = Wuptau(x,BackOff_W,m,n)
F(1) = 2.*(1-2.*x(1))/((BackOff_W + 1).*(1-2.*x(1)) + x(1).*BackOff_W.*(1-(2.*x(1))^m)) - x(2);
F(2) = 1-(1-x(2))^(n-1) - x(1);
end

