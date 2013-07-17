# See the loader file for license and author info

require 'sketchup.rb'
module CLF_Extensions_NS

  module CLF_OnScreen_Display

    class OnScreen_Display_Tool

    # The activate method is called when a tool is first activated.  It is not
    # required, but it is a good place to initialize stuff.
    def activate
      @ip = Sketchup::InputPoint.new
      @iptemp = Sketchup::InputPoint.new
      @displayed = false
      @notecomp = 0
      @notegroup = 0
      @notedimloc = 0
      @notepos = 0
    end

    # onMouseMove is called whenever SketchUp gets a mouse move event.  It is called
    # a lot, so you should try to make it as efficient as possible.
    def onMouseMove(flags, x, y, view)
        # show the screen position in the VCB
        Sketchup::set_status_text("#{x}, #{y}", SB_VCB_VALUE)

        # get a position in the model and show it in a tooltip
        @iptemp.pick view, x, y
        if( @iptemp.valid? )
            changed = @iptemp != @ip
            @ip.copy! @iptemp
            pos = @ip.position
            
            # get the text for the position
            msg = @ip.tooltip
            if( msg.length > 0 )
                msg << " "
            end
            #msg << pos.to_s
            msg << "( #{Sketchup.format_length(pos.x)},#{Sketchup.format_length(pos.y)},#{Sketchup.format_length(pos.z)} ),"

            # See if it is on any special geometry
            if( @ip.vertex == nil )
                if( @ip.edge )
                    if( @ip.depth > 0 )
                        length = @ip.edge.length(@ip.transformation)
                    else
                        length = @ip.edge.length
                    end
                    msg <<  "\n       " + $uStrings.GetString("length") + " = #{Sketchup.format_length(length)}"
                elsif( @ip.face )
                    if( @ip.depth > 0 )
                        area = @ip.face.area(@ip.transformation)
                    else
                        area = @ip.face.area
                    end
                    msg << "\n       " + $uStrings.GetString("area") + " = #{Sketchup.format_area(area)}"
                end
            end
        
            msg2 = msg.gsub(/\n/,' ')
            Sketchup::set_status_text msg2
            
            # set the tooltip to show this message
            view.tooltip = msg
            
            # see if we need to update the display for this point
            if( changed and (@ip.display? or @displayed) )
                # This tells the view that we want it to update itself
                view.invalidate
            end
        end
        
    end

    # onLButtonDown is called when the user presses the left mouse button
    def onLButtonDown(flags, x, y, view)
      model = Sketchup.active_model
      pos = @ip.position
      view = model.active_view
      point3d = view.screen_coords pos
      pickhelper = view.pick_helper 
      picked = pickhelper.do_pick point3d.x, point3d.y
      picked_ent = pickhelper.best_picked
      if picked_ent.class.to_s == "NilClass"
        picked_ent_string = 'No Entity Selected'
      else
        if picked_ent.typename == ( "ComponentInstance" )
          picked_ent_string = 'Instance name is "' + picked_ent.name.to_s + '" and Definition name is "' + picked_ent.definition.name.to_s + '"'
        else
          picked_ent_string = picked_ent.typename.to_s
        end
      end
      mydimloc = 'Cursor Position = (' + Sketchup.format_length(pos.x).to_s + ',' + Sketchup.format_length(pos.y).to_s + ',' + Sketchup.format_length(pos.z).to_s + ')'
      mypos = 'Screen Coordinates = ' + point3d.to_s
      @notecomp = model.add_note picked_ent_string, 0.01, 0.04
      @notedimloc = model.add_note mydimloc.to_s, 0.01, 0.07
      @notepos = model.add_note mypos.to_s, 0.01, 0.1
        Sketchup::set_status_text $uStrings.GetString("Left button down at") + " (#{x}, #{y})"
    end

    # onLButtonUp is called when the user releases the left mouse button
    def onLButtonUp(flags, x, y, view)
      #model = Sketchup.active_model
      if @notecomp != 0
        if @notecomp.valid?
          @notecomp.erase!
        end
      end
      @notedimloc.erase!
      @notepos.erase!
        Sketchup::set_status_text $uStrings.GetString("Left button up at") + " (#{x}, #{y})"
    end

    # draw is optional.  It is called on the active tool whenever SketchUp
    # needs to update the screen.
    # in this case, we display an input point if needed
    def draw(view)
        if( @ip.valid? && @ip.display? )
            @ip.draw view
            @displayed = true
        else
            @displayed = false
        end
    end
   end
  end
end