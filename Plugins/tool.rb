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