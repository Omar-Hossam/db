# UI.messagebox('Welcome to Digitales Bauen Architechture tool!')
cam = Sketchup.active_model.active_view.camera
Sketchup.send_action("viewTop:")
cam.perspective = false
toolbar = UI::Toolbar.new "Digitales Bauen"
cmd = UI::Command.new("Digitales Bauen") { 
  class DBTool
    def activate
      puts "Your tool has been activated."
    end

    # def onLButtonDown(flags, x, y, view)
    #   model = Sketchup.active_model
    #   selection = model.selection
    #   entities = model.active_entities
    #   entity = entities[0]
    #   status = selection.add selection
    #   #model.selection.add
    #   puts "onLButtonDown: flags = " + flags.to_s
    #   puts "                   x = " + x.to_s
    #   puts "                   y = " + y.to_s
    #   puts "                view = " + view.to_s
    # end

    def getMenu(menu)
      menu.add_item("Edit attributes") {
        model = Sketchup.active_model.selection
        m = model[0]
        at = m.attribute_dictionary "dboh"
        if at == nil
          UI.messagebox("Sorry, no attributes added yet")
        else
          ss = Sketchup.active_model.selection
          return if ss.empty?

          $LabelementWorkdist = ss[0].get_attribute 'dboh', "LabelementWorkdist"
          $LabelementWalkdist = ss[0].get_attribute 'dboh', "LabelementWalkdist"
          $Width = ss[0].get_attribute 'dboh', "Width"
          $Depth = ss[0].get_attribute 'dboh', "Depth"
          $Height = ss[0].get_attribute 'dboh', "Height"
          $Containmentmaterial = ss[0].get_attribute 'dboh', "Containmentmaterial"
          $Deskfront = ss[0].get_attribute 'dboh', "Deskfront"
          $Benchfront = ss[0].get_attribute 'dboh', "Benchfront"
          $Sinkmaterial = ss[0].get_attribute 'dboh', "Sinkmaterial"
          $Extractiontype = ss[0].get_attribute 'dboh', "Extractiontype"
          $Gastaptype = ss[0].get_attribute 'dboh', "Gastaptype"
          $Drainagetype = ss[0].get_attribute 'dboh', "Drainagetype"
          $Liquidtaptype = ss[0].get_attribute 'dboh', "Liquidtaptype"
          $HVtype = ss[0].get_attribute 'dboh', "HVtype"
          $LVtype = ss[0].get_attribute 'dboh', "LVtype"
          $Comtype = ss[0].get_attribute 'dboh', "Comtype"
          $XPos = ss[0].get_attribute 'dboh', "XPos"
          $YPos = ss[0].get_attribute 'dboh', "YPos"
          $ZPos = ss[0].get_attribute 'dboh', "ZPos"

          prompts = ["LabelementWorkdist", "LabelementWalkdist",
            "Width", "Depth", "Height", "Containmentmaterial", "Deskfront",
            "Benchfront", "Sinkmaterial", "Extractiontype", "Gastaptype",
            "Drainagetype", "Liquidtaptype", "HVtype", "LVtype", "Comtype",
            "XPos", "YPos", "ZPos"]
          values = [$LabelementWorkdist, $LabelementWalkdist, $Width,
            $Depth, $Height, $Containmentmaterial, $Deskfront, $Benchfront,
            $Sinkmaterial, $Extractiontype, $Gastaptype, $Drainagetype,
            $Liquidtaptype, $HVtype, $LVtype, $Comtype, $XPos, $YPos, $ZPos]
          results = inputbox prompts, values, "Edit Attributes"
          return if not results

          $LabelementWorkdist = results[0]
          $LabelementWalkdist = results[1]
          $Width = results[2]
          $Depth = results[3]
          $Height = results[4]
          $Containmentmaterial = results[5]
          $Deskfront = results[6]
          $Benchfront = results[7]
          $Sinkmaterial = results[8]
          $Extractiontype = results[9]
          $Gastaptype = results[10]
          $Drainagetype = results[11]
          $Liquidtaptype = results[12]
          $HVtype = results[13]
          $LVtype = results[14]
          $Comtype = results[15]
          $XPos = results[16]
          $YPos = results[17]
          $ZPos = results[18]

          ss.each do |e|
            e.set_attribute 'dboh', "XPos", $XPos
            e.set_attribute 'dboh', "YPos", $YPos
            e.set_attribute 'dboh', "ZPos", $ZPos
            e.set_attribute 'dboh', "LabelementWorkdist", $LabelementWorkdist
            e.set_attribute 'dboh', "LabelementWalkdist", $LabelementWalkdist
            e.set_attribute 'dboh', "Width", $Width
            e.set_attribute 'dboh', "Depth", $Depth
            e.set_attribute 'dboh', "Height", $Height
            e.set_attribute 'dboh', "Containmentmaterial", $Containmentmaterial
            e.set_attribute 'dboh', "Deskfront", $Deskfront
            e.set_attribute 'dboh', "Benchfront", $Benchfront
            e.set_attribute 'dboh', "Sinkmaterial", $Sinkmaterial
            e.set_attribute 'dboh', "Extractiontype", $Extractiontype
            e.set_attribute 'dboh', "Gastaptype", $Gastaptype
            e.set_attribute 'dboh', "Drainagetype", $Drainagetype
            e.set_attribute 'dboh', "Liquidtaptype", $Liquidtaptype
            e.set_attribute 'dboh', "HVtype", $HVtype
            e.set_attribute 'dboh', "LVtype", $LVtype
            e.set_attribute 'dboh', "Comtype", $Comtype

            pt = Geom::Point3d.new($XPos,$YPos,$ZPos)
            t = Geom::Transformation.new(pt)
            e.transformation= t
          end
          UI.messagebox("Attributes edits applied")
        end
      }
      menu.add_item("Zoom to slection"){
        selection = Sketchup.active_model.selection
        view = Sketchup.active_model.active_view
        view = view.zoom selection
      }
      scenes_menu = menu.add_submenu("change view")
      scenes_menu.add_item("Top view") {
      Sketchup.send_action("viewTop:")
      cam.perspective = false
      }
      scenes_menu.add_item("Front view") {
      Sketchup.send_action("viewFront:")
      cam.perspective = false
      }
      scenes_menu.add_item("Bottom view") {
      Sketchup.send_action("viewBottom:")
      cam.perspective = false
      }
      scenes_menu.add_item("Back view") {
      Sketchup.send_action("viewBack:")
      cam.perspective = false
      }
      scenes_menu.add_item("Right view") {
      Sketchup.send_action("viewRight:")
      cam.perspective = false
      }
      scenes_menu.add_item("Left view") {
      Sketchup.send_action("viewLeft:")
      cam.perspective = false
      }
      scenes_menu.add_item("Iso view") {
      Sketchup.send_action("viewIso:")
      cam.perspective = false
      }
    end

    def onLButtonDoubleClick(flags, x, y, view)
      model = Sketchup.active_model.selection
      m = model[0]
      at = m.attribute_dictionary "dboh"
      if at == nil
        UI.messagebox("Sorry, no attributes added yet")
      else
        ks = at.keys
        message = ""
        ks.each do |k|
          val = m.get_attribute "dboh", k
          message += k.to_s + ": " + val.to_s + "\n"
        end
        UI.messagebox(message)
      end
    end

    # def onMouseEnter(view)
    #   puts "onMouseEnter: view = " + view.to_s
    # end

  end

  DB_tool = DBTool.new
  Sketchup.active_model.select_tool DB_tool
}
cmd.small_icon = "images/icon.jpg"
cmd.large_icon = "images/icon.jpg"
cmd.tooltip = "Digitales Bauen Toolbars"
cmd.status_bar_text = "Special design"
cmd.menu_text = "Digitales Bauen"
toolbar = toolbar.add_item cmd
toolbar.show

