Executing The Project
---------------------
The component by itself cannot be build or executed separately.
The component should be linked in an application which needs graphics LCD display. Once the component is linked to the application, the application can be built and tested for driving a graphics LCD maodule.

The following should be done in order to link the component to the application project
  #. The LCD parameters should be configured according to the graphics LCD module used. The files `lcd.h` and `lcd_ports.xc` should be configured accordingly
  #. The module name 'module_lcd' should be added to the list of MODULES in the application project build options
  #. The object names 'lcd' and 'lcd_ports' should be added to the list of OBJECT NAMES in the application project build options
  #. The module 'module_lcd' should be added in the 'References' section in the application Project settings
  #. Now the module is linked to the application and can be directly used
