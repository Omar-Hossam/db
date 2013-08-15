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
    UI.messagebox("More than one instance is selected. Please select only one instance")
    return
  else
    cmp_class, cmp_type = get_type(ss.first.definition.name)
    if cmp_class == nil || cmp_type == nil
      UI.messagebox("Component name not clear")
      return
    elsif cmp_class = "component"
      set_cmp_att(ss.first, cmp_type)
    else
      UI.messagebox("Selected object's class is not suitable for attribute addition. You may would like to visit 'Edit attributes'")
      return
    end
  end
end

def get_type(name)
  spn = name.split('')
  cmp_type = ""
  if spn[0] == 'c' && spn[1] == 'L' && spn[2] == 'a' && spn[3] == 'b'
    if spn[4] == 'F'
      if spn[5] == 'n'
        cmp_class = "component"
        if spn[7] == 'F'
          cmp_type = "Fume Cupboard"
        elsif spn[7] == 'B'
          cmp_type = "Benchtop"
        elsif spn[7] == 'T'
          cmp_type = "Table"
        elsif spn[7] == 'M'
          cmp_type = "Miscellaenous"
        elsif spn[7] = 'S'
          if spn[8] == 'v'
            cmp_type = "Service System"
          elsif spn[8] == 'u'
            cmp_type = "Benchtop Support System"
          elsif spn[8] == 't'
            cmp_type = "Storage"
          elsif spn[8] == 'i'
            cmp_type = "Sinkmodule"
          end
        end
      elsif spn[5] == 'l'
        cmp_class = "floor"
      end
    elsif spn[4] == 'M'
      cmp_class = "component"
      cmp_type = "Media"
    elsif spn[4] == 'E'
      cmp_class = "component"
      cmp_type = "Equipment"
    elsif spn[4] == 'B'
      cmp_class = "building"
    elsif spn[4] == 'R'
      cmp_class = "room"
    elsif spn[4] == 'V'
      cmp_class = "view"
    else
      cmp_class = nil
      cmp_type = nil
    end
    return cmp_class,  cmp_type
  else
    return
  end
end