cmd = UI::Command.new("Digitales Bauen") { 
  class TopView
    def activate
      cam = Sketchup.active_model.active_view.camera
      Sketchup.send_action("viewTop:")
      cam.perspective = false
    end  
  end

  Top_view = TopView.new
  Sketchup.active_model.select_tool Top_view
}
cmd.small_icon = "images/Top.PNG"
cmd.large_icon = "images/Top.PNG"
cmd.tooltip = "Digitales Bauen Toolbars"
cmd.status_bar_text = "Top view"
cmd.menu_text = "Digitales Bauen"
toolbar = toolbar.add_item cmd
toolbar.show

cmd = UI::Command.new("Digitales Bauen") { 
  class BottomView
    def activate
      cam = Sketchup.active_model.active_view.camera
      Sketchup.send_action("viewBottom:")
      cam.perspective = false
    end  
  end

  Bottom_view = BottomView.new
  Sketchup.active_model.select_tool Bottom_view
}
cmd.small_icon = "images/Bottom.PNG"
cmd.large_icon = "images/Bottom.PNG"
cmd.tooltip = "Digitales Bauen Toolbars"
cmd.status_bar_text = "Bottom view"
cmd.menu_text = "Digitales Bauen"
toolbar = toolbar.add_item cmd
toolbar.show

