% We are assuming one channel 
clc
clear all

M = 16;                     % Size of signal constellation
k = log2(M);                % Number of bits per symbol
n = 40E3;                   % Number of bits to process  
numSamplesPerSymbol = 2;    % Oversampling factor

% ADD BIT RATE 

rng default                 % Use default random number generator
dataIn = randi([0 1],n,1);  % Generate vector of binary data

dataInMatrix = reshape(dataIn,length(dataIn)/k,k);   % Reshape data into binary k-tuples, k = log2(M)
dataSymbolsIn = bi2de(dataInMatrix);                 % Convert to integers

dataMod = qammod(dataSymbolsIn,M,'bin'); % Binary coding, phase offset = 0

EbNo = 16;
snr = EbNo + 10*log10(k) - 10*log10(numSamplesPerSymbol);

saleh = comm.MemorylessNonlinearity('Method','Saleh model'); % adding nonilnearity to model 

receivedSignal0 = awgn(dataMod,snr,'measured'); % transimitter noise

receivedSignal1 = saleh(receivedSignal0); % nonlinearlity channel noise 

receivedSignal2 = awgn(receivedSignal1,snr,'measured'); %reciever noise

for i = 1:length(receivedSignal2)
    x(i) = real(receivedSignal2(i));
    y(i) = imag(receivedSignal2(i)); 
end

sPlotFigReg = scatterplot(receivedSignal0,1,0,'b.');
sPlotFigNon = scatterplot(receivedSignal2,1,0,'b.');

filename = 'test.xlsx';
xlswrite(filename,[x',y']);