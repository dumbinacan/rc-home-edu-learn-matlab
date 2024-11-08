% Speech recognition example task
% Copyright 2018-2019 The MathWorks, Inc.

% NOTE: This requires the soundplay_node to be running on your machine.
%       roslaunch sound_play soundplay_node.py

%% Setup
connectToRobot;
% Subscribe to speech recognition node
speechSub = rossubscriber('/lm_data');
% Create speech action server and configure the goal
[speechClient,speechGoal] = rosactionclient('/sound_play');
speechClient.FeedbackFcn = '';
speechGoal.SoundRequest.Sound = speechGoal.SoundRequest.SAY;
speechGoal.SoundRequest.Command = speechGoal.SoundRequest.PLAYONCE;
speechGoal.SoundRequest.Volume = 1.0;
speechGoal.SoundRequest.Arg2 = 'voice_kal_diphone';

%% Call speech recognizer, convert output to MATLAB string
clc
disp('Hearing audio clip...')
speechMsg = receive(speechSub);
speechStr = speechMsg.Data;
disp('Listening done')
disp('Raw message:')
disp(speechStr)

%% Parse the command
[goalPoint,objType,outputMsg] = parseSpeechCommand(speechStr);
disp('Output message:')
disp(outputMsg)

%% Speak the command
speechGoal.SoundRequest.Arg = outputMsg;
sendGoal(speechClient,speechGoal);  