cmd = UI::Command.new("Digitales Bauen") { 
  class FrontView
    def activate
      cam = Sketchup.active_model.active_view.camera
      Sketchup.send_action("viewFront:")
      cam.perspective = false
    end  
  end

  Front_view = FrontView.new
  Sketchup.active_model.select_tool Front_view
}
cmd.small_icon = "images/Front.PNG"
cmd.large_icon = "images/Front.PNG"
cmd.tooltip = "Digitales Bauen Toolbars"
cmd.status_bar_text = "Front view"
cmd.menu_text = "Digitales Bauen"
toolbar = toolbar.add_item cmd
toolbar.show

cmd = UI::Command.new("Digitales Bauen") { 
  class BackView
    def activate
      cam = Sketchup.active_model.active_view.camera
      Sketchup.send_action("viewBack:")
      cam.perspective = false
    end  
  end

  Back_view = BackView.new
  Sketchup.active_model.select_tool Back_view
}
cmd.small_icon = "images/Back.PNG"
cmd.large_icon = "images/Back.PNG"
cmd.tooltip = "Digitales Bauen Toolbars"
cmd.status_bar_text = "Back view"
cmd.menu_text = "Digitales Bauen"
toolbar = toolbar.add_item cmd
toolbar.show

cmd = UI::Command.new("Digitales Bauen") { 
  class IsoView
    def activate
      cam = Sketchup.active_model.active_view.camera
      Sketchup.send_action("viewIso:")
      cam.perspective = false
    end  
  end

  Iso_view = IsoView.new
  Sketchup.active_model.select_tool Iso_view
}
cmd.small_icon = "images/Iso.PNG"
cmd.large_icon = "images/Iso.PNG"
cmd.tooltip = "Digitales Bauen Toolbars"
cmd.status_bar_text = "Iso view"
cmd.menu_text = "Digitales Bauen"
toolbar = toolbar.add_item cmd
toolbar.show

cmd = UI::Command.new("Digitales Bauen") { 
  class LeftView
    def activate
      cam = Sketchup.active_model.active_view.camera
      Sketchup.send_action("viewLeft:")
      cam.perspective = false
    end  
  end

  Left_view = LeftView.new
  Sketchup.active_model.select_tool Left_view
}
cmd.small_icon = "images/Left.PNG"
cmd.large_icon = "images/Left.PNG"
cmd.tooltip = "Digitales Bauen Toolbars"
cmd.status_bar_text = "Left view"
cmd.menu_text = "Digitales Bauen"
toolbar = toolbar.add_item cmd
toolbar.show

cmd = UI::Command.new("Digitales Bauen") { 
  class RightView
    def activate
      cam = Sketchup.active_model.active_view.camera
      Sketchup.send_action("viewRight:")
      cam.perspective = false
    end  
  end

  Right_view = RightView.new
  Sketchup.active_model.select_tool Right_view
}
cmd.small_icon = "images/Right.PNG"
cmd.large_icon = "images/Right.PNG"
cmd.tooltip = "Digitales Bauen Toolbars"
cmd.status_bar_text = "Right view"
cmd.menu_text = "Digitales Bauen"
toolbar = toolbar.add_item cmd
toolbar.show

