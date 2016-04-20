class CSV_Interface
  attr_accessor :path , :focus_s, :focus_r
  attr_reader :read_options, :units, :foci, :data, :valid

  def initialize(path, read_options = {}, units = {}, foci = {}, focus_s = '', focus_r = '')
    @data = Array.new() { Array.new }
    @path = path
    @valid = false
    read_data_set(read_options, units, foci, focus_s, focus_r)
  end

  def read_data_set(read_options = {}, units = {}, foci = {}, focus_s = '', focus_r = '')
    if File.exists?(@path)
      @data = Array.new() { Array.new }
      @read_options = Hash.new()
      @read_options['headers'] = read_options.has_key?('headers') ? read_options['headers'] : true
      @read_options['split_symbol'] = read_options.has_key?('split_symbol') ? read_options['split_symbol'] : ','
      @read_options['alert_symbol'] = read_options.has_key?('alert_symbol') ? read_options['alert_symbol'] : '"'
      @read_options['foci_from_csv'] = read_options.has_key?('foci_from_csv') ? read_options['foci_from_csv'] : true
      @read_options['set_std_foci'] = read_options.has_key?('set_std_foci') ? read_options['set_std_foci'] : true
      @read_options['units_in_header'] = read_options.has_key?('units_in_header') ? read_options['units_in_header'] : true
      @read_options['units_identifier'] = read_options.has_key?('units_identifier') ? read_options['units_identifier'] : ['(',')']
      read_csv()
      @units = !@read_options['units_in_header'] ? untis : {}
      if !@read_options['units_in_header'] && untis == nil
        (0 .. @data[0].length).each do |e|
	        untis[e] = ' '
	      end
      end
      if @read_options['units_in_header']
	      read_units_from_csv()
      end
      @foci = !@read_options['foci_from_csv'] ? foci : {}
      if !@read_options['foci_from_csv'] && foci == nil
    	  (0 .. @data[0].length).each do |e|
          foci[e.to_s] = e
   	    end
      end
      if @read_options['foci_from_csv']
   	    read_foci_from_csv()
      end
      temp = @foci.keys
      @focus_s = !@read_options['set_std_foci'] ? (@foci.has_key?(focus_s) ? focus_s : temp[0]) : ""
      @focus_r = !@read_options['set_std_foci'] ? (@foci.has_key?(focus_r) ? focus_r : temp[1]) : ""
      if @read_options['set_std_foci']
        set_std_foci()
      end
      @valid = true
    end
  end

  def read_csv()
    raw_data = File.read(@path).split("\n")
    temp = ""
    raw_data.each_with_index do |raw_row, i|
      temp_data = []
      temp = raw_row.split(@read_options['alert_symbol'])
      if temp.length > 1
        temp.each do |e|
          if e[0] == @read_options['split_symbol'] || e[-1] == @read_options['split_symbol']
            e.split(@read_options['split_symbol']).each do |d|
              temp_data << d
	    end
          else
            temp_data << e
          end
        end
      else
        temp[0].split(@read_options['split_symbol']).each do |d|
          temp_data << d
        end
      end
      @data[i] = temp_data
    end
    @data.shift
  end

  def read_units_from_csv
    raw_data = File.read(@path).split("\n")
    raw_foci = raw_data[0].split(@read_options['split_symbol'])
    @units = Hash.new()
    raw_foci.each_with_index do |focus,i|
      if focus[@read_options['units_identifier'][0].to_s] && focus[@read_options['units_identifier'][1].to_s]
        start_index = focus.index(@read_options['units_identifier'][0])
	      end_index = focus.index(@read_options['units_identifier'][1])
	      @units[i] = focus[start_index+1..end_index-1]
      else
        @units[i] = ' '
      end
     end
  end

  def read_foci_from_csv
    raw_data = File.read(@path).split("\n")
    raw_foci = raw_data[0].split(@read_options['split_symbol'])
    @foci = Hash.new()
    raw_foci.each_with_index do |focus,i|
      if focus[@read_options['units_identifier'][0].to_s] && focus[@read_options['units_identifier'][1].to_s]
        focus.slice! (@read_options['units_identifier'][0] + @units[i] + @read_options['units_identifier'][1]).to_s
      end
      @foci[focus.to_s.downcase.split.join] = i
    end
  end

  def set_std_foci()
    foci = @foci.keys
    @focus_s = foci[0].to_s
    @focus_r = foci[1].to_s
  end

  def get_data(input)
    data = []
    @data.each do |e|
      if e[@foci[@focus_s]] == input.downcase
        data << e[@foci[@focus_r]]  + ' ' + @units[i]
      end
    end
    return data.length > 0 ? data.uniq.sort : nil
  end

  def get_specific_data(focus_s, input, focus_r)
    data = []
    if @foci.has_key?(focus_s) && @foci.has_key?(focus_r)
      @data.each do |e|
        if e[@foci[focus_s]].to_s.downcase == input.downcase
          data << (e[@foci[focus_r]].to_s + @units[@foci[focus_r]].to_s)
	end
      end
      data = data.uniq.sort
    elsif @foci.has_key?(focus_s) && focus_r == 'all'
      @data.each do |e|
        if e[@foci[focus_s]].to_s.downcase == input.downcase
          @foci.each do |k,v|
            data << (k.to_s.capitalize + ": " + e[v] + @units[v].to_s)
          end
        end
      end
    end
    return data.length > 0 ? data : nil
  end

  def get_focus_data(focus, input)
    data = []
    if @foci.has_key?(focus)
      @data.each do |e|
        if input != nil
          if e[@foci[focus]] != nil && e[@foci[focus]][0..(input.length - 1)].downcase == input.to_s.downcase
            data << (e[@foci[focus]].to_s + @units[@foci[focus_r]].to_s)
          end
        else
          data << (e[@foci[focus]].to_s + @units[@foci[focus_r]].to_s)
        end
      end
    end
    return data.uniq.length > 0 ? data.uniq.sort : nil
  end

  def debug_readout()
    out = Hash.new() { |h,k| h[k] = [] }
    @data.each do |e|
      out['DATA'] << e.to_s
    end
    @foci.each do |k,v|
      out['FOCI'] << v.to_s + ': ' + k
    end
    @units.each do |k,v|
      out['UNITS'] << k.to_s + ': ' + v.to_s
    end
    out['STD FOCI'] << "focus s: " + @focus_s.to_s
    out['STD FOCI'] <<  "focus r: " + @focus_r.to_s

    return out
  end
end
