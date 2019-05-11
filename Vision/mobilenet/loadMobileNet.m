% Loads a pretrained MobileNet model and returns a filtered set of class
% names and class indices.
%
% Copyright 2019 The MathWorks, Inc.

% Load the pretrained MobileNet model
s = load('mobilenet.mat');
mobilenet = s.mobilenet;

% Filter classes by desired categories [MODIFY AS NEEDED]
categories =  {'banana', 'slug', 'orange', 'ping-pong_ball', ... 
    'pineapple','cup', 'coffee_mug', 'coffeepot','water_bottle', .... 
    'wine_bottle','plastic_bag','volleyball', 'soccer_ball','rugby_ball',...
    'basketball','football_helmet','teddy', 'toy_poodle'};
classNames = mobilenet.Layers(end).Classes;
classIndices = contains(string(classNames),categories);
classNames = classNames(classIndices);