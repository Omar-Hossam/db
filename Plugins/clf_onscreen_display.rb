=begin
Copyright 2013, Chris Fullmer
All Rights Reserved

Disclaimer
THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

License
This software is distributed under the Smustard End User License Agreement
http://www.smustard.com/eula

Information
Author - Chris Fullmer
Organization - www.ChrisFullmer.com and distributed on the SketchUp Extension Warehouse
Name - OnScreen Display
SU Version - 2013, 8, 7

Description 
This script shows the cursor location and screen position, and the 
name of the selected component.  If no component is selected, it names what 
is selected (group, face, edge, 3d polyline, etc)

Usage
Activate the tool from Plugins> OnScreen Display.  Move the cursor.  
Left click and hold the mouse to get the OnScreen Display.  If you've selected a component, 
it will show the Instance name (I usually leave that blank, so don't be surprised if that is blank) 
and the Definition name.  The definition is what you normally see in the component browser.

History
0.1:: 2009-02-20
   * Original release. Plenty of bugs.  Some known, probably lots of unknown.
0.2:: 2009-03-09
   * minor tweaks
0.3.0 - 2013-05-20
  * EW Compatibility
=end


module CLF_Extensions_NS

  module CLF_OnScreen_Display

    require 'sketchup.rb'
    require 'extensions.rb'
    
    NAME = "clf_onscreen_display"
    UNAME = "CLF OnScreen Display"
    MENU_NAME = "OnScreen Display"
    version = "0.3.0"           #EDIT
    desc = "This plugin shows information to the screen about the model, such as component names, cursor coordinates, etc."
    copy_year = "2013"
    author = "Chris Fullmer"
    
#------edit above--------------------------------------------------------------- 

    
    extension = SketchupExtension.new UNAME, NAME+"/"+NAME+"_menus.rb"

    #The name= method sets the name which appears for an extension inside the Extensions Manager dialog.
    extension.name = UNAME

    # The description= method sets the long description which appears beneath an extension inside the Extensions Manager dialog.
    extension.description = desc + "  Access it via Plugins > Chris Fullmer Tools > "+MENU_NAME

    # The version method sets the version which appears beneath an extension inside the Extensions Manager dialog.
    extension.version = version

    # Create an entry in the Extension list that loads a script called
    # stairTools.rb.
    extension.copyright = copy_year
     
    # The creator= method sets the creator string which appears beneath an extension inside the Extensions Manager dialog.
    extension.creator = author

    # The register_extension method is used to register an extension with SketchUp's extension manager (in SketchUp preferences).
    Sketchup.register_extension( extension, true )
    
  end
end  