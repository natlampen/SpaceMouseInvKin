# SpaceMouseInvKin

Seeing Salim Benbouziyane's [video](https://youtu.be/62xlzGs8LXA) on a 6DoF SpaceMouse I just wanted to evaluate the inverse kinematics of the system. Basically calculating the orientation of the joystick based on the 3 x 3D magnetometers. 

The result is a very basic Julia script, **main.jl**, which takes the sensor locations in polar coordinates. It would be simple to define the sensor location as just X,Y,Z coordinates.
