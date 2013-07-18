require 'sketchup.rb'

def self.add_attributes
  ss = Sketchup.active_model.selection
  if ss.empty?
    UI.messagebox("Nothing is selected, please select an object first")
    return
  elsif ss.first.typename != "ComponentInstance"
    UI.messagebox("These elements are not grouped. please group into a component first")
    return
  elsif ss[1] != nil
    UI.messagebox("More than one instance are selected. Please select only one instance")
    return
  else
    cmp_class, cmp_type = get_type(ss.first.definition.name)
    if cmp_class == nil || cmp_type == nil
      UI.messagebox("Component name not clear")
      return
    elsif cmp_class == "buliding"
      set_bld_att(ss.first)
    elsif cmp_class == "floor"
      set_flr_att(ss.first)
    elsif cmp_class == "room"
      set_rom_att(ss.first)
    elsif cmp_class == "view"
      set_viw_att(ss.first)
    elsif cmp_class == "component"
      set_cmp_att(ss.first, cmp_type)
    else
      return
    end
  end
end

def get_type(name)
  spn = name.split('')
  cmp_type = ""
  if spn[3] == 'F'
    if spn[4] == 'n'
      cmp_class = "component"
      if spn[6] == 'F'
        cmp_type = "Fume Cupboard"
      elsif spn[6] == 'B'
        cmp_type = "Benchtop"
      elsif spn[6] == 'T'
        cmp_type = "Table"
      elsif spn[6] == 'M'
        cmp_type = "Miscellaenous"
      elsif spn[6] = 'S'
        if spn[7] == 'v'
          cmp_type = "Service System"
        elsif spn[7] == 'u'
          cmp_type = "Benchtop Support System"
        elsif spn[7] == 't'
          cmp_type = "Storage"
        elsif spn[7] == 'i'
          cmp_type = "Sinkmodule"
        end
      end
    elsif spn[4] == 'l'
      cmp_class = "floor"
    end
  elsif spn[3] == 'M'
    cmp_class = "component"
    cmp_type = "Media"
  elsif spn[3] == 'E'
    cmp_class = "component"
    cmp_type = "Equipment"
  elsif spn[3] = 'B'
    cmp_class = "building"
  elsif spn[3] = 'R'
    cmp_class = "room"
  elsif spn[3] = 'V'
    cmp_class = "view"
  else
    cmp_class = nil
    cmp_type = nil
  end
  return cmp_class,  cmp_type
end