cmd = UI::Command.new("Digitales Bauen") { 
  class Rotate
    def activate
      cmp = Sketchup.active_model.selection.first
      pt1 = Geom::Point3d.new
      vector = Geom::Vector3d.new 0,0,1
      p = Math::PI
      transformation = Geom::Transformation.rotation pt1, vector, 0.5*p
      cmp.transform! transformation
    end  
  end

  rotato = Rotate.new
  Sketchup.active_model.select_tool rotato
}
cmd.small_icon = ""
cmd.large_icon = ""
cmd.tooltip = "Digitales Bauen Toolbars"
cmd.status_bar_text = "rotate"
cmd.menu_text = "Digitales Bauen"
toolbar = toolbar.add_item cmd
toolbar.show

cmd = UI::Command.new("Digitales Bauen") { 
  class MakeView
    def activate
      ss = Sketchup.active_model.selection
      bayez = false
      bawazan = false
      ss.each do |s|
        if s.typename != "ComponentInstance"
          byaez = true
        end
        cmpv = s.get_attribute 'o.h', "Component Name"
        if(cmpv.nil?)
          bawazan = true
        end
      end
      if ss.empty?
        UI.messagebox("Nothing is selected, please select an object first")
        return
      elsif bayez == true
        UI.messagebox("Not all selected objects are components. Please make components first")
        return
      elsif bawazan == true
        UI.messagebox("One or more of the components selected don't have attributes or is not of a component class. Please make sure that all selected objects are from the component class and add attributes to all components first")
      else
        $value = "001"
        $depthOffset = 150
        $heightOffset = 200
        prompts = ["View Number", "Depth Offset", "Height Offset"]
        values = [$value, $depthOffset, $heightOffset]
        results = inputbox prompts, values, "Make View"
        return if not results
        $value = results[0]
        $depthOffset = results[1]
        $heightOffset = results[2]
        group = Sketchup.active_model.active_entities.add_group(ss)
        $xViewOffset = group.transformation.origin.x
        $yViewOffset = group.transformation.origin.y
        $zViewOffset = group.transformation.origin.z
        gg = group.entities
        gg.each do |g|
          x = g.get_attribute 'o.h', "Component x Offset"
          $xCmpOffset = x - $xViewOffset
          y = g.get_attribute 'o.h', "Component y Offset"
          $yCmpOffset = y - $yViewOffset
          z = g.get_attribute 'o.h', "Component z Offset"
          $zCmpOffset = z - $zViewOffset
          g.set_attribute 'o.h', "Component x Offset", $xCmpOffset
          g.set_attribute 'o.h', "Component y Offset", $yCmpOffset
          g.set_attribute 'o.h', "Component z Offset", $zCmpOffset
          g.set_attribute 'o.h', "View Number", $value
          g.set_attribute 'o.h', "View x Offset", $xViewOffset
          g.set_attribute 'o.h', "View y Offset", $yViewOffset
          g.set_attribute 'o.h', "View z Offset", $zViewOffset
          g.set_attribute 'o.h', "Depth Offset", $depthOffset
          g.set_attribute 'o.h', "Height Offset", $heightOffset
        end
 
        cmp = group.to_component
        cmp.definition.name = "cLabView"
        cmp.set_attribute 'o.h', "View Number", $value
        cmp.set_attribute 'o.h', "View x Offset", $xViewOffset
        cmp.set_attribute 'o.h', "View y Offset", $yViewOffset
        cmp.set_attribute 'o.h', "View z Offset", $zViewOffset
        cmp.set_attribute 'o.h', "Depth Offset", $depthOffset
        cmp.set_attribute 'o.h', "Height Offset", $heightOffset
        UI.messagebox("View created")
      end
    end  
  end

  Make_View = MakeView.new
  Sketchup.active_model.select_tool Make_View
}
cmd.small_icon = "images/view.PNG"
cmd.large_icon = "images/view.PNG"
cmd.tooltip = "Digitales Bauen Toolbars"
cmd.status_bar_text = "Make a view"
cmd.menu_text = "Digitales Bauen"
toolbar = toolbar.add_item cmd
toolbar.show

