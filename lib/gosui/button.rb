module Gosui
  class Button

    WIDTH = 120
    HEIGHT = 80
    FONT_SIZE = 20

    UP_COL = Gosu::Color.rgb(128, 128, 128)
    DOWN_COL = Gosu::Color.rgb(96, 96, 96)
    TEXT_COL = Gosu::Color.rgb(0, 0, 0)

    def initialize(window, x, y, z, callback, width: WIDTH, height: HEIGHT, label: nil, font_size: FONT_SIZE, down_color: DOWN_COL, up_color: UP_COL, text_color: TEXT_COL)
      @win = window
      @x, @y, @z = x, y, z
      @callback = @win.method(callback)
      @label = label

      @width, @height = width, height
      @font_size = font_size
      @down_col, @up_col = down_color, up_color
      @text_col = text_color

      @font = Gosu::Font.new(@font_size, {name: 'button_font'})
      @clicking = false
    end

    def check_clicking
      if @win.button_down?(Gosu::MsLeft)
        if !@already_down && check_mouse(@win.mouse_x, @win.mouse_y, @x, @y, @x + @width, @y + @height)
          @clicking = true
        else
          @clicking = false
          @already_down = true
        end
      else
        @already_down = false
        @clicking = false
      end
    end

    def update
      @callback.call if @clicking && !@win.button_down?(Gosu::MsLeft)
      check_clicking
    end

    def draw_button
      if @clicking
        col = @down_col
      else
        col = @up_col
      end
      @win.draw_quad(@x, @y, col, @x + @width, @y, col, @x, @y + @height, col, @x + @width, @y + @height, col, @z)
    end

    def draw_label
      @font.draw_rel(@label, @x + @width / 2, @y + @height / 2, @z, 0.5, 0.5, 1, 1, @text_col)
    end

    def draw
      draw_button
      draw_label if @label
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
