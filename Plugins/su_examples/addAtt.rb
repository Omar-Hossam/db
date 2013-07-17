require 'sketchup.rb'

module Sketchup::Examples

$atr_val = 1.00 if not $atr_val
$atr_name = "" if not $atr_name

# This method prompts for a cost estimate and attaches it to all selected faces
def self.zoz

    # See if there is anything selected
    ss = Sketchup.active_model.selection
    return if ss.empty?
    
    # First prompt the user for the cost per sq foot
    prompts = [$exStrings.GetString("Attribute Name"), $exStrings.GetString("Value")]
    values = [$atr_name, $atr_val]
    results = inputbox prompts, values, $exStrings.GetString("Add Attribute")
    return if not results
    
    # Now attach this as an attribute to all selected Faces
    $atr_val = results[1]
    $atr_name = results[0]
    ss.each do |e|
            e.set_attribute 'skpex', $atr_name, $atr_val
    end

end


# Add some menu items to access this
if( not file_loaded?("addAtt.rb") )
    #Note: We don't translate the Menu names - the Ruby API assumes you are 
    #using English names for Menus.
    plugins_menu = UI.menu("Plugins")
    cost_menu = plugins_menu.add_submenu($exStrings.GetString("attr"))
    cost_menu.add_item($exStrings.GetString("Add attr")) { zoz }
end

#-----------------------------------------------------------------------------
file_loaded("addAtt.rb")

end # module Sketchup::Examples