%% ipcam2ros
% https://github.com/christophebedard/matlab-ipcam2ros
% 
% MATLAB script to acquire IP camera feed and publish on a ROS topic
% 
% IP camera application used
% Name:         IP Webcam https://play.google.com/store/apps/details?id=com.pas.webcam
% Parameters:   Scroll down and press "start server." Note the IP address
%               and the port
%% Init
rosshutdown;
clear all; close all; clc;
clear cam;
%% Parameters
% IP camera
cam_ip = '192.168.0.100';
cam_port = '8080';
img_h = 720;
img_w = 1280;
distortion_model = 'plumb_bob';
distortion_matrix = [0.224799, -0.542636, -0.003503, -0.002816, 0.0];
intrinsic_camera_matrix = [1122.176766,         0.0, 610.341398
                                   0.0, 1126.613544, 360.072269
                                   0.0,         0.0,        1.0];
projection_matrix = [1139.487793,         0.0, 604.745357, 0.0
                             0.0, 1154.259644, 358.328299, 0.0
                             0.0,         0.0,        1.0, 0.0];
% ROS
image_topic = '/camera/image_raw';
camerainfo_topic = '/camera/camera_info';
ros_master_ip = '192.168.0.105';
ros_port = '11311';
ros_ip = '192.168.0.160';
% =========================================================================
% =========================================================================
%% Init ROS
setenv('ROS_MASTER_URI',['http://',ros_master_ip,':',ros_port]);
setenv('ROS_IP',ros_ip);
rosinit;
%% Init publishers
% Images
img_pub = rospublisher(image_topic, 'sensor_msgs/Image');
msg_ = rosmessage(img_pub);
msg_.Height = img_h;
msg_.Width = img_w;
msg_.Encoding = 'rgb8';
msg_.Step = 3*img_w;
% Camera info
caminfo_pub = rospublisher(camerainfo_topic, 'sensor_msgs/CameraInfo');
caminfo_msg_ = rosmessage(caminfo_pub);
caminfo_msg_.Height = img_h;
caminfo_msg_.Width = img_w;
caminfo_msg_.DistortionModel = distortion_model;
caminfo_msg_.D = distortion_matrix;
caminfo_msg_.K = reshape(intrinsic_camera_matrix.',1,[]);
caminfo_msg_.P = reshape(projection_matrix.',1,[]);
%% Start
% Connect to IP cam
url = ['http://',cam_ip,':',cam_port,'/video'];
cam = ipcam(url);
while 1
    % Acquire
    [img,ts] = snapshot(cam);
    % Write message
    writeImage(msg_,img);
    % Publish
    send(img_pub, msg_);
    send(caminfo_pub, caminfo_msg_);
end