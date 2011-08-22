module Window
	def self.draw_line(x1, y1, x2, y2, c, z =0)
		pixel = Image.new(1, 1, c)
		sx = Math.sqrt(((x1-x2)**2) + ((y1 - y2)**2))
		angle = Math.atan2(y2 - y1, x2 - x1) / Math::PI * 180
		Window.drawEx((x2 + x1) / 2, (y2 + y1) / 2, pixel,
			:scalex => sx, :scaley => 1,
			:centerx => 0.5, :centery => 0.5,
			:angle => angle, :z => z)
	end
end