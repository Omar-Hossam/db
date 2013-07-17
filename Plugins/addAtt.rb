require 'sketchup.rb'

$LabelementWorkdist = 0.00 if not $LabelementWorkdist
$LabelementWalkdist = 0.00 if not $LabelementWalkdist
$Width = 0.00 if not $Width
$Depth = 0.00 if not $Depth
$Height = 0.00 if not $Height
$Containmentmaterial = "" if not $Containmentmaterial
$Deskfront = "" if not $Deskfront
$Benchfront = "" if not $Benchfront
$Sinkmaterial = "" if not $Sinkmaterial
$Extractiontype = "" if not $Extractiontype
$Gastaptype = "" if not $Gastaptype
$Drainagetype = "" if not $Drainagetype
$Liquidtaptype = "" if not $Liquidtaptype
$HVtype = "" if not $HVtype
$LVtype = "" if not $LVtype
$Comtype = "" if not $Comtype

def self.add_attributes
  ss = Sketchup.active_model.selection
  return if ss.empty?

  $LabelementWorkdist = ss[0].get_attribute 'dboh', "LabelementWorkdist", 0.00
  $LabelementWalkdist = ss[0].get_attribute 'dboh', "LabelementWalkdist", 0.00
  $Width = ss[0].get_attribute 'dboh', "Width", 0.00
  $Depth = ss[0].get_attribute 'dboh', "Depth", 0.00
  $Height = ss[0].get_attribute 'dboh', "Height", 0.00
  $Containmentmaterial = ss[0].get_attribute 'dboh', "Containmentmaterial", ""
  $Deskfront = ss[0].get_attribute 'dboh', "Deskfront", ""
  $Benchfront = ss[0].get_attribute 'dboh', "Benchfront", ""
  $Sinkmaterial = ss[0].get_attribute 'dboh', "Sinkmaterial", ""
  $Extractiontype = ss[0].get_attribute 'dboh', "Extractiontype", ""
  $Gastaptype = ss[0].get_attribute 'dboh', "Gastaptype", ""
  $Drainagetype = ss[0].get_attribute 'dboh', "Drainagetype", ""
  $Liquidtaptype = ss[0].get_attribute 'dboh', "Liquidtaptype", ""
  $HVtype = ss[0].get_attribute 'dboh', "HVtype", ""
  $LVtype = ss[0].get_attribute 'dboh', "LVtype", ""
  $Comtype = ss[0].get_attribute 'dboh', "Comtype", ""

  prompts = ["LabelementWorkdist", "LabelementWalkdist",
    "Width", "Depth", "Height", "Containmentmaterial", "Deskfront", "Benchfront",
    "Sinkmaterial", "Extractiontype", "Gastaptype", "Drainagetype",
    "Liquidtaptype", "HVtype", "LVtype", "Comtype"]
  values = [$LabelementWorkdist, $LabelementWalkdist, $Width,
    $Depth, $Height, $Containmentmaterial, $Deskfront, $Benchfront, $Sinkmaterial,
    $Extractiontype, $Gastaptype, $Drainagetype, $Liquidtaptype, $HVtype, $LVtype,
    $Comtype]
  results = inputbox prompts, values, "Add Attributes"
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

  ss.each do |e|
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

    f = e.transformation.origin
    $XPos = f.x
    $YPos = f.y
    $ZPos = f.z
    e.set_attribute 'dboh', "XPos", $XPos
    e.set_attribute 'dboh', "YPos", $YPos
    e.set_attribute 'dboh', "ZPos", $ZPos
  end
  UI.messagebox("Attributes added")
end

if( not file_loaded?("su_examples/addAtt.rb") )
  plugs_menu = UI.menu("Plugins")
  plugs_menu.add_item("Add attributes") { add_attributes }
end
file_loaded("su_examples/addAtt.rb")