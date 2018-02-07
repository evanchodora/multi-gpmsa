% commands to run the Multivariate example...
addpath('../code')

% read data
dat=fd(1:2);

% initial set-up
optParms.priors.lamOs.a=1000; optParms.priors.lamOs.b=1000;
optParms.lamVzGroup=1:2;
params=setupModel(dat.obsData,dat.simData,optParms);

% modifications to defaults
params.priors.lamVz.a=100;
params.priors.lamVz.b=0.0001;
params.priors.lamWs.a=1;
params.priors.lamWs.b=0.0001;

% modifications to initial values
params.model.lamOs=1;

% step size
nburn=100; nlev=21;
params=gpmmcmc(params,0,'stepInit',1,'nBurn',nburn,'nLev',nlev);
params=stepsize(params,nburn,nlev);

% mcmc
nmcmc=40000;
pout=gpmmcmc(params,nmcmc,'step',1);
save pout pout;

nmcmc=nmcmc+nburn*nlev;
pvec=floor(linspace(nburn*nlev+1,nmcmc,500));
pout.pvec500=pvec;

% calibration parameters
tmp=[pout.pvals.theta]';
save 'theta' tmp '-ascii';

% plots
%load pout;
fdPlots(pout,pvec,1:2);

%holdout;
%fdPlots(pout,pvec,3);

pvec=round(linspace(nburn*nlev+1,nmcmc,30));
pout.pvec30=pvec;
save pout pout

%fdPlots(pout,pvec,4);