def set_cmp_att(cmp, type)
  $cmpWorkdist = cmp.get_attribute 'o.h', "Workspacedepth"
  $cmpWalkdist = cmp.get_attribute 'o.h', "Walkspacedepth"
  $cmpPrice = cmp.get_attribute 'o.h', "Price", 0.00
  $cmpSuppl = cmp.get_attribute 'o.h', "Supplier", "genuine"
  $cmpSupplID = cmp.get_attribute 'o.h', "ID from Supplier", ""
  $cmpSupplPrice = cmp.get_attribute 'o.h', "Price from Supplier", ""
  $cmPos = cmp.get_attribute 'o.h', "Position", 1
  $cmpNo = cmp.get_attribute 'o.h', "Number", 1
  
  if type == "Fume Cupboard"
    materials = ["unspecified", "PP", "PVDF", "1.4301(V2A)"]
    while true
      prompts = ["Fume Cupboard Containment Material", "Workspacedepth",
        "Walkspacedepth", "Price", "Supplier", "ID from Supplier",
        "Price from Supplier", "Position", "Number"]
      values = [materials[0], $cmpWorkdist, $cmpWalkdist, $cmpPrice, $cmpSuppl,
        $cmpSupplID, $cmpSupplPrice, $cmPos, $cmpNo]
      enums = [materials.join("|")]
      results = inputbox prompts, values, enums, "Add Component Attributes"
      return if not results
      $cmpWorkdist = results[1]
      $cmpWalkdist = results[2]
      $cmpPrice = results[3]
      $cmpSuppl = results[4]
      $cmpSupplID = results[5]
      $cmpSupplPrice = results[6]
      $cmpPos = results[7]
      $cmpNo = results[8]
      if $cmpWorkdist.empty?
        UI.messagebox("Workspacedepth can't be blank")
      elsif $cmpWalkdist.empty?
        UI.messagebox("Walkspacedepth can't be blank")
      elsif $cmpPos == 0
        UI.messagebox("Position can't be zero")
      elsif $cmpNo == 0
        UI.messagebox("Number can't be zero")
      else
        break
      end
    end
    index = materials.index(results[0])
    $fntFcContainmentMaterial = materials[index]
    cmp.set_attribute 'o.h', "Fume Cupboard Containment Material", $fntFcContainmentMaterial
  
  elsif type == "Benchtop Support System"
    desks = ["none", "left-hinged-door", "right-hinged-door", "2-doors",
      "1-drawer-1-left-hinged-door", "1-drawer-1-right-hinged-door",
      "1-small-drawer-2-medium-drawers", "1-small-drawer-1-large-drawers",
      "2-drawers", "3-drawers"]
    benches = ["none", "left-hinged-door", "right-hinged-door", "2-doors",
      "1-drawer-1-left-hinged-door", "1-drawer-1-right-hinged-door",
      "1-small-drawer-2-medium-drawers", "1-small-drawer-1-large-drawers",
      "2-drawers", "3-drawers", "4-drawers"]
    while true
      prompts = ["Desk Front", "Bench Front", "Workspacedepth", "Walkspacedepth",
        "Price", "Supplier", "ID from Supplier", "Price from Supplier",
        "Position", "Number"]
      values = [desks[0], benches[0], $cmpWorkdist, $cmpWalkdist, $cmpPrice,
        $cmpSuppl, $cmpSupplID, $cmpSupplPrice, $cmPos, $cmpNo]
      enums = [desks.join("|"), benches.join("|")]
      results = inputbox prompts, values, enums, "Add Component Attributes"
      return if not results
      $cmpWorkdist = results[2]
      $cmpWalkdist = results[3]
      $cmpPrice = results[4]
      $cmpSuppl = results[5]
      $cmpSupplID = results[6]
      $cmpSupplPrice = results[7]
      $cmpPos = results[8]
      $cmpNo = results[9]
      if $cmpWorkdist.empty?
        UI.messagebox("Workspacedepth can't be blank")
      elsif $cmpWalkdist.empty?
        UI.messagebox("Walkspacedepth can't be blank")
      elsif $cmpPos == 0
        UI.messagebox("Position can't be zero")
      elsif $cmpNo == 0
        UI.messagebox("Number can't be zero")
      else
        break
      end
    end
    index = desks.index(results[0])
    index2 = benches.index(results[1])
    $fntDeskfront = desks[index]
    $fntBenchfront = benches[index2]
    cmp.set_attribute 'o.h', "Desk Front", $fntDeskfront
    cmp.set_attribute 'o.h', "Bench Front", $fntBenchfront

  elsif type == "Benchtop"
    materials = ["unspecified", "Melamine", "EBC-Worktop", "PP", "Glass",
      "1.4301(V2A)", "Ceramic", "Ceramic marine Edge", "Epoxy"]
    while true
      prompts = ["Benchtop Material", "Workspacedepth", "Walkspacedepth",
        "Price", "Supplier", "ID from Supplier", "Price from Supplier",
        "Position", "Number"]
      values = [materials[0], $cmpWorkdist, $cmpWalkdist, $cmpPrice, $cmpSuppl,
        $cmpSupplID, $cmpSupplPrice, $cmPos, $cmpNo]
      enums = [materials.join("|")]
      results = inputbox prompts, values, enums, "Add Component Attributes"
      return if not results
      $cmpWorkdist = results[1]
      $cmpWalkdist = results[2]
      $cmpPrice = results[3]
      $cmpSuppl = results[4]
      $cmpSupplID = results[5]
      $cmpSupplPrice = results[6]
      $cmpPos = results[7]
      $cmpNo = results[8]
      if $cmpWorkdist.empty?
        UI.messagebox("Workspacedepth can't be blank")
      elsif $cmpWalkdist.empty?
        UI.messagebox("Walkspacedepth can't be blank")
      elsif $cmpPos == 0
        UI.messagebox("Position can't be zero")
      elsif $cmpNo == 0
        UI.messagebox("Number can't be zero")
      else
        break
      end
    end
    index = materials.index(results[0])
    $fntBtpMaterial = materials[index]
    cmp.set_attribute 'o.h', "Benchtop Material", $fntBtpMaterial

  elsif type == "Sinkmodule"
    materials = ["unspecified", "Full-PP", "Full-1.4301(V2A)", "Full-Ceramic",
      "EBC-PP", "EBC-1.4301(V2A)", "EBC-Ceramic"]
    while true
      prompts = ["Sink Material", "Workspacedepth", "Walkspacedepth",
        "Price", "Supplier", "ID from Supplier", "Price from Supplier",
        "Position", "Number"]
      values = [materials[0], $cmpWorkdist, $cmpWalkdist, $cmpPrice, $cmpSuppl,
        $cmpSupplID, $cmpSupplPrice, $cmPos, $cmpNo]
      enums = [materials.join("|")]
      results = inputbox prompts, values, enums, "Add Component Attributes"
      return if not results
      $cmpWorkdist = results[1]
      $cmpWalkdist = results[2]
      $cmpPrice = results[3]
      $cmpSuppl = results[4]
      $cmpSupplID = results[5]
      $cmpSupplPrice = results[6]
      $cmpPos = results[7]
      $cmpNo = results[8]
      if $cmpWorkdist.empty?
        UI.messagebox("Workspacedepth can't be blank")
      elsif $cmpWalkdist.empty?
        UI.messagebox("Walkspacedepth can't be blank")
      elsif $cmpPos == 0
        UI.messagebox("Position can't be zero")
      elsif $cmpNo == 0
        UI.messagebox("Number can't be zero")
      else
        break
      end
    end
    index = materials.index(results[0])
    $fntSinkMaterial = materials[index]
    cmp.set_attribute 'o.h', "Sink Material", $fntSinkMaterial        

  else
    while true
      prompts = ["Workspacedepth", "Walkspacedepth", "Price", "Supplier",
        "ID from Supplier", "Price from Supplier", "Position", "Number"]
      values = [$cmpWorkdist, $cmpWalkdist, $cmpPrice, $cmpSuppl, $cmpSupplID,
        $cmpSupplPrice, $cmPos, $cmpNo]
      results = inputbox prompts, values, "Add Component Attributes"
      return if not results
      $cmpWorkdist = results[0]
      $cmpWalkdist = results[1]
      $cmpPrice = results[2]
      $cmpSuppl = results[3]
      $cmpSupplID = results[4]
      $cmpSupplPrice = results[5]
      $cmpPos = results[6]
      $cmpNo = results[7]
      if $cmpWorkdist.empty?
        UI.messagebox("Workspacedepth can't be blank")
      elsif $cmpWalkdist.empty?
        UI.messagebox("Walkspacedepth can't be blank")
      elsif $cmpPos == 0
        UI.messagebox("Position can't be zero")
      elsif $cmpNo == 0
        UI.messagebox("Number can't be zero")
      else
        break
      end
    end
  end

  cmp.set_attribute 'o.h', "Workspacedepth", $cmpWorkdist
  cmp.set_attribute 'o.h', "Walkspacedepth", $cmpWalkdist
  cmp.set_attribute 'o.h', "Price", $cmpPrice
  cmp.set_attribute 'o.h', "Supplier", $cmpSuppl
  cmp.set_attribute 'o.h', "ID from Supplier", $cmpSupplID
  cmp.set_attribute 'o.h', "Price from Supplier", $cmpSupplPrice
  cmp.set_attribute 'o.h', "Position", $cmpPos
  cmp.set_attribute 'o.h', "Number", $cmpNo

  f = cmp.transformation.origin
  check = cmp.get_attribute 'o.h', "Floor Number"
  if check == nil
    $xCmpOffset = f.x.to_f
    $yCmpOffset = f.y.to_f
    $zCmpOffset = f.z.to_f
  else
    fxo = cmp.get_attribute 'o.h', "Floor x Offset"
    fyo = cmp.get_attribute 'o.h', "Floor y Offset"
    fzo = cmp.get_attribute 'o.h', "Floor z Offset"
    $xCmpOffset = f.x.to_f - fxo
    $yCmpOffset = f.y.to_f - fyo
    $zCmpOffset = f.z.to_f - fzo
  end
  cmp.set_attribute 'o.h', "Component x Offset", $xCmpOffset
  cmp.set_attribute 'o.h', "Component y Offset", $yCmpOffset
  cmp.set_attribute 'o.h', "Component z Offset", $zCmpOffset

  $cmpName = cmp.definition.name
  cmp.set_attribute 'o.h', "Component Name", $cmpName
  cmp.set_attribute 'o.h', "Component Type", type
  $cmpWidth = cmp.bounds.width.to_f
  $cmpDepth = cmp.bounds.depth.to_f
  $cmpHeight = cmp.bounds.height.to_f
  cmp.set_attribute 'o.h', "Width", $cmpWidth
  cmp.set_attribute 'o.h', "Depth", $cmpDepth
  cmp.set_attribute 'o.h', "Height", $cmpHeight
  cmp.set_attribute 'o.h', "cmpID", 0

  UI.messagebox("Attributes added")

