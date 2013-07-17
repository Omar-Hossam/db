# require 'sketchup'
# pages = Sketchup.active_model.pages
# if pages.count < 4
#   Sketchup.send_action("viewRight:")
#   UI.messagebox("Welcome to our special architecture tool!")
#   pages.add "Right"
#   Sketchup.send_action("viewFront:")
#   UI.messagebox("We are modifying our cameras")
#   pages.add "Front"
#   Sketchup.send_action("viewIso:")
#   UI.messagebox("To update the scenes later, please go to plugins -> Update scenes")
#   pages.add "Iso"
#   Sketchup.send_action("viewTop:")
#   UI.messagebox("Enjoy!")
#   pages.add "Top"
#   pages.selected_page.camera.perspective = false
# end

# UI.menu("PlugIns").add_item("Update scenes") {
# 	update_scenes
# }
# UI.menu("PlugIns").add_item("Add Missing Scenes") {
#   add_miss_scene
# }

# def update_scenes
#   pages = Sketchup.active_model.pages
#   selection = Sketchup.active_model.selection
#   view = Sketchup.active_model.active_view
#   if selection.length == 0
#     pages.each do |p|
#       if p.name == "Right"
#         Sketchup.send_action("viewRight:")
#         UI.messagebox("We will now update the cameras")
#         p.update(1) 
#       elsif p.name == "Front"
#         Sketchup.send_action("viewFront:")
#         UI.messagebox("It won't take time, just be patient")
#         p.update(1)
#       elsif p.name == "Iso"
#         Sketchup.send_action("viewIso:")
#         UI.messagebox("Just do the same whenever you need to update your scenes again")
#         p.update(1)
#       elsif p.name == "Top"
#         Sketchup.send_action("viewTop:")
#         UI.messagebox("You may now complete working")
#         p.update(1)
#         pages.selected_page.camera.perspective = false
#       else
#         UI.messagebox("Sorry, there are no scenes created by the program to update. Go to the plugins menu and choose 'add missing scenes'")
#       end
#     end
#   else
#     pages.each do |p|
#       if p.name == "Right"
#         Sketchup.send_action("viewRight:")
#         view = view.zoom selection
#         UI.messagebox("We will now update the cameras")
#         p.update(1) 
#       elsif p.name == "Front"
#         Sketchup.send_action("viewFront:")
#         UI.messagebox("It won't take time, just be patient")
#         p.update(1)
#       elsif p.name == "Iso"
#         Sketchup.send_action("viewIso:")
#         view = view.zoom selection
#         UI.messagebox("Just do the same whenever you need to update your scenes again")
#         p.update(1)
#       elsif p.name == "Top"
#         Sketchup.send_action("viewTop:")
#         view = view.zoom selection
#         UI.messagebox("You may now complete working")
#         p.update(1)
#         pages.selected_page.camera.perspective = false
#       else
#         UI.messagebox("Sorry, there are no scenes created by the program to update. Go to the plugins menu and choose 'add missing scenes'" )
#       end
#     end
#   end
# end

# def add_miss_scene
#   pages = Sketchup.active_model.pages
#   r = false
#   f = false
#   i = false
#   t = false
#   pages.each do |p|
#     if p.name == "Right"
#       r = true
#     elsif p.name == "Front"
#       f = true
#     elsif p.name == "Iso"
#       i = true
#     elsif p.name == "Top"
#       t = true
#     end
#   end
#   if r == false
#     Sketchup.send_action("viewRight:")
#     UI.messagebox("Right view missing and scene being added")
#     pages.add "Right"
#   end
#   if f == false
#     Sketchup.send_action("viewFront:")
#     UI.messagebox("Front view missing and scene being added")
#     pages.add "Front"
#   end
#   if i == false
#     Sketchup.send_action("viewIso:")
#     UI.messagebox("Iso view missing and scene being added")
#     pages.add "Iso"
#   end
#   if t == false
#     Sketchup.send_action("viewTop:")
#     UI.messagebox("Top view missing and scene being added")
#     pages.add "Top"
#     pages.selected_page.camera.perspective = false
#   end
# end