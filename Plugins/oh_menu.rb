require 'sketchup.rb'
require 'json.rb'

@dbconnectPath = "C:/test"

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
  path = @dbconnectPath + "/out.json"
  File.open(path, "w") do |f|     
    f.write(json_string)
  end
  system(@dbconnectPath + "/DBConnect.exe imp -mode=#{@impt} -file=#{path}")
end

def read
  value = ""
  while true
    cls = ["Please choose one", "building", "floor", "room", "view", "component"]
    prompts = ["Class of Object"]
    values = [cls[0]]
    enums = [cls.join("|")]
    results = inputbox prompts, values, enums, "Import from database"
    return if not results

    index = cls.index(results[0])
    if cls[index] != "Please choose one"
      oclass = cls[index]

      case oclass
      when "building"
        while true
          bname = ""
          prompts = ["Building Name"]
          values = [bname]
          results = inputbox prompts, values, "Import Building from database"
          return if not results
          bname = results[0]
          if bname != ""
            value = bname
            break
          else
            UI.messagebox("Building Name can't be blank")
          end
        end
      when "floor"
        while true
          fnum = ""
          bname = ""
          prompts = ["Building Name", "Floor Number"]
          values = [bname, fnum]
          results = inputbox prompts, values, "Import Floor from database"
          return if not results
          bname = results[0]
          fnum = results[1]
          if fnum != ""
            if bname != ""
              value = bname + "-" + fnum
            else
              value = "<no building>-" + fnum
            end
            break
          else
            UI.messagebox("Floor number can't be blank")
          end
        end
      when "room"
        while true
          bname = ""
          fnum = ""
          rname = ""
          prompts = ["Building Name", "Floor Number", "Room Name"]
          values = [bname, fnum, rname]
          results = inputbox prompts, values, "Import Room from database"
          return if not results
          bname = results[0]
          fnum = results[1]
          rname = results[2]
          if rname != ""
            if bname != "" && fnum == ""
              UI.messagebox("Floor number can't be blank since the room has a building and a floor")
            else
              if fnum == ""
                value = "<no building>-<no floor>-" + rname
              elsif bname == ""
                value = "<no building>-" + fnum + "-" + rname
              else
                value = bname + "-" + fnum + "-" + rname
              end
              break
            end
          else
            UI.messagebox("Room name can't be blank")
          end
        end
      when "view"
        while true
          bname = ""
          fnum = ""
          rname = ""
          vnum = ""
          prompts = ["Building Name", "Floor Number", "Room Name", "View Number"]
          values = [bname, fnum, rname, vnum]
          results = inputbox prompts, values, "Import View from database"
          return if not results
          bname = results[0]
          fnum = results[1]
          rname = results[2]
          vnum = results[3]
          if vnum != ""
            if (bname != "" && fnum == "") || (fnum != "" && rname == "")
              UI.messagebox("Data missing from view hierarchy, please fill all the data needed")
            else
              if rname == ""
                value = "<no building>-<no floor>-<no room>-" + vnum
              elsif fnum == ""
                value = "<no building>-<no floor>-" + rname + "-" + vnum
              elsif bname == ""
                value = "<no building>-" + fnum + "-" + rname + "-" + vnum
              else
                value = bname + "-" + fnum + "-" + rname + "-" + vnum
              end
              break
            end
          else
            UI.messagebox("View Number can't be blank")
          end
        end
      when "component"
        while true
          bname = ""
          fnum = ""
          rname = ""
          vnum = ""
          cnum = 0
          prompts = ["Building Name", "Floor Number", "Room Name", "View Number", "Component Number"]
          values = [bname, fnum, rname, vnum, cnum]
          results = inputbox prompts, values, "Import View from database"
          return if not results
          bname = results[0]
          fnum = results[1]
          rname = results[2]
          vnum = results[3]
          cnum = results[4]
          if cnum != 0
            if (bname != "" && fnum == "") || (fnum != "" && rname == "") || (rname != "" && vnum == "")
              UI.messagebox("Data missing from view hierarchy, please fill all the data needed")
            else
              if vnum == ""
                value = "<no building>-<no floor>-<no room>-<no view>-" + cnum.to_s
              elsif rname == ""
                value = "<no building>-<no floor>-<no room>-" + vnum + "-" + cnum.to_s
              elsif fnum == ""
                value = "<no building>-<no floor>-" + rname + "-" + vnum + "-" + cnum.to_s
              elsif bname == ""
                value = "<no building>-" + fnum + "-" + rname + "-" + vnum + "-" + cnum.to_s
              else
                value = bname + "-" + fnum + "-" + rname + "-" + vnum + "-" + cnum.to_s
              end
              break
            end
          else
            UI.messagebox("Component Number can't be zero")
          end
        end
      end

      break
    else
      UI.messagebox("Please choose an object class first before proceeding")
    end
  end

  code = ""
  tempfile = @dbconnectPath + "/trial.json"
  if File.exist?(tempfile)
    File.delete(tempfile)
  end
  cmdstring = @dbconnectPath + "/DBConnect.exe  -#{oclass}=#{value} exp -file=\""  + tempfile + "\""
  system(cmdstring)
  count = 0
  while true
    count=count + 1
    if File.exist?(tempfile)
      break
    end
    if count == 100
      break
    end
    Sleep(1000)
  end
  test = true
  open(tempfile,"r:UTF-8") do |infile|
    while (line = infile.gets)
        code = code + line
    end
  end
  i = 0
  while code[i].chr!="["
    code[i] = ' '
    i=i+1
  end
  hash = JSON.parse code

  ss = Sketchup.active_model.selection
  thing = hash[0]
  type = thing["Type"]
  if type == "component"
    make_component(thing, type, nil, nil, nil, nil) 
  elsif type == "view"
    cmps = thing["Components"]
    cmps.each do |cmp|
      ins = make_component(cmp, type, thing, nil, nil, nil)
      ss.add ins
    end
    group = Sketchup.active_model.active_entities.add_group(ss)
    view = group.to_component
    view.definition.name = "cLabView"
    view.set_attribute 'o.h', "View Number", thing["View Number"]
    view.set_attribute 'o.h', "View x Offset", thing["View x Offset"]
    view.set_attribute 'o.h', "View y Offset", thing["View y Offset"]
    view.set_attribute 'o.h', "Depth Offset", thing["Depth Offset"]
    view.set_attribute 'o.h', "Height Offset", thing["Height Offset"]
    ss.add view
  elsif type == "room"
    views = thing["Views"]
    views.each do |view|
      cmps = view["Components"]
      cmps.each do |cmp|
        ins = make_component(cmp, type, view, thing, nil, nil)
        ss.add ins
      end
      group = Sketchup.active_model.active_entities.add_group(ss)
      nview = group.to_component
      nview.definition.name = "cLabView"
      nview.set_attribute 'o.h', "View Number", view["View Number"]
      nview.set_attribute 'o.h', "View x Offset", view["View x Offset"]
      nview.set_attribute 'o.h', "View y Offset", view["View y Offset"]
      nview.set_attribute 'o.h', "Depth Offset", view["Depth Offset"]
      nview.set_attribute 'o.h', "Height Offset", view["Height Offset"]
      nview.set_attribute 'o.h', "Room Number", thing["Room Number"]
      nview.set_attribute 'o.h', "Room x Offset", thing["Room x Offset"]
      nview.set_attribute 'o.h', "Room y Offset", thing["Room y Offset"]
      nview.set_attribute 'o.h', "Room Name", thing["Room Name"]
      nview.set_attribute 'o.h', "Room Departement", thing["Room Departement"]
      ss.add nview
    end
    group = Sketchup.active_model.active_entities.add_group(ss)
    nroom = group.to_component
    nroom.definition.name = "cLabRoom"
    nroom.set_attribute 'o.h', "Room Number", thing["Room Number"]
    nroom.set_attribute 'o.h', "Room x Offset", thing["Room x Offset"]
    nroom.set_attribute 'o.h', "Room y Offset", thing["Room y Offset"]
    nroom.set_attribute 'o.h', "Room Name", thing["Room Name"]
    nroom.set_attribute 'o.h', "Room Departement", thing["Room Departement"]
    ss.add nroom
  elsif type == "floor"
    rooms = thing["Rooms"]
    rooms.each do |room|
      views = room["Views"]
      views.each do |view|
        cmps = view["Components"]
        cmps.each do |cmp|
          ins = make_component(cmp, type, view, room, thing, nil)
          ss.add ins
        end
        group = Sketchup.active_model.active_entities.add_group(ss)
        nview = group.to_component
        nview.definition.name = "cLabView"
        nview.set_attribute 'o.h', "View Number", view["View Number"]
        nview.set_attribute 'o.h', "View x Offset", view["View x Offset"]
        nview.set_attribute 'o.h', "View y Offset", view["View y Offset"]
        nview.set_attribute 'o.h', "Depth Offset", view["Depth Offset"]
        nview.set_attribute 'o.h', "Height Offset", view["Height Offset"]
        nview.set_attribute 'o.h', "Room Number", room["Room Number"]
        nview.set_attribute 'o.h', "Room x Offset", room["Room x Offset"]
        nview.set_attribute 'o.h', "Room y Offset", room["Room y Offset"]
        nview.set_attribute 'o.h', "Room Name", room["Room Name"]
        nview.set_attribute 'o.h', "Room Departement", room["Room Departement"]
        nview.set_attribute 'o.h', "Floor Number", thing["Floor Number"]
        nview.set_attribute 'o.h', "Floor x Offset", thing["Floor x Offset"]
        nview.set_attribute 'o.h', "Floor y Offset", thing["Floor y Offset"]
        nview.set_attribute 'o.h', "Floor z Offset", thing["Floor z Offset"]
        ss.add nview
      end
      group = Sketchup.active_model.active_entities.add_group(ss)
      nroom = group.to_component
      nroom.definition.name = "cLabRoom"
      nroom.set_attribute 'o.h', "Room Number", room["Room Number"]
      nroom.set_attribute 'o.h', "Room x Offset", room["Room x Offset"]
      nroom.set_attribute 'o.h', "Room y Offset", room["Room y Offset"]
      nroom.set_attribute 'o.h', "Room Name", room["Room Name"]
      nroom.set_attribute 'o.h', "Room Departement", room["Room Departement"]
      nroom.set_attribute 'o.h', "Floor Number", thing["Floor Number"]
      nroom.set_attribute 'o.h', "Floor x Offset", thing["Floor x Offset"]
      nroom.set_attribute 'o.h', "Floor y Offset", thing["Floor y Offset"]
      nroom.set_attribute 'o.h', "Floor z Offset", thing["Floor z Offset"]
      ss.add nroom
    end
    group = Sketchup.active_model.active_entities.add_group(ss)
    nfloor = group.to_component
    nfloor.definition.name = "cLabFloor"
    nfloor.set_attribute 'o.h', "Floor Number", thing["Floor Number"]
    nfloor.set_attribute 'o.h', "Floor x Offset", thing["Floor x Offset"]
    nfloor.set_attribute 'o.h', "Floor y Offset", thing["Floor y Offset"]
    nfloor.set_attribute 'o.h', "Floor z Offset", thing["Floor z Offset"]
    ss.add nfloor
  elsif type == "building"
    floors = thing["Floors"]
    floors.each do |floor|
      rooms = floor["Rooms"]
      rooms.each do |room|
        views = room["Views"]
        views.each do |view|
          cmps = view["Components"]
          cmps.each do |cmp|
            ins = make_component(cmp, type, view, room, floor, thing)
            ss.add ins
          end
          group = Sketchup.active_model.active_entities.add_group(ss)
          nview = group.to_component
          nview.definition.name = "cLabView"
          nview.set_attribute 'o.h', "View Number", view["View Number"]
          nview.set_attribute 'o.h', "View x Offset", view["View x Offset"]
          nview.set_attribute 'o.h', "View y Offset", view["View y Offset"]
          nview.set_attribute 'o.h', "Depth Offset", view["Depth Offset"]
          nview.set_attribute 'o.h', "Height Offset", view["Height Offset"]
          nview.set_attribute 'o.h', "Room Number", room["Room Number"]
          nview.set_attribute 'o.h', "Room x Offset", room["Room x Offset"]
          nview.set_attribute 'o.h', "Room y Offset", room["Room y Offset"]
          nview.set_attribute 'o.h', "Room Name", room["Room Name"]
          nview.set_attribute 'o.h', "Room Departement", room["Room Departement"]
          nview.set_attribute 'o.h', "Floor Number", floor["Floor Number"]
          nview.set_attribute 'o.h', "Floor x Offset", floor["Floor x Offset"]
          nview.set_attribute 'o.h', "Floor y Offset", floor["Floor y Offset"]
          nview.set_attribute 'o.h', "Floor z Offset", floor["Floor z Offset"]
          nview.set_attribute 'o.h', "Building Name", thing["Building Name"]
          nview.set_attribute 'o.h', "Building x Location", thing["Building x Location"]
          nview.set_attribute 'o.h', "Building y Location", thing["Building y Location"]
          nview.set_attribute 'o.h', "Building z Location", thing["Building z Location"]
          ss.add nview
        end
        group = Sketchup.active_model.active_entities.add_group(ss)
        nroom = group.to_component
        nroom.definition.name = "cLabRoom"
        nroom.set_attribute 'o.h', "Room Number", room["Room Number"]
        nroom.set_attribute 'o.h', "Room x Offset", room["Room x Offset"]
        nroom.set_attribute 'o.h', "Room y Offset", room["Room y Offset"]
        nroom.set_attribute 'o.h', "Room Name", room["Room Name"]
        nroom.set_attribute 'o.h', "Room Departement", room["Room Departement"]
        nroom.set_attribute 'o.h', "Floor Number", floor["Floor Number"]
        nroom.set_attribute 'o.h', "Floor x Offset", floor["Floor x Offset"]
        nroom.set_attribute 'o.h', "Floor y Offset", floor["Floor y Offset"]
        nroom.set_attribute 'o.h', "Floor z Offset", floor["Floor z Offset"]
        nroom.set_attribute 'o.h', "Building Name", thing["Building Name"]
        nroom.set_attribute 'o.h', "Building x Location", thing["Building x Location"]
        nroom.set_attribute 'o.h', "Building y Location", thing["Building y Location"]
        nroom.set_attribute 'o.h', "Building z Location", thing["Building z Location"]
        ss.add nroom
      end
      group = Sketchup.active_model.active_entities.add_group(ss)
      nfloor = group.to_component
      nfloor.definition.name = "cLabFloor"
      nfloor.set_attribute 'o.h', "Floor Number", floor["Floor Number"]
      nfloor.set_attribute 'o.h', "Floor x Offset", floor["Floor x Offset"]
      nfloor.set_attribute 'o.h', "Floor y Offset", floor["Floor y Offset"]
      nfloor.set_attribute 'o.h', "Floor z Offset", floor["Floor z Offset"]
      nfloor.set_attribute 'o.h', "Building Name", thing["Building Name"]
      nfloor.set_attribute 'o.h', "Building x Location", thing["Building x Location"]
      nfloor.set_attribute 'o.h', "Building y Location", thing["Building y Location"]
      nfloor.set_attribute 'o.h', "Building z Location", thing["Building z Location"]
      ss.add nfloor
    end
    group = Sketchup.active_model.active_entities.add_group(ss)
    nbld = group.to_component
    nbld.definition.name = "cLabBld"
    nbld.set_attribute 'o.h', "Building Name", thing["Building Name"]
    nbld.set_attribute 'o.h', "Building x Location", thing["Building x Location"]
    nbld.set_attribute 'o.h', "Building y Location", thing["Building y Location"]
    nbld.set_attribute 'o.h', "Building z Location", thing["Building z Location"]
    ss.add nbld
  end
  UI.messagebox("Data imported")