def set_cmp_att(cmp, type)
  $cmpWorkdist = cmp.get_attribute 'o.h', "cmpWorkdist"
  $cmpWalkdist = cmp.get_attribute 'o.h', "cmpWalkdist"
  $cmpPrice = cmp.get_attribute 'o.h', "cmpPrice", 0.00
  $cmpSuppl = cmp.get_attribute 'o.h', "cmpSuppl", "genuine"
  $cmpSupplID = cmp.get_attribute 'o.h', "cmpSupplID", ""
  $cmpSupplPrice = cmp.get_attribute 'o.h', "cmpSupplPrice", ""
  if type == "Fume Cupboard"
    materials = ["unspecified", "PP", "PVDF", "1.4301(V2A)"]

    prompts = ["fntFcContainmentMaterial", "cmpWorkdist", "cmpWalkdist",
      "cmpPrice", "cmpSuppl", "cmpSupplID", "cmpSupplPrice"]
    values = [materials[0], $cmpWorkdist, $cmpWalkdist, $cmpPrice,
      $cmpSuppl, $cmpSupplID, $cmpSupplPrice]
    enums = [materials.join("|")]
    results = inputbox prompts, values, enums, "Add Attributes"
    return if not results
    $cmpWorkdist = results[1]
    $cmpWalkdist = results[2]
    $cmpPrice = results[3]
    $cmpSuppl = results[4]
    $cmpSupplID = results[5]
    $cmpSupplPrice = results[6]
  else
    prompts = ["cmpWorkdist", "cmpWalkdist",
      "cmpPrice", "cmpSuppl", "cmpSupplID", "cmpSupplPrice"]
    values = [$cmpWorkdist, $cmpWalkdist, $cmpPrice,
      $cmpSuppl, $cmpSupplID, $cmpSupplPrice]
    results = inputbox prompts, values, "Add Attributes"
    return if not results
    $cmpWorkdist = results[0]
    $cmpWalkdist = results[1]
    $cmpPrice = results[2]
    $cmpSuppl = results[3]
    $cmpSupplID = results[4]
    $cmpSupplPrice = results[5]

  end
  cmp.set_attribute 'o.h', "cmpWorkdist", $cmpWorkdist
  cmp.set_attribute 'o.h', "cmpWalkdist", $cmpWalkdist
  cmp.set_attribute 'o.h', "cmpPrice", $cmpPrice
  cmp.set_attribute 'o.h', "cmpSuppl", $cmpSuppl
  cmp.set_attribute 'o.h', "cmpSupplID", $cmpSupplID
  cmp.set_attribute 'o.h', "cmpSupplPrice", $cmpSupplPrice

  if type == "Media"
    $cmpClass = "Media"
  elsif type == "Equipment"
    $cmpClass = "Equipment"
  else
    $cmpClass = "Furniture"
  end
  cmp.set_attribute 'o.h', "cmpClass", $cmpClass

  f = cmp.transformation.origin
  check = cmp.get_attribute 'o.h', "viewNo"
  if check == nil
    $xCmpOffset = f.x
    $yCmpOffset = f.y
    $zCmpOffset = f.z
  end
  cmp.set_attribute 'o.h', "xCmpOffset", $xCmpOffset
  cmp.set_attribute 'o.h', "yCmpOffset", $yCmpOffset
  cmp.set_attribute 'o.h', "zCmpOffset", $zCmpOffset

  $cmpName = cmp.definition.name
  cmp.set_attribute 'o.h', "cmpName", $cmpName
  $cmpWidth = cmp.bounds.width
  $cmpDepth = cmp.bounds.depth
  $cmpHeight = cmp.bounds.height
  cmp.set_attribute 'o.h', "cmpWidth", $cmpWidth
  cmp.set_attribute 'o.h', "cmpDepth", $cmpDepth
  cmp.set_attribute 'o.h', "cmpHeight", $cmpHeight

  $cmpPos = cmp.get_attribute 'o.h', "cmpPos"
  $cmpNo = cmp.get_attribute 'o.h', "cmpNo"
  if $cmpPos.nil?
    $cmpPos = 1
  else
    $cmpPos = $cmpPos + 1
  end
  if $cmpNo.nil?
    $cmpNo = 1
  else
    $cmpNo = $cmpNo + 1
  end
  cmp.set_attribute 'o.h', "cmpPos", $cmpPos
  cmp.set_attribute 'o.h', "cmpNo", $cmpNo

  if type == "Fume Cupboard"
    name = cmp.definition.name
    nsp = name.split('')
    height = nsp[11]
    dimension = nsp[8]
    if height == 'S'
      height = "Standard Height"
    elsif height == 'L'
      height = "Low Height"
    else
      height = "Walk-in"
    end
    if dimension == 'S'
      dimension = "Space Construction"
    else
      dimension = "Extended Media Construction"
    end
    $fntFcType = height + " / " + dimension
    cmp.set_attribute 'o.h', "fntFcType", $fntFcType

    index = materials.index(results[0])
    $fntFcContainmentMaterial = materials[index]
    cmp.set_attribute 'o.h', "fntFcContainmentMaterial", $fntFcContainmentMaterial
  end

  UI.messagebox("Attributes added")

# cmp3D
# cmpTop
# cmpFront
# cmpSide
# cmpDg

end

if( not file_loaded?("su_examples/addAtt.rb") )
  plugs_menu = UI.menu("Plugins")
  plugs_menu.add_item("Add attributes") { add_attributes }
end
file_loaded("su_examples/addAtt.rb")