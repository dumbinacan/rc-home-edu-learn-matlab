% Final vision algorithm (Depth mode)

% Copyright 2018 The MathWorks, Inc.

%% Setup
connectToRobot;
% Create publishers and subscribers for vision
imgSub = rossubscriber(RGB_IMAGE);
depthSub = rossubscriber(DEPTH_IMAGE);
[vPub,vMsg] = rospublisher(ROBOT_CMD_VEL);

%% Get first images
close all
imgMsg = receive(imgSub);
img = readImage(imgMsg);
figure, imshow(img);
depthMsg = receive(depthSub);
depthImg = readImage(depthMsg);
figure, imshow(depthImg,[0 3000]); % Plot up to 3 meters

%% OBJECT DETECTION + TRACKING
objType = 'blue';

% Create video player for visualization
vidPlayer = vision.DeployableVideoPlayer;

gripCount = 0;
while(gripCount < 20)
    % Get image data
    imgMsg = imgSub.LatestMessage;
    img = readImage(imgMsg);
    depthMsg = depthSub.LatestMessage;
    depthImg = readImage(depthMsg);
    
    % Detect object
    [objLocation,objArea,objBox] = detectObject(img,objType);
    objDepth = getObjectDepth(depthImg,objBox);
    
    % Visualize and track only if an object is found
    if ~isempty(objDepth) && (objDepth > 0)
        % Visualize
        img = insertShape(img,'Rectangle',objBox,'LineWidth',2);
        img = insertText(img,[0 0],['Depth: ' num2str(objDepth) ' m'], ...
            'FontSize',20);
        
        % Track object using depth mode
        imgWidth = size(img,2);
        [v,w,grip] = trackObjectDepth(objLocation,objDepth,imgWidth);
        
        % Keep track of "ready to grip" counter
        if grip
            gripCount = gripCount + 1;
        else
            gripCount = 0;
        end
        
        % Publish velocity command
        vMsg.Linear.X = v;
        vMsg.Angular.Z = w;
        send(vPub,vMsg);
    end
    
    step(vidPlayer,img);
    
end
disp('Ready to grip!')
