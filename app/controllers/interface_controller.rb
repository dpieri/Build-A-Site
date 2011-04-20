class InterfaceController < ApplicationController
  
  @@site_type = :webapp
  @@color_1 = [223, 125, 34]
  @@color_2 = [0, 187, 76]
  @@color_3 = [16, 42, 109]

  @@gradients = {:social => "medium", :webapp => "low", :b2b => "low", :lifestyle => "medium", :mobile => "low", :service => "medium", :platform => "medium"}
  @@button_corner_radii = {:social => 12, :webapp => 4, :b2b => 4, :lifestyle => 5, :mobile => 7, :service => 5, :platform => 5}
  @@stroke_contrast = {:social => "high", :webapp => "high", :b2b => "high", :lifestyle => "high", :mobile => "high", :service => "medium", :platform => "medium"}
  @@drop_shadow = {:social => true, :webapp => true, :b2b => true, :lifestyle => true, :mobile => false, :service => true, :platform => true}
  @@inner_glow = {:social => false, :webapp => true, :b2b => true, :lifestyle => false, :mobile => false, :service => false, :platform => false}
  @@tb_contrast = {:social => false, :webapp => true, :b2b => true, :lifestyle => false, :mobile => true, :service => false, :platform => true}
  @@hard_top = {:social => true, :webapp => true, :b2b => true, :lifestyle => false, :mobile => true, :service => false, :platform => true}
  @@top_nav = {:social => "distinct", :webapp => "buttons", :b2b => "buttons", :lifestyle => "naked", :mobile => "naked", :service => "distinct", :platform => "naked"}
  
  def show
    params[:type] ? @site_type = params[:type].capitalize : @site_type = @@site_type.id2name.capitalize
    colors
    button_type
    background
    other
  end
  
  def extract_color_from_string(input)
    input = input.sub('rgb(', '').sub(')', '').split(',')
    input.each_with_index do |c,i|
      input[i] = c.to_i
    end
    input
  end
  
  def colors
    params[:accent_color] ? @color_1_a = extract_color_from_string(params[:accent_color]) : @color_1_a = @@color_1
    params[:button_color] ? @color_2_a = extract_color_from_string(params[:button_color]): @color_2_a = @@color_2
    params[:background_color] ? @color_3_a = extract_color_from_string(params[:background_color]): @color_3_a = @@color_3
    
    @color_1 = @color_1_a.join(',')
    @color_2 = @color_2_a.join(',')
    @color_3 = @color_3_a.join(',')
    @color_3_dark = darken @color_3_a, 20
  end
  
  def darken(color, diff)
    dark_color = color.dup
    median_color =color.sort[2]
    median_index = dark_color.index(median_color) #its 3 long so [2] is the median
    dark_color[median_index] = [0, median_color - diff].max
    dark_color = dark_color.join(',')
  end

  def button_type
  	gradient =  @@gradients[@site_type.downcase.to_sym]
  	stroke_contrast = @@stroke_contrast[@site_type.downcase.to_sym]

  	#
  	# Gradient
  	#
  	case gradient
    when "low"
      color_diff = 10
    when "medium"
      color_diff = 15
    when "high"
      color_diff = 20
    else
      color_diff = 0
    end

    @dark_color = darken @color_2_a, color_diff
    @light_color = darken @color_2_a, -color_diff
    # @light_color = @color_2_a.dup
    # @light_color[median_index] = [255, median_color + color_diff].min
    # @light_color = @light_color.join(',')

    puts "colors: #{@dark_color.inspect} #{@light_color.inspect}"

    #
  	# Corner Radius
  	#
    @corner_radius = @@button_corner_radii[@site_type.downcase.to_sym]
    puts "corner radius: #{@corner_radius}"

    #
  	# Stroke
  	#
    case stroke_contrast
    when "low"
      color_diff = 10
    when "medium"
      color_diff = 15
    when "high"
      color_diff = 20
    else
      color_diff = 0
    end
    @stroke = @color_2_a.map {|c| [0, c - color_diff].max}.join(',')
    puts "stroke: #{@stroke.inspect}"

    #
  	# Drop Shadow
  	#
  	@drop_shadow = @@drop_shadow[@site_type.downcase.to_sym]

  	#
  	# Inner Glow
  	#
  	@inner_glow = @@inner_glow[@site_type.downcase.to_sym]
  	
  end
  
  def background
    #
  	# TB Contrast
  	#
    params[:type] ? @tb_contrast = @@tb_contrast[params[:type].to_sym] : @tb_contrast = @@tb_contrast[@@site_type]
    @tb_contrast = true if params[:mobile] == "1"
    
    #
  	# Texture
  	#
  	@texture = params[:mobile] == "1"
  	
  	#
  	# Hard Sides
  	#
  	@hard_sides = params[:type] == 'lifestyle'
  	@hard_sides = false if params[:mobile] == "1"
  end
  
  def other
    #
  	# Mobile
  	#
    @mobile = params[:mobile] == "1"
    
    #
  	# Hard Top
  	#
  	params[:type] ? @hard_top = @@hard_top[params[:type].to_sym] : @hard_top = @@hard_top[@@site_type]
  	
  	#
  	# Top Nav
  	#
  	params[:type] ? @top_nav = @@top_nav[params[:type].to_sym] : @top_nav = @@top_nav[@@site_type]
  end

end