end

def make_component(cmp, type, view, room, floor, building)
  model = Sketchup.active_model
  name = cmp["Component Name"]
  a = @dbconnectPath + "\\components\\#{name}.skp"
  definitions = model.definitions
  b = definitions.load a
  if type == "component"
    x = cmp["Component x Offset"]
    y = cmp["Component y Offset"]
    z = cmp["Component z Offset"]
  else
    x = cmp["Component x Offset"] + view["View x Offset"]
    y = cmp["Component y Offset"] + view["View y Offset"]
    if (type == "building") || (type == "floor")
      z = cmp["Component z Offset"] + floor["Floor z Offset"]
    else
      z = cmp["Component z Offset"]
    end
  end
  pt = Geom::Point3d.new(x,y,z)
  tr = Geom::Transformation.new(pt)
  ins = model.entities.add_instance( b, tr )
  ins.set_attribute 'o.h', "Workspacedepth", cmp["Workspacedepth"]
  ins.set_attribute 'o.h', "Walkspacedepth", cmp["Walkspacedepth"]
  ins.set_attribute 'o.h', "Price", cmp["Price"]
  ins.set_attribute 'o.h', "Supplier", cmp["Supplier"]
  ins.set_attribute 'o.h', "ID from Supplier", cmp["ID from Supplier"]
  ins.set_attribute 'o.h', "Price from Supplier", cmp["Price from Supplier"]
  ins.set_attribute 'o.h', "Position", cmp["Position"]
  ins.set_attribute 'o.h', "Number", cmp["Number"]
  ins.set_attribute 'o.h', "Component x Offset", cmp["Component x Offset"]
  ins.set_attribute 'o.h', "Component y Offset", cmp["Component y Offset"]
  ins.set_attribute 'o.h', "Component z Offset", cmp["Component z Offset"]
  ins.set_attribute 'o.h', "Component Name", cmp["Component Name"]
  ins.set_attribute 'o.h', "Component Type", cmp["Component Type"]
  ins.set_attribute 'o.h', "Width", cmp["Width"]
  ins.set_attribute 'o.h', "Depth", cmp["Depth"]
  ins.set_attribute 'o.h', "Height", cmp["Height"]
  ins.set_attribute 'o.h', "Component id", cmp["Component id"]
  if cmp["Component Type"] == "Fume Cupboard"
    ins.set_attribute 'o.h', "Fume Cupboard Containment Material", cmp["Fume Cupboard Containment Material"]
  elsif cmp["Component Type"] == "Benchtop Support System"
    ins.set_attribute 'o.h', "Desk Front", cmp["Desk Front"]
    ins.set_attribute 'o.h', "Bench Front", cmp["Bench Front"]
  elsif cmp["Component Type"] == "Benchtop"
    ins.set_attribute 'o.h', "Benchtop Material", cmp["Benchtop Material"]
  elsif cmp["Component Type"] == "Sinkmodule"
    ins.set_attribute 'o.h', "Sink Material", cmp["Sink Material"]
  end
  if type == "building"
    ins.set_attribute 'o.h', "Building Name", building["Building Name"]
    ins.set_attribute 'o.h', "Building x Location", building["Building x Location"]
    ins.set_attribute 'o.h', "Building y Location", building["Building y Location"]
    ins.set_attribute 'o.h', "Building z Location", building["Building z Location"]
    type = "floor"
  end
  if type == "floor"
    ins.set_attribute 'o.h', "Floor Number", floor["Floor Number"]
    ins.set_attribute 'o.h', "Floor x Offset", floor["Floor x Offset"]
    ins.set_attribute 'o.h', "Floor y Offset", floor["Floor y Offset"]
    ins.set_attribute 'o.h', "Floor z Offset", floor["Floor z Offset"]
    type = "room"
  end
  if type == "room"
    ins.set_attribute 'o.h', "Room Number", room["Room Number"]
    ins.set_attribute 'o.h', "Room x Offset", room["Room x Offset"]
    ins.set_attribute 'o.h', "Room y Offset", room["Room y Offset"]
    ins.set_attribute 'o.h', "Room Name", room["Room Name"]
    ins.set_attribute 'o.h', "Room Departement", room["Room Departement"]  
    type = "view"
  end
  if type == "view"
    ins.set_attribute 'o.h', "View Number", view["View Number"]
    ins.set_attribute 'o.h', "View x Offset", view["View x Offset"]
    ins.set_attribute 'o.h', "View y Offset", view["View y Offset"]
    ins.set_attribute 'o.h', "Depth Offset", view["Depth Offset"]
    ins.set_attribute 'o.h', "Height Offset", view["Height Offset"]
  end  
  return ins
end

if( not file_loaded?("su_examples/addAtt.rb") )
  plugs_menu = UI.menu("Plugins")
  plugs_menu.add_item("Add attributes") { add_attributes }
  plugs_menu.add_item("save") { to_json }
  plugs_menu.add_item("import") { read }
end
file_loaded("su_examples/addAtt.rb")