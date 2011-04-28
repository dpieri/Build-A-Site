module ColorHelper
  
  # Converts an RGB color value to HSV. Conversion formula
  # adapted from http://en.wikipedia.org/wiki/HSV_color_space.
  # Assumes r, g, and b are contained in the set [0, 255] and
  # returns h, s, and v in the set [0, 1].
  # 
  # @param   Number  r       The red color value
  # @param   Number  g       The green color value
  # @param   Number  b       The blue color value
  # @return  Array           The HSV representation
  def self.rgb_to_hsv(color)
    r = color[0].to_f
    g = color[1].to_f
    b = color[2].to_f
    
    r = r/255 and g = g/255 and b = b/255
    
    max = [r, g, b].max
    min = [r, g, b].min
    h, s, v = max, max, max

    d = max - min
    s = max == 0 ? 0 : d / max
    
    if max == min
      h = 0 # achromatic
    else
      case max
      when r
        h = (g - b) / d + (g < b ? 6 : 0)
      when g
        h = (b - r) / d + 2
      when b
        h = (r - g) / d + 4
      end
      
      h = h*0.6
    end
    
    [h*100, s, v]
  end
  
  def self.hsvToRGB(hsv)
		h, s, v = hsv
		hi = (h/60.0).floor % 6
		f = h/60.0 - (h/60.0).floor
		p = (v * (1 - s))
		q = (v * (1 - f * s))
		t = (v * (1 - (1 - f) * s) )
		
    v = (v*255).to_i
    t = (t*255).to_i
    p = (p*255).to_i
    q = (q*255).to_i
		@rgb = []
		case hi
			when 0
        @rgb = [v, t, p]
			when 1
				@rgb = [q, v, p]
			when 2
				@rgb = [p, v, t]
			when 3
				@rgb = [p, q, v]
			when 4
				@rgb = [t, p, v]
			when 5
        @rgb = [v, p, t]
  	end
  	return @rgb
	end
  
  def self.extract_color_from_string(input)
    input = input.sub('rgb(', '').sub(')', '').split(',')
    input.each_with_index do |c,i|
      input[i] = c.to_i
    end
    input
  end
  
  def self.darken(color, diff, is_button)
    return [color[0], [color[1], 0.5].max, [0, [255, (color[2] - diff)].min].max ] if is_button
    return [color[0], color[1], [0, [255, (color[2] - diff)].min].max ] if !is_button
  end
  
end
