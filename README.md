# matlab-ipcam2ros

Use an IP camera with ROS with a simple MATLAB script.

## What it does

It uses MATLAB's image acquisition toolbox (required) to acquire images from an IP camera's video feed and publish them.

## IP camera

Any IP camera (with an IP and port) should work. This was tested with the [IP Webcam](https://play.google.com/store/apps/details?id=com.pas.webcam) application on an Android phone.

You can specify camera calibration parameters.

## ROS

It publishes two topics:

* images (`sensor_msgs/Image`)
* camera information (`sensor_msgs/CameraInfo`)

## Camera calibration

See this [tutorial](http://wiki.ros.org/camera_calibration/Tutorials/MonocularCalibration).