cmd = UI::Command.new("Digitales Bauen") { 
  class MakeRoom
    def activate
      ss = Sketchup.active_model.selection
      bayez = false
      bawazan = false
      ss.each do |s|
        cmpv = s.get_attribute 'o.h', "View Number"
        if(cmpv.nil?) || s.typename != "ComponentInstance"
          bawazan = true
        end
      end
      if ss.empty?
        UI.messagebox("Nothing is selected, please select an object first")
        return
      elsif bawazan == true
        UI.messagebox("Not all selected objects are from the View class. Please make sure when creating a room that all objects are Views")
      else
        $roomNo = "001"
        $roomName = ""
        $roomDept = ""
        prompts = ["Room Number", "Room Name", "Room Departement"]
        values = [$roomNo, $roomName, $roomDept]
        results = inputbox prompts, values, "Make Room"
        return if not results
        $roomNo = results[0]
        $roomName = results[1]
        $roomDept = results[2]
        group = Sketchup.active_model.active_entities.add_group(ss)
        $xRoomOffset = group.transformation.origin.x
        $yRoomOffset = group.transformation.origin.y
        $zRoomOffset = group.transformation.origin.z
        gg = group.entities
        gg.each do |g|
          x = g.get_attribute 'o.h', "View x Offset"
          $xViewOffset = x - $xRoomOffset
          y = g.get_attribute 'o.h', "View y Offset"
          $yViewOffset = y - $yRoomOffset
          z = g.get_attribute 'o.h', "View z Offset"
          $zViewOffset = z - $zRoomOffset
          g.set_attribute 'o.h', "View x Offset", $xViewOffset
          g.set_attribute 'o.h', "View y Offset", $yViewOffset
          g.set_attribute 'o.h', "View z Offset", $zViewOffset
          g.set_attribute 'o.h', "Room Number", $roomNo
          g.set_attribute 'o.h', "Room x Offset", $xRoomOffset
          g.set_attribute 'o.h', "Room y Offset", $yRoomOffset
          g.set_attribute 'o.h', "Room z Offset", $zRoomOffset
          g.set_attribute 'o.h', "Room Name", $roomName
          g.set_attribute 'o.h', "Room Departement", $roomDept
          g.definition.entities.each do |c|
            c.set_attribute 'o.h', "View x Offset", $xViewOffset
            c.set_attribute 'o.h', "View y Offset", $yViewOffset
            c.set_attribute 'o.h', "View z Offset", $zViewOffset
            c.set_attribute 'o.h', "Room Number", $roomNo
            c.set_attribute 'o.h', "Room x Offset", $xRoomOffset
            c.set_attribute 'o.h', "Room y Offset", $yRoomOffset
            c.set_attribute 'o.h', "Room z Offset", $zRoomOffset
            c.set_attribute 'o.h', "Room Name", $roomName
            c.set_attribute 'o.h', "Room Departement", $roomDept
          end
        end
 
        cmp = group.to_component
        cmp.definition.name = "cLabRoom"
        cmp.set_attribute 'o.h', "Room Number", $roomNo
        cmp.set_attribute 'o.h', "Room x Offset", $xRoomOffset
        cmp.set_attribute 'o.h', "Room y Offset", $yRoomOffset
        cmp.set_attribute 'o.h', "Room z Offset", $zRoomOffset
        cmp.set_attribute 'o.h', "Room Name", $roomName
        cmp.set_attribute 'o.h', "Room Departement", $roomDept
        UI.messagebox("Room created")
      end
    end  
  end

  Make_Room = MakeRoom.new
  Sketchup.active_model.select_tool Make_Room
}
cmd.small_icon = "images/room.PNG"
cmd.large_icon = "images/room.PNG"
cmd.tooltip = "Digitales Bauen Toolbars"
cmd.status_bar_text = "Make a room"
cmd.menu_text = "Digitales Bauen"
toolbar = toolbar.add_item cmd
toolbar.show

