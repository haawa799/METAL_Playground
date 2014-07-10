UPDATE
===================
After finishing this try-out project I made Flappy bird colne with Metal, go check it out https://github.com/haawa799/Metal-Flaps


METAL_Playground
===================
Task: Create complex 3D scene app using Apples new Metal framework, using Swift as much as possible.

NOTE1: Since I'm trying to use Swift where it's posiible, this code is not super efficient or fast, there are some wrappers which are not recommanded in this kind of projects.

Hope to improve it as new Xcode betas will come out.

NOTE: 

1) For now (Xcode 6 - beta2) requires -Ofast compiler flag to build.

2) iOS 8 and device with A7 required! Doesn't work on simulator.

![alt tag](http://cl.ly/image/2h2p3x2r0f2E/triangle.png) ![alt tag](http://cl.ly/image/400Y0C3G2c0o/transform.png) ![alt tag](http://cl.ly/image/2u2v1W3H3T3b/texture.png) ![alt tag](http://cl.ly/image/0B153R3g2M21/lighting.png) ![alt tag](http://cl.ly/image/0g2K022n220m/ram.png) 


Model importing script Obj_Convert.py
===================

In part 5 i wrote simple python script which parse OBJ file (generated from Blender or any other 3D model tool) and produce Swift class and txt file.

Here are steps on how I used it to get that Ram rendered. Here's a link to free 3D model http://www.3dvia.com/models/67EC495D6F415365/ramiro-the-ram, thanks to dipsy.

1. Put your OBJ and MTL file (generated from Blender) into one folder
![alt tag](http://cl.ly/image/012R0p303g2J/Screen%20Shot%202014-07-04%20at%2012.14.22%20AM.png) 

2. Make sure that both OBJ and MTL files have same name, and this name will be your Swift class name, in my case it's "ram.obj" and "ram.mtl"

3. Put Obj_Convert.py file into same folder
![alt tag](http://cl.ly/image/0s2A0G1P2G2X/Screen%20Shot%202014-07-04%20at%2012.14.57%20AM.png)

4. From terminal cd to your folder
![alt tag](http://cl.ly/image/00312g2F2Q2y/Screen%20Shot%202014-07-04%20at%2012.16.01%20AM.png)

5. Run following command "python Obj_Convert.py name" name should be equal to .obj and .mtl file names in my case it's "ram"
![alt tag](http://cl.ly/image/010Y1q410g2E/Screen%20Shot%202014-07-04%20at%2012.16.41%20AM.png)

6. Check you folder, .swift and .txt files should be there, drag and drop them into your project
![alt tag](http://cl.ly/image/410j0F330G22/Screen%20Shot%202014-07-04%20at%2012.19.00%20AM.png)
![alt tag](http://cl.ly/image/2Z3a1B3w3v3c/Screen%20Shot%202014-07-04%20at%2012.20.55%20AM.png)

7. Double check .swift file, wethere texture name is correct
![alt tag](http://cl.ly/image/3N2u1l3k1f0w/Screen%20Shot%202014-07-04%20at%2012.57.21%20AM.png)

8. Use imported model as any other Model subclass inside your MetalViewController
