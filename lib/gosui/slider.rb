module Gosui
  class Slider

    PWIDTH = 20
    QHEIGHT = 15
    THEIGHT = 10
    PHEIGHT = QHEIGHT + THEIGHT
    MARGIN = 5
    LHEIGHT = 5
    FONT_SIZE = 20

    C = Gosu::Color.rgb(128, 128, 128)

    attr_reader :max, :min
    def initialize(window, x, y, z, length, max, min: 0, value: 0, markers: 0, color: C, text: true, scale: 1, label: nil, percentage: false)
      @win = window
      @x, @y, @z = x, y, z
      @l = length
      @max, @min = max, min
      @markers = markers
      @col = color
      @text = text
      @label = label
      @percentage = percentage

      @pwidth = PWIDTH * scale
      @qheight = QHEIGHT * scale
      @theight = THEIGHT * scale
      @pheight = PHEIGHT * scale
      @margin = MARGIN * scale
      @lheight = LHEIGHT * scale
      @font_size = FONT_SIZE * scale

      if value == 0
        @pos = 0.0
      else
        @pos = (value.to_f - @min) / (@max - @min)
      end
      @dragging = false
      @dragging = false
      @font = Gosu::Font.new(@font_size, {name: 'slider_font'})
      @selectorx = @x + @pos * @l - PWIDTH / 2
      @selectory = @y + @margin + @lheight
    end

    def value(pos = @pos)
      (@max - @min) * pos + @min
    end

    def check_clicking
      if @win.button_down?(Gosu::MsLeft)
        if !@already_down && check_mouse(@win.mouse_x, @win.mouse_y, @selectorx, @selectory - @pheight, @selectorx + @pwidth, @selectory)
          @dragging = true
        else
          @already_down = true
        end
      else
        @already_down = false
        @dragging = false
      end
    end

    def drag
      if @win.mouse_x < @x
        @pos = 0
      elsif @win.mouse_x > @x + @l
        @pos = 1
      else
        @pos = (@win.mouse_x - @x) / @l
      end
    end

    def update
      check_clicking
      drag if @dragging
      @selectorx = @x + @pos * @l - @pwidth / 2
      @selectory = @y + @margin + @lheight
    end

    def draw_pointer
      x, y = @selectorx, @selectory
      @win.draw_quad(x, y - @pheight, @col, x + @pwidth, y - @pheight, @col, x, y - @theight, @col, x + @pwidth, y - @theight, @col, @z)
      @win.draw_triangle(x, y - @theight, @col, x + @pwidth / 2, y, @col, x + @pwidth, y - @theight, @col, @z)
    end

    def draw_bar
      @win.draw_quad(@x, @y, @col, @x + @l, @y, @col, @x, @y + @lheight, @col, @x + @l, @y + @lheight, @col, @z)
      @win.draw_quad(@x, @y - @lheight, @col, @x + @lheight, @y - @lheight, @col, @x, @y, @col, @x + @lheight, @y, @col, @z)
      @win.draw_quad(@x + @l - @lheight, @y - @lheight, @col, @x + @l, @y - @lheight, @col, @x + @l - @lheight, @y, @col, @x + @l, @y, @col, @z)
    end

    def draw_markers
      @markers.times do |i|
        pos = (i + 1).to_f / (@markers + 1).to_f
        @win.draw_quad(pos * @l + @x - 0.5 * @lheight, @y - @lheight, @col, pos * @l + @x + 0.5 * @lheight, @y - @lheight, @col, pos * @l + @x - 0.5 * @lheight, @y, @col, pos * @l + @x + 0.5 * @lheight, @y, @col, @z)
        @font.draw_rel(value(pos).round, pos * @l + @x, @y + @lheight + @margin, @z, 0.5, 0, 1, 1, @col) if @text
      end
    end

    def draw_text
      @font.draw(min.round, @x, @y + @lheight + @margin, @z, 1, 1, @col)
      @font.draw_rel(max.round, @x + @l, @y + @lheight + @margin, @z, 1, 0, 1, 1, @col)
      if @percentage
        @font.draw_rel("#{value.round}%", @x + @l, @y - @margin - @qheight, @z, 1, 1, 1, 1, @col)
      else
        @font.draw_rel(value.round, @x + @l, @y - @margin - @qheight, @z, 1, 1, 1, 1, @col)
      end
      @font.draw_rel(@label, @x, @y - @margin - @qheight, @z, 0, 1, 1, 1, @col)
    end

    def draw
      draw_pointer
      draw_bar
      draw_markers
      draw_text if @text
    end

    def check_mouse(mouse_x, mouse_y, x1, y1, x2, y2)
      if mouse_x > x1 && mouse_x < x2 && mouse_y > y1 && mouse_y < y2
        true
      else
        false
      end
    end

  end
end
