class InterfaceController < ApplicationController
  
  @@site_type = :webapp
  @@color_1 = [80, 112, 255] #[113, 255, 80] #[235, 133, 0]  
  @@color_2 = [235, 133, 0]
  @@color_3 = [0, 96, 15]  #[255, 80, 192]  rgb(80, 112, 255)

  @@gradients = {:social => "medium", :webapp => "low", :b2b => "low", :lifestyle => "medium", :mobile => "low", :service => "medium", :platform => "medium"}
  @@button_corner_radii = {:social => 12, :webapp => 4, :b2b => 4, :lifestyle => 5, :mobile => 7, :service => 5, :platform => 5}
  @@stroke_contrast = {:social => "high", :webapp => "high", :b2b => "high", :lifestyle => "high", :mobile => "high", :service => "medium", :platform => "medium"}
  @@drop_shadow = {:social => true, :webapp => true, :b2b => true, :lifestyle => true, :mobile => false, :service => true, :platform => true}
  @@inner_glow = {:social => false, :webapp => true, :b2b => true, :lifestyle => false, :mobile => false, :service => false, :platform => false}
  @@tb_contrast = {:social => false, :webapp => true, :b2b => true, :lifestyle => false, :mobile => true, :service => false, :platform => true}
  @@hard_top = {:social => true, :webapp => true, :b2b => true, :lifestyle => false, :mobile => true, :service => false, :platform => true}
  @@top_nav = {:social => "distinct", :webapp => "buttons", :b2b => "buttons", :lifestyle => "naked", :mobile => "naked", :service => "distinct", :platform => "naked"}
  
  def show
    params[:type] ? @site_type = params[:type] : @site_type = @@site_type.id2name
    types
    colors false
    button_type
    background
    nav
  end
  
  def get_css
    params[:type] ? @site_type = params[:type] : @site_type = @@site_type.id2name
    types
    colors true
    button_type
    background
    nav
  end
  
  def colors(is_raw_color)
    if is_raw_color
      params[:accent_color] ? @color_1_a = params[:accent_color].split(',') : @color_1_a = @@color_1
      params[:button_color] && params[:button_color_customized] == 'true' ? @color_2_a = params[:button_color].split(',') : @color_2_a = @@color_2
      params[:background_color] && params[:button_color_customized] == 'true' ? @color_3_a = params[:background_color].split(',') : @color_3_a = @@color_3
    else
      params[:accent_color] ? @color_1_a = ColorHelper::extract_color_from_string(params[:accent_color]) : @color_1_a = @@color_1
      params[:button_color] && params[:button_color_customized] == 'true' ? @color_2_a = ColorHelper::extract_color_from_string(params[:button_color]): @color_2_a = @@color_2
      params[:background_color] && params[:button_color_customized] == 'true' ? @color_3_a = ColorHelper::extract_color_from_string(params[:background_color]): @color_3_a = @@color_3
    end

    @color_1 = @color_1_a.join(',')
    @color_2 = @color_2_a.join(',')
    @color_3 = @color_3_a.join(',')
    
    color = ColorHelper::rgb_to_hsv @color_1_a
    
    h1 = (color[0] + 320) % 360  #80
    h2 = (color[0] + 140) % 360 #260
    h3 = (color[0]) % 360 #120
    
    # color_1_hsv = [h3, color[1], color[2]]
    # @color_1_a = hsvToRGB(color_1_hsv)
    # @color_1 = @color_1_a.join(',')
    
    color_2_hsv = ColorHelper::rgb_to_hsv @color_2.split(',')
    unless params[:button_color_customized] == 'true'
      color_2_hsv = [h2, color[1], color[2]]
      @color_2_a = ColorHelper::hsvToRGB(color_2_hsv)
      @color_2 = @color_2_a.join(',')
    end
    
    color_3_hsv = ColorHelper::rgb_to_hsv @color_3.split(',')
    unless params[:background_color_customized] == 'true'
      color_3_hsv = [h1, color[1], color[2]]
      @color_3_a =  ColorHelper::hsvToRGB(color_3_hsv)
      @color_3 = @color_3_a.join(',')
    end
    
    @color_3_dark = ColorHelper::hsvToRGB(darken @color_3_a, 0.40)
    
    @dark_background = color_3_hsv[1] > 0.8
    @background_color_customized = params[:background_color_customized] == 'true'
    @button_color_customized = params[:button_color_customized] == 'true'
    
    #
  	# Gradient
  	#
  	gradient =  @@gradients[@site_type.downcase.to_sym]
  	case gradient
    when "low"
      color_diff = 0.10
    when "medium"
      color_diff = 0.15
    when "high"
      color_diff = 0.20
    else
      color_diff = 0
    end

    @dark_color = ColorHelper::hsvToRGB(darken color_2_hsv, 2*color_diff).join(',')
    @light_color = ColorHelper::hsvToRGB(darken color_2_hsv, -color_diff).join(',')
    
    
    #
  	# Stroke
  	#
  	stroke_contrast = @@stroke_contrast[@site_type.downcase.to_sym]
    case stroke_contrast
    when "low"
      color_diff = 0.10
    when "medium"
      color_diff = 0.15
    when "high"
      color_diff = 0.20
    else
      color_diff = 0
    end
    @stroke = darken color_2_hsv, color_diff
  end
  
  def darken(color, diff)    
    [color[0], color[1], [0, [255, (color[2] - diff)].min].max ]      
  end
  
  def types
    @b2b = @site_type == 'b2b'
    @webapp = @site_type == 'webapp'
    @social = @site_type == 'social'
    @lifestyle = @site_type == 'lifestyle'
    @mobile = params[:mobile] == "1"
  end

  def button_type
    #
  	# Corner Radius
  	#
    @corner_radius = @@button_corner_radii[@site_type.to_sym]

    #
  	# Drop Shadow
  	#
  	@drop_shadow = @@drop_shadow[@site_type.to_sym]

  	#
  	# Inner Glow
  	#
  	@inner_glow = @@inner_glow[@site_type.to_sym]
  	
  end
  
  def background
    #
  	# TB Contrast
  	#
    @tb_contrast = @@tb_contrast[@site_type.to_sym]
    @tb_contrast = true if params[:mobile] == "1"
    
    #
  	# Texture
  	#
  	@texture = params[:mobile] == "1" || params[:type] == 'webapp' || params[:type].nil?
    # @texture_image = ['text_2.png', 'text_3.png', 'text_4.png'].sample
  	@texture_image = 'text_4.png'
  	
  	#
  	# Hard Sides
  	#
  	@hard_sides = @lifestyle
  	@hard_sides = false if params[:mobile] == "1"
  end
  
  def nav
    #
  	# Hard Top
  	#
    @hard_top = @@hard_top[@site_type.to_sym]
  	
  	#
  	# Top Nav
  	#
  	@top_nav = @@top_nav[@site_type.to_sym]
  end

end
