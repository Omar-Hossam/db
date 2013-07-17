# See the loader file for license and author info

module CLF_Extensions_NS
	module CLF_OnScreen_Display
    require 'sketchup.rb'
    require NAME+'/'+NAME+'_data.rb'
  end

  if !file_loaded?('clf_menu2_loader')
    @@clf_tools_menu = UI.menu("Plugins").add_submenu("Chris Fullmer Tools")
  end
    
	#------New menu Items---------------------------
	if !file_loaded?('clf_ew_loader')
		@@clf_ew_menu = @@clf_tools_menu.add_submenu("-=Extension Warehouse=-")
		@@clf_ew_menu.add_item("My Extension Warehouse Store"){UI.openURL "http://extensions.sketchup.com/user/46/store"}
    @@clf_tools_menu.add_separator
    @@clf_ew_menu.add_separator
	end
    @@clf_ew_menu.add_item(CLF_OnScreen_Display::MENU_NAME+" Page"){UI.openURL "http://extensions.sketchup.com/content/clf-onscreen-display"}
	#------------------------------------------------
    
  if !file_loaded?(__FILE__)
    @@clf_tools_menu.add_item(CLF_OnScreen_Display::MENU_NAME) { Sketchup.active_model.select_tool CLF_OnScreen_Display::OnScreen_Display_Tool.new }
  end

  file_loaded('clf_ew_loader')    
  file_loaded('clf_menu2_loader')
  file_loaded(__FILE__)
end