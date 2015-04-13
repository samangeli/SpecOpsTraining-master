BlackZero8
==========


Submodules
----------

The applicaiton uses the following as git submodules:


  AFNetworking - for handling online downloading of missions from the CMS. To install AFNetworking, you need to init the submodule and udpate it from Github:
  
  	git submodule add git://github.com/AFNetworking/AFNetworking


Other Frameworks
----------------

  - PSLocationManager -  used for some apsects of the location updates.
  - SSZipArchive - for uncompressing zip files
  
As well the app uses frameworks from:
  
  - Parse.com
  - TestFlightApp.com
  - Facebook.com
  

Start-up
--------

When the app starts-up, the download manager is invoked to download the latest manifest.json file from the Missoin CMS.  If there are new or updated missions, they get downloaded.

The initial view is a black view with a acitivity indicator;  after any downloaded have completed, the view is switched to the home view.
    


App Styling
-----------

The app. makes extensive use of storyboards.  As the app is using a custom font, the font is set at run-time.  To make this more efficient, the app uses collections of the different objects groups into different categories.

Most of the view controllers inherhit from the class Base View Controller.  In the viewDidLoad method, the fonts are specified.  The same method is where colours and other attributes on the UI objects can be specified.



Debugging the App
-----------------

The user interface will appear differently if the DEBUG macro is set. E.g geo-location informaiton will appear on the home view and there is debug view available from the menu.