end

def next_t(ent)
  all = ["building", "floor", "room", "view", "component"]
  type, fs = get_type(ent.definition.name)
  ind = all.index(type)
  ind = ind + 1
  nxt = all[ind]
  return nxt
end

def to_json
  ents = Sketchup.active_model.entities
  json_string = "[ "
  first = true
  ents.each do |ent|
    if first
      json_string << "{ "
      first = false
    else
      json_string << " , { "
    end
    type, fs = get_type(ent.definition.name)
    @impt = type
    json_string << "\"type\" : \"" + type + "\""
    at = ent.attribute_dictionary "o.h"
    ks = at.keys
    ks.each do |k|
      val = ent.get_attribute "o.h", k
      json_string << " , \"" + k.to_s + "\" : " 
      if (val.is_a? Integer) || (val.is_a? Float)
        json_string << val.to_s
      else
        json_string << "\"" + val.to_s + "\""
      end
    end
    bah = false
    type2 = ""
    ent.definition.entities.each do |enw|
      if enw.typename != "ComponentInstance"
        bah = true
        break
      end
    end
    if not bah
      json_string << " , \"" + next_t(ent) + "s\" : [ "
      first2 = true
      ent.definition.entities.each do |enw|
        bah = false
        if first2
          json_string << "{ "
          first2 = false
        else
          json_string << " , { "
        end
        type2, fs = get_type(enw.definition.name)
        json_string << "\"type\" : \"" + type2 + "\""
        at = enw.attribute_dictionary "o.h"
        ks = at.keys
        ks.each do |k|
          val = enw.get_attribute "o.h", k
          json_string << " , \"" + k.to_s + "\" : " 
          if (val.is_a? Integer) || (val.is_a? Float)
            json_string << val.to_s
          else
            json_string << "\"" + val.to_s + "\""
          end
        end
        type3 = ""
        enw.definition.entities.each do |enh|
          if enh.typename != "ComponentInstance"
            bah = true
            break
          end
        end
        if not bah
          json_string << " , \"" + next_t(enw) + "s\" : [ "
          first3 = true
          enw.definition.entities.each do |enh|
            bah = false
            if first3
              json_string << "{ "
              first3 = false
            else
              json_string << " , { "
            end
            type3, fs = get_type(enh.definition.name)
            json_string << "\"type\" : \"" + type3 + "\""
            at = enh.attribute_dictionary "o.h"
            ks = at.keys
            ks.each do |k|
              val = enh.get_attribute "o.h", k
              json_string << " , \"" + k.to_s + "\" : " 
              if (val.is_a? Integer) || (val.is_a? Float)
                json_string << val.to_s
              else
                json_string << "\"" + val.to_s + "\""
              end
            end
            type4 = ""
            enh.definition.entities.each do |enf|
              if enf.typename != "ComponentInstance"
                bah = true
                break
              end
            end
            if not bah
              json_string << " , \"" + next_t(enh) + "s\" : [ "
              first4 = true
              enh.definition.entities.each do |enf|
                bah = false
                if first4
                  json_string << "{ "
                  first4 = false
                else
                  json_string << " , { "
                end
                type4, fs = get_type(enf.definition.name)
                json_string << "\"type\" : \"" + type4 + "\""
                at = enf.attribute_dictionary "o.h"
                ks = at.keys
                ks.each do |k|
                  val = enf.get_attribute "o.h", k
                  json_string << " , \"" + k.to_s + "\" : " 
                  if (val.is_a? Integer) || (val.is_a? Float)
                    json_string << val.to_s
                  else
                    json_string << "\"" + val.to_s + "\""
                  end
                end
                type5 = ""
                enf.definition.entities.each do |eni|
                  if eni.typename != "ComponentInstance"
                    bah = true
                    break
                  end
                end
                if not bah
                  json_string << " , \"" + next_t(enf) + "s\" : [ "
                  first5 = true
                  enf.definition.entities.each do |eni|
                    bah = false
                    if first5
                      json_string << "{ "
                      first5 = false
                    else
                      json_string << " , { "
                    end
                    type5, fs = get_type(eni.definition.name)
                    json_string << "\"type\" : \"" + type5 + "\""
                    at = eni.attribute_dictionary "o.h"
                    ks = at.keys
                    ks.each do |k|
                      val = eni.get_attribute "o.h", k
                      json_string << " , \"" + k.to_s + "\" : " 
                      if (val.is_a? Integer) || (val.is_a? Float)
                        json_string << val.to_s
                      else
                        json_string << "\"" + val.to_s + "\""
                      end
                    end
                    json_string << " }"
                  end
                  json_string << " ]"
                end
                json_string << " }"
              end
              json_string << " ]"
            end
            json_string << " }"
          end
          json_string << " ]"
        end
        json_string << " }"
      end
      json_string << " ]"
    end
    json_string << " }"
  end
  json_string << " ]"
  File.open("C:/Users/Omar H/Desktop/out.json", "w") do |f|     
    f.write(json_string)
  end
  system("C:/test/DBConnect.exe imp -mode=#{@impt} -file=\"C:/Users/Omar H/Desktop/out.json\"")
end

if( not file_loaded?("su_examples/addAtt.rb") )
  plugs_menu = UI.menu("Plugins")
  plugs_menu.add_item("Add attributes") { add_attributes }
  plugs_menu.add_item("save") { to_json }
end
file_loaded("su_examples/addAtt.rb")