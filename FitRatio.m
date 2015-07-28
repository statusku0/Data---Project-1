%% preparation
clear all;
close all;
path(pathdef);
addpath(path,genpath([pwd '/utils/']));

%% load files (adjust third file name accordingly)
load('C:/Users/Kevin/Documents/MATLAB/cPdist-master/DistRslts0Sample/cPDistMatrix.mat')
load('C:/Users/Kevin/Documents/MATLAB/cPdist-master/ratioRank.mat')
load('C:/Users/Kevin/Documents/MATLAB/cPdist-master/TopcoefRank.mat')
load('C:/Users/Kevin/Documents/MATLAB/cPdist-master/TopinterceptRank.mat')
load('C:/Users/Kevin/Documents/MATLAB/cPdist-master/TopDencoefRank.mat')
load('C:/Users/Kevin/Documents/MATLAB/cPdist-master/Mostnegcoef.mat')
load('C:/Users/Kevin/Documents/MATLAB/cPdist-master/Topr2Rank.mat')

%% create Dist matrix
Dist = zeros(116,116);
for k1 = 1:116
    for k2 = 1:116
        if ratioRank(k1,k2) ~= 0
            Dist(k1,k2) = cPDistMatrix(k1,k2);
        end
    end
end

%% set variables/get rid of outliers
oldx = Dist(find(Dist(:)));
oldy = TopcoefRank(find(ratioRank(:)));
topr2 = Topr2Rank(find(Topr2Rank(:)));
outlist = [];
for k1 = 1:length(oldy)
    if abs(oldy(k1)-median(oldy)) > 1.5*iqr(oldy) | topr2(k1) < 0.7 %% eliminates outliers and r2 values less than 0.7
        outlist = [outlist k1];
    end
end
x = [];
y = [];
for k1 = 1:length(oldx)
    if isempty(find(outlist == k1)) == 1
        x = [x,oldx(k1)];
        y = [y,oldy(k1)];
    end
end

%% fit
xmodel = linspace(0.015,0.06,1000);
yeqn = @(coefs,x) -(coefs(1)./(coefs(2).*((x).^(coefs(4)))))+coefs(3);
InitialGuess = [1,100,-0.01,0.1];

fSSR = @(coefs,x,y) sum((y-yeqn(coefs,x)).^2);
[MyCoefs,Sr] = fminsearch(@(MyCoefsDummy) fSSR(MyCoefsDummy,x,y), InitialGuess);

yhat = yeqn(MyCoefs,x);
ymodel = yeqn(MyCoefs,xmodel);

St = sum((y-mean(y)).^2);
r2 = (St-Sr)./St;

figure;plot(x,y,'bo',xmodel,ymodel,'k-')
title('cP Distance vs. Rate of LMSE Ratio Decline (using NumDensity with largest r^2)')
xlabel('cP Distance')
ylabel('Rate of Ratio Decline (Ratio Units per Intermediate Tooth)')