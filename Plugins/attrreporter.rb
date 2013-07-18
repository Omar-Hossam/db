require 'sketchup.rb'

class AttrReporter

  def set_up(filename)
    @group_list = []
    @component_list = []
    @dictionary_name = "o.h"
    @report_data = []
    @totals_by_att_name = {}
    @report_attribute_list = []
    @title_array = []
    @title_array.push('ENTITY')
    @title_array.push('DEFINITION NAME')
    @title_array.push('ENTITY DESCRIPTION')
    @title_array.push('LAYER')
    @filetype = (filename.split('.').last).downcase
    @filename = filename 
    if @filetype == "csv"
      @doc_start  = ""
      @doc_end    = ""
      @row_start  = ""
      @row_end    = "\n"
      @cell_start = ""
      @cell_mid   = ","
      @cell_end   = ","
    else
      @doc_start = "<html><head><meta http-equiv=\"Content-Type\" " +
        "content=\"text/html; charset=utf-8\"></head>\n<style>" +
        "table {\n" +
        "  padding: 0px;\n" +
        "  margin: 0px;\n" +
        "  empty-cells: show;\n" +
        "  border-right: 1px solid silver;\n" +
        "  border-bottom: 1px solid silver;\n" +
        "  border-collapse: collapse;\n" +
        "}\n" +
        "td {\n" +
        "  padding: 4px;\n" +
        "  margin: 0px;\n" +
        "  border-left: 1px solid silver;\n" +
        "  border-top: 1px solid silver;\n" +
        "  font-family: sans-serif;\n" +
        "  font-size: 9pt;\n" +
        "  vertical-align: top;\n" +
        "}\n</style>\n" +
        "<table border=1>"
      @doc_end    = "</table></html>"
      @row_start  = "   <tr>\n"
      @row_end    = "   </tr>\n"
      @cell_start = "    <td>"
      @cell_mid   = "</td>\n    <td>"
      @cell_end   = "</td>\n"
    end
  end

  def to_number(value)
    if value.kind_of? String
      if value =~ /^[^\d\.\-]/
        return 0.0
      end
      value = value.gsub(/[^\d\.\-]/, '')
    end
    value = value.to_f
    if value.to_s == "NaN"
      return 0.0
    else
      return value
    end
  end

  def clean_for_xml(value)
    value = value.to_s
    value = value.gsub(/\</,'<')
    value = value.gsub(/\>/,'>')
    value = value.gsub(/\"/,'"')
    value = value.gsub(/\'/,"'")
    return value
  end

  def clean_number(value)
    if is_number(value)
      value = (((value.to_f*1000000.0).round) / 1000000.0).to_s
      value = value.gsub(/\.0$/, '')
    end
    return value
  end

  def is_number(value)
    return value.to_s =~ /^\-*\d+\.*\d*$/
  end

  def get_attribute_value(entity,name)
    if entity.typename == 'ComponentInstance'
      value = entity.get_attribute @dictionary_name, name
      return value
    elsif entity.typename == 'Group' || entity.typename == "Model" || 
      entity.typename == 'ComponentDefinition'
      return entity.get_attribute(@dictionary_name, name)
    else
      return nil
    end
  end

  def collect_attributes(list)
    n = 0
    while list != []    
      list.each do |item| 
      n +=1
      type = item.typename
      case type
        when "Group"
          item.entities.each do |entity|  
            @group_list.push entity
          end
          create_report_string(item, n)
          @group_list.delete(item)
        when "ComponentInstance"
          item.definition.entities.each do |entity|
            @component_list.push entity  
          end
          create_report_string(item, n)
          @component_list.delete(item)
      end
    end
    list = @group_list + @component_list
    @group_list.clear
    @component_list.clear
    end
  end

  def get_attributes_list(attribute_entity)
    list = {}
    if attribute_entity.attribute_dictionaries
      if attribute_entity.attribute_dictionaries[@dictionary_name]
        dictionary = attribute_entity.attribute_dictionaries[@dictionary_name]
        for key in dictionary.keys
          if key[0..0] != '_'
            list[key] = true
          end
        end
      end
    end
    if attribute_entity.typename == "ComponentInstance"
      attribute_entity = attribute_entity.definition
      if attribute_entity.attribute_dictionaries
        if attribute_entity.attribute_dictionaries[@dictionary_name]
          dictionary = attribute_entity.attribute_dictionaries[@dictionary_name]
          for key in dictionary.keys
            if key[0..0] != '_'
              list[key] = true
            end
          end
        end
      end
    end
    return list.keys
  end

  def create_report_string(entity, number)
    cell_data = []
    if entity.typename == "Model" || entity.typename == "Group" ||
      entity.typename == "ComponentInstance"
      for attribute_name in get_attributes_list(entity)
        if @report_attribute_list.include?(attribute_name) == false
          if attribute_name[0..0] != '_'
            @title_array.push(attribute_name.upcase)
            @report_attribute_list.push attribute_name
          end
        end
      end
      entity_name = entity.name
      if entity_name.length < 1
        if entity.typename == 'ComponentInstance'
          entity_name = entity.definition.name
        elsif entity.typename == 'Model'
          entity_name = 'Model'
        else
          entity_name = 'Unnamed Part'
        end
      end
      cell_data.push(number.to_s)
      if entity.typename == "ComponentInstance"
        cell_data.push(entity.definition.name)
      else
        cell_data.push('-')
      end
      cell_data.push(entity.description)
      cell_data.push(entity.layer.name)
      for attribute_name in @report_attribute_list
        value = get_attribute_value(entity,attribute_name)
        if value.kind_of? Float
          if value.to_s.include?('e-')
            value = 0.0
          else 
            value = clean_number(value)
          end
        end
        cell_data.push(value)
        if @totals_by_att_name[attribute_name.upcase] == nil
          @totals_by_att_name[attribute_name.upcase] = 0.0
        end
        @totals_by_att_name[attribute_name.upcase] = 
          @totals_by_att_name[attribute_name.upcase] +
          to_number(value).to_f  
      end
      @report_data.push(cell_data)  
    end
  end

  def write_report_string
    @report_string = @doc_start
    @report_string += @row_start + @cell_start + @title_array.join(@cell_mid) +
      @cell_end + @row_end
    if @report_data.last.nil?
      UI.messagebox "No Components or Groups in the selection"
      return -1
    else
      longest_row_length = @report_data.last.length
    end
    totals_row = []
    for att_name in @title_array
      total = clean_number(@totals_by_att_name[att_name]).to_f
      if total == 0.0
        total = '-'
      end
      totals_row.push total
    end
    totals_row[0] = 'TOTALS'
    @report_data.push totals_row
    for cell_data in @report_data
      @report_string += @row_start
      for i in 0..(longest_row_length-1)
        value = cell_data[i]
        @report_string += @cell_start
        if @filetype == "csv"
          value = value.to_s
          value = value.gsub(/\"/,'""')
          value = '"' + value + '"'
          @report_string += value
        else
          @report_string += clean_for_xml(value)
        end
        @report_string += @cell_end
      end
      @report_string += @row_end
    end
    @report_string += @doc_end
    @report_attribute_list = nil
    @title_array = nil
    @report_data = nil
    @totals_by_att_name = nil
  end

  def generate_attributes_report(filename, entities_list)
    Sketchup.active_model.start_operation 'Generate Report', true
    set_up(filename)
    collect_attributes(entities_list)
    if write_report_string == -1
      return
    end
    path = UI.savepanel "Save Report", nil, @filename
    if (path and path.split('.').last == @filetype)
      begin
        file = File.new(path, "w")
        file.print @report_string 
      rescue 
        msg = "There was an error saving your report.\n" +
          "Please make sure it is not open in any other software " +
          "and try again."
      ensure
        file.close
      end        
    elsif path.nil == false
      UI.messagebox "You Have changed the filetype in the save dialog, please try again."      
    end
    Sketchup.active_model.commit_operation
  end
end

if( not $attribute_reporter_loaded )
  attr_reporter = AttrReporter.new
  plugins_menu = UI.menu "Plugins"
  plugins_menu.add_item("Generate Model Attribute Report as HTML") {
    attr_reporter.generate_attributes_report("report.html", Sketchup.active_model.entities)
  }
  plugins_menu.add_item("Generate Model Attribute Report as CSV") {
    attr_reporter.generate_attributes_report("report.csv", Sketchup.active_model.entities)
  }
  UI.add_context_menu_handler do |context_menu| 
    context_menu.add_separator
      context_menu.add_item('Generate Selection Attributes Report -> HTML') do
        attr_reporter.generate_attributes_report("report.html", Sketchup.active_model.selection)
      end
      context_menu.add_item('Generate Selection Attributes Report -> CSV') do
        attr_reporter.generate_attributes_report("report.csv", Sketchup.active_model.selection)
      end
  end
  $attribute_reporter_loaded = true
end