# UI.messagebox('Welcome to Digitales Bauen Architechture tool!')
Sketchup.send_action "showRubyPanel:"
cam = Sketchup.active_model.active_view.camera
Sketchup.send_action("viewTop:")
cam.perspective = false
toolbar = UI::Toolbar.new "Digitales Bauen"
cmd = UI::Command.new("Digitales Bauen") { 
  class DBTool
    def activate
      puts "Your tool has been activated."
    end

    def get_words(name)
      spn = name.split('')
      if spn[4] == 'F'
        if spn[5] == 'n'
          index = 4
        elsif spn[5] == 'l'
          index = 1
        end
      elsif spn[4] == 'V'
        index = 3
      elsif spn[4] == 'R'
        index = 2
      elsif spn[4] == 'B'
        index = 0
      end
      return index
    end

    def getMenu(menu)
      menu.add_item("Edit attributes") {
        s = Sketchup.active_model.selection
        ss = s.first
        if s.empty?
          UI.messagebox("Nothing is selected, please select an object first")
          return
        elsif s[1] != nil
          UI.messagebox("More than one instance is selected. Please select only one instance")
          return
        elsif ss.typename != "ComponentInstance"
          UI.messagebox("This is not a component. Entities should be grouped in components to have attributes")
          return
        else
          at = ss.attribute_dictionary "o.h"
          if at.nil?
            UI.messagebox("Sorry, no attributes added yet")
          else
            at = ss.attribute_dictionary "o.h"
            ks = at.keys
            vals = []
            ks.each do |k|
              vals << (ss.get_attribute "o.h", k)
            end
            prompts = ks
            values = vals
            results = inputbox prompts, values, "Edit 2"
            return if not results
            index = 0
            name = ss.definition.name
            cats = [["Building x Location", "Building y Location",
              "Building z Location"], ["Floor x Offset", "Floor y Offset",
              "Floor z Offset"], ["Room x Offset", "Room y Offset",
              "Floor z Offset"], ["View x Offset", "View y Offset",
              "Floor z Offset"], ["Component x Offset", "Component y Offset",
              "Component z Offset"]]
            ind = get_words(name)
            cat = cats[ind]
            xpos = 0
            ypos = 0
            zpos = 0
            xold = 0
            yold = 0
            zold = 0
            ks.each do |k|
              if k == cat[0]
                xpos = results[index]
                xold = ss.get_attribute "o.h", k
              elsif k == cat[1]
                ypos = results[index]
                yold = ss.get_attribute "o.h", k
              elsif k == cat[2]
                zpos = results[index]
                zold = ss.get_attribute "o.h", k
              end
              ss.set_attribute 'o.h', k, results[index]
              index = index + 1
            end
            xdif = 0.0
            ydif = 0.0
            zdif = 0.0
            xdif = xpos - xold
            ydif = ypos - yold
            zdif = zpos - zold
            if ind == 0
              cat2 = cats[1]
              ss.definition.entities.each do |f|
                xx = (f.get_attribute 'o.h', cat2[0]) - xdif
                yx = (f.get_attribute 'o.h', cat2[1]) - ydif
                zx = (f.get_attribute 'o.h', cat2[2]) - zdif
                f.set_attribute 'o.h', cat[0], xpos
                f.set_attribute 'o.h', cat[1], ypos
                f.set_attribute 'o.h', cat[2], zpos
                f.set_attribute 'o.h', cat2[0], xx
                f.set_attribute 'o.h', cat2[1], yx
                f.set_attribute 'o.h', cat2[2], zx
                f.definition.entities.each do |r|
                  r.set_attribute 'o.h', cat[0], xpos
                  r.set_attribute 'o.h', cat[1], ypos
                  r.set_attribute 'o.h', cat[2], zpos
                  r.set_attribute 'o.h', cat2[0], xx
                  r.set_attribute 'o.h', cat2[1], yx
                  r.set_attribute 'o.h', cat2[2], zx
                  r.definition.entities.each do |v|
                    v.set_attribute 'o.h', cat[0], xpos
                    v.set_attribute 'o.h', cat[1], ypos
                    v.set_attribute 'o.h', cat[2], zpos
                    v.set_attribute 'o.h', cat2[0], xx
                    v.set_attribute 'o.h', cat2[1], yx
                    v.set_attribute 'o.h', cat2[2], zx
                    v.definition.entities.each do |c|
                      c.set_attribute 'o.h', cat[0], xpos
                      c.set_attribute 'o.h', cat[1], ypos
                      c.set_attribute 'o.h', cat[2], zpos
                      c.set_attribute 'o.h', cat2[0], xx
                      c.set_attribute 'o.h', cat2[1], yx
                      c.set_attribute 'o.h', cat2[2], zx
                    end
                  end
                end
              end  
            elsif ind == 1
              cat2 = cats[2]
              cat3 = cats[4]
              ss.definition.entities.each do |r|
                xx = (r.get_attribute 'o.h', cat2[0]) - xdif
                yx = (r.get_attribute 'o.h', cat2[1]) - ydif
                r.set_attribute 'o.h', cat[0], xpos
                r.set_attribute 'o.h', cat[1], ypos
                r.set_attribute 'o.h', cat[2], zpos
                r.set_attribute 'o.h', cat2[0], xx
                r.set_attribute 'o.h', cat2[1], yx
                r.definition.entities.each do |v|
                  v.set_attribute 'o.h', cat[0], xpos
                  v.set_attribute 'o.h', cat[1], ypos
                  v.set_attribute 'o.h', cat[2], zpos
                  v.set_attribute 'o.h', cat2[0], xx
                  v.set_attribute 'o.h', cat2[1], yx
                  v.definition.entities.each do |c|
                    zx = (c.get_attribute 'o.h', cat3[2]) - zdif
                    c.set_attribute 'o.h', cat[0], xpos
                    c.set_attribute 'o.h', cat[1], ypos
                    c.set_attribute 'o.h', cat[2], zpos
                    c.set_attribute 'o.h', cat2[0], xx
                    c.set_attribute 'o.h', cat2[1], yx
                    c.set_attribute 'o.h', cat3[2], zx
                  end
                end
              end
            elsif ind == 2
              cat2 = cats[3]
              ss.definition.entities.each do |v|
                xx = (v.get_attribute 'o.h', cat2[0]) - xdif
                yx = (v.get_attribute 'o.h', cat2[1]) - ydif
                v.set_attribute 'o.h', cat[0], xpos
                v.set_attribute 'o.h', cat[1], ypos
                v.set_attribute 'o.h', cat2[0], xx
                v.set_attribute 'o.h', cat2[1], yx
                v.definition.entities.each do |c|
                  c.set_attribute 'o.h', cat[0], xpos
                  c.set_attribute 'o.h', cat[1], ypos
                  c.set_attribute 'o.h', cat2[0], xx
                  c.set_attribute 'o.h', cat2[1], yx
                end
              end
            elsif ind == 3
              cat2 = cats[4]
              ss.definition.entities.each do |c|
                xx = (c.get_attribute 'o.h', cat2[0]) - xdif
                yx = (c.get_attribute 'o.h', cat2[1]) - ydif
                c.set_attribute 'o.h', cat[0], xpos
                c.set_attribute 'o.h', cat[1], ypos
                c.set_attribute 'o.h', cat2[0], xx
                c.set_attribute 'o.h', cat2[1], yx
              end
            end
            pt = Geom::Point3d.new(xpos,ypos,zpos)
            t = Geom::Transformation.new(pt)
            ss.transformation= t
            UI.messagebox("Attributes edits applied")
          end
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
      if model.empty?
        UI.messagebox("Nothing is selected, please select an object first")
        return
      elsif model[1] != nil
        UI.messagebox("More than one instance is selected. Please select only one instance")
        return
      elsif model.first.typename != "ComponentInstance"
        UI.messagebox("This is not a component. Entities should be grouped in components to have attributes")
        return
      else
        m = model[0]
        at = m.attribute_dictionary "o.h"
        if at == nil
          UI.messagebox("Sorry, no attributes added yet")
        else
          ks = at.keys
          message = ""
          ks.each do |k|
            val = m.get_attribute "o.h", k
            message += k.to_s + ": " + val.to_s + "\n"
          end
          UI.messagebox(message)
        end
      end
    end
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
    vnos = []
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
        $xViewOffset = group.transformation.origin.x.to_f
        $yViewOffset = group.transformation.origin.y.to_f
        gg = group.entities
        gg.each do |g|
          x = g.get_attribute 'o.h', "Component x Offset"
          $xCmpOffset = x - $xViewOffset
          y = g.get_attribute 'o.h', "Component y Offset"
          $yCmpOffset = y - $yViewOffset
          g.set_attribute 'o.h', "Component x Offset", $xCmpOffset
          g.set_attribute 'o.h', "Component y Offset", $yCmpOffset
          g.set_attribute 'o.h', "View Number", $value
          g.set_attribute 'o.h', "View x Offset", $xViewOffset
          g.set_attribute 'o.h', "View y Offset", $yViewOffset
          g.set_attribute 'o.h', "Depth Offset", $depthOffset
          g.set_attribute 'o.h', "Height Offset", $heightOffset
        end
 
        cmp = group.to_component
        cmp.definition.name = "cLabView"
        cmp.set_attribute 'o.h', "View Number", $value
        cmp.set_attribute 'o.h', "View x Offset", $xViewOffset
        cmp.set_attribute 'o.h', "View y Offset", $yViewOffset
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
        $xRoomOffset = group.transformation.origin.x.to_f
        $yRoomOffset = group.transformation.origin.y.to_f
        gg = group.entities
        gg.each do |g|
          x = g.get_attribute 'o.h', "View x Offset"
          $xViewOffset = x - $xRoomOffset
          y = g.get_attribute 'o.h', "View y Offset"
          $yViewOffset = y - $yRoomOffset
          g.set_attribute 'o.h', "View x Offset", $xViewOffset
          g.set_attribute 'o.h', "View y Offset", $yViewOffset
          g.set_attribute 'o.h', "Room Number", $roomNo
          g.set_attribute 'o.h', "Room x Offset", $xRoomOffset
          g.set_attribute 'o.h', "Room y Offset", $yRoomOffset
          g.set_attribute 'o.h', "Room Name", $roomName
          g.set_attribute 'o.h', "Room Departement", $roomDept
          g.definition.entities.each do |c|
            c.set_attribute 'o.h', "View x Offset", $xViewOffset
            c.set_attribute 'o.h', "View y Offset", $yViewOffset
            c.set_attribute 'o.h', "Room Number", $roomNo
            c.set_attribute 'o.h', "Room x Offset", $xRoomOffset
            c.set_attribute 'o.h', "Room y Offset", $yRoomOffset
            c.set_attribute 'o.h', "Room Name", $roomName
            c.set_attribute 'o.h', "Room Departement", $roomDept
          end
        end
 
        cmp = group.to_component
        cmp.definition.name = "cLabRoom"
        cmp.set_attribute 'o.h', "Room Number", $roomNo
        cmp.set_attribute 'o.h', "Room x Offset", $xRoomOffset
        cmp.set_attribute 'o.h', "Room y Offset", $yRoomOffset
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
        $floorNo = "000"
        prompts = ["Floor Number"]
        values = [$floorNo]
        results = inputbox prompts, values, "Make Floor"
        return if not results
        $floorNo = results[0]
        group = Sketchup.active_model.active_entities.add_group(ss)
        $xFloorOffset = group.transformation.origin.x.to_f
        $yFloorOffset = group.transformation.origin.y.to_f
        $zFloorOffset = group.transformation.origin.z.to_f
        gg = group.entities
        gg.each do |g|
          x = g.get_attribute 'o.h', "Room x Offset"
          $xRoomOffset = x - $xFloorOffset
          y = g.get_attribute 'o.h', "Room y Offset"
          $yRoomOffset = y - $yFloorOffset
          g.set_attribute 'o.h', "Room x Offset", $xRoomOffset
          g.set_attribute 'o.h', "Room y Offset", $yRoomOffset
          g.set_attribute 'o.h', "Floor Number", $floorNo
          g.set_attribute 'o.h', "Floor x Offset", $xFloorOffset
          g.set_attribute 'o.h', "Floor y Offset", $yFloorOffset
          g.set_attribute 'o.h', "Floor z Offset", $zFloorOffset
          g.definition.entities.each do |c|
            c.set_attribute 'o.h', "Room x Offset", $xRoomOffset
            c.set_attribute 'o.h', "Room y Offset", $yRoomOffset
            c.set_attribute 'o.h', "Floor Number", $floorNo
            c.set_attribute 'o.h', "Floor x Offset", $xFloorOffset
            c.set_attribute 'o.h', "Floor y Offset", $yFloorOffset
            c.set_attribute 'o.h', "Floor z Offset", $zFloorOffset
            c.definition.entities.each do |f|
              z = f.get_attribute 'o.h', "Component z Offset"
              $zCmpOffset = z - $zFloorOffset
              f.set_attribute 'o.h', "Component z Offset", $zCmpOffset
              f.set_attribute 'o.h', "Room x Offset", $xRoomOffset
              f.set_attribute 'o.h', "Room y Offset", $yRoomOffset
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
        while true
          prompts = ["Building Name"]
          values = [$bldName]
          results = inputbox prompts, values, "Make Building"
          return if not results
          $bldName = results[0]
          if $bldName.empty?
            UI.messagebox("Building Name can't be blank")
          else
            break
          end
        end
        group = Sketchup.active_model.active_entities.add_group(ss)
        $xBldLocation = group.transformation.origin.x.to_f
        $yBldLocation = group.transformation.origin.y.to_f
        $zBldLocation = group.transformation.origin.z.to_f
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