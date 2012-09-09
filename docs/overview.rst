Overview
========

The LCD component is used to drive a single graphics LCD module up to 800 * 600 pixels. 
The component is designed to support multiple targets - LCD modules with no internal image buffer.
The target used in the example is TM043NDH02 from SHANGHAI TIANMA MICRO-ELECTRONICS corporation

Component Summary
+++++++++++++++++

+----------------------------------------------------------------+
| 	               **Functionality**	      		 |
+----------------------------------------------------------------+
|  Component driving a graphics LCD module 		         |
+----------------------------------------------------------------+
| 		      **Supported Device**		         |
+-------------------------------+--------------------------------+
| | XMOS devices		| | XS1-L1                       |
|				| | XS1-L2		         |
| 				| | XS1-G4			 |
+-------------------------------+--------------------------------+
|  	               **Requirements** 		         |
+-------------------------------+--------------------------------+
| XMOS Desktop Tools		| V11.11.0 or later	         |
+-------------------------------+--------------------------------+
| XMOS LCD component		| 1v0                            |
+-------------------------------+--------------------------------+
|                     **Licensing and Support**                  |
+----------------------------------------------------------------+
| Component code provided without charge from XMOS.              |
| Component code is maintained by XMOS.                          |
+----------------------------------------------------------------+


LCD Display component properties
++++++++++++++++++++++++++++++++

	* Standard component to support different LCD modules
	* The target name can be specified in the build options inorder to automatically select the target configurations by the component
	* Different color depths 24 bpp, 18 bpp, 16 bpp based on user configuration
	* Frame rate dependent on resolution and frame rate.
	* Uses one thread
	* Resolution upto 800 * 600 pixels. See table below for different screen configurations.
        * Example code for 480 * 272 pixel

		======== ========= ========= ========== =========
		Screen	 PClk(MHz) Ref. Rate Bandwidth  FB Size 
		======== ========= ========= ========== =========
		320x240	 5	   52.08     4000000    76800   
		320x240	 6	   62.50     4800000    76800   
		320x240	 7	   72.92     5600000    76800   
		480x240	 7	   48.61     5600000    115200  
		480x240	 8	   55.56     6400000    115200  
		480x240	 9	   62.50     7200000    115200 
		480x272	 7	   42.89     5600000    130560  
		480x272	 9	   55.15     7200000    130560  
		480x272	 12	   73.53     9600000    130560  
		640x480	 21	   54.69     16800000   307200  
		640x480	 25	   65.10     20000000   307200  
		640x480	 29	   75.52     23200000   307200 
		800x600	 34	   56.67     27200000   480000  
		800x600	 36	   60.00     28800000   480000  
		800x600	 38	   63.33     30400000   480000  
		800x600	 40	   66.67     32000000   480000  
		800x600	 32	   53.33     25600000   480000  
		800x600	 34	   56.67     27200000   480000  
		800x600	 36	   60.00     28800000   480000  
		======== ========= ========= ========== =========

Resource requirements
=====================

The resource requirements for the LCD component are:

+--------------+-----------------------------------------------+
| Resource     | Usage                            	       |
+==============+===============================================+
| Channels     | 1 		                               |
+--------------+-----------------------------------------------+
| Timers       | 1 (for deciding the LCD signal write timings) |
+--------------+-----------------------------------------------+
| Clocks       | 1 (the LCD clock)                             |
+--------------+-----------------------------------------------+
| Threads      | 1                                             |
+--------------+-----------------------------------------------+

The memory requirements for the component are as shown below:
+--------------+-----------------------------------------------+
| Resource     | Usage                            	       |
+==============+===============================================+
| Setting      | No Optimization                               |
+--------------+-----------------------------------------------+
| Compiler     | XCC                                           |
+--------------+-----------------------------------------------+
| Stack        | 16 bytes (for LCD ports)                      |
+--------------+-----------------------------------------------+
| Program      | 212 bytes                                     |
+--------------+-----------------------------------------------+


