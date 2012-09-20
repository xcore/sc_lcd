Executing The Project
---------------------
The module by itself cannot be build or executed separately. It must be linked in to an application which needs LCD display. Once the module is linked to the application, the application can be built and tested for driving a LCD screen.

The following should be done in order to link the component to the application project
  #. The module name ``module_lcd`` should be added to the list of MODULES in the application project build options. 
  #. Now the module is linked to the application and can be directly used
