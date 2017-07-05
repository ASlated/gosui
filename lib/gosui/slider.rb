module Gosui
  class Slider

    PWIDTH = 20 * @scale
    QHEIGHT = 15 * @scale
    THEIGHT = 10 * @scale
    PHEIGHT = (QHEIGHT + THEIGHT) * @scale
    MARGIN = 5 * @scale
    LHEIGHT = 5 * @scale

    C = Gosu::Color.rgb(128, 128, 128)
    FONT_SIZE = 20 * @scale

    def initialize(window, x, y, z, length, max, min: 0, pos: 0.0, markers: 0, color: C, text: true, scale: 1, label: nil)
      @win = window
      @x, @y, @z = x, y, z
      @l = length
      @max, @min = max, min
      @pos = pos.to_f
      @markers = markers
      @col = color
      @text = text
      @scale = scale
      @label = label
      @dragging = false
      @font = Gosu::Font.new(FONT_SIZE, {name: 'slider_font'})
      @selectorx = @x + @pos * @l - PWIDTH / 2
      @selectory = @y + MARGIN + LHEIGHT
      @dir = 'up'
      @dragging = false
    end

    def value(pos = @pos)
      (@max - @min) * pos + @min
    end

    def max; @max; end
    def min; @min; end

    def check_clicking
      if @win.button_down?(Gosu::MsLeft)
        if !@already_down && check_mouse(@win.mouse_x, @win.mouse_y, @selectorx, @selectory - PHEIGHT, @selectorx + PWIDTH, @selectory)
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
      @selectorx = @x + @pos * @l - PWIDTH / 2
      @selectory = @y + MARGIN + LHEIGHT
    end

    def draw_pointer
      x, y = @selectorx, @selectory
      @win.draw_quad(x, y - PHEIGHT, @col, x + PWIDTH, y - PHEIGHT, @col, x, y - THEIGHT, @col, x + PWIDTH, y - THEIGHT, @col, @z)
      @win.draw_triangle(x, y - THEIGHT, @col, x + PWIDTH / 2, y, @col, x + PWIDTH, y - THEIGHT, @col, @z)
    end

    def draw_bar
      @win.draw_quad(@x, @y, @col, @x + @l, @y, @col, @x, @y + LHEIGHT, @col, @x + @l, @y + LHEIGHT, @col, @z)
      @win.draw_quad(@x, @y - LHEIGHT, @col, @x + LHEIGHT, @y - LHEIGHT, @col, @x, @y, @col, @x + LHEIGHT, @y, @col, @z)
      @win.draw_quad(@x + @l - LHEIGHT, @y - LHEIGHT, @col, @x + @l, @y - LHEIGHT, @col, @x + @l - LHEIGHT, @y, @col, @x + @l, @y, @col, @z)
    end

    def draw_markers
      @markers.times do |i|
        pos = (i + 1).to_f / (@markers + 1).to_f
        @win.draw_quad(pos * @l + @x - 0.5 * LHEIGHT, @y - LHEIGHT, @col, pos * @l + @x + 0.5 * LHEIGHT, @y - LHEIGHT, @col, pos * @l + @x - 0.5 * LHEIGHT, @y, @col, pos * @l + @x + 0.5 * LHEIGHT, @y, @col, @z)
        @font.draw_rel(value(pos).round, pos * @l + @x, @y + LHEIGHT + MARGIN, @z, 0.5, 0, 1, 1, @col) if @text
      end
    end

    def draw_text
      @font.draw(min.round, @x, @y + LHEIGHT + MARGIN, @z, 1, 1, @col)
      @font.draw_rel(max.round, @x + @l, @y + LHEIGHT + MARGIN, @z, 1, 0, 1, 1, @col)
      @font.draw_rel(value.round, @x + @l, @y - MARGIN - QHEIGHT, @z, 1, 1, 1, 1, @col)
      @font.draw_rel(@label, @x, @y - MARGIN - QHEIGHT, @z, 0, 1, 1, 1, @col)
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
