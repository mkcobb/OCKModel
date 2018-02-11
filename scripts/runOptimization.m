%% Script to run an optimization

% Clean up before doing anyting
close all;clear;clc;bdclose all;

% Change to the correct path and add all subfolders to the path
cd(fileparts(which(mfilename)))
addpath(genpath(pwd))

% Load the simulink model
load_system('CDCJournalModel')
preLoadCallback
p.runMode   = 1;
p.ic        = 'userspecified';
p.height    = 15;
p.width     = 100;
p.verbose   = 0;
p.soundOnOff = 1;


startCallback
sim('CDCJournalModel')
close_system('CDCJournalModel')
stopCallback

