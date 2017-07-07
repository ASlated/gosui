module Gosui
  class TextInput

    FONT_SIZE = 20

    B = Gosu::Color.rgb(0, 0, 0)
    W = Gosu::Color.rgb(255, 255, 255)
    G = Gosu::Color.rgb(192, 192, 192)

    def initialize(window, x, y, z, callback: :puts, font_size: FONT_SIZE, length: 200, placeholder: '', layout: 'qwerty')
      @win = window
      @x, @y, @z = x, y, z
      @callback = @win.method(callback)
      @font_size = font_size
      @length = length
      @placeholder = placeholder

      @timer = Gosu::milliseconds
      @height = @font_size
      @margin = 0.15 * @height
      @value = ''
      @font = Gosu::Font.new(@font_size, {name: 'button_font'})
      @qwerty = [{code: Gosu::KB_RIGHT_SHIFT, val: 'shift'}, {code: Gosu::KB_LEFT_SHIFT, val: 'shift'}, {code: Gosu::KB_SPACE, val: ' '}, {code: Gosu::KB_A, val: 'a'}, {code: Gosu::KB_B, val: 'b'}, {code: Gosu::KB_C, val: 'c'}, {code: Gosu::KB_D, val: 'd'}, {code: Gosu::KB_E, val: 'e'}, {code: Gosu::KB_F, val: 'f'}, {code: Gosu::KB_G, val: 'g'}, {code: Gosu::KB_H, val: 'h'}, {code: Gosu::KB_I, val: 'i'}, {code: Gosu::KB_J, val: 'j'}, {code: Gosu::KB_K, val: 'k'}, {code: Gosu::KB_L, val: 'l'}, {code: Gosu::KB_M, val: 'm'}, {code: Gosu::KB_N, val: 'n'}, {code: Gosu::KB_O, val: 'o'}, {code: Gosu::KB_P, val: 'p'}, {code: Gosu::KB_Q, val: 'q'}, {code: Gosu::KB_R, val: 'r'}, {code: Gosu::KB_S, val: 's'}, {code: Gosu::KB_T, val: 't'}, {code: Gosu::KB_U, val: 'u'}, {code: Gosu::KB_V, val: 'v'}, {code: Gosu::KB_W, val: 'w'}, {code: Gosu::KB_X, val: 'x'}, {code: Gosu::KB_Y, val: 'y'}, {code: Gosu::KB_Z, val: 'z'}, {code: Gosu::KB_0, val: '0'}, {code: Gosu::KB_1, val: '1'}, {code: Gosu::KB_2, val: '2'}, {code: Gosu::KB_3, val: '3'}, {code: Gosu::KB_4, val: '4'}, {code: Gosu::KB_5, val: '5'}, {code: Gosu::KB_6, val: '6'}, {code: Gosu::KB_7, val: '7'}, {code: Gosu::KB_8, val: '8'}, {code: Gosu::KB_9, val: '9'}, {code: Gosu::KB_COMMA, val: ','}, {code: Gosu::KB_PERIOD, val: '.'}, {code: 56, val: '/'}, {code: Gosu::KB_SEMICOLON, val: ';'}, {code: Gosu::KB_BACKSPACE, val: 'delete'}].each { |i| i[:down] = false }
      @dvorak = [{code: Gosu::KB_RIGHT_SHIFT, val: 'shift'}, {code: Gosu::KB_LEFT_SHIFT, val: 'shift'}, {code: Gosu::KB_SPACE, val: ' '}, {code: Gosu::KB_A, val: 'a'}, {code: Gosu::KB_B, val: 'x'}, {code: Gosu::KB_C, val: 'j'}, {code: Gosu::KB_D, val: 'e'}, {code: Gosu::KB_E, val: '.'}, {code: Gosu::KB_F, val: 'u'}, {code: Gosu::KB_G, val: 'i'}, {code: Gosu::KB_H, val: 'd'}, {code: Gosu::KB_I, val: 'c'}, {code: Gosu::KB_J, val: 'h'}, {code: Gosu::KB_K, val: 't'}, {code: Gosu::KB_L, val: 'n'}, {code: Gosu::KB_M, val: 'm'}, {code: Gosu::KB_N, val: 'b'}, {code: Gosu::KB_O, val: 'r'}, {code: Gosu::KB_P, val: 'l'}, {code: Gosu::KB_Q, val: "\'"}, {code: Gosu::KB_R, val: 'p'}, {code: Gosu::KB_S, val: 'o'}, {code: Gosu::KB_T, val: 'y'}, {code: Gosu::KB_U, val: 'g'}, {code: Gosu::KB_V, val: 'k'}, {code: Gosu::KB_W, val: ','}, {code: Gosu::KB_X, val: 'q'}, {code: Gosu::KB_Y, val: 'f'}, {code: Gosu::KB_Z, val: ';'}, {code: Gosu::KB_0, val: '0'}, {code: Gosu::KB_1, val: '1'}, {code: Gosu::KB_2, val: '2'}, {code: Gosu::KB_3, val: '3'}, {code: Gosu::KB_4, val: '4'}, {code: Gosu::KB_5, val: '5'}, {code: Gosu::KB_6, val: '6'}, {code: Gosu::KB_7, val: '7'}, {code: Gosu::KB_8, val: '8'}, {code: Gosu::KB_9, val: '9'}, {code: Gosu::KB_COMMA, val: 'w'}, {code: Gosu::KB_PERIOD, val: 'v'}, {code: 56, val: 'z'}, {code: Gosu::KB_SEMICOLON, val: 's'}, {code: Gosu::KB_BACKSPACE, val: 'delete'}].each { |i| i[:down] = false }
      keyboard_layout(layout)
    end

    def keyboard_layout(layout)
      case layout
      when 'qwerty'
        @layout = @qwerty
      when 'dvorak'
        @layout = @dvorak
      end
    end

    def check_clicking
      if check_mouse(@win.mouse_x, @win.mouse_y, @x, @y, @x + @length, @y + @height)
        @selected = true
        @blinker = true
      else
        @selected = false
      end
    end

    def get_text_input
      shift = false
      @layout.each do |i|
        if @win.button_down?(i[:code])
          shift = true if i[:val] == 'shift'
          unless i[:down]
            reset_timer
            case i[:val]
            when 'delete'
              @value.slice!(-1)
            when 'shift'
            else
              if shift
                @value += i[:val].upcase
              else
                @value += i[:val]
              end
            end
            i[:down] = true
          end
        else
          i[:down] = false
        end
      end
    end

    def blinker_timer
      @timer += 1
      @timer = Gosu::milliseconds if @timer > Gosu::milliseconds
      if Gosu::milliseconds >= @timer + 500
        @blinker = @blinker^
        @timer = Gosu::milliseconds
      end
    end

    def reset_timer
      @timer = Gosu::milliseconds
      @blinker = true
    end

    def update
      check_clicking if @win.button_down?(Gosu::MsLeft)
      get_text_input if @selected
      blinker_timer
    end

    def draw_text
      @font.draw_rel(@placeholder, @x + @margin, @y + @height / 2, @z, 0, 0.5, 1, 1, G) if @value == ''
      if @selected
        @font.draw_rel(@value + '|', @x + @margin, @y + @height / 2, @z, 0, 0.5, 1, 1, B) if @blinker
        @font.draw_rel(@value, @x + @margin, @y + @height / 2, @z, 0, 0.5, 1, 1, B) if !@blinker
      else
        @font.draw_rel(@value, @x + @margin, @y + @height / 2, @z, 0, 0.5, 1, 1, B) if @value != ''
      end
    end

    def draw
      @win.draw_quad(@x, @y, B, @x + @length, @y, B, @x, @y + @height, B, @x + @length, @y + @height, B, @z)
      @win.draw_quad(@x + 2, @y + 2, W, @x + @length - 2, @y + 2, W, @x + 2, @y + @height - 2, W, @x + @length - 2, @y + @height - 2, W, @z)
      draw_text
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