cmd = UI::Command.new("Digitales Bauen") { 
  class MakeFloor
    def activate
      ss = Sketchup.active_model.selection
      bayez = false
      bawazan = false
      ss.each do |s|
        cmpv = s.get_attribute 'o.h', "Room Number"
        if(cmpv.nil?) || s.typename != "ComponentInstance"
          bawazan = true
        end
      end
      if ss.empty?
        UI.messagebox("Nothing is selected, please select an object first")
        return
      elsif bawazan == true
        UI.messagebox("Not all selected objects are from the View class. Please make sure when creating a room that all objects are Views")
      else
        $floorNo = "001"
        prompts = ["Floor Number"]
        values = [$floorNo]
        results = inputbox prompts, values, "Make Floor"
        return if not results
        $floorNo = results[0]
        group = Sketchup.active_model.active_entities.add_group(ss)
        $xFloorOffset = group.transformation.origin.x
        $yFloorOffset = group.transformation.origin.y
        $zFloorOffset = group.transformation.origin.z
        gg = group.entities
        gg.each do |g|
          x = g.get_attribute 'o.h', "Room x Offset"
          $xRoomOffset = x - $xFloorOffset
          y = g.get_attribute 'o.h', "Room y Offset"
          $yRoomOffset = y - $yFloorOffset
          z = g.get_attribute 'o.h', "Room z Offset"
          $zRoomOffset = z - $zFloorOffset
          g.set_attribute 'o.h', "Room x Offset", $xRoomOffset
          g.set_attribute 'o.h', "Room y Offset", $yRoomOffset
          g.set_attribute 'o.h', "Room z Offset", $zRoomOffset
          g.set_attribute 'o.h', "Floor Number", $floorNo
          g.set_attribute 'o.h', "Floor x Offset", $xFloorOffset
          g.set_attribute 'o.h', "Floor y Offset", $yFloorOffset
          g.set_attribute 'o.h', "Floor z Offset", $zFloorOffset
          g.definition.entities.each do |c|
            c.set_attribute 'o.h', "Room x Offset", $xRoomOffset
            c.set_attribute 'o.h', "Room y Offset", $yRoomOffset
            c.set_attribute 'o.h', "Room z Offset", $zRoomOffset
            c.set_attribute 'o.h', "Floor Number", $floorNo
            c.set_attribute 'o.h', "Floor x Offset", $xFloorOffset
            c.set_attribute 'o.h', "Floor y Offset", $yFloorOffset
            c.set_attribute 'o.h', "Floor z Offset", $zFloorOffset
            c.definition.entities.each do |f|
              f.set_attribute 'o.h', "Room x Offset", $xRoomOffset
              f.set_attribute 'o.h', "Room y Offset", $yRoomOffset
              f.set_attribute 'o.h', "Room z Offset", $zRoomOffset
              f.set_attribute 'o.h', "Floor Number", $floorNo
              f.set_attribute 'o.h', "Floor x Offset", $xFloorOffset
              f.set_attribute 'o.h', "Floor y Offset", $yFloorOffset
              f.set_attribute 'o.h', "Floor z Offset", $zFloorOffset
            end
          end
        end
 
        cmp = group.to_component
        cmp.definition.name = "cLabFloor"
        cmp.set_attribute 'o.h', "Floor Number", $floorNo
        cmp.set_attribute 'o.h', "Floor x Offset", $xFloorOffset
        cmp.set_attribute 'o.h', "Floor y Offset", $yFloorOffset
        cmp.set_attribute 'o.h', "Floor z Offset", $zFloorOffset
        UI.messagebox("Floor created")
      end
    end  
  end

  Make_Floor = MakeFloor.new
  Sketchup.active_model.select_tool Make_Floor
}
cmd.small_icon = "images/floor.PNG"
cmd.large_icon = "images/floor.PNG"
cmd.tooltip = "Digitales Bauen Toolbars"
cmd.status_bar_text = "Make a floor"
cmd.menu_text = "Digitales Bauen"
toolbar = toolbar.add_item cmd
toolbar.show

cmd = UI::Command.new("Digitales Bauen") { 
  class MakeBuilding
    def activate
      ss = Sketchup.active_model.selection
      bayez = false
      bawazan = false
      ss.each do |s|
        cmpv = s.get_attribute 'o.h', "Floor Number"
        if(cmpv.nil?) || s.typename != "ComponentInstance"
          bawazan = true
        end
      end
      if ss.empty?
        UI.messagebox("Nothing is selected, please select an object first")
        return
      elsif bawazan == true
        UI.messagebox("Not all selected objects are from the View class. Please make sure when creating a room that all objects are Views")
      else
        $bldName = ""
        prompts = ["Building Name"]
        values = [$bldName]
        results = inputbox prompts, values, "Make Building"
        return if not results
        $bldName = results[0]
        group = Sketchup.active_model.active_entities.add_group(ss)
        $xBldLocation = group.transformation.origin.x
        $yBldLocation = group.transformation.origin.y
        $zBldLocation = group.transformation.origin.z
        gg = group.entities
        gg.each do |g|
          x = g.get_attribute 'o.h', "Floor x Offset"
          $xFloorOffset = x - $xBldLocation
          y = g.get_attribute 'o.h', "Floor y Offset"
          $yFloorOffset = y - $yBldLocation
          z = g.get_attribute 'o.h', "Floor z Offset"
          $zFloorOffset = z - $zBldLocation
          g.set_attribute 'o.h', "Floor x Offset", $xFloorOffset
          g.set_attribute 'o.h', "Floor y Offset", $yFloorOffset
          g.set_attribute 'o.h', "Floor z Offset", $zFloorOffset
          g.set_attribute 'o.h', "Building Name", $bldName
          g.set_attribute 'o.h', "Building x Location", $xBldLocation
          g.set_attribute 'o.h', "Building y Location", $yBldLocation
          g.set_attribute 'o.h', "Building z Location", $zBldLocation
          g.definition.entities.each do |c|
            c.set_attribute 'o.h', "Floor x Offset", $xFloorOffset
            c.set_attribute 'o.h', "Floor y Offset", $yFloorOffset
            c.set_attribute 'o.h', "Floor z Offset", $zFloorOffset
            c.set_attribute 'o.h', "Building Name", $bldName
            c.set_attribute 'o.h', "Building x Location", $xBldLocation
            c.set_attribute 'o.h', "Building y Location", $yBldLocation
            c.set_attribute 'o.h', "Building z Location", $zBldLocation
            c.definition.entities.each do |f|
              f.set_attribute 'o.h', "Floor x Offset", $xFloorOffset
              f.set_attribute 'o.h', "Floor y Offset", $yFloorOffset
              f.set_attribute 'o.h', "Floor z Offset", $zFloorOffset
              f.set_attribute 'o.h', "Building Name", $bldName
              f.set_attribute 'o.h', "Building x Location", $xBldLocation
              f.set_attribute 'o.h', "Building y Location", $yBldLocation
              f.set_attribute 'o.h', "Building z Location", $zBldLocation
              f.definition.entities.each do |b|
                b.set_attribute 'o.h', "Floor x Offset", $xFloorOffset
                b.set_attribute 'o.h', "Floor y Offset", $yFloorOffset
                b.set_attribute 'o.h', "Floor z Offset", $zFloorOffset
                b.set_attribute 'o.h', "Building Name", $bldName
                b.set_attribute 'o.h', "Building x Location", $xBldLocation
                b.set_attribute 'o.h', "Building y Location", $yBldLocation
                b.set_attribute 'o.h', "Building z Location", $zBldLocation
              end
            end
          end
        end

        cmp = group.to_component
        cmp.definition.name = "cLabBld"
        cmp.set_attribute 'o.h', "Building Name", $bldName
        cmp.set_attribute 'o.h', "Building x Location", $xBldLocation
        cmp.set_attribute 'o.h', "Building y Location", $yBldLocation
        cmp.set_attribute 'o.h', "Building z Location", $zBldLocation
        UI.messagebox("Building created")
      end
    end  
  end

  Make_Building = MakeBuilding.new
  Sketchup.active_model.select_tool Make_Building
}
cmd.small_icon = "images/build.PNG"
cmd.large_icon = "images/build.PNG"
cmd.tooltip = "Digitales Bauen Toolbars"
cmd.status_bar_text = "Make a building"
cmd.menu_text = "Digitales Bauen"
toolbar = toolbar.add_item cmd
toolbar.show