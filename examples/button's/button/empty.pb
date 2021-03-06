﻿
CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/widget"
  XIncludeFile "include/fixme(mac).pbi"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux 
  IncludePath "/media/sf_as/Documents/GitHub/widget"
  XIncludeFile "include/fixme(lin).pbi"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows 
  IncludePath "Z:/Documents/GitHub/widget"
  ;IncludePath "C:\Users\as\Desktop\Widget_15_08_2020"
  XIncludeFile "include/fixme(win).pbi"
CompilerEndIf


CompilerIf Not Defined(func, #PB_Module)
  XIncludeFile "include/func.pbi"
CompilerEndIf

CompilerIf Not Defined(constants, #PB_Module)
  XIncludeFile "include/constants.pbi"
CompilerEndIf

CompilerIf Not Defined(structures, #PB_Module)
  XIncludeFile "include/structures.pbi"
CompilerEndIf

CompilerIf Not Defined(colors, #PB_Module)
  XIncludeFile "include/colors.pbi"
CompilerEndIf


CompilerIf Not Defined(widget, #PB_Module)
  ;-  >>>
  DeclareModule widget
    EnableExplicit
    UseModule constants
    UseModule structures
    ;UseModule functions
    
    CompilerIf Defined(fixme, #PB_Module)
      UseModule fixme
    CompilerEndIf
    
    Global _macro_call_count_
    Macro Debugger(_text_="")
      CompilerIf #PB_Compiler_Debugger  ; Only enable assert in debug mode
        Debug  " " +_macro_call_count_ +_text_+ "   (debug >> "+ #PB_Compiler_Procedure +" ( "+#PB_Compiler_Line +" ))"
        _macro_call_count_ + 1
      CompilerEndIf
    EndMacro
    
    Macro _get_colors_()
      colors::*this\blue
    EndMacro
    
    Macro PB(Function)
      Function
    EndMacro
    
    Macro This()
      structures::*event
    EndMacro
    
    Macro Root()
      This()\_root()
    EndMacro
    
    Macro Widget() ; Returns last created widget 
      This()\_childrens()
    EndMacro
    
    ;     Macro children(_this_) ;  
    ;       Bool(widget() And child(widget(), _this_))
    ;     EndMacro
    
    Macro EventIndex()
      This()\widget\index
    EndMacro
    
    Macro WidgetEvent()
      This()\event
    EndMacro
    
    Macro EventWidget()
      This()\widget
    EndMacro
    
    Macro WaitClose(_window_ = #PB_Any, _time_ = 0)
      If Root()
        ReDraw(Root())
      EndIf  
      
      Repeat 
        If WaitWindowEvent(_time_) = #PB_Event_CloseWindow
          If _window_ = #PB_Any 
            If this()\widget\container =- 1
              ;Else
              
              ForEach root()
                Debug root()
                free( root() )
                ;               ForEach widget()
                ;                 Debug ""+widget()\root +" "+ _is_root_(widget())
                ;               Next
              Next
              Break
            EndIf
            
          ElseIf EventGadget() = _window_
            Debug " - close - " +EventWindow() ; +" "+ GetWindow(_window_)
            Free(_window_)
            Break
          ElseIf EventWindow() = _window_ And Post(#PB_EventType_Free, _window_)
            Debug " - close2 - " +EventWindow() ; +" "+ GetWindow(_window_)
            Break
          EndIf
        EndIf
      ForEver
      
      If Root()
        ReDraw(Root())
      EndIf  
    EndMacro
    
    ;-
    Macro Opened()
      Root()\canvas\widget
    EndMacro
    
    Macro Entered() ; Returns mouse entered widget
      Mouse()\widget
    EndMacro
    
    Macro Focused() 
      Keyboard()\widget 
    EndMacro ; Returns keyboard focused widget
    
    Macro Pressed()
      Mouse()\buttons
    EndMacro
    

    ;-
    Macro Mouse()
      This()\mouse
    EndMacro
    
    Macro Keyboard()
      This()\keyboard
    EndMacro
    
    Macro Repaints()
      ForEach root()
        ;  ReDraw(Root())
        Post(#PB_EventType_Repaint, Root()) ;This()\widget\root)
      Next
    EndMacro
    
    ;-
    Macro _structure_(_struct_name_)
      _s_#_struct_name_ = AllocateStructure(_s_#_struct_name_)
    EndMacro
    
    Macro Transform()
      Root()\_transform
    EndMacro
    
    Macro CustomCursor(_image_)
      func::cursor(_image_)
    EndMacro
    
    Macro GetCursor(_this_)
      _this_\cursor
    EndMacro
    
    Macro _set_cursor_(_this_, _cursor_)
      If _this_\root\cursor <> _cursor_ 
        _this_\root\cursor = _cursor_
        
        If _cursor_ < 65560
          SetGadgetAttribute(_this_\root\canvas\gadget, #PB_Canvas_Cursor, _cursor_)
        Else
          SetGadgetAttribute(_this_\root\canvas\gadget, #PB_Canvas_CustomCursor, CustomCursor(_cursor_))
        EndIf
      EndIf
    EndMacro
    
    ;- 
    Macro _is_root_(_this_)
      Bool(_this_ > 0 And _this_ = _this_\root) ; * _this_\root
    EndMacro
    
    Macro _is_item_(_this_, _item_)
      Bool(_item_ >= 0 And _item_ < _this_\count\items)
    EndMacro
    
    Macro _is_widget_(_this_)
      Bool(_this_ > 0 And _this_\adress) ; * _this_\adress
    EndMacro
    
    Macro _is_window_(_this_)
      ;  Bool(_this_ > 0 And _this_ = _this_\window)
      Bool(_is_widget_(_this_) And _this_\container =- 1)
      ;  Bool(_is_widget_(_this_) And _this_\type = #__type_window)
    EndMacro
    
    Macro _is_selected_(_this_)
      (_is_widget_(_this_) And _this_\_state & #__s_selected)
    ;  (_this_ = Focused() And _is_widget_(_this_) And _this_\_state & #__s_selected)
    EndMacro
    
    Macro _is_scrollbar_(_this_)
      Bool(_this_\parent And _this_\parent\scroll And (_this_\parent\scroll\v = _this_ Or _this_ = _this_\parent\scroll\h))
    EndMacro
    
    Macro _no_select_(_list_, _item_)
      ;  Bool(_item_ >= 0 And _list_\index <> _item_ And Not SelectElement(_list_, _item_))
      Bool(_item_ >= 0 And ListIndex(_list_) <> _item_ And Not SelectElement(_list_, _item_)) 
      ;Bool(ListIndex(_list_) <> _item_ And Not SelectElement(_list_, _item_))
      ;  Bool(_item_ >= 0 And _item_ < ListSize(_list_) And ListIndex(_list_) <> _item_ And Not SelectElement(_list_, _item_))
    EndMacro
    
    ;- 
    Macro Intersect(_adress_1_, _adress_2_, _mode_ = )
      Bool((_adress_1_\x#_mode_ + _adress_1_\width) > _adress_2_\x And _adress_1_\x#_mode_ < (_adress_2_\x + _adress_2_\width) And 
           (_adress_1_\y#_mode_ + _adress_1_\height) > _adress_2_\y And _adress_1_\y#_mode_ < (_adress_2_\y + _adress_2_\height))
    EndMacro
    
    Macro Atpoint(_adress_, _mode_ = )
      Bool(mouse()\x > _adress_\x#_mode_ And mouse()\x < (_adress_\x#_mode_ + _adress_\width#_mode_) And 
           mouse()\y > _adress_\y#_mode_ And mouse()\y < (_adress_\y#_mode_ + _adress_\height#_mode_))
    EndMacro
    
    Macro _from_point_(mouse_x, mouse_y, _type_, _mode_ = )
      Bool(mouse_x > _type_\x#_mode_ And mouse_x < (_type_\x#_mode_ + _type_\width#_mode_) And 
           mouse_y > _type_\y#_mode_ And mouse_y < (_type_\y#_mode_ + _type_\height#_mode_))
    EndMacro
    
    Macro _box_gradient_(_vertical_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _round_ = 0, _alpha_ = 255)
      BackColor(_color_1_&$FFFFFF|_alpha_<<24)
      FrontColor(_color_2_&$FFFFFF|_alpha_<<24)
      
      If _vertical_
        LinearGradient(_x_,_y_, (_x_ + _width_), _y_)
      Else
        LinearGradient(_x_,_y_, _x_, (_y_ + _height_))
      EndIf
      
      RoundBox(_x_,_y_,_width_,_height_, _round_,_round_)
      
      BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
    EndMacro
    
        ;-
;     Macro _button_draw_(_vertical_, _x_,_y_,_width_,_height_, _arrow_type_, _arrow_size_, _arrow_direction_, _color_fore_,_color_back_,_color_frame_, _color_arrow_, _alpha_, _round_)
;       ; Draw buttons   
;       DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
;       _box_gradient_(_vertical_,_x_,_y_,_width_,_height_, _color_fore_,_color_back_, _round_, _alpha_)
;       
;       ; Draw buttons frame
;       DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
;       RoundBox(_x_,_y_,_width_,_height_,_round_,_round_,_color_frame_&$FFFFFF|_alpha_<<24)
;       
;       ; Draw arrows
;       DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
;       Arrow(_x_ + (_width_ - _arrow_size_)/2,_y_ + (_height_ - _arrow_size_)/2, _arrow_size_, _arrow_direction_, _color_arrow_&$FFFFFF|_alpha_<<24, _arrow_type_)
;       ResetGradientColors()
;     EndMacro
    
    Macro draw_box_button(_adress_, _color_)
      If Not _adress_\hide
        RoundBox(_adress_\x, _adress_\y, _adress_\width, _adress_\height, _adress_\round, _adress_\round, _color_)
        RoundBox(_adress_\x, _adress_\y + 1, _adress_\width, _adress_\height - 2, _adress_\round, _adress_\round, _color_)
        RoundBox(_adress_\x + 1, _adress_\y, _adress_\width - 2, _adress_\height, _adress_\round, _adress_\round, _color_)
      EndIf
    EndMacro
    
    Macro draw_close_button(_adress_, _size_)
      ; close button
      If Not _adress_\hide
        If _adress_\color\state
          Line(_adress_\x + 1 + (_adress_\width - _size_)/2, _adress_\y + (_adress_\height - _size_)/2, _size_, _size_, _adress_\color\front[_adress_\color\state]&$FFFFFF|_adress_\color\alpha<<24)
          Line(_adress_\x + (_adress_\width - _size_)/2, _adress_\y + (_adress_\height - _size_)/2, _size_, _size_, _adress_\color\front[_adress_\color\state]&$FFFFFF|_adress_\color\alpha<<24)
          
          Line(_adress_\x - 1 + _size_ + (_adress_\width - _size_)/2, _adress_\y + (_adress_\height - _size_)/2,  - _size_, _size_, _adress_\color\front[_adress_\color\state]&$FFFFFF|_adress_\color\alpha<<24)
          Line(_adress_\x + _size_ + (_adress_\width - _size_)/2, _adress_\y + (_adress_\height - _size_)/2,  - _size_, _size_, _adress_\color\front[_adress_\color\state]&$FFFFFF|_adress_\color\alpha<<24)
        EndIf
        
        draw_box_button(_adress_, _adress_\color\frame[_adress_\color\state]&$FFFFFF|_adress_\color\alpha<<24)
      EndIf
    EndMacro
    
    Macro draw_maximize_button(_adress_, _size_)
      If Not _adress_\hide
        If _adress_\color\state
          Line(_adress_\x + 2 + (_adress_\width - _size_)/2, _adress_\y + (_adress_\height - _size_)/2, _size_, _size_, _adress_\color\front[_adress_\color\state]&$FFFFFF|_adress_\color\alpha<<24)
          Line(_adress_\x + 1 + (_adress_\width - _size_)/2, _adress_\y + (_adress_\height - _size_)/2, _size_, _size_, _adress_\color\front[_adress_\color\state]&$FFFFFF|_adress_\color\alpha<<24)
          
          Line(_adress_\x + 1 + (_adress_\width - _size_)/2, _adress_\y + (_adress_\height - _size_)/2,  - _size_, _size_, _adress_\color\front[_adress_\color\state]&$FFFFFF|_adress_\color\alpha<<24)
          Line(_adress_\x + 2 + (_adress_\width - _size_)/2, _adress_\y + (_adress_\height - _size_)/2,  - _size_, _size_, _adress_\color\front[_adress_\color\state]&$FFFFFF|_adress_\color\alpha<<24)
        EndIf
        
        draw_box_button(_adress_, _adress_\color\frame[_adress_\color\state]&$FFFFFF|_adress_\color\alpha<<24)
      EndIf
    EndMacro
    
    Macro draw_minize_button(_adress_, _size_)
      If Not _adress_\hide
        If _adress_\color\state
          Line(_adress_\x + 1 + (_adress_\width )/2 - _size_, _adress_\y + (_adress_\height - _size_)/2, _size_, _size_, _adress_\color\front[_adress_\color\state]&$FFFFFF|_adress_\color\alpha<<24)
          Line(_adress_\x + 0 + (_adress_\width )/2 - _size_, _adress_\y + (_adress_\height - _size_)/2, _size_, _size_, _adress_\color\front[_adress_\color\state]&$FFFFFF|_adress_\color\alpha<<24)
          
          Line(_adress_\x - 1 + (_adress_\width)/2 + _size_, _adress_\y + (_adress_\height - _size_)/2,  - _size_, _size_, _adress_\color\front[_adress_\color\state]&$FFFFFF|_adress_\color\alpha<<24)
          Line(_adress_\x - 2 + (_adress_\width)/2 + _size_, _adress_\y + (_adress_\height - _size_)/2,  - _size_, _size_, _adress_\color\front[_adress_\color\state]&$FFFFFF|_adress_\color\alpha<<24)
        EndIf
        
        draw_box_button(_adress_, _adress_\color\frame[_adress_\color\state]&$FFFFFF|_adress_\color\alpha<<24)
      EndIf
    EndMacro
    
    Macro draw_help_button(_adress_, _size_)
      If Not _adress_\hide
        RoundBox(_adress_\x, _adress_\y, _adress_\width, _adress_\height, 
                 _adress_\round, _adress_\round, _adress_\color\frame[_adress_\color\state]&$FFFFFF|_adress_\color\alpha<<24)
      EndIf
    EndMacro
    
    Macro draw_option_button(_adress_, _size_, _color_)
      If _adress_\round > 2
        If _adress_\width % 2
          RoundBox(_adress_\x + (_adress_\width - _size_)/2,_adress_\y + (_adress_\height - _size_)/2, _size_ + 1,_size_ + 1, _size_ + 1,_size_ + 1, _color_) 
        Else
          RoundBox(_adress_\x + (_adress_\width - _size_)/2,_adress_\y + (_adress_\height - _size_)/2, _size_,_size_, _size_,_size_, _color_) 
        EndIf
      Else
        If _adress_\width % 2
          RoundBox(_adress_\x + (_adress_\width - _size_)/2,_adress_\y + (_adress_\height - _size_)/2, _size_ + 1,_size_ + 1, 1,1, _color_) 
        Else
          RoundBox(_adress_\x + (_adress_\width - _size_)/2,_adress_\y + (_adress_\height - _size_)/2, _size_ + 1,_size_ + 1, 1,1, _color_) 
        EndIf
      EndIf
    EndMacro
    
    Macro draw_check_button(_adress_, _size_, _color_)
      If _adress_\state
        LineXY((_adress_\x +0+ (_adress_\width-_size_)/2),(_adress_\y +4+ (_adress_\height-_size_)/2),(_adress_\x +1+ (_adress_\width-_size_)/2),(_adress_\y +5+ (_adress_\height-_size_)/2), _color_) ; Левая линия
        LineXY((_adress_\x +0+ (_adress_\width-_size_)/2),(_adress_\y +5+ (_adress_\height-_size_)/2),(_adress_\x +1+ (_adress_\width-_size_)/2),(_adress_\y +6+ (_adress_\height-_size_)/2), _color_) ; Левая линия
        
        LineXY((_adress_\x +5+ (_adress_\width-_size_)/2),(_adress_\y +0+ (_adress_\height-_size_)/2),(_adress_\x +2+ (_adress_\width-_size_)/2),(_adress_\y +6+ (_adress_\height-_size_)/2), _color_) ; правая линия
        LineXY((_adress_\x +6+ (_adress_\width-_size_)/2),(_adress_\y +0+ (_adress_\height-_size_)/2),(_adress_\x +3+ (_adress_\width-_size_)/2),(_adress_\y +6+ (_adress_\height-_size_)/2), _color_) ; правая линия
      EndIf
    EndMacro
    
    Macro draw_button(_type_, _x_,_y_, _width_, _height_, _checked_, _round_, _color_fore_=$FFFFFFFF, _color_fore2_=$FFE9BA81, _color_back_=$80E2E2E2, _color_back2_=$FFE89C3D, _color_frame_=$80C8C8C8, _color_frame2_=$FFDC9338, _alpha_ = 255) 
      DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
      LinearGradient(_x_,_y_, _x_, (_y_ + _height_))
      
      If _checked_
        BackColor(_color_fore2_&$FFFFFF|_alpha_<<24)
        FrontColor(_color_back2_&$FFFFFF|_alpha_<<24)
      Else
        BackColor(_color_fore_&$FFFFFF|_alpha_<<24)
        FrontColor(_color_back_&$FFFFFF|_alpha_<<24)
      EndIf
      
      RoundBox(_x_,_y_,_width_,_height_, _round_,_round_)
      
      If _type_ = 4
        FrontColor($ff000000&$FFFFFF|_alpha_<<24)
        BackColor($ff000000&$FFFFFF|_alpha_<<24)
        
        Line(_x_ + 1 + (_width_ - 6)/2, _y_ + (_height_ - 6)/2, 6, 6)
        Line(_x_ + (_width_ - 6)/2, _y_ + (_height_ - 6)/2, 6, 6)
        
        Line(_x_ - 1 + 6 + (_width_ - 6)/2, _y_ + (_height_ - 6)/2,  - 6, 6)
        Line(_x_ + 6 + (_width_ - 6)/2, _y_ + (_height_ - 6)/2,  - 6, 6)
      Else
        FrontColor(_color_fore_&$FFFFFF|_alpha_<<24)
        BackColor(_color_fore_&$FFFFFF|_alpha_<<24)
        
        If _checked_
          If _type_ = 1
            If _width_%2
              RoundBox(_x_ + (_width_ - 4)/2,_y_ + (_height_ - 4)/2, 5,5, 5,5) 
            Else
              RoundBox(_x_ + (_width_ - 4)/2,_y_ + (_height_ - 4)/2, 4,4, 4,4) 
            EndIf
          Else
            If _checked_ =- 1
              If _width_%2
                Box(_x_ + (_width_ - 4)/2,_y_ + (_height_ - 4)/2, 5,5) 
              Else
                Box(_x_ + (_width_ - 4)/2,_y_ + (_height_ - 4)/2, 4,4) 
              EndIf
            Else
              _box_x_ = _width_/2 - 4
              _box_y_ = _box_x_ + Bool(_width_%2) 
              
              LineXY((_x_ + 1+_box_x_),(_y_ +4+ _box_y_),(_x_ +2+ _box_x_),(_y_ +5+ _box_y_)) ; Левая линия
              LineXY((_x_ + 1+_box_x_),(_y_ +5+ _box_y_),(_x_ +2+ _box_x_),(_y_ +6+ _box_y_)) ; Левая линия
              
              LineXY((_x_ + 6+_box_x_),(_y_ +0+ _box_y_),(_x_ +3+ _box_x_),(_y_ +6+ _box_y_)) ; правая линия
              LineXY((_x_ + 7+_box_x_),(_y_ +0+ _box_y_),(_x_ +4+ _box_x_),(_y_ +6+ _box_y_)) ; правая линия
            EndIf
          EndIf
        EndIf
        
      EndIf    
      
      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
      
      If _checked_
        FrontColor(_color_frame2_&$FFFFFF|_alpha_<<24)
      Else
        FrontColor(_color_frame_&$FFFFFF|_alpha_<<24)
      EndIf
      
      RoundBox(_x_,_y_,_width_,_height_, _round_,_round_);, _color_frame_&$FFFFFF|_alpha_<<24)
    EndMacro
    
   
    ;-
    Macro _draw_v_progress_(_pos_, _len_, _x_, _y_, _width_ ,_height_, _round_, _color1_, _color2_, _frame_size_, _gradient_=1)
      FrontColor(_color1_)
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      RoundBox(_x_ + _frame_size_, _y_ + _frame_size_, _width_ - _frame_size_*2,_height_ - _frame_size_*2, _round_,_round_)
      
      If _gradient_
        DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        LinearGradient(_x_,_y_, (_x_ + _width_), _y_)
        
        
        FrontColor(_color1_)
        If (_pos_)
          For i = 0 To (_len_)
            If Point(_x_ + i, _y_ + (_height_ - _pos_)) & $00FFFFFF = _color1_ & $00FFFFFF
              Line(_x_ + i, _y_ + (_height_ - _pos_), (_len_) - i*2, 1)
              Break
            EndIf
          Next i
          
          FillArea(_x_ + (_len_)/2, _y_ + (_height_ - _frame_size_) - 1,  -1) 
        EndIf
      EndIf
      
      FrontColor(_color2_)
      If (_height_ - _pos_)
        For i = 0 To (_len_)
          If Point(_x_ + i, _y_ + (_height_ - _pos_)) & $00FFFFFF = _color1_ & $00FFFFFF
            Line(_x_ + i, _y_ + (_height_ - _pos_), (_len_) - i*2, 1)
            Break
          EndIf
        Next i
        
        FillArea(_x_ + (_len_)/2, _y_ + (_height_ - _pos_)/2,  -1) 
      EndIf
    EndMacro
    
    Macro _draw_h_progress_3(_pos_, _len_, _x_, _y_, _width_ ,_height_, _round_, _color1_, _color2_, _frame_size_, _gradient_=1)
      FrontColor(_color2_)
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      RoundBox(_x_ + _frame_size_, _y_ + _frame_size_, _width_ - _frame_size_*2,_height_ - _frame_size_*2, _round_,_round_)
      
      If _gradient_
        DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        LinearGradient(_x_,_y_, _x_, (_y_ + _height_))
        
        For y = _y_ To _y_ + _height_
          If _round_ > _pos_ 
            For x = (_x_ + _pos_) To _x_ + _round_
              If Point(x, y) & $00FFFFFF = _color2_ & $00FFFFFF
                Plot(x, y)
              EndIf
            Next x
          EndIf
          
          If (_pos_) > _width_-_round_ 
            For x = _x_ + (_pos_) To _x_ + _width_
              If Point(x, y) & $00FFFFFF = _color2_ & $00FFFFFF
                Plot(x, y)
              EndIf
            Next x
          Else
            For x = _x_ + _width_-_round_ To _x_ + _width_
              If Point(x, y) & $00FFFFFF = _color2_ & $00FFFFFF
                Plot(x, y)
              EndIf
            Next x
          EndIf
        Next y
        
        
        If (_pos_) < _width_-_round_ 
          If (_pos_) >= _round_ 
            Box((_x_ + (_pos_)), _y_ + _frame_size_, (_width_-(_pos_)-_round_), _height_ - _frame_size_*2)
          Else
            Box((_x_ + _round_), _y_ + _frame_size_, (_width_-_round_*2), _height_ - _frame_size_*2)
          EndIf 
        EndIf 
        
      EndIf
      
      FrontColor(_color1_)
      
      For y = _y_ To _y_ + _height_
        If _round_ > _pos_ 
          For x = _x_ To _x_ + (_pos_)
            If Point(x, y) & $00FFFFFF = _color2_ & $00FFFFFF
              Plot(x, y)
            EndIf
          Next x
        Else
          For x = _x_ To _x_ + _round_
            If Point(x, y) & $00FFFFFF = _color2_ & $00FFFFFF
              Plot(x, y)
            EndIf
          Next x
        EndIf
        
        If (_pos_) > _width_-_round_ 
          For x = _x_ + _width_-_round_ To _x_ + (_pos_)
            If Point(x, y) & $00FFFFFF = _color2_ & $00FFFFFF
              Plot(x, y)
            EndIf
          Next x
        EndIf
      Next y
      
      If (_pos_) >= _round_ 
        If (_pos_) <= _width_-_round_
          Box((_x_ + _round_), _y_ + _frame_size_, (_pos_-_round_), _height_ - _frame_size_*2)
        Else
          Box((_x_ + _round_), _y_ + _frame_size_, (_width_-_round_*2), _height_ - _frame_size_*2)
        EndIf
      EndIf 
    EndMacro
    
    Macro _draw_h_progress_2(_pos_, _len_, _x_, _y_, _width_ ,_height_, _round_, _color1_, _color2_, _frame_size_, _gradient_=1)
      FrontColor(_color1_)
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      RoundBox(_x_ + _frame_size_, _y_ + _frame_size_, _width_ - _frame_size_*2,_height_ - _frame_size_*2, _round_,_round_)
      
      If _gradient_
        DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        LinearGradient(_x_,_y_, _x_, (_y_ + _height_))
        
        FrontColor(_color1_)
        For y = _y_ To _y_ + _height_
          For x = _x_ To (_x_ + (_pos_))
            If Point(x, y) & $00FFFFFF = _color1_ & $00FFFFFF
              Plot(x, y)
            EndIf
          Next x
        Next y
      EndIf
      
      FrontColor(_color2_)
      For y = _y_ To _y_ + _height_
        For x = _x_ + (_pos_) To _x_ + _width_
          If Point(x, y) & $00FFFFFF = _color1_ & $00FFFFFF
            Plot(x, y)
          EndIf
        Next x
      Next y
      
    EndMacro
    
    Macro _draw_h_progress_(_pos_, _len_, _x_, _y_, _width_ ,_height_, _round_, _color1_, _color2_, _frame_size_, _gradient_=1)
      
      ;_draw_h_progress_2(_pos_, _len_, _x_, _y_, _width_ ,_height_, _round_, _color1_, _color2_, _frame_size_, _gradient_)
      
      FrontColor(_color1_)
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      RoundBox(_x_ + _frame_size_, _y_ + _frame_size_, _width_ - _frame_size_*2,_height_ - _frame_size_*2, _round_,_round_)
      
      If _gradient_
        DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        LinearGradient(_x_,_y_, _x_, (_y_ + _height_))
        
        FrontColor(_color1_)
        If (_pos_)
          For i = 0 To (_len_)
            If Point(_x_ + (_pos_), _y_ + i) & $00FFFFFF = _color1_ & $00FFFFFF
              Line(_x_ + (_pos_), _y_ + i, 1, (_len_) - i*2)
              Break
            EndIf
          Next i
          
          FillArea(_x_ + (_pos_)/2, _y_ + (_len_)/2,  -1) 
        EndIf
      EndIf
      
      FrontColor(_color2_)
      If (_width_-_pos_)
        For i = 0 To (_len_)
          If Point(_x_ + (_pos_), _y_ + i) & $00FFFFFF = _color1_ & $00FFFFFF
            Line(_x_ + (_pos_), _y_ + i, 1, (_len_) - i*2)
            Break
          EndIf
        Next i
        
        FillArea(_x_ + (_width_ - _frame_size_) - 1, _y_ + (_len_)/2,  -1) 
      EndIf
    EndMacro
    
    Macro _draw_progress_(_reverse_, _vertical_, _pos_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, _frame_color1_, _frame_color2_, _gradient_=1)
      ;https://www.purebasic.fr/english/viewtopic.php?f=13&t=75757&p=557936#p557936 ; thank you infratec
      If _vertical_
        If _reverse_
          _pos_ = _height_ - _pos_
          
          _draw_v_progress_(_pos_, _width_, _x_, _y_, _width_ ,_height_, _round_, _frame_color2_, _frame_color1_, 0, _gradient_)
          _draw_v_progress_(_pos_, _width_, _x_, _y_, _width_ ,_height_, _round_, _back_color2_, _back_color1_, 1, _gradient_)
        Else
          _draw_v_progress_(_pos_, _width_, _x_, _y_, _width_ ,_height_, _round_, _frame_color1_, _frame_color2_, 0, _gradient_)
          _draw_v_progress_(_pos_, _width_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, 1, _gradient_)
          
        EndIf
      Else
        If _reverse_
          _pos_ = _width_ - _pos_
          
          _draw_h_progress_(_pos_, _height_, _x_, _y_, _width_ ,_height_, _round_, _frame_color2_, _frame_color1_, 0, _gradient_)
          _draw_h_progress_(_pos_, _height_, _x_, _y_, _width_ ,_height_, _round_, _back_color2_, _back_color1_, 1, _gradient_)
        Else
          _draw_h_progress_(_pos_, _height_, _x_, _y_, _width_ ,_height_, _round_, _frame_color1_, _frame_color2_, 0, _gradient_)
          _draw_h_progress_(_pos_, _height_, _x_, _y_, _width_ ,_height_, _round_, _back_color1_, _back_color2_, 1, _gradient_)
          
        EndIf
      EndIf
    EndMacro
    
    ;-
    Macro _bar_in_start_(_bar_) 
      Bool(_bar_\page\pos <= _bar_\min) 
    EndMacro
    
    Macro _bar_in_stop_(_bar_) 
      Bool(_bar_\page\pos >= _bar_\page\end) 
    EndMacro
    
    Macro _bar_invert_(_bar_, _scroll_pos_, _inverted_ = #True)
      (Bool(_inverted_) * (_bar_\page\end - (_scroll_pos_ - _bar_\min)) + Bool(Not _inverted_) * (_scroll_pos_))
    EndMacro
    
    Macro _bar_page_pos_(_bar_, _thumb_pos_)
      (_bar_\min + Round(((_thumb_pos_) - _bar_\area\pos) / _bar_\percent, #PB_Round_Nearest))
    EndMacro
    
    Macro _bar_thumb_pos_(_this_, _scroll_pos_)
      (_this_\bar\area\pos + Round(((_scroll_pos_) - _this_\bar\min) * _this_\bar\percent, #PB_Round_Nearest)) 
      
      If (_this_\bar\fixed And Not _this_\bar\thumb\change)
        If _this_\bar\thumb\pos < _this_\bar\area\pos + _this_\bar\button[#__b_1]\fixed  
          _this_\bar\thumb\pos = _this_\bar\area\pos + _this_\bar\button[#__b_1]\fixed 
        EndIf
        
        If _this_\bar\thumb\pos > _this_\bar\area\end - _this_\bar\button[#__b_2]\fixed 
          _this_\bar\thumb\pos = _this_\bar\area\end - _this_\bar\button[#__b_2]\fixed 
        EndIf
      Else
        If _this_\bar\thumb\pos < _this_\bar\area\pos
          _this_\bar\thumb\pos = _this_\bar\area\pos
        EndIf
        
        If _this_\bar\thumb\pos > _this_\bar\area\end
          _this_\bar\thumb\pos = _this_\bar\area\end
        EndIf
      EndIf
      
      ; 
      If _this_\bar\thumb\change
        If Not _this_\bar\direction > 0 
          If _this_\bar\page\pos = _this_\bar\min Or _this_\bar\mode & #PB_TrackBar_Ticks 
            _this_\bar\button[#__b_3]\arrow\direction = Bool(Not _this_\vertical) + Bool(_this_\vertical = _this_\bar\inverted) * 2
          Else
            _this_\bar\button[#__b_3]\arrow\direction = Bool(_this_\vertical) + Bool(_this_\bar\inverted) * 2
          EndIf
        Else
          If _this_\bar\page\pos = _this_\bar\page\end Or _this_\bar\mode & #PB_TrackBar_Ticks
            _this_\bar\button[#__b_3]\arrow\direction = Bool(Not _this_\vertical) + Bool(_this_\vertical = _this_\bar\inverted) * 2
          Else
            _this_\bar\button[#__b_3]\arrow\direction = Bool(_this_\vertical) + Bool(Not _this_\bar\inverted ) * 2
          EndIf
        EndIf
      EndIf
    EndMacro
    
    ;- 
    Macro _bar_scrollarea_change_(_this_, _pos_, _len_)
      - Bool(Bool((((_pos_) + _this_\bar\min) - _this_\bar\page\pos) < 0 And Bar_SetState(_this_, ((_pos_) + _this_\bar\min))) Or
             Bool((((_pos_) + _this_\bar\min) - _this_\bar\page\pos) > (_this_\bar\page\len - (_len_)) And Bar_SetState(_this_, ((_pos_) + _this_\bar\min) - (_this_\bar\page\len - (_len_)))))
    EndMacro
    
    Macro _bar_scrollarea_update_(_this_)
      Bool(*this\scroll\v\bar\area\change Or *this\scroll\h\bar\area\change)
      Bar_Resizes(_this_, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      ;Bar_Resizes(_this_, _this_\x[#__c_frame], _this_\y, _this_\width, _this_\height)
      ;Updates(_this_, _this_\x[#__c_frame], _this_\y, _this_\width, _this_\height)
      ;       _this_\width[#__c_inner] = _this_\scroll\h\bar\page\len ; *this\width[#__c_draw] - Bool(Not *this\scroll\v\hide) * *this\scroll\v\width ; 
      ;       _this_\height[#__c_inner] = _this_\scroll\v\bar\page\len; *this\height[#__c_draw] - Bool(Not *this\scroll\h\hide) * *this\scroll\h\height ; 
      
      _this_\scroll\v\bar\area\change = #False
      _this_\scroll\h\bar\area\change = #False
    EndMacro
    
    Macro MDI_Update(_child_)
      _child_\parent\x[#__c_required] = _child_\x[#__c_frame] 
      _child_\parent\y[#__c_required] = _child_\y[#__c_frame]
      _child_\parent\width[#__c_required] = _child_\x[#__c_frame] + _child_\width[#__c_frame] - _child_\parent\x[#__c_required]
      _child_\parent\height[#__c_required] = _child_\y[#__c_frame] + _child_\height[#__c_frame] - _child_\parent\y[#__c_required]
      
      PushListPosition(widget())
      ForEach widget()
        If widget()\parent = _child_\parent
          If _child_\parent\x[#__c_required] > widget()\x[#__c_frame] 
            _child_\parent\x[#__c_required] = widget()\x[#__c_frame] 
          EndIf
          If _child_\parent\y[#__c_required] > widget()\y[#__c_frame] 
            _child_\parent\y[#__c_required] = widget()\y[#__c_frame] 
          EndIf
        EndIf
      Next
      
      ForEach widget()
        If widget()\parent = _child_\parent
          If _child_\parent\width[#__c_required] < widget()\x[#__c_frame] + widget()\width[#__c_frame] - _child_\parent\x[#__c_required] 
            _child_\parent\width[#__c_required] = widget()\x[#__c_frame] + widget()\width[#__c_frame] - _child_\parent\x[#__c_required] 
          EndIf
          If _child_\parent\height[#__c_required] < widget()\y[#__c_frame] + widget()\height[#__c_frame] - _child_\parent\y[#__c_required] 
            _child_\parent\height[#__c_required] = widget()\y[#__c_frame] + widget()\height[#__c_frame] - _child_\parent\y[#__c_required] 
          EndIf
        EndIf
      Next
      PopListPosition(widget())
      
      If widget::Updates(_child_\parent, _child_\parent\x[#__c_inner], _child_\parent\y[#__c_inner], _child_\parent\width[#__c_draw], _child_\parent\height[#__c_draw])
        
        _child_\parent\width[#__c_inner] = _child_\parent\scroll\h\bar\page\len
        _child_\parent\height[#__c_inner] = _child_\parent\scroll\v\bar\page\len
        
        If _child_\parent\container And _child_\parent\count\childrens
          PushListPosition(widget())
          ForEach widget()
            If widget()\parent = _child_\parent
              Clip(widget(), #True)
            EndIf
          Next
          PopListPosition(widget())
        EndIf
      EndIf
      
    EndMacro
    
 
    ;- 
    ;-   DECLAREs
    ;{
    ; Requester
    Declare Message(Title.s, Text.s, Flag.i = #Null)
    
    Declare.i Tree_Properties(x.l,y.l,width.l,height.l, Flag.i = 0)
    
    Declare a_add(*this)
    Declare a_get(*this)
    Declare a_set(*this, Size.l = 5, Pos.l = -1)
    Declare a_events(eventtype.i)
    
    Declare.l X(*this, mode.l = #__c_frame)
    Declare.l Y(*this, mode.l = #__c_frame)
    Declare.l Width(*this, mode.l = #__c_frame)
    Declare.l Height(*this, mode.l = #__c_frame)
    Declare.l GetMouseX(*this, mode.l = #__c_screen)
    Declare.l GetMouseY(*this, mode.l = #__c_screen)
    
    Declare.b Draw(*this)
    Declare   ReDraw(*this)
    Declare.b Hide(*this, State.b = -1)
    Declare.b Disable(*this, State.b = -1)
    
    Declare.b Update(*this)
    Declare   Child(*this, *parent)
    Declare.b Change(*this, ScrollPos.f)
    Declare   Flag(*this, flag.i=#Null, state.b =- 1)
    Declare.b Resize(*this, ix.l,iy.l,iwidth.l,iheight.l)
    
    Declare.l CountItems(*this)
    Declare.l ClearItems(*this)
    Declare   RemoveItem(*this, Item.l) 
    
    
    Declare.l GetDeltaX(*this)
    Declare.l GetDeltaY(*this)
    Declare.l GetIndex(*this)
    Declare   Getwidget(index)
    Declare.l GetLevel(*this)
    Declare.l GetButtons(*this)
    Declare.l GetType(*this)
    Declare.i GetRoot(*this)
    Declare.i GetGadget(*this)
    Declare.i GetWindow(*this)
    Declare.l GetCount(*this, mode.b = #False)
    Declare.i GetItem(*this, parent_sublevel.l =- 1)
    
    Declare   SetImage(*this, *image)
    Declare.i SetAlignment(*this, Mode.l, Type.l = 1)
    
    ; 
    Declare.i SetActive(*this)
    Macro GetActive() : this()\active : EndMacro ; Returns activeed window
    
    Declare.s GetClass(*this)
    Declare   SetClass(*this, class.s)
    
    Declare.s GetText(*this)
    Declare   SetText(*this, text.s)
    
    Declare.i GetData(*this)
    Declare.i SetData(*this, *data)
    
    Declare.i GetFont(*this)
    Declare.i SetFont(*this, FontID.i)
    
    Declare.f GetState(*this)
    Declare.b SetState(*this, state.f)
    
    Declare.i GetParent(*this)
    Declare   SetParent(*this, *parent, _item.l = 0)
    
    Declare.l GetColor(*this, ColorType.l)
    Declare.l SetColor(*this, ColorType.l, Color.l)
    
    Declare.i GetAttribute(*this, Attribute.l)
    Declare.i SetAttribute(*this, Attribute.l, *value)
    
    Declare   GetPosition(*this, position.l)
    Declare   SetPosition(*this, position.l, *widget_2 = #Null)
    
    ;
    Declare.l GetItemState(*this, Item.l)
    Declare.b SetItemState(*this, Item.l, State.b)
    
    Declare.i GetItemData(*this, item.l)
    Declare.i SetItemData(*this, item.l, *data)
    
    Declare.s GetItemText(*this, Item.l, Column.l = 0)
    Declare.l SetItemText(*this, Item.l, Text.s, Column.l = 0)
    
    Declare.i GetItemImage(*this, Item.l)
    Declare.i SetItemImage(*this, Item.l, Image.i)
    
    Declare.i GetItemFont(*this, Item.l)
    Declare.i SetItemFont(*this, Item.l, Font.i)
    
    Declare.l GetItemColor(*this, Item.l, ColorType.l, Column.l = 0)
    Declare.l SetItemColor(*this, Item.l, ColorType.l, Color.l, Column.l = 0)
    
    Declare.i GetItemAttribute(*this, Item.l,  Attribute.l, Column.l = 0)
    Declare.i SetItemAttribute(*this, Item.l, Attribute.l, *value, Column.l = 0)
    
    Declare   SetCursor(*this, *cursor)
    
    Declare.i Create(*parent, class.s, type.l, x.l,y.l,width.l,height.l, *param_1, *param_2, *param_3, size.l, flag.i = 0, round.l = 7, ScrollStep.f = 1.0)
    
    ; button
    Declare.i Text(x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, round.l = 0)
    Declare.i String(x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, round.l = 0)
    Declare.i Button(x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, Image.i = -1, round.l = 0)
    Declare.i Option(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i = 0)
    Declare.i CheckBox(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i = 0)
    Declare.i HyperLink(X.l,Y.l,Width.l,Height.l, Text.s, Color.i, Flag.i = 0)
    
    ; bar
    ;Declare.i Area(*parent, ScrollStep, AreaWidth, AreaHeight, Width, Height, Mode = 1)
    Declare.i Spin(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i = 0, round.l = 0, increment.f = 1.0)
    Declare.i Tab(x.l,y.l,width.l,height.l, Min.l,Max.l,PageLength.l, Flag.i = 0, round.l = 0)
    Declare.i Scroll(x.l,y.l,width.l,height.l, Min.l,Max.l,PageLength.l, Flag.i = 0, round.l = 0)
    Declare.i Track(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i = 0, round.l = 7)
    Declare.i Progress(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i = 0, round.l = 0)
    Declare.i Splitter(x.l,y.l,width.l,height.l, First.i, Second.i, Flag.i = 0)
    
    ; list
    Declare.i Tree(x.l,y.l,width.l,height.l, Flag.i = 0)
    Declare.i ListView(x.l,y.l,width.l,height.l, Flag.i = 0)
    Declare.i Editor(X.l, Y.l, Width.l, Height.l, Flag.i = 0, round.i = 0)
    Declare.i ListIcon(x.l,y.l,width.l,height.l, ColumnTitle.s, ColumnWidth.i, flag.i=0)
    
    Declare.i Image(x.l,y.l,width.l,height.l, image.i, Flag.i = 0)
    Declare.i ButtonImage(x.l,y.l,width.l,height.l, Image.i = -1, Flag.i = 0, round.l = 0)
    
    ; container
    Declare.i Panel(x.l,y.l,width.l,height.l, Flag.i = 0)
    Declare.i Container(x.l,y.l,width.l,height.l, Flag.i = 0)
    Declare.i Frame(x.l,y.l,width.l,height.l, Text.s, Flag.i = 0)
    Declare.i Window(x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, *parent = 0)
    Declare.i ScrollArea(x.l,y.l,width.l,height.l, ScrollAreaWidth.l, ScrollAreaHeight.l, ScrollStep.l = 1, Flag.i = 0)
    Declare.i MDI(x.l,y.l,width.l,height.l, Flag.i = 0) 
    
    ; menu
    Declare   ToolBar(*parent, flag.i = #PB_ToolBar_Small)
    ;     Declare   Menus(*parent, flag.i)
    ;     Declare   PopupMenu(*parent, flag.i)
    
    Declare   CallBack()
    Declare.i CloseList()
    Declare.i OpenList(*this, item.l = 0)
    
    Declare   Updates(*this, x.l,y.l,width.l,height.l)
    Declare   Bar_Resizes(*this, x.l,y.l,width.l,height.l)
    Declare   AddItem(*this, Item.l, Text.s, Image.i = -1, flag.i = 0)
    Declare   AddColumn(*this, Position.l, Text.s, Width.l, Image.i =- 1)
    
    Declare.b Arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
    
    Declare   Free(*this)
    Declare.i Bind(*this, *callback, eventtype.l = #PB_All)
    Declare.i Post(eventtype.l, *this, *button = #PB_All, *data = 0)
    
    ;
    Declare   Events(*this, eventtype.l, mouse_x.l, mouse_y.l, _wheel_x_.b = 0, _wheel_y_.b = 0)
    Declare   Open(Window, x.l = 0,y.l = 0,width.l = #PB_Ignore,height.l = #PB_Ignore, Flag.i = #Null, *callback = #Null, Canvas = #PB_Any)
    Declare.i Gadget(Type.l, Gadget.i, X.l, Y.l, Width.l, Height.l, Text.s = "", *param1 = #Null, *param2 = #Null, *param3 = #Null, Flag.i = #Null,  window = -1, *CallBack = #Null)
    ;}
    
  EndDeclareModule
  
  Module widget
    ;-
    Procedure   CreateIcon(img.l, type.l)
      Protected x,y,Pixel, size = 8, index.i
      
      index = CreateImage(img, size, size) 
      If img =- 1 : img = index : EndIf
      
      If StartDrawing(ImageOutput(img))
        Box(0, 0, size, size, $fff0f0f0);GetSysColor_(#COLOR_bTNFACE))
        
        If type = 1
          Restore img_arrow_down
          For y = 0 To size - 1
            For x = 0 To size - 1
              Read.b Pixel
              
              If Pixel
                Plot(x, y, $000000)
              EndIf
            Next x
          Next y
          
        ElseIf type = 2
          Restore img_arrow_down
          For y = size - 1 To 0 Step -1
            For x = 0 To size - 1
              Read.b Pixel
              
              If Pixel
                Plot(x, y, $000000)
              EndIf
            Next x
          Next y
        EndIf 
        StopDrawing()
      EndIf
      
      DataSection
        
        img_arrow_down:
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        Data.b 0,0,0,0,0,0,0,0,0,0
        
        
        ;       img_arrow_>:
        ;       Data.b 0,0,0,0,0,0,0,0
        ;       Data.b 0,1,1,1,0,0,0,0
        ;       Data.b 0,0,1,1,1,0,0,0
        ;       Data.b 0,0,0,1,1,1,0,0
        ;       Data.b 0,0,1,1,1,0,0,0
        ;       Data.b 0,1,1,1,0,0,0,0
        ;       Data.b 0,0,0,0,0,0,0,0
        ;       Data.b 0,0,0,0,0,0,0,0
        
        ;       img_arrow_v:
        ;       Data.b 0,0,0,0,0,0,0,0
        ;       Data.b 0,1,0,0,0,1,0,0
        ;       Data.b 0,1,1,0,1,1,0,0
        ;       Data.b 0,1,1,1,1,1,0,0
        ;       Data.b 0,0,1,1,1,0,0,0
        ;       Data.b 0,0,0,1,0,0,0,0
        ;       Data.b 0,0,0,0,0,0,0,0
        ;       Data.b 0,0,0,0,0,0,0,0
        ;       
        ;       img_close
        ;       Data.b 0,0,0,0,0,0,0,0
        ;       Data.b 0,1,1,0,0,1,1,0
        ;       Data.b 0,1,1,1,1,1,1,0
        ;       Data.b 0,0,1,1,1,1,0,0
        ;       Data.b 0,0,1,1,1,1,0,0
        ;       Data.b 0,1,1,1,1,1,1,0
        ;       Data.b 0,1,1,0,0,1,1,0
        ;       Data.b 0,0,0,0,0,0,0,0
        
      EndDataSection
    EndProcedure
    
    Procedure   DrawArrow(x.l, y.l, Direction.l, color.l)
      
      If Direction = 0
        ; left                                                 
        ; 0,0,0,0,0,0,0
        ; 0,0,0,1,1,1,0
        ; 0,0,1,1,1,0,0
        ; 0,1,1,1,0,0,0
        ; 0,0,1,1,1,0,0
        ; 0,0,0,1,1,1,0
        ; 0,0,0,0,0,0,0
        
        :                                               : Plot(x + 3, y + 1, color)                        
        :                       : Plot(x + 2, y + 2, color) : Plot(x + 4, y + 1, color)                     
        :                       : Plot(x + 3, y + 2, color) : Plot(x + 5, y + 1, color)
        : Plot(x + 1, y + 3, color) : Plot(x + 4, y + 2, color)
        : Plot(x + 2, y + 3, color)                                                                       
        : Plot(x + 3, y + 3, color) : Plot(x + 2, y + 4, color)                          
        :                       : Plot(x + 3, y + 4, color)     
        :                       : Plot(x + 4, y + 4, color) : Plot(x + 3, y + 5, color) 
        :                                               : Plot(x + 4, y + 5, color)                       
        :                                               : Plot(x + 5, y + 5, color)  
      EndIf
      
      If Direction = 1
        ; up                                                 
        ; 0,0,0,0,0,0,0
        ; 0,0,0,1,0,0,0
        ; 0,0,1,1,1,0,0
        ; 0,1,1,1,1,1,0
        ; 0,1,1,0,1,1,0
        ; 0,1,0,0,0,1,0
        ; 0,0,0,0,0,0,0
        
        :                                               : Plot(x + 3, y + 1, color) 
        :                       : Plot(x + 2, y + 2, color) : Plot(x + 3, y + 2, color) : Plot(x + 4, y + 2, color) 
        : Plot(x + 1, y + 3, color) : Plot(x + 2, y + 3, color) : Plot(x + 3, y + 3, color) : Plot(x + 4, y + 3, color) : Plot(x + 5, y + 3, color)
        : Plot(x + 1, y + 4, color) : Plot(x + 2, y + 4, color)                         : Plot(x + 4, y + 4, color) : Plot(x + 5, y + 4, color)
        : Plot(x + 1, y + 5, color)                                                                         : Plot(x + 5, y + 5, color)
      EndIf
      
      If Direction = 2
        ; right                                                 
        ; 0,0,0,0,0,0,0
        ; 0,1,1,1,0,0,0
        ; 0,0,1,1,1,0,0
        ; 0,0,0,1,1,1,0
        ; 0,0,1,1,1,0,0
        ; 0,1,1,1,0,0,0
        ; 0,0,0,0,0,0,0
        
        : Plot(x + 1, y + 1, color)                        
        : Plot(x + 2, y + 1, color) : Plot(x + 2, y + 2, color)                      
        : Plot(x + 3, y + 1, color) : Plot(x + 3, y + 2, color) 
        :                       : Plot(x + 4, y + 2, color) : Plot(x + 3, y + 3, color)
        :                                               : Plot(x + 4, y + 3, color)                        
        :                       : Plot(x + 2, y + 4, color) : Plot(x + 5, y + 3, color)                          
        :                       : Plot(x + 3, y + 4, color)     
        : Plot(x + 1, y + 5, color) : Plot(x + 4, y + 4, color)
        : Plot(x + 2, y + 5, color)                       
        : Plot(x + 3, y + 5, color)  
      EndIf
      
      If Direction = 3
        ; down
        ; 0,0,0,0,0,0,0
        ; 0,1,0,0,0,1,0
        ; 0,1,1,0,1,1,0
        ; 0,1,1,1,1,1,0
        ; 0,0,1,1,1,0,0
        ; 0,0,0,1,0,0,0
        ; 0,0,0,0,0,0,0
        
        : Plot(x + 1, y + 1, color)                                                                         : Plot(x + 5, y + 1, color)
        : Plot(x + 1, y + 2, color) : Plot(x + 2, y + 2, color)                         : Plot(x + 4, y + 2, color) : Plot(x + 5, y + 2, color)
        : Plot(x + 1, y + 3, color) : Plot(x + 2, y + 3, color) : Plot(x + 3, y + 3, color) : Plot(x + 4, y + 3, color) : Plot(x + 5, y + 3, color)
        :                       : Plot(x + 2, y + 4, color) : Plot(x + 3, y + 4, color) : Plot(x + 4, y + 4, color)
        :                                               : Plot(x + 3, y + 5, color)
      EndIf
      
    EndProcedure
    
    Procedure.b Arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
      ; ProcedureReturn DrawArrow(x,y, Direction, Color)
      
      Protected I
      ;Size - 2
      
      If Not Length
        Style =- 1
      EndIf
      Length = (Size + 2)/2
      
      
      If Direction = 1 ; top
        If Style > 0 : x - 1 : y + 2
          Size / 2
          For i = 0 To Size 
            LineXY((X + 1 + i) + Size,(Y + i - 1) - (Style),(X + 1 + i) + Size,(Y + i - 1) + (Style),Color)         ; Левая линия
            LineXY(((X + 1 + (Size)) - i),(Y + i - 1) - (Style),((X + 1 + (Size)) - i),(Y + i - 1) + (Style),Color) ; правая линия
          Next
        Else : x - 1 : y - 1
          For i = 1 To Length 
            If Style =- 1
              LineXY(x + i, (Size + y), x + Length, y, Color)
              LineXY(x + Length*2 - i, (Size + y), x + Length, y, Color)
            Else
              LineXY(x + i, (Size + y) - i/2, x + Length, y, Color)
              LineXY(x + Length*2 - i, (Size + y) - i/2, x + Length, y, Color)
            EndIf
          Next 
          i = Bool(Style =- 1) 
          LineXY(x, (Size + y) + Bool(i = 0), x + Length, y + 1, Color) 
          LineXY(x + Length*2, (Size + y) + Bool(i = 0), x + Length, y + 1, Color) ; bug
        EndIf
      ElseIf Direction = 3 ; bottom
        If Style > 0 : x - 1 : y + 1;2
          Size / 2
          For i = 0 To Size
            LineXY((X + 1 + i),(Y + i) - (Style),(X + 1 + i),(Y + i) + (Style),Color) ; Левая линия
            LineXY(((X + 1 + (Size*2)) - i),(Y + i) - (Style),((X + 1 + (Size*2)) - i),(Y + i) + (Style),Color) ; правая линия
          Next
        Else : x - 1 : y + 1
          For i = 0 To Length 
            If Style =- 1
              LineXY(x + i, y, x + Length, (Size + y), Color)
              LineXY(x + Length*2 - i, y, x + Length, (Size + y), Color)
            Else
              LineXY(x + i, y + i/2 - Bool(i = 0), x + Length, (Size + y), Color)
              LineXY(x + Length*2 - i, y + i/2 - Bool(i = 0), x + Length, (Size + y), Color)
            EndIf
          Next
        EndIf
      ElseIf Direction = 0 ; в лево
        If Style > 0 : y - 1
          Size / 2
          For i = 0 To Size 
            ; в лево
            LineXY(((X + 1) + i) - (Style),(((Y + 1) + (Size)) - i),((X + 1) + i) + (Style),(((Y + 1) + (Size)) - i),Color) ; правая линия
            LineXY(((X + 1) + i) - (Style),((Y + 1) + i) + Size,((X + 1) + i) + (Style),((Y + 1) + i) + Size,Color)         ; Левая линия
          Next  
        Else : x - 1 : y - 1
          For i = 1 To Length
            If Style =- 1
              LineXY((Size + x), y + i, x, y + Length, Color)
              LineXY((Size + x), y + Length*2 - i, x, y + Length, Color)
            Else
              LineXY((Size + x) - i/2, y + i, x, y + Length, Color)
              LineXY((Size + x) - i/2, y + Length*2 - i, x, y + Length, Color)
            EndIf
          Next 
          i = Bool(Style =- 1) 
          LineXY((Size + x) + Bool(i = 0), y, x + 1, y + Length, Color) 
          LineXY((Size + x) + Bool(i = 0), y + Length*2, x + 1, y + Length, Color)
        EndIf
      ElseIf Direction = 2 ; в право
        If Style > 0 : y - 1 ;: x + 1
          Size / 2
          For i = 0 To Size 
            ; в право
            LineXY(((X + 1) + i) - (Style),((Y + 1) + i),((X + 1) + i) + (Style),((Y + 1) + i),Color) ; Левая линия
            LineXY(((X + 1) + i) - (Style),(((Y + 1) + (Size*2)) - i),((X + 1) + i) + (Style),(((Y + 1) + (Size*2)) - i),Color) ; правая линия
          Next
        Else : y - 1 : x + 1
          For i = 0 To Length 
            If Style =- 1
              LineXY(x, y + i, Size + x, y + Length, Color)
              LineXY(x, y + Length*2 - i, Size + x, y + Length, Color)
            Else
              LineXY(x + i/2 - Bool(i = 0), y + i, Size + x, y + Length, Color)
              LineXY(x + i/2 - Bool(i = 0), y + Length*2 - i, Size + x, y + Length, Color)
            EndIf
          Next
        EndIf
      EndIf
      
    EndProcedure
    
    Procedure.i Match(*value, Grid.i, Max.i = $7FFFFFFF)
      If Grid 
        *value = Round((*value/Grid), #PB_Round_Nearest) * Grid 
        
        If *value > Max 
          *value = Max 
        EndIf
      EndIf
      
      ProcedureReturn *value
      ;   Procedure.i Match(*value.i, Grid.i, Max.i = $7FFFFFFF)
      ;     ProcedureReturn ((Bool(*value>Max) * Max) + (Bool(Grid And *value<Max) * (Round((*value/Grid), #PB_round_nearest) * Grid)))
    EndProcedure
    
    Procedure.s InvertCase(Text.s)
      Protected *C.CHARACTER = @Text
      
      While (*C\c)
        If (*C\c = Asc(LCase(Chr(*C\c))))
          *C\c = Asc(UCase(Chr(*C\c)))
        Else
          *C\c = Asc(LCase(Chr(*C\c)))
        EndIf
        
        *C + #__sOC ; SizeOf(CHARACTER)
      Wend
      
      ProcedureReturn Text
    EndProcedure
    
    Procedure   Draw_Selection(X, Y, SourceColor, TargetColor)
      Protected Color, Dot.b = 4, line.b = 10, Length.b = (Line + Dot*2 + 1)
      Static Len.b
      
      If ((Len%Length)<line Or (Len%Length) = (line + Dot))
        If (Len>(Line + Dot)) : Len = 0 : EndIf
        Color = SourceColor
      Else
        Color = TargetColor
      EndIf
      
      Len + 1
      ProcedureReturn Color
    EndProcedure
    
    Procedure   Draw_PlotX(X, Y, SourceColor, TargetColor)
      Protected Color
      
      If x%2
        Color = SourceColor
      Else
        Color = TargetColor
      EndIf
      
      ProcedureReturn Color
    EndProcedure
    
    Procedure   Draw_PlotY(X, Y, SourceColor, TargetColor)
      Protected Color
      
      If y%2
        Color = SourceColor
      Else
        Color = TargetColor
      EndIf
      
      ProcedureReturn Color
    EndProcedure
    
    ;- 
    ;-  ANCHORs
    Macro a_draw(_this_)
      If *this\root And
         Transform() And 
         Transform()\widget And 
         Not Transform()\widget\hide
        
        ;UnclipOutput()
        ClipOutput(Transform()\main\x[#__c_clip],Transform()\main\y[#__c_clip],Transform()\main\width[#__c_clip],Transform()\main\height[#__c_clip])
        
        DrawingMode(#PB_2DDrawing_Outlined)
        If Transform()\id[1] : Box(Transform()\id[1]\x, Transform()\id[1]\y, Transform()\id[1]\width, Transform()\id[1]\height ,Transform()\id[1]\color[Transform()\id[1]\color\state]\frame) : EndIf
        If Transform()\id[2] : Box(Transform()\id[2]\x, Transform()\id[2]\y, Transform()\id[2]\width, Transform()\id[2]\height ,Transform()\id[2]\color[Transform()\id[2]\color\state]\frame) : EndIf
        If Transform()\id[3] : Box(Transform()\id[3]\x, Transform()\id[3]\y, Transform()\id[3]\width, Transform()\id[3]\height ,Transform()\id[3]\color[Transform()\id[3]\color\state]\frame) : EndIf
        If Transform()\id[4] : Box(Transform()\id[4]\x, Transform()\id[4]\y, Transform()\id[4]\width, Transform()\id[4]\height ,Transform()\id[4]\color[Transform()\id[4]\color\state]\frame) : EndIf
        If Transform()\id[5] : Box(Transform()\id[5]\x, Transform()\id[5]\y, Transform()\id[5]\width, Transform()\id[5]\height ,Transform()\id[5]\color[Transform()\id[5]\color\state]\frame) : EndIf
        If Transform()\id[6] : Box(Transform()\id[6]\x, Transform()\id[6]\y, Transform()\id[6]\width, Transform()\id[6]\height ,Transform()\id[6]\color[Transform()\id[6]\color\state]\frame) : EndIf
        If Transform()\id[7] : Box(Transform()\id[7]\x, Transform()\id[7]\y, Transform()\id[7]\width, Transform()\id[7]\height ,Transform()\id[7]\color[Transform()\id[7]\color\state]\frame) : EndIf
        If Transform()\id[8] : Box(Transform()\id[8]\x, Transform()\id[8]\y, Transform()\id[8]\width, Transform()\id[8]\height ,Transform()\id[8]\color[Transform()\id[8]\color\state]\frame) : EndIf
        ;If Transform()\id[#__a_moved] : Box(Transform()\id[#__a_moved]\x, Transform()\id[#__a_moved]\y, Transform()\id[#__a_moved]\width, Transform()\id[#__a_moved]\height ,Transform()\id[#__a_moved]\color[Transform()\id[#__a_moved]\color\state]\frame) : EndIf
        
        If Transform()\id[10] : Box(Transform()\id[10]\x, Transform()\id[10]\y, Transform()\id[10]\width, Transform()\id[10]\height ,Transform()\id[10]\color[Transform()\id[10]\color\state]\frame) : EndIf
        If Transform()\id[11] : Box(Transform()\id[11]\x, Transform()\id[11]\y, Transform()\id[11]\width, Transform()\id[11]\height ,Transform()\id[11]\color[Transform()\id[11]\color\state]\frame) : EndIf
        If Transform()\id[12] : Box(Transform()\id[12]\x, Transform()\id[12]\y, Transform()\id[12]\width, Transform()\id[12]\height ,Transform()\id[12]\color[Transform()\id[12]\color\state]\frame) : EndIf
        If Transform()\id[13] : Box(Transform()\id[13]\x, Transform()\id[13]\y, Transform()\id[13]\width, Transform()\id[13]\height ,Transform()\id[13]\color[Transform()\id[13]\color\state]\frame) : EndIf
        
        DrawingMode(#PB_2DDrawing_Default)
        If Transform()\id[1] : Box(Transform()\id[1]\x + 1, Transform()\id[1]\y + 1, Transform()\id[1]\width - 2, Transform()\id[1]\height - 2 ,Transform()\id[1]\color[Transform()\id[1]\color\state]\back) : EndIf
        If Transform()\id[2] : Box(Transform()\id[2]\x + 1, Transform()\id[2]\y + 1, Transform()\id[2]\width - 2, Transform()\id[2]\height - 2 ,Transform()\id[2]\color[Transform()\id[2]\color\state]\back) : EndIf
        If Transform()\id[3] : Box(Transform()\id[3]\x + 1, Transform()\id[3]\y + 1, Transform()\id[3]\width - 2, Transform()\id[3]\height - 2 ,Transform()\id[3]\color[Transform()\id[3]\color\state]\back) : EndIf
        If Transform()\id[4] : Box(Transform()\id[4]\x + 1, Transform()\id[4]\y + 1, Transform()\id[4]\width - 2, Transform()\id[4]\height - 2 ,Transform()\id[4]\color[Transform()\id[4]\color\state]\back) : EndIf
        If Transform()\id[5] And Not Transform()\widget\container
                             : Box(Transform()\id[5]\x + 1, Transform()\id[5]\y + 1, Transform()\id[5]\width - 2, Transform()\id[5]\height - 2 ,Transform()\id[5]\color[Transform()\id[5]\color\state]\back) : EndIf
        If Transform()\id[6] : Box(Transform()\id[6]\x + 1, Transform()\id[6]\y + 1, Transform()\id[6]\width - 2, Transform()\id[6]\height - 2 ,Transform()\id[6]\color[Transform()\id[6]\color\state]\back) : EndIf
        If Transform()\id[7] : Box(Transform()\id[7]\x + 1, Transform()\id[7]\y + 1, Transform()\id[7]\width - 2, Transform()\id[7]\height - 2 ,Transform()\id[7]\color[Transform()\id[7]\color\state]\back) : EndIf
        If Transform()\id[8] : Box(Transform()\id[8]\x + 1, Transform()\id[8]\y + 1, Transform()\id[8]\width - 2, Transform()\id[8]\height - 2 ,Transform()\id[8]\color[Transform()\id[8]\color\state]\back) : EndIf
        
      EndIf
    EndMacro
    
    Macro a_move(_this_)
      If Transform()\id[1] ; left
        Transform()\id[1]\x = _this_\x
        Transform()\id[1]\y = _this_\y + (_this_\height - Transform()\id[1]\height)/2
      EndIf
      If Transform()\id[2] ; top
        Transform()\id[2]\x = _this_\x + (_this_\width - Transform()\id[2]\width)/2
        Transform()\id[2]\y = _this_\y
      EndIf
      If  Transform()\id[3] ; right
        Transform()\id[3]\x = _this_\x + _this_\width - Transform()\id[3]\width 
        Transform()\id[3]\y = _this_\y + (_this_\height - Transform()\id[3]\height)/2
      EndIf
      If Transform()\id[4] ; bottom
        Transform()\id[4]\x = _this_\x + (_this_\width - Transform()\id[4]\width)/2
        Transform()\id[4]\y = _this_\y + _this_\height - Transform()\id[4]\height
      EndIf
      
      If Transform()\id[5] ; left&top
        Transform()\id[5]\x = _this_\x
        Transform()\id[5]\y = _this_\y
      EndIf
      If Transform()\id[6] ; right&top
        Transform()\id[6]\x = _this_\x + _this_\width - Transform()\id[6]\width
        Transform()\id[6]\y = _this_\y
      EndIf
      If Transform()\id[7] ; right&bottom
        Transform()\id[7]\x = _this_\x + _this_\width - Transform()\id[7]\width
        Transform()\id[7]\y = _this_\y + _this_\height - Transform()\id[7]\height
      EndIf
      If Transform()\id[8] ; left&bottom
        Transform()\id[8]\x = _this_\x
        Transform()\id[8]\y = _this_\y + _this_\height - Transform()\id[8]\height
      EndIf
      
      If Transform()\id[#__a_moved] 
        Transform()\id[#__a_moved]\x = _this_\x[#__c_frame]
        Transform()\id[#__a_moved]\y = _this_\y[#__c_frame]
        Transform()\id[#__a_moved]\width = _this_\width[#__c_frame]
        Transform()\id[#__a_moved]\height = _this_\height[#__c_frame]
      EndIf
      
      If Transform()\id[10] And 
         Transform()\id[11] And
         Transform()\id[12] And
         Transform()\id[13]
        a_lines(_this_)
      EndIf
      
    EndMacro
    
    Procedure   a_lines(*this._s_widget = -1, distance = 0)
      Protected ls = 1, top_x1,left_y2,top_x2,left_y1,bottom_x1,right_y2,bottom_x2,right_y1
      Protected checked_x1,checked_y1,checked_x2,checked_y2, relative_x1,relative_y1,relative_x2,relative_y2
      
      With *this
        If *this
          checked_x1 = *this\x[#__c_frame]
          checked_y1 = *this\y[#__c_frame]
          checked_x2 = checked_x1 + *this\width[#__c_frame]
          checked_y2 = checked_y1 + *this\height[#__c_frame]
          
          top_x1 = checked_x1 : top_x2 = checked_x2
          left_y1 = checked_y1 : left_y2 = checked_y2 
          right_y1 = checked_y1 : right_y2 = checked_y2
          bottom_x1 = checked_x1 : bottom_x2 = checked_x2
          
          Transform()\id[10]\color\state = 0
          Transform()\id[10]\x = checked_x1
          Transform()\id[10]\y = checked_y1
          Transform()\id[10]\width = ls
          Transform()\id[10]\height = checked_y2 - checked_y1
          
          Transform()\id[12]\color\state = 0
          Transform()\id[12]\x = checked_x2 - ls
          Transform()\id[12]\y = checked_y1
          Transform()\id[12]\width = ls
          Transform()\id[12]\height = checked_y2 - checked_y1
          
          Transform()\id[11]\color\state = 0
          Transform()\id[11]\x = checked_x1
          Transform()\id[11]\y = checked_y1
          Transform()\id[11]\width = checked_x2 - checked_x1
          Transform()\id[11]\height = ls
          
          Transform()\id[13]\color\state = 0
          Transform()\id[13]\x = checked_x1
          Transform()\id[13]\y = checked_y2 - ls
          Transform()\id[13]\width = checked_x2 - checked_x1
          Transform()\id[13]\height = ls
          
          If *this\parent And ListSize(widget())
            PushListPosition(widget())
            ForEach widget()
              If *this <> widget() And
                 Not widget()\hide And
                 widget()\transform And
                 widget()\parent = *this\parent
                
                relative_x1 = widget()\x[#__c_frame]
                relative_y1 = widget()\y[#__c_frame]
                relative_x2 = relative_x1 + widget()\width[#__c_frame]
                relative_y2 = relative_y1 + widget()\height[#__c_frame]
                
                ;Left_line
                If checked_x1 = relative_x1
                  If left_y1 > relative_y1 : left_y1 = relative_y1 : EndIf
                  If left_y2 < relative_y2 : left_y2 = relative_y2 : EndIf
                  
                  Transform()\id[10]\color\state = 2
                  Transform()\id[10]\x = checked_x1
                  Transform()\id[10]\y = left_y1
                  Transform()\id[10]\width = ls
                  Transform()\id[10]\height = left_y2 - left_y1
                  
                EndIf
                
                ;Right_line
                If checked_x2 = relative_x2
                  If right_y1 > relative_y1 : right_y1 = relative_y1 : EndIf
                  If right_y2 < relative_y2 : right_y2 = relative_y2 : EndIf
                  
                  Transform()\id[12]\color\state = 2
                  Transform()\id[12]\x = checked_x2 - ls
                  Transform()\id[12]\y = right_y1
                  Transform()\id[12]\width = ls
                  Transform()\id[12]\height = right_y2 - right_y1
                  
                EndIf
                
                ;Top_line
                If checked_y1 = relative_y1 
                  If top_x1 > relative_x1 : top_x1 = relative_x1 : EndIf
                  If top_x2 < relative_x2 : top_x2 = relative_x2: EndIf
                  
                  Transform()\id[11]\color\state = 1
                  Transform()\id[11]\x = top_x1
                  Transform()\id[11]\y = checked_y1
                  Transform()\id[11]\width = top_x2 - top_x1
                  Transform()\id[11]\height = ls
                  
                EndIf
                
                ;Bottom_line
                If checked_y2 = relative_y2 
                  If bottom_x1 > relative_x1 : bottom_x1 = relative_x1 : EndIf
                  If bottom_x2 < relative_x2 : bottom_x2 = relative_x2: EndIf
                  
                  Transform()\id[13]\color\state = 1
                  Transform()\id[13]\x = bottom_x1
                  Transform()\id[13]\y = checked_y2 - ls
                  Transform()\id[13]\width = bottom_x2 - bottom_x1
                  Transform()\id[13]\height = ls
                  
                EndIf
              EndIf
            Next
            PopListPosition(widget())
            
            
          EndIf
          
        EndIf
      EndWith
    EndProcedure
    
    Procedure.i a_Add(*this._s_widget)
      Structure DataBuffer
        cursor.i[#__anchors + 1]
      EndStructure
      
      Protected i, *Cursor.DataBuffer = ?CursorsBuffer
      
      With *this
        If Not *this\transform
          *this\transform = #True
          
          If Not Transform()
            Transform()._structure_(transform)
            
            Transform()\main = *this
            Transform()\index = #__a_moved
            
            For i = 0 To #__anchors
              Transform()\id[i]\cursor = *Cursor\cursor[i]
              
              Transform()\id[i]\color[0]\frame = $ff000000
              Transform()\id[i]\color[1]\frame = $ffFF0000
              Transform()\id[i]\color[2]\frame = $ff0000FF
              
              Transform()\id[i]\color[0]\back = $ffFFFFFF
              Transform()\id[i]\color[1]\back = $ffFFFFFF
              Transform()\id[i]\color[2]\back = $ffFFFFFF
            Next i
          EndIf
        EndIf
      EndWith
      
      ;;;;;;;;;;;;;;
      a_set(*this)
      
      DataSection
        CursorsBuffer:
        Data.i #PB_Cursor_Default
        Data.i #PB_Cursor_LeftRight
        Data.i #PB_Cursor_UpDown
        Data.i #PB_Cursor_LeftRight
        Data.i #PB_Cursor_UpDown
        Data.i #PB_Cursor_LeftUpRightDown
        Data.i #PB_Cursor_LeftDownRightUp
        Data.i #PB_Cursor_LeftUpRightDown
        Data.i #PB_Cursor_LeftDownRightUp
        Data.i #PB_Cursor_Arrows
      EndDataSection
    EndProcedure
    
    Procedure.i a_get(*this._s_widget)
      ProcedureReturn Bool(Transform()\widget = *this) * Transform()\widget
    EndProcedure
    
    Procedure.i a_set(*this._s_widget, Size.l = 5, Pos.l = -1)
      Protected result.i
      Static *LastPos
      
      Mouse()\grid = 6
      
      If *this\transform And 
         Transform()\main <> *this And 
         Transform()\widget <> *this
        *this\cursor = #PB_Cursor_Default
        ;Debug ""+Transform()\main +" "+ *this
        
        ;         If Transform()\widget
        ;           If *LastPos
        ;             ; ?????????? ?? ?????
        ;             SetPosition(Transform()\widget, #PB_list_before, *LastPos)
        ;             *LastPos = 0
        ;           EndIf
        ;         EndIf
        ;         
        ;         *LastPos = GetPosition(*this, #PB_list_after)
        ;         If *LastPos
        ;           SetPosition(*this, #PB_list_last)
        ;         EndIf
        
        
        ;         ;If *this\repaint
        ;         If Transform()\widget
        ;           Post(#PB_EventType_LostFocus, Transform()\widget, Transform()\index)
        ;         EndIf
        ;         Post(#PB_EventType_Focus, *this, Transform()\index)
        ;         ;EndIf
        
        Transform()\size = 5 + *this\fs
        Transform()\Pos = (Transform()\size-*this\fs) - (Transform()\size-*this\fs) / 3 - 1
        *this\bs = Transform()\pos + *this\fs
        
        
        Transform()\id[1]\width = Transform()\size
        Transform()\id[1]\height = Transform()\size
        
        Transform()\id[2]\width = Transform()\size
        Transform()\id[2]\height = Transform()\size
        
        Transform()\id[3]\width = Transform()\size
        Transform()\id[3]\height = Transform()\size
        
        Transform()\id[4]\width = Transform()\size
        Transform()\id[4]\height = Transform()\size
        
        Transform()\id[6]\width = Transform()\size
        Transform()\id[6]\height = Transform()\size
        
        Transform()\id[7]\width = Transform()\size
        Transform()\id[7]\height = Transform()\size
        
        Transform()\id[8]\width = Transform()\size
        Transform()\id[8]\height = Transform()\size
        
        If *this\container
          Transform()\id[5]\width = Transform()\size * 2
          Transform()\id[5]\height = Transform()\size * 2
        Else
          Transform()\id[5]\width = Transform()\size
          Transform()\id[5]\height = Transform()\size
        EndIf
        
        
        If Transform()\widget
          result = Transform()\widget
        Else
          result =- 1
        EndIf
        
        Transform()\widget = *this
        a_move(*this)
        Post(#PB_EventType_StatusChange, *this, Transform()\index)
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   a_events(eventtype.i)
      Static xx, yy
      Protected result, i, mouse_x.i, mouse_y.i 
      Protected mxw, myh
      Protected.l mx, my, mw, mh
      Protected.l Px,Py, IsGrid = Bool(Mouse()\grid>1)
      
      Macro a_index(_result_, _index_)
        ; From point anchor
        For _index_ = 0 To #__a_moved;#__anchors ; To 0 Step - 1
          If Transform()\id[_index_] And _from_point_(mouse_x, mouse_y, Transform()\id[_index_]) 
            If Transform()\id[_index_]\color\state <> #__s_1
              If _index_ <> #__a_moved
                If Transform()\widget\container And _index_ = 5
                  _set_cursor_(Transform()\widget, Transform()\id[#__a_moved]\cursor)
                Else
                  _set_cursor_(Transform()\widget, Transform()\id[_index_]\cursor)
                EndIf
              EndIf
              
              Transform()\id[_index_]\color\state = #__s_1
              _result_ = 1
            EndIf
            
            Transform()\index = _index_
            Break
            
          ElseIf Transform()\id[_index_]\color\state <> #__s_0
            _set_cursor_(Transform()\widget, #PB_Cursor_Default)
            Transform()\id[_index_]\color\state = #__s_0
            Transform()\index = #__a_moved
            _result_ = 1
          EndIf
        Next
        
      EndMacro
      
      Macro a_resize(_result_, _index_)
        Select _index_
          Case #__a_moved 
            If Not Transform()\widget\container
              If Transform()\widget\cursor <> Transform()\id[_index_]\cursor
                Transform()\widget\cursor = Transform()\id[_index_]\cursor
                _set_cursor_(Transform()\widget, Transform()\id[_index_]\cursor)
              EndIf
              
              _result_ = Resize(Transform()\widget, mx, my, #PB_Ignore, #PB_Ignore)
            EndIf
            
          Case 1 : _result_ = Resize(Transform()\widget, mx, #PB_Ignore, mxw, #PB_Ignore)
          Case 2 : _result_ = Resize(Transform()\widget, #PB_Ignore, my, #PB_Ignore, myh)
          Case 3 : _result_ = Resize(Transform()\widget, #PB_Ignore, #PB_Ignore, mw, #PB_Ignore)
          Case 4 : _result_ = Resize(Transform()\widget, #PB_Ignore, #PB_Ignore, #PB_Ignore, mh)
          Case 5 : _result_ = Resize(Transform()\widget, mx, my, mxw, myh)
          Case 6 : _result_ = Resize(Transform()\widget, #PB_Ignore, my, mw, myh)
          Case 7 : _result_ = Resize(Transform()\widget, #PB_Ignore, #PB_Ignore, mw, mh)
          Case 8 : _result_ = Resize(Transform()\widget, mx, #PB_Ignore, mxw, mh)
        EndSelect
      EndMacro
      
      If Transform() 
        mouse_x = Mouse()\x
        mouse_y = Mouse()\y
        
        Select eventtype 
          Case #__Event_MouseMove
            If Transform()\id[Transform()\index]\color\state = #__s_2
              ;{ widget transform
              If Transform()\widget\parent
                Px = Transform()\widget\parent\x[#__c_inner]
                Py = Transform()\widget\parent\y[#__c_inner]
              EndIf
              
              mouse_x - Mouse()\delta\x
              mouse_y - Mouse()\delta\y
              
              ;               mx = mouse_x - Px + Transform()\pos
              ;               my = mouse_y - Py + Transform()\pos
              mx = Match(mouse_x - Px + Transform()\pos, Mouse()\grid)
              my = Match(mouse_y - Py + Transform()\pos, Mouse()\grid)
              
              If xx <> mx Or yy <> my
                xx = mx
                yy = my
                
                If (Transform()\index = #__a_moved) Or
                   (Transform()\index = 5 And Transform()\widget\container) ; Form, Container, ScrollArea, Panel
                  mxw = #PB_Ignore
                  myh = #PB_Ignore
                Else
                  mxw = Transform()\widget\x[#__c_draw] + Transform()\widget\width[#__c_frame] - mx
                  myh = Transform()\widget\y[#__c_draw] + Transform()\widget\height[#__c_frame] - my
                EndIf
                
                ; mw = mx - Transform()\widget\x[#__c_draw] + IsGrid 
                ; mh = my - Transform()\widget\y[#__c_draw] + IsGrid 
                mw = Match(mouse_x - Transform()\widget\x[#__c_frame], Mouse()\grid) + IsGrid 
                mh = Match(mouse_y - Transform()\widget\y[#__c_frame], Mouse()\grid) + IsGrid 
                
                a_resize(result, Transform()\index)
                
                If result And Not Transform()\widget\container
                  Post(#PB_EventType_Resize, Transform()\widget, Transform()\index)
                EndIf
              EndIf
              ;}
              
            ElseIf Not Mouse()\Buttons
              a_index(result, i)
              
            EndIf
            
            ;           Case #__Event_leftButtonDown  
            ;Debug 
            ;             If Entered()\transform 
            ;               If Transform()\id[Transform()\index]\color\state <> #__s_2
            ;                 If Not (_from_point_(mouse_x, mouse_y, Transform()\id[Transform()\index]) And Transform()\index <> #__a_moved)
            ;                   If a_set(Entered())
            ;                     a_index(result, i)
            ;                     ; Post(#PB_EventType_StatusChange, Entered(), Transform()\index)
            ;                   EndIf
            ;                 EndIf
            ;                 
            ;                 If _from_point_(mouse_x, mouse_y, Transform()\id[Transform()\index])
            ;                   Transform()\id[Transform()\index]\color\state = #__s_2
            ;                 EndIf
            ;                 
            ;                 ;get anchor delta pos
            ;                 If Transform()\index = #__a_moved
            ;                   If Mouse()\grid > 0
            ;                     mouse_x = (mouse_x/Mouse()\grid) * Mouse()\grid
            ;                     mouse_y = (mouse_y/Mouse()\grid) * Mouse()\grid
            ;                   EndIf
            ;                   
            ;                   Mouse()\delta\x = mouse_x - Entered()\x[#__c_frame]        
            ;                   Mouse()\delta\y = mouse_y - Entered()\y[#__c_frame]
            ;                 Else
            ;                   Mouse()\delta\x = mouse_x - Transform()\id[Transform()\index]\x
            ;                   Mouse()\delta\y = mouse_y - Transform()\id[Transform()\index]\y
            ;                 EndIf
            ;               EndIf
            ;               
            ;               result = 1
            ;             EndIf
            
          Case #__Event_leftButtonUp
            If Transform()\widget\transform
              If Transform()\widget\cursor = #PB_Cursor_Arrows Or
                 Not _from_point_(mouse_x, mouse_y, Transform()\id[Transform()\index])
                Transform()\widget\cursor = #PB_Cursor_Default
                _set_cursor_(Transform()\widget, Transform()\widget\cursor)
              EndIf
              
              Transform()\id[Transform()\index]\color\state = #__s_0
              ;Transform()\index = #__a_moved
              result = 1
            EndIf
            
          Case #PB_EventType_KeyUp
            ;             Selected = #False
            
          Case #PB_EventType_KeyDown
            If Transform()\widget
              mx = Transform()\widget\x[#__c_draw]
              my = Transform()\widget\y[#__c_draw]
              mw = Transform()\widget\width[#__c_frame]
              mh = Transform()\widget\height[#__c_frame]
              
              Select Keyboard()\Key[1] 
                Case #PB_Canvas_Shift
                  Select Keyboard()\Key
                    Case #PB_Shortcut_Left  : mw - Mouse()\grid : Transform()\index = 3  
                    Case #PB_Shortcut_Right : mw + Mouse()\grid : Transform()\index = 3
                      
                    Case #PB_Shortcut_Up    : mh - Mouse()\grid : Transform()\index = 4
                    Case #PB_Shortcut_Down  : mh + Mouse()\grid : Transform()\index = 4
                  EndSelect
                  
                  ;                 If xx <> mx Or yy <> my
                  ;                   xx = mx
                  ;                   yy = my
                  
                  a_resize(result, Transform()\index)
                  ;                 EndIf
                  
                Case #PB_Canvas_Shift|#PB_Canvas_Control ;, #PB_Canvas_Control, #PB_Canvas_Command, #PB_Canvas_Control|#PB_Canvas_Command
                  Select Keyboard()\Key
                    Case #PB_Shortcut_Left  : mx - Mouse()\grid
                    Case #PB_Shortcut_Right : mx + Mouse()\grid
                      
                    Case #PB_Shortcut_Up    : my - Mouse()\grid
                    Case #PB_Shortcut_Down  : my + Mouse()\grid
                  EndSelect
                  
                  If xx <> mx Or yy <> my
                    xx = mx
                    yy = my
                    
                    If Transform()\widget\container
                      Transform()\index = 5
                      mxw = #PB_Ignore
                      myh = #PB_Ignore
                    Else
                      Transform()\index = #__a_moved
                    EndIf
                    
                    a_resize(result, Transform()\index)
                  EndIf
                  
                Default
                  Select Keyboard()\Key
                      ;                   Case #PB_Shortcut_Left  : mx - Mouse()\grid
                      ;                   Case #PB_Shortcut_Right : mx + Mouse()\grid
                      
                    Case #PB_Shortcut_Up   
                      ForEach widget()
                        If widget()\index = Transform()\widget\index - 1
                          result = a_set(widget())
                          Break
                        EndIf
                      Next
                      
                    Case #PB_Shortcut_Down  
                      ForEach widget()
                        If widget()\index = Transform()\widget\index + 1 
                          result = a_set(widget())
                          Break
                        EndIf
                      Next
                      
                  EndSelect
                  
              EndSelect
            EndIf
            
        EndSelect
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    
    
    ;- 
    ;-  PRIVATEs
    ; хочу внедрит
    Macro _drawing_mode_(_mode_)
      If widget()\_drawing <> _mode_
        widget()\_drawing = _mode_
        
        DrawingMode(_mode_)
      EndIf
    EndMacro
    
    Macro _drawing_mode_alpha_(_mode_)
      If widget()\_drawing_alpha <> _mode_
        widget()\_drawing_alpha = _mode_
        
        DrawingMode(_mode_|#PB_2DDrawing_AlphaBlend)
      EndIf
    EndMacro
    
    Macro _drawing_font_(_this_)
      ; drawing font
      ; If Not _this_\hide
      
      If _this_\root\text\fontID[1] <> _this_\text\fontID
        If Not _this_\text\fontID 
          _this_\text\fontID = _this_\root\text\fontID 
        EndIf
        
        _this_\root\text\fontID[1] = _this_\text\fontID
        If _this_\text\fontID[1] <> _this_\text\fontID
          _this_\text\fontID[1] = _this_\text\fontID
          _this_\text\change = #True
        EndIf
        
        DrawingFont(_this_\text\fontID) 
        
        If #debug_draw_font
          Debug "draw current font - " + #PB_Compiler_Procedure  + " " +  _this_  + " " +  _this_\text\change
        EndIf
      EndIf
      
      ; Получаем один раз после изменения текста  
      If _this_\text\change
        If _this_\text\invert 
          If _this_\vertical
            _this_\text\rotate = 270 
          Else
            _this_\text\rotate = 180
          EndIf
        Else
          _this_\text\rotate = Bool(_this_\vertical) * 90
        EndIf
        
        If _this_\text\string 
          _this_\text\width = TextWidth(_this_\text\string) 
        EndIf
        
        _this_\text\height = TextHeight("A"); - Bool(#PB_Compiler_OS <> #PB_OS_Windows) * 2
        
        If #debug_draw_font_change
          Debug "change text size - " + #PB_Compiler_Procedure  + " " +  _this_
        EndIf
      EndIf
      
      ; EndIf
    EndMacro
    
    Macro _drawing_font_item_(_this_, _item_, _change_)
      ; drawing item font
      If _this_\root\text\fontID[1] <> _item_\text\fontID
        If Not _item_\text\fontID
          If Not _this_\text\fontID
            _this_\text\fontID = _this_\root\text\fontID
            ;_drawing_font_(_this_)
          EndIf
          
          _item_\text\fontID = _this_\text\fontID
        EndIf
        
        _this_\root\text\fontID[1] = _item_\text\fontID
        If _item_\text\fontID[1] <> _item_\text\fontID
          _item_\text\fontID[1] = _item_\text\fontID
          _item_\text\change = #True
        EndIf
        DrawingFont(_item_\text\fontID) 
      EndIf
      
      ; Получаем один раз после изменения текста  
      If  _item_\text\change; _change_
        If _item_\text\string
          _item_\text\width = TextWidth(_item_\text\string) 
        EndIf
        _item_\text\height = TextHeight("A") 
        _item_\text\change = #False
        
        If #debug_draw_item_font_change
          Debug "item change text size - " + #PB_Compiler_Procedure  + " " +  _item_\index
        EndIf
      EndIf 
    EndMacro      
    
    Macro _repaint_(_this_)
      If _this_\root And Not _this_\repaint : _this_\repaint = 1
        PostEvent(#PB_Event_Gadget, _this_\root\canvas\window, _this_\root\canvas\gadget, #__Event_repaint);, _this_)
      EndIf
    EndMacro 
    
    Macro _repaint_items_(_this_)
      If _this_\count\items = 0 Or 
         (Not _this_\hide And _this_\row\count And 
          (_this_\count\items % _this_\row\count) = 0)
        
        ; Debug #PB_Compiler_Procedure
        _this_\change = 1
        _this_\row\count = _this_\count\items
        _repaint_(_this_)
      EndIf  
    EndMacro
    
    Macro change_checkbox_state(_adress_, _three_state_)
      ; change checkbox state
      Select _adress_\state 
        Case #PB_Checkbox_Unchecked 
          If _three_state_
            _adress_\state = #PB_Checkbox_Inbetween
          Else
            _adress_\state = #PB_Checkbox_Checked
          EndIf
        Case #PB_Checkbox_Checked : _adress_\state = #PB_Checkbox_Unchecked
        Case #PB_Checkbox_Inbetween : _adress_\state = #PB_Checkbox_Checked
      EndSelect
    EndMacro


    ;-
    Macro _set_image_(_this_, _adress_, _image_)
      If IsImage(_image_)
        _adress_\change = 1
        
        If _adress_\size
          ResizeImage(_image_, 
                      _adress_\size, 
                      _adress_\size)
          
          _adress_\width = _adress_\size
          _adress_\height = _adress_\size
        Else
          _adress_\width = ImageWidth(_image_)
          _adress_\height = ImageHeight(_image_)
        EndIf  
        
        _adress_\img = _image_ 
        _adress_\id = ImageID(_image_)
        
        _this_\row\margin\width = _adress_\padding\x + 
                                  _adress_\width + 2
      Else
        _adress_\change =- 1
        _adress_\img =- 1
        _adress_\id = 0
        _adress_\width = 0
        _adress_\height = 0
      EndIf
    EndMacro
    
    ;-
    Macro _set_align_(_adress_, _left_, _top_, _right_, _bottom_, _center_)
      _adress_\align\left = _left_
      _adress_\align\right = _right_
      
      _adress_\align\top = _top_
      _adress_\align\bottom = _bottom_
      
      If Not _center_ And 
         Not _adress_\align\top And 
         Not _adress_\align\left And
         Not _adress_\align\right And 
         Not _adress_\align\bottom
        
        If Not _adress_\align\right
          _adress_\align\left = #True 
        EndIf
        If Not _adress_\align\bottom
          _adress_\align\top = #True
        EndIf
      EndIf
    EndMacro
    
    Macro _set_align_x_(_this_, _adress_, _width_, _rotate_)
      If _rotate_ = 180
        If _this_\align\right
          _adress_\x = _width_                          - _this_\padding\x
        ElseIf Not _this_\align\left
          _adress_\x = (_width_ + _adress_\width) / 2
        Else
          _adress_\x = _adress_\width                   + _this_\padding\x
        EndIf
      EndIf
      
      If _rotate_ = 0
        If _this_\align\right
          _adress_\x = (_width_ - _adress_\width)       - _this_\padding\x
        ElseIf Not _this_\align\left
          _adress_\x = (_width_ - _adress_\width) / 2           
        Else
          _adress_\x =                                    _this_\padding\x
        EndIf
      EndIf
    EndMacro
    
    Macro _set_align_y_(_this_, _adress_, _height_, _rotate_)
      If _rotate_ = 90                  
        If _this_\align\bottom
          _adress_\y = _height_                         - _this_\padding\y
        ElseIf Not _this_\align\top
          _adress_\y = (_height_ + _adress_\width) / 2
        Else
          _adress_\y = _adress_\width                   + _this_\padding\y
        EndIf
      EndIf
      
      If _rotate_ = 270                 
        If _this_\align\bottom
          _adress_\y = (_height_ - _adress_\width)      - _this_\padding\y
        ElseIf Not _this_\align\top
          _adress_\y = (_height_ - _adress_\width) / 2
        Else
          _adress_\y =                                    _this_\padding\y
        EndIf
      EndIf
    EndMacro
    
    Macro _set_align_flag_(_this_, _parent_, _flag_)
      If _flag_ & #__flag_autosize = #__flag_autosize
        _this_\align = AllocateStructure(_s_align)
        _this_\align\autoSize = 1
        _this_\align\left = 1
        _this_\align\top = 1
        _this_\align\right = 1
        _this_\align\bottom = 1
        
        If _parent_
          _parent_\color\back =- 1
;           _parent_\color\alpha = 0
;           _parent_\color\alpha[1] = 0
        EndIf
      EndIf
    EndMacro
    
    ;-
    Macro make_scrollarea_x(_this_, _adress_);, _rotate_)
      ; make horizontal scroll x
      If _this_\scroll\h
        If _adress_\align\right
          _this_\x[#__c_required] = (_this_\width[#__c_inner] - _this_\width[#__c_required] + _this_\scroll\h\bar\page\end) - (_this_\scroll\h\bar\page\pos - _this_\scroll\h\bar\min)
        ElseIf Not _adress_\align\left ; horizontal center
          _this_\x[#__c_required] = (_this_\width[#__c_inner] -  _this_\width[#__c_required] + _this_\scroll\h\bar\page\end) / 2 - (_this_\scroll\h\bar\page\pos - _this_\scroll\h\bar\min)
        Else
          _this_\x[#__c_required] =- (_this_\scroll\h\bar\page\pos - _this_\scroll\h\bar\min)
        EndIf
      Else
        If _adress_\align\right
          _this_\x[#__c_required] = (_this_\width[#__c_inner] - _this_\width[#__c_required])
        ElseIf Not _adress_\align\left ; horizontal center
          _this_\x[#__c_required] = (_this_\width[#__c_inner] -  _this_\width[#__c_required]) / 2
        Else
          _this_\x[#__c_required] = 0
        EndIf
      EndIf
    EndMacro    
    
    Macro make_scrollarea_y(_this_, _adress_, _rotate_=0)
      ; make vertical scroll y
      If _this_\scroll\v
        If _adress_\align\bottom
          _this_\y[#__c_required] = (_this_\height[#__c_inner] - _this_\height[#__c_required] + _this_\scroll\v\bar\page\end) - (_this_\scroll\v\bar\page\pos - _this_\scroll\v\bar\min)
        ElseIf Not _adress_\align\top ; vertical center
          _this_\y[#__c_required] = (_this_\height[#__c_inner] - _this_\height[#__c_required] + _this_\scroll\v\bar\page\end) / 2 - (_this_\scroll\v\bar\page\pos - _this_\scroll\v\bar\min)
        Else
          _this_\y[#__c_required] =- (_this_\scroll\v\bar\page\pos - _this_\scroll\v\bar\min)
        EndIf
      Else
        If _adress_\align\bottom
          _this_\y[#__c_required] = (_this_\height[#__c_inner] - _this_\height[#__c_required])
        ElseIf Not _adress_\align\top ; vertical center
          If _this_\button\height And Not _adress_\align\left And Not _adress_\align\right
            If _rotate_ = 0
              _this_\y[#__c_required] = (_this_\height[#__c_inner] - _this_\height[#__c_required] + _this_\button\height) / 2
            Else
              _this_\y[#__c_required] = (_this_\height[#__c_inner] - _this_\height[#__c_required] - _this_\button\height) / 2
            EndIf
          Else
            _this_\y[#__c_required] = (_this_\height[#__c_inner] - _this_\height[#__c_required]) / 2
          EndIf
        Else
          _this_\y[#__c_required] = 0
        EndIf
      EndIf
    EndMacro
    
    ;- 
    Macro _set_text_(_this_, _text_, _flag_)
      ;     If Not _this_\text
      ;       _this_\text = AllocateStructure(_s_text)
      ;     EndIf
      
      If _this_\text
        _this_\text\change = #True
        
        _this_\text\editable = Bool(Not constants::_check_(_flag_, #__text_readonly))
        _this_\text\lower = constants::_check_(_flag_, #__text_lowercase)
        _this_\text\upper = constants::_check_(_flag_, #__text_uppercase)
        _this_\text\pass = constants::_check_(_flag_, #__text_password)
        _this_\text\invert = constants::_check_(_flag_, #__text_invert)
        
        _set_align_(_this_\text, 
                        constants::_check_(_flag_, #__text_left),
                        constants::_check_(_flag_, #__text_top),
                        constants::_check_(_flag_, #__text_right),
                        constants::_check_(_flag_, #__text_bottom),
                        constants::_check_(_flag_, #__text_center))
        
        If _this_\text\invert 
          _this_\text\rotate = Bool(_this_\vertical)*270 + Bool(Not _this_\vertical)*180
        Else
          _this_\text\rotate = Bool(_this_\vertical)*90
        EndIf
        
        If _this_\type = #__type_Editor Or
           _this_\type = #__type_String
          
          _this_\color\fore = 0
          _this_\text\caret\pos[1] =- 1
          _this_\text\caret\pos[2] =- 1
          _this_\cursor = #PB_Cursor_IBeam
          
          If _this_\text\editable
            _this_\text\caret\width = 1
            _this_\color\back[0] = $FFFFFFFF 
          Else
            _this_\color\back[0] = $FFF0F0F0  
          EndIf
        EndIf
        
        ;  _this_\text\fontID = Root()\text\fontID
      EndIf
      
      ; padding
      If _this_\type = #PB_GadgetType_Text
        _this_\text\padding\x = 1
      ElseIf _this_\type = #PB_GadgetType_Button
        _this_\text\padding\x = 4
        _this_\text\padding\y = 4
      ElseIf _this_\type = #PB_GadgetType_Editor
        _this_\text\padding\y = 6
        _this_\text\padding\x = 6
      ElseIf _this_\type = #PB_GadgetType_String
        _this_\text\padding\x = 3
        _this_\text\padding\y = 0
        
      ElseIf _this_\type = #__type_Option Or 
             _this_\type = #__type_checkBox 
        _this_\text\padding\x = _this_\button\width + 8
      EndIf
      
      
      ; multiline
      If constants::_check_(_flag_, #__text_wordwrap)
        _this_\text\multiLine =- 1
        
      ElseIf constants::_check_(_flag_, #__text_multiline)
        _this_\text\multiLine = 1
      Else
        _this_\text\multiLine = 0 
      EndIf
      
      If _this_\type = #__type_text
        _this_\text\multiLine =- 1
        
      ElseIf _this_\type = #__type_Option Or 
             _this_\type = #__type_checkBox Or 
             _this_\type = #__type_HyperLink
        ; wrap text
        _this_\text\multiline =- CountString(_text_, #LF$)
        
      ElseIf _this_\type = #__type_Editor
        If Not _this_\text\multiLine
          _this_\text\multiLine = 1
        EndIf
        
      ElseIf _this_\type = #__type_string
        _this_\text\multiLine = 0
      EndIf
      
      If _text_
        SetText(_this_, _text_)
      EndIf
      
    EndMacro
    
    Macro _set_text_flag_(_this_, _flag_, _x_ = 0, _y_ = 0)
      ;     If Not _this_\text
      ;       _this_\text = AllocateStructure(_s_text)
      ;     EndIf
      
      If _this_\text
        _this_\text\x = _x_
        _this_\text\y = _y_
        ; _this_\text\_padding = 5
        _this_\text\change = #True
        
        _this_\text\editable = Bool(Not constants::_check_(_flag_, #__text_readonly))
        _this_\text\lower = constants::_check_(_flag_, #__text_lowercase)
        _this_\text\upper = constants::_check_(_flag_, #__text_uppercase)
        _this_\text\pass = constants::_check_(_flag_, #__text_password)
        _this_\text\invert = constants::_check_(_flag_, #__text_invert)
        
        _set_align_(_this_\text, 
                        constants::_check_(_flag_, #__text_left),
                        constants::_check_(_flag_, #__text_top),
                        constants::_check_(_flag_, #__text_right),
                        constants::_check_(_flag_, #__text_bottom),
                        constants::_check_(_flag_, #__text_center))
        
        
        If constants::_check_(_flag_, #__text_wordwrap)
          _this_\text\multiLine =- 1
        ElseIf constants::_check_(_flag_, #__text_multiline)
          _this_\text\multiLine = 1
        Else
          _this_\text\multiLine = 0 
        EndIf
        
        If _this_\text\invert 
          _this_\text\rotate = Bool(_this_\vertical)*270 + Bool(Not _this_\vertical)*180
        Else
          _this_\text\rotate = Bool(_this_\vertical)*90
        EndIf
        
        If _this_\type = #__type_Editor Or
           _this_\type = #__type_String
          
          _this_\color\fore = 0
          _this_\text\caret\pos[1] =- 1
          _this_\text\caret\pos[2] =- 1
          _this_\cursor = #PB_Cursor_IBeam
          
          If _this_\text\editable
            _this_\text\caret\width = 1
            _this_\color\back[0] = $FFFFFFFF 
          Else
            _this_\color\back[0] = $FFF0F0F0  
          EndIf
        EndIf
        
        ;  _this_\text\fontID = Root()\text\fontID
      EndIf
      
    EndMacro
    
   
    ;-
    ;-  BARs
    ;{
    Declare.b Tab_Draw(*this)
    Declare.b Bar_Update(*this)
    Declare.b Bar_SetState(*this, state.f)
    
    Macro Area(_parent_, _scroll_step_, _area_width_, _area_height_, _width_, _height_, _mode_ = #True)
      _parent_\scroll\v = Create(_parent_, "vertical", #__type_ScrollBar, 0,0,#__scroll_buttonsize,0,  0,_area_height_, _height_, #__scroll_buttonsize, #__bar_child|#__bar_vertical, 7, _scroll_step_)
      _parent_\scroll\h = Create(_parent_, "horizontal", #__type_ScrollBar, 0,0,0,#__scroll_buttonsize,  0,_area_width_, _width_, Bool(_mode_)*#__scroll_buttonsize, #__bar_child, 7, _scroll_step_)
    EndMacro                                                  
    
    Macro Area_Draw(_this_)
      If _this_\scroll
        If _this_\scroll\v And Not _this_\scroll\v\hide And _this_\scroll\v\width And _this_\scroll\v\width[#__c_clip] > 0 And _this_\scroll\v\height[#__c_clip] > 0
          Bar_Draw(_this_\scroll\v)
        EndIf
        If _this_\scroll\h And Not _this_\scroll\h\hide And _this_\scroll\h\height And _this_\scroll\h\width[#__c_clip] > 0 And _this_\scroll\h\height[#__c_clip] > 0
          Bar_Draw(_this_\scroll\h)
        EndIf
        
        If #__draw_scroll_box
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          ; Scroll area coordinate
          Box(_this_\x[#__c_inner] + _this_\x[#__c_required] + _this_\text\padding\x, _this_\y[#__c_inner] + _this_\y[#__c_required] + _this_\text\padding\y, _this_\width[#__c_required] - _this_\text\padding\x*2, _this_\height[#__c_required] - _this_\text\padding\y*2, $FFFF0000)
          Box(_this_\x[#__c_inner] + _this_\x[#__c_required], _this_\y[#__c_inner] + _this_\y[#__c_required], _this_\width[#__c_required], _this_\height[#__c_required], $FF0000FF)
          
          If _this_\scroll\v And _this_\scroll\h
            Box(_this_\scroll\h\x[#__c_frame] + _this_\x[#__c_required], _this_\scroll\v\y[#__c_frame] + _this_\y[#__c_required], _this_\width[#__c_required], _this_\height[#__c_required], $FF0000FF)
            
            ; Debug "" +  _this_\x[#__c_required]  + " " +  _this_\y[#__c_required]  + " " +  _this_\width[#__c_required]  + " " +  _this_\height[#__c_required]
            ; Box(_this_\scroll\h\x[#__c_frame] - _this_\scroll\h\bar\page\pos, _this_\scroll\v\y[#__c_frame] - _this_\scroll\v\bar\page\pos, _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, $FF0000FF)
            
            ; page coordinate
            Box(_this_\scroll\h\x[#__c_frame], _this_\scroll\v\y[#__c_frame], _this_\scroll\h\bar\page\len, _this_\scroll\v\bar\page\len, $FF00FF00)
          EndIf
        EndIf
      EndIf
    EndMacro
    
    ;- 
    Procedure.i Tab_SetState(*this._s_widget, State.l)
      Protected result.b
      
      If State < 0 
        State = 0 
      EndIf
      
      If State > *this\count\items - 1 
        State = *this\count\items - 1 
      EndIf
      
      If *this\index[#__s_2] <> State 
        *this\index[#__s_2] = State
        
        If *this = *this\parent\gadget[#__panel_1] 
          *this\parent\index[#__panel_2] = State
          
          PushListPosition(widget())
          ForEach widget()
            If Child( widget(), *this\parent)  
              widget()\hide = Bool(widget()\hide[1] Or
                                   widget()\parent\hide Or 
                                   (widget()\parent\type = #PB_GadgetType_Panel And
                                    widget()\parent\index[#__panel_2] <> widget()\_item))
            EndIf
          Next
          PopListPosition(widget())
          
          Post(#PB_EventType_Change, *this\parent, State)
        Else
          Post(#PB_EventType_Change, *this, State)
        EndIf
        
        *this\bar\fixed = State + 1
        result = #True
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   Tab_AddItem(*this._s_widget, Item.i, Text.s, Image.i = -1, sublevel.i = 0)
      Protected result
      
      With *this
        ; 
        *this\bar\change = #True
        
        If (Item =- 1 Or Item > ListSize(\bar\_s()) - 1)
          LastElement(\bar\_s())
          AddElement(\bar\_s()) 
          Item = ListIndex(\bar\_s())
        Else
          If SelectElement(\bar\_s(), Item)
            If Item =< *this\index[#__s_2]
              *this\index[#__s_2]  + 1
            EndIf
            
            If *this\parent\gadget[#__panel_1] = *this
              ; \parent\type = #PB_GadgetType_Panel
              ; PushListPosition(widget())
              ForEach widget()
                If Child( widget(), *this\parent)
                  If widget()\parent = *this\parent And 
                     widget()\_item = Item
                    widget()\_item + 1
                  EndIf
                  
                  widget()\hide = Bool(widget()\hide[1] Or
                                       widget()\parent\hide Or 
                                       (widget()\parent\type = #PB_GadgetType_Panel And
                                        widget()\parent\index[#__panel_2] <> widget()\_item))
                  
                EndIf
              Next
              ; PopListPosition(widget())
            EndIf
            
            InsertElement(\bar\_s())
            
            PushListPosition(\bar\_s())
            While NextElement(\bar\_s())
              *this\bar\_s()\index = ListIndex(*this\bar\_s())
            Wend
            PopListPosition(\bar\_s())
          EndIf
        EndIf
        
        *this\bar\_s() = AllocateStructure(_s_tabs)
        *this\bar\_s()\color = _get_colors_()
        *this\bar\_s()\index = Item
        *this\bar\_s()\text\string = Text.s
        *this\bar\_s()\height = \height - 1
        
        ; last opened item of the parent
        If *this\parent\gadget[#__panel_1] = *this ; type = #PB_GadgetType_Panel
          *this\parent\index[#__panel_1] = *this\bar\_s()\index
          *this\parent\count\items + 1 
        EndIf
        
        *this\count\items + 1 
        
        ; _set_image_(*this, \bar\_s()\Image, Image)
      EndWith
      
      ProcedureReturn Item
    EndProcedure
    
    Procedure.i Tab_removeItem(*this._s_widget, Item.l)
      If SelectElement(*this\bar\_s(), item)
        If *this\bar\_s()\index = *this\index[#__s_2]
          *this\index[#__s_2]  = item - 1
        EndIf
        
        DeleteElement(*this\bar\_s(), 1)
        *this\count\items - 1
        
        If *this\parent\gadget[#__panel_1] = *this
          *this\parent\count\items - 1
          Post(#PB_EventType_CloseItem, *this\parent, Item)
        Else
          Post(#PB_EventType_CloseItem, *this, Item)
        EndIf
        *this\bar\change = 1
      EndIf
    EndProcedure
    
    Procedure   Tab_clearItems(*this._s_widget) ; Ok
      If *this\count\items <> 0
        *this\count\items = 0
        ClearList(*this\bar\_s())
        
        If *this\parent\gadget[#__panel_1] = *this
          *this\parent\count\items = 0
          Post(#PB_EventType_CloseItem, *this\parent, #PB_All)
        Else
          Post(#PB_EventType_CloseItem, *this, #PB_All)
        EndIf
      EndIf
    EndProcedure
    
    Procedure.s Tab_GetItemText(*this._s_widget, Item.l, Column.l = 0)
      Protected result.s
      
      If _is_item_(*this, Item) And 
         SelectElement(*this\bar\_s(), Item) 
        result = *this\bar\_s()\text\string
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b Tab_Draw(*this._s_widget)
      With *this
        
        If Not \hide And \color\alpha
          If \color\back <>- 1
            ; Draw scroll bar background
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(\x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\round,\round,\color\Back&$FFFFFF|\color\alpha<<24)
          EndIf
          
          If *this\bar\change
            If *this\vertical
              *this\text\y = 6
            Else
              *this\text\x = 6
            EndIf
            
            ;             *this\parent\__width = 0
            *this\bar\max = 0
            *this\text\height = TextHeight("A")
            *this\text\width = *this\width;[2]
            
            ForEach \bar\_s()
              _drawing_font_item_(*this, *this\bar\_s(), *this\bar\_s()\change)
              
              If *this\vertical
                ;                If *this\parent\__width < *this\bar\_s()\text\width + 12
                ;                  *this\parent\__width = *this\bar\_s()\text\width + 12
                ;                EndIf
                
                
                *this\bar\_s()\x = 2
                *this\bar\_s()\y = *this\bar\max
                *this\bar\_s()\width = *this\bar\button[#__b_3]\width - 3
                
                *this\bar\_s()\text\y = *this\text\y + *this\bar\_s()\y
                *this\bar\_s()\text\x = *this\text\x + *this\bar\_s()\x + (*this\bar\_s()\width - *this\bar\_s()\text\width)/2
                *this\bar\_s()\height = *this\text\y*2 + *this\bar\_s()\text\height
                
                ; then set tab state
                If *this\bar\_s()\index = *this\bar\fixed - 1
                  *this\bar\page\pos = *this\bar\_s()\y - ((*this\height[#__c_inner] - *this\bar\button[2]\len) - *this\bar\_s()\height) 
                EndIf
                
                *this\bar\max + *this\bar\_s()\height + Bool(*this\bar\_s()\index <> *this\count\items - 1) ; +  Bool(*this\bar\_s()\index = *this\count\items - 1) 
              Else
                *this\bar\_s()\y = 2
                *this\bar\_s()\x = *this\bar\max
                *this\bar\_s()\height = *this\bar\button[#__b_3]\height - 3
                
                *this\bar\_s()\text\x = *this\text\x + *this\bar\_s()\x
                *this\bar\_s()\text\y = *this\text\y + *this\bar\_s()\y + (*this\bar\_s()\height - *this\bar\_s()\text\height)/2
                *this\bar\_s()\width = *this\text\x*2 + *this\bar\_s()\text\width
                
                ; then set tab state
                If *this\bar\_s()\index = *this\bar\fixed - 1
                  *this\bar\page\pos = *this\bar\_s()\x - ((*this\width[#__c_inner] - *this\bar\button[2]\len) - *this\bar\_s()\width)
                EndIf
                
                *this\bar\max + *this\bar\_s()\width + Bool(*this\bar\_s()\index <> *this\count\items - 1) ; +  Bool(*this\bar\_s()\index = *this\count\items - 1) 
              EndIf
            Next
            
            ; then set tab state
            If *this\bar\fixed
              If *this\bar\page\pos < *this\bar\min Or 
                 *this\bar\area\len > *this\bar\max
                *this\bar\page\pos = 0
              EndIf
              
              If *this\bar\page\end And 
                 *this\bar\page\pos > *this\bar\page\end
                *this\bar\page\pos = *this\bar\page\end
              EndIf
              
              *this\bar\fixed = 0
            EndIf
            
            Debug " tab max - " + *this\bar\max  + " " +  *this\width[#__c_inner]  + " " +  *this\bar\page\pos  + " " +  *this\bar\page\end
            
            Bar_Update(*this)
            *this\bar\change = 0
          EndIf
          
          Protected x = \bar\button[#__b_3]\x
          Protected y = \bar\button[#__b_3]\y
          
          ;           If *this\bar\button[#__b_2]\color\state = #__s_3 ;And 
          ;              ;*this\bar\button[#__b_2]\color\state = #__s_3
          ;             x = \bar\button[#__b_3]\x - \bar\button[#__b_1]\width
          ;           EndIf
          
          Protected State_3, Color_frame
          Protected bar_button = \bar\index
          
          ForEach \bar\_s()
            _drawing_font_item_(*this, *this\bar\_s(), 0)
            
            If \index[#__s_1] = \bar\_s()\index
              State_3 = Bool(\index[#__s_1] = \bar\_s()\index);  + Bool( \index[#__s_1] = \bar\_s()\index And bar_button = #__b_3)
            Else
              State_3 = 0
            EndIf
            
            If \index[#__s_2] = \bar\_s()\index
              State_3 = 2
            EndIf
            
            ;State_3 = \bar\_s()\color\state
            
            If *this\vertical
              \bar\_s()\draw = Bool(Not \bar\_s()\hide And \y[#__c_inner] + \bar\_s()\y + \bar\_s()\height > \y[#__c_inner] ); And \x[#__c_inner] + \bar\_s()\x < \x[#__c_inner] + \width[#__c_inner])
              
              If \bar\_s()\draw
                ; Draw back
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\vertical,x + \bar\_s()\x - Bool(\index[#__s_2] = \bar\_s()\index),y + \bar\_s()\y,\bar\_s()\width + Bool(\index[#__s_2] = \bar\_s()\index)*2,\bar\_s()\height,
                               \bar\_s()\color\fore[State_3],\bar\_s()\color\Back[State_3], \bar\button[#__b_3]\round, \bar\_s()\color\alpha)
                
                ; Draw frame
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                RoundBox(x + \bar\_s()\x - Bool(\index[#__s_2] = \bar\_s()\index)*2, y + \bar\_s()\y,\bar\_s()\width + Bool(\index[#__s_2] = \bar\_s()\index)*4,\bar\_s()\height,
                         \bar\button[#__b_3]\round,\bar\button[#__b_3]\round,\bar\_s()\color\frame[State_3]&$FFFFFF|\bar\_s()\color\alpha<<24)
                
                If \index[#__s_2] = \bar\_s()\index
                  Line(x + \bar\_s()\x + \bar\_s()\width + 1, y + \bar\_s()\y + 1,1,\bar\_s()\height - 2, \bar\_s()\color\frame[0]&$FFFFFF|\bar\_s()\color\alpha<<24)
                EndIf
                
                If Bool(\index[#__s_1] = \bar\_s()\index And bar_button = #__b_3)
                  RoundBox(x + \bar\_s()\x,y + \bar\_s()\y + Bool(\index[#__s_2] = \bar\_s()\index)*2,\bar\_s()\width,\bar\_s()\height - Bool(\index[#__s_2] = \bar\_s()\index)*4,
                           \bar\button[#__b_3]\round,\bar\button[#__b_3]\round,\bar\_s()\color\frame[2]&$FFFFFF|\bar\_s()\color\alpha<<24)
                EndIf
                
                
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawText(x + \bar\_s()\text\x, y + \bar\_s()\text\y,\bar\_s()\text\string, \bar\_s()\color\front[State_3]&$FFFFFF|\bar\_s()\color\alpha<<24)
              EndIf
              
            Else
              \bar\_s()\draw = Bool(Not \bar\_s()\hide And \x[#__c_inner] + \bar\_s()\x + \bar\_s()\width > \x[#__c_inner] );And \x[#__c_inner] + \bar\_s()\x < \x[#__c_inner] + \width[#__c_inner])
              
              If \bar\_s()\draw
                ; Draw back
                DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
                _box_gradient_(\vertical,x + \bar\_s()\x,y + \bar\_s()\y - Bool(\index[#__s_2] = \bar\_s()\index),\bar\_s()\width,\bar\_s()\height + Bool(\index[#__s_2] = \bar\_s()\index)*2,
                               \bar\_s()\color\fore[State_3],\bar\_s()\color\Back[State_3], \bar\button[#__b_3]\round, \bar\_s()\color\alpha)
                
                ; Draw frame
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                RoundBox(x + \bar\_s()\x, y + \bar\_s()\y - Bool(\index[#__s_2] = \bar\_s()\index)*2,\bar\_s()\width,\bar\_s()\height + Bool(\index[#__s_2] = \bar\_s()\index)*4,
                         \bar\button[#__b_3]\round,\bar\button[#__b_3]\round,\bar\_s()\color\frame[State_3]&$FFFFFF|\bar\_s()\color\alpha<<24)
                
                If \index[#__s_2] = \bar\_s()\index
                  Line(x + \bar\_s()\x + 1, y + \bar\_s()\y + \bar\_s()\height + 1,\bar\_s()\width - 2,1, \bar\_s()\color\frame[0]&$FFFFFF|\bar\_s()\color\alpha<<24)
                EndIf
                
                If Bool(\index[#__s_1] = \bar\_s()\index And bar_button = #__b_3)
                  RoundBox(x + \bar\_s()\x + Bool(\index[#__s_2] = \bar\_s()\index)*2,y + \bar\_s()\y,\bar\_s()\width - Bool(\index[#__s_2] = \bar\_s()\index)*4,\bar\_s()\height,
                           \bar\button[#__b_3]\round,\bar\button[#__b_3]\round,\bar\_s()\color\frame[2]&$FFFFFF|\bar\_s()\color\alpha<<24)
                EndIf
                
                
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawText(x + \bar\_s()\text\x, y + \bar\_s()\text\y,\bar\_s()\text\string, \bar\_s()\color\front[State_3]&$FFFFFF|\bar\_s()\color\alpha<<24)
              EndIf
            EndIf
          Next
          
          
          Protected fabe_x, fabe_out, button_size, Size = 40, color = \parent\color\fore[\parent\color\state]
          If Not color
            color = \parent\color\back[\parent\color\state]
          EndIf
          
          DrawingMode(#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_Gradient)
          ResetGradientColors()
          GradientColor(0.0, Color&$FFFFFF)
          GradientColor(0.5, Color&$FFFFFF|$A0<<24)
          GradientColor(1.0, Color&$FFFFFF|245<<24)
          
          If *this\vertical
            
            ;             ; to left
            ;             If (\bar\button[#__b_1]\y < \bar\button[#__b_3]\y)
            If \bar\button[#__b_2]\y < \bar\button[#__b_3]\y
              button_size = \bar\button[#__b_1]\len + 5
            Else
              button_size = \bar\button[#__b_2]\len/2 + 5
            EndIf
            fabe_out = Size - button_size
            ;             Else
            ;               fabe_out = Size
            ;             EndIf
            
            If Not _bar_in_start_(\bar) 
              fabe_x = \y[#__c_frame] + (size - size/5)
              LinearGradient(\x[#__c_frame] + \bs, fabe_x, \x[#__c_frame] + \bs, fabe_x - fabe_out)
              RoundBox(\x[#__c_frame] + \bs, fabe_x, \width[#__c_frame] - \bs,  - Size, 10,10)
            EndIf
            
            ;             ; to right
            ;             If \bar\button[#__b_2]\y > \bar\button[#__b_3]\y
            If \bar\button[#__b_1]\y > \bar\button[#__b_3]\y
              button_size = \bar\button[#__b_1]\len + 5
            Else
              button_size = \bar\button[#__b_1]\len/2 + 5
            EndIf
            fabe_out = Size - button_size
            ;             Else
            ;               fabe_out = Size
            ;             EndIf
            
            If Not _bar_in_stop_(\bar) 
              fabe_x = \y[#__c_frame] + \height[#__c_frame] - (size - size/5)
              LinearGradient(\x[#__c_frame] + \bs, fabe_x, \x[#__c_frame] + \bs, fabe_x + fabe_out)
              RoundBox(\x[#__c_frame] + \bs, fabe_x, \width[#__c_frame] - \bs ,Size, 10,10)
            EndIf
          Else
            ;             ; to left
            ;             If (\bar\button[#__b_1]\x < \bar\button[#__b_3]\x)
            If \bar\button[#__b_2]\x < \bar\button[#__b_3]\x
              button_size = \bar\button[#__b_1]\len + 5
            Else
              button_size = \bar\button[#__b_2]\len/2 + 5
            EndIf
            fabe_out = Size - button_size
            ;             Else
            ;               fabe_out = Size
            ;             EndIf
            
            If Not _bar_in_start_(\bar) 
              fabe_x = \x[#__c_frame] + (size - size/5)
              LinearGradient(fabe_x, \y + \bs, fabe_x - fabe_out, \y + \bs)
              RoundBox(fabe_x, \y + \bs,  - Size, \height - \bs, 10,10)
            EndIf
            
            ;             ; to right
            ;             If \bar\button[#__b_2]\x > \bar\button[#__b_3]\x
            If \bar\button[#__b_1]\x > \bar\button[#__b_3]\x
              button_size = \bar\button[#__b_1]\len + 5
            Else
              button_size = \bar\button[#__b_1]\len/2 + 5
            EndIf
            fabe_out = Size - button_size
            ;             Else
            ;               fabe_out = Size
            ;             EndIf
            
            If Not _bar_in_stop_(\bar) 
              fabe_x = \x[#__c_frame] + \width[#__c_frame] - (size - size/5)
              LinearGradient(fabe_x, \y + \bs, fabe_x + fabe_out, \y + \bs)
              RoundBox(fabe_x, \y + \bs, Size, \height - \bs ,10,10)
            EndIf
          EndIf
          
          ResetGradientColors()
          
          
          If Not \bar\button[#__b_1]\hide And (\vertical And \bar\button[#__b_1]\height) Or (Not \vertical And \bar\button[#__b_1]\width) ;\bar\button[#__b_1]\len
                                                                                                                                          ; Draw buttons
            If \bar\button[#__b_1]\color\fore <>- 1
              DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
              _box_gradient_(\vertical,\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,
                             \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state], \bar\button[#__b_1]\round, \bar\button[#__b_1]\color\alpha)
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              RoundBox(\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24)
            EndIf
            
            ; Draw buttons frame
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24)
            
            ; Draw arrows
            If \bar\button[#__b_1]\arrow\size
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Arrow(\bar\button[#__b_1]\x + (\bar\button[#__b_1]\width - \bar\button[#__b_1]\arrow\size)/2,\bar\button[#__b_1]\y + (\bar\button[#__b_1]\height - \bar\button[#__b_1]\arrow\size)/2, 
                    \bar\button[#__b_1]\arrow\size, Bool(\vertical) + 2, \bar\button[#__b_1]\color\front[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24, \bar\button[#__b_1]\arrow\type)
            EndIf
          EndIf
          
          If Not \bar\button[#__b_2]\hide And (\vertical And \bar\button[#__b_2]\height) Or (Not \vertical And \bar\button[#__b_2]\width)
            ; Draw buttons
            If \bar\button[#__b_2]\color\fore <>- 1
              DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
              _box_gradient_(\vertical,\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,
                             \bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\Back[\bar\button[#__b_2]\color\state], \bar\button[#__b_2]\round, \bar\button[#__b_2]\color\alpha)
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              RoundBox(\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24)
            EndIf
            
            ; Draw buttons frame
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24)
            
            ; Draw arrows
            If \bar\button[#__b_2]\arrow\size
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Arrow(\bar\button[#__b_2]\x + (\bar\button[#__b_2]\width - \bar\button[#__b_2]\arrow\size)/2,\bar\button[#__b_2]\y + (\bar\button[#__b_2]\height - \bar\button[#__b_2]\arrow\size)/2, 
                    \bar\button[#__b_2]\arrow\size, Bool(\vertical), \bar\button[#__b_2]\color\front[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24, \bar\button[#__b_2]\arrow\type)
            EndIf
          EndIf
          
          
        EndIf
        
        ;         DrawingMode(#PB_2DDrawing_Outlined)
        ;         Box(\x[#__c_frame] - 1,\y[#__c_inner] + \height[#__c_inner],\width[#__c_frame] + 2,1, \color\frame[Bool(\index[#__s_2] <>- 1)*2 ])
        ;         
        ;         DrawingMode(#PB_2DDrawing_Outlined)
        ;         Box(\x[#__c_clip],\y[#__c_clip],\width[#__c_clip],\height[#__c_clip], $FF0000FF)
        ;         ;         ;Box(\x[#__c_screen],\y[#__c_screen],\width[#__c_screen],\height[#__c_screen], $FF00F0F0)
        ;         ;         Box(\x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame], $FF00F0F0)
        ;         Box(\x[#__c_inner],\y[#__c_inner],\width[#__c_inner],\height[#__c_inner], $FF00FF00)
        
      EndWith 
    EndProcedure
    
    ;- 
    Procedure.b Scroll_Draw(*this._s_widget)
      With *this
        
        ;         DrawImage(ImageID(UpImage),\bar\button[#__b_1]\x,\bar\button[#__b_1]\y)
        ;         DrawImage(ImageID(DownImage),\bar\button[#__b_2]\x,\bar\button[#__b_2]\y)
        ;         ProcedureReturn 
        
        If Not \hide And \color\alpha
          If \color\back <>- 1
            ; Draw scroll bar background
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            RoundBox(\x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\round,\round,\color\Back&$FFFFFF|\color\alpha<<24)
          EndIf
          
          If \type = #PB_GadgetType_ScrollBar
            If \vertical
              If (\bar\page\len + Bool(\round)*(\width/4)) = \height[#__c_frame]
                Line( \x[#__c_frame], \y[#__c_frame], 1, \bar\page\len + 1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
              Else
                Line( \x[#__c_frame], \y[#__c_frame], 1, \height, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
              EndIf
            Else
              If (\bar\page\len + Bool(\round)*(\height/4)) = \width[#__c_frame]
                Line( \x[#__c_frame], \y[#__c_frame], \bar\page\len + 1, 1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
              Else
                Line( \x[#__c_frame], \y[#__c_frame], \width[#__c_frame], 1, \color\front&$FFFFFF|\color\alpha<<24) ; $FF000000) ;   
              EndIf
            EndIf
          EndIf
          
          If (\vertical And \bar\button[#__b_1]\height) Or (Not \vertical And \bar\button[#__b_1]\width) ;\bar\button[#__b_1]\len
                                                                                                         ; Draw buttons
            If \bar\button[#__b_1]\color\fore <>- 1
              DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
              _box_gradient_(\vertical,\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,
                             \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state], \bar\button[#__b_1]\round, \bar\button[#__b_1]\color\alpha)
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              RoundBox(\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24)
            EndIf
            
            ; Draw buttons frame
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\bar\button[#__b_1]\x,\bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button[#__b_1]\round,\bar\button[#__b_1]\round,\bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24)
            
            ; Draw arrows
            If \bar\button[#__b_1]\arrow\size
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Arrow(\bar\button[#__b_1]\x + (\bar\button[#__b_1]\width - \bar\button[#__b_1]\arrow\size)/2,\bar\button[#__b_1]\y + (\bar\button[#__b_1]\height - \bar\button[#__b_1]\arrow\size)/2, 
                    \bar\button[#__b_1]\arrow\size, Bool(\vertical), \bar\button[#__b_1]\color\front[\bar\button[#__b_1]\color\state]&$FFFFFF|\bar\button[#__b_1]\color\alpha<<24, \bar\button[#__b_1]\arrow\type)
            EndIf
          EndIf
          
          If (\vertical And \bar\button[#__b_2]\height) Or (Not \vertical And \bar\button[#__b_2]\width)
            ; Draw buttons
            If \bar\button[#__b_2]\color\fore <>- 1
              DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
              _box_gradient_(\vertical,\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,
                             \bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\Back[\bar\button[#__b_2]\color\state], \bar\button[#__b_2]\round, \bar\button[#__b_2]\color\alpha)
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              RoundBox(\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24)
            EndIf
            
            ; Draw buttons frame
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\bar\button[#__b_2]\x,\bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button[#__b_2]\round,\bar\button[#__b_2]\round,\bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24)
            
            ; Draw arrows
            If \bar\button[#__b_2]\arrow\size
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Arrow(\bar\button[#__b_2]\x + (\bar\button[#__b_2]\width - \bar\button[#__b_2]\arrow\size)/2,\bar\button[#__b_2]\y + (\bar\button[#__b_2]\height - \bar\button[#__b_2]\arrow\size)/2, 
                    \bar\button[#__b_2]\arrow\size, Bool(\vertical) + 2, \bar\button[#__b_2]\color\front[\bar\button[#__b_2]\color\state]&$FFFFFF|\bar\button[#__b_2]\color\alpha<<24, \bar\button[#__b_2]\arrow\type)
            EndIf
          EndIf
          
          If \bar\thumb\len And \type <> #PB_GadgetType_ProgressBar
            ; Draw thumb
            DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            _box_gradient_(\vertical,\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width,\bar\button[#__b_3]\height,
                           \bar\button[#__b_3]\color\fore[\bar\button[#__b_3]\color\state],\bar\button[#__b_3]\color\Back[\bar\button[#__b_3]\color\state], \bar\button[#__b_3]\round, \bar\button[#__b_3]\color\alpha)
            
            ; Draw thumb frame
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\bar\button[#__b_3]\x,\bar\button[#__b_3]\y,\bar\button[#__b_3]\width,\bar\button[#__b_3]\height,\bar\button[#__b_3]\round,\bar\button[#__b_3]\round,\bar\button[#__b_3]\color\frame[\bar\button[#__b_3]\color\state]&$FFFFFF|\bar\button[#__b_3]\color\alpha<<24)
            
            If \bar\button[#__b_3]\arrow\type ; \type = #PB_GadgetType_ScrollBar
              If \bar\button[#__b_3]\arrow\size
                DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                Arrow(\bar\button[#__b_3]\x + (\bar\button[#__b_3]\width - \bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y + (\bar\button[#__b_3]\height - \bar\button[#__b_3]\arrow\size)/2, 
                      \bar\button[#__b_3]\arrow\size, \bar\button[#__b_3]\arrow\direction, \bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\bar\button[#__b_3]\color\alpha<<24, \bar\button[#__b_3]\arrow\type)
              EndIf
            Else
              ; Draw thumb lines
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              If \vertical
                Line(\bar\button[#__b_3]\x + (\bar\button[#__b_3]\width - \bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y + \bar\button[#__b_3]\height/2 - 3,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
                Line(\bar\button[#__b_3]\x + (\bar\button[#__b_3]\width - \bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y + \bar\button[#__b_3]\height/2,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
                Line(\bar\button[#__b_3]\x + (\bar\button[#__b_3]\width - \bar\button[#__b_3]\arrow\size)/2,\bar\button[#__b_3]\y + \bar\button[#__b_3]\height/2 + 3,\bar\button[#__b_3]\arrow\size,1,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
              Else
                Line(\bar\button[#__b_3]\x + \bar\button[#__b_3]\width/2 - 3,\bar\button[#__b_3]\y + (\bar\button[#__b_3]\height - \bar\button[#__b_3]\arrow\size)/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
                Line(\bar\button[#__b_3]\x + \bar\button[#__b_3]\width/2,\bar\button[#__b_3]\y + (\bar\button[#__b_3]\height - \bar\button[#__b_3]\arrow\size)/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
                Line(\bar\button[#__b_3]\x + \bar\button[#__b_3]\width/2 + 3,\bar\button[#__b_3]\y + (\bar\button[#__b_3]\height - \bar\button[#__b_3]\arrow\size)/2,1,\bar\button[#__b_3]\arrow\size,\bar\button[#__b_3]\color\front[\bar\button[#__b_3]\color\state]&$FFFFFF|\color\alpha<<24)
              EndIf
              
            EndIf
          EndIf
          
          
        EndIf
        
        
        ;         DrawingMode(#PB_2DDrawing_Outlined)
        ;         Box(\x[#__c_clip],\y[#__c_clip],\width[#__c_clip],\height[#__c_clip], $FF00FF00)
        
      EndWith 
    EndProcedure
    
    Procedure.i Spin_Draw(*this._s_widget) 
      Scroll_Draw(*this)
      
      DrawingMode(#PB_2DDrawing_Outlined)
      Box(*this\bar\button[#__b_1]\x - 2,*this\y[#__c_frame],*this\x[#__c_inner] + *this\width[#__c_draw] - *this\bar\button[#__b_1]\x + 3,*this\height[#__c_frame], *this\color\frame[*this\color\state])
      Box(*this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame], *this\color\frame[*this\color\state])
      
      
      ; Draw string
      If *this\text And *this\text\string
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawRotatedText(*this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\color\front[0]) ; *this\color\state])
      EndIf
    EndProcedure
    
    Procedure.b Track_Draw(*this._s_widget)
      ;       *this\bar\button[#__b_1]\color\state = Bool(Not *this\bar\inverted) * #__s_2
      ;        *this\bar\button[#__b_2]\color\state = Bool(*this\bar\inverted) * #__s_2
      ;       *this\bar\button[#__b_3]\color\state = #__s_2
      
      Scroll_Draw(*this)
      
      With *this
        If \type = #PB_GadgetType_TrackBar And \bar\thumb\len
          Protected i, _thumb_ = (\bar\button[3]\len/2)
          DrawingMode(#PB_2DDrawing_XOr)
          
          If \vertical
            If \bar\mode & #PB_TrackBar_Ticks
              If \bar\percent > 1
                For i = \bar\min To \bar\page\end
                  Line(\bar\button[3]\x + Bool(\bar\inverted)*(\bar\button[3]\width - 3 + 4) - 1, 
                       (\bar\area\pos + _thumb_ + (i - \bar\min) * \bar\percent),3, 1,\bar\button[#__b_1]\color\frame)
                Next
              Else
                Box(\bar\button[3]\x + Bool(\bar\inverted)*(\bar\button[3]\width - 3 + 4) - 1,\bar\area\pos + _thumb_, 3, *this\bar\area\len - *this\bar\thumb\len + 1, \bar\button[#__b_1]\color\frame)
              EndIf
            EndIf
            
            Line(\bar\button[3]\x + Bool(\bar\inverted)*(\bar\button[3]\width - 3),\bar\area\pos + _thumb_,3, 1,\bar\button[#__b_3]\color\Frame)
            Line(\bar\button[3]\x + Bool(\bar\inverted)*(\bar\button[3]\width - 3),\bar\area\pos + *this\bar\area\len - *this\bar\thumb\len + _thumb_,3, 1,\bar\button[#__b_3]\color\Frame)
            
          Else
            If \bar\mode & #PB_TrackBar_Ticks
              If \bar\percent > 1
                For i = 0 To \bar\page\end - \bar\min
                  Line((\bar\area\pos + _thumb_ + i * \bar\percent), 
                       \bar\button[3]\y + Bool(Not \bar\inverted)*(\bar\button[3]\height - 3 + 4) - 1,1,3,\bar\button[#__b_3]\color\Frame)
                Next
              Else
                Box(\bar\area\pos + _thumb_, \bar\button[3]\y + Bool(Not \bar\inverted)*(\bar\button[3]\height - 3 + 4) - 1,*this\bar\area\len - *this\bar\thumb\len + 1, 3, \bar\button[#__b_1]\color\frame)
              EndIf
            EndIf
            
            Line(\bar\area\pos + _thumb_, \bar\button[3]\y + Bool(Not \bar\inverted)*(\bar\button[3]\height - 3),1,3,\bar\button[#__b_3]\color\Frame)
            Line(\bar\area\pos + *this\bar\area\len - *this\bar\thumb\len + _thumb_, \bar\button[3]\y + Bool(Not \bar\inverted)*(\bar\button[3]\height - 3),1,3,\bar\button[#__b_3]\color\Frame)
          EndIf
        EndIf
      EndWith    
      
    EndProcedure
    
    Procedure.b Progress_Draw(*this._s_widget)
      *this\bar\button[#__b_1]\color\state = Bool(Not *this\bar\inverted) * #__s_2
      *this\bar\button[#__b_2]\color\state = Bool(*this\bar\inverted) * #__s_2
      
      With *this
        
        ;         If *this\type = #PB_GadgetType_ProgressBar 
        ;           Protected i, _color_1_, _color_2_, pos, y,x, color
        ;           BackColor(\bar\button[#__b_1]\color\fore)
        ;           
        ;           If *this\vertical
        ;             pos = (\bar\thumb\pos-\y[#__c_frame])
        ;           Else
        ;             pos = (\bar\thumb\pos-\x[#__c_frame])
        ;             _draw_progress_(0,*this\vertical, pos,
        ;                             \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\bar\button[#__b_1]\round,
        ;                             $ff0000FF, $ff00FF00,
        ;                             $FFDC9338, $FFCECECE,1)
        ;           EndIf
        ;           
        ;         EndIf
        
        Scroll_Draw(*this)
        
        If *this\type = #PB_GadgetType_ProgressBar 
          
          If \bar\button[#__b_1]\round
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            
            If \vertical
              Line(\bar\button[#__b_1]\x, \bar\thumb\pos - \bar\button[#__b_1]\round, 1,\bar\button[#__b_1]\round, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              Line(\bar\button[#__b_1]\x + \bar\button[#__b_1]\width - 1, \bar\thumb\pos - \bar\button[#__b_1]\round, 1,\bar\button[#__b_1]\round, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              
              Line(\bar\button[#__b_2]\x, \bar\thumb\pos, 1,\bar\button[#__b_2]\round, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
              Line(\bar\button[#__b_2]\x + \bar\button[#__b_2]\width - 1, \bar\thumb\pos, 1,\bar\button[#__b_2]\round, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
            Else
              Line(\bar\thumb\pos - \bar\button[#__b_1]\round,\bar\button[#__b_1]\y, \bar\button[#__b_1]\round, 1, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              Line(\bar\thumb\pos - \bar\button[#__b_1]\round,\bar\button[#__b_1]\y + \bar\button[#__b_1]\height - 1, \bar\button[#__b_1]\round, 1, \bar\button[#__b_1]\color\frame[\bar\button[#__b_1]\color\state])
              
              Line(\bar\thumb\pos,\bar\button[#__b_2]\y, \bar\button[#__b_2]\round, 1, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
              Line(\bar\thumb\pos,\bar\button[#__b_2]\y + \bar\button[#__b_2]\height - 1, \bar\button[#__b_2]\round, 1, \bar\button[#__b_2]\color\frame[\bar\button[#__b_2]\color\state])
            EndIf
          EndIf
          
          If \bar\page\pos > \bar\min
            DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            
            If \vertical
              If \bar\button[#__b_1]\color\fore <>- 1
                _box_gradient_(\vertical,\bar\button[#__b_1]\x + 1,\bar\thumb\pos - 1 - \bar\button[#__b_2]\round,\bar\button[#__b_1]\width - 2,1 + \bar\button[#__b_2]\round,
                               \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state], 0, \bar\button[#__b_1]\color\alpha)
              EndIf
              
              ; Draw buttons
              If \bar\button[#__b_2]\color\fore <>- 1
                _box_gradient_(\vertical,\bar\button[#__b_2]\x + 1,\bar\thumb\pos,\bar\button[#__b_2]\width - 2,1 + \bar\button[#__b_2]\round,
                               \bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\Back[\bar\button[#__b_2]\color\state], 0, \bar\button[#__b_2]\color\alpha)
              EndIf
            Else
              If \bar\button[#__b_1]\color\fore <>- 1
                _box_gradient_(\vertical,\bar\thumb\pos - 1 - \bar\button[#__b_2]\round,\bar\button[#__b_1]\y + 1,1 + \bar\button[#__b_2]\round,\bar\button[#__b_1]\height - 2,
                               \bar\button[#__b_1]\color\fore[\bar\button[#__b_1]\color\state],\bar\button[#__b_1]\color\Back[\bar\button[#__b_1]\color\state], 0, \bar\button[#__b_1]\color\alpha)
              EndIf
              
              ; Draw buttons
              If \bar\button[#__b_2]\color\fore <>- 1
                _box_gradient_(\vertical,\bar\thumb\pos,\bar\button[#__b_2]\y + 1,1 + \bar\button[#__b_2]\round,\bar\button[#__b_2]\height - 2,
                               \bar\button[#__b_2]\color\fore[\bar\button[#__b_2]\color\state],\bar\button[#__b_2]\color\Back[\bar\button[#__b_2]\color\state], 0, \bar\button[#__b_2]\color\alpha)
              EndIf
            EndIf
          EndIf
          
        EndIf
        
        ; Draw string
        If *this\text And *this\text\string And (*this\height > *this\text\height)
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawRotatedText(*this\text\x, *this\text\y, *this\text\string, *this\text\rotate, *this\bar\button[#__b_3]\color\frame[*this\bar\button[#__b_3]\color\state])
        EndIf
      EndWith
    EndProcedure
    
    Procedure.b Splitter_Draw(*this._s_widget)
      With *this
        DrawingMode(#PB_2DDrawing_Outlined);|#PB_2DDrawing_AlphaBlend)
        
        
        If \bar\mode = #PB_Splitter_Separator 
          If \vertical ; horisontal
            Box(\x[#__c_frame], \bar\thumb\pos,\width,\bar\thumb\len,$FFFFFFFF)
          Else
            Box(\bar\thumb\pos,\y[#__c_frame],\bar\thumb\len, \height,$FFFFFFFF)
          EndIf
          
          If \vertical ; horisontal
            Box(\x[#__c_frame] + 1, \bar\thumb\pos + 1,\width[#__c_frame] - 2,\bar\thumb\len - 2,\bar\button[#__b_3]\color\Frame[#__s_2])
          Else
            Box(\bar\thumb\pos + 1,\y[#__c_frame] + 1,\bar\thumb\len - 2, \height[#__c_frame] - 2,\bar\button[#__b_3]\color\Frame[#__s_2])
          EndIf
          
          If #__draw_scroll_box
            If Not \index[#__split_1] And (Not \gadget[#__split_1] Or (\gadget[#__split_1] And Not \gadget[#__split_1]\type = #PB_GadgetType_Splitter))
              Box(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button\color\frame[\bar\button[#__b_1]\color\state])
            EndIf
            If Not \index[#__split_2] And (Not \gadget[#__split_2] Or (\gadget[#__split_2] And Not \gadget[#__split_2]\type = #PB_GadgetType_Splitter))
              Box(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button\color\frame[\bar\button[#__b_2]\color\state])
            EndIf
          EndIf
        
          ;           If \vertical ; horisontal
          ;             Box(\x[#__c_frame], \bar\thumb\pos + \bar\thumb\len/2,\width,1,\bar\button\color\frame[\bar\button[#__b_1]\color\state])
          ;           Else
          ;             Box(\bar\thumb\pos + \bar\thumb\len/2,\y[#__c_frame],1, \height,\bar\button\color\frame[\bar\button[#__b_1]\color\state])
          ;           EndIf
          ;           
          ;           If Not \index[#__split_1] And (Not \gadget[#__split_1] Or (\gadget[#__split_1] And Not \gadget[#__split_1]\type = #pb_gadgettype_splitter))
          ; ;             Line(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y, \bar\button[#__b_1]\width, 1, \bar\button\color\frame[\bar\button[#__b_1]\color\state])
          ; ;             Line(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y, 1, \bar\button[#__b_1]\height, \bar\button\color\frame[\bar\button[#__b_1]\color\state])
          ; ;             Line(\bar\button[#__b_1]\x + \bar\button[#__b_1]\width - 1, \bar\button[#__b_1]\y, 1, \bar\button[#__b_1]\height, \bar\button\color\frame[\bar\button[#__b_1]\color\state])
          ; ;             Line(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y + \bar\button[#__b_1]\height - 1, \bar\button[#__b_1]\width, 1, $FFFFFFFF)
          ; ;             ; Box(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button\color\frame[\bar\button[#__b_1]\color\state])
          ;              Box(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,$FFFFFFFF)
          ;           EndIf
          ;           If Not \index[#__split_2] And (Not \gadget[#__split_2] Or (\gadget[#__split_2] And Not \gadget[#__split_2]\type = #pb_gadgettype_splitter))
          ; ;             Line(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y, \bar\button[#__b_2]\width, 1, $FFFFFFFF)
          ; ;             Line(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y, 1, \bar\button[#__b_2]\height, \bar\button\color\frame[\bar\button[#__b_2]\color\state])
          ; ;             Line(\bar\button[#__b_2]\x + \bar\button[#__b_2]\width - 1, \bar\button[#__b_2]\y, 1, \bar\button[#__b_2]\height, \bar\button\color\frame[\bar\button[#__b_2]\color\state])
          ; ;             Line(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y + \bar\button[#__b_2]\height - 1, \bar\button[#__b_2]\width, 1, \bar\button\color\frame[\bar\button[#__b_2]\color\state])
          ; ;           ;  Box(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button\color\frame[\bar\button[#__b_2]\color\state])
          ;             Box(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,$FFFFFFFF)
          ;           EndIf
          ;           
          ;           ;Box(\x[#__c_frame], \y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\bar\button\color\frame[\bar\button[#__b_1]\color\state])
        Else
          If #__draw_scroll_box
            If Not \index[#__split_1] And (Not \gadget[#__split_1] Or (\gadget[#__split_1] And Not \gadget[#__split_1]\type = #PB_GadgetType_Splitter))
              Box(\bar\button[#__b_1]\x, \bar\button[#__b_1]\y,\bar\button[#__b_1]\width,\bar\button[#__b_1]\height,\bar\button\color\frame[\bar\button[#__b_1]\color\state])
            EndIf
            If Not \index[#__split_2] And (Not \gadget[#__split_2] Or (\gadget[#__split_2] And Not \gadget[#__split_2]\type = #PB_GadgetType_Splitter))
              Box(\bar\button[#__b_2]\x, \bar\button[#__b_2]\y,\bar\button[#__b_2]\width,\bar\button[#__b_2]\height,\bar\button\color\frame[\bar\button[#__b_2]\color\state])
            EndIf
          EndIf
          
          If *this\bar\thumb\len
            Protected circle_x, circle_y
            
            If *this\vertical
              circle_y = (*this\bar\button[#__b_3]\y + *this\bar\button[#__b_3]\height/2)
              circle_x = *this\x[#__c_frame] + (*this\width[#__c_frame] - *this\bar\button[#__b_3]\round)/2 + Bool(*this\width%2)
            Else
              circle_x = (*this\bar\button[#__b_3]\x + *this\bar\button[#__b_3]\width/2) ; - *this\x
              circle_y = *this\y[#__c_frame] + (*this\height[#__c_frame] - *this\bar\button[#__b_3]\round)/2 + Bool(*this\height%2)
            EndIf
            
            If \vertical ; horisontal
              If \bar\button[#__b_3]\width > 35
                Circle(circle_x - (\bar\button[#__b_3]\round*2 + 2)*2 - 2, circle_y,\bar\button[#__b_3]\round,\bar\button[#__b_3]\color\Frame[#__s_2])
                Circle(circle_x + (\bar\button[#__b_3]\round*2 + 2)*2 + 2, circle_y,\bar\button[#__b_3]\round,\bar\button[#__b_3]\color\Frame[#__s_2])
              EndIf
              If \bar\button[#__b_3]\width > 20
                Circle(circle_x - (\bar\button[#__b_3]\round*2 + 2), circle_y,\bar\button[#__b_3]\round,\bar\button[#__b_3]\color\Frame[#__s_2])
                Circle(circle_x + (\bar\button[#__b_3]\round*2 + 2), circle_y,\bar\button[#__b_3]\round,\bar\button[#__b_3]\color\Frame[#__s_2])
              EndIf
            Else
              If \bar\button[#__b_3]\height > 35
                Circle(circle_x,circle_y - (\bar\button[#__b_3]\round*2 + 2)*2 - 2, \bar\button[#__b_3]\round,\bar\button[#__b_3]\color\Frame[#__s_2])
                Circle(circle_x,circle_y + (\bar\button[#__b_3]\round*2 + 2)*2 + 2, \bar\button[#__b_3]\round,\bar\button[#__b_3]\color\Frame[#__s_2])
              EndIf
              If \bar\button[#__b_3]\height > 20
                Circle(circle_x,circle_y - (\bar\button[#__b_3]\round*2 + 2), \bar\button[#__b_3]\round,\bar\button[#__b_3]\color\Frame[#__s_2])
                Circle(circle_x,circle_y + (\bar\button[#__b_3]\round*2 + 2), \bar\button[#__b_3]\round,\bar\button[#__b_3]\color\Frame[#__s_2])
              EndIf
            EndIf
            
            Circle(circle_x, circle_y,\bar\button[#__b_3]\round,\bar\button[#__b_3]\color\Frame[#__s_2])
          EndIf
          
        EndIf
      EndWith
    EndProcedure
    
    Procedure.b Bar_Draw(*this._s_widget)
      With *this
        If \text\string  And (*this\type = #PB_GadgetType_Spin Or
                              *this\type = #PB_GadgetType_ProgressBar)
          
          _drawing_font_(*this)
          
          If \text\change Or *this\resize & #__resize_change
            
            Protected _x_ = *this\x[#__c_inner]
            Protected _y_ = *this\y[#__c_inner]
            Protected _width_ = *this\width[#__c_inner]
            Protected _height_ = *this\height[#__c_inner]
            
            If *this\text\rotate = 0
              *this\text\y = _y_ + (_height_ - *this\text\height)/2
              
              If *this\text\align\right
                *this\text\x = _x_ + (_width_ - *this\text\align\delta\x - *this\text\width - *this\text\padding\x) 
              ElseIf Not *this\text\align\left
                *this\text\x = _x_ + (_width_ - *this\text\align\delta\x - *this\text\width)/2
              Else
                *this\text\x = _x_ + *this\text\padding\x
              EndIf
              
            ElseIf *this\text\rotate = 180
              *this\text\y = _y_ + (_height_ - *this\y)
              
              If *this\text\align\right
                *this\text\x = _x_ + *this\text\padding\x + *this\text\width
              ElseIf Not *this\text\align\left
                *this\text\x = _x_ + (_width_ + *this\text\width)/2 
              Else
                *this\text\x = _x_ + _width_ - *this\text\padding\x 
              EndIf
              
            ElseIf *this\text\rotate = 90
              *this\text\x = _x_ + (_width_ - *this\text\height)/2
              
              If *this\text\align\right
                *this\text\y = _y_  + *this\text\align\delta\y +  *this\text\padding\y + *this\text\width
              ElseIf Not *this\text\align\left
                *this\text\y = _y_ + (_height_ + *this\text\align\delta\y + *this\text\width)/2
              Else
                *this\text\y = _y_ + _height_ - *this\text\padding\y
              EndIf
              
            ElseIf *this\text\rotate = 270
              *this\text\x = _x_ + (_width_ - 4)
              
              If *this\text\align\right
                *this\text\y = _y_ + (_height_ - *this\text\width - *this\text\padding\y) 
              ElseIf Not *this\text\align\left
                *this\text\y = _y_ + (_height_ - *this\text\width)/2 
              Else
                *this\text\y = _y_ + *this\text\padding\y 
              EndIf
            EndIf
            
          EndIf
        EndIf
        
        Select \type
          Case #__type_Spin           : Spin_Draw(*this)
          Case #__type_tabBar         : Tab_Draw(*this)
          Case #__type_trackBar       : Track_Draw(*this)
          Case #__type_ScrollBar      : Scroll_Draw(*this)
          Case #__type_ProgressBar    : Progress_Draw(*this)
          Case #__type_Splitter       : Splitter_Draw(*this)
        EndSelect
        
        ;            DrawingMode(#PB_2DDrawing_Outlined)
        ;            Box(\x[#__c_inner],\y[#__c_inner],\width[#__c_inner],\height[#__c_inner], $FF00FF00)
        
        If *this\text\change <> 0
          *this\text\change = 0
        EndIf
        
        If *this\bar\change <> 0
          *this\bar\change = 0
        EndIf  
      EndWith
    EndProcedure
    
    ;- 
    Procedure.b Bar_Update(*this._s_widget)
      Protected result.b, _scroll_pos_.f
      
      If Not *this\bar\thumb\change And Bool(*this\resize & #__resize_change)
        If *this\type = #PB_GadgetType_ScrollBar 
          If *this\bar\max 
            If *this\bar\button[#__b_1]\len =- 1 And *this\bar\button[#__b_2]\len =- 1
              If *this\vertical And *this\width[#__c_inner] > 7 And *this\width[#__c_inner] < 21
                *this\bar\button[#__b_1]\len = *this\width[#__c_inner] - 1
                *this\bar\button[#__b_2]\len = *this\width[#__c_inner] - 1
                
              ElseIf Not *this\vertical And *this\height[#__c_inner] > 7 And *this\height[#__c_inner] < 21
                *this\bar\button[#__b_1]\len = *this\height[#__c_inner] - 1
                *this\bar\button[#__b_2]\len = *this\height[#__c_inner] - 1
                
              Else
                *this\bar\button[#__b_1]\len = *this\bar\button[#__b_3]\len
                *this\bar\button[#__b_2]\len = *this\bar\button[#__b_3]\len
              EndIf
            EndIf
            
            If *this\bar\button[#__b_3]\len
              If *this\vertical
                If *this\width = 0
                  *this\width = *this\bar\button[#__b_3]\len
                EndIf
              Else
                If *this\height = 0
                  *this\height = *this\bar\button[#__b_3]\len
                EndIf
              EndIf
            EndIf
          EndIf
        EndIf
        
        If *this\type = #PB_GadgetType_tabBar
          If *this\vertical
            *this\bar\area\pos = *this\y[#__c_frame] + *this\bs
            *this\bar\area\len = *this\height[#__c_frame] - *this\bs*2
          Else
            *this\bar\area\pos = *this\x[#__c_frame] + *this\bs 
            *this\bar\area\len = *this\width[#__c_frame] - *this\bs*2
          EndIf
          
        Else
          If *this\vertical
            *this\bar\area\pos = *this\y[#__c_frame] + *this\bs + *this\bar\button[#__b_1]\len
            *this\bar\area\len = *this\height[#__c_frame] - *this\bs*2 - (*this\bar\button[#__b_1]\len + *this\bar\button[#__b_2]\len)
          Else
            *this\bar\area\pos = *this\x[#__c_frame] + *this\bs + *this\bar\button[#__b_1]\len
            *this\bar\area\len = *this\width[#__c_frame] - *this\bs*2 - (*this\bar\button[#__b_1]\len + *this\bar\button[#__b_2]\len)
          EndIf
        EndIf
        
        If *this\bar\area\len < *this\bar\button[#__b_3]\len 
          *this\bar\area\len = *this\bar\button[#__b_3]\len 
        EndIf
        
        If *this\type <> #PB_GadgetType_tabBar ;And *this\bar\button[#__b_3]\fixed
          
          ; if SetState(height - value or width - value)
          If *this\bar\button[#__b_3]\fixed < 0 
            Debug  "if SetState(height - value or width - value)"
            *this\bar\page\pos = *this\bar\area\len + *this\bar\button[#__b_3]\fixed
            *this\bar\button[#__b_3]\fixed = 0
          EndIf
        EndIf
        
        If *this\type = #PB_GadgetType_Splitter 
          ; one (set max)
          If Not *this\bar\max And *this\width[#__c_frame] And *this\height[#__c_frame] 
            *this\bar\thumb\len = *this\bar\button[#__b_3]\len
            *this\bar\max = (*this\bar\area\len - *this\bar\thumb\len)
            
            If Not *this\bar\page\pos 
              *this\bar\page\pos = *this\bar\max/2 
            EndIf
            
            ;if splitter fixed set splitter pos to center
            If *this\bar\fixed = #__split_1
              *this\bar\button[*this\bar\fixed]\fixed = *this\bar\page\pos
            Else
              *this\bar\button[*this\bar\fixed]\fixed = *this\bar\max - *this\bar\page\pos
            EndIf
          EndIf
        EndIf
        
        ; get page end
        If *this\type = #PB_GadgetType_tabBar
          *this\bar\page\end = *this\bar\max - *this\bar\area\len
        Else
          *this\bar\page\end = *this\bar\max - *this\bar\page\len
        EndIf
        If *this\bar\page\end < 0 : *this\bar\page\end = 0 : EndIf
        
        ; get thumb len
        If *this\type = #PB_GadgetType_tabBar
          *this\bar\thumb\len = *this\bar\area\len - *this\bar\page\end
          
        ElseIf *this\type = #PB_GadgetType_ScrollBar
          *this\bar\thumb\len = Round((*this\bar\area\len / (*this\bar\max - *this\bar\min)) * (*this\bar\page\len), #PB_Round_Nearest)
          
          If *this\bar\thumb\len > *this\bar\area\len
            *this\bar\thumb\len = *this\bar\area\len
          EndIf
          
          If *this\bar\thumb\len < *this\bar\button[#__b_3]\len 
            If *this\bar\area\len > *this\bar\button[#__b_3]\len + *this\bar\thumb\len
              *this\bar\thumb\len = *this\bar\button[#__b_3]\len 
            ElseIf *this\bar\button[#__b_3]\len > 7
              *this\bar\thumb\len = 0
            EndIf
          EndIf
          
        Else
          *this\bar\thumb\len = *this\bar\button[#__b_3]\len
        EndIf
        
        ; get area end
        ; *this\bar\thumb\end = (*this\bar\area\len - *this\bar\thumb\len)
        *this\bar\area\end = *this\bar\area\pos + (*this\bar\area\len - *this\bar\thumb\len)  
        
        ; get increment size
        If *this\bar\area\len > *this\bar\thumb\len
          If *this\type = #PB_GadgetType_tabBar
            *this\bar\percent = ((*this\bar\area\len - *this\bar\thumb\len) / ((*this\bar\max - *this\bar\min) - *this\bar\area\len)) 
          Else
            *this\bar\percent = ((*this\bar\area\len - *this\bar\thumb\len) / ((*this\bar\max - *this\bar\min) - *this\bar\page\len)) 
          EndIf 
          
          If *this\bar\fixed 
            If *this\bar\percent < 1.0
              *this\bar\percent = 1.0
            EndIf
          EndIf
        Else
          *this\bar\percent = 1.0
        EndIf
      EndIf
      
      
      If *this\type = #PB_GadgetType_Splitter And
         (*this\bar\area\len - *this\bar\thumb\len) > 0
        ;               If Not *this\bar\thumb\change And *this\bar\max > (*this\bar\area\len - *this\bar\thumb\len)
        ;                 Debug "  - " + *this\bar\max  + " " +  *this\bar\page\pos  + " " +  *this\bar\area\len  + " " +  *this\bar\thumb\pos  + " " +  Bool(*this\resize & #__resize_change)
        ;                 *this\bar\page\pos = (*this\bar\area\len - *this\bar\thumb\len)/2
        ;               EndIf
        
        ;               If *this\bar\max > (*this\bar\area\len - *this\bar\thumb\len)
        ;                 *this\bar\max = (*this\bar\area\len - *this\bar\thumb\len)
        ;                 
        ;                 *this\bar\page\end = *this\bar\max - *this\bar\page\len
        ;                 If *this\bar\page\end < 0 : *this\bar\page\end = 0 : EndIf
        ;                 
        ;                 *this\bar\percent = ((*this\bar\area\len - *this\bar\thumb\len) / ((*this\bar\max - *this\bar\min) - *this\bar\page\len)) 
        ;               EndIf
        
        ;              If *this\bar\max <> (*this\bar\area\len - *this\bar\thumb\len)
        ;                *this\bar\max = (*this\bar\area\len - *this\bar\thumb\len)
        ;                 
        ;                 *this\bar\page\end = *this\bar\max - *this\bar\page\len
        ;                 If *this\bar\page\end < 0 : *this\bar\page\end = 0 : EndIf
        ;                 
        ;                 *this\bar\percent = ((*this\bar\area\len - *this\bar\thumb\len) / ((*this\bar\max - *this\bar\min) - *this\bar\page\len)) 
        ;                
        ;                 ; If Not *this\bar\thumb\change ;And Not *this\bar\page\pos
        ;                   *this\bar\page\pos = (*this\bar\max)/2
        ;                 ;EndIf
        ;               EndIf
        
      EndIf
      
      If Not *this\bar\area\len < 0
        ; thumb pos
        If *this\type = #PB_GadgetType_Splitter And
           *this\bar\fixed And Not *this\bar\thumb\change
          ; поведение при изменении размера 
          ; чтобы вернуть fix сплиттер на свое место
          ; Debug "" + *this + " " + *this\bar\fixed
          
          If *this\bar\button[*this\bar\fixed]\fixed < 0
            *this\bar\button[*this\bar\fixed]\fixed = 0
          EndIf
          
          Protected fixed.l
          If *this\bar\button[*this\bar\fixed]\fixed > (*this\bar\area\len - *this\bar\thumb\len)
            fixed = (*this\bar\area\len - *this\bar\thumb\len)
          Else
            fixed = *this\bar\button[*this\bar\fixed]\fixed
          EndIf
          
          If fixed < 0 
            fixed = 0 
          EndIf
          
          If *this\bar\fixed = #__split_1
            *this\bar\thumb\pos = *this\bar\area\pos + fixed 
          Else
            *this\bar\thumb\pos = *this\bar\area\end - fixed 
          EndIf
          
          ; чтобы сделать паведение
          ; стандартное как в OS мне не нравится
          ;; *this\bar\button[*this\bar\fixed]\fixed = fixed
          
        Else
          ; for the scrollarea childrens
          If *this\bar\page\end And *this\bar\page\pos > *this\bar\page\end ; And *this\parent And *this\parent\scroll And *this\parent\scroll\v And *this\parent\scroll\h
            *this\bar\thumb\change = *this\bar\page\pos - *this\bar\page\end
            *this\bar\page\pos = *this\bar\page\end
          EndIf
          
          _scroll_pos_ = _bar_invert_(*this\bar, *this\bar\page\pos, *this\bar\inverted)
          *this\bar\thumb\pos = _bar_thumb_pos_(*this, _scroll_pos_)
        EndIf
        
        If *this\type = #PB_GadgetType_ScrollBar
          ; _in_start_
          If *this\bar\button[#__b_1]\len 
            If *this\bar\min >= _scroll_pos_
              *this\bar\button[#__b_1]\color\state = #__s_3
              ; *this\bar\button[#__b_1]\interact = #False
              ; *this\bar\button[#__b_1]\hide = #True
            Else
              If *this\bar\button[#__b_1]\color\state <> #__s_2
                *this\bar\button[#__b_1]\color\state = #__s_0
              EndIf
              ; *this\bar\button[#__b_1]\interact = #True
              ; *this\bar\button[#__b_1]\hide = #False
            EndIf 
          EndIf
          
          ; _in_stop_
          If *this\bar\button[#__b_2]\len
            If _scroll_pos_ >= *this\bar\page\end
              *this\bar\button[#__b_2]\color\state = #__s_3
              ; *this\bar\button[#__b_2]\interact = #False
              ; *this\bar\button[#__b_2]\hide = #True
            Else
              If *this\bar\button[#__b_2]\color\state <> #__s_2
                *this\bar\button[#__b_2]\color\state = #__s_0
              EndIf
              ; *this\bar\button[#__b_2]\interact = #True
              ; *this\bar\button[#__b_2]\hide = #False
            EndIf 
          EndIf
          
          ; disable thumb button
          If *this\bar\thumb\len
            ; Debug   "" +  *this\bar\min  + " " +  *this\bar\page\end
            If *this\bar\min >= *this\bar\page\end
              *this\bar\button[#__b_3]\color\state = #__s_3
            ElseIf *this\bar\button[#__b_3]\color\state <> #__s_2
              *this\bar\button[#__b_3]\color\state = #__s_0
            EndIf
          EndIf
        EndIf
      EndIf
      
      
      ; update draw coordinate
      If *this\draw
        If *this\type = #PB_GadgetType_ScrollBar 
          *this\bar\hide = Bool(Not (*this\bar\max > *this\bar\page\len)) ; Bool(*this\bar\min = *this\bar\page\end) ; 
          
          ; не уверен что нужно пока оставлю
          If *this\bar\hide
            If *this\bar\page\pos > *this\bar\min
              *this\bar\thumb\change = *this\bar\page\pos - *this\bar\page\end
            EndIf
            
            *this\bar\page\pos = *this\bar\min
            *this\bar\thumb\pos = _bar_thumb_pos_(*this, _bar_invert_(*this\bar, *this\bar\page\pos, *this\bar\inverted))
          EndIf
          
          If *this\bar\button[#__b_1]\len 
            If *this\vertical 
              ; Top button coordinate on vertical scroll bar
              *this\bar\button[#__b_1]\x = *this\x[#__c_frame]           + 1 ; white line size
              *this\bar\button[#__b_1]\width = *this\width[#__c_frame]  -1   ; white line size
              *this\bar\button[#__b_1]\y = *this\y[#__c_frame] 
              *this\bar\button[#__b_1]\height = *this\bar\button[#__b_1]\len                   
            Else 
              ; Left button coordinate on horizontal scroll bar
              *this\bar\button[#__b_1]\y = *this\y[#__c_frame]           + 1 ; white line size
              *this\bar\button[#__b_1]\height = *this\height[#__c_frame] - 1 ; white line size
              *this\bar\button[#__b_1]\x = *this\x[#__c_frame] 
              *this\bar\button[#__b_1]\width = *this\bar\button[#__b_1]\len 
            EndIf
          EndIf
          
          If *this\bar\button[#__b_2]\len 
            If *this\vertical 
              ; Botom button coordinate on vertical scroll bar
              *this\bar\button[#__b_2]\x = *this\x[#__c_frame]           + 1 ; white line size
              *this\bar\button[#__b_2]\width = *this\width[#__c_frame]  -1   ; white line size
              *this\bar\button[#__b_2]\height = *this\bar\button[#__b_2]\len 
              *this\bar\button[#__b_2]\y = *this\y[#__c_frame] + *this\height[#__c_frame] - *this\bar\button[#__b_2]\height
            Else 
              ; Right button coordinate on horizontal scroll bar
              *this\bar\button[#__b_2]\y = *this\y[#__c_frame]           + 1 ; white line size
              *this\bar\button[#__b_2]\height = *this\height[#__c_frame] - 1 ; white line size
              *this\bar\button[#__b_2]\width = *this\bar\button[#__b_2]\len 
              *this\bar\button[#__b_2]\x = *this\X[#__c_frame] + *this\width[#__c_frame] - *this\bar\button[#__b_2]\width 
            EndIf
          EndIf
          
          ; Thumb coordinate on scroll bar
          If *this\bar\thumb\len
            If *this\vertical
              *this\bar\button[#__b_3]\x = *this\bar\button[#__b_1]\x 
              *this\bar\button[#__b_3]\width = *this\bar\button[#__b_1]\width 
              *this\bar\button[#__b_3]\y = *this\bar\thumb\pos
              *this\bar\button[#__b_3]\height = *this\bar\thumb\len                              
            Else
              *this\bar\button[#__b_3]\y = *this\bar\button[#__b_1]\y 
              *this\bar\button[#__b_3]\height = *this\bar\button[#__b_1]\height
              *this\bar\button[#__b_3]\x = *this\bar\thumb\pos 
              *this\bar\button[#__b_3]\width = *this\bar\thumb\len                                  
            EndIf
            
          Else
            ; auto resize buttons
            If *this\vertical
              *this\bar\button[#__b_2]\height = *this\height[#__c_frame]/2 
              *this\bar\button[#__b_2]\y = *this\y[#__c_frame] + *this\bar\button[#__b_2]\height + Bool(*this\height[#__c_frame]%2) 
              
              *this\bar\button[#__b_1]\y = *this\y 
              *this\bar\button[#__b_1]\height = *this\height/2 - Bool(Not *this\height[#__c_frame]%2)
              
            Else
              *this\bar\button[#__b_2]\width = *this\width[#__c_frame]/2 
              *this\bar\button[#__b_2]\x = *this\x[#__c_frame] + *this\bar\button[#__b_2]\width + Bool(*this\width[#__c_frame]%2) 
              
              *this\bar\button[#__b_1]\x = *this\x[#__c_frame] 
              *this\bar\button[#__b_1]\width = *this\width[#__c_frame]/2 - Bool(Not *this\width[#__c_frame]%2)
            EndIf
            
            If *this\vertical
              *this\bar\button[#__b_3]\width = 0 
              *this\bar\button[#__b_3]\height = 0                             
            Else
              *this\bar\button[#__b_3]\height = 0
              *this\bar\button[#__b_3]\width = 0                                 
            EndIf
          EndIf
          
          If *this\bar\thumb\change 
            
            If *this\parent And 
               *this\parent\scroll
              
              If *this\vertical
                If *this\parent\scroll\v = *this
                  *this\parent\y[#__c_required] =- *this\bar\page\pos
                  *this\parent\change =- 1
                  
                  ; ScrollArea childrens auto resize 
                  If *this\parent\container And *this\parent\count\childrens
                    ChangeCurrentElement(widget(), *this\parent\adress)
                    While NextElement(widget())
                      If widget()\parent = *this\parent
                        Resize(widget(), #PB_Ignore, (widget()\y[#__c_draw] + *this\parent\y[#__c_required]) + *this\bar\thumb\change, #PB_Ignore, #PB_Ignore)
                      EndIf
                    Wend
                  EndIf
                EndIf
              Else
                If *this\parent\scroll\h = *this
                  *this\parent\x[#__c_required] =- *this\bar\page\pos
                  *this\parent\change =- 2
                  
                  ; ScrollArea childrens auto resize 
                  If *this\parent\container And *this\parent\count\childrens
                    ChangeCurrentElement(widget(), *this\parent\adress)
                    While NextElement(widget())
                      If widget()\parent = *this\parent
                        Resize(widget(), (widget()\x[#__c_draw] + *this\parent\x[#__c_required]) + *this\bar\thumb\change, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                      EndIf
                    Wend
                  EndIf
                EndIf
              EndIf
            EndIf
          EndIf
          
          result = *this\bar\hide
        EndIf
        
        If *this\type = #PB_GadgetType_TabBar 
          ; _in_start_
          If *this\bar\button[#__b_1]\len 
            If *this\bar\min >= _scroll_pos_
              *this\bar\button[#__b_1]\color\state = #__s_3
              ; *this\bar\button[#__b_1]\interact = #False
              *this\bar\button[#__b_1]\hide = #True
            Else
              If *this\bar\button[#__b_1]\color\state <> #__s_2
                *this\bar\button[#__b_1]\color\state = #__s_0
              EndIf
              ; *this\bar\button[#__b_1]\interact = #True
              *this\bar\button[#__b_1]\hide = #False
            EndIf 
          EndIf
          
          ; _in_stop_
          If *this\bar\button[#__b_2]\len
            If _scroll_pos_ >= *this\bar\page\end
              *this\bar\button[#__b_2]\color\state = #__s_3
              ; *this\bar\button[#__b_2]\interact = #False
              *this\bar\button[#__b_2]\hide = #True
            Else
              If *this\bar\button[#__b_2]\color\state <> #__s_2
                *this\bar\button[#__b_2]\color\state = #__s_0
              EndIf
              ; *this\bar\button[#__b_2]\interact = #True
              *this\bar\button[#__b_2]\hide = #False
            EndIf 
          EndIf
          
          If *this\vertical
            *this\x[#__c_inner] = *this\x[#__c_frame] + *this\bs
            *this\y[#__c_inner] = *this\y[#__c_frame] + *this\bs + Bool(*this\bar\button[#__b_2]\color\state <> #__s_3) * *this\bar\button[#__b_1]\len + 1
            *this\height[#__c_inner] = *this\height[#__c_frame] - *this\bs*2 - (Bool(*this\bar\button[#__b_2]\color\state <> #__s_3) * *this\bar\button[#__b_1]\len + Bool(*this\bar\button[#__b_1]\color\state <> #__s_3) * *this\bar\button[#__b_2]\len) - 2
            *this\width[#__c_inner] = *this\width[#__c_frame] - *this\bs - 1
          Else
            *this\y[#__c_inner] = *this\y[#__c_frame] + *this\bs
            *this\x[#__c_inner] = *this\x[#__c_frame] + *this\bs + Bool(*this\bar\button[#__b_2]\color\state <> #__s_3) * *this\bar\button[#__b_1]\len + 1
            *this\width[#__c_inner] = *this\width[#__c_frame] - *this\bs*2 - (Bool(*this\bar\button[#__b_2]\color\state <> #__s_3) * *this\bar\button[#__b_1]\len + Bool(*this\bar\button[#__b_1]\color\state <> #__s_3) * *this\bar\button[#__b_2]\len) - 2
            *this\height[#__c_inner] = *this\height[#__c_frame] - *this\bs - 1
          EndIf
          
          If *this\bar\button[#__b_2]\len 
            If *this\vertical 
              ; Top button coordinate on vertical scroll bar
              *this\bar\button[#__b_2]\x = *this\x[#__c_inner]  + (*this\width[#__c_inner] - *this\bar\button[#__b_2]\len)/2            
              *this\bar\button[#__b_2]\width = *this\bar\button[#__b_2]\len
              *this\bar\button[#__b_2]\y = *this\y[#__c_frame] + *this\bs
              *this\bar\button[#__b_2]\height = *this\bar\button[#__b_2]\len                   
            Else 
              ; Left button coordinate on horizontal scroll bar
              *this\bar\button[#__b_2]\y = *this\y[#__c_inner] + (*this\height[#__c_inner] - *this\bar\button[#__b_2]\len)/2           
              *this\bar\button[#__b_2]\height = *this\bar\button[#__b_2]\len
              *this\bar\button[#__b_2]\x = *this\x[#__c_frame] + *this\bs
              *this\bar\button[#__b_2]\width = *this\bar\button[#__b_2]\len 
            EndIf
          EndIf
          
          If *this\bar\button[#__b_1]\len 
            If *this\vertical 
              ; Botom button coordinate on vertical scroll bar
              *this\bar\button[#__b_1]\x = *this\x[#__c_inner] + (*this\width[#__c_inner] - *this\bar\button[#__b_1]\len)/2             
              *this\bar\button[#__b_1]\width  = *this\bar\button[#__b_1]\len
              *this\bar\button[#__b_1]\height = *this\bar\button[#__b_1]\len 
              *this\bar\button[#__b_1]\y = *this\y + *this\height - *this\bar\button[#__b_1]\height - *this\bs
            Else 
              ; Right button coordinate on horizontal scroll bar
              *this\bar\button[#__b_1]\y = *this\y[#__c_inner] + (*this\height[#__c_inner] - *this\bar\button[#__b_1]\len)/2            
              *this\bar\button[#__b_1]\height = *this\bar\button[#__b_1]\len
              *this\bar\button[#__b_1]\width = *this\bar\button[#__b_1]\len 
              *this\bar\button[#__b_1]\x = *this\X[#__c_frame] + *this\width[#__c_frame] - *this\bar\button[#__b_1]\width - *this\bs
            EndIf
          EndIf
          
          ;If *this\bar\thumb\len
          If *this\vertical
            *this\bar\button[#__b_3]\x = *this\x[#__c_inner]           
            *this\bar\button[#__b_3]\width = *this\width[#__c_inner]
            *this\bar\button[#__b_3]\height = *this\bar\max                             
            *this\bar\button[#__b_3]\y = (*this\bar\area\pos + _bar_page_pos_(*this\bar, *this\bar\thumb\pos) - *this\bar\page\end)
          Else
            *this\bar\button[#__b_3]\y = *this\y[#__c_inner]           
            *this\bar\button[#__b_3]\height = *this\height[#__c_inner]
            *this\bar\button[#__b_3]\width = *this\bar\max
            *this\bar\button[#__b_3]\x = (*this\bar\area\pos + _bar_page_pos_(*this\bar, *this\bar\thumb\pos) - *this\bar\page\end)
          EndIf
          ;EndIf
          
          result = Bool(*this\resize & #__resize_change)
        EndIf
        
        If *this\type = #PB_GadgetType_ProgressBar
          *this\bar\button[#__b_1]\x        = *this\X[#__c_frame]
          *this\bar\button[#__b_1]\y        = *this\y[#__c_frame]
          
          If *this\vertical
            *this\bar\button[#__b_1]\width  = *this\width[#__c_frame]
            *this\bar\button[#__b_1]\height = *this\bar\thumb\pos - *this\y 
          Else
            *this\bar\button[#__b_1]\width  = *this\bar\thumb\pos - *this\x 
            *this\bar\button[#__b_1]\height = *this\height[#__c_frame]
          EndIf
          
          If *this\vertical
            *this\bar\button[#__b_2]\x      = *this\x[#__c_frame]
            *this\bar\button[#__b_2]\y      = *this\bar\thumb\pos + *this\bar\thumb\len
            *this\bar\button[#__b_2]\width  = *this\width[#__c_frame]
            *this\bar\button[#__b_2]\height = *this\height - (*this\bar\thumb\pos + *this\bar\thumb\len - *this\y)
          Else
            *this\bar\button[#__b_2]\x      = *this\bar\thumb\pos + *this\bar\thumb\len
            *this\bar\button[#__b_2]\y      = *this\y[#__c_frame]
            *this\bar\button[#__b_2]\width  = *this\width[#__c_frame] - (*this\bar\thumb\pos + *this\bar\thumb\len - *this\x)
            *this\bar\button[#__b_2]\height = *this\height[#__c_frame]
          EndIf
          
          If *this\text
            *this\text\change = 1
            *this\text\string = "%" + Str(*this\bar\page\pos)   + " " +  Str(*this\width[#__c_frame])
          EndIf
          
          result = Bool(*this\resize & #__resize_change)
        EndIf
        
        If *this\type = #PB_GadgetType_TrackBar 
          If *this\bar\button[#__b_1]\color\state <> Bool(Not *this\bar\inverted) * #__s_2 Or 
             *this\bar\button[#__b_2]\color\state <> Bool(*this\bar\inverted) * #__s_2
            *this\bar\button[#__b_1]\color\state = Bool(Not *this\bar\inverted) * #__s_2
            *this\bar\button[#__b_2]\color\state = Bool(*this\bar\inverted) * #__s_2
            *this\bar\button[#__b_3]\color\state = #__s_2
          EndIf
          
          ; Thumb coordinate on scroll bar
          If *this\bar\thumb\len
            If *this\vertical
              *this\bar\button[#__b_3]\x      = *this\bar\button\x 
              *this\bar\button[#__b_3]\width  = *this\bar\button\width 
              *this\bar\button[#__b_3]\y      = *this\bar\thumb\pos
              *this\bar\button[#__b_3]\height = *this\bar\thumb\len                              
            Else
              *this\bar\button[#__b_3]\y      = *this\bar\button\y 
              *this\bar\button[#__b_3]\height = *this\bar\button\height
              *this\bar\button[#__b_3]\x      = *this\bar\thumb\pos 
              *this\bar\button[#__b_3]\width  = *this\bar\thumb\len                                  
            EndIf
          EndIf
          
          ; draw track bar coordinate
          If *this\vertical
            *this\bar\button[#__b_1]\width    = 4
            *this\bar\button[#__b_2]\width    = 4
            *this\bar\button[#__b_3]\width    = *this\bar\button[#__b_3]\len + (Bool(*this\bar\button[#__b_3]\len<10)**this\bar\button[#__b_3]\len)
            
            *this\bar\button[#__b_1]\y        = *this\y
            *this\bar\button[#__b_1]\height   = *this\bar\thumb\pos - *this\y + *this\bar\thumb\len/2
            
            *this\bar\button[#__b_2]\y        = *this\bar\thumb\pos + *this\bar\thumb\len/2
            *this\bar\button[#__b_2]\height   = *this\height - (*this\bar\thumb\pos + *this\bar\thumb\len/2 - *this\y)
            
            If *this\bar\inverted
              *this\bar\button[#__b_1]\x      = *this\x[#__c_frame] + 6
              *this\bar\button[#__b_2]\x      = *this\x[#__c_frame] + 6
              *this\bar\button[#__b_3]\x      = *this\bar\button[#__b_1]\x - *this\bar\button[#__b_3]\width/4 - 1 -  Bool(*this\bar\button[#__b_3]\len>10)
            Else
              *this\bar\button[#__b_1]\x      = *this\x[#__c_frame] + *this\width[#__c_frame] - *this\bar\button[#__b_1]\width - 6
              *this\bar\button[#__b_2]\x      = *this\x[#__c_frame] + *this\width[#__c_frame] - *this\bar\button[#__b_2]\width - 6 
              *this\bar\button[#__b_3]\x      = *this\bar\button[#__b_1]\x - *this\bar\button[#__b_3]\width/2 + Bool(*this\bar\button[#__b_3]\len>10)
            EndIf
          Else
            *this\bar\button[#__b_1]\height   = 4
            *this\bar\button[#__b_2]\height   = 4
            *this\bar\button[#__b_3]\height   = *this\bar\button[#__b_3]\len + (Bool(*this\bar\button[#__b_3]\len<10)**this\bar\button[#__b_3]\len)
            
            *this\bar\button[#__b_1]\x        = *this\X[#__c_frame]
            *this\bar\button[#__b_1]\width    = *this\bar\thumb\pos - *this\x[#__c_frame] + *this\bar\thumb\len/2
            
            *this\bar\button[#__b_2]\x        = *this\bar\thumb\pos + *this\bar\thumb\len/2
            *this\bar\button[#__b_2]\width    = *this\width[#__c_frame] - (*this\bar\thumb\pos + *this\bar\thumb\len/2 - *this\x)
            
            If *this\bar\inverted
              *this\bar\button[#__b_1]\y      = *this\y[#__c_frame] + *this\height[#__c_frame] - *this\bar\button[#__b_1]\height - 6
              *this\bar\button[#__b_2]\y      = *this\y[#__c_frame] + *this\height[#__c_frame] - *this\bar\button[#__b_2]\height - 6 
              *this\bar\button[#__b_3]\y      = *this\bar\button[#__b_1]\y - *this\bar\button[#__b_3]\height/2 + Bool(*this\bar\button[#__b_3]\len>10)
            Else
              *this\bar\button[#__b_1]\y      = *this\y[#__c_frame] + 6
              *this\bar\button[#__b_2]\y      = *this\y[#__c_frame] + 6
              *this\bar\button[#__b_3]\y      = *this\bar\button[#__b_1]\y - *this\bar\button[#__b_3]\height/4 - 1 -  Bool(*this\bar\button[#__b_3]\len>10)
            EndIf
          EndIf
          
          result = Bool(*this\resize & #__resize_change)
        EndIf
        
        If *this\type = #PB_GadgetType_Splitter 
          If *this\vertical
            *this\bar\button[#__b_1]\width    = *this\width[#__c_frame]
            *this\bar\button[#__b_1]\height   = *this\bar\thumb\pos - *this\y[#__c_frame] 
            
            *this\bar\button[#__b_1]\x        = *this\x[#__c_frame] + (Bool(*this\index[#__split_1])**this\x[#__c_frame])
            *this\bar\button[#__b_2]\x        = *this\x[#__c_frame] + (Bool(*this\index[#__split_2])**this\x[#__c_frame])
            
            If Not ((#PB_Compiler_OS = #PB_OS_MacOS) And *this\index[#__split_1] And Not *this\parent)
              *this\bar\button[#__b_1]\y      = *this\y[#__c_frame] + (Bool(*this\index[#__split_1])**this\y[#__c_frame])
              *this\bar\button[#__b_2]\y      = (*this\bar\thumb\pos + *this\bar\thumb\len) + (Bool(*this\index[#__split_2])**this\y[#__c_frame])
            Else
              *this\bar\button[#__b_1]\y      = *this\height[#__c_frame] - *this\bar\button[#__b_1]\height
            EndIf
            
            *this\bar\button[#__b_2]\height   = *this\height[#__c_frame] - (*this\bar\button[#__b_1]\height + *this\bar\thumb\len)
            *this\bar\button[#__b_2]\width    = *this\width[#__c_frame]
            
            If *this\bar\thumb\len
              *this\bar\button[#__b_3]\x      = *this\x[#__c_frame]
              *this\bar\button[#__b_3]\y      = *this\bar\thumb\pos
              *this\bar\button[#__b_3]\height = *this\bar\thumb\len                              
              *this\bar\button[#__b_3]\width  = *this\width[#__c_frame] 
            EndIf
          Else
            *this\bar\button[#__b_1]\width    = *this\bar\thumb\pos - *this\x[#__c_frame] 
            *this\bar\button[#__b_1]\height   = *this\height[#__c_frame]
            
            *this\bar\button[#__b_1]\y        = *this\y[#__c_frame] + (Bool(*this\index[#__split_1])**this\y[#__c_frame])
            *this\bar\button[#__b_2]\y        = *this\y[#__c_frame] + (Bool(*this\index[#__split_2])**this\y[#__c_frame])
            *this\bar\button[#__b_1]\x        = *this\x[#__c_frame] + (Bool(*this\index[#__split_1])**this\x[#__c_frame])
            *this\bar\button[#__b_2]\x        = (*this\bar\thumb\pos + *this\bar\thumb\len) + (Bool(*this\index[#__split_2])**this\x[#__c_frame])
            
            *this\bar\button[#__b_2]\width    = *this\width[#__c_frame] - (*this\bar\button[#__b_1]\width + *this\bar\thumb\len)
            *this\bar\button[#__b_2]\height   = *this\height[#__c_frame]
            
            If *this\bar\thumb\len
              *this\bar\button[#__b_3]\y      = *this\y[#__c_frame]
              *this\bar\button[#__b_3]\x      = *this\bar\thumb\pos
              *this\bar\button[#__b_3]\width  = *this\bar\thumb\len                                  
              *this\bar\button[#__b_3]\height = *this\height[#__c_frame]
            EndIf
          EndIf
          
          ; 
          If *this\bar\fixed And *this\bar\thumb\change
            If *this\vertical
              *this\bar\button[*this\bar\fixed]\fixed = *this\bar\button[*this\bar\fixed]\height - *this\bar\button[*this\bar\fixed]\len
            Else
              *this\bar\button[*this\bar\fixed]\fixed = *this\bar\button[*this\bar\fixed]\width - *this\bar\button[*this\bar\fixed]\len
            EndIf
          EndIf
          
          ; Splitter childrens auto resize       
          If *this\gadget[#__split_1]
            If *this\index[#__split_1]
              If *this\root\canvas\container
                ResizeGadget(*this\gadget[#__split_1], *this\bar\button[#__b_1]\x - *this\x[#__c_frame], *this\bar\button[#__b_1]\y - *this\y, *this\bar\button[#__b_1]\width, *this\bar\button[#__b_1]\height)
              Else
                ResizeGadget(*this\gadget[#__split_1], (*this\bar\button[#__b_1]\x - *this\x[#__c_frame]) + GadgetX(*this\root\canvas\gadget), (*this\bar\button[#__b_1]\y - *this\y[#__c_frame]) + GadgetY(*this\root\canvas\gadget), *this\bar\button[#__b_1]\width, *this\bar\button[#__b_1]\height)
              EndIf
            Else
              If *this\gadget[#__split_1]\x <> *this\bar\button[#__b_1]\x Or ;  - *this\x
                 *this\gadget[#__split_1]\y <> *this\bar\button[#__b_1]\y Or ;  - *this\y
                 *this\gadget[#__split_1]\width <> *this\bar\button[#__b_1]\width Or
                 *this\gadget[#__split_1]\height <> *this\bar\button[#__b_1]\height
                ; Debug "splitter_1_resize " + *this\gadget[#__split_1]
                Resize(*this\gadget[#__split_1], *this\bar\button[#__b_1]\x - *this\x[#__c_frame], *this\bar\button[#__b_1]\y - *this\y[#__c_frame], *this\bar\button[#__b_1]\width, *this\bar\button[#__b_1]\height)
              EndIf
            EndIf
          EndIf
          
          If *this\gadget[#__split_2]
            If *this\index[#__split_2]
              If *this\root\canvas\container 
                ResizeGadget(*this\gadget[#__split_2], *this\bar\button[#__b_2]\x - *this\x[#__c_frame], *this\bar\button[#__b_2]\y - *this\y[#__c_frame], *this\bar\button[#__b_2]\width, *this\bar\button[#__b_2]\height)
              Else
                ResizeGadget(*this\gadget[#__split_2], (*this\bar\button[#__b_2]\x - *this\x[#__c_frame]) + GadgetX(*this\root\canvas\gadget), (*this\bar\button[#__b_2]\y - *this\y[#__c_frame]) + GadgetY(*this\root\canvas\gadget), *this\bar\button[#__b_2]\width, *this\bar\button[#__b_2]\height)
              EndIf
            Else
              If *this\gadget[#__split_2]\x <> *this\bar\button[#__b_2]\x Or ;  - *this\x
                 *this\gadget[#__split_2]\y <> *this\bar\button[#__b_2]\y Or ;  - *this\y
                 *this\gadget[#__split_2]\width <> *this\bar\button[#__b_2]\width Or
                 *this\gadget[#__split_2]\height <> *this\bar\button[#__b_2]\height 
                ; Debug "splitter_2_resize " + *this\gadget[#__split_2]
                Resize(*this\gadget[#__split_2], *this\bar\button[#__b_2]\x - *this\x[#__c_frame], *this\bar\button[#__b_2]\y - *this\y[#__c_frame], *this\bar\button[#__b_2]\width, *this\bar\button[#__b_2]\height)
              EndIf
            EndIf   
          EndIf      
          
          result = Bool(*this\resize & #__resize_change)
        EndIf
        
        If *this\type = #PB_GadgetType_Spin
          If *this\vertical      
            ; Top button coordinate
            *this\bar\button[#__b_2]\y      = *this\y[#__c_inner] + *this\height[#__c_inner]/2 + Bool(*this\height%2)
            *this\bar\button[#__b_2]\height = *this\height[#__c_inner]/2 - 1 
            *this\bar\button[#__b_2]\width  = *this\bar\button[#__b_2]\len 
            *this\bar\button[#__b_2]\x      = (*this\x[#__c_inner] + *this\width[#__c_draw]) - *this\bar\button[#__b_2]\len - 1
            
            ; Bottom button coordinate
            *this\bar\button[#__b_1]\y      = *this\y[#__c_inner] + 1 
            *this\bar\button[#__b_1]\height = *this\height[#__c_inner]/2 - Bool(Not *this\height%2) - 1
            *this\bar\button[#__b_1]\width  = *this\bar\button[#__b_1]\len 
            *this\bar\button[#__b_1]\x      = (*this\x[#__c_inner] + *this\width[#__c_draw]) - *this\bar\button[#__b_1]\len - 1                               
          Else    
            ; Left button coordinate
            *this\bar\button[#__b_1]\y      = *this\y[#__c_inner] + 1
            *this\bar\button[#__b_1]\height = *this\height[#__c_inner] - 2
            *this\bar\button[#__b_1]\width  = *this\bar\button[#__b_1]\len/2 - 1
            *this\bar\button[#__b_1]\x      = *this\x + *this\width - *this\bar\button[#__b_1]\len - 1   
            
            ; Right button coordinate
            *this\bar\button[#__b_2]\y      = *this\y[#__c_inner] + 1 
            *this\bar\button[#__b_2]\height = *this\height[#__c_inner] - 2
            *this\bar\button[#__b_2]\width  = *this\bar\button[#__b_2]\len/2 - 1
            *this\bar\button[#__b_2]\x      = *this\x[#__c_inner] + *this\width[#__c_draw] - *this\bar\button[#__b_2]\len/2                             
          EndIf
          
          ; 
          If *this\text And 
             (*this\bar\thumb\change Or *this\text\string = "")
            Protected i : For i = 0 To 3
              If *this\bar\increment = ValF(StrF(*this\bar\increment, i))
                *this\text\string = StrF(*this\bar\page\pos, i)
                *this\text\change = 1
                Break
              EndIf
            Next
          EndIf
          
          result = Bool(*this\resize & #__resize_change)
        EndIf
      EndIf
      
      
      If *this\bar\thumb\change <> 0
        *this\bar\thumb\change = 0
      EndIf  
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b Bar_SetPos(*this._s_widget, ThumbPos.i)
      If ThumbPos < *this\bar\area\pos : ThumbPos = *this\bar\area\pos : EndIf
      If ThumbPos > *this\bar\area\end : ThumbPos = *this\bar\area\end : EndIf
      
      If *this\bar\thumb\end <> ThumbPos : *this\bar\thumb\end = ThumbPos
        ProcedureReturn Bar_SetState(*this, _bar_invert_(*this\bar, _bar_page_pos_(*this\bar, ThumbPos), *this\bar\inverted))
      EndIf
    EndProcedure
    
    Procedure.b Bar_Change(*this._s_widget, ScrollPos.f)
      With *this
        If ScrollPos < \bar\min 
          ;If *this\type <> #PB_GadgetType_tabBar
          ; if SetState(height - value or width - value)
          \bar\button[#__b_3]\fixed = ScrollPos
          ;EndIf
          ScrollPos = \bar\min 
          
        ElseIf \bar\max And ScrollPos > \bar\page\end ; = (\bar\max - \bar\page\len)
          If \bar\max >= \bar\page\len 
            ScrollPos = \bar\page\end
          Else
            ScrollPos = \bar\min 
          EndIf
        EndIf
        
        ;Debug  "  " + ScrollPos  + " " +  \bar\page\pos  + " " +  \bar\page\end
        
        If \bar\page\pos <> ScrollPos 
          \bar\thumb\change = \bar\page\pos - ScrollPos
          
          If \bar\page\pos > ScrollPos
            \bar\direction =- ScrollPos
          Else
            \bar\direction = ScrollPos
          EndIf
          
          \bar\page\change = \bar\thumb\change
          \bar\page\pos = ScrollPos
          ProcedureReturn #True
        EndIf
      EndWith
    EndProcedure
    
    Procedure.b Bar_SetState(*this._s_widget, state.f)
      Protected result
      
      If Bar_Change(*this, state) 
        Bar_Update(*this)
        
        ; post event
        If Not (*this\type = #PB_GadgetType_ScrollBar And _is_scrollbar_(*this))
          If *this\type <> #PB_GadgetType_tabBar
            If *this\root\canvas\gadget <> EventGadget() 
              ReDraw(*this\root) ; сним у панель setstate хурмить
            EndIf
          EndIf
          
          Post(#PB_EventType_Change, *this, *this\bar\from, *this\bar\direction)
        Else
          Post(#PB_EventType_ScrollChange, *this\parent, *this, *this\bar\direction)
        EndIf
        
        result = #True
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l Bar_SetAttribute(*this._s_widget, Attribute.l, *value)
      Protected result.l
      
      With *this
        If \type = #PB_GadgetType_Splitter
          Select Attribute
            Case #PB_Splitter_FirstMinimumSize
              \bar\min = *value
              \bar\button[#__b_1]\len = *value
              result = Bool(\bar\max)
              
            Case #PB_Splitter_SecondMinimumSize
              \bar\button[#__b_2]\len = *value
              result = Bool(\bar\max)
              
            Case #PB_Splitter_FirstGadget
              *this\gadget[#__split_1] = *value
              *this\index[#__split_1] = Bool(IsGadget(*value))
              result = 1
              
            Case #PB_Splitter_SecondGadget
              *this\gadget[#__split_2] = *value
              *this\index[#__split_2] = Bool(IsGadget(*value))
              result = 1
              
          EndSelect
          
        Else
          Select Attribute
            Case #__bar_minimum
              If \bar\min <> *value And Not *value < 0
                \bar\area\change = \bar\min - *value
                If \bar\page\pos < *value
                  \bar\page\pos = *value
                EndIf
                \bar\min = *value
                ;Debug  " min " + \bar\min + " max " + \bar\max
                result = #True
              EndIf
              
            Case #__bar_maximum
              If \bar\max <> *value And Not *value < 0
                \bar\area\change = \bar\max - *value
                If \bar\min > *value
                  \bar\max = \bar\min + 1
                Else
                  \bar\max = *value
                EndIf
                
                If Not \bar\max
                  \bar\page\pos = \bar\max
                EndIf
                ;Debug  "   min " + \bar\min + " max " + \bar\max
                
                ;\bar\thumb\change = #True
                result = #True
              EndIf
              
            Case #__bar_pagelength
              If \bar\page\len <> *value And Not *value < 0
                \bar\area\change = \bar\page\len - *value
                \bar\page\len = *value
                
                If Not \bar\max
                  If \bar\min > *value
                    \bar\max = \bar\min + 1
                  Else
                    \bar\max = *value
                  EndIf
                EndIf
                
                result = #True
              EndIf
              
            Case #__bar_buttonsize
              If \bar\button[#__b_3]\len <> *value
                \bar\button[#__b_3]\len = *value
                
                If \type = #PB_GadgetType_ScrollBar
                  \bar\button[#__b_1]\len = *value
                  \bar\button[#__b_2]\len = *value
                EndIf
                
                If \type = #PB_GadgetType_tabBar
                  \bar\button[#__b_1]\len = *value
                  \bar\button[#__b_2]\len = *value
                EndIf
                
                *this\resize | #__resize_change
                result = #True
              EndIf
              
            Case #__bar_inverted
              \bar\inverted = Bool(*value)
              ProcedureReturn Update(*this)
              
            Case #__bar_ScrollStep 
              \bar\increment = *value
              
          EndSelect
        EndIf
        
        If result ; And \width And \height ; есть проблемы с imagegadget и scrollareagadget
                  ;\bar\thumb\change = #True
                  ;Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) 
          Update(*this) ; \hide = 
        EndIf
      EndWith
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   Updates(*this._s_widget, x.l,y.l,width.l,height.l)
      Static v_max, h_max
      Protected sx, sy, round
      Protected result
      
      If *this\scroll\v\bar\page\len <> height - Bool(*this\width[#__c_required] > width) * *this\scroll\h\height
        *this\scroll\v\bar\page\len = height - Bool(*this\width[#__c_required] > width) * *this\scroll\h\height
      EndIf
      
      If *this\scroll\h\bar\page\len <> width - Bool(*this\height[#__c_required] > height) * *this\scroll\v\width
        *this\scroll\h\bar\page\len = width - Bool(*this\height[#__c_required] > height) * *this\scroll\v\width
      EndIf
      
      If *this\x[#__c_required] < x
        ; left set state
        *this\scroll\v\bar\page\len = height - *this\scroll\h\height
      Else
        sx = (*this\x[#__c_required] - x) 
        *this\width[#__c_required] + sx
        *this\x[#__c_required] = x
      EndIf
      
      If *this\y[#__c_required] < y
        ; top set state
        *this\scroll\h\bar\page\len = width - *this\scroll\v\width
      Else
        sy = (*this\y[#__c_required] - y)
        *this\height[#__c_required] + sy
        *this\y[#__c_required] = y
      EndIf
      
      If *this\width[#__c_required] > *this\scroll\h\bar\page\len - (*this\x[#__c_required] - x)
        If *this\width[#__c_required] - sx <= width And *this\height[#__c_required] = *this\scroll\v\bar\page\len - (*this\y[#__c_required] - y)
          ;Debug "w - " + Str(*this\height[#__c_required] - sx)
          
          ; if on the h - scroll
          If *this\scroll\v\bar\max > height - *this\scroll\h\height
            *this\scroll\v\bar\page\len = height - *this\scroll\h\height
            *this\scroll\h\bar\page\len = width - *this\scroll\v\width 
            *this\height[#__c_required] = *this\scroll\v\bar\max
            ;  Debug "w - " + *this\scroll\v\bar\max  + " " +  *this\scroll\v\height  + " " +  *this\scroll\v\bar\page\len
          Else
            *this\height[#__c_required] = *this\scroll\v\bar\page\len - (*this\x[#__c_required] - x) - *this\scroll\h\height
          EndIf
        EndIf
        
        *this\scroll\v\bar\page\len = height - *this\scroll\h\height 
      Else
        *this\scroll\h\bar\max = *this\width[#__c_required]
        *this\width[#__c_required] = *this\scroll\h\bar\page\len - (*this\x[#__c_required] - x)
      EndIf
      
      If *this\height[#__c_required] > *this\scroll\v\bar\page\len - (*this\y[#__c_required] - y)
        If *this\height[#__c_required] - sy <= Height And *this\width[#__c_required] = *this\scroll\h\bar\page\len - (*this\x[#__c_required] - x)
          ;Debug " h - " + Str(*this\height[#__c_required] - sy)
          
          ; if on the v - scroll
          If *this\scroll\h\bar\max > width - *this\scroll\v\width
            *this\scroll\h\bar\page\len = width - *this\scroll\v\width
            *this\scroll\v\bar\page\len = height - *this\scroll\h\height 
            *this\width[#__c_required] = *this\scroll\h\bar\max
            ;  Debug "h - " + *this\scroll\h\bar\max  + " " +  *this\scroll\h\width  + " " +  *this\scroll\h\bar\page\len
          Else
            *this\width[#__c_required] = *this\scroll\h\bar\page\len - (*this\x[#__c_required] - x) - *this\scroll\v\width
          EndIf
        EndIf
        
        *this\scroll\h\bar\page\len = width - *this\scroll\v\width
      Else
        *this\scroll\v\bar\max = *this\height[#__c_required]
        *this\height[#__c_required] = *this\scroll\v\bar\page\len - (*this\y[#__c_required] - y)
      EndIf
      
      If *this\scroll\h\round And
         *this\scroll\v\round And
         *this\scroll\h\bar\page\len < width And 
         *this\scroll\v\bar\page\len < height
        round = (*this\scroll\h\height/4)
      EndIf
      
      If *this\width[#__c_required] >= *this\scroll\h\bar\page\len  
        If *this\scroll\h\bar\Max <> *this\width[#__c_required] 
          *this\scroll\h\bar\Max = *this\width[#__c_required]
          
          If *this\x[#__c_required] <= x 
            *this\scroll\h\bar\page\pos =- (*this\x[#__c_required] - x)
            *this\scroll\h\bar\change = 0
          EndIf
        EndIf
        
        If *this\scroll\h\width <> *this\scroll\h\bar\page\len + round
          ; Debug  "h " + *this\scroll\h\bar\page\len
          *this\scroll\h\hide = Resize(*this\scroll\h, #PB_Ignore, #PB_Ignore, *this\scroll\h\bar\page\len + round, #PB_Ignore)
          ;           *this\scroll\h\width = *this\scroll\h\bar\page\len + round
          ;           *this\scroll\h\hide = Bar_Update(*this\scroll\h)
          result = 1
        EndIf
      EndIf
      
      If *this\height[#__c_required] >= *this\scroll\v\bar\page\len  
        If *this\scroll\v\bar\Max <> *this\height[#__c_required]  
          *this\scroll\v\bar\Max = *this\height[#__c_required]
          
          If *this\y[#__c_required] <= y 
            ;If *this\scroll\v\bar\page\pos <>- (*this\y[#__c_required] - y)
            *this\scroll\v\bar\page\pos =- (*this\y[#__c_required] - y)
            
            *this\scroll\v\bar\change = 0
            ; Post(#PB_EventType_change, *this\scroll\v)
            ;EndIf
          EndIf
        EndIf
        
        If *this\scroll\v\height <> *this\scroll\v\bar\page\len + round
          ; Debug  "v " + *this\scroll\v\bar\page\len
          *this\scroll\v\hide = Resize(*this\scroll\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, *this\scroll\v\bar\page\len + round)
          ;           *this\scroll\v\height = *this\scroll\v\bar\page\len + round
          ;           *this\scroll\v\hide = Bar_Update(*this\scroll\v)
          result = 1
        EndIf
      EndIf
      
      ;       If Not *this\scroll\h\hide 
      ;         If *this\scroll\h\y[#__c_draw] <> y + height - *this\scroll\h\height
      ;           ; Debug "y"
      ;           *this\scroll\h\hide = Resize(*this\scroll\h, #PB_Ignore, y + height - *this\scroll\h\height, #PB_Ignore, #PB_Ignore)
      ;         EndIf
      ;         If *this\scroll\h\x[#__c_draw] <> x
      ;           ; Debug "y"
      ;           *this\scroll\h\hide = Resize(*this\scroll\h, x, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      ;         EndIf
      ;       EndIf
      ;       
      ;       If Not *this\scroll\v\hide 
      ;         If *this\scroll\v\x[#__c_draw] <> x + width - *this\scroll\v\width
      ;           ; Debug "x"
      ;           *this\scroll\v\hide = Resize(*this\scroll\v, x + width - *this\scroll\v\width, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      ;         EndIf
      ;         If *this\scroll\v\y[#__c_draw] <> y
      ;           ; Debug "y"
      ;           *this\scroll\v\hide = Resize(*this\scroll\v, #PB_Ignore, y, #PB_Ignore, #PB_Ignore)
      ;         EndIf
      ;       EndIf
      
      If v_max <> *this\scroll\v\bar\Max
        v_max = *this\scroll\v\bar\Max
        *this\scroll\v\resize | #__resize_change
        *this\scroll\v\hide = Bar_Update(*this\scroll\v) 
      EndIf
      
      If h_max <> *this\scroll\h\bar\Max
        h_max = *this\scroll\h\bar\Max
        *this\scroll\h\resize | #__resize_change
        *this\scroll\h\hide = Bar_Update(*this\scroll\h) 
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   Bar_Resizes(*this._s_widget, x.l,y.l,width.l,height.l)
      ;       *this\width[#__c_required] = *this\scroll\h\bar\max
      ;       *this\height[#__c_required] = *this\scroll\v\bar\max
      ;       
      ;       ProcedureReturn Updates(*this, x.l,y.l,width.l,height.l)
      
      
      ;       y = #PB_Ignore 
      ;         x = #PB_Ignore 
      ;           Width = #PB_Ignore 
      ;           Height = #PB_Ignore 
      ;           
      Macro _get_page_height_(_this_, _scroll_, _round_ = 0)
        (_scroll_\v\bar\page\len + Bool(_round_ And _scroll_\v\round And _scroll_\h\round And Not _scroll_\h\hide) * (_scroll_\h\height/4)) 
      EndMacro
      
      Macro _get_page_width_(_this_, _scroll_, _round_ = 0)
        (_scroll_\h\bar\page\len + Bool(_round_ And _scroll_\v\round And _scroll_\h\round And Not _scroll_\v\hide) * (_scroll_\v\width/4))
      EndMacro
      
      Macro _make_area_height_(_this_, _scroll_, _width_, _height_)
        (_height_ - (Bool((_this_\width[#__c_required] > _width_) Or Not _scroll_\h\hide) * _scroll_\h\height)) 
      EndMacro
      
      Macro _make_area_width_(_this_, _scroll_, _width_, _height_)
        (_width_ - (Bool((_this_\height[#__c_required] > _height_) Or Not _scroll_\v\hide) * _scroll_\v\width))
      EndMacro
      
      With *this\scroll
        Protected iHeight, iWidth, v_x = #PB_Ignore, h_y = #PB_Ignore
        
        If Not *this\scroll\v Or Not *this\scroll\h
          ProcedureReturn
        EndIf
        
        If y = #PB_Ignore : y = \v\y[#__c_frame] - \v\parent\y[#__c_inner] : EndIf
        If x = #PB_Ignore : x = \h\x[#__c_frame] - \v\parent\x[#__c_inner] : EndIf
        If Width = #PB_Ignore : Width = \v\x[#__c_frame] - \h\x[#__c_frame] + \v\width[#__c_frame] : EndIf
        If Height = #PB_Ignore : Height = \h\y[#__c_frame] - \v\y[#__c_frame] + \h\height[#__c_frame] : EndIf
        
        If Width + x - *this\scroll\v\width[#__c_frame] <> *this\scroll\v\x[#__c_draw]
          v_x = Width + x - *this\scroll\v\width[#__c_frame]
        EndIf
        
        If Height + y - *this\scroll\h\height[#__c_frame] <> *this\scroll\h\y[#__c_draw]
          h_y = Height + y - *this\scroll\h\height[#__c_frame]
        EndIf
        ;Debug _make_area_height_(*this,*this\scroll, Width, Height)
        ;If
        Bar_SetAttribute(*this\scroll\v, #__bar_pagelength, _make_area_height_(*this,*this\scroll, Width, Height))
        *this\scroll\v\hide = widget::Resize(*this\scroll\v, v_x, y, #PB_Ignore, _get_page_height_(*this,*this\scroll, 1))
        ;EndIf
        
        ;If 
        Bar_SetAttribute(*this\scroll\h, #__bar_pagelength, _make_area_width_(*this,*this\scroll, Width, Height))
        *this\scroll\h\hide = widget::Resize(*this\scroll\h, x, h_y, _get_page_width_(*this,*this\scroll, 1), #PB_Ignore)
        ;EndIf
        
        If Bar_SetAttribute(*this\scroll\v, #__bar_pagelength, _make_area_height_(*this,*this\scroll, Width, Height))
          *this\scroll\v\hide = widget::Resize(*this\scroll\v, v_x, #PB_Ignore, #PB_Ignore, _get_page_height_(*this,*this\scroll, 1))
        EndIf
        
        If Bar_SetAttribute(*this\scroll\h, #__bar_pagelength, _make_area_width_(*this,*this\scroll, Width, Height))
          *this\scroll\h\hide = widget::Resize(*this\scroll\h, #PB_Ignore, h_y, _get_page_width_(*this,*this\scroll, 1), #PB_Ignore)
        EndIf
        
        *this\scroll\v\hide = Bar_Update(*this\scroll\v)
        *this\scroll\h\hide = Bar_Update(*this\scroll\h)
        ;         
        ;         *this\scroll\v\hide = *this\scroll\v\bar\hide ; Bool(*this\scroll\v\bar\min = *this\scroll\v\bar\page\end)
        ;         *this\scroll\h\hide = *this\scroll\h\bar\hide ; Bool(*this\scroll\h\bar\min = *this\scroll\h\bar\page\end)
        ;         
        ProcedureReturn Bool(*this\scroll\v\bar\area\change Or *this\scroll\h\bar\area\change)
      EndWith
    EndProcedure
    
    
    Procedure   Bar_Events(*this._s_widget, eventtype.l, mouse_x.l, mouse_y.l, _wheel_x_.b = 0, _wheel_y_.b = 0)
      Protected Repaint
      Protected bar_button = *this\bar\index
      
      
      If eventtype = #__Event_MouseEnter
        Repaint | #True
      EndIf
      
      If eventtype = #__Event_MouseLeave
        Repaint | #True
      EndIf
      
      If eventtype = #__Event_leftButtonUp 
        If bar_button >= 0
          If *this\bar\button[bar_button]\state = #__s_2
            ;Debug " up button - " + bar_button
            *this\bar\button[bar_button]\state = #__s_1
            Repaint | #True
          EndIf
          
          ;Debug "" + bar_button  + " " +  *this\bar\from
          
          If bar_button <> *this\bar\from
            If *this\bar\button[bar_button]\state = #__s_1
              *this\bar\button[bar_button]\state = #__s_0
              
              If bar_button = #__b_3 
                If *this\cursor And *this\bar\button[#__b_2]\len <> $ffffff
                  _set_cursor_(*this, #PB_Cursor_Default)
                EndIf
              EndIf
              
              ; Debug " up leave button - " + bar_button
              Repaint | #True
            EndIf
          EndIf
          
          If *this\type = #PB_GadgetType_tabBar
            If bar_button = #__b_3
              If *this\index[#__s_1] >= 0 And 
                 *this\index[#__s_2] <> *this\index[#__s_1]
                Repaint | Tab_SetState(*this, *this\index[#__s_1])
              EndIf
            EndIf
          EndIf
          
          *this\bar\index =- 1 
        EndIf
      EndIf
      
      If eventtype = #__Event_MouseMove Or
         eventtype = #__Event_MouseEnter Or
         eventtype = #__Event_MouseLeave Or
         eventtype = #__Event_leftButtonUp
        
        
        If *this\bar\button[#__b_3]\interact And
           *this\bar\button[#__b_3]\state <> #__s_3 And
           _from_point_(mouse_x, mouse_y, *this, [#__c_inner]) And
           _from_point_(mouse_x, mouse_y, *this\bar\button[#__b_3])
          
          If *this\bar\from <> #__b_3
            If *this\bar\button[#__b_3]\state = #__s_0
              *this\bar\button[#__b_3]\state = #__s_1
              
              If *this\bar\from = #__b_1
                ; Debug " leave button - (1 >> 3)"
                If *this\bar\button[#__b_1]\state = #__s_1
                  *this\bar\button[#__b_1]\state = #__s_0
                EndIf
              EndIf
              
              If *this\bar\from = #__b_2
                ; Debug " leave button - (2 >> 3)"
                If *this\bar\button[#__b_2]\state = #__s_1  
                  *this\bar\button[#__b_2]\state = #__s_0
                EndIf
              EndIf
              
              If *this\cursor And Not _is_selected_(*this)
                If *this\bar\button[#__b_2]\len <> $ffffff
                  _set_cursor_(*this, *this\cursor)
                EndIf
              EndIf
              
              *this\bar\from = #__b_3
              ; Debug " enter button - 3"
              Repaint | #True
            EndIf
          EndIf
          
        ElseIf *this\bar\button[#__b_2]\interact And
               *this\bar\button[#__b_2]\state <> #__s_3 And 
               _from_point_(mouse_x, mouse_y, *this\bar\button[#__b_2])
          
          If *this\bar\from <> #__b_2
            If *this\bar\button[#__b_2]\state = #__s_0
              *this\bar\button[#__b_2]\state = #__s_1
              
              If *this\bar\from = #__b_1
                ; Debug " leave button - (1 >> 2)"
                If *this\bar\button[#__b_1]\state = #__s_1
                  *this\bar\button[#__b_1]\state = #__s_0
                EndIf
              EndIf
              
              If *this\bar\from = #__b_3
                ; Debug " leave button - (3 >> 2)"
                If *this\bar\button[#__b_3]\state = #__s_1  
                  *this\bar\button[#__b_3]\state = #__s_0
                EndIf
              EndIf
              
              *this\bar\from = #__b_2
              ; Debug " enter button - 2"
              Repaint | #True
            EndIf
          EndIf
          
        ElseIf *this\bar\button[#__b_1]\interact And 
               *this\bar\button[#__b_1]\state <> #__s_3 And 
               _from_point_(mouse_x, mouse_y, *this\bar\button[#__b_1])
          
          If *this\bar\from <> #__b_1
            If *this\bar\button[#__b_1]\state = #__s_0
              *this\bar\button[#__b_1]\state = #__s_1
              
              If *this\bar\from = #__b_2
                ; Debug " leave button - (2 >> 1)"
                If *this\bar\button[#__b_2]\state = #__s_1  
                  *this\bar\button[#__b_2]\state = #__s_0
                EndIf
              EndIf
              
              If *this\bar\from = #__b_3
                ; Debug " leave button - (3 >> 1)"
                If *this\bar\button[#__b_3]\state = #__s_1  
                  *this\bar\button[#__b_3]\state = #__s_0
                EndIf
              EndIf
              
              *this\bar\from = #__b_1
              ; Debug " enter button - 1"
              Repaint | #True
            EndIf
          EndIf
          
        Else
          If *this\bar\from <>- 1
            If *this\bar\button[*this\bar\from]\state = #__s_1
              *this\bar\button[*this\bar\from]\state = #__s_0
              
              If Not _is_selected_(*this)
                If *this\cursor And *this\bar\from = #__b_3
                  If *this\bar\button[#__b_2]\len <> $ffffff
                    _set_cursor_(*this, #PB_Cursor_Default)
                  EndIf
                EndIf
              EndIf
              
              ; Debug " leave button - " + *this\bar\from
            EndIf
            
            *this\bar\from =- 1
            Repaint | #True
          EndIf
        EndIf
        
        If *this\type = #PB_GadgetType_tabBar
          If *this\count\items
            ForEach *this\bar\_s()
              ; If *this\bar\_s()\draw
              If _from_point_((mouse_x - *this\x[#__c_frame]) + Bool(Not *this\vertical) * *this\bar\page\pos, mouse_y - *this\y[#__c_frame] + Bool(*this\vertical) * *this\bar\page\pos, *this\bar\_s()) And *this\bar\from = #__b_3
                ;If _from_point_(mouse_x, mouse_y, *this\bar\_s()) And *this\bar\from = #__b_3
                If *this\index[#__s_1] <> *this\bar\_s()\index
                  If *this\index[#__s_1] >= 0
                    ; Debug " leave tab - " + *this\index[#__s_1]
                    Repaint | #True
                  EndIf
                  
                  *this\index[#__s_1] = *this\bar\_s()\index
                  ; Debug " enter tab - " + *this\index[#__s_1]
                  Repaint | #True
                EndIf
                Break
                
              ElseIf *this\index[#__s_1] = *this\bar\_s()\index
                ; Debug " leave tab - " + *this\index[#__s_1]
                *this\index[#__s_1] =- 1
                Repaint | #True
                Break
              EndIf
              ; EndIf
            Next
          EndIf
        Else       
          ;         If Not Mouse()\buttons
          ;          ; *this\bar\index = *this\bar\from
          ;         EndIf
        EndIf
        
        ; set color state
        If *this\type <> #PB_GadgetType_TrackBar
          ; set button_1 color state
          If *this\bar\button[#__b_1]\color\state <> #__s_3 And 
             *this\bar\button[#__b_1]\color\state <> *this\bar\button[#__b_1]\state
            *this\bar\button[#__b_1]\color\state = *this\bar\button[#__b_1]\state
          EndIf
          
          ; set button_2 color state
          If *this\bar\button[#__b_2]\color\state <> #__s_3 And 
             *this\bar\button[#__b_2]\color\state <> *this\bar\button[#__b_2]\state
            *this\bar\button[#__b_2]\color\state = *this\bar\button[#__b_2]\state
          EndIf
          
          ; set thumb color state
          If *this\bar\button[#__b_3]\color\state <> #__s_3 And 
             *this\bar\button[#__b_3]\color\state <> *this\bar\button[#__b_3]\state
            *this\bar\button[#__b_3]\color\state = *this\bar\button[#__b_3]\state
          EndIf
        EndIf
      EndIf
      
      If eventtype = #__Event_leftButtonDown
        If *this\bar\from >= 0 And 
           *this\bar\button[*this\bar\from]\state = #__s_1
          *this\bar\button[*this\bar\from]\state = #__s_2
          
          If *this\type <> #PB_GadgetType_TrackBar
            ; set color state
            If *this\bar\button[*this\bar\from]\color\state <> #__s_3 And 
               *this\bar\button[*this\bar\from]\color\state <> *this\bar\button[*this\bar\from]\state
              *this\bar\button[*this\bar\from]\color\state = *this\bar\button[*this\bar\from]\state
            EndIf
          EndIf
          
          If *this\bar\from = #__b_3
            Repaint = #True
          ElseIf (*this\bar\from = #__b_1 And *this\bar\inverted) Or
                 (*this\bar\from = #__b_2 And Not *this\bar\inverted)
            
            Post(#PB_EventType_Down, *this)
            Repaint | Bar_SetState(*this, *this\bar\page\pos + *this\bar\increment)
            
          ElseIf (*this\bar\from = #__b_2 And *this\bar\inverted) Or 
                 (*this\bar\from = #__b_1 And Not *this\bar\inverted)
            
            Post(#PB_EventType_Up, *this)
            Repaint | Bar_SetState(*this, *this\bar\page\pos - *this\bar\increment)
          EndIf
          
          *this\bar\index = *this\bar\from
        EndIf
      EndIf
      
      If eventtype = #__Event_MouseMove
        If bar_button And _is_selected_(*this)
          
          If *this\vertical
            Repaint | Bar_SetPos(*this, (mouse_y - Mouse()\delta\y))
          Else
            Repaint | Bar_SetPos(*this, (mouse_x - Mouse()\delta\x))
          EndIf
          
          SetWindowTitle(EventWindow(), Str(*this\bar\page\pos)  + " " +  Str(*this\bar\thumb\pos - *this\bar\area\pos))
        EndIf
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    ;}
    
    
    ;- 
    ;-  EDITOR
    Macro  _start_drawing_(_this_)
      StartDrawing(CanvasOutput(_this_\root\canvas\gadget)) 
      
      _drawing_font_(_this_)
      ;       If _this_\text\fontID
      ;         DrawingFont(_this_\text\fontID) 
      ;       EndIf
    EndMacro
    
    Macro _row_x_(_this_)
      (_this_\x[#__c_inner] + _this_\row\_s()\x + _this_\x[#__c_required])
    EndMacro
    
    Macro _row_y_(_this_)
      (_this_\y[#__c_inner] + _this_\row\_s()\y + _this_\y[#__c_required])
    EndMacro
    
    Macro _row_text_x_(_this_)
      (_this_\x[#__c_inner] + _this_\row\_s()\text\x + _this_\x[#__c_required])
    EndMacro
    
    Macro _row_text_y_(_this_)
      (_this_\y[#__c_inner] + _this_\row\_s()\text\y + _this_\y[#__c_required])
    EndMacro
    
    Macro _row_text_edit_x_(_this_, _mode_)
      (_this_\x[#__c_inner] + _this_\row\_s()\text\edit#_mode_\x + _this_\x[#__c_required])
    EndMacro
    
    Macro _row_text_edit_y_(_this_, _mode_)
      (_this_\y[#__c_inner] + _this_\row\_s()\text\edit#_mode_\y + _this_\y[#__c_required])
    EndMacro
    
    Macro _text_scroll_x_(_this_)
      If *this\scroll\h 
        If _this_\text\caret\x
          *this\change = _bar_scrollarea_change_(*this\scroll\h, _this_\text\caret\x - _this_\text\padding\x, (_this_\text\padding\x * 2 + _this_\row\margin\width)) ; ok
        EndIf
      EndIf
    EndMacro
    
    Macro _text_scroll_y_(_this_)
      If *this\scroll\v
        *this\change = _bar_scrollarea_change_(*this\scroll\v, _this_\text\caret\y - _this_\text\padding\y, (_this_\text\padding\y * 2 + _this_\text\caret\height)) ; ok
      EndIf
    EndMacro
    
    
    
    ;- 
    Procedure.l _text_caret_(*this._s_widget)
      ; Get caret position
      Protected i.l, X.l, Position.l =- 1,  
                MouseX.l, Distance.f, MinDistance.f = Infinity()
      
      MouseX = Mouse()\x - _row_text_x_(*this)
      
      For i = 0 To *this\row\_s()\text\len
        X = TextWidth(Left(*this\row\_s()\text\string, i))
        Distance = (MouseX - X)*(MouseX - X)
        
        If MinDistance > Distance 
          MinDistance = Distance
          Position = i
        EndIf
      Next 
      
      ProcedureReturn Position
    EndProcedure
    
    Procedure   _edit_sel_(*this._s_widget, _pos_, _len_)
      If _pos_ < 0 : _pos_ = 0 : EndIf
      If _len_ < 0 : _len_ = 0 : EndIf
      
      If _pos_ > *this\row\_s()\text\len
        _pos_ = *this\row\_s()\text\len
      EndIf
      
      If _len_ > *this\row\_s()\text\len
        _len_ = *this\row\_s()\text\len
      EndIf
      
      Protected _line_ = *this\index[#__s_1]
      Protected _caret_last_len_ = Bool(_line_ <> *this\index[#__s_2] And 
                                        (*this\row\_s()\index < *this\index[#__s_1] Or 
                                         *this\row\_s()\index < *this\index[#__s_2])) * *this\mode\fullselection
      
      ;     If  _caret_last_len_
      ;       _caret_last_len_ = *this\width[2]
      ;     EndIf
      
      *this\row\_s()\text\edit[1]\len = _pos_
      *this\row\_s()\text\edit[2]\len = _len_
      
      *this\row\_s()\text\edit[1]\pos = 0 
      *this\row\_s()\text\edit[2]\pos = *this\row\_s()\text\edit[1]\len
      
      *this\row\_s()\text\edit[3]\pos = *this\row\_s()\text\edit[2]\pos + *this\row\_s()\text\edit[2]\len 
      *this\row\_s()\text\edit[3]\len = *this\row\_s()\text\len - *this\row\_s()\text\edit[3]\pos
      
      ; set string & size (left;selected;right)
      If *this\row\_s()\text\edit[1]\len > 0
        *this\row\_s()\text\edit[1]\string = Left(*this\row\_s()\text\string, *this\row\_s()\text\edit[1]\len)
        *this\row\_s()\text\edit[1]\width = TextWidth(*this\row\_s()\text\edit[1]\string) 
      Else
        *this\row\_s()\text\edit[1]\string = ""
        *this\row\_s()\text\edit[1]\width = 0
      EndIf
      If *this\row\_s()\text\edit[2]\len > 0
        If *this\row\_s()\text\edit[2]\len <> *this\row\_s()\text\len
          *this\row\_s()\text\edit[2]\string = Mid(*this\row\_s()\text\string, 1 + *this\row\_s()\text\edit[2]\pos, *this\row\_s()\text\edit[2]\len)
          *this\row\_s()\text\edit[2]\width = TextWidth(*this\row\_s()\text\edit[2]\string) + _caret_last_len_ 
          ;         + Bool((_line_ <  *this\index[2] And *this\row\_s()\index = _line_) Or
          ;                                                                                                  ;(_line_ <> *this\row\_s()\index And *this\row\_s()\index <> *this\index[2]) Or
          ;         (_line_  > *this\index[2] And *this\row\_s()\index = *this\index[2])) * *this\mode\fullselection
        Else
          *this\row\_s()\text\edit[2]\string = *this\row\_s()\text\string
          *this\row\_s()\text\edit[2]\width = *this\row\_s()\text\width + _caret_last_len_
        EndIf
      Else
        *this\row\_s()\text\edit[2]\string = ""
        *this\row\_s()\text\edit[2]\width = _caret_last_len_
      EndIf
      
      If *this\row\_s()\text\edit[3]\len > 0
        *this\row\_s()\text\edit[3]\string = Right(*this\row\_s()\text\string, *this\row\_s()\text\edit[3]\len)
        *this\row\_s()\text\edit[3]\width = TextWidth(*this\row\_s()\text\edit[3]\string)  
      Else
        *this\row\_s()\text\edit[3]\string = ""
        *this\row\_s()\text\edit[3]\width = 0
      EndIf
      
      ; because bug in mac os
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        If *this\row\_s()\text\edit[2]\width And Not (_line_ = *this\index[#__s_2] And *this\text\caret\pos[1] > *this\text\caret\pos[2]) And
           *this\row\_s()\text\edit[2]\width <> *this\row\_s()\text\width - (*this\row\_s()\text\edit[1]\width + *this\row\_s()\text\edit[3]\width) + _caret_last_len_
          *this\row\_s()\text\edit[2]\width = *this\row\_s()\text\width - (*this\row\_s()\text\edit[1]\width + *this\row\_s()\text\edit[3]\width) + _caret_last_len_
        EndIf
      CompilerEndIf
      
      ; для красоты
      If *this\row\_s()\text\edit[2]\width > *this\width[#__c_required]
        *this\row\_s()\text\edit[2]\width - _caret_last_len_
      EndIf
      
      ; set position (left;selected;right)
      *this\row\_s()\text\edit[1]\x = *this\row\_s()\text\x 
      *this\row\_s()\text\edit[2]\x = (*this\row\_s()\text\edit[1]\x + *this\row\_s()\text\edit[1]\width) 
      *this\row\_s()\text\edit[3]\x = (*this\row\_s()\text\edit[2]\x + *this\row\_s()\text\edit[2]\width)
      
      ; если выделили свнизу вверх
      ; то запоминаем позицию начала текста[3]
      If *this\index[#__s_2] >= *this\row\_s()\index
        *this\text\edit[1]\len = (*this\row\_s()\text\pos + *this\row\_s()\text\edit[2]\pos)
        *this\text\edit[2]\pos = *this\text\edit[1]\len
      EndIf
      
      ; если выделили сверху ввниз
      ; то запоминаем позицию начала текста[3]
      If *this\index[#__s_2] <= *this\row\_s()\index
        *this\text\edit[3]\pos = (*this\row\_s()\text\pos + *this\row\_s()\text\edit[3]\pos)
        *this\text\edit[3]\len = (*this\text\len - *this\text\edit[3]\pos)
      EndIf
      
      ; text/pos/len/state
      If _line_ = *this\row\_s()\index
        If *this\text\edit[2]\len <> (*this\text\edit[3]\pos - *this\text\edit[2]\pos)
          *this\text\edit[2]\len = (*this\text\edit[3]\pos - *this\text\edit[2]\pos)
        EndIf
        
        ; set text (left;selected;right)
        If *this\text\edit[1]\len > 0
          *this\text\edit[1]\string = Left(*this\text\string.s, *this\text\edit[1]\len) 
        Else
          *this\text\edit[1]\string = ""
        EndIf
        If *this\text\edit[2]\len > 0
          *this\text\edit[2]\string = Mid(*this\text\string.s, 1 + *this\text\edit[2]\pos, *this\text\edit[2]\len) 
        Else
          *this\text\edit[2]\string = ""
        EndIf
        If *this\text\edit[3]\len > 0
          *this\text\edit[3]\string = Right(*this\text\string.s, *this\text\edit[3]\len)
        Else
          *this\text\edit[3]\string = ""
        EndIf
        
        ;       ; set cursor pos
        ;       If _line_ = *this\row\_s()\index
        *this\text\caret\y = *this\row\_s()\text\y + Bool(#PB_Compiler_OS <> #PB_OS_Windows)
        *this\text\caret\height = *this\row\_s()\text\height
        
        If _line_ > *this\index[#__s_2] Or
           (_line_ = *this\index[#__s_2] And *this\text\caret\pos[1] > *this\text\caret\pos[2])
          *this\text\caret\x = *this\row\_s()\text\edit[3]\x
          *this\text\caret\pos = *this\row\_s()\text\pos + *this\row\_s()\text\edit[3]\pos
        Else
          ;           If *this\row\_s()\text\edit[2]\x
          *this\text\caret\x = *this\row\_s()\text\edit[2]\x
          ;           Else
          ;             *this\text\caret\x = *this\text\padding\x
          ;           EndIf
          *this\text\caret\pos = *this\row\_s()\text\pos + *this\row\_s()\text\edit[2]\pos
        EndIf
        
        ;*this\text\caret\width = 1
        
        ProcedureReturn 1
        ;       EndIf
      EndIf
      
    EndProcedure
    
    Procedure   _edit_sel_set_(*this._s_widget, _line_, _scroll_) ; Ok
                                                                  ;     Debug  "" + *this\text\caret\pos[1]  + " " +  *this\text\caret\pos[2]
                                                                  ;     ProcedureReturn 3
      Macro _edit_sel_reset_(_this_)
        _this_\text\edit[1]\len = 0 
        _this_\text\edit[2]\len = 0 
        _this_\text\edit[3]\len = 0 
        
        _this_\text\edit[1]\pos = 0 
        _this_\text\edit[2]\pos = 0 
        _this_\text\edit[3]\pos = 0 
        
        _this_\text\edit[1]\width = 0 
        _this_\text\edit[2]\width = 0 
        _this_\text\edit[3]\width = 0 
        
        _this_\text\edit[1]\string = ""
        _this_\text\edit[2]\string = "" 
        _this_\text\edit[3]\string = ""
      EndMacro
      
      
      If _scroll_
        
        PushListPosition(*this\row\_s()) 
        ForEach *this\row\_s()
          If (_line_ = *this\row\_s()\index Or *this\index[#__s_2] = *this\row\_s()\index) Or    ; линия
             (_line_ < *this\row\_s()\index And *this\index[#__s_2] > *this\row\_s()\index) Or   ; верх
             (_line_ > *this\row\_s()\index And *this\index[#__s_2] < *this\row\_s()\index)      ; вниз
            
            If _line_ = *this\index[#__s_2]  ; And *this\index[2] = *this\row\_s()\index
              If *this\text\caret\pos[1] > *this\text\caret\pos[2]
                _edit_sel_(*this, *this\text\caret\pos[2], *this\text\caret\pos[1] - *this\text\caret\pos[2])
              Else
                _edit_sel_(*this, *this\text\caret\pos[1], *this\text\caret\pos[2] - *this\text\caret\pos[1])
              EndIf
              
            ElseIf (_line_ < *this\row\_s()\index And *this\index[#__s_2] > *this\row\_s()\index) Or   ; верх
                   (_line_ > *this\row\_s()\index And *this\index[#__s_2] < *this\row\_s()\index)      ; вниз
              
              If _line_ < 0
                ; если курсор перешел за верхный предел
                *this\index[#__s_1] = 0
                *this\text\caret\pos[1] = 0
              ElseIf _line_ > *this\count\items - 1
                ; если курсор перешел за нижный предел
                *this\index[#__s_1] = *this\count\items - 1
                *this\text\caret\pos[1] = *this\row\_s()\text\len
              EndIf
              
              _edit_sel_(*this, 0, *this\row\_s()\text\len)
              
            ElseIf _line_ = *this\row\_s()\index 
              If _line_ > *this\index[#__s_2] 
                _edit_sel_(*this, 0, *this\text\caret\pos[1])
              Else
                _edit_sel_(*this, *this\text\caret\pos[1], *this\row\_s()\text\len - *this\text\caret\pos[1])
              EndIf
              
            ElseIf *this\index[#__s_2] = *this\row\_s()\index
              
              
              If *this\count\items = 1 And 
                 (_line_ < 0 Or _line_ > *this\count\items - 1)
                ; если курсор перешел за пределы итемов
                *this\index[#__s_1] = 0
                
                If *this\text\caret\pos[2] > *this\text\caret\pos[1]
                  _edit_sel_(*this, 0, *this\text\caret\pos[2])
                Else
                  *this\text\caret\pos[1] = *this\row\_s()\text\len
                  _edit_sel_(*this, *this\text\caret\pos[2], Bool(_line_ <> *this\index[#__s_2]) * (*this\row\_s()\text\len - *this\text\caret\pos[2]))
                EndIf
                
                *this\index[#__s_1] = _line_
              Else
                If _line_ < 0
                  *this\index[#__s_1] = 0
                  *this\text\caret\pos[1] = 0
                ElseIf _line_ > *this\count\items - 1
                  *this\index[#__s_1] = *this\count\items - 1
                  *this\text\caret\pos[1] = *this\row\_s()\text\len
                EndIf
                
                If *this\index[#__s_2] > _line_ 
                  _edit_sel_(*this, 0, *this\text\caret\pos[2])
                Else
                  _edit_sel_(*this, *this\text\caret\pos[2], (*this\row\_s()\text\len - *this\text\caret\pos[2]))
                EndIf
              EndIf
              
            EndIf
            
            If *this\index[#__s_1] = *this\row\_s()\index
              ; vertical scroll
              If _scroll_ = 1
                _text_scroll_y_(*this)
              EndIf
              
              ; horizontal scroll
              If _scroll_ =- 1
                _text_scroll_x_(*this)
              EndIf
            EndIf
            
          ElseIf (*this\row\_s()\text\edit[2]\width <> 0 And 
                  *this\index[#__s_2] <> *this\row\_s()\index And _line_ <> *this\row\_s()\index)
            
            ; reset selected string
            _edit_sel_reset_(*this\row\_s())
            
          EndIf
        Next
        PopListPosition(*this\row\_s()) 
        
      EndIf 
      
      ProcedureReturn _scroll_
    EndProcedure
    
    Procedure   _edit_sel_draw_(*this._s_widget, _line_, _caret_ = -1) ; Ok
      Protected Repaint.b
      
      Macro _edit_sel_is_line_(_this_)
        Bool(_this_\row\_s()\text\edit[2]\width And 
             Mouse()\x > _this_\row\_s()\text\edit[2]\x - _this_\scroll\h\bar\page\pos And
             Mouse()\y > _this_\row\_s()\text\y - _this_\scroll\v\bar\page\pos And 
             Mouse()\y < (_this_\row\_s()\text\y + _this_\row\_s()\text\height) - _this_\scroll\v\bar\page\pos And
             Mouse()\x < (_this_\row\_s()\text\edit[2]\x + _this_\row\_s()\text\edit[2]\width) - _this_\scroll\h\bar\page\pos)
      EndMacro
      
      With *this
        ; select enter mouse item
        If _line_ >= 0 And 
           _line_ < *this\count\items And 
           _line_ <> *this\row\_s()\index
          \row\_s()\color\state = 0
          SelectElement(*this\row\_s(), _line_) 
          \row\_s()\color\state = 1
        EndIf
        
        If _start_drawing_(*this)
          
          If _caret_ =- 1
            _caret_ = _text_caret_(*this) 
          Else
            ; Ctrl - A
            Repaint =- 2
          EndIf
          
          ; если перемещаем выделеный текст
          If *this\row\box\state 
            If *this\index[#__s_1] <> _line_
              *this\index[#__s_1] = _line_
              Repaint = 1
            EndIf
            
            If _edit_sel_is_line_(*this)
              If *this\text\caret\pos[2] <> *this\row\_s()\text\edit[1]\len
                *this\text\caret\pos[2] = *this\row\_s()\text\edit[1]\len
                *this\text\caret\pos[1] = *this\row\_s()\text\edit[1]\len + *this\row\_s()\text\edit[2]\len
                
                If _caret_ < *this\row\_s()\text\edit[1]\len + *this\row\_s()\text\edit[2]\len/2
                  _caret_ = *this\row\_s()\text\edit[1]\len
                Else
                  _caret_ = *this\row\_s()\text\edit[1]\len + *this\row\_s()\text\edit[2]\len
                EndIf
                
                Repaint =- 1
              EndIf
            Else
              If *this\text\caret\pos[2] <> _caret_
                *this\text\caret\pos[2] = _caret_
                *this\text\caret\pos[1] = _caret_
                Repaint =- 1
              EndIf
            EndIf
            
            If Repaint 
              ; set cursor pos
              *this\text\caret\y = *this\row\_s()\text\y
              *this\text\caret\height = *this\row\_s()\text\height - 1
              *this\text\caret\x = *this\row\_s()\text\x + TextWidth(Left(*this\row\_s()\text\string, _caret_))
              _text_scroll_x_(*this)
            EndIf
            
          Else
            If *this\text\caret\pos[1] <> _caret_
              *this\text\caret\pos[1] = _caret_
              Repaint =- 1 ; scroll horizontal
            EndIf
            
            If *this\index[#__s_1] <> _line_ 
              *this\index[#__s_1] = _line_ ; scroll vertical
              Repaint = 1
            EndIf
            
            Repaint = _edit_sel_set_(*this, _line_, Repaint)
          EndIf
          
          StopDrawing() 
        EndIf
      EndWith
      
      ProcedureReturn Bool(Repaint)
    EndProcedure
    
    Procedure   _edit_sel_update_(*this._s_widget)
      ; ProcedureReturn 
      
      ; key - (return & backspace)
      If *this\index[#__s_2] = *this\row\_s()\index 
        *this\row\selected = *this\row\_s()
        
        If *this\index[#__s_2] = *this\index[#__s_1]
          If *this\text\caret\pos[1] > *this\text\caret\pos[2]
            _edit_sel_(*this, *this\text\caret\pos[2] , *this\text\caret\pos[1] - *this\text\caret\pos[2])
          Else
            _edit_sel_(*this, *this\text\caret\pos[1] , *this\text\caret\pos[2] - *this\text\caret\pos[1])
          EndIf
        EndIf
      EndIf
      
      ;     If *this\row\count = *this\count\items
      ;       ; move caret
      ;       If *this\index[2] + 1 = *this\row\_s()\index 
      ;         ;         *this\index[1] = *this\row\_s()\index 
      ;         ;         *this\index[2] = *this\index[1]
      ;         
      ;         If *this\index[2] = *this\index[1]
      ;           If *this\text\caret\pos[1]<>*this\text\caret\pos[2]
      ;             _edit_sel_(*this, 0, *this\text\caret\pos[1] - *this\row\selected\text\len)
      ;           Else
      ;             _edit_sel_(*this, *this\text\caret\pos[1] - *this\row\selected\text\len, 0)
      ;           EndIf
      ;         EndIf
      ;         
      ;       EndIf
      ;     EndIf
      
      
      
      
      Protected  _line_ = *this\index[#__s_1]
      ;       If _line_ > 0 
      ;         SelectElement(*this\row\_s(), _line_)
      ;       EndIf
      
      ;; PushListPosition(*this\row\_s())
      
      If _line_ = *this\index[#__s_2]  ; And *this\index[2] = *this\row\_s()\index
        If *this\text\caret\pos[1] > *this\text\caret\pos[2]
          _edit_sel_(*this, *this\text\caret\pos[2], *this\text\caret\pos[1] - *this\text\caret\pos[2])
        Else
          _edit_sel_(*this, *this\text\caret\pos[1], *this\text\caret\pos[2] - *this\text\caret\pos[1])
        EndIf
        
      ElseIf (*this\index[#__s_2] > *this\row\_s()\index And _line_ < *this\row\_s()\index) Or   ; верх
             (*this\index[#__s_2] < *this\row\_s()\index And _line_ > *this\row\_s()\index)      ; вниз
        
        _edit_sel_(*this, 0, *this\row\_s()\text\len)
        
      ElseIf _line_ = *this\row\_s()\index 
        If _line_ > *this\index[#__s_2] 
          _edit_sel_(*this, 0, *this\text\caret\pos[1])
        Else
          _edit_sel_(*this, *this\text\caret\pos[1], *this\row\_s()\text\len - *this\text\caret\pos[1])
        EndIf
        
      ElseIf *this\index[#__s_2] = *this\row\_s()\index
        If *this\index[#__s_2] > _line_ 
          _edit_sel_(*this, 0, *this\text\caret\pos[2])
        Else
          _edit_sel_(*this, *this\text\caret\pos[2], *this\row\_s()\text\len - *this\text\caret\pos[2])
        EndIf
        
      EndIf
      
      ;; PopListPosition(*this\row\_s())
      
      
      
      
      ProcedureReturn 
      
      If (*this\index[#__s_2] = *this\row\_s()\index Or *this\index[#__s_1] = *this\row\_s()\index) Or    ; линия
         (*this\index[#__s_2] > *this\row\_s()\index And *this\index[#__s_1] < *this\row\_s()\index) Or   ; верх
         (*this\index[#__s_2] < *this\row\_s()\index And *this\index[#__s_1] > *this\row\_s()\index)      ; вниз
        
        If (*this\index[#__s_2] > *this\row\_s()\index And *this\index[#__s_1] < *this\row\_s()\index) Or   ; верх
           (*this\index[#__s_2] < *this\row\_s()\index And *this\index[#__s_1] > *this\row\_s()\index)      ; вниз
          
          *this\row\_s()\text\edit[1]\len = 0 
          *this\row\_s()\text\edit[2]\len = *this\row\_s()\text\len
          
        ElseIf *this\index[#__s_1] = *this\row\_s()\index 
          If *this\index[#__s_1] > *this\index[#__s_2] 
            *this\row\_s()\text\edit[1]\len = 0 
            *this\row\_s()\text\edit[2]\len = *this\text\caret\pos[1]
          Else
            *this\row\_s()\text\edit[1]\len = *this\text\caret\pos[1] 
            *this\row\_s()\text\edit[2]\len = *this\row\_s()\text\len - *this\row\_s()\text\edit[1]\len
          EndIf
          
        ElseIf *this\index[#__s_2] = *this\row\_s()\index
          If *this\index[#__s_2] > *this\index[#__s_1] 
            *this\row\_s()\text\edit[1]\len = 0 
            *this\row\_s()\text\edit[2]\len = *this\text\caret\pos[2]
          Else
            *this\row\_s()\text\edit[1]\len = *this\text\caret\pos[2] 
            *this\row\_s()\text\edit[2]\len = *this\row\_s()\text\len - *this\row\_s()\text\edit[1]\len
          EndIf
          
        EndIf
        
        *this\row\_s()\text\edit[1]\pos = 0 
        *this\row\_s()\text\edit[2]\pos = *this\row\_s()\text\edit[1]\len
        
        *this\row\_s()\text\edit[3]\pos = *this\row\_s()\text\edit[2]\pos + *this\row\_s()\text\edit[2]\len 
        *this\row\_s()\text\edit[3]\len = *this\row\_s()\text\len - *this\row\_s()\text\edit[3]\pos
        
        ; set string & size (left;selected;right)
        If *this\row\_s()\text\edit[1]\len > 0
          *this\row\_s()\text\edit[1]\string = Left(*this\row\_s()\text\string, *this\row\_s()\text\edit[1]\len)
          *this\row\_s()\text\edit[1]\width = TextWidth(*this\row\_s()\text\edit[1]\string) 
        Else
          *this\row\_s()\text\edit[1]\string = ""
          *this\row\_s()\text\edit[1]\width = 0
        EndIf
        If *this\row\_s()\text\edit[2]\len > 0
          If *this\row\_s()\text\edit[2]\len = *this\row\_s()\text\len
            *this\row\_s()\text\edit[2]\string = *this\row\_s()\text\string
            *this\row\_s()\text\edit[2]\width = *this\row\_s()\text\width + *this\mode\fullselection
          Else
            *this\row\_s()\text\edit[2]\string = Mid(*this\row\_s()\text\string, 1 + *this\row\_s()\text\edit[2]\pos, *this\row\_s()\text\edit[2]\len)
            *this\row\_s()\text\edit[2]\width = TextWidth(*this\row\_s()\text\edit[2]\string) + Bool((*this\index[#__s_1] <  *this\index[#__s_2] And *this\row\_s()\index = *this\index[#__s_1]) Or
                                                                                                     ; (*this\index[1] <> *this\row\_s()\index And *this\row\_s()\index <> *this\index[2]) Or
            (*this\index[#__s_1]  > *this\index[#__s_2] And *this\row\_s()\index = *this\index[#__s_2])) * *this\mode\fullselection
          EndIf
        Else
          *this\row\_s()\text\edit[2]\string = ""
          *this\row\_s()\text\edit[2]\width = 0
        EndIf
        If *this\row\_s()\text\edit[3]\len > 0
          *this\row\_s()\text\edit[3]\string = Right(*this\row\_s()\text\string, *this\row\_s()\text\edit[3]\len)
          *this\row\_s()\text\edit[3]\width = TextWidth(*this\row\_s()\text\edit[3]\string)  
        Else
          *this\row\_s()\text\edit[3]\string = ""
          *this\row\_s()\text\edit[3]\width = 0
        EndIf
        
        ; set position (left;selected;right)
        *this\row\_s()\text\edit[1]\x = *this\row\_s()\text\x 
        *this\row\_s()\text\edit[2]\x = (*this\row\_s()\text\edit[1]\x + *this\row\_s()\text\edit[1]\width) 
        *this\row\_s()\text\edit[3]\x = (*this\row\_s()\text\edit[2]\x + *this\row\_s()\text\edit[2]\width)
        
        ; set cursor pos
        If *this\index[#__s_1] = *this\row\_s()\index 
          *this\text\caret\y = *this\row\_s()\text\y
          *this\text\caret\height = *this\row\_s()\text\height
          
          If *this\index[#__s_1] > *this\index[#__s_2] Or
             (*this\index[#__s_1] = *this\index[#__s_2] And *this\text\caret\pos[1] > *this\text\caret\pos[2])
            *this\text\caret\x = *this\row\_s()\text\edit[3]\x
          Else
            *this\text\caret\x = *this\row\_s()\text\edit[2]\x
          EndIf
        EndIf
      EndIf
      
    EndProcedure
    
    Procedure.i _edit_sel_start_(*this._s_widget)
      Protected result.i, i.i, char.i
      
      Macro _edit_sel_end_(_char_)
        Bool((_char_ >= ' ' And _char_ <= '/') Or 
             (_char_ >= ':' And _char_ <= '@') Or 
             (_char_ >= '[' And _char_ <= 96) Or 
             (_char_ >= '{' And _char_ <= '~'))
      EndMacro
      
      With *this
        ; |<<<<<< left edge of the word 
        If \text\caret\pos[1] > 0 
          For i = \text\caret\pos[1] - 1 To 1 Step - 1
            char = Asc(Mid(\row\_s()\text\string.s, i, 1))
            If _edit_sel_end_(char)
              Break
            EndIf
          Next 
          
          result = i
        EndIf
      EndWith  
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i _edit_sel_stop_(*this._s_widget)
      Protected result.i, i.i, char.i
      
      With *this
        ; >>>>>>| right edge of the word
        For i = \text\caret\pos[1] + 2 To \row\_s()\text\len
          char = Asc(Mid(\row\_s()\text\string.s, i, 1))
          If _edit_sel_end_(char)
            Break
          EndIf
        Next 
        
        result = i - 1
      EndWith  
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.s _text_insert_make_(*this._s_widget, Text.s)
      Protected String.s, i.i, Len.i
      
      With *this
        If \text\numeric And Text.s <> #LF$
          Static Dot, Minus
          Protected Chr.s, Input.i, left.s, count.i
          
          Len = Len(Text.s) 
          For i = 1 To Len 
            Chr = Mid(Text.s, i, 1)
            Input = Asc(Chr)
            
            Select Input
              Case '0' To '9', '.',' - '
              Case 'Ю','ю','Б','б',44,47,60,62,63 : Input = '.' : Chr = Chr(Input)
              Default
                Input = 0
            EndSelect
            
            If Input
              If \type = #PB_GadgetType_IPAddress
                left.s = Left(\text\string, \text\caret\pos[1] )
                Select CountString(left.s, ".")
                  Case 0 : left.s = StringField(left.s, 1, ".")
                  Case 1 : left.s = StringField(left.s, 2, ".")
                  Case 2 : left.s = StringField(left.s, 3, ".")
                  Case 3 : left.s = StringField(left.s, 4, ".")
                EndSelect                                           
                count = Len(left.s + Trim(StringField(Mid(\text\string, \text\caret\pos[1]  + 1), 1, "."), #LF$))
                If count < 3 And (Val(left.s) > 25 Or Val(left.s + Chr.s) > 255)
                  Continue
                  ;               ElseIf Mid(\text\string, \text\caret\pos[1] + 1, 1) = "."
                  ;                 \text\caret\pos[1] + 1 : \text\caret\pos[2] = \text\caret\pos[1] 
                EndIf
              EndIf
              
              If Not Dot And Input = '.' And Mid(\text\string, \text\caret\pos[1] + 1, 1) <> "."
                Dot = 1
              ElseIf Input <> '.' And count < 3
                Dot = 0
              Else
                Continue
              EndIf
              
              If Not Minus And Input = ' - ' And Mid(\text\string, \text\caret\pos[1] + 1, 1) <> " - "
                Minus = 1
              ElseIf Input <> ' - '
                Minus = 0
              Else
                Continue
              EndIf
              
              String.s + Chr
            EndIf
          Next
          
        ElseIf \text\pass
          Len = Len(Text.s) 
          For i = 1 To Len : String.s + "●" : Next
          
        Else
          Select #True
            Case \text\lower : String.s = LCase(Text.s)
            Case \text\upper : String.s = UCase(Text.s)
            Default
              String.s = Text.s
          EndSelect
        EndIf
      EndWith
      
      ProcedureReturn String.s
    EndProcedure
    
    Procedure.b _text_paste_(*this._s_widget, Chr.s = "", Count.l = 0)
      Protected Repaint.b
      
      With *this
        If \index[#__s_1] <> \index[#__s_2] ; Это значить строки выделени
          If \index[#__s_2] > \index[#__s_1] : Swap \index[#__s_2], \index[#__s_1] : EndIf
          
          If \row\_s()\index <> \index[#__s_2]
            SelectElement(\row\_s(), \index[#__s_2])
          EndIf
          
          If Count
            \index[#__s_2] + Count
            \text\caret\pos[1] = Len(StringField(Chr.s, 1 + Count, #LF$))
          ElseIf Chr.s = #LF$ ; to return
            \index[#__s_2] + 1
            \text\caret\pos[1] = 0
          Else
            \text\caret\pos[1] = \row\_s()\text\edit[1]\len
            If Chr.s <> ""
              \text\caret\pos[1] + Len(Chr.s)
            EndIf
          EndIf
          
          ; reset items selection
          PushListPosition(*this\row\_s())
          ForEach *this\row\_s()
            If *this\row\_s()\text\edit[2]\width <> 0 
              _edit_sel_reset_(*this\row\_s())
            EndIf
          Next
          PopListPosition(*this\row\_s())
          
          \text\caret\pos[2] = \text\caret\pos[1] 
          \index[#__s_1] = \index[#__s_2]
          \text\change =- 1 
          Repaint = #True
        EndIf
        
        ;       \row\_s()\text\string.s = \row\_s()\text\edit[1]\string + Chr.s + \row\_s()\text\edit[3]\string
        ;       \row\_s()\text\len = Len(\row\_s()\text\string.s)
        
        \text\string.s = \text\edit[1]\string + Chr.s + \text\edit[3]\string
      EndWith
      
      ProcedureReturn Repaint
    EndProcedure
    
    Procedure.b _text_insert_(*this._s_widget, Chr.s)
      Static Dot, Minus, Color.i
      Protected result.b = -1, Input, Input_2, String.s, Count.i
      
      With *this
        Chr.s = _text_insert_make_(*this, Chr.s)
        
        If Chr.s
          Count = CountString(Chr.s, #LF$)
          
          If Not _text_paste_(*this, Chr.s, Count)
            If \row\_s()\text\edit[2]\len 
              If \text\caret\pos[1] > \text\caret\pos[2] : \text\caret\pos[1] = \text\caret\pos[2] : EndIf
              \row\_s()\text\edit[2]\len = 0 : \row\_s()\text\edit[2]\string.s = "" : \row\_s()\text\edit[2]\change = 1
            EndIf
            
            \row\_s()\text\edit[1]\change = 1
            \row\_s()\text\edit[1]\string.s + Chr.s
            \row\_s()\text\edit[1]\len = Len(\row\_s()\text\edit[1]\string.s)
            
            \row\_s()\text\string.s = \row\_s()\text\edit[1]\string.s + \row\_s()\text\edit[3]\string.s
            \row\_s()\text\len = \row\_s()\text\edit[1]\len + \row\_s()\text\edit[3]\len : \row\_s()\text\change = 1
            
            If Count
              \index[#__s_2] + Count
              \index[#__s_1] = \index[#__s_2] 
              \text\caret\pos[1] = Len(StringField(Chr.s, 1 + Count, #LF$))
            Else
              \text\caret\pos[1] + Len(Chr.s) 
            EndIf
            
            \text\string.s = \text\edit[1]\string + Chr.s + \text\edit[3]\string
            \text\caret\pos[2] = \text\caret\pos[1] 
            ;; \count\items = CountString(\text\string.s, #LF$)
            \text\change =- 1 ; - 1 post event change widget
          EndIf
          
          SelectElement(\row\_s(), \index[#__s_2]) 
          result = 1 
        EndIf
      EndWith
      
      If result =- 1
        *this\notify = 1
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.s text_wrap_(text$, Width.i, Mode = -1, DelimList$ = " " + Chr(9), nl$ = #LF$)
      ; <http://www.purebasic.fr/english/viewtopic.php?f = 12&t = 53800>
      Protected line$, ret$ = "", LineRet$ = ""
      Protected.i CountString, i, start, found, length
      
      ;     text$ = ReplaceString(text$, #LFCR$, #LF$)
      ;     text$ = ReplaceString(text$, #CRLF$, #LF$)
      ;     text$ = ReplaceString(text$, #CR$, #LF$)
      ;     text$ + #LF$
      ;     
      ;CountString = CountString(text$, #LF$) 
      Protected *str.Character = @text$
      Protected *end.Character = @text$
      
      While *end\c 
        If *end\c = #LF
          start = (*end - *str) >> #PB_Compiler_Unicode
          line$ = PeekS (*str, start)
          ; Debug "" + start  + " " +  Str((*end - *str))  + " " +  Str((*end - *str) / #__sOC)  + " " +  #PB_compiler_Unicode  + " " +  #__sOC
          
          ;           For i = 1 To CountString
          ;       line$ = StringField(text$, i, #LF$)
          ;       start = Len(line$)
          length = start
          
          ; Get text len
          While length > 1
            If width > TextWidth(RTrim(Left(line$, length)))
              Break
            Else
              length - 1 
            EndIf
          Wend
          
          While start > length 
            For found = length To 1 Step - 1
              If FindString(" ", Mid(line$, found,1))
                start = found
                Break
              EndIf
            Next
            
            If found = 0 
              start = length
            EndIf
            
            ; LineRet$ + Left(line$, start) + nl$
            ret$ + Left(line$, start) + nl$
            line$ = LTrim(Mid(line$, start + 1))
            start = Len(line$)
            
            If length <> start
              length = start
              
              ; Get text len
              While length > 1
                If width > TextWidth(RTrim(Left(line$, length)))
                  Break
                Else
                  length - 1 
                EndIf
              Wend
            EndIf
          Wend
          
          ret$ + line$ + nl$
          ;         ret$ +  LineRet$ + line$ + nl$
          ;         LineRet$ = ""
          *str = *end + #__sOC 
        EndIf 
        
        *end + #__sOC 
        
        ;     Next
      Wend
      
      ProcedureReturn ret$ ; ReplaceString(ret$, " ", "*")
    EndProcedure
    
    ;-
    Procedure   Editor_Update(*this._s_widget, List row._s_rows())
      With *this
        
        If \text\string.s And *this\change > 0
          Debug "*this\change > 0 - " + #PB_Compiler_Procedure
          
          Protected *str.Character
          Protected *end.Character
          Protected TxtHeight = \text\height
          Protected String.s, String1.s, CountString
          Protected IT, len.l, Position.l, width
          Protected ColorFont = \color\Front[Bool(*this\_state & #__s_front) * \color\state]
          
          ; \max 
          If *this\vertical
            If *this\height[#__c_required] > *this\height[#__c_inner]
              *this\text\change = #__text_update
            EndIf
            Width = *this\height[#__c_inner] - *this\text\padding\X*2
            
          Else
            If *this\width[#__c_required] > *this\width[#__c_inner]
              *this\text\change = #__text_update
            EndIf
            
            width = *this\width[#__c_inner] - *this\text\padding\x*2 
          EndIf
          
          If *this\text\multiLine
            ; make multiline text
            Protected text$ = *this\text\string.s + #LF$
            
            ;     text$ = ReplaceString(text$, #LFCR$, #LF$)
            ;     text$ = ReplaceString(text$, #CRLF$, #LF$)
            ;     text$ = ReplaceString(text$, #CR$, #LF$)
            ;     text$ + #LF$
            ;     
            
            If *this\text\multiLine > 0
              String = text$
            Else
              ; <http://www.purebasic.fr/english/viewtopic.php?f = 12&t = 53800>
              Protected.i i, start, found, length
              Protected$ line$, DelimList$ = " " + Chr(9), nl$ = #LF$
              
              *str.Character = @text$
              *end.Character = @text$
              
              ; make word wrap
              While *end\c 
                If *end\c = #LF
                  start = (*end - *str) >> #PB_Compiler_Unicode
                  line$ = PeekS (*str, start)
                  length = start
                  
                  ; Get text len
                  While length > 1
                    If width > TextWidth(RTrim(Left(line$, length)))
                      Break
                    Else
                      length - 1 
                    EndIf
                  Wend
                  
                  While start > length 
                    For found = length To 1 Step - 1
                      If FindString(" ", Mid(line$, found,1))
                        start = found
                        Break
                      EndIf
                    Next
                    
                    If Not found
                      start = length
                    EndIf
                    
                    String + Left(line$, start) + nl$
                    line$ = LTrim(Mid(line$, start + 1))
                    start = Len(line$)
                    
                    ;If length <> start
                    length = start
                    
                    ; Get text len
                    While length > 1
                      If width > TextWidth(RTrim(Left(line$, length)))
                        Break
                      Else
                        length - 1 
                      EndIf
                    Wend
                    ;EndIf
                  Wend
                  
                  String + line$ + nl$
                  *str = *end + #__sOC 
                EndIf 
                
                *end + #__sOC 
              Wend
            EndIf
            
            CountString = CountString(String, #LF$)
          Else
            String.s = RemoveString(*this\text\string, #LF$) + #LF$
            CountString = 1
          EndIf
          
          If *this\count\items <> CountString
            If *this\count\items > CountString
              *this\text\change = 1
            Else
              *this\text\change = #__text_update
            EndIf
            
            *this\count\items = CountString
          EndIf
          
          If *this\change > 0
            *this\text\change = 1
          EndIf
          
          If *this\text\change
            *str.Character = @String
            *end.Character = @String
            
            *this\text\pos  = 0
            *this\text\len = Len(*this\text\string)
            
            ;             ;; editor
            ;If *this\text\change =- 10 
            ;             If *this\row\count <> *this\count\items 
            ; *this\row\count = *this\count\items
            Debug  " - - - - ClearList - - - - " + *this\text\change
            Protected padding_x2 = *this\text\padding\x*2 ;+ *this\image\width
            
            ClearList(row())
            *this\width[#__c_required] = padding_x2
            *this\height[#__c_required] = *this\text\padding\y*2 
            
            ;
            While *end\c 
              If *end\c = #LF 
                AddElement(row())
                ; drawing item font
                _drawing_font_item_(*this, row(), row()\text\change)
                
                row()\text\len = (*end - *str)>>#PB_Compiler_Unicode
                row()\text\string = PeekS (*str, row()\text\len)
                row()\text\width = TextWidth(row()\text\string)
                
                ;; editor
                row()\index = ListIndex(row())
                row()\height = row()\text\height
                
                ;If *this\type = #PB_GadgetType_Editor
                ;EndIf
                
                row()\color\back[1] = _get_colors_()\back[1]
                row()\color\back[2] = _get_colors_()\back[2] : row()\color\front[2] = _get_colors_()\front[2]
                row()\color\back[3] = _get_colors_()\back[3]
                
                If \index[#__s_1] = row()\index Or
                   \index[#__s_2] = row()\index 
                  row()\text\change = 1
                EndIf
                
                ; make line position
                If \vertical
                  If *this\height[#__c_required] < row()\text\width + *this\text\padding\y * 2
                    *this\height[#__c_required] = row()\text\width + *this\text\padding\y * 2
                  EndIf
                  
                  If \text\rotate = 270
                    row()\x = *this\width[#__c_inner] - *this\width[#__c_required] + *this\text\padding\x                      ; + Bool(#PB_Compiler_OS = #PB_OS_MacOS)
                  ElseIf \text\rotate = 90
                    row()\x = *this\width[#__c_required]                           - *this\text\padding\x                      ; - 1 
                  EndIf
                  
                  *this\width[#__c_required] + TxtHeight + Bool(row()\index <> *this\count\items - 1) * *this\mode\gridlines
                Else
                  If *this\width[#__c_required] < row()\text\width + padding_x2
                    *this\width[#__c_required] = row()\text\width + padding_x2
                  EndIf
                  
                  If \text\rotate = 0
                    row()\y = *this\height[#__c_required]                            - *this\text\padding\y                     ; - 1 
                  ElseIf \text\rotate = 180
                    row()\y = *this\height[#__c_inner] - *this\height[#__c_required] + *this\text\padding\y - row()\text\height ; + Bool(#PB_Compiler_OS = #PB_OS_MacOS)
                  EndIf
                  
                  *this\height[#__c_required] + TxtHeight + Bool(row()\index <> *this\count\items - 1) * *this\mode\gridlines
                EndIf
                
                *str = *end + #__sOC 
              EndIf 
              
              *end + #__sOC 
            Wend
            
            ;             Else
            ;               While *end\c 
            ;                 If *end\c = #LF 
            ;                   If SelectElement(row(), IT)
            ;                     row()\text\len = (*end - *str)>>#PB_Compiler_Unicode
            ;                     line$ = PeekS (*str, row()\text\len)
            ;                     
            ;                     If row()\text\string.s <> line$
            ;                       row()\text\string.s = line$
            ;                       row()\text\change = 1
            ;                     EndIf
            ;                     
            ;                     If row()\text\change <> 0
            ;                       row()\text\width = TextWidth(row()\text\string)
            ;                       ;Debug *this\count\items
            ;                       If *this\width[#__c_required] < row()\text\width + *this\text\padding\x * 2
            ;                         *this\width[#__c_required] = row()\text\width + *this\text\padding\x * 2
            ;                       EndIf
            ;                     EndIf
            ;                   EndIf
            ;                   
            ;                   IT + 1
            ;                   *str = *end + #__sOC 
            ;                 EndIf 
            ;                 
            ;                 *end + #__sOC 
            ;               Wend
            ;             EndIf 
            
            
            ;
            ForEach row()
              row()\text\pos = *this\text\pos 
              *this\text\pos + row()\text\len + 1 ; Len(#LF$)
              
              If *this\vertical
                If *this\text\rotate = 270
                  row()\x - (*this\width[#__c_inner] - *this\width[#__c_required])
                EndIf
                
                ; changed
                If \text\rotate = 270
                  row()\text\x = row()\x + Bool(#PB_Compiler_OS = #PB_OS_MacOS) + 1
                ElseIf \text\rotate = 90
                  row()\text\x = row()\x - Bool(#PB_Compiler_OS = #PB_OS_MacOS) - 1 
                Else
                  row()\text\x = row()\x
                EndIf
                
                _set_align_y_(*this\text, row()\text, *this\height[#__c_required], *this\text\rotate)
              Else
                If *this\text\rotate = 180
                  row()\y - (*this\height[#__c_inner] - *this\height[#__c_required])
                EndIf
                
                ; changed
                If \text\rotate = 0
                  row()\text\y = row()\y - Bool(#PB_Compiler_OS = #PB_OS_MacOS) - 1 
                ElseIf \text\rotate = 180
                  row()\text\y = row()\y + Bool(#PB_Compiler_OS = #PB_OS_MacOS) * 2 + Bool(#PB_Compiler_OS = #PB_OS_Linux) + row()\text\height
                Else
                  row()\text\y = row()\y
                EndIf
                
                _set_align_x_(*this\text, row()\text, *this\width[#__c_required], *this\text\rotate)
              EndIf
              
              ;               
              ;                         \row\_s()\draw = Bool(Not \row\_s()\hide And 
              ;                                     _row_y_(*this) > *this\y[#__c_inner] - \row\_s()\height And 
              ;                                     _row_y_(*this) < *this\y[#__c_inner] + *this\height[#__c_inner])
              ; ;               If  _row_y_(*this) > *this\y[#__c_inner] - \row\_s()\height And _row_y_(*this) < *this\y[#__c_inner] + \row\_s()\height
              ;                         If \row\_s()\draw
              ;                           Debug \row\_s()\index;_row_y_(*this)
              ;                EndIf
              
              If row()\text\change <> 0
                _edit_sel_update_(*this)
                
                row()\text\change = 0
              EndIf
            Next 
            
            
          EndIf
        EndIf
        
        If *this\text\change
          Protected update_scroll_area
          
          If *this\scroll\v And
             *this\scroll\v\bar\max <> *this\height[#__c_required] And
             Bar_SetAttribute(*this\scroll\v, #__bar_maximum, *this\height[#__c_required])
            update_scroll_area = 1
          EndIf
          
          If *this\scroll\h And 
             *this\scroll\h\bar\max <> *this\width[#__c_required] And  
             Bar_SetAttribute(*this\scroll\h, #__bar_maximum, *this\width[#__c_required])
            update_scroll_area = 1
          EndIf
          
          If update_scroll_area ; _bar_scrollarea_update_(*this)
            Bar_Resizes(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            \height[#__c_inner] = \scroll\v\bar\page\len
            \width[#__c_inner] = \scroll\h\bar\page\len 
          EndIf
          
          ; Debug ""+*this\scroll\h\bar\page\pos +" "+ *this\scroll\h\bar\page\end
          ; *this\scroll\h\bar\page\end) *this\scroll\h\bar\page\pos - *this\scroll\h\bar\min
          ; make horizontal scroll x
          make_scrollarea_x(*this, *this\text)
          
          ; make vertical scroll y
          make_scrollarea_y(*this, *this\text)
          
          
          If *this\text\change = #__text_update 
            
            ; vertical bar one before displaying
            If *this\scroll\v 
              If *this\text\align\bottom
                If Bar_Change(*this\scroll\v, *this\scroll\v\bar\page\end) 
                  Bar_Update(*this\scroll\v)
                EndIf
                
              ElseIf Not *this\text\align\top
                If Bar_Change(*this\scroll\v, *this\scroll\v\bar\page\end / 2) 
                  Bar_Update(*this\scroll\v)
                EndIf
              EndIf
            EndIf
            
            ; horizontal bar one before displaying
            If *this\scroll\h  
              If *this\text\align\right
                If Bar_Change(*this\scroll\h, *this\scroll\h\bar\page\end) 
                  Bar_Update(*this\scroll\h)
                EndIf
                
              ElseIf Not *this\text\align\left
                If Bar_Change(*this\scroll\h, *this\scroll\h\bar\page\end / 2) 
                  Bar_Update(*this\scroll\h)
                EndIf
              EndIf
            EndIf
          Else
            
            ; This is for the caret and scroll 
            ; when entering the key - (enter & backspace) 
            If *this\scroll\v
              _text_scroll_y_(*this)
            EndIf
            
            If *this\scroll\h
              _text_scroll_x_(*this)
            EndIf
            
          EndIf
        EndIf
        ;           ; text frame 
        ;           *this\text\x = *this\x[#__c_required] + *this\text\padding\x
        ;           *this\text\y = *this\y[#__c_required] + *this\text\padding\y
        ;           *this\text\width = *this\width[#__c_required] - *this\text\padding\x*2
        ;           *this\text\height = *this\height[#__c_required] + *this\text\padding\y*2
        
        
      EndWith
    EndProcedure
    
    Procedure   _Editor_Update(*this._s_widget, List row._s_rows())
      With *this
        
        If \text\string.s
          Protected *str.Character
          Protected *end.Character
          Protected TxtHeight = \text\height
          Protected String.s, String1.s, CountString
          Protected IT, len.l, Position.l, Width,Height
          Protected ColorFont = \color\Front[Bool(*this\_state & #__s_front) * \color\state]
          
          If \vertical
            Width = \height[#__c_inner] - \text\X*2
            Height = \width[#__c_inner] - \text\y*2
          Else
            Width = \width[#__c_inner] - \text\X*2 
            Height = \height[#__c_inner] - \text\y*2
          EndIf
          
          ; make multiline text
          If \text\multiLine
            Protected text$ = *this\text\string.s + #LF$
            
            ;     text$ = ReplaceString(text$, #LFCR$, #LF$)
            ;     text$ = ReplaceString(text$, #CRLF$, #LF$)
            ;     text$ = ReplaceString(text$, #CR$, #LF$)
            ;     text$ + #LF$
            ;     
            
            If \text\multiLine < 0
              String = text$
            Else
              ; <http://www.purebasic.fr/english/viewtopic.php?f = 12&t = 53800>
              Protected.i i, start, found, length
              Protected$ line$, DelimList$ = " " + Chr(9), nl$ = #LF$
              
              *str.Character = @text$
              *end.Character = @text$
              
              ; make word wrap
              While *end\c 
                If *end\c = #LF
                  start = (*end - *str) >> #PB_Compiler_Unicode
                  line$ = PeekS (*str, start)
                  length = start
                  
                  ; Get text len
                  While length > 1
                    If width > TextWidth(RTrim(Left(line$, length)))
                      Break
                    Else
                      length - 1 
                    EndIf
                  Wend
                  
                  While start > length 
                    For found = length To 1 Step - 1
                      If FindString(" ", Mid(line$, found,1))
                        start = found
                        Break
                      EndIf
                    Next
                    
                    If Not found
                      start = length
                    EndIf
                    
                    String + Left(line$, start) + nl$
                    line$ = LTrim(Mid(line$, start + 1))
                    start = Len(line$)
                    
                    ;If length <> start
                    length = start
                    
                    ; Get text len
                    While length > 1
                      If width > TextWidth(RTrim(Left(line$, length)))
                        Break
                      Else
                        length - 1 
                      EndIf
                    Wend
                    ;EndIf
                  Wend
                  
                  String + line$ + nl$
                  *str = *end + #__sOC 
                EndIf 
                
                *end + #__sOC 
              Wend
            EndIf
            
            CountString = CountString(String, #LF$)
          Else
            String.s = RemoveString(*this\text\string, #LF$) + #LF$
            CountString = 1
          EndIf
          
          ; \max 
          If \vertical
            If *this\height[#__c_required] > *this\height[#__c_inner]
              *this\text\change = #True
            EndIf
          Else
            If *this\width[#__c_required] > *this\width[#__c_inner]
              *this\text\change = #True
            EndIf
          EndIf
          
          ; 
          If *this\count\items <> CountString
            *this\count\items = CountString
            *this\text\change = #True
          EndIf
          
          If *this\text\change
            Debug "*this\text\change - " + #PB_Compiler_Procedure
            
            *str.Character = @String
            *end.Character = @String
            
            *this\text\pos  = 0
            *this\text\len = Len(*this\text\string)
            
            ;             ;; editor
            ;             If *this\row\count <> *this\count\items 
            *this\row\count = *this\count\items
            Debug  " - - - - ClearList - - - - "
            
            ClearList(row())
            *this\width[#__c_required] = *this\text\padding\x*2 
            *this\height[#__c_required] = *this\text\padding\y*2 
            
            ;
            While *end\c 
              If *end\c = #LF 
                AddElement(row())
                ; drawing item font
                _drawing_font_item_(*this, row(), row()\text\change)
                
                row()\text\len = (*end - *str)>>#PB_Compiler_Unicode
                row()\text\string = PeekS (*str, row()\text\len)
                row()\text\width = TextWidth(row()\text\string)
                
                ;; editor
                row()\index = ListIndex(row())
                row()\height = row()\text\height
                row()\color\back[1] = _get_colors_()\back[1]
                row()\color\back[2] = _get_colors_()\back[2]
                row()\color\back[3] = _get_colors_()\back[3]
                row()\color\front[2] = _get_colors_()\front[2]
                
                If \index[#__s_1] = row()\index Or
                   \index[#__s_2] = row()\index 
                  row()\text\change = 1
                EndIf
                
                ; make line position
                If \vertical
                  If *this\height[#__c_required] < row()\text\width + *this\text\padding\y * 2
                    *this\height[#__c_required] = row()\text\width + *this\text\padding\y * 2
                  EndIf
                  
                  If \text\rotate = 270
                    row()\x = *this\width[#__c_inner] - *this\width[#__c_required] + *this\text\padding\x + Bool(#PB_Compiler_OS = #PB_OS_MacOS)
                  ElseIf \text\rotate = 90
                    row()\x = *this\width[#__c_required]                           - *this\text\padding\x - 1 
                  EndIf
                  
                  *this\width[#__c_required] + TxtHeight
                Else
                  If *this\width[#__c_required] < row()\text\width + *this\text\padding\x * 2
                    *this\width[#__c_required] = row()\text\width + *this\text\padding\x * 2
                  EndIf
                  
                  If \text\rotate = 0
                    row()\y = *this\height[#__c_required]                            - *this\text\padding\y - 1 
                  ElseIf \text\rotate = 180
                    row()\y = *this\height[#__c_inner] - *this\height[#__c_required] + *this\text\padding\y + Bool(#PB_Compiler_OS = #PB_OS_MacOS)
                  EndIf
                  
                  *this\height[#__c_required] + TxtHeight
                EndIf
                
                *str = *end + #__sOC 
              EndIf 
              
              *end + #__sOC 
            Wend
            
            ;             Else
            ;               While *end\c 
            ;                 If *end\c = #LF 
            ;                   If SelectElement(row(), IT)
            ;                     row()\text\len = (*end - *str)>>#PB_Compiler_Unicode
            ;                     line$ = PeekS (*str, row()\text\len)
            ;                     
            ;                     If row()\text\string.s <> line$
            ;                       row()\text\string.s = line$
            ;                       row()\text\change = 1
            ;                     EndIf
            ;                     
            ;                     If row()\text\change <> 0
            ;                       row()\text\width = TextWidth(row()\text\string)
            ;                       ;Debug *this\count\items
            ;                       If *this\width[#__c_required] < row()\text\width + *this\text\padding\x * 2
            ;                         *this\width[#__c_required] = row()\text\width + *this\text\padding\x * 2
            ;                       EndIf
            ;                     EndIf
            ;                   EndIf
            ;                   
            ;                   IT + 1
            ;                   *str = *end + #__sOC 
            ;                 EndIf 
            ;                 
            ;                 *end + #__sOC 
            ;               Wend
            ;             EndIf 
            
            ;
            ForEach row()
              row()\text\pos = *this\text\pos 
              *this\text\pos + row()\text\len + 1 ; Len(#LF$)
              
              If *this\vertical
                If *this\text\rotate = 270
                  row()\x - (*this\width[#__c_inner] - *this\width[#__c_required])
                EndIf
                
                ; changed
                If \text\rotate = 270
                  row()\text\x = row()\x + Bool(#PB_Compiler_OS = #PB_OS_MacOS) + 1
                ElseIf \text\rotate = 90
                  row()\text\x = row()\x - Bool(#PB_Compiler_OS = #PB_OS_MacOS) - 1 
                Else
                  row()\text\x = row()\x
                EndIf
                
                _set_align_y_(*this\text, row()\text, *this\height[#__c_required], *this\text\rotate)
              Else
                If *this\text\rotate = 180
                  row()\y - (*this\height[#__c_inner] - *this\height[#__c_required])
                EndIf
                
                ; changed
                If \text\rotate = 0
                  row()\text\y = row()\y - Bool(#PB_Compiler_OS = #PB_OS_MacOS) - 1 
                ElseIf \text\rotate = 180
                  row()\text\y = row()\y + Bool(#PB_Compiler_OS = #PB_OS_MacOS) * 2 + Bool(#PB_Compiler_OS = #PB_OS_Linux) + row()\text\height
                Else
                  row()\text\y = row()\y
                EndIf
                
                _set_align_x_(*this\text, row()\text, *this\width[#__c_required], *this\text\rotate)
              EndIf
              
              ;               
              ;                         \row\_s()\draw = Bool(Not \row\_s()\hide And 
              ;                                     _row_y_(*this) > *this\y[#__c_inner] - \row\_s()\height And 
              ;                                     _row_y_(*this) < *this\y[#__c_inner] + *this\height[#__c_inner])
              ; ;               If  _row_y_(*this) > *this\y[#__c_inner] - \row\_s()\height And _row_y_(*this) < *this\y[#__c_inner] + \row\_s()\height
              ;                         If \row\_s()\draw
              ;                           Debug \row\_s()\index;_row_y_(*this)
              ;                EndIf
              
              If row()\text\change <> 0
                _edit_sel_update_(*this)
                
                row()\text\change = 0
              EndIf
            Next 
          EndIf
          
          
        EndIf
          
          Protected update_scroll_area
          
          If *this\scroll\v And
             *this\scroll\v\bar\max <> *this\height[#__c_required] And
             Bar_SetAttribute(*this\scroll\v, #__bar_maximum, *this\height[#__c_required])
            update_scroll_area = 1
          EndIf
          
          If *this\scroll\h And 
             *this\scroll\h\bar\max <> *this\width[#__c_required] And  
             Bar_SetAttribute(*this\scroll\h, #__bar_maximum, *this\width[#__c_required])
            update_scroll_area = 1
          EndIf
          
          If update_scroll_area ; _bar_scrollarea_update_(*this)
            Bar_Resizes(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            \height[#__c_inner] = \scroll\v\bar\page\len
            \width[#__c_inner] = \scroll\h\bar\page\len 
          EndIf
          
            ; make vertical scroll y
            make_scrollarea_y(*this, *this\text)
            
            ; make horizontal scroll x
            make_scrollarea_x(*this, *this\text)
            
            
            
          If *this\scroll\v
              ; This is for the caret and scroll when entering the key - (enter & backspace) 
            _text_scroll_y_(*this)
            
            ; fist show 
            If Not *this\scroll\v\bar\page\change
              If *this\text\align\bottom
                If Bar_Change(*this\scroll\v, *this\scroll\v\bar\page\end) 
                  Bar_Update(*this\scroll\v)
                EndIf
                
              ElseIf Not *this\text\align\top
                If Bar_Change(*this\scroll\v, *this\scroll\v\bar\page\end / 2) 
                  Bar_Update(*this\scroll\v)
                EndIf
              EndIf
            EndIf
          EndIf
          
          
          If *this\scroll\h
            ; This is for the caret and scroll when entering the key - (enter & backspace) 
            _text_scroll_x_(*this)
            
            ; first show
            If Not *this\scroll\h\bar\page\change
              If *this\text\align\right
                If Bar_Change(*this\scroll\h, *this\scroll\h\bar\page\end) 
                  Bar_Update(*this\scroll\h)
                EndIf
                
              ElseIf Not *this\text\align\left
                If Bar_Change(*this\scroll\h, *this\scroll\h\bar\page\end / 2) 
                  Bar_Update(*this\scroll\h)
                EndIf
              EndIf
            EndIf
          EndIf
          
;           ; text frame 
;           *this\text\x = *this\x[#__c_required] + *this\text\padding\x
;           *this\text\y = *this\y[#__c_required] + *this\text\padding\y
;           *this\text\width = *this\width[#__c_required] - *this\text\padding\x*2
;           *this\text\height = *this\height[#__c_required] + *this\text\padding\y*2
        
        
      EndWith
    EndProcedure
    
    Procedure   Editor_Draw(*this._s_widget)
      Protected String.s, StringWidth, ix, iy, iwidth, iheight
      Protected IT,Text_Y,Text_X, X,Y, Width, Drawing
      
      If Not *this\hide
        
        With *this
          ; Make output multi line text
          If *this\change > 0 ;<> 0
            Editor_Update(*this, *this\row\_s())
          EndIf
          
          ; Draw back color
          ;         If \color\fore[\color\state]
          ;           DrawingMode(#PB_2DDrawing_Gradient)
          ;           _box_gradient_(\vertical,\x[1],\y[1],\width[1],\height[1],\color\fore[\color\state],\color\back[\color\state],\round)
          ;         Else
          DrawingMode(#PB_2DDrawing_Default)
          RoundBox(\x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\round,\round,\color\back[\color\state])
          ;         EndIf
          
          ; Draw margin back color
          If \row\margin\width > 0
            If (\text\change Or \resize)
              \row\margin\x = \x[#__c_inner]
              \row\margin\y = \y[#__c_inner]
              \row\margin\height = \height[#__c_inner]
            EndIf
            
            ; Draw margin
            DrawingMode(#PB_2DDrawing_Default);|#PB_2DDrawing_AlphaBlend)
            Box(\row\margin\x, \row\margin\y, \row\margin\width, \row\margin\height, \row\margin\color\back)
          EndIf
          
          ; widget inner coordinate
          iX = \x[#__c_inner] + \row\margin\width 
          iY = \y[#__c_inner]
          iwidth = \width[#__c_inner]
          iheight = \height[#__c_inner]
          
          ; Draw Lines text
          If \count\items
            PushListPosition(\row\_s())
            ForEach \row\_s()
              ;               ; Is visible lines - -  - 
              ;               \row\_s()\draw = Bool(Not \row\_s()\hide And 
              ;                                     \row\_s()\y + \row\_s()\height + *this\y[#__c_required] > *this\y[#__c_inner] And 
              ;                                     (\row\_s()\y - *this\y[#__c_inner]) + *this\y[#__c_required]<*this\height[#__c_inner])
              
              \row\_s()\draw = Bool(Not \row\_s()\hide And 
                                    _row_y_(*this) > *this\y[#__c_inner] - \row\_s()\height And 
                                    _row_y_(*this) < *this\y[#__c_inner] + *this\height[#__c_inner])
              
              ; Draw selections
              If *this\row\_s()\draw 
                Y = _row_y_(*this)
                Text_X = _row_text_x_(*this)
                Text_Y = _row_text_y_(*this)
                
                Protected sel_text_x1 = _row_text_edit_x_(*this, [1])
                Protected sel_text_x2 = _row_text_edit_x_(*this, [2])
                Protected sel_text_x3 = _row_text_edit_x_(*this, [3])
                
                Protected sel_x = \x[#__c_inner] + *this\text\y
                Protected sel_width = \width[#__c_inner] - *this\text\y*2
                
                Protected text_sel_state = 2 + Bool(Focused() <> *this)
                Protected text_sel_width = \row\_s()\text\edit[2]\width + Bool(Focused() <> *this) * *this\text\caret\width
                Protected text_state = *this\row\_s()\color\state
                
                text_state = Bool(*this\row\_s()\index = *this\index[#__s_1]) + Bool(*this\row\_s()\index = *this\index[#__s_1] And Focused() <> *this)*2
                
                If *this\text\editable
                  ; Draw lines
                  ; Если для итема установили задный 
                  ; фон отличный от заднего фона едитора
                  If *this\row\_s()\color\Back  
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    RoundBox(sel_x,Y,sel_width ,*this\row\_s()\height, *this\row\_s()\round,*this\row\_s()\round, *this\row\_s()\color\back[0] )
                    
                    If *this\color\Back And 
                       *this\color\Back <> *this\row\_s()\color\Back
                      ; Draw margin back color
                      If *this\row\margin\width > 0
                        ; то рисуем вертикальную линию на границе поля нумерации и начало итема
                        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                        Box(*this\row\margin\x, *this\row\_s()\y, *this\row\margin\width, *this\row\_s()\height, *this\row\margin\color\back)
                        Line(*this\x[#__c_inner] + *this\row\margin\width, *this\row\_s()\y, 1, *this\row\_s()\height, *this\color\Back) ; $FF000000);
                      EndIf
                    EndIf
                  EndIf
                  
                  ; Draw entered selection
                  ; GetActive()\gadget = *this
                  If text_state ; *this\row\_s()\index = *this\index[1] ; \color\state;
                    If *this\row\_s()\color\back[text_state] <>- 1              ; no draw transparent
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      RoundBox(sel_x,Y,sel_width ,*this\row\_s()\height, *this\row\_s()\round,*this\row\_s()\round, *this\row\_s()\color\back[text_state] )
                    EndIf
                    
                    If *this\row\_s()\color\frame[text_state] <>- 1 ; no draw transparent
                      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                      RoundBox(sel_x,Y,sel_width ,*this\row\_s()\height, *this\row\_s()\round,*this\row\_s()\round, *this\row\_s()\color\frame[text_state] )
                    EndIf
                  EndIf
                EndIf
                
                ; Draw text
                ; Draw string
                If *this\text\editable And 
                   *this\row\_s()\text\edit[2]\width And 
                   *this\row\_s()\color\front[2] <> *this\color\front
                  
                  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
                    If \row\_s()\text\string.s
                      DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                      DrawRotatedText(Text_X, Text_Y, \row\_s()\text\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                    EndIf
                    
                    If \row\_s()\text\edit[2]\width
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(sel_text_x2, Y, text_sel_width, \row\_s()\height, *this\row\_s()\color\back[text_sel_state])
                    EndIf
                    
                    DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                    
                    ; to right select
                    If (*this\index[#__s_1] > *this\index[#__s_2] Or 
                        (*this\index[#__s_1] = *this\index[#__s_2] And *this\text\caret\pos[1] > *this\text\caret\pos[2]))
                      
                      If \row\_s()\text\edit[2]\string.s
                        DrawRotatedText(sel_text_x2, Text_Y, \row\_s()\text\edit[2]\string.s, *this\text\rotate, *this\row\_s()\color\front[text_sel_state])
                      EndIf
                      
                      ; to left select
                    Else
                      If \row\_s()\text\edit[2]\string.s
                        DrawRotatedText(Text_X, Text_Y, \row\_s()\text\edit[1]\string.s + \row\_s()\text\edit[2]\string.s, *this\text\rotate, *this\row\_s()\color\front[text_sel_state])
                      EndIf
                      
                      If \row\_s()\text\edit[1]\string.s
                        DrawRotatedText(Text_X, Text_Y, \row\_s()\text\edit[1]\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                      EndIf
                    EndIf
                    
                  CompilerElse
                    If \row\_s()\text\edit[2]\width
                      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                      Box(sel_text_x2, Y, text_sel_width, \row\_s()\height, *this\row\_s()\color\back[text_sel_state])
                    EndIf
                    
                    DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                    
                    If \row\_s()\text\edit[1]\string.s
                      DrawRotatedText(sel_text_x1, Text_Y, \row\_s()\text\edit[1]\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                    EndIf
                    If \row\_s()\text\edit[2]\string.s
                      DrawRotatedText(sel_text_x2, Text_Y, \row\_s()\text\edit[2]\string.s, *this\text\rotate, *this\row\_s()\color\front[text_sel_state])
                    EndIf
                    If \row\_s()\text\edit[3]\string.s
                      DrawRotatedText(sel_text_x3, Text_Y, \row\_s()\text\edit[3]\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                    EndIf
                  CompilerEndIf
                  
                Else
                  If *this\row\_s()\text\edit[2]\width
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(sel_text_x2, Y, text_sel_width, *this\row\_s()\height, $FFFBD9B7);*this\row\_s()\color\back[2])
                  EndIf
                  
                  If *this\color\state = 2
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(Text_X, Text_Y, *this\row\_s()\text\string.s, *this\text\rotate, *this\row\_s()\color\front[text_sel_state])
                  Else
                    DrawingMode(#PB_2DDrawing_Transparent)
                    DrawRotatedText(Text_X, Text_Y, *this\row\_s()\text\string.s, *this\text\rotate, *this\row\_s()\color\front[*this\row\_s()\color\state])
                  EndIf
                EndIf
                
                ; Draw margin text
                If *this\row\margin\width > 0
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawRotatedText(*this\row\_s()\margin\x + Bool(*this\vertical) * *this\x[#__c_required],
                                  *this\row\_s()\margin\y + Bool(Not *this\vertical) * *this\y[#__c_required], 
                                  *this\row\_s()\margin\string, *this\text\rotate, *this\row\margin\color\front)
                EndIf
                
                ; Horizontal line
                If *this\mode\GridLines And
                   *this\row\_s()\color\line And 
                   *this\row\_s()\color\line <> *this\row\_s()\color\back 
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(*this\row\_s()\x, (*this\row\_s()\y + *this\row\_s()\height + Bool(*this\mode\gridlines>1)) + *this\y[#__c_required], *this\row\_s()\width, 1, *this\color\line)
                EndIf
              EndIf
            Next
            PopListPosition(*this\row\_s()) ; 
          EndIf
          
          ; Draw caret
          If *this\text\editable And *this = Focused(); _is_selected_(*this)
            DrawingMode(#PB_2DDrawing_XOr)             
            Box(*this\x[#__c_inner] + *this\text\caret\x + *this\x[#__c_required], *this\y[#__c_inner] + *this\text\caret\y + *this\y[#__c_required], *this\text\caret\width, *this\text\caret\height, $FFFFFFFF)
          EndIf
          
          ; Draw frames
          If *this\notify
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\round,\round, $FF0000FF)
            If \round : RoundBox(\x[#__c_frame],\y[#__c_frame] - 1,\width[#__c_frame],\height[#__c_frame] + 2,\round,\round, $FF0000FF) : EndIf  ; Сглаживание краев )))
          ElseIf *this\bs
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(\x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\round,\round,\color\frame[\color\state])
            If \round : RoundBox(\x[#__c_frame],\y[#__c_frame] - 1,\width[#__c_frame],\height[#__c_frame] + 2,\round,\round,\color\front[\color\state]) : EndIf  ; Сглаживание краев )))
          EndIf
          
          ; Draw scroll bars
          Area_Draw(*this)
          
          If *this\text\change : *this\text\change = 0 : EndIf
          If *this\change : *this\change = 0 : EndIf
          If *this\resize : *this\resize = 0 : EndIf
        EndWith
      EndIf
      
    EndProcedure
    
    Procedure   Editor_SetItemState(*this._s_widget, Item.l, State.i)
      Protected result
      
      With *this
        If state < 0 Or 
           state > *this\text\len
          state = *this\text\len
        EndIf
        
        ;       If *this\text\caret\pos <> State
        ;         *this\text\caret\pos = State
        If *this\text\caret\pos <> State
          Protected i.l, len.l
          Protected *str.Character = @\text\string 
          Protected *end.Character = @\text\string 
          
          While *end\c 
            If *end\c = #LF 
              i + 1
              len + (*end - *str)/#__sOC
              ; Debug "" + Item + " " + Str(len + Item)  + " " +  state
              
              If i = Item 
                *this\index[#__s_1] = Item
                *this\index[#__s_2] = Item
                
                *this\text\caret\pos = state + len + Item
                *this\text\caret\pos[1] = state
                *this\text\caret\pos[2] = *this\text\caret\pos[1]
                
                Break
              EndIf
              
              *str = *end + #__sOC 
            EndIf 
            
            *end + #__sOC 
          Wend
          
          ; last line
          If *this\index[#__s_1] <> Item 
            *this\index[#__s_1] = Item
            *this\index[#__s_2] = Item
            
            *this\text\caret\pos = state + len + Item
            *this\text\caret\pos[1] = state
            *this\text\caret\pos[2] = *this\text\caret\pos[1]
          EndIf
          
          
        EndIf
        
        ; ;       PushListPosition(\row\_s())
        ; ;       result = SelectElement(\row\_s(), Item) 
        ; ;       
        ; ;       If result 
        ; ;         \index[1] = \row\_s()\index
        ; ;         \index[2] = \row\_s()\index
        ; ;         \row\index = \row\_s()\index
        ; ;        ; \text\caret\pos[1] = State
        ; ;        ; \text\caret\pos[2] = \text\caret\pos[1] 
        ; ;       EndIf
        ; ;       PopListPosition(\row\_s())
      EndWith
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   Editor_AddItem(*this._s_widget, Item.l,Text.s,Image.i = -1,Flag.i = 0)
      Static len.l
      Protected l.l, i.l
      
      If *this
        With *this  
          Protected string.s = \text\string + #LF$
          
          If Item > \count\items - 1
            Item = \count\items - 1
          EndIf
          
          If (Item > 0 And Item < \count\items - 1)
            Define *str.Character = @string 
            Define *end.Character = @string 
            len = 0
            
            While *end\c 
              If *end\c = #LF 
                
                If item = i 
                  len + Item
                  Break 
                Else
                  ;Debug "" +  PeekS (*str, (*end - *str)/#__sOC)  + " " +  Str((*end - *str)/#__sOC)
                  len + (*end - *str)/#__sOC
                EndIf
                
                i + 1
                *str = *end + #__sOC 
              EndIf 
              
              *end + #__sOC 
            Wend
          EndIf
          
          \text\string = Trim(InsertString(string, Text.s + #LF$, len + 1), #LF$)
          
          l = Len(Text.s) + 1
          \text\change = 1
          \text\len + l 
          Len + l
          
          ;_repaint_items_(*this)
          \count\items + 1
          
        EndWith
      EndIf
      
      ProcedureReturn *this\count\items
    EndProcedure
    
    Procedure   Editor_Events_Key(*this._s_widget, eventtype.l, mouse_x.l, mouse_y.l)
      Static _caret_last_pos_, DoubleClick.i
      Protected Repaint.i, _key_control_.i, _key_shift_.i, Caret.i, Item.i, String.s
      Protected _line_, _step_ = 1, _caret_min_ = 0, _caret_max_ = *this\row\_s()\text\len, _line_first_ = 0, _line_last_ = *this\count\items - 1
      
      With *this
        _key_shift_ = Bool(Keyboard()\key[1] & #PB_Canvas_Shift)
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
          _key_control_ = Bool((Keyboard()\key[1] & #PB_Canvas_Control) Or (Keyboard()\key[1] & #PB_Canvas_Command)) * #PB_Canvas_Control
        CompilerElse
          _key_control_ = Bool(Keyboard()\key[1] & #PB_Canvas_Control) * #PB_Canvas_Control
        CompilerEndIf
        
        Select EventType
          Case #__Event_Input ; - Input (key)
            If Not _key_control_   ; And Not _key_shift_
              If Not *this\notify And Keyboard()\input
                
                Repaint = _text_insert_(*this, Chr(Keyboard()\input))
                
              EndIf
            EndIf
            
          Case #__Event_KeyUp
            ; Чтобы перерисовать 
            ; рамку вокруг едитора 
            ; reset all errors
            If \notify 
              \notify = 0
              ProcedureReturn - 1
            EndIf
            
          Case #__Event_KeyDown
            Select Keyboard()\key
              Case #PB_Shortcut_Home : *this\text\caret\pos[2] = 0
                If _key_control_ : *this\index[#__s_2] = 0 : EndIf
                Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])
                
              Case #PB_Shortcut_End : *this\text\caret\pos[2] = *this\text\len
                If _key_control_ : *this\index[#__s_2] = *this\count\items - 1 : EndIf
                Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])
                
              Case #PB_Shortcut_PageUp   ;: Repaint = ToPos(*this, 1, 1)
                
              Case #PB_Shortcut_PageDown ;: Repaint = ToPos(*this, - 1, 1)
                
              Case #PB_Shortcut_A        ; Ok
                If _key_control_ And
                   \text\edit[2]\len <> \text\len
                  
                  ; set caret to begin
                  \text\caret\pos[2] = 0 
                  \text\caret\pos[1] = \text\len ; если поставить ноль то и прокручиваеть в конец строки
                  
                  ; select first item
                  \index[#__s_2] = 0 
                  \index[#__s_1] = \count\items - 1 ; если поставить ноль то и прокручиваеть в конец линии
                  
                  Repaint = _edit_sel_draw_(*this, \count\items - 1, \text\len)
                EndIf
                
              Case #PB_Shortcut_Up       ; Ok
                If *this\index[#__s_1] > _line_first_
                  If _caret_last_pos_
                    If Not Keyboard()\key[1] & #PB_Canvas_Alt 
                      *this\text\caret\pos[1] = _caret_last_pos_
                      *this\text\caret\pos[2] = _caret_last_pos_
                    EndIf
                    _caret_last_pos_ = 0
                  EndIf
                  
                  If _key_shift_
                    If _key_control_
                      Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])  
                      Repaint = _edit_sel_draw_(*this, 0, 0)  
                    Else
                      Repaint = _edit_sel_draw_(*this, *this\index[#__s_1] - _step_, *this\text\caret\pos[1])  
                    EndIf
                  ElseIf Keyboard()\key[1] & #PB_Canvas_Alt 
                    If *this\text\caret\pos[1] <> _caret_min_ 
                      *this\text\caret\pos[2] = _caret_min_
                    Else
                      *this\index[#__s_2] - _step_ 
                    EndIf
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])  
                    
                  Else
                    If _key_control_
                      *this\index[#__s_2] = 0
                      *this\text\caret\pos[2] = 0
                    Else
                      *this\index[#__s_2] - _step_
                    EndIf
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])
                  EndIf
                ElseIf *this\index[#__s_1] = _line_first_
                  
                  If *this\text\caret\pos[1] <> _caret_min_ : *this\text\caret\pos[2] = _caret_min_ : _caret_last_pos_ = *this\text\caret\pos[1]
                    Repaint = _edit_sel_draw_(*this, _line_first_, *this\text\caret\pos[2])  
                  EndIf
                  
                EndIf
                
              Case #PB_Shortcut_Down     ; Ok
                If *this\index[#__s_1] < _line_last_
                  If _caret_last_pos_
                    If Not Keyboard()\key[1] & #PB_Canvas_Alt And Not _key_control_
                      *this\text\caret\pos[1] = _caret_last_pos_
                      *this\text\caret\pos[2] = _caret_last_pos_
                    EndIf
                    _caret_last_pos_ = 0
                  EndIf
                  
                  If _key_shift_
                    If _key_control_
                      Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])  
                      Repaint = _edit_sel_draw_(*this, \count\items - 1, *this\text\len)  
                    Else
                      Repaint = _edit_sel_draw_(*this, *this\index[#__s_1] + _step_, *this\text\caret\pos[1])  
                    EndIf
                  ElseIf Keyboard()\key[1] & #PB_Canvas_Alt 
                    If *this\text\caret\pos[1] <> _caret_max_ 
                      *this\text\caret\pos[2] = _caret_max_
                    Else
                      *this\index[#__s_2] + _step_ 
                      
                      If SelectElement(*this\row\_s(), *this\index[#__s_2]) 
                        _caret_max_ = *this\row\_s()\text\len
                        
                        If *this\text\caret\pos[1] <> _caret_max_
                          *this\text\caret\pos[2] = _caret_max_
                          
                          Debug "" + #PB_Compiler_Procedure + "*this\text\caret\pos[1] <> _caret_max_"
                        EndIf
                      EndIf
                    EndIf
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])  
                    
                  Else
                    If _key_control_
                      *this\index[#__s_2] = \count\items - 1
                      *this\text\caret\pos[2] = *this\text\len
                    Else
                      *this\index[#__s_2] + _step_
                    EndIf
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])  
                  EndIf
                ElseIf *this\index[#__s_1] = _line_last_
                  
                  If *this\row\_s()\index <> _line_last_ And
                     SelectElement(*this\row\_s(), _line_last_) 
                    _caret_max_ = *this\row\_s()\text\len
                    Debug "" + #PB_Compiler_Procedure + "*this\row\_s()\index <> _line_last_"
                  EndIf
                  
                  If *this\text\caret\pos[1] <> _caret_max_ : *this\text\caret\pos[2] = _caret_max_ : _caret_last_pos_ = *this\text\caret\pos[1]
                    Repaint = _edit_sel_draw_(*this, _line_last_, *this\text\caret\pos[2])  
                  EndIf
                  
                EndIf
                
              Case #PB_Shortcut_Left     ; Ok
                If _key_shift_        
                  If _key_control_
                    Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], 0)  
                  Else
                    _line_ = *this\index[#__s_1] - Bool(*this\index[#__s_1] > _line_first_ And *this\text\caret\pos[1] = _caret_min_) * _step_
                    
                    ; коректируем позицию коректора
                    If *this\row\_s()\index <> _line_ And
                       SelectElement(*this\row\_s(), _line_) 
                    EndIf
                    If *this\text\caret\pos[1] > *this\row\_s()\text\len
                      *this\text\caret\pos[1] = *this\row\_s()\text\len
                    EndIf
                    
                    If *this\index[#__s_1] <> _line_
                      Repaint = _edit_sel_draw_(*this, _line_, *this\row\_s()\text\len)  
                    ElseIf *this\text\caret\pos[1] > _caret_min_
                      Repaint = _edit_sel_draw_(*this, _line_, *this\text\caret\pos[1] - _step_)  
                    EndIf
                  EndIf
                  
                ElseIf *this\index[#__s_1] > _line_first_
                  If Keyboard()\key[1] & #PB_Canvas_Alt 
                    *this\text\caret\pos[2] = _edit_sel_start_(*this)
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])  
                  Else
                    If _key_control_
                      *this\text\caret\pos[2] = 0
                    Else
                      If *this\text\caret\pos[2] = *this\text\caret\pos[1]
                        *this\text\caret\pos[2] - _step_
                      Else
                        *this\text\caret\pos[2] = *this\text\caret\pos[1] - _step_ 
                      EndIf
                      
                      If *this\text\caret\pos[1] = _caret_min_
                        *this\index[#__s_2] - _step_
                        
                        If SelectElement(*this\row\_s(), *this\index[#__s_2]) 
                          *this\text\caret\pos[1] = *this\row\_s()\text\len
                          *this\text\caret\pos[2] = *this\row\_s()\text\len
                        EndIf
                      EndIf
                    EndIf
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])  
                  EndIf
                  
                ElseIf *this\index[#__s_1] = _line_first_
                  
                  If *this\text\caret\pos[1] > _caret_min_ 
                    *this\text\caret\pos[2] - _step_
                    Repaint = _edit_sel_draw_(*this, _line_first_, *this\text\caret\pos[2])  
                  EndIf
                  
                EndIf
                
              Case #PB_Shortcut_Right    ; Ok
                If _key_shift_       
                  If _key_control_
                    Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\len)  
                  Else
                    If *this\row\_s()\index <> *this\index[#__s_1] And
                       SelectElement(*this\row\_s(), *this\index[#__s_1]) 
                      _caret_max_ = *this\row\_s()\text\len
                    EndIf
                    
                    If *this\text\caret\pos[1] > _caret_max_
                      *this\text\caret\pos[1] = _caret_max_
                    EndIf
                    
                    _line_ = *this\index[#__s_1] + Bool(*this\index[#__s_1] < _line_last_ And *this\text\caret\pos[1] = _caret_max_) * _step_
                    
                    ; если дошли в конец строки,
                    ; то переходим в начало
                    If *this\index[#__s_1] <> _line_ 
                      Repaint = _edit_sel_draw_(*this, _line_, 0)  
                    ElseIf *this\text\caret\pos[1] < _caret_max_
                      Repaint = _edit_sel_draw_(*this, _line_, *this\text\caret\pos[1] + _step_)  
                    EndIf
                  EndIf
                  
                ElseIf *this\index[#__s_1] < _line_last_
                  If Keyboard()\key[1] & #PB_Canvas_Alt 
                    *this\text\caret\pos[2] = _edit_sel_stop_(*this)
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])  
                  Else
                    If _key_control_
                      *this\text\caret\pos[2] = *this\text\len
                    Else
                      If *this\text\caret\pos[2] = *this\text\caret\pos[1]
                        *this\text\caret\pos[2] + _step_
                      Else
                        *this\text\caret\pos[2] = *this\text\caret\pos[1] + _step_ 
                      EndIf
                      
                      If *this\text\caret\pos[1] = _caret_max_
                        *this\index[#__s_2] + _step_
                        
                        If SelectElement(*this\row\_s(), *this\index[#__s_2]) 
                          *this\text\caret\pos[1] = 0
                          *this\text\caret\pos[2] = 0
                        EndIf
                      EndIf
                    EndIf
                    
                    Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], *this\text\caret\pos[2])  
                  EndIf
                  
                ElseIf *this\index[#__s_1] = _line_last_
                  
                  If *this\text\caret\pos[1] < _caret_max_ 
                    *this\text\caret\pos[2] + _step_
                    
                    
                    Repaint = _edit_sel_draw_(*this, _line_last_, *this\text\caret\pos[2])  
                  EndIf
                  
                EndIf
                
                ;- backup  
              Case #PB_Shortcut_Back   
                If Not \notify
                  If Not _text_paste_(*this)
                    If \row\_s()\text\edit[2]\len
                      
                      If \text\caret\pos[1] > \text\caret\pos[2] : \text\caret\pos[1] = \text\caret\pos[2] : EndIf
                      \row\_s()\text\edit[2]\len = 0 : \row\_s()\text\edit[2]\string.s = "" : \row\_s()\text\edit[2]\change = 1
                      
                      \row\_s()\text\string.s = \row\_s()\text\edit[1]\string.s + \row\_s()\text\edit[3]\string.s
                      \row\_s()\text\len = \row\_s()\text\edit[1]\len + \row\_s()\text\edit[3]\len : \row\_s()\text\change = 1
                      
                      \text\string.s = \text\edit[1]\string + \text\edit[3]\string
                      \text\change =- 1 ; - 1 post event change widget
                      
                    ElseIf \text\caret\pos[2] > 0 : \text\caret\pos[1] - 1 
                      \row\_s()\text\edit[1]\string.s = Left(\row\_s()\text\string.s, \text\caret\pos[1] )
                      \row\_s()\text\edit[1]\len = Len(\row\_s()\text\edit[1]\string.s) : \row\_s()\text\edit[1]\change = 1
                      
                      \row\_s()\text\string.s = \row\_s()\text\edit[1]\string.s + \row\_s()\text\edit[3]\string.s
                      \row\_s()\text\len = \row\_s()\text\edit[1]\len + \row\_s()\text\edit[3]\len : \row\_s()\text\change = 1
                      
                      \text\string.s = Left(\text\string.s, \row\_s()\text\pos + \text\caret\pos[1]) + \text\edit[3]\string
                      \text\change =- 1 ; - 1 post event change widget
                      
                    Else
                      ; Если дошли до начала строки то 
                      ; переходим в конец предыдущего итема
                      If \index[#__s_1] > _line_first_ 
                        \text\string.s = RemoveString(\text\string.s, #LF$, #PB_String_CaseSensitive, \row\_s()\text\pos + \text\caret\pos[1], 1)
                        
                        ;to up
                        \index[#__s_1] - 1
                        \index[#__s_2] - 1
                        
                        If *this\row\_s()\index <> \index[#__s_2] And
                           SelectElement(*this\row\_s(), \index[#__s_2]) 
                        EndIf
                        ;: _edit_sel_draw_(*this, \index[2], \text\len)
                        
                        \text\caret\pos[1] = \row\_s()\text\len
                        \text\change =- 1 ; - 1 post event change widget
                        
                      Else
                        \notify = 2
                        ProcedureReturn - 1
                      EndIf
                      
                    EndIf
                  EndIf
                  
                  If \text\change
                    \text\caret\pos[2] = \text\caret\pos[1] 
                    Repaint =- 1 
                  EndIf
                EndIf
                
                
              Case #PB_Shortcut_Delete
                If Not _text_paste_(*this) And 
                   (\text\caret\pos[2] < \text\len Or \row\_s()\text\edit[2]\len)
                  
                  If \row\_s()\text\edit[2]\len 
                    If \text\caret\pos[1] > \text\caret\pos[2] 
                      \text\caret\pos[1] = \text\caret\pos[2] 
                    Else
                      \text\caret\pos[2] = \text\caret\pos[1] 
                    EndIf
                    
                    \row\_s()\text\edit[2]\pos = 0 
                    \row\_s()\text\edit[2]\len = 0 
                    \row\_s()\text\edit[2]\width = 0 
                    \row\_s()\text\edit[2]\string.s = "" 
                    \row\_s()\text\edit[2]\change = 1
                    
                  Else
                    \row\_s()\text\edit[3]\string.s = Right(\row\_s()\text\string.s, \row\_s()\text\len - \text\caret\pos[1] - 1)
                    \row\_s()\text\edit[3]\len = Len(\row\_s()\text\edit[3]\string.s) : \row\_s()\text\edit[3]\change = 1
                    
                    \text\edit[3]\string = Right(\text\string.s, \text\len - (\row\_s()\text\pos + \text\caret\pos[1] ) - 1)
                    \text\edit[3]\len = Len(\text\edit[3]\string.s)
                    \text\caret\pos[2] = \text\caret\pos[1] 
                  EndIf
                  
                  \row\_s()\text\string.s = \row\_s()\text\edit[1]\string.s + \row\_s()\text\edit[3]\string.s
                  \row\_s()\text\len = \row\_s()\text\edit[1]\len + \row\_s()\text\edit[3]\len : \row\_s()\text\change = 1
                  
                  \text\string.s = \text\edit[1]\string + \text\edit[3]\string
                  \text\change =- 1 
                  Repaint =- 1 
                EndIf
                
                ;- return
              Case #PB_Shortcut_Return 
                If *this\text\multiline
                  If Not _text_paste_(*this, #LF$)
                    *this\index[#__s_2] + 1
                    *this\index[#__s_1] = *this\index[#__s_2]
                    *this\text\caret\pos[2] = 0
                    *this\text\caret\pos[1] = 0
                    *this\text\change =- 1 ; - 1 post event change widget
                  EndIf
                  
                  If *this\text\change 
                    Repaint = 1
                  EndIf
                Else
                  *this\notify = 3
                  ProcedureReturn - 1
                EndIf
                
              Case #PB_Shortcut_C, #PB_Shortcut_X
                If _key_control_
                  SetClipboardText(*this\text\edit[2]\string)
                  
                  If Keyboard()\key = #PB_Shortcut_X
                    Repaint = _text_paste_(*this)
                  EndIf
                EndIf
                
              Case #PB_Shortcut_V
                If _key_control_ And *this\text\editable
                  Protected text.s = GetClipboardText()
                  
                  If Not *this\text\multiLine
                    text = ReplaceString(text, #LFCR$, #LF$)
                    text = ReplaceString(text, #CRLF$, #LF$)
                    text = ReplaceString(text, #CR$, #LF$)
                    text = RemoveString(text, #LF$)
                  EndIf
                  
                  Repaint = _text_insert_(*this, text)
                EndIf  
                
            EndSelect 
            
            Select Keyboard()\key
              Case #PB_Shortcut_Home,
                   #PB_Shortcut_End,
                   #PB_Shortcut_PageUp, 
                   #PB_Shortcut_PageDown,
                   #PB_Shortcut_Up,
                   #PB_Shortcut_Down,
                   #PB_Shortcut_Left,
                   #PB_Shortcut_Right,
                   #PB_Shortcut_Delete,
                   #PB_Shortcut_Return ;, #PB_Shortcut_back
                
                If Not Repaint
                  *this\notify =- 1
                  ProcedureReturn - 1
                EndIf
                
              Case #PB_Shortcut_A,
                   #PB_Shortcut_C,
                   #PB_Shortcut_X, 
                   #PB_Shortcut_V
                
            EndSelect
            
        EndSelect
      EndWith
      
      ProcedureReturn Repaint
    EndProcedure
    
    Procedure   _Editor_Events(*this._s_widget, eventtype.l, mouse_x.l, mouse_y.l)
      Static DoubleClick.i = -1
      Protected Repaint.i, _key_control_.i, Caret.i, _line_.l, String.s
      
      With *this
        ;If \text\editable  
        
        ;Debug *this\scroll\v\bar\index
        If *this And (*this\scroll\v And *this\scroll\h And *this\scroll\v\bar\index =- 1 And *this\scroll\h\bar\index =- 1)
          If ListSize(*this\row\_s())
            If Not \hide ;And \interact
                         ; Get line position
                         ;If Mouse()\buttons ; сним двойной клик не работает
              If \scroll\v And (Mouse()\y - \y[#__c_inner] - \text\y + \scroll\v\bar\page\pos) > 0
                _line_ = ((Mouse()\y - \y[#__c_inner] - \text\y - \y[#__c_required]) / (\text\height + \mode\gridlines))
                ;  _line_ = ((Mouse()\y - \y[2] - \text\y + \scroll\v\bar\page\pos) / (\text\height + \mode\gridlines))
              Else
                _line_ =- 1
              EndIf
              ;EndIf
              ;Debug  _line_; (Mouse()\y - \y[2] - \text\y + \scroll\v\bar\page\pos)
              
              Select eventtype 
                Case #__Event_leftDoubleClick 
                  ; bug pb
                  ; в мак ос в editorgadget ошибка
                  ; при двойном клике на слове выделяет правильно 
                  ; но стирает вместе с предшествующим пробелом
                  ; в окнах выделяет уще и пробелл но стирает то что выделено
                  
                  ; Событие двойной клик происходит по разному
                  ; - mac os  - 
                  ; LeftButtonDown 
                  ; LeftButtonUp 
                  ; LeftClick 
                  ; LeftDoubleClick 
                  
                  ; - windows & linux  - 
                  ; LeftButtonDown
                  ; LeftDoubleClick
                  ; LeftButtonUp
                  ; LeftClick
                  
                  *this\index[#__s_2] = _line_
                  
                  Caret = _edit_sel_stop_(*this)
                  *this\text\caret\time = ElapsedMilliseconds()
                  *this\text\caret\pos[2] = _edit_sel_start_(*this)
                  Repaint = _edit_sel_draw_(*this, *this\index[#__s_2], Caret)
                  *this\row\selected = \row\_s() ; *this\index[2]
                  
                Case #__Event_leftButtonDown
                  
                  If _is_item_(*this, _line_) And 
                     _line_ <> \row\_s()\index  
                    \row\_s()\color\state = 0
                    SelectElement(*this\row\_s(), _line_) 
                  EndIf
                  
                  If _line_ = \row\_s()\index
                    \row\_s()\color\state = 1
                    
                    If *this\row\selected And 
                       *this\row\selected = \row\_s() And
                       (ElapsedMilliseconds() - *this\text\caret\time) < 500
                      
                      *this\text\caret\pos[2] = 0
                      *this\row\box\state = #False
                      *this\row\selected = #Null
                      *this\index[#__s_1] = _line_
                      *this\text\caret\pos[1] = \row\_s()\text\len ; Чтобы не прокручивало в конец строки
                      Repaint = _edit_sel_draw_(*this, _line_, \row\_s()\text\len)
                      
                    Else
                      _start_drawing_(*this)
                      *this\row\selected = \row\_s()
                      
                      If *this\text\editable And _edit_sel_is_line_(*this)
                        ; Отмечаем что кликнули
                        ; по выделеному тексту
                        *this\row\box\state = 1
                        
                        Debug "sel - " + \row\_s()\text\edit[2]\width
                        _set_cursor_(*this, #PB_Cursor_Default)
                      Else
                        ; reset items selection
                        PushListPosition(*this\row\_s())
                        ForEach *this\row\_s()
                          If *this\row\_s()\text\edit[2]\width <> 0 
                            _edit_sel_reset_(*this\row\_s())
                          EndIf
                        Next
                        PopListPosition(*this\row\_s())
                        
                        Caret = _text_caret_(*this)
                        
                        \index[#__s_2] = \row\_s()\index 
                        
                        
                        If *this\text\caret\pos[1] <> Caret
                          *this\text\caret\pos[1] = Caret
                          *this\text\caret\pos[2] = Caret 
                          Repaint =- 1
                        EndIf
                        
                        If *this\index[#__s_1] <> _line_ 
                          *this\index[#__s_1] = _line_
                          Repaint = 1
                        EndIf
                        
                        If Repaint
                          Repaint = Bool(_edit_sel_set_(*this, _line_, Repaint))
                        EndIf
                      EndIf
                      
                      StopDrawing() 
                    EndIf
                  EndIf
                  
                  
                Case #__Event_MouseMove  
                  If Mouse()\buttons & #PB_Canvas_LeftButton 
                    Repaint = _edit_sel_draw_(*this, _line_)
                  EndIf
                  
                Case #__Event_leftButtonUp  
                  If *this\text\editable And *this\row\box\state
                    ;                   
                    ;                   If _line_ >= 0 And 
                    ;                      _line_ < \count\items And 
                    ;                      _line_ <> \row\_s()\index And 
                    ;                      SelectElement(\row\_s(), _line_) 
                    ;                   EndIf
                    ;                    
                    _start_drawing_(*this)
                    
                    ; на одной линии работает
                    ; теперь надо сделать чтоб и на другие линии можно было бросать
                    If *this\text\caret\pos[2] = *this\text\caret\pos[1] 
                      
                      ; Если бросили на правую сторону от выделеного текста.
                      If *this\index[#__s_2] = *this\index[#__s_1] And *this\text\caret\pos[2] > *this\row\selected\text\edit[2]\pos + *this\row\selected\text\edit[2]\len
                        *this\text\caret\pos[2] - *this\row\selected\text\edit[2]\len
                      EndIf
                      ; Debug "" + *this\text\caret\pos[2]  + " " +  *this\row\selected\text\edit[2]\pos
                      
                      *this\row\selected\text\string = RemoveString(*this\row\selected\text\string, *this\row\selected\text\edit[2]\string, #PB_String_CaseSensitive, *this\row\selected\text\edit[2]\pos, 1)
                      *this\text\string = RemoveString(*this\text\string, *this\row\selected\text\edit[2]\string, #PB_String_CaseSensitive, *this\row\selected\text\pos + *this\row\selected\text\edit[2]\pos, 1)
                      
                      *this\row\_s()\text\string = InsertString(*this\row\_s()\text\string, *this\row\selected\text\edit[2]\string, *this\text\caret\pos[2] + 1)
                      *this\text\string = InsertString(*this\text\string, *this\row\selected\text\edit[2]\string, *this\row\_s()\text\pos + *this\text\caret\pos[2] + 1)
                      
                      
                      ;                       \row\_s()\text\edit[1]\string.s = Left(\row\_s()\text\string.s, \text\caret\pos[1] )
                      ;                     \row\_s()\text\edit[1]\len = Len(\row\_s()\text\edit[1]\string.s) : \row\_s()\text\edit[1]\change = 1
                      ;                     
                      ;                     \row\_s()\text\string.s = \row\_s()\text\edit[1]\string.s + \row\_s()\text\edit[3]\string.s
                      ;                     \row\_s()\text\len = \row\_s()\text\edit[1]\len + \row\_s()\text\edit[3]\len : \row\_s()\text\change = 1
                      ;                     
                      ;                     \text\string.s = Left(\text\string.s, \row\_s()\text\pos + \text\caret\pos[1] ) + \text\edit[3]\string
                      ;                     \text\change =- 1 ; - 1 post event change widget
                      
                      ;                     _text_insert_(*this, *this\row\selected\text\edit[2]\string)
                      
                      Debug *this\row\selected\index
                      ;                     *this\index[1] = *this\row\selected\index
                      ;                     *this\index[2] = *this\row\selected\index
                      ;                     Protected len = *this\row\selected\text\edit[2]\len
                      ;                     ;
                      ;                     _line_ = *this\row\selected\index
                      ;                     If _line_ >= 0 And 
                      ;                      _line_ < \count\items And 
                      ;                      _line_ <> \row\_s()\index And 
                      ;                      SelectElement(\row\_s(), _line_) 
                      ;                   EndIf
                      ;                           
                      Debug *this\row\selected\text\string
                      
                      If *this\index[#__s_2] <> *this\index[#__s_1]
                        ; *this\text\change =- 1
                        _edit_sel_reset_(*this\row\selected)
                        *this\index[#__s_2] = *this\index[#__s_1]
                        
                        ;                          *this\text\change =- 1
                        ;                       make_text_multiline(*this)
                        ;                        *this\text\change = 0
                        ;                     
                      EndIf
                      
                      *this\text\caret\pos[1] = *this\row\selected\text\edit[2]\len
                      
                      ;Swap *this\text\caret\pos[1], *this\text\caret\pos[2]
                      *this\row\selected = #Null
                      
                      Repaint = _edit_sel_(*this, *this\text\caret\pos[2], *this\text\caret\pos[1])
                      ;                     If *this\text\caret\pos[1] <> Caret  ; *this\text\caret\pos[2]); + *this\row\selected\text\edit[2]\len
                      ;                       *this\text\caret\pos[1] = Caret
                      ;                       Repaint =- 1
                      ;                     EndIf
                      ;                     
                      ;                     If *this\index[1] <> _line_ 
                      ;                       *this\index[1] = _line_
                      ;                       Repaint = 1
                      ;                     EndIf
                      ;Repaint = _edit_sel_set_(*this, *this\index[1], Repaint)
                      
                      _set_cursor_(*this, #PB_Cursor_IBeam)
                    Else
                      *this\text\caret\pos[2] = _text_caret_(*this)
                      *this\row\_s()\text\edit[2]\len = 0
                      *this\index[#__s_2] = _line_
                      
                      If *this\text\caret\pos[1] <> *this\text\caret\pos[2] + *this\row\selected\text\edit[2]\len
                        *this\text\caret\pos[1] = *this\text\caret\pos[2] + *this\row\selected\text\edit[2]\len
                        Repaint =- 1
                      EndIf
                      
                      If *this\index[#__s_1] <> _line_ 
                        *this\index[#__s_1] = _line_
                        Repaint = 1
                      EndIf
                      
                      Repaint = _edit_sel_set_(*this, _line_, Repaint)
                    EndIf
                    
                    StopDrawing() 
                    *this\row\box\state = #False
                    *this\row\selected = #Null
                    Repaint = 1
                  EndIf
                  
                Default
                  If _is_item_(*this, \index[#__s_2]) And 
                     \index[#__s_2] <> \row\_s()\index  
                    \row\_s()\color\state = 0
                    SelectElement(*this\row\_s(), \index[#__s_2]) 
                  EndIf
                  
              EndSelect
            EndIf
            
            ; edit key events
            If eventtype = #__Event_Input Or
               eventtype = #__Event_KeyDown Or
               eventtype = #__Event_KeyUp
              
              Repaint | Editor_Events_Key(*this, eventtype, Mouse()\x, Mouse()\y)
            EndIf
          EndIf
        EndIf
        ;EndIf
      EndWith
      
      If *this\text\change 
        *this\change = 1
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    Procedure   Editor_Events(*this._s_widget, eventtype.l, mouse_x.l, mouse_y.l)
      Protected Repaint
      
      Select eventtype
        Case #PB_EventType_Focus
          If *this\text\editable
            Repaint = Bool(Post(eventtype, *this))
          EndIf
          
        Case #PB_EventType_LostFocus
          If *this\text\editable
            Repaint = Bool(Post(eventtype, *this))
          EndIf
          
      EndSelect
      
      Repaint = _Editor_Events(*this._s_widget, eventtype.l, mouse_x.l, mouse_y.l)
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ;- 
    ;-  TREE
    Declare.l Tree_Draw(*this._s_widget, List row._s_rows())
    Declare tt_close(*this._s_tt)
    
    Procedure tt_tree_Draw(*this._s_tt, *color._s_color = 0)
      With *this
        If *this And IsGadget(\gadget) And StartDrawing(CanvasOutput(\gadget))
          If Not *color
            *color = \color
          EndIf
          
          ;_drawing_font_(*this)
          If \text\fontID 
            DrawingFont(\text\fontID) 
          EndIf
          
          DrawingMode(#PB_2DDrawing_Default)
          Box(0,1,\width,\height - 2, *color\back[*color\state])
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawText(\text\x, \text\y, \text\string, *color\front[*color\state])
          DrawingMode(#PB_2DDrawing_Outlined)
          Line(0,0,\width,1, *color\frame[*color\state])
          Line(0,\height - 1,\width,1, *color\frame[*color\state])
          Line(\width - 1,0,1,\height, *color\frame[*color\state])
          StopDrawing()
        EndIf 
      EndWith
    EndProcedure
    
    Procedure tt_tree_callBack()
      ;     ;SetActiveWindow(This()\widget\root\canvas\window)
      ;     ;SetActiveGadget(This()\widget\root\canvas\gadget)
      ;     
      ;     If This()\widget\row\selected
      ;       This()\widget\row\selected\color\state = 0
      ;     EndIf
      ;     
      ;     This()\widget\row\selected = This()\widget\row\_s()
      ;     This()\widget\row\_s()\color\state = 2
      ;     This()\widget\color\state = 2
      ;     
      ;     ;Tree_reDraw(This()\widget)
      
      tt_close(GetWindowData(EventWindow()))
    EndProcedure
    
    Procedure tt_creare(*this._s_widget, x,y)
      With *this
        If *this
          This()\widget = *this
          \row\tt = AllocateStructure(_s_tt)
          \row\tt\visible = 1
          \row\tt\x = x + \row\_s()\x + \row\_s()\width - 1
          \row\tt\y = y + \row\_s()\y - \scroll\v\bar\page\pos
          
          \row\tt\width = \row\_s()\text\width - \width[#__c_inner] + (\row\_s()\text\x - \row\_s()\x) + 5 ; -  (\width[#__c_required] - \width); -  \row\_s()\text\x; 105 ;\row\_s()\text\width - (\width[#__c_required] - \row\_s()\width)  ; - 32 + 5 
          
          If \row\tt\width < 6
            \row\tt\width = 0
          EndIf
          
          Debug \row\tt\width ;Str(\row\_s()\text\x - \row\_s()\x)
          
          \row\tt\height = \row\_s()\height
          Protected flag
          CompilerIf #PB_Compiler_OS = #PB_OS_Linux
            flag = #PB_Window_Tool
          CompilerEndIf
          
          \row\tt\window = OpenWindow(#PB_Any, \row\tt\x, \row\tt\y, \row\tt\width, \row\tt\height, "", 
                                      #PB_Window_BorderLess|#PB_Window_NoActivate|flag, WindowID(\root\canvas\window))
          
          \row\tt\gadget = CanvasGadget(#PB_Any,0,0, \row\tt\width, \row\tt\height)
          \row\tt\color = \row\_s()\color
          \row\tt\text = \row\_s()\text
          \row\tt\text\fontID = \row\_s()\text\fontID
          \row\tt\text\x =- (\width[#__c_inner] - (\row\_s()\text\x - \row\_s()\x)) + 1
          \row\tt\text\y = (\row\_s()\text\y - \row\_s()\y) + \scroll\v\bar\page\pos
          
          BindEvent(#PB_Event_ActivateWindow, @tt_tree_callBack(), \row\tt\window)
          SetWindowData(\row\tt\window, \row\tt)
          tt_tree_Draw(\row\tt)
        EndIf
      EndWith              
    EndProcedure
    
    Procedure tt_close(*this._s_tt)
      If IsWindow(*this\window)
        *this\visible = 0
        ; UnbindEvent(#PB_Event_ActivateWindow, @tt_tree_callBack(), *this\window)
        CloseWindow(*this\window)
        ; ClearStructure(*this, _s_tt) ;??????
      EndIf
    EndProcedure
    
    ;- 
    Macro _tree_bar_update_(_this_, _pos_, _len_)
      ;       Bool(Bool((_pos_ - _this_\y - _this_\bar\page\pos) < 0 And bar_SetState(_this_, (_pos_ - _this_\y))) Or
      ;            Bool((_pos_ - _this_\y - _this_\bar\page\pos) > (_this_\bar\page\len - _len_) And
      ;                 bar_SetState(_this_, (_pos_ - _this_\y) - (_this_\bar\page\len - _len_)))) : _this_\change = 0
      _bar_scrollarea_change_(_this_, _pos_ - _this_\y, _len_)
    EndMacro
    
    Procedure   Tree_Update(*this._s_widget, List row._s_rows())
      Debugger()
      
      If *this\change > 0
        *this\x[#__c_required] = 0
        *this\y[#__c_required] = 0
        *this\width[#__c_required] = 0
        *this\height[#__c_required] = 0
      EndIf
      
      ; reset item z - order
      PushListPosition(row())
      ForEach row()
        If row()\parent
          row()\parent\first = 0
          row()\parent\last = 0
        EndIf     
      Next
      ;       PopListPosition(row())
      Protected bp = 12; + Bool(*this\mode\check <> 4) * 8
      
      ;       
      ;       PushListPosition(row())
      ForEach row()
        row()\index = ListIndex(row())
        
        If row()\hide
          row()\draw = 0
        Else
          If *this\change > 0
            ; check box position
            If (*this\mode\check = 1 Or 
                *this\mode\check = 4)
              row()\box[1]\width = 11
              row()\box[1]\height = row()\box[1]\width
            EndIf
            
            If (*this\mode\lines Or *this\mode\buttons) And
               Not (row()\sublevel And *this\mode\check = 4)
              row()\box[0]\width = 9
              row()\box[0]\height = 9
            EndIf
            
            ; drawing item font
            _drawing_font_item_(*this, row(), row()\text\change)
            
            row()\height = row()\text\height + 2 ;
            row()\y = *this\y[#__c_inner] + *this\height[#__c_required]
            
            row()\x = *this\x[#__c_inner]
            row()\width = *this\width[#__c_inner] ; ???
          EndIf
          
          ;           ; sublevel position
          ;           If (*this\mode\check = 4)
          ;             If *this\mode\buttons
          ;               row()\sublevellen = row()\sublevel * *this\row\sublevellen + row()\box[1]\width + 6 ;+ 18
          ;             Else
          ;               row()\sublevellen = 18
          ;             EndIf
          ;           Else
          ;             row()\sublevellen = row()\sublevel * *this\row\sublevellen + Bool(*this\mode\lines Or *this\mode\buttons) * (bp+bp/2) + Bool(*this\mode\check = 1) * 18
          ;           EndIf
          
          row()\sublevellen = row()\sublevel * *this\row\sublevellen + Bool(*this\mode\lines Or *this\mode\buttons) * (bp+bp/2) + Bool(*this\mode\check) * 18
          
          ; check & option box position
          If (*this\mode\check = 1 Or 
              *this\mode\check = 4)
            
            If row()\parent And *this\mode\check = 4
              row()\box[1]\x = row()\x + row()\sublevellen - row()\box[1]\width - *this\scroll\h\bar\page\pos
            Else
              row()\box[1]\x = row()\x + (18 - row()\box[1]\width) - *this\scroll\h\bar\page\pos
            EndIf
            row()\box[1]\y = (row()\y + row()\height) - (row()\height + row()\box[1]\height)/2 - *this\scroll\v\bar\page\pos
          EndIf
          
          ; expanded & collapsed box position
          If (*this\mode\lines Or *this\mode\buttons) And Not (row()\sublevel And *this\mode\check = 4)
            
            If *this\mode\check = 4
              row()\box[0]\x = row()\x + row()\sublevellen - 10 - *this\scroll\h\bar\page\pos ; - Bool(*this\mode\check=4) * 16
            Else
              row()\box[0]\x = row()\x + row()\sublevellen - bp+2 - *this\scroll\h\bar\page\pos ; - Bool(*this\mode\check=4) * 16
            EndIf
            row()\box[0]\y = (row()\y + row()\height) - (row()\height + row()\box[0]\height)/2 - *this\scroll\v\bar\page\pos
          EndIf
          
          ; image position
          If row()\image\id
            row()\image\x = row()\x + row()\sublevellen + *this\image\padding\x + 3 - *this\scroll\h\bar\page\pos
            row()\image\y = row()\y + (row()\height - row()\image\height)/2 - *this\scroll\v\bar\page\pos
          EndIf
          
          ; text position
          If row()\text\string
            row()\text\x = row()\x + row()\sublevellen + *this\row\margin\width + *this\text\padding\x - *this\scroll\h\bar\page\pos
            row()\text\y = row()\y + (row()\height - row()\text\height)/2 - *this\scroll\v\bar\page\pos
          EndIf
          
          If row()\text\edit\string
            row()\text\edit\x = row()\x + row()\sublevellen + *this\row\margin\width + *this\text\padding\x - *this\scroll\h\bar\page\pos  + *this\bar\page\pos; *this\bar\page\pos + row()\x + row()\sublevellen + 5
            row()\text\edit\y = row()\text\y
          EndIf
          
          ; vertical & horizontal scroll max value
          If *this\change > 0
            *this\height[#__c_required] + row()\height + Bool(row()\index <> *this\count\items - 1) * *this\mode\GridLines
            
            If *this\width[#__c_required] < (*this\row\_s()\text\x + *this\row\_s()\text\width + *this\mode\fullSelection + *this\scroll\h\bar\page\pos) - *this\x[#__c_inner]
              *this\width[#__c_required] = (*this\row\_s()\text\x + *this\row\_s()\text\width + *this\mode\fullSelection + *this\scroll\h\bar\page\pos) - *this\x[#__c_inner]
            EndIf
          EndIf
        EndIf
      Next
      ;       PopListPosition(row())
      
      ; if the item list has changed
      If *this\change > 0
        ; *this\height[#__c_required] - *this\mode\gridlines
        
        ; change vertical scrollbar max
        If *this\scroll\v\bar\max <> *this\height[#__c_required] And
           bar_SetAttribute(*this\scroll\v, #__bar_Maximum, *this\height[#__c_required])
          
          Bar_Resizes(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          *this\width[#__c_inner] = *this\scroll\h\bar\page\len
          *this\height[#__c_inner] = *this\scroll\v\bar\page\len
        EndIf
        
        ; change horizontal scrollbar max
        If *this\scroll\h\bar\max <> *this\width[#__c_required] And
           bar_SetAttribute(*this\scroll\h, #__bar_Maximum, *this\width[#__c_required])
          
          Bar_Resizes(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          *this\width[#__c_inner] = *this\scroll\h\bar\page\len
          *this\height[#__c_inner] = *this\scroll\v\bar\page\len
        EndIf
        
        ; 
        If *this\row\selected And *this\row\scrolled
          bar_SetState(*this\scroll\v, ((*this\row\selected\y - *this\scroll\v\y) - (Bool(*this\row\scrolled>0) * (*this\scroll\v\bar\page\len - *this\row\selected\height))) ) 
          *this\scroll\v\change = 0 
          *this\row\scrolled = 0
          
          Tree_Draw(*this, *this\row\draws())
        EndIf
      EndIf
      
      ; reset draw list
      ClearList(*this\row\draws())
      
      ;        PushListPosition(row())
      ForEach row()
        row()\draw = Bool(Not row()\hide And 
                          ((row()\y + row()\height) - *this\scroll\v\bar\page\pos > *this\y[#__c_inner] And 
                           (row()\y - *this\y[#__c_inner]) - *this\scroll\v\bar\page\pos < *this\height[#__c_inner]))
        
        ; lines for tree widget
        If *this\mode\lines And *this\row\sublevellen
          
          ; ; ;             If row()\parent
          ; ; ;               ; set z - order position 
          ; ; ;               If Not row()\parent\first 
          ; ; ;                 If Not row()\parent\last
          ; ; ;                   ; Debug row()\index
          ; ; ;                   row()\parent\last = row()
          ; ; ;                 EndIf
          ; ; ;                 ; Debug row()\index
          ; ; ;                 row()\parent\first = row()
          ; ; ;               ElseIf row()\parent\last
          ; ; ;                 row()\before = row()\parent\last
          ; ; ;                 row()\before\after = row()
          ; ; ;                 
          ; ; ;                 row()\parent\last = row()
          ; ; ;               EndIf
          ; ; ;             EndIf
          
          ; vertical lines for tree widget
          If row()\parent 
            
            If row()\draw
              If row()\parent\last
                row()\parent\last\l\v\height = 0
                
                row()\parent\last\first = 0
              EndIf
              
              row()\first = row()\parent
              row()\parent\last = row()
            Else
              
              If row()\parent\last
                row()\parent\last\l\v\height = (*this\y[#__c_inner] + *this\height[#__c_inner]) -  row()\parent\last\l\v\y 
              EndIf
              
            EndIf
            
          Else
            If row()\draw
              If *this\row\first\last And
                 *this\row\first\sublevel = *this\row\first\last\sublevel
                If *this\row\first\last\first
                  *this\row\first\last\l\v\height = 0
                  
                  *this\row\first\last\first = 0
                EndIf
              EndIf
              
              row()\first = *this\row\first
              *this\row\first\last = row()
              
            Else
              If *this\row\first\last And
                 *this\row\first\sublevel = *this\row\first\last\sublevel
                
                *this\row\first\last\l\v\height = (*this\y[#__c_inner] + *this\height[#__c_inner]) -  *this\row\first\last\l\v\y
                ;Debug row()\text\string
              EndIf
            EndIf
          EndIf
          
          row()\l\h\y = row()\box[0]\y + row()\box[0]\height/2
          row()\l\v\x = row()\box[0]\x + row()\box[0]\width/2
          
          If (*this\x[#__c_inner] - row()\l\v\x) < *this\mode\lines
            If row()\l\v\x<*this\x[#__c_inner]
              row()\l\h\width = (*this\mode\lines - (*this\x[#__c_inner] - row()\l\v\x))
            Else
              row()\l\h\width = *this\mode\lines
            EndIf
            
            If row()\draw And row()\l\h\y > *this\y[#__c_inner] And row()\l\h\y < *this\y[#__c_inner] + *this\height[#__c_inner]
              row()\l\h\x = row()\l\v\x + (*this\mode\lines - row()\l\h\width)
              row()\l\h\height = 1
            Else
              row()\l\h\height = 0
            EndIf
            
            ; Vertical plot
            If row()\first And *this\x[#__c_inner]<row()\l\v\x
              row()\l\v\y = (row()\first\y + row()\first\height -  Bool(row()\first\sublevel = row()\sublevel) * row()\first\height/2) - *this\scroll\v\bar\page\pos
              If row()\l\v\y < *this\y[#__c_inner] : row()\l\v\y = *this\y[#__c_inner] : EndIf
              
              row()\l\v\height = (row()\y + row()\height/2) - row()\l\v\y - *this\scroll\v\bar\page\pos
              If row()\l\v\height < 0 : row()\l\v\height = 0 : EndIf
              If row()\l\v\y + row()\l\v\height > *this\y[#__c_inner] + *this\height[#__c_inner] 
                If row()\l\v\y > *this\y[#__c_inner] + *this\height[#__c_inner] 
                  row()\l\v\height = 0
                Else
                  row()\l\v\height = (*this\y[#__c_inner] + *this\height[#__c_inner]) -  row()\l\v\y 
                EndIf
              EndIf
              
              If row()\l\v\height
                row()\l\v\width = 1
              Else
                row()\l\v\width = 0
              EndIf
            EndIf 
            
          EndIf
        EndIf
        
        ; add new draw list
        If row()\draw And 
           AddElement(*this\row\draws())
          *this\row\draws() = row()
        EndIf
      Next
      PopListPosition(row())
      
    EndProcedure
    
    
    Procedure.l Tree_Draw(*this._s_widget, List *row._s_rows())
      Protected state.b
      
      With *this
        If Not \hide
          If \change <> 0
            Tree_Update(*this, *this\row\_s())
            \change = 0
          EndIf 
          
          ; Draw background
          If *this\color\alpha
            DrawingMode(#PB_2DDrawing_Default)
            RoundBox(*this\x[#__c_frame],*this\y[#__c_frame],
                     *this\width[#__c_frame],*this\height[#__c_frame],
                     *this\round,*this\round,*this\color\back[*this\color\state])
          EndIf
          
          ; Draw background image
          If *this\image\id
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(*this\image\id, *this\image\x, *this\image\y, *this\color\alpha)
          EndIf
          ;
          PushListPosition(*row())
          
          ; Draw all items
          ForEach *row()
            If *row()\draw
              If *row()\width <> *this\width[#__c_inner]
                *row()\width = *this\width[#__c_inner]
              EndIf
              
              ; init real drawing font
              _drawing_font_item_(*this, *row(), 0)
              
              state = *row()\color\state  ; +  Bool(*row()\color\state = #__s_2 And *this <> GetActive()\gadget)
              
              ; Draw selector back
              If *row()\childrens And *this\_flag & #__tree_property
                DrawingMode(#PB_2DDrawing_Default)
                RoundBox(*this\x[#__c_inner], *row()\y - *this\scroll\v\bar\page\pos, *this\width[#__c_inner],*row()\height,*row()\round,*row()\round,*row()\color\back)
                ;RoundBox(*this\x[#__c_inner] + *this\row\sublevellen,Y,*this\width[#__c_inner] - *this\row\sublevellen,*row()\height,*row()\round,*row()\round,*row()\color\back[state])
                Line(*this\x[#__c_inner] + *this\row\sublevellen, *row()\y + *row()\height - *this\scroll\v\bar\page\pos, *this\width[#__c_inner] - *this\row\sublevellen, 1, $FFACACAC)
                
              Else
                If *row()\color\back[state]
                  DrawingMode(#PB_2DDrawing_Default)
                  RoundBox(*row()\x, *row()\y - *this\scroll\v\bar\page\pos, *row()\width, *row()\height,*row()\round,*row()\round,*row()\color\back[state])
                EndIf
              EndIf
              
              ; Draw items image
              If *row()\image\id
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(*row()\image\id, *row()\image\x, *row()\image\y, *row()\color\alpha)
              EndIf
              
              ; Draw items text
              If *row()\text\string.s
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawRotatedText(*row()\text\x, *row()\text\y, *row()\text\string.s, *this\text\rotate, *row()\color\front[state])
              EndIf
              
              ; Draw items data text
              If *row()\text\edit\string.s
                DrawingMode(#PB_2DDrawing_Transparent)
                DrawRotatedText(*row()\text\edit\x, *row()\text\edit\y, *row()\text\edit\string.s, *this\text\rotate, *row()\color\front[state])
              EndIf
              
              ; Draw selector frame
              If *row()\childrens And *this\_flag & #__tree_property
              Else
                If *row()\color\frame[state]
                  DrawingMode(#PB_2DDrawing_Outlined)
                  RoundBox(*row()\x, *row()\y - *this\scroll\v\bar\page\pos, *row()\width, *row()\height, *row()\round,*row()\round, *row()\color\frame[state])
                EndIf
              EndIf
              
              ; Horizontal line
              If *this\mode\GridLines And 
                 *row()\color\line <> *row()\color\back
                DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                Box(*row()\x, (*row()\y + *row()\height + Bool(*this\mode\gridlines>1)) - *this\scroll\v\bar\page\pos, *row()\width, 1, *this\color\line)
              EndIf
            EndIf
          Next
          
          ;           DrawingMode(#PB_2DDrawing_Default);|#PB_2DDrawing_AlphaBlend)
          ;           Box(*this\x[#__c_inner], *this\y[#__c_inner], *this\row\sublevellen, *this\height[#__c_inner], *this\row\_s()\parent\color\back)
          
          
          ; Draw plots
          If *this\mode\lines
            ;DrawingMode(#PB_2DDrawing_XOr);|#PB_2DDrawing_AlphaBlend)
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            ;DrawingMode(#PB_2DDrawing_XOr|#PB_2DDrawing_customFilter) 
            
            ;             CustomFilterCallback(@Draw_PlotX())
            ForEach *row()
              If *row()\draw 
                If *row()\l\h\height
                  Line(*row()\l\h\x, *row()\l\h\y, *row()\l\h\width, *row()\l\h\height, *row()\color\line)
                EndIf
                ;               EndIf    
                ;             Next
                ;             
                ;             CustomFilterCallback(@Draw_PlotY())
                ;             ForEach *row()
                ;               If *row()\draw 
                If *row()\l\v\width
                  Line(*row()\l\v\x, *row()\l\v\y, *row()\l\v\width, *row()\l\v\height, *row()\color\line)
                EndIf
              EndIf    
            Next
            
            
            ; ; ;           ; Draw plots
            ; ; ;           If *this\mode\lines
            ; ; ;             ;DrawingMode(#PB_2DDrawing_XOr);|#PB_2DDrawing_AlphaBlend)
            ; ; ;             ;DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            ; ; ;              DrawingMode(#PB_2DDrawing_customFilter) 
            ; ; ;             
            ; ; ;               CustomFilterCallback(@Draw_PlotX())
            ; ; ;             ForEach *row()
            ; ; ;               If *row()\draw 
            ; ; ;                 Line(*row()\box[0]\x + *row()\box[0]\width/2, *row()\box[0]\y + *row()\box[0]\height/2, *this\mode\lines, 1, *row()\color\front[*row()\color\state])
            ; ; ;               EndIf    
            ; ; ;             Next
            ; ; ;             
            ; ; ;               CustomFilterCallback(@Draw_PlotY())
            ; ; ;             ForEach *row()
            ; ; ;               If *row()\draw 
            ; ; ;                 ;                 If *row()\before And *row()\before\sublevel = *row()\sublevel
            ; ; ;                 ;                  Line(*row()\l\v\x, *row()\before\y - *this\scroll\v\bar\page\pos, 1, *row()\y - *row()\before\y + Bool(*row()\parent\last = *row()) * *row()\height/2, *row()\color\line)
            ; ; ;                 ;                 EndIf
            ; ; ;                 If *row()\after
            ; ; ;                   Line(*row()\after\box[0]\x + *row()\after\box[0]\width/2, *row()\y - *this\scroll\v\bar\page\pos, 1, *row()\after\y - *row()\y, *row()\color\front[*row()\color\state])
            ; ; ;                 Else
            ; ; ;                   Line(*row()\box[0]\x + *row()\box[0]\width/2, *row()\y - *this\scroll\v\bar\page\pos, 1, *row()\height/2, *row()\color\front[*row()\color\state])
            ; ; ;                 EndIf
            ; ; ;               EndIf    
            ; ; ;             Next
            ; ; ;           EndIf
          EndIf
          
          ; Draw check buttons
          If *this\mode\buttons Or
             (*this\mode\check = 1 Or *this\mode\check = 4)
            
; ; ;             DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
; ; ;             ; Draw boxs (check&option)
; ; ;             ForEach *row()
; ; ;               If *row()\draw And 
; ; ;                  *this\mode\check 
; ; ;                 If *row()\parent And *this\mode\check = 4
; ; ;                   *row()\box[1]\round = 4
; ; ;                 Else                                                                                                                ;If Not (*this\mode\buttons And *row()\childrens And *this\mode\check = 4)
; ; ;                   *row()\box[1]\round = 1
; ; ;                 EndIf
; ; ;                 
; ; ;                 If *row()\box[1]\state
; ; ;                   BackColor($FFE9BA81&$FFFFFF|255<<24)
; ; ;                   FrontColor($FFE89C3D&$FFFFFF|255<<24)
; ; ;                 Else
; ; ;                   BackColor($FFFeFeFe&$FFFFFF|255<<24)
; ; ;                   FrontColor($80E2E2E2&$FFFFFF|255<<24)
; ; ;                 EndIf
; ; ;                 
; ; ;                 LinearGradient(*row()\box[1]\x, *row()\box[1]\y,
; ; ;                                *row()\box[1]\x, (*row()\box[1]\y + *row()\box[1]\height))
; ; ;                 
; ; ;                 draw_box_button(*row()\box[1], 0)
; ; ;                 
; ; ;               EndIf    
; ; ;             Next
; ; ;             
; ; ;             DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
; ; ;             ; Draw state (check&option)
; ; ;             ForEach *row()
; ; ;               If *row()\draw And 
; ; ;                  *this\mode\check And 
; ; ;                   *row()\box[1]\state
; ; ;                 If *row()\parent And *this\mode\check = 4
; ; ;                   draw_option_button(*row()\box[1], 4, $FFFFFFFF)
; ; ;                 Else                                                                                                                ;If Not (*this\mode\buttons And *row()\childrens And *this\mode\check = 4)
; ; ;                   draw_check_button(*row()\box[1], 6, $FFFFFFFF)
; ; ;                 EndIf
; ; ;               EndIf    
; ; ;             Next
; ; ;             
; ; ;             DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
; ; ;             ; Draw frame (check&option)
; ; ;             ForEach *row()
; ; ;               If *row()\draw And 
; ; ;                  *this\mode\check
; ; ;                 If *row()\box[1]\state
; ; ;                   draw_box_button(*row()\box[1], $FFDC9338)
; ; ;                 Else
; ; ;                   draw_box_button(*row()\box[1], $80C8C8C8)
; ; ;                 EndIf
; ; ;               EndIf    
; ; ;             Next
; ; ;             
            
            ; Draw boxs (check&option)
            Protected _box_x_, _box_y_
            ForEach *row()
              If *row()\draw And 
                 *this\mode\check
                
                If *row()\parent And *this\mode\check = 4
                  draw_button(1, *row()\box[1]\x, *row()\box[1]\y, *row()\box[1]\width, *row()\box[1]\height, *row()\box[1]\state, 4);, \color)
                Else                                                                                                                ;If Not (*this\mode\buttons And *row()\childrens And *this\mode\check = 4)
                  draw_button(3, *row()\box[1]\x, *row()\box[1]\y, *row()\box[1]\width, *row()\box[1]\height, *row()\box[1]\state, 2);, \color)
                EndIf
              EndIf    
            Next
            
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            
            ; Draw buttons (expanded&collapsed)
            ForEach *row()
              If *row()\draw And *this\mode\buttons And 
                 *row()\childrens And Not (*row()\sublevel And *this\mode\check = 4)
                
                Arrow(*row()\box[0]\x + (*row()\box[0]\width - 6)/2,
                      *row()\box[0]\y + (*row()\box[0]\height - 6)/2, 
                      6, Bool(Not *row()\box[0]\state) + 2,
                      *row()\color\front[0], 0,0)   ; *row()\color\state
              EndIf    
            Next
          EndIf
          
          ; 
          PopListPosition(*row()) ; 
          
          
          ; Draw frames
          If *this\fs
            DrawingMode(#PB_2DDrawing_Outlined)
            RoundBox(*this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame],*this\round,*this\round,*this\color\frame[Bool(*this\color\state) * 2])
          EndIf
          
          ; Draw scroll bars
          Area_Draw(*this)
        EndIf
      EndWith
      
    EndProcedure
    
    
    Procedure.l Tree_SetItemState(*this._s_widget, Item.l, State.b)
      Protected result.l, collapsed.b, sublevel.l, *SelectElement
      
      If Item < 0 : Item = 0 : EndIf
      If Item > *this\count\items - 1 
        Item = *this\count\items - 1 
      EndIf
      
      *SelectElement = SelectElement(*this\row\_s(), Item) 
      
      If *SelectElement 
        If State & #__tree_Selected
          If *this\row\selected And *this\mode\check = 4 ;& #__flag_multiselect
            *this\row\selected\color\state = #__s_0
          EndIf
          *this\row\_s()\color\state = #__s_3
          *this\row\selected = *this\row\_s()
        EndIf
        
        If State & #__tree_inbetween = #__tree_inbetween
          *this\row\_s()\box[1]\state = #PB_Checkbox_Inbetween
          
        ElseIf State & #__tree_checked = #__tree_checked
          *this\row\_s()\box[1]\state = #PB_Checkbox_Checked
        EndIf
        
        If State & #__tree_collapsed
          collapsed = 1
        EndIf
        
        If collapsed Or State & #__tree_Expanded
          *this\row\_s()\box[0]\state = collapsed
          
          sublevel = *this\row\_s()\sublevel
          
          PushListPosition(*this\row\_s())
          While NextElement(*this\row\_s())
            If *this\row\_s()\sublevel = sublevel
              Break
            ElseIf *this\row\_s()\sublevel > sublevel 
              *this\row\_s()\hide = collapsed
              ;*this\row\_s()\hide = Bool(*this\row\_s()\parent\box[0]\state | *this\row\_s()\parent\hide)
              
            EndIf
          Wend
          PushListPosition(*this\row\_s())
        EndIf
        
        result = *SelectElement
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i Tree_AddItem(*this._s_widget, position.l, Text.s, Image.i = -1, sublevel.i = 0)
      Protected handle, *parent._s_rows
      
      ;With *this
      If *this
        If sublevel =- 1
          If *this\mode\check <> 4 And 
             *this\_flag & #__tree_optionboxes = 0
            *this\_flag | #__tree_optionboxes
            *this\mode\check = 4
          EndIf
        EndIf
        
        ;{ Генерируем идентификатор
        If position < 0 Or position > ListSize(*this\row\_s()) - 1
          If LastElement(*this\row\_s())
            If *this\mode\check = 4
              If sublevel <> 0 And *this\row\_s()\parent
                If sublevel > 0 And *this\row\_s()\sublevel
                  sublevel = *this\row\_s()\sublevel
                EndIf
                *parent = *this\row\_s()\parent
              Else
                *parent = *this\row\_s()
              EndIf
            EndIf
          EndIf
          
          handle = AddElement(*this\row\_s()) 
          If position < 0 
            position = ListIndex(*this\row\_s())
          EndIf
        Else
          handle = SelectElement(*this\row\_s(), position)
          
          If sublevel < *this\row\_s()\sublevel
            sublevel = *this\row\_s()\sublevel 
          EndIf
          
          If *this\mode\check = 4
            If sublevel <> 0 And *this\row\_s()\parent
              If sublevel > 0 And *this\row\_s()\sublevel
                sublevel = *this\row\_s()\sublevel
              EndIf
              *parent = *this\row\_s()\parent
            Else
              *parent = *this\row\_s()
            EndIf
          EndIf
          
          handle = InsertElement(*this\row\_s())
        EndIf
        ;}
        
        If handle
          ;*this\row\i(Hex(position)) = ListIndex(*this\row\_s())
          
          ;             If Not \row\_s()
          ;               \row\_s() = AllocateStructure(_s_rows)
          ;             EndIf
          If Not ListIndex(*this\row\_s()) Or Not position
            *this\row\first = *this\row\_s()
          EndIf
          
          If *this\mode\check = 4
            If sublevel <> 0
              If *parent
                *this\row\_s()\parent = *parent
                ; if not the parent option add the childrens
                If *this\row\_s()\parent\parent <> *this\row\_s()\parent 
                  *this\row\_s()\parent\childrens + 1
                EndIf
                
                If sublevel > 0
                  *this\row\_s()\sublevel = Bool(*this\mode\buttons) * sublevel ;+ 
                EndIf
              Else
                ; if first item option
                *this\row\_s()\parent = *this\row\_s()
              EndIf
              
              sublevel = 0
            EndIf
            
            ; set option group
            If *this\row\_s()\parent
              *this\row\_s()\option_group = *this\row\_s()\parent
            EndIf
          EndIf
          
          If sublevel
            If sublevel > position
              sublevel = position
            EndIf
            
            PushListPosition(*this\row\_s())
            While PreviousElement(*this\row\_s()) 
              If sublevel = *this\row\_s()\sublevel
                *parent = *this\row\_s()\parent
                Break
              ElseIf sublevel > *this\row\_s()\sublevel
                *parent = *this\row\_s()
                Break
              EndIf
            Wend 
            PopListPosition(*this\row\_s())
            
            If *parent
              If sublevel > *parent\sublevel
                sublevel = *parent\sublevel + 1
                *parent\childrens + 1
              EndIf
              
              *this\row\_s()\parent = *parent
            EndIf
            
            *this\row\_s()\sublevel = sublevel
          EndIf
          
          If *this\mode\collapse And *this\row\_s()\parent And 
             *this\row\_s()\sublevel > *this\row\_s()\parent\sublevel
            *this\row\_s()\parent\box[0]\state = 1 
            *this\row\_s()\hide = 1
          EndIf
          
          ; properties
          If *this\_Flag & #__tree_property
            If *parent And Not *parent\sublevel And Not *parent\text\fontID
              *parent\color\back = $FFF9F9F9
              *parent\color\back[1] = *parent\color\back
              *parent\color\back[2] = *parent\color\back
              *parent\color\frame = *parent\color\back
              *parent\color\frame[1] = *parent\color\back
              *parent\color\frame[2] = *parent\color\back
              *parent\color\front[1] = *parent\color\front
              *parent\color\front[2] = *parent\color\front
              *parent\text\fontID = FontID(LoadFont(#PB_Any, "Helvetica", 14, #PB_Font_Bold|#PB_Font_Italic))
            EndIf
          EndIf
          
          ; add lines
          *this\row\_s()\index = ListIndex(*this\row\_s())
          *this\row\_s()\color = _get_colors_()
          *this\row\_s()\color\state = 0
          *this\row\_s()\color\back = 0 
          *this\row\_s()\color\frame = 0
          
          *this\row\_s()\color\fore[0] = 0 
          *this\row\_s()\color\fore[1] = 0
          *this\row\_s()\color\fore[2] = 0
          *this\row\_s()\color\fore[3] = 0
          
          If Text
            *this\row\_s()\text\change = 1
            *this\row\_s()\text\string = StringField(Text.s, 1, #LF$)
            *this\row\_s()\text\edit\string = StringField(Text.s, 2, #LF$)
          EndIf
          
          _set_image_(*this, *this\row\_s()\Image, Image)
          
          If *this\row\selected 
            *this\row\scrolled = 0
            *this\row\selected\color\state = 0
            *this\row\selected = *this\row\_s() 
            *this\row\selected\color\state = 2 + Bool(GetActive()\gadget <> *this)
          EndIf
          
          _repaint_items_(*this)
          
          *this\count\items + 1
          *this\change = 1
        EndIf
      EndIf
      ;EndWith
      
      ProcedureReturn *this\count\items - 1
    EndProcedure
    
    
    Procedure.l Tree_Events_Key(*this._s_widget, eventtype.l, mouse_x.l = -1, mouse_y.l = -1)
      Protected result, from =- 1
      Static cursor_change, Down, *row_selected._s_rows
      
      With *this
        Select eventtype 
          Case #__Event_KeyDown
            ;If *this = GetActive()\gadget
            
            Select Keyboard()\key
              Case #PB_Shortcut_PageUp
                If bar_SetState(*this\scroll\v, 0) 
                  *this\change = 1 
                  result = 1
                EndIf
                
              Case #PB_Shortcut_PageDown
                If bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\end) 
                  *this\change = 1 
                  result = 1
                EndIf
                
              Case #PB_Shortcut_Up,
                   #PB_Shortcut_Home
                If *this\row\selected
                  If (Keyboard()\key[1] & #PB_Canvas_Alt) And
                     (Keyboard()\key[1] & #PB_Canvas_Control)
                    If bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\pos - 18) 
                      *this\change = 1 
                      result = 1
                    EndIf
                    
                  ElseIf *this\row\selected\index > 0
                    ; select modifiers key
                    If (Keyboard()\key = #PB_Shortcut_Home Or
                        (Keyboard()\key[1] & #PB_Canvas_Alt))
                      SelectElement(*this\row\_s(), 0)
                    Else
                      SelectElement(*this\row\_s(), *this\row\selected\index - 1)
                      
                      If *this\row\_s()\hide
                        While PreviousElement(*this\row\_s())
                          If Not *this\row\_s()\hide
                            Break
                          EndIf
                        Wend
                      EndIf
                    EndIf
                    
                    If *this\row\selected <> *this\row\_s()
                      *this\row\selected\color\state = 0
                      *this\row\selected  = *this\row\_s()
                      *this\row\_s()\color\state = 2
                      *row_selected = *this\row\_s()
                      
                      *this\change = _tree_bar_update_(*this\scroll\v, *this\row\selected\y, *this\row\selected\height)
                      Post(#__Event_change, *this, *this\row\_s()\index)
                      result = 1
                    EndIf
                    
                    
                  EndIf
                EndIf
                
              Case #PB_Shortcut_Down,
                   #PB_Shortcut_End
                If *this\row\selected
                  If (Keyboard()\key[1] & #PB_Canvas_Alt) And
                     (Keyboard()\key[1] & #PB_Canvas_Control)
                    
                    If bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\pos + 18) 
                      *this\change = 1 
                      result = 1
                    EndIf
                    
                  ElseIf *this\row\selected\index < (*this\count\items - 1)
                    ; select modifiers key
                    If (Keyboard()\key = #PB_Shortcut_End Or
                        (Keyboard()\key[1] & #PB_Canvas_Alt))
                      SelectElement(*this\row\_s(), (*this\count\items - 1))
                    Else
                      SelectElement(*this\row\_s(), *this\row\selected\index + 1)
                      
                      If *this\row\_s()\hide
                        While NextElement(*this\row\_s())
                          If Not *this\row\_s()\hide
                            Break
                          EndIf
                        Wend
                      EndIf
                    EndIf
                    
                    If *this\row\selected <> *this\row\_s()
                      *this\row\selected\color\state = 0
                      *this\row\selected  = *this\row\_s()
                      *this\row\_s()\color\state = 2
                      *row_selected = *this\row\_s()
                      
                      *this\change = _tree_bar_update_(*this\scroll\v, *this\row\selected\y, *this\row\selected\height)
                      Post(#__Event_change, *this, *this\row\_s()\index)
                      result = 1
                    EndIf
                    
                    
                  EndIf
                EndIf
                
              Case #PB_Shortcut_Left
                If (Keyboard()\key[1] & #PB_Canvas_Alt) And
                   (Keyboard()\key[1] & #PB_Canvas_Control)
                  
                  *this\change = bar_SetState(*this\scroll\h, *this\scroll\h\bar\page\pos - (*this\scroll\h\bar\page\end/10)) 
                  result = 1
                EndIf
                
              Case #PB_Shortcut_Right
                If (Keyboard()\key[1] & #PB_Canvas_Alt) And
                   (Keyboard()\key[1] & #PB_Canvas_Control)
                  
                  *this\change = bar_SetState(*this\scroll\h, *this\scroll\h\bar\page\pos + (*this\scroll\h\bar\page\end/10)) 
                  result = 1
                EndIf
                
            EndSelect
            
            ;EndIf
            
        EndSelect
      EndWith
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l Tree_Events(*this._s_widget, eventtype.l, mouse_x.l = -1, mouse_y.l = -1)
      Protected Repaint
      
      If eventtype = #__Event_leftButtonUp
        ; collapsed button up
        If *this\row\box\state = 2
          *this\row\box\state =- 1
          Post(#PB_EventType_Up, *this, This()\item)
          Repaint | #True
        Else
          If *this\row\selected ;And *this\row\selected\index = This()\item
                                ; Debug "" + *this\row\selected\index  + " " +  This()\item
            If Not *this\mode\check
              If *this\row\selected\_state & #__s_selected = #False
                *this\row\selected\_state | #__s_selected
                Post(#PB_EventType_Change, *this, *this\row\selected\index)
                
                If *this\_state & #__s_entered = #False
                  Post(#PB_EventType_LeftClick, *this, This()\item)
                EndIf
              EndIf
            EndIf
          EndIf
          
          Repaint | #True
        EndIf
      EndIf
      
      If eventtype = #__Event_leftClick
        If *this\row\box\state =- 1
          *this\row\box\state = 0
        Else
          Post(#PB_EventType_LeftClick, *this, This()\item)
          Repaint | #True
        EndIf
      EndIf
      
      If eventtype = #__Event_rightButtonUp
        Post(#PB_EventType_RightClick, *this, This()\item)
        Repaint | #True
      EndIf
      
      If eventtype = #__Event_leftDoubleClick
        Post(#PB_EventType_LeftDoubleClick, *this, This()\item)
        Repaint | #True
      EndIf
      
      If eventtype = #__Event_Focus
        If *this\count\items
          PushListPosition(*this\row\_s()) 
          ForEach *this\row\_s()
            If *this\row\_s()\color\state = #__s_3
              *this\row\_s()\color\state = #__s_2
              *this\row\_s()\_state | #__s_selected
            EndIf
          Next
          PopListPosition(*this\row\_s()) 
        EndIf
        
        ; Post(#PB_EventType_Focus, *this, This()\item)
        Repaint | #True
      EndIf
      
      If eventtype = #__Event_lostfocus
        If *this\count\items
          PushListPosition(*this\row\_s()) 
          ForEach *this\row\_s()
            If *this\row\_s()\color\state = #__s_2
              *this\row\_s()\color\state = #__s_3
              *this\row\_s()\_state &~ #__s_selected
            EndIf
          Next
          PopListPosition(*this\row\_s()) 
        EndIf
        
        ; Post(#PB_EventType_lostFocus, *this, This()\item)
        Repaint | #True
      EndIf
      
      If eventtype = #__Event_MouseEnter Or
         eventtype = #__Event_MouseMove Or
         eventtype = #__Event_MouseLeave Or
         eventtype = #__Event_rightButtonDown Or
         eventtype = #__Event_leftButtonDown ;Or eventtype = #__Event_leftButtonUp
        
        If *this\count\items
          ForEach *this\row\draws()
            ; If *this\row\draws()\draw
            If _from_point_(mouse_x, mouse_y, *this, [#__c_inner]) And 
               _from_point_(mouse_x + *this\scroll\h\bar\page\pos,
                            mouse_y + *this\scroll\v\bar\page\pos, *this\row\draws())
              
              ; 
              If Not *this\row\draws()\_state & #__s_entered
                *this\row\draws()\_state | #__s_entered 
                *this\row\entered = *this\row\draws()
                
                If *this\row\draws()\color\state = #__s_0
                  *this\row\draws()\color\state = #__s_1
                  Repaint | #True
                EndIf
                
                If Not (Mouse()\buttons And *this\mode\check)
                  Post(#PB_EventType_StatusChange, *this, *this\row\draws()\index)
                  Repaint | #True
                EndIf
              EndIf
              
              If (eventtype = #__Event_leftButtonDown) Or 
                 (Mouse()\buttons And Not *this\mode\check)
                
                ; collapsed/expanded button
                If eventtype = #__Event_leftButtonDown And 
                   (*this\mode\buttons And *this\row\draws()\childrens) And 
                   _from_point_(mouse_x, mouse_y, *this\row\draws()\box[0])
                  
                  If SelectElement(*this\row\_s(), *this\row\draws()\index) 
                    *this\row\_s()\box[0]\state ! 1
                    *this\row\box\state = 2
                    ; Post(#PB_EventType_Down, *this, *this\row\_s()\index)
                    
                    PushListPosition(*this\row\_s())
                    While NextElement(*this\row\_s())
                      If *this\row\_s()\parent And *this\row\_s()\sublevel > *this\row\_s()\parent\sublevel 
                        *this\row\_s()\hide = Bool(*this\row\_s()\parent\box[0]\state | *this\row\_s()\parent\hide)
                      Else
                        Break
                      EndIf
                    Wend
                    PopListPosition(*this\row\_s())
                    
                    *this\change = 1
                    If *this\root
                      ReDraw(*this)
                    EndIf
                  EndIf
                  
                Else
                  ; change box (option&check)
                  If _from_point_(mouse_x, mouse_y, *this\row\draws()\box[1])
                    *this\row\box\state = 1
                    ; change box option
                    If *this\mode\check = 4 And *this\row\draws()\parent
                      If *this\row\draws()\option_group  
                        If *this\row\draws()\option_group\parent And 
                           *this\row\draws()\option_group\box[1]\state 
                          *this\row\draws()\option_group\box[1]\state = #PB_Checkbox_Unchecked
                        EndIf
                        
                        If *this\row\draws()\option_group\option_group <> *this\row\draws()
                          If *this\row\draws()\option_group\option_group
                            *this\row\draws()\option_group\option_group\box[1]\state = #PB_Checkbox_Unchecked
                          EndIf
                          *this\row\draws()\option_group\option_group = *this\row\draws()
                        EndIf
                      EndIf
                    EndIf
                    
                    ; change box check
                    change_checkbox_state(*this\row\draws()\box[1], *this\mode\threestate)
                  EndIf
                  
                  If *this\mode\check = 2
                    If *this\row\draws()\_state & #__s_selected 
                      *this\row\draws()\_state &~ #__s_selected
                      *this\row\draws()\color\state = #__s_0
                    Else
                      *this\row\draws()\_state | #__s_selected
                      *this\row\draws()\color\state = #__s_2
                    EndIf
                    
                    Post(#PB_EventType_Change, *this, *this\row\draws()\index)
                    
                  Else
                    If *this\row\selected And *this\row\selected <> *this\row\draws()
                      ;If *this\row\selected <> *this\row\draws()
                      If *this\mode\check = 3
                        If *this\row\selected\_state & #__s_selected
                          *this\row\selected\_state &~ #__s_selected
                          Post(#PB_EventType_Change, *this, *this\row\selected\index)
                        EndIf
                      EndIf
                      
                      *this\row\selected\_state &~ #__s_selected
                      ;EndIf
                      
                      *this\row\selected\color\state = #__s_0
                    EndIf
                    
                    If *this\mode\check = 3
                      If *this\row\draws()\_state & #__s_selected = 0
                        *this\row\draws()\_state | #__s_selected
                        Post(#PB_EventType_Change, *this, *this\row\draws()\index)
                      EndIf
                    EndIf
                    
                    *this\row\draws()\color\state = #__s_2
                  EndIf
                  
                  *this\row\selected = *this\row\draws()
                EndIf
                
                
                
                
                
                ; *this\change = _tree_bar_update_(*this\scroll\v, *this\row\selected\y, *this\row\selected\height)
                Repaint | #True
              EndIf
              
              If *this\mode\check = 3 And
                 Mouse()\buttons
                Protected _index_, _selected_index_
                
                _index_ = *this\row\draws()\index
                _selected_index_ = *this\row\selected\index
                
                PushListPosition(*this\row\_s()) 
                ForEach *this\row\_s()
                  If *this\row\_s()\draw
                    If Bool((_selected_index_ >= *this\row\_s()\index And _index_ <= *this\row\_s()\index) Or ; верх
                            (_selected_index_ <= *this\row\_s()\index And _index_ >= *this\row\_s()\index))   ; вниз
                      
                      If *this\row\_s()\color\state <> #__s_2
                        *this\row\_s()\color\state = #__s_2
                        
                        Post(#PB_EventType_Change, *this, *this\row\_s()\index)
                        Repaint | #True
                      EndIf
                      
                    ElseIf *this\row\_s()\color\state <> #__s_0
                      *this\row\_s()\color\state = #__s_0
                      
                      Post(#PB_EventType_Change, *this, *this\row\_s()\index)
                      Repaint | #True
                    EndIf
                  EndIf
                Next
                PopListPosition(*this\row\_s()) 
              EndIf
              
            ElseIf *this\row\draws()\_state & #__s_entered
              *this\row\draws()\_state &~ #__s_entered 
              
              
              If *this\row\draws()\color\state = #__s_1
                *this\row\draws()\color\state = #__s_0
              EndIf
              
              ; TODO должен отправлять если покинули все итеми
              If Not _from_point_(mouse_x - *this\x[#__c_frame], mouse_y - *this\y[#__c_frame], *this, [#__c_required])
                If *this\row\selected
                  Post(#PB_EventType_StatusChange, *this, *this\row\selected\index)
                Else
                  Post(#PB_EventType_StatusChange, *this, - 1)
                EndIf
              EndIf
              Repaint | #True
            EndIf
            ; EndIf
          Next
          
        EndIf
      EndIf
      
      ; key events
      If eventtype = #__Event_Input Or
         eventtype = #__Event_KeyDown Or
         eventtype = #__Event_KeyUp
        
        Repaint | Tree_Events_Key(*this, eventtype, mouse_x, mouse_y)
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    ;- 
    Macro _multi_select_items_(_this_)
      PushListPosition(*this\row\_s()) 
      ForEach *this\row\_s()
        If *this\row\_s()\draw
          If Bool((*this\row\entered\index >= *this\row\_s()\index And *this\row\selected\index <= *this\row\_s()\index) Or ; верх
                  (*this\row\selected\index >= *this\row\_s()\index And *this\row\entered\index <= *this\row\_s()\index))   ; вниз
            
            If *this\row\_s()\color\state <> #__s_2
              *this\row\_s()\color\state = #__s_2
              Repaint | #True
            EndIf
            
          Else
            
            If *this\row\_s()\color\state <> #__s_0
              *this\row\_s()\color\state = #__s_0
              
              ; example(sel 5;6;7, click 5, no post change)
              If *this\row\_s()\_state & #__s_selected
                *this\row\_s()\_state &~ #__s_selected
              EndIf
              
              Repaint | #True
            EndIf
            
          EndIf
        EndIf
      Next
      PopListPosition(*this\row\_s()) 
    EndMacro
    
    
    Procedure.l ListView_Events(*this._s_widget, eventtype.l, mouse_x.l = -1, mouse_y.l = -1)
      Protected Repaint
      
      If eventtype = #__event_dragstart
        Post(#PB_EventType_DragStart, *this, This()\item)
        Repaint | #True
      EndIf
      
      If eventtype = #__Event_Focus
        PushListPosition(*this\row\_s()) 
        ForEach *this\row\_s()
          If *this\row\_s()\color\state = #__s_3
            *this\row\_s()\color\state = #__s_2
            *this\row\_s()\_state | #__s_selected
          EndIf
        Next
        PopListPosition(*this\row\_s()) 
        
        ; Post(#PB_EventType_Focus, *this, This()\item)
        Repaint | #True
      EndIf
      
      If eventtype = #__Event_lostfocus
        PushListPosition(*this\row\_s()) 
        ForEach *this\row\_s()
          If *this\row\_s()\color\state = #__s_2
            *this\row\_s()\color\state = #__s_3
            *this\row\_s()\_state &~ #__s_selected
          EndIf
        Next
        PopListPosition(*this\row\_s()) 
        
        ; Post(#PB_EventType_lostFocus, *this, This()\item)
        Repaint | #True
      EndIf
      
      If eventtype = #__Event_leftButtonUp
        If *this\row\selected 
          If *this\mode\check = 3
            *this\row\entered = *this\row\selected
          EndIf
          
          If *this\mode\check <> 2 
            If *this\row\selected\_state & #__s_selected = #False
              *this\row\selected\_state | #__s_selected
              Post(#PB_EventType_Change, *this, *this\row\selected\index)
              Repaint | #True
            EndIf
          EndIf
        EndIf
      EndIf
      
      If eventtype = #__Event_leftClick
        Post(#PB_EventType_LeftClick, *this, *this\row\entered\index)
        Repaint | #True
      EndIf
      
      If eventtype = #__Event_leftDoubleClick
        Post(#PB_EventType_LeftDoubleClick, *this, *this\row\entered\index)
        Repaint | #True
      EndIf
      
      If eventtype = #__Event_rightClick
        Post(#PB_EventType_RightClick, *this, *this\row\entered\index)
        Repaint | #True
      EndIf
      
      
      If eventtype = #__Event_MouseEnter Or
         eventtype = #__Event_MouseMove Or
         eventtype = #__Event_MouseLeave Or
         eventtype = #__Event_rightButtonDown Or
         eventtype = #__Event_leftButtonDown ;Or eventtype = #__Event_leftButtonUp
        
        If *this\count\items
          ForEach *this\row\draws()
            ; If *this\row\draws()\draw
            If _from_point_(mouse_x, mouse_y, *this, [#__c_inner]) And 
               _from_point_(mouse_x + *this\scroll\h\bar\page\pos,
                            mouse_y + *this\scroll\v\bar\page\pos, *this\row\draws())
              
              ;  
              If Not *this\row\draws()\_state & #__s_entered 
                *this\row\draws()\_state | #__s_entered 
                
                ; 
                If Not Mouse()\buttons
                  *this\row\entered = *this\row\draws()
                EndIf
                
                If *this\row\draws()\color\state = #__s_0
                  *this\row\draws()\color\state = #__s_1
                  Repaint | #True
                EndIf
                
                ;
                If Not (Mouse()\buttons And *this\mode\check)
                  Post(#PB_EventType_StatusChange, *this, *this\row\draws()\index)
                  Repaint | #True
                EndIf
              EndIf
              
              If Mouse()\buttons
                If *this\mode\check
                  *this\row\selected = *this\row\draws()
                  
                  ; clickselect items
                  If *this\mode\check = 2
                    If eventtype = #__Event_leftButtonDown
                      If *this\row\draws()\_state & #__s_selected 
                        *this\row\draws()\_state &~ #__s_selected
                        *this\row\draws()\color\state = #__s_1
                      Else
                        *this\row\draws()\_state | #__s_selected
                        *this\row\draws()\color\state = #__s_2
                      EndIf
                      
                      Post(#PB_EventType_Change, *this, *this\row\draws()\index)
                      Repaint | #True
                    EndIf
                  EndIf
                  
                  If *this\row\selected
                    PushListPosition(*this\row\_s()) 
                    ForEach *this\row\_s()
                      If *this\row\_s()\draw
                        If Bool((*this\row\entered\index >= *this\row\_s()\index And *this\row\selected\index <= *this\row\_s()\index) Or ; верх
                                (*this\row\entered\index <= *this\row\_s()\index And *this\row\selected\index >= *this\row\_s()\index))   ; вниз
                          
                          If *this\mode\check = 2
                            If *this\row\entered\_state & #__s_selected
                              If *this\row\_s()\color\state <> #__s_2
                                *this\row\_s()\color\state = #__s_2
                                
                                If *this\row\_s()\_state & #__s_selected = #False
                                  ; entered to no selected
                                  Post(#PB_EventType_Change, *this, *this\row\_s()\index)
                                EndIf
                                
                                Repaint | #True
                              EndIf
                              
                            ElseIf *this\row\_s()\_state & #__s_entered
                              If *this\row\_s()\color\state <> #__s_1
                                *this\row\_s()\color\state = #__s_1
                                
                                If *this\row\_s()\_state & #__s_selected
                                  If *this\row\entered\_state & #__s_selected = #False
                                    ; entered to selected
                                    Post(#PB_EventType_Change, *this, *this\row\_s()\index)
                                  EndIf
                                EndIf
                                
                                Repaint | #True
                              EndIf
                            EndIf
                          EndIf
                          
                          ; multiselect items
                          If *this\mode\check = 3
                            If *this\row\_s()\color\state <> #__s_2
                              *this\row\_s()\color\state = #__s_2
                              Repaint | #True
                              
                              ; reset select before this 
                              ; example(sel 5;6;7, click 7, reset 5;6)
                            ElseIf eventtype = #__Event_leftButtonDown
                              If *this\row\selected <> *this\row\_s()
                                *this\row\_s()\color\state = #__s_0
                                Repaint | #True
                              EndIf
                            EndIf
                          EndIf
                          
                        Else
                          
                          If *this\mode\check = 2
                            If *this\row\_s()\_state & #__s_selected 
                              If *this\row\_s()\color\state <> #__s_2
                                *this\row\_s()\color\state = #__s_2
                                
                                If *this\row\entered\_state & #__s_selected = #False
                                  ; leaved from selected
                                  Post(#PB_EventType_Change, *this, *this\row\_s()\index)
                                EndIf
                                
                                Repaint | #True
                              EndIf
                              
                            ElseIf *this\row\_s()\_state & #__s_entered = #False
                              If *this\row\_s()\color\state <> #__s_0
                                *this\row\_s()\color\state = #__s_0
                                
                                If *this\row\entered\_state & #__s_selected
                                  If *this\row\_s()\_state & #__s_selected = #False
                                    ; leaved from no selected
                                    Post(#PB_EventType_Change, *this, *this\row\_s()\index)
                                  EndIf
                                EndIf
                                
                                Repaint | #True
                              EndIf
                            EndIf
                          EndIf
                          
                          If *this\mode\check = 3
                            If *this\row\_s()\color\state <> #__s_0
                              *this\row\_s()\color\state = #__s_0
                              
                              ; example(sel 5;6;7, click 5, no post change)
                              If *this\row\_s()\_state & #__s_selected
                                *this\row\_s()\_state &~ #__s_selected
                              EndIf
                              
                              Repaint | #True
                            EndIf
                          EndIf
                          
                        EndIf
                      EndIf
                    Next
                    PopListPosition(*this\row\_s()) 
                  EndIf
                Else
                  If *this\row\selected And
                     *this\row\selected <> *this\row\draws()
                    *this\row\selected\_state &~ #__s_selected
                    *this\row\selected\color\state = #__s_0
                  EndIf
                  
                  *this\row\draws()\color\state = #__s_2
                  *this\row\selected = *this\row\draws()
                  ; *this\change = _tree_bar_update_(*this\scroll\v, *this\row\selected\y, *this\row\selected\height)
                  Repaint | #True
                EndIf
              EndIf
              
            ElseIf *this\row\draws()\_state & #__s_entered
              *this\row\draws()\_state &~ #__s_entered 
              
              
              If *this\row\draws()\color\state = #__s_1
                *this\row\draws()\color\state = #__s_0
              EndIf
              
              ;
              If Mouse()\buttons And *this\mode\check
                If *this\mode\check = 3
                  If *this\row\draws()\_state & #__s_selected = #False
                    *this\row\draws()\_state | #__s_selected
                  EndIf
                  
                  Post(#PB_EventType_Change, *this, *this\row\draws()\index)
                EndIf
              EndIf
              
              Repaint | #True
            EndIf
            ; EndIf
          Next
          
        EndIf
      EndIf
      
      If eventtype = #__Event_KeyDown 
        Protected result, from =- 1
        Static cursor_change, Down
        
        If GetActive() And GetActive()\gadget = *this
          
          
          
          Select Keyboard()\key
            Case #PB_Shortcut_PageUp
              ; TODO scroll to first visible
              If bar_SetState(*this\scroll\v, 0) 
                *this\change = 1 
                Repaint = 1
              EndIf
              
            Case #PB_Shortcut_PageDown
              ; TODO scroll to last visible
              If bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\end) 
                *this\change = 1 
                Repaint = 1
              EndIf
              
            Case #PB_Shortcut_Up,
                 #PB_Shortcut_Home
              If *this\row\selected
                If (Keyboard()\key[1] & #PB_Canvas_Alt) And
                   (Keyboard()\key[1] & #PB_Canvas_Control)
                  
                  ; scroll to top
                  If bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\pos - 18) 
                    *this\change = 1 
                    Repaint = 1
                  EndIf
                  
                ElseIf *this\row\selected\index > 0
                  ; select modifiers key
                  If (Keyboard()\key = #PB_Shortcut_Home Or
                      (Keyboard()\key[1] & #PB_Canvas_Alt))
                    SelectElement(*this\row\_s(), 0)
                  Else
                    SelectElement(*this\row\_s(), *this\row\selected\index - 1)
                    
                    If *this\row\_s()\hide
                      While PreviousElement(*this\row\_s())
                        If Not *this\row\_s()\hide
                          Break
                        EndIf
                      Wend
                    EndIf
                  EndIf
                  
                  If *this\row\selected <> *this\row\_s()
                    If *this\row\selected 
                      *this\row\selected\_state &~ #__s_selected
                      *this\row\selected\color\state = #__s_0
                    EndIf
                    *this\row\selected  = *this\row\_s()
                    *this\row\_s()\color\state = #__s_2
                    
                    
                    
                    If Not Keyboard()\key[1] & #PB_Canvas_Shift
                      *this\row\entered = *this\row\selected
                    EndIf
                    
                    If *this\mode\check = 3
                      _multi_select_items_(*this)
                    EndIf
                    
                    
                    *this\change = _tree_bar_update_(*this\scroll\v, *this\row\selected\y, *this\row\selected\height)
                    Post(#__Event_change, *this, *this\row\_s()\index)
                    Repaint = 1
                  EndIf
                  
                  
                EndIf
              EndIf
              
            Case #PB_Shortcut_Down,
                 #PB_Shortcut_End
              If *this\row\selected
                If (Keyboard()\key[1] & #PB_Canvas_Alt) And
                   (Keyboard()\key[1] & #PB_Canvas_Control)
                  
                  If bar_SetState(*this\scroll\v, *this\scroll\v\bar\page\pos + 18) 
                    *this\change = 1 
                    Repaint = 1
                  EndIf
                  
                ElseIf *this\row\selected\index < (*this\count\items - 1)
                  ; select modifiers key
                  If (Keyboard()\key = #PB_Shortcut_End Or
                      (Keyboard()\key[1] & #PB_Canvas_Alt))
                    SelectElement(*this\row\_s(), (*this\count\items - 1))
                    
                  Else
                    SelectElement(*this\row\_s(), *this\row\selected\index + 1)
                    
                    If *this\row\_s()\hide
                      While NextElement(*this\row\_s())
                        If Not *this\row\_s()\hide
                          Break
                        EndIf
                      Wend
                    EndIf
                  EndIf
                  
                  If *this\row\selected <> *this\row\_s()
                    If *this\row\selected 
                      *this\row\selected\_state &~ #__s_selected
                      *this\row\selected\color\state = #__s_0
                    EndIf
                    *this\row\selected  = *this\row\_s()
                    *this\row\_s()\color\state = #__s_2
                    
                    
                    If Not Keyboard()\key[1] & #PB_Canvas_Shift
                      *this\row\entered = *this\row\selected
                    EndIf
                    
                    If *this\mode\check = 3
                      _multi_select_items_(*this)
                    EndIf
                    
                    
                    *this\change = _tree_bar_update_(*this\scroll\v, *this\row\selected\y, *this\row\selected\height)
                    Post(#__Event_change, *this, *this\row\_s()\index)
                    Repaint = 1
                  EndIf
                  
                  
                EndIf
              EndIf
              
            Case #PB_Shortcut_Left
              If (Keyboard()\key[1] & #PB_Canvas_Alt) And
                 (Keyboard()\key[1] & #PB_Canvas_Control)
                
                *this\change = bar_SetState(*this\scroll\h, *this\scroll\h\bar\page\pos - (*this\scroll\h\bar\page\end/10)) 
                Repaint = 1
              EndIf
              
            Case #PB_Shortcut_Right
              If (Keyboard()\key[1] & #PB_Canvas_Alt) And
                 (Keyboard()\key[1] & #PB_Canvas_Control)
                
                *this\change = bar_SetState(*this\scroll\h, *this\scroll\h\bar\page\pos + (*this\scroll\h\bar\page\end/10)) 
                Repaint = 1
              EndIf
              
          EndSelect
          
          
          
        EndIf
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    ;- 
    ;-  WINDOW - e
    Procedure   Window_Draw(*this._s_widget)
      With *this 
        If \fs
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          Protected i = 1
          
          If \fs = 1 
            For i = 1 To \round
              Line(\x[#__c_frame] + i - 1,\y[#__c_frame] + \caption\height - 1,1,Bool(\round)*(i - \round),\caption\color\back[\color\state])
              Line(\x[#__c_frame] + \width[#__c_frame] + i - \round - 1,\y[#__c_frame] + \caption\height - 1,1, - Bool(\round)*(i),\caption\color\back[\color\state])
            Next
          Else
            For i = 1 To \fs
              RoundBox(\x[#__c_frame] + i - 1, \y[#__c_inner] - \fs + i - 1, \width[#__c_frame] - i*2 + 2, Bool(\height[#__c_frame] - \__height>0)*(\height[#__c_frame] - \__height) - i*2 + 2,Bool(Not \__height)*\round,Bool(Not \__height)*\round, \caption\color\back[\color\state])
              RoundBox(\x[#__c_frame] + i - 1, \y[#__c_inner] - \fs + i, \width[#__c_frame] - i*2 + 2, Bool(\height[#__c_frame] - \__height>0)*(\height[#__c_frame] - \__height) - i*2,Bool(Not \__height)*\round,Bool(Not \__height)*\round, \caption\color\back[\color\state])
            Next
          EndIf
        EndIf 
        
        ; Draw back
        If \color\back[\interact * \color\state]
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          ;  RoundBox(\x[#__c_inner] - Bool(\fs),\y[#__c_inner] - Bool(\fs),\width[#__c_inner] + Bool(\fs),Bool(\height[#__c_frame] - \__height - \fs*2 + Bool(\fs)*2>0) * (\height[#__c_frame] - \__height - \fs*2 + Bool(\fs)),Bool(Not \__height)*\round,Bool(Not \__height)*\round,\color\back[\interact * \color\state])
          RoundBox(\x[#__c_inner],\y[#__c_inner],\width[#__c_inner],\height[#__c_inner], Bool(Not \__height)*\round,Bool(Not \__height)*\round,\color\back[\interact * \color\state])
          ;  RoundBox(\x[#__c_inner] - 1,\y[#__c_inner] - 1,\width[#__c_inner] + 2,\height[#__c_inner] + 2, Bool(Not \__height)*\round,Bool(Not \__height)*\round,\color\back[\interact * \color\state])
        EndIf
        
        ; Draw background image
        If *this\image\id
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(*this\image\id, *this\x[#__c_inner]+*this\image\x, *this\y[#__c_inner]+*this\image\y, *this\color\alpha)
        EndIf
        
        ; frame draw
        If \fs
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          If \fs = 1 
            RoundBox(\x[#__c_frame], \y[#__c_frame] + \__height, \width[#__c_frame], Bool(\height[#__c_frame] - \__height>0) * (\height[#__c_frame] - \__height),
                     Bool(Not \__height)*\round, Bool(Not \__height)*\round, \color\frame[\color\state])
          Else
            ; draw out frame
            RoundBox(\x[#__c_frame], \y[#__c_frame] + \__height, \width[#__c_frame], Bool(\height[#__c_frame] - \__height>0) * (\height[#__c_frame] - \__height),
                     Bool(Not \__height)*\round, Bool(Not \__height)*\round, \color\frame[\color\state])
            
            ; draw inner frame 
            If \type = #__type_ScrollArea ; \scroll And \scroll\v And \scroll\h
              RoundBox(\x[#__c_inner] - 1, \y[#__c_inner] - 1, Bool(\width[#__c_frame] - \fs*2> - 2)*(\width[#__c_frame] - \fs*2 + 2), 
                       Bool(\height[#__c_frame] - \fs*2 - \__height> - 2)*(\height[#__c_frame] - \fs*2 - \__height + 2),
                       Bool(Not \__height)*\round, Bool(Not \__height)*\round, \scroll\v\color\line)
            Else
              RoundBox(\x[#__c_inner] - 1, \y[#__c_inner] - 1, Bool(\width[#__c_frame] - \fs*2> - 2)*(\width[#__c_frame] - \fs*2 + 2), 
                       Bool(\height[#__c_frame] - \fs*2 - \__height> - 2)*(\height[#__c_frame] - \fs*2 - \__height + 2),
                       Bool(Not \__height)*\round, Bool(Not \__height)*\round, \color\frame[\color\state])
            EndIf
          EndIf
        EndIf
        
        
        If \__height
          ; Draw caption back
          If \caption\color\back 
            DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            _box_gradient_( 0, \caption\x, \caption\y, \caption\width, \caption\height - 1, \caption\color\fore[\color\state], \caption\color\back[\color\state], \round, \caption\color\alpha)
          EndIf
          
          ; Draw caption frame
          If \fs
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\caption\x, \caption\y, \caption\width, \caption\height - 1,\round,\round,\color\frame[\color\state])
            
            ; erase the bottom edge of the frame
            DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            BackColor(\caption\color\fore[\color\state])
            FrontColor(\caption\color\back[\color\state])
            
            ;Protected i
            For i = \round/2 + 2 To \caption\height - 2
              Line(\x[#__c_frame],\y[#__c_frame] + i,\width[#__c_frame],1, \caption\color\back[\color\state])
            Next
            
            ; two edges of the frame
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            Line(\x[#__c_frame],\y[#__c_frame] + \round/2 + 2,1,\caption\height - \round/2,\color\frame[\color\state])
            Line(\x[#__c_frame] + \width[#__c_frame] - 1,\y[#__c_frame] + \round/2 + 2,1,\caption\height - \round/2,\color\frame[\color\state])
          EndIf
          
          ;         ; Draw image
          ;         If \caption\image\id
          ;           DrawingMode(#PB_2DDrawing_transparent|#PB_2DDrawing_AlphaBlend)
          ;           DrawAlphaImage(\caption\image\id, \caption\image\x, \caption\image\y, \caption\color\alpha)
          ;         EndIf
          
          If \caption\text\string
            ;ClipOutput(\caption\x[#__c_clip], \caption\y[#__c_clip], \caption\width[#__c_clip], \caption\height[#__c_clip])
            ClipOutput(\caption\x[#__c_inner], \caption\y[#__c_inner], \caption\width[#__c_inner], \caption\height[#__c_inner])
            ;           DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            ;           RoundBox(\caption\x[#__c_inner], \caption\y[#__c_inner], \caption\width[#__c_inner], \caption\height[#__c_inner], \round, \round, $FF000000)
            ; Draw string
            If \resize & #__resize_change
              \caption\text\x = \caption\x[#__c_inner] + \caption\text\padding\x
              \caption\text\y = \caption\y[#__c_inner] + (\caption\height[#__c_inner] - TextHeight("A"))/2
            EndIf
            
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawText(\caption\text\x, \caption\text\y, \caption\text\string, \color\front[\color\state]&$FFFFFF|\color\alpha<<24)
          EndIf
          
          ClipOutput(\x[#__c_clip],\y[#__c_clip],\width[#__c_clip],\height[#__c_clip])
          
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          ; close button
          draw_box_button(\caption\button[0], \caption\button[0]\color\back[\caption\button[0]\color\state]&$FFFFFF|\caption\button[0]\color\alpha<<24)
          
          ; maximize button
          draw_box_button(\caption\button[1], \caption\button[1]\color\back[\caption\button[1]\color\state]&$FFFFFF|\caption\button[1]\color\alpha<<24)
          
          ; minimize button
          draw_box_button(\caption\button[2], \caption\button[2]\color\back[\caption\button[2]\color\state]&$FFFFFF|\caption\button[2]\color\alpha<<24)
          
          ; help button
          draw_box_button(\caption\button[3], \caption\button[3]\color\back[\caption\button[3]\color\state]&$FFFFFF|\caption\button[3]\color\alpha<<24)
          
          
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          ; close button
          draw_close_button(\caption\button[0], 6)
          
          ; maximize button
          draw_maximize_button(\caption\button[1], 4)
          
          ; minimize button
          draw_minize_button(\caption\button[2], 4)
          
          ; help button
          draw_help_button(\caption\button[3], 4)
        EndIf
        
      EndWith
    EndProcedure
    
    Procedure   Window_Update(*this._s_widget)
      If *this\type = #__type_window
        ; caption title bar
        If Not *this\caption\hide
          *this\caption\x = *this\x[#__c_frame]
          *this\caption\y = *this\y[#__c_frame]
          *this\caption\width = *this\width[#__c_frame]
          *this\caption\height = *this\__height + *this\fs ; *this\height[#__c_frame] - *this\height[#__c_inner] - *this\fs ; 
          
          ; 
          *this\caption\x[#__c_inner] = *this\x[#__c_frame] + *this\fs
          *this\caption\y[#__c_inner] = *this\y[#__c_frame] + *this\fs
          *this\caption\height[#__c_inner] = *this\__height - *this\fs
          
          If *this\caption\height > *this\height[#__c_frame] - *this\fs ;*2
            *this\caption\height = *this\height[#__c_frame] - *this\fs  ;*2
          EndIf
          
          ; caption close button
          If Not *this\caption\button[0]\hide
            *this\caption\button[0]\x = (*this\x[#__c_inner] + *this\width[#__c_inner]) - (*this\caption\button[0]\width + *this\caption\_padding)
            *this\caption\button[0]\y = *this\y[#__c_frame] + (*this\caption\height - *this\caption\button[0]\height)/2
          EndIf
          
          ; caption maximize button
          If Not *this\caption\button[1]\hide
            If *this\caption\button[0]\hide
              *this\caption\button[1]\x = (*this\x[#__c_inner] + *this\width[#__c_inner]) - (*this\caption\button[1]\width + *this\caption\_padding)
            Else
              *this\caption\button[1]\x = *this\caption\button[0]\x - (*this\caption\button[1]\width + *this\caption\_padding)
            EndIf
            *this\caption\button[1]\y = *this\y[#__c_frame] + (*this\caption\height - *this\caption\button[1]\height)/2
          EndIf
          
          ; caption minimize button
          If Not *this\caption\button[2]\hide
            If *this\caption\button[1]\hide
              *this\caption\button[2]\x = *this\caption\button[0]\x - (*this\caption\button[2]\width + *this\caption\_padding)
            Else
              *this\caption\button[2]\x = *this\caption\button[1]\x - (*this\caption\button[2]\width + *this\caption\_padding)
            EndIf
            *this\caption\button[2]\y = *this\y[#__c_frame] + (*this\caption\height - *this\caption\button[2]\height)/2
          EndIf
          
          ; caption help button
          If Not *this\caption\button[3]\hide
            If Not *this\caption\button[2]\hide
              *this\caption\button[3]\x = *this\caption\button[2]\x - (*this\caption\button[3]\width + *this\caption\_padding)
            ElseIf Not *this\caption\button[1]\hide
              *this\caption\button[3]\x = *this\caption\button[1]\x - (*this\caption\button[3]\width + *this\caption\_padding)
            Else
              *this\caption\button[3]\x = *this\caption\button[0]\x - (*this\caption\button[3]\width + *this\caption\_padding)
            EndIf
            *this\caption\button[3]\y = *this\caption\button[0]\y
          EndIf
          
          ; title bar width
          If Not *this\caption\button[3]\hide
            *this\caption\width[#__c_inner] = *this\caption\button[3]\x - *this\x[#__c_inner] - *this\caption\_padding
          ElseIf Not *this\caption\button[2]\hide
            *this\caption\width[#__c_inner] = *this\caption\button[2]\x - *this\x[#__c_inner] - *this\caption\_padding
          ElseIf Not *this\caption\button[1]\hide
            *this\caption\width[#__c_inner] = *this\caption\button[1]\x - *this\x[#__c_inner] - *this\caption\_padding
          ElseIf Not *this\caption\button[0]\hide
            *this\caption\width[#__c_inner] = *this\caption\button[0]\x - *this\x[#__c_inner] - *this\caption\_padding
          Else
            *this\caption\width[#__c_inner] = *this\width[#__c_frame] - *this\fs*2
          EndIf
          
          ; clip text coordinate
          If *this\caption\x[#__c_inner] < *this\x[#__c_clip]
            *this\caption\x[#__c_clip] = *this\x[#__c_clip]
          Else
            *this\caption\x[#__c_clip] = *this\caption\x[#__c_inner]
          EndIf
          If *this\caption\y[#__c_inner] < *this\y[#__c_clip]
            *this\caption\y[#__c_clip] = *this\y[#__c_clip]
          Else
            *this\caption\y[#__c_clip] = *this\caption\y[#__c_inner]
          EndIf
          If *this\caption\x[#__c_inner] + *this\caption\width[#__c_inner] > *this\x[#__c_clip] + *this\width[#__c_inner]
            *this\caption\width[#__c_clip] = *this\width[#__c_clip]
          Else
            *this\caption\width[#__c_clip] = *this\caption\width[#__c_inner]
          EndIf
          If *this\caption\y[#__c_inner] + *this\caption\height[#__c_inner] > *this\y[#__c_clip] + *this\height[#__c_inner]
            *this\caption\height[#__c_clip] = *this\height[#__c_clip]
          Else
            *this\caption\height[#__c_clip] = *this\caption\height[#__c_inner]
          EndIf
          
        EndIf
      EndIf
    EndProcedure
    
    Procedure   Window_SetState(*this._s_widget, state.l)
      Protected.b result
      
      ; restore state
      If state = #__Window_Normal
        If Not Post(#__Event_restoreWindow, *this)
          If *this\resize & #__resize_minimize
            *this\resize &~ #__resize_minimize
            *this\caption\button[0]\hide = 0
            *this\caption\button[2]\hide = 0
          EndIf
          *this\resize &~ #__resize_maximize
          *this\resize | #__resize_restore
          
          Resize(*this, *this\root\x[#__c_draw], *this\root\y[#__c_draw], 
                 *this\root\width[#__c_draw], *this\root\height[#__c_draw])
          
          If _is_root_(*this)
            PostEvent(#PB_Event_RestoreWindow, *this\root\canvas\window, *this)
          EndIf
        EndIf
      EndIf
      
      ; maximize state
      If state = #__Window_Maximize
        If Not Post(#__Event_MaximizeWindow, *this)
          If Not *this\resize & #__resize_minimize
            *this\root\x[#__c_draw] = *this\x[#__c_draw]
            *this\root\y[#__c_draw] = *this\y[#__c_draw]
            *this\root\width[#__c_draw] = *this\width
            *this\root\height[#__c_draw] = *this\height
          EndIf
          
          *this\resize | #__resize_maximize
          Resize(*this, 0,0, *this\parent\width, *this\parent\height)
          
          If _is_root_(*this)
            PostEvent(#PB_Event_MaximizeWindow, *this\root\canvas\window, *this)
          EndIf
          
          result = #True
        EndIf
      EndIf
      
      ; minimize state
      If state = #__Window_Minimize
        If Not Post(#__Event_MinimizeWindow, *this)
          If Not *this\resize & #__resize_maximize
            *this\root\x[#__c_draw] = *this\x[#__c_draw]
            *this\root\y[#__c_draw] = *this\y[#__c_draw]
            *this\root\width[#__c_draw] = *this\width
            *this\root\height[#__c_draw] = *this\height
          EndIf
          
          *this\caption\button[0]\hide = 1
          If *this\caption\button[1]\hide = 0
            *this\caption\button[2]\hide = 1
          EndIf
          *this\resize | #__resize_minimize
          
          Resize(*this, *this\root\x[#__c_draw], *this\parent\height - *this\__height, *this\root\width[#__c_draw], *this\__height)
          
          If _is_root_(*this)
            PostEvent(#PB_Event_MinimizeWindow, *this\root\canvas\window, *this)
          EndIf
          
          result = #True
        EndIf
      EndIf
      
      ProcedureReturn result 
    EndProcedure
    
    Procedure   Window_close(*this._s_widget)
      Protected.b result
      
      ; close window
      If Not Post(#__Event_closeWindow, *this)
        Free(*this)
        
        If _is_root_(*this)
          PostEvent(#PB_Event_CloseWindow, *this\root\canvas\window, *this)
        EndIf
        
        result = #True
      EndIf
    EndProcedure
    
    Procedure   Window_Events(*this._s_widget, eventtype.l, mouse_x.l, mouse_y.l)
      Protected Repaint
      
      If eventtype = #__Event_focus
        *this\color\state = #__s_2
        Post(eventtype, *this)
        Repaint = #True
      EndIf
      
      If eventtype = #__Event_lostfocus
        *this\color\state = #__s_3
        Post(eventtype, *this)
        Repaint = #True
      EndIf
      
      If eventtype = #__Event_MouseEnter
        Repaint = #True
      EndIf
      
      If eventtype = #__Event_MouseLeave
        Repaint = #True
      EndIf
      
      If eventtype = #__Event_MouseMove
        If _is_selected_(*this)
          If *this = *this\root\canvas\container
            ResizeWindow(*this\root\canvas\window, (DesktopMouseX() - Mouse()\delta\x), (DesktopMouseY() - Mouse()\delta\y), #PB_Ignore, #PB_Ignore)
          Else
            Repaint = Resize(*this, (mouse_x - Mouse()\delta\x), (mouse_y - Mouse()\delta\y), #PB_Ignore, #PB_Ignore)
          EndIf
        EndIf
      EndIf
      
      If eventtype = #__Event_leftclick
        If *this\type = #__type_Window
          *this\caption\interact = _from_point_(mouse_x, mouse_y, *this\caption, [2])
          ;*this\color\state = 2
          
          ; close button
          If _from_point_(mouse_x, mouse_y, *this\caption\button[0])
            ProcedureReturn Window_close(*this)
          EndIf
          
          ; maximize button
          If _from_point_(mouse_x, mouse_y, *this\caption\button[1])
            If Not *this\resize & #__resize_maximize And
               Not *this\resize & #__resize_minimize
              
              ProcedureReturn Window_SetState(*this, #__window_maximize)
            Else
              ProcedureReturn Window_SetState(*this, #__window_normal)
            EndIf
          EndIf
          
          ; minimize button
          If _from_point_(mouse_x, mouse_y, *this\caption\button[2])
            If Not *this\resize & #__resize_minimize
              ProcedureReturn Window_SetState(*this, #__window_minimize)
            EndIf
          EndIf
        EndIf
        
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    
    ;- 
    ;-  DRAWINGs
    Procedure   Button_Draw(*this._s_widget)
      With *this
;         If *this\image\change <> 0
;           _set_align_x_(*this\image, *this\image, *this\width[#__c_inner], 0)
;           _set_align_y_(*this\image, *this\image, *this\height[#__c_inner], 270)
;           *this\image\change = 0
;         EndIf
        
        
        
        If *this\color\back <>- 1
          If \color\fore <>- 1
            DrawingMode(#PB_2DDrawing_Gradient)
            _box_gradient_(\vertical, \x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame],\color\Fore[\color\state],\color\Back[Bool(*this\_state&#__s_back)*\color\state], \round)
          Else
            DrawingMode(#PB_2DDrawing_Default)
            RoundBox(\x[#__c_frame],\y[#__c_frame],\width[#__c_frame],\height[#__c_frame], \round,\round, \color\Back[Bool(*this\_state&#__s_back)*\color\state])
          EndIf
        EndIf
        
        If \text\string.s
          If *this\change
            Editor_Update(*this, *this\row\_s())
            
            ; update element (option&checkbox)
            If *this\type = #__type_Option Or *this\type = #__type_checkbox
              *this\button\y = *this\y[#__c_inner] + (*this\height[#__c_inner] - *this\button\height)/2
              
              If *this\text\align\right
                *this\button\x = *this\x[#__c_inner] + (*this\width[#__c_inner] - *this\button\height - 3)
              ElseIf Not *this\text\align\left
                *this\button\x = *this\x[#__c_inner] + (*this\width[#__c_inner] - *this\button\width)/2
                
                If Not *this\text\align\top 
                  If *this\text\rotate = 0
                    *this\button\y = *this\y[#__c_inner] + *this\y[#__c_required] - *this\button\height
                  Else
                    *this\button\y = *this\y[#__c_inner] + *this\y[#__c_required] + *this\height[#__c_required]
                  EndIf
                EndIf
              Else
                *this\button\x = *this\x[#__c_inner] + 3
              EndIf
            EndIf
            
            
            *this\change = 0
          EndIf
          
          ; draw text
          DrawingMode(#PB_2DDrawing_Transparent)
          ForEach *this\row\_s()
            DrawRotatedText(*this\x[#__c_inner] + *this\x[#__c_required] + *this\row\_s()\text\x, *this\y[#__c_inner] + *this\y[#__c_required] + *this\row\_s()\text\y, *this\row\_s()\text\String.s, *this\text\rotate, *this\color\Front[Bool(*this\_state & #__s_front) * *this\color\state]);*this\row\_s()\color\font)
          Next 
        EndIf
        ;       
        
        
        
        
        If *this\image\change <> 0
          *this\image\padding\x = *this\text\padding\x 
          *this\image\padding\y = *this\text\padding\y
          
          ; make horizontal scroll max 
          If *this\width[#__c_required] < *this\image\width + *this\image\padding\x * 2
            *this\width[#__c_required] = *this\image\width + *this\image\padding\x * 2
          EndIf
          
          ; make vertical scroll max 
          If *this\height[#__c_required] < *this\image\height + *this\image\padding\y * 2
            *this\height[#__c_required] = *this\image\height + *this\image\padding\y * 2
          EndIf
          
          ; make horizontal scroll x
          make_scrollarea_x(*this, *this\image)
          
          ; make vertical scroll y
          make_scrollarea_y(*this, *this\image)
          
            
          _set_align_x_(*this\image, *this\image, *this\width[#__c_required], 0)
          _set_align_y_(*this\image, *this\image, *this\height[#__c_required], 270)
          *this\image\change = 0
        EndIf
        
        
        If #PB_GadgetType_Option = *this\type
          Protected _box_x_,_box_y_
          draw_button(1, *this\button\x,*this\button\y,*this\button\width,*this\button\height, *this\button\state, *this\button\round);, \color)
        EndIf 
        
        If #PB_GadgetType_CheckBox = *this\type
          draw_button(3, *this\button\x,*this\button\y,*this\button\width,*this\button\height, *this\button\state, *this\button\round);, \color)
        EndIf
        
; ;         If #PB_GadgetType_Option = *this\type Or
; ;            #PB_GadgetType_CheckBox = *this\type
; ;           
; ;           DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
; ;           
; ; ;           DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
; ; ;           LinearGradient(*this\button\x,
; ; ;                          *this\button\y,
; ; ;                          *this\button\x, 
; ; ;                          (*this\button\y + *this\button\height))
; ;           ; Draw boxs (check&option)      
; ;           If *this\button\state
; ; ;             BackColor($FFE9BA81&$FFFFFF|255<<24)
; ; ;             FrontColor($FFE89C3D&$FFFFFF|255<<24)
; ;             draw_box_button(*this\button, $FFE89C3D)
; ;           Else
; ; ;             BackColor($FFFeFeFe&$FFFFFF|255<<24)
; ; ;             FrontColor($80E2E2E2&$FFFFFF|255<<24)
; ;             draw_box_button(*this\button, $ffffffff)
; ;           EndIf
; ;           
; ;           If *this\button\state
; ;             DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
; ;             If #PB_GadgetType_Option = *this\type
; ;               draw_option_button(*this\button, 4, $FFFFFFFF)
; ;             Else                                                                                                                ;If Not (*this\mode\buttons And *row()\childrens And *this\mode\check = 4)
; ;               If *this\button\state =- 1
; ;                 ;draw_option_button(*this\button, 4, $FFFFFFFF)
; ;                 RoundBox(*this\button\x+4,
; ;                          *this\button\y+4,
; ;                          *this\button\width-8,
; ;                          *this\button\height-8, 1,1, $FFFFFFFF)
; ;               Else
; ;                 draw_check_button(*this\button, 6, $FFFFFFFF)
; ;               EndIf
; ;             EndIf
; ;           EndIf
; ;           
; ;           DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
; ;           ; Draw frame (check&option)
; ;           If *this\button\state
; ;             draw_box_button(*this\button, $FFDC9338)
; ;           Else
; ;             draw_box_button(*this\button, $80C8C8C8)
; ;           EndIf
; ;         EndIf
          
            
        ;;  ClipOutput(*this\x[#__c_clip], *this\y[#__c_clip], *this\width[#__c_clip], *this\height[#__c_clip])
        
        ; Draw background image
        If \image\id
          ;ClipOutput( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner])
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(\image\id,
                         *this\x[#__c_inner] + *this\x[#__c_required] + \image\x,
                         *this\y[#__c_inner] + *this\y[#__c_required] + \image\y, 
                         \color\alpha)
          ;ClipOutput( *this\x[#__c_clip], *this\y[#__c_clip], *this\width[#__c_clip], *this\height[#__c_clip])
        EndIf
        
        ; draw frame
        If *this\fs
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(*this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame], *this\round,*this\round, *this\color\Frame[Bool(*this\_state & #__s_frame)**this\color\state])
        EndIf
        
        If *this\_flag & #__button_default
          DrawingMode(#PB_2DDrawing_Outlined)
          
          ;RoundBox(*this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame], *this\round,*this\round, *this\color\Frame[2])
          
          RoundBox(\X[#__c_inner]+2-1,\Y[#__c_inner]+2-1,\Width[#__c_inner]-4+2,\Height[#__c_inner]-4+2,\round,\round,*this\color\Frame[1])
          If \round : RoundBox(\X[#__c_inner]+2,\Y[#__c_inner]+2-1,\Width[#__c_inner]-4,\Height[#__c_inner]-4+2,\round,\round,*this\color\Frame[1]) : EndIf
          RoundBox(\X[#__c_inner]+2,\Y[#__c_inner]+2,\Width[#__c_inner]-4,\Height[#__c_inner]-4,\round,\round,*this\color\Frame[1])
        EndIf
        
        ; Draw scroll bars
        Area_Draw(*this)
        
        
      EndWith
    EndProcedure
    
    Procedure.i Panel_Draw(*this._s_widget)
      If *this\gadget[#__panel_1]\count\items
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Box(*this\x[#__c_inner] - 1, *this\y[#__c_inner] - 1, *this\width[#__c_inner] + 2, *this\height[#__c_inner] + 2, *this\color\back[0])
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        Box(*this\x[#__c_inner] - 1, *this\y[#__c_inner] - 1, *this\width[#__c_inner] + 2, *this\height[#__c_inner] + 2, *this\color\frame[Bool(*this\gadget[#__panel_1]\index[#__s_2]  <>-1)*2 ])
        
        Tab_Draw(*this\gadget[#__panel_1]) 
      Else
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Box(*this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], *this\color\back[0])
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        Box(*this\x[#__c_frame], *this\y[#__c_frame], *this\width[#__c_frame], *this\height[#__c_frame], *this\color\frame[Bool(*this\index[#__panel_2] <>- 1)*2 ])
      EndIf
    EndProcedure
    
    Procedure   ScrollArea_Draw(*this._s_widget)
      With *this
        If *this\image\change <> 0
          _set_align_x_(*this\image, *this\image, *this\width[#__c_inner], 0)
          _set_align_y_(*this\image, *this\image, *this\height[#__c_inner], 270)
          *this\image\change = 0
        EndIf
        
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(*this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame], *this\round, *this\round, *this\color\back[*this\color\state])
        
        ;         DrawingMode(#PB_2DDrawing_transparent)
        ;         DrawText(*this\x[#__c_frame] + 20,*this\y[#__c_frame], Str(\index) + "_" + Str(\level), $ff000000)
        
        ; Draw background image
        If \image\id
          ;ClipOutput( *this\x[#__c_inner], *this\y[#__c_inner], *this\width[#__c_inner], *this\height[#__c_inner])
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
          DrawAlphaImage(\image\id,
                         *this\x[#__c_inner] + *this\x[#__c_required] + \image\x,
                         *this\y[#__c_inner] + *this\y[#__c_required] + \image\y, 
                         \color\alpha)
          ;ClipOutput( *this\x[#__c_clip], *this\y[#__c_clip], *this\width[#__c_clip], *this\height[#__c_clip])
        EndIf
        
        If \scroll 
          If \scroll\v And \scroll\v\type And Not \scroll\v\hide : Scroll_Draw(\scroll\v) : EndIf
          If \scroll\h And \scroll\h\type And Not \scroll\h\hide : Scroll_Draw(\scroll\h) : EndIf
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(*this\x[#__c_frame],*this\y[#__c_frame],*this\width[#__c_frame],*this\height[#__c_frame], *this\round, *this\round, *this\color\frame[*this\color\state])
      EndWith
    EndProcedure
    
    
    ;- 
    Procedure.i GetItem(*this, parent_sublevel.l =- 1)
      Protected result
      Protected *row._s_rows
      Protected *widget._s_widget
      
      If *this 
        If parent_sublevel =- 1
          *widget = *this
          result = *widget\_item
          
        Else
          *row = *this
          
          While *row And *row <> *row\parent
            
            If parent_sublevel = *row\parent\sublevel
              result = *row
              Break
            EndIf
            
            *row = *row\parent
          Wend
          
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   Flag(*this._s_widget, flag.i=#Null, state.b =- 1)
      Protected result
      
      If Not flag
        result = *this\_flag
        ;       If *this\type = #PB_GadgetType_Button
        ;         ;         If *this\text\align\left
        ;         ;           result | #__button_left
        ;         ;         EndIf
        ;         ;         If *this\text\align\right
        ;         ;           result | #__button_right
        ;         ;         EndIf
        ;         ;         If *this\text\multiline
        ;         ;           result | #__button_multiline
        ;         ;         EndIf
        ;         ;         If *this\_flag & #__button_toggle
        ;         ;           result | #__button_toggle
        ;         ;         EndIf
        ;       EndIf
      Else
        If state =- 1
          result = Bool(*this\_flag & flag)
        Else
          If state 
            *this\_flag | flag
          Else
            *this\_flag &~ flag
          EndIf
          
          ; commons
          If Flag & #__flag_vertical
            *this\vertical = state
            *this\text\change = #True
          EndIf
          
          If flag & #__text_invert
            *this\text\invert = state 
            *this\text\change = #True
          EndIf
          
          If *this\text\change
            If *this\text\invert 
              If *this\vertical
                *this\text\rotate = 270 
              Else
                *this\text\rotate = 180
              EndIf
            Else
              *this\text\rotate = Bool(*this\vertical) * 90
            EndIf
          EndIf
          
          If flag & #__text_top
            *this\text\change = #__text_update
            *this\text\align\bottom = 0
            *this\text\align\top = state
          EndIf
          If flag & #__text_bottom
            *this\text\change = #__text_update
            *this\text\align\top = 0
            *this\text\align\bottom = state
            
            *this\image\change = #__text_update
            *this\image\align\top = 0
            *this\image\align\bottom = state
          EndIf
          If flag & #__text_left
            *this\text\change = #__text_update
            *this\text\align\right = 0
            *this\text\align\left = state
          EndIf
          If flag & #__text_right
            *this\text\change = #__text_update
            *this\text\align\left = 0
            *this\text\align\right = state
            
            *this\image\change = #__text_update
            *this\image\align\left = 0
            *this\image\align\right = state
          EndIf
          
          If flag & #__text_multiline
            *this\text\change = #__text_update
            *this\text\multiline = state
          EndIf
          
          If flag & #__text_wordwrap
            *this\text\change = #__text_update
            *this\text\multiline =- state
          EndIf
          
          If *this\type = #PB_GadgetType_Button
            If flag & #__button_default
              ; *this\text\align\left = state
            EndIf
            ;             If flag & #__button_left
            ;               *this\text\align\right = 0
            ;               *this\text\align\left = state
            ;             EndIf
            ;             If flag & #__button_right
            ;               *this\text\align\left = 0
            ;               *this\text\align\right = state
            ;             EndIf
            ;             If flag & #__button_multiline
            ;               *this\text\change = #__text_update
            ;               *this\text\multiline = state
            ;             EndIf
            If flag & #__button_toggle
              If state 
                *this\_state | #__s_toggled
                *this\color\state = #__s_2
              Else
                *this\_state &~ #__s_toggled
                *this\color\state = #__s_0
              EndIf
            EndIf
            
            *this\change = 1
          EndIf
          
          If *this\type = #PB_GadgetType_Tree Or
             *this\type = #PB_GadgetType_ListView Or
             *this\type = #__type_property
            
            If flag & #__tree_nolines
              *this\mode\lines = Bool(state) * #__tree_linesize
            EndIf
            If flag & #__tree_nobuttons
              *this\mode\buttons = state
              
              If *this\count\items
                If *this\_flag & #__tree_optionboxes
                  PushListPosition(*this\row\_s())
                  ForEach *this\row\_s()
                    If *this\row\_s()\parent And 
                       *this\row\_s()\parent\childrens
                      *this\row\_s()\sublevel = state
                    EndIf
                  Next
                  PopListPosition(*this\row\_s())
                EndIf
              EndIf
            EndIf
            If flag & #__tree_checkboxes
              If *this\_flag & #__tree_optionboxes
                *this\mode\check = Bool(state) * 4
              Else
                *this\mode\check = Bool(state)
              EndIf
            EndIf
            If flag & #__tree_threestate
              If *this\_flag & #__tree_checkboxes
                *this\mode\threestate = state
              Else
                *this\mode\threestate = 0
              EndIf
            EndIf
            If flag & #__tree_clickselect
              *this\mode\check = Bool(state) * 2
            EndIf
            If flag & #__tree_multiselect
              *this\mode\check = Bool(state) * 3
            EndIf
            If flag & #__tree_optionboxes
              If state 
                *this\mode\check = 4
              Else
                *this\mode\check = Bool(*this\_flag & #__tree_checkboxes)
              EndIf
              
              ; set option group
              If *this\count\items
                PushListPosition(*this\row\_s())
                ForEach *this\row\_s()
                  If *this\row\_s()\parent
                    *this\row\_s()\box[1]\state = #PB_Checkbox_Unchecked
                    *this\row\_s()\option_group = Bool(state) * GetItem(*this\row\_s(), 0) 
                  EndIf
                Next
                PopListPosition(*this\row\_s())
              EndIf
            EndIf
            If flag & #__tree_gridlines
              *this\mode\gridlines = state
            EndIf
            If flag & #__tree_collapse ; d
              *this\mode\collapse = state
              
              If *this\count\items
                PushListPosition(*this\row\_s())
                ForEach *this\row\_s()
                  If *this\row\_s()\parent 
                    *this\row\_s()\parent\box[0]\state = state
                    *this\row\_s()\hide = state
                  EndIf
                Next
                PopListPosition(*this\row\_s())
              EndIf
              
              If *this\root
                ReDraw(*this)
              EndIf
            EndIf
            
            
            If (*this\mode\lines Or *this\mode\buttons Or *this\mode\check) And
               Not (*this\_flag & #__tree_property Or *this\_flag & #__tree_optionboxes)
              *this\row\sublevellen = 18 
            Else
              *this\row\sublevellen = 0
            EndIf
            
            If *this\count\items
              *this\change = 1
            EndIf
          EndIf
          
          If flag & #__text_center
            *this\text\align\left = 0
            *this\text\align\top = 0
            *this\text\align\right = 0
            *this\text\align\bottom = 0
            
            ;           Else
            ;             If Not *this\text\align\bottom
            ;               *this\text\align\top = #True
            ;             EndIf
            ;             
            ;             If Not *this\text\align\right
            ;               *this\text\align\left = #True 
            ;             EndIf
          EndIf
          
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b Disable(*this._s_widget, State.b =- 1)
      If State =- 1
        ProcedureReturn Bool(*this\color\state = #__s_3)
      Else
        *this\color\state = #__s_3
        ; *this\_state = #__s_disabled
      EndIf
    EndProcedure
    
    Procedure.b Hide(*this._s_widget, State.b =- 1)
      With *this
        If State =- 1
          ProcedureReturn *this\hide 
        Else
          *this\hide = State
          *this\hide[1] = *this\hide
          
          If *this\count\childrens
            ForEach widget()
              If Child(widget(), *this)
                widget()\hide = Bool(widget()\hide[1] Or
                                     widget()\parent\hide Or 
                                     (widget()\parent\type = #PB_GadgetType_Panel And
                                      widget()\parent\index[#__panel_2] <> widget()\_item))
                
              EndIf
            Next
          EndIf
        EndIf
      EndWith
    EndProcedure
    
    Procedure   Child(*this._s_widget, *parent._s_widget)
      Protected result
      
      ;If *this And *parent
      If *this\parent = *parent
        result = *this
      Else
        While *this <> *this\root ; Not _is_root_(*this)
          If *parent = *this\parent
            result = *this
            Break
          EndIf
          
          *this = *this\parent
        Wend
      EndIf
      ;EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   Clip(*this._s_widget, childrens.b)
      ; Debug  *this\adress
      
      ; then move and size parent set clip (width&height)
      Protected _p_x2_ = *this\parent\x[#__c_inner] + *this\parent\width[#__c_inner]
      Protected _p_y2_ = *this\parent\y[#__c_inner] + *this\parent\height[#__c_inner]
      Protected _p_x4_ = *this\parent\x[#__c_clip] + *this\parent\width[#__c_clip]
      Protected _p_y4_ = *this\parent\y[#__c_clip] + *this\parent\height[#__c_clip]
      Protected _t_x2_ = *this\x + *this\width
      Protected _t_y2_ = *this\y + *this\height
      
      If *this\type = #__type_tabbar And 
         *this\parent\gadget[#__panel_1] And *this\parent\gadget[#__panel_1] = *this
        _p_x2_ = *this\parent\x[#__c_frame] + *this\parent\width[#__c_frame]
        _p_y2_ = *this\parent\y[#__c_frame] + *this\parent\height[#__c_frame]
      EndIf
      
      If *this\type = #__type_scrollbar And 
         *this\parent\scroll And (*this\parent\scroll\v = *this Or *this = *this\parent\scroll\h)
        _p_x2_ = *this\parent\x[#__c_inner] + *this\parent\width[#__c_draw]
        _p_y2_ = *this\parent\y[#__c_inner] + *this\parent\height[#__c_draw]
      EndIf
      
      If *this\parent And _p_x4_ > 0 And _p_x4_ < _t_x2_ And _p_x2_ > _p_x4_ 
        *this\width[#__c_clip] = _p_x4_ - *this\x[#__c_clip]
      ElseIf *this\parent And _p_x2_ > 0 And _p_x2_ < _t_x2_
        *this\width[#__c_clip] = _p_x2_ - *this\x[#__c_clip]
      Else
        *this\width[#__c_clip] = _t_x2_ - *this\x[#__c_clip]
      EndIf
      
      If *this\parent And _p_y4_ > 0 And _p_y4_ < _t_y2_ And _p_y2_ > _p_y4_ 
        *this\height[#__c_clip] = _p_y4_ - *this\y[#__c_clip]
      ElseIf *this\parent And _p_y2_ > 0 And _p_y2_ < _t_y2_
        *this\height[#__c_clip] = _p_y2_ - *this\y[#__c_clip]
      Else
        *this\height[#__c_clip] = _t_y2_ - *this\y[#__c_clip]
      EndIf
      
      If *this\width[#__c_clip] < 0
        *this\width[#__c_clip] = 0
      EndIf
      
      If *this\height[#__c_clip] < 0
        *this\height[#__c_clip] = 0
      EndIf
      
      If (*this\width[#__c_clip] Or 
          *this\height[#__c_clip])
        *this\draw = #True
      Else
        *this\draw = #False
      EndIf
      
      ; clip child tab bar
      If *this\type = #__type_panel And *this\gadget[#__panel_1]
        Clip(*this\gadget[#__panel_1], 0)
      EndIf
      
      ; clip child scroll bars 
      If *this\scroll And 
         *this\scroll\v And
         *this\scroll\h
        Clip(*this\scroll\v, 0)
        Clip(*this\scroll\h, 0)
      EndIf
      
      If childrens And *this\container And *this\count\childrens
        PushListPosition(widget())
        ForEach widget()
          If widget()\parent = *this
            Clip(widget(), childrens)
          EndIf
        Next
        PopListPosition(widget())
      EndIf
    EndProcedure
    
    Procedure.b Update(*this._s_widget)
      Protected result.b, _scroll_pos_.f
      
      ; update draw coordinate
      If *this\type = #__type_Panel
        result = Bar_Update(*this\gadget[#__panel_1])
      EndIf  
      
      If *this\type = #__type_Window
        result = Window_Update(*this)
      EndIf
      
      ; ;       If *this\type = #__type_tree
      ; ;         If StartDrawing(CanvasOutput(*this\root\canvas\gadget))
      ; ;           Tree_Update(*this, *this\row\_s())
      ; ;           StopDrawing()
      ; ;         EndIf
      ; ;         
      ; ;         result = 1
      ; ;       EndIf
      
      If *this\type = #PB_GadgetType_ScrollBar Or
         *this\type = #PB_GadgetType_tabBar Or
         *this\type = #PB_GadgetType_ProgressBar Or
         *this\type = #PB_GadgetType_TrackBar Or
         *this\type = #PB_GadgetType_Splitter Or
         *this\type = #PB_GadgetType_Spin
        
        result = Bar_Update(*this)
      Else
        result = Bool(*this\resize & #__resize_change)
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b Change(*this._s_widget, ScrollPos.f)
      Select *this\type
        Case #__type_tabBar,
             #PB_GadgetType_Spin,
             #PB_GadgetType_Splitter,
             #PB_GadgetType_TrackBar,
             #PB_GadgetType_ScrollBar,
             #PB_GadgetType_ProgressBar
          
          ProcedureReturn Bar_Change(*this, ScrollPos)
      EndSelect
    EndProcedure
    
    Procedure.b Resize(*this._s_widget, x.l,y.l,width.l,height.l)
      Protected.b result
      Protected.l Change_x, Change_y, Change_width, Change_height
      
      With *this
        ; #__flag_autoSize
        If *this\parent And 
           *this\align And *this\align\autosize And
           *this\parent\type <> #__type_Splitter And
           *this\align\left And *this\align\top And 
           *this\align\right And *this\align\bottom
          X = 0; \align\delta\x
          Y = 0; \align\delta\y
          Width = *this\parent\width[#__c_inner] ; - \align\delta\x
          Height = *this\parent\height[#__c_inner] ; - \align\delta\y
        EndIf
        
        ; 
        ; If \bs < \fs : \bs = \fs : EndIf
        
        If X<>#PB_Ignore 
          If *this\parent 
            If Not *this\child
              x - *this\parent\x[#__c_required] 
            EndIf
            
            If *this\x[#__c_draw] <> x
              *this\x[#__c_draw] = x
              *this\x[#__c_container] = *this\x[#__c_draw] ; - *this\parent\x[#__c_required]
            EndIf
            
            X + *this\parent\x[#__c_inner]
          EndIf 
          
          If *this\x[#__c_frame] <> X; + *this\bs - *this\fs  
            Change_x = x - *this\x[#__c_frame] 
            *this\x[#__c_frame] = X 
            *this\x = *this\x[#__c_frame] - (*this\bs - *this\fs) 
            *this\x[#__c_inner] = *this\x + *this\bs + *this\__width 
            *this\x[#__c_window] = *this\x[#__c_frame] - *this\window\x[#__c_inner]
            
            If *this\parent And 
               *this\parent\x[#__c_inner] > *this\x And 
               *this\parent\x[#__c_inner] > *this\parent\x[#__c_clip]
              *this\x[#__c_clip] = *this\parent\x[#__c_inner]
            ElseIf *this\parent And *this\parent\x[#__c_clip] > *this\x 
              *this\x[#__c_clip] = *this\parent\x[#__c_clip]
            Else
              *this\x[#__c_clip] = *this\x
            EndIf
            
            *this\resize | #__resize_x | #__resize_change
          EndIf 
        EndIf  
        
        If Y<>#PB_Ignore 
          If *this\parent 
            If Not *this\child
              y - *this\parent\y[#__c_required] 
            EndIf
            
            If *this\y[#__c_draw] <> y
              *this\y[#__c_draw] = y
              *this\y[#__c_container] = *this\y[#__c_draw]
            EndIf
            
            y + *this\parent\y[#__c_inner]
          EndIf 
          
          If *this\y[#__c_frame] <> y 
            Change_y = y - *this\y[#__c_frame] 
            *this\y[#__c_frame] = y 
            *this\y = *this\y[#__c_frame] - (*this\bs - *this\fs)
            *this\y[#__c_inner] = *this\y + *this\bs + *this\__height
            *this\y[#__c_window] = *this\y[#__c_frame] - *this\window\y[#__c_inner]
            
            If *this\parent And *this\parent\y[#__c_inner] > *this\y And 
               *this\parent\y[#__c_inner] > *this\parent\y[#__c_clip]
              *this\y[#__c_clip] = *this\parent\y[#__c_inner]
            ElseIf \parent And *this\parent\y[#__c_clip] > *this\y 
              *this\y[#__c_clip] = *this\parent\y[#__c_clip]
            Else
              *this\y[#__c_clip] = *this\y
            EndIf
            
            *this\resize | #__resize_y | #__resize_change
          EndIf 
        EndIf  
        
        If width <> #PB_Ignore 
          If width < 0 : width = 0 : EndIf
          
          If \width[#__c_frame] <> width 
            Change_width = width - \width[#__c_frame] 
            \width[#__c_frame] = width 
            \width = \width[#__c_frame] + (\bs*2 - \fs*2)
            \width[#__c_draw] = \width - \bs*2 - \__width 
            ;If \width[#__c_frame] < 0 : \width[#__c_frame] = 0 : EndIf
            If \width[#__c_draw] < 0 : \width[#__c_draw] = 0 : EndIf
            \resize | #__resize_width | #__resize_change
            
            If *this\type = #__type_image Or
               *this\type = #__type_buttonimage
              *this\image\change = 1
            EndIf
            
            If *this\type = #__type_tabbar
              If *this\vertical
                ; to fix the width of the vertical tabbar items
                *this\bar\change | #__resize_width
              EndIf
            EndIf
            
            If *this\count\items
              *this\change | #__resize_width
            EndIf
          EndIf 
        EndIf  
        
        If Height <> #PB_Ignore 
          If Height < 0 : Height = 0 : EndIf
          
          If \height[#__c_frame] <> Height 
            Change_height = height - \height[#__c_frame] 
            \height[#__c_frame] = Height 
            \height = \height[#__c_frame] + (\bs*2 - \fs*2)
            \height[#__c_draw] = \height - \bs*2 - \__height
            If \height[#__c_frame] < 0 : \height[#__c_frame] = 0 : EndIf
            If \height[#__c_draw] < 0 : \height[#__c_draw] = 0 : EndIf
            \resize | #__resize_height | #__resize_change
            
            If *this\type = #__type_image Or
               *this\type = #__type_buttonimage
              *this\image\change = 1
            EndIf
            
            If *this\type = #__type_tabbar
              If Not *this\vertical
                ; to fix the height of the horizontal tabbar items
                *this\bar\change | #__resize_height
              EndIf
            EndIf
            
            If *this\count\items ;And \height[#__c_required] > \height[#__c_draw]
              *this\change | #__resize_height
            EndIf
          EndIf 
        EndIf 
        
        
        If *this\resize & #__resize_change
          ; then move and size parent set clip (width&height)
          If *this\parent And *this\parent <> *this
            Clip(*this, #False)
          Else
            *this\x[#__c_clip] = *this\x
            *this\y[#__c_clip] = *this\y
            *this\width[#__c_clip] = *this\width
            *this\height[#__c_clip] = *this\height
          EndIf
          
          ; 
          *this\width[#__c_inner] = *this\width[#__c_draw]
          *this\height[#__c_inner] = *this\height[#__c_draw]
          
          ; resize vertical&horizontal scrollbars
          If (*this\scroll And *this\scroll\v And *this\scroll\h)
            If (Change_x Or Change_y)
              Resize(*this\scroll\v, *this\scroll\v\x[#__c_draw], *this\scroll\v\y[#__c_draw], #__scroll_buttonsize, #PB_Ignore)
              Resize(*this\scroll\h, *this\scroll\h\x[#__c_draw], *this\scroll\h\y[#__c_draw], #PB_Ignore, #__scroll_buttonsize)
            EndIf
            
            If (Change_width Or Change_height)
              Bar_Resizes(*this, 0, 0, *this\width[#__c_draw], *this\height[#__c_draw])
            EndIf
            
            *this\width[#__c_inner] = *this\scroll\h\bar\page\len ; *this\width[#__c_draw] - Bool(Not *this\scroll\v\hide) * *this\scroll\v\width ; 
            *this\height[#__c_inner] = *this\scroll\v\bar\page\len; *this\height[#__c_draw] - Bool(Not *this\scroll\h\hide) * *this\scroll\h\height ; 
          EndIf
          
          If *this\type = #__type_panel And *this\gadget[#__panel_1]
            If *this\gadget[#__panel_1]\vertical
              *this\x[#__c_inner] = *this\x + *this\bs
              
              Resize(*this\gadget[#__panel_1], 0, 0, *this\__width, *this\height[#__c_draw])
              
              *this\x[#__c_inner] = *this\x + *this\bs + *this\__width
            Else
              *this\y[#__c_inner] = *this\y + *this\bs
              
              Resize(*this\gadget[#__panel_1], 0, 0, *this\width[#__c_draw], *this\__height)
              
              *this\y[#__c_inner] = *this\y + *this\bs + *this\__height
            EndIf
          EndIf
          
          If *this\type = #PB_GadgetType_Spin
            *this\width[#__c_inner] = *this\width[#__c_draw] - *this\bs*2 - *this\bar\button[#__b_3]\len
          EndIf
          
          ; then move and size parent
          If *this\container And *this\count\childrens
            Macro ResizeD(_type_, v1, ov1, v2, ov2, adv, ndv)
              Select _type_
                Case 0  : v1 = ov1                               : v2 = ov2
                Case 1  : v1 = ov1 + (ndv - adv)/2               : v2 = ov2 + (ndv - adv)/2   ; center (right & bottom)
                Case 2  : v1 = ov1 + (ndv - adv)                 : v2 = ov2 + (ndv - adv)     ; right & bottom
                Case 3  : v1 = ov1                               : v2 = ov2 + (ndv - adv)     ; full (right & bottom)
                Case 4  : v1 = ov1 * ndv / adv                   : v2 = ov2 * ndv / adv
                Case 5  : v1 = ov1                               : v2 = ov2 + (ndv - adv)/2
                Case 6  : v1 = ov1 + (ndv - adv)/2               : v2 = ov2 + (ndv - adv) 
              EndSelect
            EndMacro
            
            PushListPosition(widget())
            ForEach widget()
              If widget()\parent = *this ; And widget()\draw 
                If widget()\align
                  ResizeD( widget()\align\h, x, widget()\align\delta\x, 
                           Width, (widget()\align\delta\x + widget()\align\delta\width), *this\align\delta\width, *this\width)
                  
                  ResizeD( widget()\align\v, y, widget()\align\delta\y,
                           Height, (widget()\align\delta\y + widget()\align\delta\height), *this\align\delta\height, *this\height)
                  
                  ;Resize( widget(), x, y, Width - x + widget()\bs*2, Height - y + widget()\bs*2)
                  Resize( widget(), x, y, Width - x, Height - y)
                  
                Else
                  If (Change_x Or Change_y)
                    
                    Resize(widget(), 
                           widget()\x[#__c_draw],
                           widget()\y[#__c_draw], 
                           #PB_Ignore, #PB_Ignore)
                    
                  ElseIf (Change_width Or Change_height)
                    ;                     If  widget()\type = #PB_GadgetType_Panel ;(*this\gadget[#__panel_1])
                    ;                       Resize(widget(), #PB_Ignore, #PB_Ignore, widget()\width[#__c_draw], #PB_Ignore)
                    ;                     EndIf
                    
                    Clip(widget(), #True)
                  EndIf
                EndIf
              EndIf
            Next
            PopListPosition(widget())
          EndIf
          
          ;             If *this\text\string = "Button" And *this\parent\scroll And *this\parent\scroll\v 
          ;             ;*this\y[#__c_container]  = 370
          ;             Debug    *this\y[#__c_container] 
          ;            EndIf
          
          
          If *this\parent And 
             *this\parent\type = #__type_mdi And ; Not _is_scrollbar_(*this) And Not *this\parent\change 
             *this\parent\scroll And 
             *this\parent\scroll\v <> *this And 
             *this\parent\scroll\h <> *this And
             *this\parent\scroll\v\bar\thumb\change = 0 And
             *this\parent\scroll\h\bar\thumb\change = 0
            
            MDI_Update(*this)
          EndIf
          
        EndIf
        
        If *this\draw
          result = Update(*this)
        Else
          result = #True
        EndIf
        
        ; anchors widgets
        If *this And (*this\root And Transform() And Transform()\widget = *this)
          a_move(*this)
        EndIf
        
        If *this\container And (Change_x Or Change_y Or Change_width Or Change_height)
          Post(#__event_resize, *this)
        EndIf
                  
        ProcedureReturn result
      EndWith
    EndProcedure
    
    Procedure.l X(*this._s_widget, mode.l = #__c_frame)
      ProcedureReturn (Bool(Not *this\hide) * *this\x[mode])
    EndProcedure
    
    Procedure.l Y(*this._s_widget, mode.l = #__c_frame)
      ProcedureReturn (Bool(Not *this\hide) * *this\y[mode])
    EndProcedure
    
    Procedure.l Width(*this._s_widget, mode.l = #__c_frame)
      ProcedureReturn (Bool(Not *this\hide) * *this\width[mode])
    EndProcedure
    
    Procedure.l Height(*this._s_widget, mode.l = #__c_frame)
      ProcedureReturn (Bool(Not *this\hide) * *this\height[mode])
    EndProcedure
    
    ;- 
    Procedure.i AddColumn(*this._s_widget, Position.l, Text.s, Width.l, Image.i=-1)
      
      With *This
        ;         LastElement(\Columns())
        ;         AddElement(\Columns()) 
        ;         ;       Position = ListIndex(\Columns())
        ;         
        ;         \Columns()\text\string.s = Text.s
        ;         \Columns()\text\change = 1
        ;         \Columns()\x = \width[#__c_required]
        ;         \Columns()\width = Width
        ;         \Columns()\height = 24
        ;         \width[#__c_required] + Width
        ;         \height[#__c_required] = \bs*2+\Columns()\height
        ;         ;      ; ReDraw(*This)
        ;         ;       If Position = 0
        ;         ;      ;   PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
        ;         ;       EndIf
      EndWith
    EndProcedure
    
    Procedure   AddItem(*this._s_widget, Item.l, Text.s, Image.i =- 1, flag.i = 0)
      Protected result
      
      If *this\type = #PB_GadgetType_MDI
        *this\count\items + 1
        Static pos_x, pos_y
        Protected x = 10, y = 10, width.l = 280, height.l = 180
        flag | #__window_systemmenu|#__window_sizegadget|#__window_maximizegadget|#__window_minimizegadget
        result = Window(pos_x + x, pos_y + y, Width, Height, Text, flag, *this)
        pos_y + 20 + 25
        pos_x + 20
        ProcedureReturn result
      EndIf
      
      If *this\type = #PB_GadgetType_Editor
        ProcedureReturn Editor_AddItem(*this, Item,Text, Image, flag)
      EndIf
      
      If *this\type = #PB_GadgetType_Tree Or 
         *this\type = #__type_property
        ProcedureReturn Tree_AddItem(*this, Item,Text,Image,flag)
      EndIf
      
      If *this\type = #PB_GadgetType_ListView
        ProcedureReturn Tree_AddItem(*this, Item,Text,Image,flag)
      EndIf
      
      If *this\type = #PB_GadgetType_tabBar
        ProcedureReturn Tab_AddItem(*this, Item,Text,Image,flag)
      EndIf
      
      If *this\type = #PB_GadgetType_Panel
        ProcedureReturn Tab_AddItem(*this\gadget[#__panel_1], Item,Text,Image,flag)
      EndIf
      
      ProcedureReturn Item
    EndProcedure
    
    Procedure   RemoveItem(*this._s_widget, Item.l)
      Protected result
      
      If *this\type = #__type_Editor
        *this\text\change = 1
        *this\count\items - 1
        
        If *this\count\items =- 1 
          *this\count\items = 0 
          *this\text\string = #LF$
          
          _repaint_(*this)
          
        Else
          *this\text\string = RemoveString(*this\text\string, StringField(*this\text\string, item + 1, #LF$) + #LF$)
        EndIf
        
        result = #True
      ElseIf *this\type = #__type_tree
        Protected sublevel.l
        
        If _no_select_(*this\row\_s(), Item)
          ProcedureReturn #False
        EndIf
        
        If *this\row\_s()\childrens
          sublevel = *this\row\_s()\sublevel
          *this\change = 1
          
          PushListPosition(*this\row\_s())
          While NextElement(*this\row\_s())
            If *this\row\_s()\sublevel > sublevel 
              ;Debug *this\row\_s()\text\string
              DeleteElement(*this\row\_s())
              *this\count\items - 1
              *this\row\count - 1
            Else
              Break
            EndIf
          Wend
          PopListPosition(*this\row\_s())
        EndIf
        
        DeleteElement(*this\row\_s())
        
        If *this\row\selected And
           *this\row\selected\index >= Item 
          *this\row\selected\color\state = 0
          
          PushListPosition(*this\row\_s())
          If *this\row\selected\index <> Item 
            SelectElement(*this\row\_s(), *this\row\selected\index)
          EndIf
          
          While NextElement(*this\row\_s())
            If *this\row\_s()\sublevel = sublevel 
              *this\row\selected = *this\row\_s()
              *this\row\selected\color\state = 2 + Bool(GetActive()\gadget<>*this)
              Break
            EndIf
          Wend
          PopListPosition(*this\row\_s())
        EndIf
        
        _repaint_items_(*this)
        *this\count\items - 1
        
        result = #True
        
      ElseIf *this\type = #__type_Panel
        result = Tab_removeItem(*this\gadget[#__panel_1], Item)
        
      ElseIf *this\type = #__type_tabBar
        result = Tab_removeItem(*this, Item)
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l CountItems(*this._s_widget)
      ProcedureReturn *this\count\items
    EndProcedure
    
    Procedure.l ClearItems(*this._s_widget)
      Protected result
      
      If *this\type = #__type_Editor
        *this\text\change = 1 
        *this\count\items = 0
        
        If *this\text\editable
          *this\text\string = #LF$
        EndIf
        
        _repaint_(*this)
        ProcedureReturn #True
      EndIf
      
      If *this\type = #__type_tree
        If *this\count\items <> 0
          *this\change =- 1
          *this\row\count = 0
          *this\count\items = 0
          
          If *this\row\selected 
            *this\row\selected\color\state = 0
            *this\row\selected = 0
          EndIf
          
          ClearList(*this\row\_s())
          ReDraw(*this)
          
          Post(#__Event_change, *this, #PB_All)
        EndIf
      EndIf
      
      If *this\type = #__type_Panel
        result = Tab_clearItems(*this\gadget[#__panel_1])
        
      ElseIf *this\type = #__type_tabBar
        result = Tab_clearItems(*this)
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i CloseList()
      If Opened() And 
         Opened()\parent And
         Opened()\root\canvas\gadget = Root()\canvas\gadget 
        
        ; Debug "" + Opened() + " - " + Opened()\class + " " + Opened()\parent + " - " + Opened()\parent\class
        If Opened()\parent\type = #__type_mdi
          Opened() = Opened()\parent\parent
        Else
          Opened() = Opened()\parent
        EndIf
      Else
        Opened() = Root()
      EndIf
    EndProcedure
    
    Procedure.i OpenList(*this._s_widget, item.l = 0)
      Protected result.i = Opened()
      
      If *this
        If (_is_root_(*this) Or 
            *this\type = #__type_Window)
          *this\window = *this
        EndIf
        
        Opened() = *this
        If *this\type = #PB_GadgetType_Panel
          Opened()\index[#__panel_1] = item
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;- 
    Procedure   Getwidget(index)
      Protected result
      
      If index =- 1
        ProcedureReturn widget()
      Else
        ForEach widget()
          If widget()\index = index ; +  1
            result = widget()
            Break
          EndIf
        Next
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l GetIndex(*this._s_widget)
      ProcedureReturn *this\index ; - 1
    EndProcedure
    
    Procedure.l GetLevel(*this._s_widget)
      ProcedureReturn *this\level ; - 1
    EndProcedure
    
    Procedure.s GetClass(*this._s_widget)
      ProcedureReturn *this\class
    EndProcedure
    
    Procedure.l GetMouseX(*this._s_widget, mode.l = #__c_screen)
      ProcedureReturn Mouse()\x - *this\x[mode]
    EndProcedure
    
    Procedure.l GetMouseY(*this._s_widget, mode.l = #__c_screen)
      ProcedureReturn Mouse()\y - *this\y[mode]
    EndProcedure
    
    Procedure.l GetDeltaX(*this._s_widget)
      ProcedureReturn (Mouse()\delta\x + Focused()\x[#__c_draw])
    EndProcedure
    
    Procedure.l GetDeltaY(*this._s_widget)
      ProcedureReturn (Mouse()\delta\y + Focused()\y[#__c_draw])
    EndProcedure
    
    Procedure.l GetButtons(*this._s_widget)
      ProcedureReturn Mouse()\buttons
    EndProcedure
    
    Procedure.i GetFont(*this._s_widget)
      ProcedureReturn *this\text\fontID
    EndProcedure
    
    Procedure.l GetCount(*this._s_widget, mode.b = #False)
      If mode
        ProcedureReturn *this\count\type
      Else
        ProcedureReturn *this\count\index
      EndIf
    EndProcedure
    
    Procedure.i GetData(*this._s_widget)
      ProcedureReturn *this\data
    EndProcedure
    
    Procedure.l GetType(*this._s_widget)
      ProcedureReturn *this\type
    EndProcedure
    
    Procedure.i GetRoot(*this._s_widget)
      ProcedureReturn *this\root ; Returns root element
    EndProcedure
    
    Procedure.i GetGadget(*this._s_widget)
      If _is_root_(*this)
        ProcedureReturn *this\root\canvas\gadget ; Returns canvas gadget
      Else
        ProcedureReturn *this\gadget ; Returns active gadget
      EndIf
    EndProcedure
    
    Procedure.i GetWindow(*this._s_widget)
      If _is_root_(*this)
        ProcedureReturn *this\root\canvas\window ; Returns canvas window
      Else
        ProcedureReturn *this\window ; Returns element window
      EndIf
    EndProcedure
    
    Procedure.i GetParent(*this._s_widget)
      ProcedureReturn *this\parent
    EndProcedure
    
    Procedure.i GetParentLast(*parent._s_widget)
      Protected result.i
      
      While *parent
        result = *parent
        *parent = *parent\last
      Wend
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetPosition(*this._s_widget, Position.l)
      Protected result.i
      
      If *this
        Select Position
          Case #PB_List_First  : result = *this\parent\first
          Case #PB_List_Before : result = *this\before
          Case #PB_List_After  : result = *this\after
          Case #PB_List_Last   : result = *this\parent\last
        EndSelect
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetAttribute(*this._s_widget, Attribute.l)
      Protected result.i
      
      Select Attribute
        Case #__bar_minimum    : result = *this\bar\min          ; 1
        Case #__bar_maximum    : result = *this\bar\max          ; 2
        Case #__bar_pagelength : result = *this\bar\page\len     ; 3
        Case #__bar_nobuttons  : result = *this\bar\button\len   ; 4
        Case #__bar_inverted   : result = *this\bar\inverted
        Case #__bar_direction  : result = *this\bar\direction
      EndSelect
      
      If *this\type = #PB_GadgetType_Tree
        If Attribute = #__tree_collapsed  
          result = *this\mode\collapse
        EndIf
      EndIf
      
      If *this\type = #PB_GadgetType_Splitter
        Select Attribute 
          Case #PB_Splitter_FirstGadget       : result = *this\gadget[#__split_1]
          Case #PB_Splitter_SecondGadget      : result = *this\gadget[#__split_2]
          Case #PB_Splitter_FirstMinimumSize  : result = *this\bar\button[#__b_1]\len
          Case #PB_Splitter_SecondMinimumSize : result = *this\bar\button[#__b_2]\len
        EndSelect
      EndIf
      
      If *this\type = #PB_GadgetType_ScrollArea
        Select Attribute 
          Case #PB_ScrollArea_X               : result = *this\x[#__c_required]
          Case #PB_ScrollArea_Y               : result = *this\y[#__c_required]
          Case #PB_ScrollArea_InnerWidth      : result = *this\width[#__c_required]
          Case #PB_ScrollArea_InnerHeight     : result = *this\height[#__c_required]
          Case #PB_ScrollArea_ScrollStep      : result = *this\bar\increment
        EndSelect
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.f GetState(*this._s_widget)
      If *this\type = #PB_GadgetType_ListView Or
         *this\type = #PB_GadgetType_Tree
        
        If *this\row\selected And 
           *this\row\selected\color\state
          ProcedureReturn *this\row\selected\index
        Else
          ProcedureReturn - 1
        EndIf
      EndIf
      
      If *this\type = #__type_button Or
         *this\type = #__type_buttonimage
        
        ProcedureReturn Bool(*this\_state & #__s_toggled)
      EndIf
      
      If *this\type = #PB_GadgetType_Option
        ProcedureReturn *this\button\state
      EndIf
      
      If *this\type = #PB_GadgetType_CheckBox
        ProcedureReturn *this\button\state
      EndIf
      
      If *this\type = #PB_GadgetType_Editor
        ProcedureReturn *this\index[#__s_2] ; *this\text\caret\pos
      EndIf
      
      If *this\type = #PB_GadgetType_Panel
        ProcedureReturn *this\index[#__s_2] 
      EndIf
      
      If *this\type = #PB_GadgetType_tabBar
        ProcedureReturn *this\index[#__s_2] 
        
      Else
        ProcedureReturn *this\bar\page\pos
      EndIf
    EndProcedure
    
    Procedure.s GetText(*this._s_widget)
      If *this\type = #PB_GadgetType_Tree
        If *this\row\selected 
          ProcedureReturn *this\row\selected\text\string
        EndIf
      EndIf
      
      If *this\text\pass
        ProcedureReturn *this\text\edit\string
      Else
        ProcedureReturn *this\text\string
      EndIf
    EndProcedure
    
    Procedure.l GetColor(*this._s_widget, ColorType.l)
      Protected Color.l
      
      With *This
        Select ColorType
          Case #__color_line  : Color = \color\Line
          Case #__color_back  : Color = \color\Back
          Case #__color_front : Color = \color\Front
          Case #__color_frame : Color = \color\Frame
        EndSelect
      EndWith
      
      ProcedureReturn Color
    EndProcedure
    
    
    ;- 
    Procedure   SetCursor(*this._s_widget, *cursor)
      _set_cursor_(*this, *cursor)
    EndProcedure
    
    Procedure   SetClass(*this._s_widget, class.s)
      *this\class = class
    EndProcedure
    
    Procedure.b SetState(*this._s_widget, state.f)
      Protected result
      
      ;- Button_SetState()
      If *this\type = #__type_button Or
         *this\type = #__type_buttonimage
        
        If *this\_flag & #__button_toggle
          If *this\_state & #__s_toggled
            *this\_state &~ #__s_toggled
            
            If *this\_state & #__s_entered
              *this\color\state = #__s_1 
            Else
              *this\color\state = #__s_0 
            EndIf
            
          ElseIf state
            *this\_state | #__s_toggled
            *this\color\state = #__s_2 
          EndIf
          
          Post(#PB_EventType_Change, *this)
          result = 1
        Else
          If *this\color\state <> #__s_1
            *this\color\state = #__s_1
            result = 1
          EndIf
        EndIf
      EndIf
      
      ;
      If *this\type = #__type_checkBox
        If *this\button\state <> state
          change_checkbox_state(*this\button, Bool(state = #PB_Checkbox_Inbetween))
          
          Post(#PB_EventType_Change, *this)
          ReDraw(*this\root)
          ProcedureReturn 1
        EndIf
      EndIf
      
      ;
      If *this\type = #__type_Option
        If *this\_group And 
           *this\button\state <> State
          
          If *this\_group\_group <> *this
            If *this\_group\_group
              *this\_group\_group\button\state = 0
            EndIf
            *this\_group\_group = *this
          EndIf
          *this\button\state = State
          
          Post(#PB_EventType_Change, *this)
          ReDraw(*this\root)
          ProcedureReturn 1
        EndIf
      EndIf
      
      If *this\type = #__type_IPAddress
        If *this\index[#__s_2] <> State : *this\index[#__s_2] = State
          SetText(*this, Str(IPAddressField(State,0)) + "." + 
                         Str(IPAddressField(State,1)) + "." + 
                         Str(IPAddressField(State,2)) + "." + 
                         Str(IPAddressField(State,3)))
        EndIf
      EndIf
      
      If *this\type = #__type_Window
        result = Window_SetState(*this, state)
      EndIf
      
      If *this\type = #__type_Editor
        If state < 0 Or state > *this\text\len
          state = *this\text\len
        EndIf
        
        If *this\text\caret\pos <> State
          *this\text\caret\pos = State
          
          Protected i.l, len.l
          Protected *str.Character = @*this\text\string 
          Protected *end.Character = @*this\text\string 
          
          While *end\c 
            If *end\c = #LF 
              len + (*end - *str)/#__sOC
              ; Debug "" + i + " " + Str(len + i)  + " " +  state
              
              If len + i >= state
                *this\index[#__s_1] = i
                *this\index[#__s_2] = i
                
                *this\text\caret\pos[1] = state - (len - (*end - *str)/#__sOC) - i
                *this\text\caret\pos[2] = *this\text\caret\pos[1]
                
                Break
              EndIf
              i + 1
              
              *str = *end + #__sOC 
            EndIf 
            
            *end + #__sOC 
          Wend
          
          ; last line
          If *this\index[#__s_1] <> i 
            *this\index[#__s_1] = i
            *this\index[#__s_2] = i
            
            *this\text\caret\pos[1] = (state - len - i) 
            *this\text\caret\pos[2] = *this\text\caret\pos[1]
          EndIf
          
          result = #True 
        EndIf
      EndIf
      
      If *this\type = #__type_tree Or 
         *this\type = #__type_listView
        
        If _no_select_(*this\row\_s(), State)
          ProcedureReturn #False
        EndIf
        
        If *this\count\items
          ; mode click select
          If *this\mode\check = 2
            If *this\row\_s()\_state & #__s_selected 
              *this\row\_s()\_state &~ #__s_selected
              *this\row\_s()\color\state = #__s_0
            Else
              *this\row\_s()\_state | #__s_selected
              *this\row\_s()\color\state = #__s_3
            EndIf
            
            Post(#PB_EventType_Change, *this, *this\row\_s()\index)
            
          Else
            If *this\row\selected 
              If *this\row\selected <> *this\row\_s()
                ; mode multi select
                If *this\mode\check = 3
                  If *this\row\selected\_state & #__s_selected
                    *this\row\selected\_state &~ #__s_selected
                    Post(#PB_EventType_Change, *this, *this\row\selected\index)
                  EndIf
                EndIf
                
                *this\row\selected\_state &~ #__s_selected
              EndIf
              
              *this\row\selected\color\state = #__s_0
            EndIf
            
            ; mode multi select
            If *this\mode\check = 3
              If *this\row\_s()\_state & #__s_selected = 0
                *this\row\_s()\_state | #__s_selected
                Post(#PB_EventType_Change, *this, *this\row\_s()\index)
              EndIf
            EndIf
            
            *this\row\_s()\color\state = #__s_3
          EndIf
          
          *this\row\selected = *this\row\_s()
          *this\row\scrolled = (State+1)
          
          _repaint_items_(*this)
          ProcedureReturn #True
        EndIf
      EndIf
      
      If *this\type = #__type_Panel
        result = Tab_SetState(*this\gadget[#__panel_1], state)
      EndIf
      
      If *this\type = #__type_tabBar
        result = Tab_SetState(*this, state)
      EndIf
      
      Select *this\type
        Case #__type_Spin ,
             #__type_tabBar,
             #__type_trackBar,
             #__type_ScrollBar,
             #__type_ProgressBar,
             #__type_Splitter       
          
          result = Bar_SetState(*this, state)
      EndSelect
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetAttribute(*this._s_widget, Attribute.l, *value)
      Protected result.i
      
      If *this\type = #PB_GadgetType_Spin Or
         *this\type = #PB_GadgetType_TabBar Or
         *this\type = #PB_GadgetType_TrackBar Or
         *this\type = #PB_GadgetType_ScrollBar Or
         *this\type = #PB_GadgetType_ProgressBar Or
         *this\type = #PB_GadgetType_Splitter
        result = Bar_SetAttribute(*this, Attribute, *value)
      EndIf
      
      If *this\type = #PB_GadgetType_Button Or
         *this\type = #PB_GadgetType_ButtonImage
        
        Select Attribute 
          Case #PB_Button_Image
            _set_image_(*this, *this\image, *value)
            _set_image_(*this, *this\image[1], *value)
            
          Case #PB_Button_PressedImage
            _set_image_(*this, *this\image[2], *value)
            
        EndSelect
      EndIf
      
      ; Ok
      If *this\type = #PB_GadgetType_ScrollArea
        Select Attribute 
          Case #PB_ScrollArea_X 
            If Bar_SetState(*this\scroll\h, *value)
              *this\x[#__c_required] = *this\scroll\h\bar\page\pos
              result = 1
            EndIf
            
          Case #PB_ScrollArea_Y               
            If Bar_SetState(*this\scroll\v, *value)
              *this\y[#__c_required] = *this\scroll\v\bar\page\pos
              result = 1
            EndIf
            
          Case #PB_ScrollArea_InnerWidth      
            If Bar_SetAttribute(*this\scroll\h, #__bar_maximum, *value)
              *this\width[#__c_required] = *this\scroll\h\bar\max
              result = 1
            EndIf
            
          Case #PB_ScrollArea_InnerHeight     
            If Bar_SetAttribute(*this\scroll\v, #__bar_maximum, *value)
              *this\height[#__c_required] = *this\scroll\v\bar\max
              result = 1
            EndIf
            
          Case #PB_ScrollArea_ScrollStep      
            *this\bar\increment = *value
            
        EndSelect
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetText(*this._s_widget, Text.s)
      Protected result.i, Len.i, String.s, i.i
      
      
      If *this\type = #PB_GadgetType_Tree
        If *this\row\selected 
          *this\row\selected\text\string = Text
        EndIf
      EndIf
      
      If *this\type = #PB_GadgetType_Editor
        ; If Text.s = "" : Text.s = #LF$ : EndIf
        Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
        Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
        Text.s = ReplaceString(Text.s, #CR$, #LF$)
        ;Text + #LF$
        
        With *this
          If ListSize(*this\row\_s())
            ClearItems(*this)
          EndIf
          
          If \text\edit\string.s <> Text.s
            \text\edit\string = Text.s
            \text\string.s = _text_insert_make_(*this, Text.s)
            
            If \text\string.s
              If \text\multiline
                \count\items = CountString(\text\string.s, #LF$)
              Else
                \count\items = 1
              EndIf
              
              ;           If *this And StartDrawing(CanvasOutput(*this\root\canvas\gadget))
              ;             If \text\fontID 
              ;               DrawingFont(\text\fontID) 
              ;             EndIf
              ;             
              ;             make_text_multiline(*this)
              ;             StopDrawing()
              ;           EndIf
              
              \text\len = Len(\text\string.s)
              \text\change = #True
              
              _repaint_(*this)
              
              result = #True
            EndIf
          EndIf
        EndWith
      Else
        ;         If *this\text\multiline = 0
        ;           Text = RemoveString(Text, #LF$)
        ;         EndIf
        
        Text = ReplaceString(Text, #LFCR$, #LF$)
        Text = ReplaceString(Text, #CRLF$, #LF$)
        Text = ReplaceString(Text, #CR$, #LF$)
        ;Text + #LF$
        
        If *This\text\string.s <> Text.s
          *This\text\string.s = Text.s
          *This\text\change = #True
          result = #True
        EndIf
      EndIf
      
      *this\change = 1
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetFont(*this._s_widget, FontID.i)
      Protected result
      
      If *this\text\fontID <> FontID
        *this\text\fontID = FontID
        ; reset current drawing font
        ; to set new current drawing font
        *this\root\text\fontID[1] =- 1 
        
        
        If *this\type = #PB_GadgetType_Editor
          *this\text\change = 1
          
          If Not Bool(*this\row\count And *this\row\count <> *this\count\items)
            Redraw(*this)
          EndIf
        Else
          ; reset current font
          *this\root\text\fontID[1] = 0
          ReDraw(*this)
          ;           ; example\font\font(demo)
          ;           If StartDrawing(CanvasOutput(*this\root\canvas\gadget))
          ;             _drawing_font_(*this)
          ;             Draw(*this)
          ;             
          ;             StopDrawing()
          ;           EndIf
        EndIf
        
        result = #True
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l SetColor(*this._s_widget, ColorType.l, Color.l)
      Protected result
      
      With *This
        Select ColorType
          Case #__color_line
            If \color\Line <> Color 
              \color\Line = Color
              result = #True
            EndIf
            
          Case #__color_back
            If \color\Back <> Color 
              \color\Back = Color
              result = #True
            EndIf
            
          Case #__color_fore
            If \color\fore <> Color 
              \color\fore = Color
              result = #True
            EndIf
            
          Case #__color_front
            If \color\Front <> Color 
              \color\Front = Color
              result = #True
            EndIf
            
          Case #__color_frame
            If \color\Frame <> Color 
              \color\Frame = Color
              result = #True
            EndIf
            
        EndSelect
      EndWith
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   SetImage(*this._s_widget, *image)
      _set_image_(*this, *this\Image, *image)
    EndProcedure
    
    Procedure   SetData(*this._s_widget, *data)
      *this\data = *data
    EndProcedure
    
    Procedure   SetParent(*this._s_widget, *parent._s_widget, _item.l = 0)
      Protected x.l, y.l, *LastParent._s_widget
      
      If *parent 
        If _item < 0 
          _item = *parent\index[#__panel_1] 
        EndIf
        
        If *this\parent <> *parent Or 
           *this\_item <> _item
          *this\_item = _item
          
          *this\root = *parent\root
          *this\window = *parent\window
          
          If *parent\type = #PB_GadgetType_Panel
            If *parent\index[#__panel_2] = _item
              *this\hide = #False
            Else
              *this\hide = #True
            EndIf
          EndIf
          
          If *parent\hide
            *this\hide = #True
          EndIf
          
          ; 
          If *this\parent
            *LastParent = *this\parent
            *LastParent\count\childrens - 1
            
            If _is_root_(*parent)
              FirstElement(widget())
              MoveElement(widget(), #PB_List_First)
            Else
              ChangeCurrentElement(widget(), *this\adress)
              If *parent\last 
                If *parent\last = *this
                  If *parent\last\before
                    MoveElement(widget(), #PB_List_After, *parent\last\before\adress)
                    ;   MoveElement(widget(), #PB_list_After, *Parent\adress)
                    
                  Else
                    Debug "*parent\last - " + *parent\last\index
                    MoveElement(widget(), #PB_List_After, *Parent\adress)
                  EndIf
                Else
                  MoveElement(widget(), #PB_List_After, *parent\last\adress)
                EndIf
              Else
                MoveElement(widget(), #PB_List_After, *parent\adress)
              EndIf
            EndIf
            
            
            If *this\root <> *this\parent\root
              LastElement(widget())
            EndIf
            
            While PreviousElement(widget()) 
              If Child(widget(), *this)
                ; Debug widget()\index
                widget()\root = *parent\root
                widget()\window = *parent\window
                
                If widget()\scroll
                  If widget()\scroll\v
                    widget()\scroll\v\root = *parent\root
                    widget()\scroll\v\window = *parent\window
                  EndIf
                  If widget()\scroll\h
                    widget()\scroll\v\root = *parent\root
                    widget()\scroll\h\window = *parent\window
                  EndIf
                EndIf
                
                MoveElement(widget(), #PB_List_After, *this\adress)
              EndIf
            Wend
            
          EndIf
          
          *this\parent = *parent
          
          ; TODO
          If *this\window
            Static NewMap typecount.l()
            
            *this\count\index = typecount(Hex(*this\window) + "_" + Hex(*this\type))
            typecount(Hex(*this\window) + "_" + Hex(*this\type)) + 1
            
            *this\count\type = typecount(Hex(*parent) + "__" + Hex(*this\type))
            typecount(Hex(*parent) + "__" + Hex(*this\type)) + 1
          EndIf
          
          If Not *this\adress
            ;           If Not *parent\last And ListIndex(widget()) > 0 ; And *parent\last\index < ListIndex(widget())
            ;             Debug " - - - -  " + *this\class  + " " +  ListIndex(widget()) ;\index
            ;                                                                               ;Protected *last._s_widget = GetParentLast(*parent)
            ;             SelectElement(widget(), *parent\index + 1)
            ;             *this\adress = InsertElement(widget())
            ;             ; *this\adress = AddElement(widget()) 
            ;             ; *parent\last = *this\after
            ;             
            ;             ;             ; Исправляем идентификатор итема  
            ;             ;             PushListPosition(widget())
            ;             ;             While NextElement(widget())
            ;             ;               widget()\index = ListIndex(widget())
            ;             ;             Wend
            ;             ;             PopListPosition(widget())
            ;           *this\index = *this\root\count\childrens; ListIndex(widget()) 
            ;          Else
            LastElement(widget())
            *this\adress = AddElement(widget()) 
            *this\index = ListIndex(widget()) 
            ;           EndIf
            widget() = *this
            
            ; set z - order position 
            If Not *parent\first 
              If Not *parent\last
                ; Debug *this\index
                *parent\last = *this
              EndIf
              ; Debug *this\index
              *parent\first = *this
              
            ElseIf *parent\last
              *this\before = *parent\last
              *this\before\after = *this
              
              *parent\last = *this
            EndIf
            
            ; set transformation for the child
            If Not *this\transform And *parent\transform 
              *this\transform = *parent\transform 
              a_set(*this)
            EndIf
          EndIf
          
          ; add parent childrens count
          *parent\count\childrens + 1
          
          If *parent <> *this\root
            *this\root\count\childrens + 1
            *this\level = *parent\level + 1
          EndIf
          
          ; children reparent 
          If *LastParent And 
             *LastParent <> *parent
            
            If *this\scroll
              If *this\scroll\v
                *this\scroll\v\root = *this\root
                *this\scroll\v\window = *this\window
              EndIf
              If *this\scroll\h
                *this\scroll\v\root = *this\root
                *this\scroll\h\window = *this\window
              EndIf
            EndIf
            
            x = *this\x[#__c_draw]
            y = *this\y[#__c_draw]
            
            ; new parent
            If *parent\scroll And 
               *parent\scroll\v And 
               *parent\scroll\h
              
              ; for the scroll area childrens
              x - *parent\scroll\h\bar\page\pos
              y - *parent\scroll\v\bar\page\pos
            EndIf
            
            ; last parent
            If *LastParent\scroll And 
               *LastParent\scroll\v And 
               *LastParent\scroll\h
              
              ; for the scroll area childrens
              x + *LastParent\scroll\h\bar\page\pos
              y + *LastParent\scroll\v\bar\page\pos
            EndIf
            
            Resize(*this, x + *parent\x[#__c_required], y + *parent\y[#__c_required], #PB_Ignore, #PB_Ignore)
            
            ; re draw new parent root 
            If *LastParent\root <> *parent\root
              Select Root()
                Case *LastParent\root : ReDraw(*parent\root)
                Case *parent\root     : ReDraw(*LastParent\root)
              EndSelect
            EndIf
          EndIf
        EndIf
      EndIf
    EndProcedure
    
    Procedure.i SetAlignment(*this._s_widget, Mode.l, Type.l = 1) ; ok
      Protected rx.b, ry.b
      
      With *this
        Select Type
          Case 1 ; widget
            If \parent
              If Not \parent\align
                \parent\align.structures::_s_align = AllocateStructure(structures::_s_align)
              EndIf
              If Not \align
                \align.structures::_s_align = AllocateStructure(structures::_s_align)
              EndIf
              
              ; 
              If Mode & #__align_full = #__align_full
                Mode | (Bool(Mode & #__align_right = #False) * #__align_left) |
                       (Bool(Mode & #__align_bottom = #False) * #__align_top) | 
                       (Bool(Mode & #__align_left = #False) * #__align_right) |
                       (Bool(Mode & #__align_top = #False) * #__align_bottom)
              EndIf
              
              If Mode & #__align_right = #__align_right
                rx = 2 + Bool(Mode & #__align_left = #__align_left)
              EndIf
              
              If Mode & #__align_bottom = #__align_bottom
                ry = 2 + Bool(Mode & #__align_top = #__align_top)
              EndIf
              
              If Mode & #__align_center = #__align_center
                If Not Mode & #__align_right And
                   Not Mode & #__align_left
                  rx = 1
                EndIf
                
                If Not Mode & #__align_bottom And
                   Not Mode & #__align_top
                  ry = 1
                EndIf
              EndIf
              
              If Mode & #__align_proportional = #__align_proportional
                If Mode & #__align_vertical = #__align_vertical
                  If Mode & #__align_top = #__align_top And Not Mode & #__align_left 
                    If Mode & #__align_bottom = #__align_bottom
                      ry = 4
                    Else
                      ry = 5
                    EndIf
                  Else
                    ry = 6
                  EndIf
                  
                Else
                  If Mode & #__align_left = #__align_left And Not Mode & #__align_top
                    If Mode & #__align_right = #__align_right
                      rx = 4
                    Else
                      rx = 5
                    EndIf
                  Else
                    rx = 6
                  EndIf
                EndIf
              EndIf
              
              \align\h = rx
              \align\v = ry
              
              \align\delta\x = \x[#__c_draw]
              \align\delta\y = \y[#__c_draw]
              \align\delta\width = \width
              \align\delta\height = \height
              
              \parent\align\delta\x = \parent\x[#__c_draw]
              \parent\align\delta\y = \parent\y[#__c_draw]
              \parent\align\delta\width = \parent\width
              \parent\align\delta\height = \parent\height
              
              ; docking
              If Mode & #__align_auto = #__align_auto
                If \align\h = 1 ; center
                  \align\delta\x = (\parent\width[#__c_inner] - \align\delta\width)/2
                ElseIf \align\h = 2 ; right
                  \align\delta\x = \parent\width[#__c_inner] - \align\delta\width
                EndIf
                
                If \align\v = 1 ; center
                  \align\delta\y = (\parent\height[#__c_inner] - \align\delta\height)/2
                ElseIf \align\v = 2 ; bottom
                  \align\delta\y = \parent\height[#__c_inner] - \align\delta\height
                EndIf
                
                If \align\h = 3 Or \align\v = 3
                  If \align\h = 3 ; full horizontal
                    \align\delta\width = \parent\width[#__c_inner]
                    
                    If \align\v = 0 ; top
                      \align\delta\y + \parent\align\_top
                      \parent\align\_top + *this\height
                      
                    ElseIf \align\v = 2 ; bottom
                      \align\delta\y - \parent\align\_bottom
                      \parent\align\_bottom + *this\height + \parent\bs*2
                      
                    EndIf
                  EndIf
                  
                  If \align\v = 3 ; full vertical
                    \align\delta\height = \parent\height[#__c_inner] 
                    
                    If \align\h = 0 ; left
                      \align\delta\x + \parent\align\_left
                      \parent\align\_left + *this\width
                      
                    ElseIf \align\h = 2 ; right
                      \align\delta\x - \parent\align\_right
                      \parent\align\_right + *this\width + \parent\bs*2
                      
                    EndIf
                  EndIf
                  
                  PushListPosition(widget())
                  ForEach widget()
                    If widget()\align And
                       widget()\parent = \parent 
                      
                      If (widget()\align\h = 0 Or widget()\align\h = 2)
                        widget()\align\delta\y = \parent\align\_top
                        widget()\align\delta\height = \parent\align\delta\height - \parent\align\_top - \parent\align\_bottom
                      EndIf
                      
                      If (widget()\align\v = 3 And widget()\align\h = 3)
                        widget()\align\delta\x = \parent\align\_left
                        widget()\align\delta\width = \parent\align\delta\width - \parent\align\_left - \parent\align\_right
                        
                        widget()\align\delta\y = \parent\align\_top
                        widget()\align\delta\height = \parent\align\delta\height - \parent\align\_top - \parent\align\_bottom
                      EndIf
                      
                    EndIf
                  Next
                  PopListPosition(widget())
                EndIf
              EndIf
              
              ; update parent childrens coordinate
              Resize(\parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            EndIf
          Case 2 ; text
          Case 3 ; image
        EndSelect
      EndWith
    EndProcedure
    
    Procedure __SetPosition(*this._s_widget, position.l, *widget_2._s_widget = #Null) ; Ok
      Protected Type
      Protected result =- 1
      
      If *this = *widget_2
        ProcedureReturn 0
      EndIf
      Select Position
        Case #PB_List_First 
          If *this\parent\first <> *this
            ChangeCurrentElement(widget(), *this\adress)
            MoveElement(widget(), #PB_List_Before, *this\parent\first\adress)
            
            While NextElement(widget()) 
              If Child(widget(), *this)
                MoveElement(widget(), #PB_List_Before, *this\parent\first\adress)
              EndIf
            Wend
            
            If *this\parent\last = *this
              *this\parent\last = *this\before
              *this\before\after = 0
              
              *this\after = *this\parent\first
              *this\after\before = *this
              
              *this\parent\first = *this
              *this\before = 0
            EndIf
          EndIf
          
        Case #PB_List_Before 
          If *this\before
            ChangeCurrentElement(widget(), *this\adress)
            MoveElement(widget(), #PB_List_Before, *this\before\adress)
            
            While NextElement(widget()) 
              If Child(widget(), *this)
                MoveElement(widget(), #PB_List_Before, *this\before\adress)
              EndIf
            Wend
            
            If *this\parent\last = *this
              *this\parent\last = *this\before
            EndIf
            
            *this\before\after = *this\after
            *this\after = *this\before
            *this\before = *this\before\before 
            
            If *this\before
              *this\before\after = *this
            EndIf
            *this\after\before = *this
          EndIf
          
        Case #PB_List_After 
          If *this\after
            ChangeCurrentElement(widget(), *this\adress)
            MoveElement(widget(), #PB_List_After, *this\after\adress)
            
            While PreviousElement(widget()) 
              If Child(widget(), *this)
                MoveElement(widget(), #PB_List_After, *this\adress)
              EndIf
            Wend
            
            If *this\parent\first = *this
              *this\parent\first = *this\after
            EndIf
            
            *this\after\before = *this\before
            *this\before = *this\after
            *this\after = *this\after\after 
            
            *this\before\after = *this
            If *this\after
              *this\after\before = *this
            EndIf
          EndIf
          
        Case #PB_List_Last 
          Protected *Last._s_widget = GetParentLast(*this\parent)
          
          If *Last <> *this
            ChangeCurrentElement(widget(), *this\adress)
            MoveElement(widget(), #PB_List_After, *Last\adress)
            
            While PreviousElement(widget()) 
              If Child(widget(), *this)
                MoveElement(widget(), #PB_List_After, *this\adress)
              EndIf
            Wend
            
            If *this\parent\first = *this
              *this\parent\first = *this\after
              *this\after\before = 0
              
              *this\before = *this\parent\last
              *this\before\after = *this
              
              *this\parent\last = *this
              *this\after = 0
            EndIf
          EndIf
          
      EndSelect
      
      
      ;redraw(root())
      PostEvent(#PB_Event_Gadget, *this\root\canvas\window, *this\root\canvas\gadget, #__event_repaint, *this)
      
      ProcedureReturn result
    EndProcedure
    
    Procedure   SetPosition(*this._s_widget, position.l, *widget_2._s_widget = #Null) ; Ok
      Protected Type
      Protected result =- 1
      
      Protected *before._s_widget 
      Protected *after._s_widget 
      Protected *Last._s_widget
      
      If *this = *widget_2
        ProcedureReturn 0
      EndIf
      
      Select Position
        Case #PB_List_First 
          If *this\parent\first <> *this
            SetPosition(*this, #PB_List_Before, *this\parent\first)
          EndIf
          
        Case #PB_List_Before 
          If *widget_2
            *before = *widget_2
          Else
            *before = *this\before
          EndIf
          
          If *before
            ChangeCurrentElement(widget(), *this\adress)
            MoveElement(widget(), #PB_List_Before, *before\adress)
            
            While NextElement(widget()) 
              If Child(widget(), *this)
                MoveElement(widget(), #PB_List_Before, *before\adress)
              EndIf
            Wend
            
            If *this\parent\last   = *this ; GetParentLast(*this) 
              *this\parent\last    = *before
            EndIf
            
            If *this\before
              *this\before\after   = *this\after
            EndIf
            
            *this\after            = *before
            *this\before           = *before\before 
            
            If Not *this\before
              *this\parent\first = *this
              *this\parent\first\before = 0
            EndIf
          EndIf
          
        Case #PB_List_After 
          If *widget_2
            *after = *widget_2
          Else
            *after = *this\after
          EndIf
          
          If *after
            *Last = GetParentLast(*after)
            
            ChangeCurrentElement(widget(), *this\adress)
            MoveElement(widget(), #PB_List_After, *Last\adress)
            
            While PreviousElement(widget()) 
              If Child(widget(), *this)
                MoveElement(widget(), #PB_List_After, *this\adress)
              EndIf
            Wend
            
            If *this\parent\first = *this
              *this\parent\first = *after
            EndIf
            
            If *this\after
              *this\after\before = *this\before
            EndIf
            
            *this\before = *after
            *this\after = *after\after 
            
            If Not *this\after
              *this\parent\last = *this
              *this\parent\last\after = 0
            EndIf
          EndIf
          
        Case #PB_List_Last 
          ;             *after = *this\parent\last
          ;           
          ;           If *this\parent\last <> *this 
          ;             *Last = GetParentLast(*after)
          ;             
          ;             ChangeCurrentElement(widget(), *this\adress)
          ;             MoveElement(widget(), #PB_list_After, *Last\adress)
          ;             
          ;             While PreviousElement(widget()) 
          ;               If Child(widget(), *this)
          ;                 MoveElement(widget(), #PB_list_After, *this\adress)
          ;               EndIf
          ;             Wend
          ;             
          ;             If *this\parent\first = *this
          ;               *this\parent\first = *after
          ;             EndIf
          ;             
          ;               Debug "last - " + *after\index + " " + *this\after\index
          ;             If *this\after
          ;               *this\after\before = *this\before
          ;             EndIf
          ;             
          ;             *this\before = *after
          ;             *this\after = *after\after 
          ;             
          ;             If Not *this\after
          ; ;               If *this\before
          ; ;                 Debug "   this\before " + *this\before\index
          ; ;               EndIf
          ; ;               Debug "   this " + *this\index
          ; ;               If *this\after
          ; ;                 Debug "   this\after " + *this\after\index
          ; ;               EndIf
          ;             
          ;               *this\parent\last = *this
          ;               *this\parent\last\after = 0
          ;             EndIf
          ;           EndIf
          ;                     *Last = GetParentLast(*this\parent)
          ;                     
          ;                     If *Last <> *this
          ;                       Debug  "set Last "
          ;                       SetPosition(*this, #PB_list_After, *last)
          ;                     EndIf
          
      EndSelect
      
      ; PostEvent(#PB_Event_Gadget, *this\root\canvas\window, *this\root\canvas\gadget, #__event_repaint, *this)
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetActive(*this._s_widget)
      Protected result.i
      
      Macro _set_active_state_(_active_, _state_)
        If Not(_active_ = _active_\root And _active_\root\type =- 5)
          If (_state_)
            Events(_active_, #__Event_Focus, Mouse()\x, Mouse()\y)
          Else
            Events(_active_, #__Event_lostFocus, Mouse()\x, Mouse()\y)
          EndIf
          
          PostEvent(#PB_Event_Gadget, _active_\root\canvas\window, _active_\root\canvas\gadget, #__Event_repaint)
        EndIf
        
        If _active_\gadget
          If (_state_)
            Events(_active_\gadget, #__Event_Focus, Mouse()\x, Mouse()\y)
          Else
            Events(_active_\gadget, #__Event_lostFocus, Mouse()\x, Mouse()\y)
          EndIf
        EndIf
      EndMacro
      
      With *this
        If *this\child  
          *this = *this\parent
        EndIf
        
        ;This()\widget = *this
        
        If \type > 0 And GetActive()
          If GetActive()\gadget <> *this
            If GetActive() <> \window
              If _is_widget_(GetActive())
                _set_active_state_(GetActive(), #__s_0)
              EndIf
              
              GetActive() = \window
              GetActive()\gadget = *this
              
              _set_active_state_(GetActive(), #__s_2)
            Else
              If GetActive()\gadget
                Events(GetActive()\gadget, #__Event_lostFocus, Mouse()\x, Mouse()\y)
              EndIf
              
              GetActive()\gadget = *this
              Events(GetActive()\gadget, #__Event_Focus, Mouse()\x, Mouse()\y)
            EndIf
            
            result = #True 
          EndIf
          
        ElseIf GetActive() <> *this
          If _is_widget_(GetActive())
            _set_active_state_(GetActive(), #__s_0)
          EndIf
          
          GetActive() = *this
          _set_active_state_(GetActive(), #__s_2)
          result = #True
        EndIf
        
        SetPosition(GetActive(), #PB_List_Last)
      EndWith
      
      ProcedureReturn result
    EndProcedure
    
    ;- 
    Procedure.i GetItemData(*this._s_widget, item.l)
      Protected result.i
      
      With *This
        Select \type
          Case #PB_GadgetType_Tree,
               #PB_GadgetType_ListView
            
            ;             PushListPosition(*this\row\_s()) 
            ;             ForEach *this\row\_s()
            ;               If *this\row\_s()\index = Item 
            ;                 result = *this\row\_s()\data
            ;                 ; Debug *this\row\_s()\text\string
            ;                 Break
            ;               EndIf
            ;             Next
            ;             PopListPosition(*this\row\_s())
            ; 
            If _no_select_(*this\row\_s(), item)
              ProcedureReturn #False
            EndIf
            
            result = *this\row\_s()\data
        EndSelect
      EndWith
      
      ;     If result
      ;       Protected *w.widget_S = result
      ;       
      ;       Debug "GetItemData " + Item  + " " +  result  + " " +   *w\class
      ;     EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.s GetItemText(*this._s_widget, Item.l, Column.l = 0)
      Protected result.s
      
      If *this\count\items ; row\count
        If _no_select_(*this\row\_s(), Item) 
          ProcedureReturn ""
        EndIf
        
        If *this\type = #__type_property And Column 
          result = *this\row\_s()\text\edit\string
        Else
          result = *this\row\_s()\text\string
        EndIf
      EndIf
      
      If *this\type = #__type_Panel
        result = Tab_GetItemText(*this\gadget[#__panel_1], Item, Column)
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetItemImage(*this._s_widget, Item.l) 
      Protected result
      
      If *this\type = #__type_Editor Or
         *this\type = #__type_property Or
         *this\type = #__type_listview Or
         *this\type = #__type_tree
        
        If _no_select_(*this\row\_s(), Item) 
          ProcedureReturn #PB_Default
        EndIf
        
        result = *this\row\_s()\image\img
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetItemFont(*this._s_widget, Item.l)
      Protected result
      
      If *this\type = #__type_Editor Or
         *this\type = #__type_property Or
         *this\type = #__type_listview Or
         *this\type = #__type_tree
        
        If _no_select_(*this\row\_s(), Item) 
          ProcedureReturn #False
        EndIf
        
        result = *this\row\_s()\text\fontID
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l GetItemState(*this._s_widget, Item.l)
      Protected result
      
      If *this\type = #PB_GadgetType_Editor
        If item =- 1
          ProcedureReturn *this\text\caret\pos
        Else
          ProcedureReturn *this\text\caret\pos[1]
        EndIf
        
      ElseIf *this\type = #PB_GadgetType_Tree
        If _is_item_(*this, item) And SelectElement(*this\row\_s(), Item) 
          If *this\row\_s()\color\state
            result | #__tree_Selected
          EndIf
          
          If *this\row\_s()\box[1]\state
            If *this\mode\threestate And 
               *this\row\_s()\box[1]\state = #PB_Checkbox_Inbetween
              result | #__tree_Inbetween
            Else
              result | #__tree_checked
            EndIf
          EndIf
          
          If *this\row\_s()\childrens And
             *this\row\_s()\box[0]\state = #PB_Checkbox_Unchecked
            result | #__tree_Expanded
          Else
            result | #__tree_collapsed
          EndIf
        EndIf
        
      Else
        ProcedureReturn *this\bar\page\pos
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l GetItemColor(*this._s_widget, Item.l, ColorType.l, Column.l = 0)
      Protected result, *color._s_color
      
      If *this\type = #PB_GadgetType_Editor
        If _is_item_(*this, item) And SelectElement(*this\row\_s(), Item)
          *color = *this\row\_s()\color
        EndIf
      ElseIf *this\type = #PB_GadgetType_Tree 
        If _is_item_(*this, item) And SelectElement(*this\row\_s(), Item)
          *color = *this\row\_s()\color
        EndIf
      Else
        *color = *this\bar\button[Item]\color
      EndIf
      
      Select ColorType
        Case #__color_line  : result = *color\line[Column]
        Case #__color_back  : result = *color\back[Column]
        Case #__color_front : result = *color\front[Column]
        Case #__color_frame : result = *color\frame[Column]
      EndSelect
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i GetItemAttribute(*this._s_widget, Item.l, Attribute.l, Column.l = 0)
      Protected result
      
      If *this\type = #__type_tree
        If _no_select_(*this\row\_s(), Item)
          ProcedureReturn #False
        EndIf
        
        Select Attribute
          Case #__tree_sublevel
            result = *this\row\_s()\sublevel
        EndSelect
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    ;- 
    Procedure.i SetItemData(*This._s_widget, item.l, *data)
      Protected result.i
      
      If *this\count\items ; *this\type = #__type_tree
                           ;Item = *this\row\i(Hex(Item))
        
        If _no_select_(*this\row\_s(), item)
          ProcedureReturn #False
        EndIf
        
        *this\row\_s()\data = *Data
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l SetItemText(*this._s_widget, Item.l, Text.s, Column.l = 0)
      Protected result
      
      If *this\type = #__type_tree Or 
         *this\type = #__type_property
        
        ;Item = *this\row\i(Hex(Item))
        
        If _no_select_(*this\row\_s(), item)
          ProcedureReturn #False
        EndIf
        
        Protected row_count = CountString(Text.s, #LF$)
        
        If Not row_count
          *this\row\_s()\text\string = Text.s
        Else
          *this\row\_s()\text\string = StringField(Text.s, 1, #LF$)
          *this\row\_s()\text\edit\string = StringField(Text.s, 2, #LF$)
        EndIf
        
        *this\row\_s()\text\change = 1
        *this\change = 1
        result = #True
        
      ElseIf *this\type = #__type_Panel
        result = SetItemText(*this\gadget[#__panel_1], Item, Text, Column)
        
      ElseIf *this\type = #__type_tabBar
        If _is_item_(*this, Item) And
           SelectElement(*this\bar\_s(), Item) And 
           *this\bar\_s()\text\string <> Text 
          *this\bar\_s()\text\string = Text 
          *this\bar\_s()\text\change = 1
          *this\change = 1
          result = #True
        EndIf
        
      Else
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetItemImage(*this._s_widget, Item.l, Image.i) 
      Protected result
      
      If *this\type = #__type_tree
        If _is_item_(*this, item) And SelectElement(*this\row\_s(), Item)
          If *this\row\_s()\image\img <> Image
            _set_image_(*this, *this\row\_s()\Image, Image)
            _repaint_items_(*this)
          EndIf
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetItemFont(*this._s_widget, Item.l, Font.i)
      Protected result, FontID.i = FontID(Font)
      
      If *this\type = #__type_Editor Or 
         *this\type = #__type_property Or 
         *this\type = #__type_listview Or 
         *this\type = #__type_tree
        
        If _is_item_(*this, item) And 
           SelectElement(*this\row\_s(), Item) And 
           *this\row\_s()\text\fontID <> FontID
          *this\row\_s()\text\fontID = FontID
          ;       *this\row\_s()\text\change = 1
          ;       *this\change = 1
          result = #True
        EndIf 
        
      ElseIf *this\type = #__type_Panel
        If _is_item_(*this\gadget[#__panel_1], item) And 
           SelectElement(*this\gadget[#__panel_1]\bar\_s(), Item) And 
           *this\gadget[#__panel_1]\bar\_s()\text\fontID <> FontID
          *this\gadget[#__panel_1]\bar\_s()\text\fontID = FontID
          ;       *this\row\_s()\text\change = 1
          ;       *this\change = 1
          result = #True
        EndIf 
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.b SetItemState(*this._s_widget, Item.l, State.b)
      Protected result
      
      If *this\type = #__type_Window
        ; result = Window_SetState(*this, state)
        
      ElseIf *this\type = #__type_Editor
        result = Editor_SetItemState(*this, Item, state)
        
      ElseIf *this\type = #__type_tree
        result = Tree_SetItemState(*this, Item, state)
        
      ElseIf *this\type = #__type_Panel
        ; result = Panel_SetItemState(*this, state)
        
      Else
        ; result = Bar_SetState(*this, state)
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.l _SetItemColor(*this._s_widget, Item.l, ColorType.l, Color.l, Column.l = 0)
      Protected result
      
      With *this
        If Item =- 1
          PushListPosition(\row\_s()) 
          ForEach \row\_s()
            Select ColorType
              Case #__color_back
                \row\_s()\color\back[Column] = Color
                
              Case #__color_Front
                \row\_s()\color\front[Column] = Color
                
              Case #__color_Frame
                \row\_s()\color\frame[Column] = Color
                
              Case #__color_line
                \row\_s()\color\line[Column] = Color
                
            EndSelect
          Next
          PopListPosition(\row\_s()) 
          
        Else
          If _is_item_(*this, item) And SelectElement(*this\row\_s(), Item)
            Select ColorType
              Case #__color_back
                \row\_s()\color\back[Column] = Color
                
              Case #__color_front
                \row\_s()\color\front[Column] = Color
                
              Case #__color_frame
                \row\_s()\color\frame[Column] = Color
                
              Case #__color_line
                \row\_s()\color\line[Column] = Color
                
            EndSelect
          EndIf
        EndIf
      EndWith
      
    EndProcedure
    
    Procedure.l SetItemColor(*this._s_widget, Item.l, ColorType.l, Color.l, Column.l = 0)
      Protected result
      
      If *this\type = #__type_tree Or 
         *this\type = #__type_Editor
        
        result = _SetItemColor(*this, Item.l, ColorType.l, Color.l, Column.l)
        
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i SetItemAttribute(*this._s_widget, Item.l, Attribute.l, *value, Column.l = 0)
      Protected result
      
      If *this\type = #__type_Window
        
      ElseIf *this\type = #__type_tree
        Select Attribute
          Case #__tree_collapsed
            *this\mode\collapse = Bool(Not *value) 
            
          Case #__tree_OptionBoxes
            *this\mode\check = Bool(*value)*2
            
        EndSelect
        
      ElseIf *this\type = #__type_Editor
        
      ElseIf *this\type = #__type_Panel
        
      Else
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    
    ;- 
    ;-  CREATEs
    Procedure.i _create_list(*parent._s_widget, class.s, type.l, x.l,y.l,width.l,height.l, *param_1, *param_2, *param_3, size.l, flag.i = 0, round.l = 7, ScrollStep.f = 1.0)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      
      If *this
        With *this
          *this\x[#__c_frame] =- 2147483648
          *this\y[#__c_frame] =- 2147483648
          
          *this\type = type
          *this\class = class
          
          ;*this\_state = #__s_front
          *this\color\alpha = 255
          *this\color\fore[#__s_0] =- 1
          *this\color\back[#__s_0] = $ffffffff ; _get_colors_()\fore
          *this\color\front[#__s_0] = _get_colors_()\front
          *this\color\frame[#__s_0] = _get_colors_()\frame
          
          *this\row\index =- 1
          *this\change = 1
          
          *this\interact = 1
          ;*this\round = round
          
          *this\text\change = 1 
          *this\text\height = 18 
          
          *this\image\padding\x = 2
          *this\text\padding\x = 4
          
          ;*this\vertical = Bool(Flag&#__flag_vertical)
          *this\fs = Bool(Not Flag&#__flag_borderLess)*2
          *this\bs = *this\fs
          
          If flag & #__flag_nolines
            flag &~ #__flag_nolines
          Else
            flag | #__flag_nolines
          EndIf
          
          If flag & #__flag_nogadgets
            flag &~ #__flag_nogadgets
          Else
            flag | #__flag_nogadgets
          EndIf
          
          If flag
            Flag(*this, flag, #True)
          EndIf
          
          _set_align_flag_(*this, *parent, flag)
          SetParent(*this, *parent, #PB_Default)
          
          If flag & #__flag_noscrollbars = #False
            Area(*this, 1, width, height, width, height, Bool((\mode\buttons = 0 And \mode\lines = 0) = 0))
          EndIf
          Resize(*this, X,Y,Width,Height)
        EndWith
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Create(*parent._s_widget, class.s, type.l, x.l,y.l,width.l,height.l, *param_1, *param_2, *param_3, size.l, flag.i = 0, round.l = 7, ScrollStep.f = 1.0)
      Protected ScrollBars, *this._structure_(widget) ; _s_widget = AllocateStructure(_s_widget)
      
      With *this
        
        *this\x[#__c_frame] =- 2147483648
        *this\y[#__c_frame] =- 2147483648
        *this\type = type
        *this\round = round
        
        *this\bar\from =- 1
        *this\bar\index =- 1
        *this\index[#__s_1] =- 1
        *this\index[#__s_2] =- 1
        
        ; *this\adress = *this
        ; *this\class = #PB_compiler_Procedure
        *this\color = _get_colors_()
        
        ; - Create Texts
        If *this\type = #PB_GadgetType_Text Or
           *this\type = #PB_GadgetType_Editor Or
           *this\type = #PB_GadgetType_String Or
           *this\type = #PB_GadgetType_Button Or
           *this\type = #PB_GadgetType_Option
          
          
        EndIf
        
        ; - Create Containers
        If *this\type = #PB_GadgetType_Container Or
           *this\type = #PB_GadgetType_ScrollArea Or
           *this\type = #PB_GadgetType_Panel Or
           *this\type = #PB_GadgetType_MDI
          
          *this\index[#__s_1] =- 1
          *this\index[#__s_2] = 0
          *this\container = *this\type
          *this\color\back = $FFF9F9F9
          
          If *this\type = #PB_GadgetType_MDI
            ScrollBars = 1
            *this\fs = Bool(Not Flag&#__flag_borderLess) * #__border_scroll
            *this\class = "MDI"
          EndIf
          
          If *this\type = #PB_GadgetType_ScrollArea
            ScrollBars = 1
            *this\bar\increment = ScrollStep
            *this\fs = Bool(Not Flag&#__flag_borderLess) * #__border_scroll
            *this\class = "ScrollArea"
          EndIf
          
          If *this\type = #PB_GadgetType_Container 
            *this\class = "Container"
            *this\fs = 1
          EndIf
          
          If *this\type = #PB_GadgetType_Panel 
            If Flag & #__bar_vertical = #False
              *this\__height = 25
            Else
              *this\__width = 85
            EndIf
            
            *this\index[#__panel_1] = 0
            *this\index[#__panel_2] = 0
            *this\class = "Panel"
            *this\fs = 1
          EndIf
        EndIf
        
        ; - Create image
        If *this\type = #PB_GadgetType_Image
          ScrollBars = 1
          *this\class = "Image"
          *this\_flag = Flag
      
          If *this\image\img <> *param_3
            _set_image_(*this, *this\Image, *param_3)
          EndIf
          
          _set_align_(*this\image, 
                      constants::_check_(Flag, #__flag_left),
                      constants::_check_(Flag, #__flag_top),
                      constants::_check_(Flag, #__flag_right),
                      constants::_check_(Flag, #__flag_bottom),
                      constants::_check_(Flag, #__flag_center))
          
          *param_1 = *this\image\width 
          *param_2 = *this\image\height 
          
          *this\color\back = $FFF9F9F9
          *this\index[#__s_1] =- 1
          *this\index[#__s_2] = 0
          
          *this\fs = Bool(Not Flag&#__flag_borderLess) * #__border_scroll
        EndIf
        
        ; - Create Bars
        If *this\type = #PB_GadgetType_ScrollBar Or 
           *this\type = #PB_GadgetType_ProgressBar Or
           *this\type = #PB_GadgetType_TrackBar Or
           *this\type = #PB_GadgetType_TabBar Or
           *this\type = #PB_GadgetType_Spin Or
           *this\type = #PB_GadgetType_Splitter
          
          ; - Create Scroll
          If *this\type = #PB_GadgetType_ScrollBar
            *this\class = "Scroll"
            *this\bar\increment = ScrollStep
            
            *this\color\back = $FFF9F9F9 ; - 1 
            *this\color\front = $FFFFFFFF
            *this\bar\button[#__b_1]\color = _get_colors_()
            *this\bar\button[#__b_2]\color = _get_colors_()
            *this\bar\button[#__b_3]\color = _get_colors_()
            
            *this\bar\inverted = Bool(Flag & #__bar_Inverted = #__bar_Inverted)
            
            If Flag & #PB_ScrollBar_Vertical = #PB_ScrollBar_Vertical Or
               Flag & #__bar_vertical = #__bar_vertical
              *this\vertical = #True
            EndIf
            
            *this\bar\button[#__b_3]\len = size
            
            If Not Flag & #__bar_nobuttons = #__bar_nobuttons
              *this\bar\button[#__b_1]\len =- 1
              *this\bar\button[#__b_2]\len =- 1
            EndIf
            
            *this\bar\button[#__b_1]\interact = #True
            *this\bar\button[#__b_2]\interact = #True
            *this\bar\button[#__b_3]\interact = #True
            
            *this\bar\button[#__b_1]\round = *this\round
            *this\bar\button[#__b_2]\round = *this\round
            *this\bar\button[#__b_3]\round = *this\round
            
            *this\bar\button[#__b_1]\arrow\type = #__arrow_type ; -1 0 1
            *this\bar\button[#__b_2]\arrow\type = #__arrow_type ; -1 0 1
            
            *this\bar\button[#__b_1]\arrow\size = #__arrow_size
            *this\bar\button[#__b_2]\arrow\size = #__arrow_size
            *this\bar\button[#__b_3]\arrow\size = 3
          EndIf
          
          ; - Create Spin
          If *this\type = #PB_GadgetType_Spin
            *this\class = "Spin"
            *this\bar\increment = ScrollStep
            
            *this\color\back =- 1 
            *this\bar\button[#__b_1]\color = _get_colors_()
            *this\bar\button[#__b_2]\color = _get_colors_()
            ;*this\bar\button[#__b_3]\color = _get_colors_()
            
            *this\bar\inverted = Bool(Flag & #__bar_Inverted = #__bar_Inverted)
            
            If Not (Flag & #PB_Splitter_Vertical = #PB_Splitter_Vertical Or
                    Flag & #__bar_vertical = #__bar_vertical)
              *this\vertical = #True
              *this\bar\inverted = #True
            EndIf
            
            *this\fs = Bool(Not Flag&#__flag_borderless)
            *this\bs = *this\fs
            
            ; *this\text = AllocateStructure(_s_text)
            *this\text\change = 1
            *this\text\editable = 1
            *this\text\align\top = 1
            
            *this\text\padding\x = #__spin_padding_text
            *this\text\padding\y = #__spin_padding_text
            
            *this\color = _get_colors_()
            *this\color\alpha = 255
            *this\color\back = $FFFFFFFF
            
            *this\bar\button[#__b_1]\interact = #True
            *this\bar\button[#__b_2]\interact = #True
            ;*this\bar\button[#__b_3]\interact = #True
            
            If *this\vertical
              *this\bar\button[#__b_3]\len = Size + 2
            Else
              *this\bar\button[#__b_3]\len = Size*2 + 3
            EndIf
            
            *this\bar\button[#__b_1]\len = Size
            *this\bar\button[#__b_2]\len = Size
            
            *this\bar\button[#__b_1]\arrow\size = #__arrow_size
            *this\bar\button[#__b_2]\arrow\size = #__arrow_size
            
            *this\bar\button[#__b_1]\arrow\type = #__arrow_type ; -1 0 1
            *this\bar\button[#__b_2]\arrow\type = #__arrow_type ; -1 0 1
            
            _set_text_flag_(*this, flag)
            
          EndIf
          
          ; - Create Tab
          If *this\type = #PB_GadgetType_TabBar
            *this\class = "Tab"
            *this\bar\increment = ScrollStep
            
            ;;*this\text\change = 1
            *this\index[#__s_2] = 0 ; default selected tab
            
            *this\color\back =- 1 
            *this\bar\button[#__b_1]\color = _get_colors_()
            *this\bar\button[#__b_2]\color = _get_colors_()
            ;*this\bar\button[#__b_3]\color = _get_colors_()
            
            *this\bar\inverted = Bool(Flag & #__bar_Inverted = #False)
            
            If Flag & #__bar_vertical = #__bar_vertical
              *this\vertical = #True
            EndIf
            
            If Not Flag & #__bar_nobuttons = #__bar_nobuttons
              *this\bar\button[#__b_3]\len = size
              *this\bar\button[#__b_1]\len = 15
              *this\bar\button[#__b_2]\len = 15
            EndIf
            
            ;*this\__height = size
            *this\bs = 1 + Bool(Flag & #__bar_child = #False)
            
            *this\bar\button[#__b_1]\interact = #True
            *this\bar\button[#__b_2]\interact = #True
            *this\bar\button[#__b_3]\interact = #True
            
            *this\bar\button[#__b_1]\round = 7
            *this\bar\button[#__b_2]\round = 7
            *this\bar\button[#__b_3]\round = *this\round
            
            *this\bar\button[#__b_1]\arrow\type = #__arrow_type ; -1 0 1
            *this\bar\button[#__b_2]\arrow\type = #__arrow_type ; -1 0 1
            
            *this\bar\button[#__b_1]\arrow\size = #__arrow_size
            *this\bar\button[#__b_2]\arrow\size = #__arrow_size
            ;*this\bar\button[#__b_3]\arrow\size = 3
            
            _set_text_flag_(*this, flag)
          EndIf
          
          ; - Create Track
          If *this\type = #PB_GadgetType_TrackBar
            *this\class = "Track"
            *this\bar\increment = ScrollStep
            
            *this\color\back =- 1 
            *this\bar\button[#__b_1]\color = _get_colors_()
            *this\bar\button[#__b_2]\color = _get_colors_()
            *this\bar\button[#__b_3]\color = _get_colors_()
            
            *this\bar\inverted = Bool(Flag & #__bar_Inverted = #__bar_Inverted)
            
            If Flag & #PB_TrackBar_Vertical = #PB_TrackBar_Vertical Or
               Flag & #__bar_vertical = #__bar_vertical
              *this\vertical = #True
              *this\bar\inverted = Bool(Not Flag & #__bar_Inverted)
            Else
              *this\bar\inverted = Bool(Flag & #__bar_Inverted = #__bar_Inverted)
            EndIf
            
            If flag & #PB_TrackBar_Ticks = #PB_TrackBar_Ticks Or
               Flag & #__bar_ticks = #__bar_ticks
              *this\bar\mode = #PB_TrackBar_Ticks
            EndIf
            
            *this\bar\button[#__b_1]\interact = #True
            *this\bar\button[#__b_2]\interact = #True
            *this\bar\button[#__b_3]\interact = #True
            
            *this\bar\button[#__b_3]\arrow\size = #__arrow_size
            *this\bar\button[#__b_3]\arrow\type = #__arrow_type
            
            *this\bar\button[#__b_1]\round = 2
            *this\bar\button[#__b_2]\round = 2
            *this\bar\button[#__b_3]\round = *this\round
            
            If *this\round < 7
              *this\bar\button[#__b_3]\len = 9
            Else
              *this\bar\button[#__b_3]\len = 15
            EndIf
            
            _set_text_flag_(*this, flag)
            
          EndIf
          
          ; - Create Progress
          If *this\type = #PB_GadgetType_ProgressBar
            *this\class = "Progress"
            *this\bar\increment = ScrollStep
            
            *this\color\back =- 1 
            *this\bar\button[#__b_1]\color = _get_colors_()
            *this\bar\button[#__b_2]\color = _get_colors_()
            ;*this\bar\button[#__b_3]\color = _get_colors_()
            
            
            If Flag & #PB_ProgressBar_Vertical = #PB_ProgressBar_Vertical Or
               Flag & #__bar_vertical = #__bar_vertical
              *this\vertical = #True
              *this\bar\inverted = Bool(Not Flag & #__bar_Inverted)
            Else
              *this\bar\inverted = Bool(Flag & #__bar_Inverted = #__bar_Inverted)
            EndIf
            
            *this\bar\button[#__b_1]\round = *this\round
            *this\bar\button[#__b_2]\round = *this\round
            
            *this\text\change = #True
            _set_text_flag_(*this, flag|#__text_center)
          EndIf
          
          ; - Create Splitter
          If *this\type = #PB_GadgetType_Splitter
            *this\class = "Splitter"
            *this\bar\increment = ScrollStep
            
            *this\color\back =- 1
            
            ;         *this\bar\button[#__b_1]\color = _get_colors_()
            ;         *this\bar\button[#__b_2]\color = _get_colors_()
            ;         *this\bar\button[#__b_3]\color = _get_colors_()
            
            ;;Debug ""+*param_1 +" "+ IsGadget(*param_1)
            
            *this\container =- *this\type 
            *this\gadget[#__split_1] = *param_1
            *this\gadget[#__split_2] = *param_2
            *this\index[#__split_1] = Bool(IsGadget(*this\gadget[#__split_1]))
            *this\index[#__split_2] = Bool(IsGadget(*this\gadget[#__split_2]))
            
            *this\bar\inverted = Bool(Flag & #__bar_Inverted = #__bar_Inverted)
            
            If flag & #PB_Splitter_Separator = #PB_Splitter_Separator
              *this\bar\mode = #PB_Splitter_Separator
            EndIf
            
            If (Flag & #PB_Splitter_Vertical = #PB_Splitter_Vertical Or
                Flag & #__bar_vertical = #__bar_vertical)
              *this\cursor = #PB_Cursor_LeftRight
            Else
              *this\vertical = #True
              *this\cursor = #PB_Cursor_UpDown
            EndIf
            
            If Flag & #PB_Splitter_FirstFixed = #PB_Splitter_FirstFixed
              *this\bar\fixed = #__split_1 
            ElseIf Flag & #PB_Splitter_SecondFixed = #PB_Splitter_SecondFixed
              *this\bar\fixed = #__split_2 
            EndIf
            
            *this\bar\button[#__b_3]\len = #__splitter_buttonsize
            *this\bar\button[#__b_3]\interact = #True
            *this\bar\button[#__b_3]\round = 2
            
          Else
            If *param_1 
              SetAttribute(*this, #__bar_minimum, *param_1) 
            EndIf
            If *param_2 
              SetAttribute(*this, #__bar_maximum, *param_2) 
            EndIf
            If *param_3 
              SetAttribute(*this, #__bar_pageLength, *param_3) 
            EndIf
          EndIf
        EndIf
        
        ;
        If Flag & #__bar_child = #__bar_child
          *this\parent = *parent
          *this\root = *parent\root
          *this\window = *parent\window
          ; 
          *this\index = *parent\index
          *this\adress = *parent\adress
          
          *this\child = #True
        Else
          _set_align_flag_(*this, *parent, flag)
          
          If *parent
            SetParent(*this, *parent, #PB_Default)
          Else
            *this\draw = 1
          EndIf
          
          If *this\type = #PB_GadgetType_Splitter
            If *this\gadget[#__split_1] And Not *this\index[#__split_1]
              SetParent(*this\gadget[#__split_1], *this)
            EndIf
            
            If *this\gadget[#__split_2] And Not *this\index[#__split_2]
              SetParent(*this\gadget[#__split_2], *this)
            EndIf
          EndIf
          
          If *this\type = #PB_GadgetType_Panel 
            *this\gadget[#__panel_1] = Create(*this, "PanelTabBar", #__type_tabBar, 0,0,0,0, 0,0,0, 0, Flag|#__bar_child, 0, 30)
          EndIf
          
          If *this\container And 
             *this\type <> #PB_GadgetType_Splitter And 
             flag & #__flag_nogadgets = #False
            OpenList(*this)
          EndIf
          
          If ScrollBars And 
             flag & #__flag_noscrollbars = #False
            Area(*this, ScrollStep, *param_1, *param_2, 0, 0)
            ; Area(*this, ScrollStep, *param_1, *param_2, width, height)
          EndIf
          
          
          ; this before resize() and after setparent()
          If Bool(flag & #__flag_anchorsGadget = #__flag_anchorsGadget)
            a_add(*this)
          EndIf
          
          If *this\fs And Not *this\transform
            *this\bs = *this\fs
          EndIf
          
          Resize(*this, x,y,width,height)
          
          If ScrollBars And 
             flag & #__flag_noscrollbars = #False
            ; ;             *this\x[#__c_required] = *this\x[#__c_inner]
            ; ;             *this\y[#__c_required] = *this\y[#__c_inner] 
            *this\width[#__c_required] = *param_1
            *this\height[#__c_required] = *param_2
          EndIf
          
        EndIf
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Tab(x.l,y.l,width.l,height.l, Min.l,Max.l,PageLength.l, Flag.i = 0, round.l = 0)
      ProcedureReturn Create(Opened(), #PB_Compiler_Procedure, #__type_TabBar, x,y,width,height, min,max,pagelength, 40, flag, round, 40)
    EndProcedure
    
    Procedure.i Spin(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i = 0, round.l = 0, Increment.f = 1.0)
      ProcedureReturn Create(Opened(), #PB_Compiler_Procedure, #__type_Spin, x,y,width,height, min,max,0, #__spin_buttonsize, flag, round, Increment)
    EndProcedure
    
    Procedure.i Scroll(x.l,y.l,width.l,height.l, Min.l,Max.l,PageLength.l, Flag.i = 0, round.l = 0)
      ProcedureReturn Create(Opened(), #PB_Compiler_Procedure, #__type_ScrollBar, x,y,width,height, min,max,pagelength, #__scroll_buttonsize, flag, round, 1)
    EndProcedure
    
    Procedure.i Track(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i = 0, round.l = 7)
      ProcedureReturn Create(Opened(), #PB_Compiler_Procedure, #__type_TrackBar, x,y,width,height, min,max,0,0, flag, round, 1)
    EndProcedure
    
    Procedure.i Progress(x.l,y.l,width.l,height.l, Min.l,Max.l, Flag.i = 0, round.l = 0)
      ProcedureReturn Create(Opened(), #PB_Compiler_Procedure, #__type_ProgressBar, x,y,width,height, min,max,0,0, flag, round, 1)
    EndProcedure
    
    Procedure.i Splitter(x.l,y.l,width.l,height.l, First.i,Second.i, Flag.i = 0)
      ProcedureReturn Create(Opened(), #PB_Compiler_Procedure, #__type_Splitter, x,y,width,height, First,Second, 0,0, flag, 0, 1)
    EndProcedure
    
    
    
    ;- 
    Procedure.i Tree(x.l,y.l,width.l,height.l, Flag.i = 0)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      Protected *parent._s_widget = Opened()
      
      If *this
        With *this
          *this\x[#__c_frame] =- 2147483648
          *this\y[#__c_frame] =- 2147483648
          
          If Flag & #__tree_property
            *this\type = #__type_property
            *this\class = "Property"
            *this\bar\page\pos = 60
            
          ElseIf Flag & #__tree_listview
            *this\type = #PB_GadgetType_ListView
            *this\class = "ListView"
            
          Else
            *this\type = #PB_GadgetType_Tree
            *this\class = #PB_Compiler_Procedure
          EndIf
          
          ;*this\_state = #__s_front
          *this\color\alpha = 255
          *this\color\fore[#__s_0] =- 1
          *this\color\back[#__s_0] = $ffffffff ; _get_colors_()\fore
          *this\color\front[#__s_0] = _get_colors_()\front
          *this\color\frame[#__s_0] = _get_colors_()\frame
          
          *this\row\index =- 1
          *this\change = 1
          
          *this\interact = 1
          ;*this\round = round
          
          *this\text\change = 1 
          *this\text\height = 18 
          
          *this\image\padding\x = 2
          *this\text\padding\x = 4
          
          ;*this\vertical = Bool(Flag&#__flag_vertical)
          *this\fs = Bool(Not Flag&#__flag_borderLess)*2
          *this\bs = *this\fs
          
          If flag & #__tree_NoLines
            flag &~ #__tree_NoLines
          Else
            flag | #__tree_NoLines
          EndIf
          
          If flag & #__tree_NoButtons
            flag &~ #__tree_NoButtons
          Else
            flag | #__tree_NoButtons
          EndIf
          
          If flag
            Flag(*this, flag, #True)
          EndIf
          
          _set_align_flag_(*this, *parent, flag)
          SetParent(*this, *parent, #PB_Default)
          
          If flag & #__flag_noscrollbars = #False
            Area(*this, 1, width, height, width, height, Bool((\mode\buttons = 0 And \mode\lines = 0) = 0))
          EndIf
          Resize(*this, X,Y,Width,Height)
        EndWith
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i ListView(x.l,y.l,width.l,height.l, Flag.i = 0)
      ProcedureReturn Tree(x,y,width,height, Flag|#__tree_nobuttons|#__tree_nolines|#__tree_listview)
    EndProcedure
    
    Procedure.i ListIcon(x.l,y.l,width.l,height.l, ColumnTitle.s, ColumnWidth.i, flag.i=0)
      ProcedureReturn Tree(x,y,width,height, Flag|#__tree_property)
    EndProcedure
    
    Procedure.i Tree_Properties(x.l,y.l,width.l,height.l, Flag.i = 0)
      ProcedureReturn Tree(x,y,width,height, Flag|#__tree_property)
    EndProcedure
    
    
    ;- 
    Procedure.i _text(*parent._s_widget, class.s, type.l, x.l, y.l, width.l, height.l, text.s, flag.i = 0, round.i = 0, color.i = 0)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      
      *this\type = type
      *this\class = class
      *this\round = round
      
      ; flag
      If *this\type = #__Type_Editor
        *this\_flag = Flag|#__text_left|#__text_top
        
      ElseIf *this\type = #__type_Option Or 
             *this\type = #__type_checkBox Or 
             *this\type = #__Type_String
        
        If Not flag & #__text_center
          *this\_flag = flag|#__text_center|#__text_left
        Else
          *this\_flag = flag|#__text_center
        EndIf
        
      ElseIf *this\type = #__type_button Or 
             *this\type = #__type_HyperLink
        
        *this\_flag = Flag|#__text_center
        
      EndIf
      
      
      If Flag & #__flag_vertical = #__flag_vertical
        *this\vertical = #True
      EndIf
      
      *this\mode\threestate = constants::_check_(Flag, #PB_CheckBox_ThreeState)
      
      *this\bs = *this\fs
      *this\color\fore[#__s_0] =- 1
      *this\color\back[#__s_0] = _get_colors_()\fore
      *this\color\front[#__s_0] = _get_colors_()\front
      
      
      If *this\type = #PB_GadgetType_Editor Or 
         *this\type = #PB_GadgetType_String
        *this\color = _get_colors_()
        *this\color\back = $FFF9F9F9
      EndIf
      
      
      
      If *this\type = #PB_GadgetType_Editor
        *this\index[#__s_1] =- 1
        *this\index[#__s_2] = *this\index[#__s_1]
        
        ; PB 
        *this\fs = constants::_check_(Flag, #__flag_borderLess, #False) * #__border_scroll
        
        *this\mode\check = 3 ; multiselect
        *this\mode\fullselection = constants::_check_(Flag, #__flag_fullselection, #False)*7
        *this\mode\alwaysselection = constants::_check_(Flag, #__flag_alwaysselection)
        *this\mode\gridlines = constants::_check_(Flag, #__flag_gridlines)
        
        *this\row\margin\hide = constants::_check_(Flag, #__text_numeric, #False)
        *this\row\margin\color\front = $C8000000 ; \color\back[0] 
        *this\row\margin\color\back = $C8F0F0F0  ; \color\back[0] 
      EndIf
      
      If *this\type = #PB_GadgetType_String
        If Not Flag & #__flag_borderLess
          *this\fs = 1
          *this\color\frame = _get_colors_()\frame
        EndIf
        
        *this\text\caret\x = *this\text\padding\X
        
        Text = RemoveString(Text, #LF$) ; +  #LF$
      EndIf
      
      ; - Create Text
      If *this\type = #PB_GadgetType_Text
        If Flag & #__text_border = #__text_border 
          *this\fs = 1
          *this\color\frame = _get_colors_()\frame
        EndIf
        
      EndIf
      
      ; - Create Button
      If *this\type = #PB_GadgetType_Button
        *this\_state = #__s_front|#__s_back|#__s_frame
        
        *this\fs = 1
        *this\color = _get_colors_()
      EndIf
      
      If *this\type = #__type_Option Or 
         *this\type = #__type_checkBox Or 
         *this\type = #__type_HyperLink
        
        *this\button\color = _get_colors_()
        *this\button\color\back = $ffffffff
      EndIf
      
      If *this\type = #__type_Option Or 
         *this\type = #__type_checkBox 
        *this\button\width = 15
        *this\button\height = *this\button\width
      EndIf
      
      If *this\type = #__type_Option
        *this\button\round = *this\button\width/2
      EndIf
      
      If *this\type = #__type_checkBox
        *this\button\round = 2
      EndIf
      
      If *this\type = #__type_HyperLink
        *this\_state = #__s_front
        *this\cursor = #PB_Cursor_Hand
        
        *this\mode\lines = constants::_check_(Flag, #PB_HyperLink_Underline)
        *this\color\front[#__s_1] = Color
      EndIf
      
      
      If *this\type = #__type_Option
        If Root()\count\childrens
          If widget()\type = #__type_Option
            *this\_group = widget()\_group 
          Else
            *this\_group = widget() 
          EndIf
        Else
          *this\_group = Opened()
        EndIf
      EndIf
      
      _set_align_flag_(*this, *parent, flag)
      SetParent(*this, *parent, #PB_Default)
      
      If Bool(flag & #__flag_anchorsGadget = #__flag_anchorsGadget)
        a_add(*this)
      EndIf
      
      If flag & #__flag_noscrollbars = #False
        Area(*this,1,0,0,0,0)
      EndIf
      
      Resize(*this, x,y,width,height)
      
      ; text
      _set_text_flag_(*this, *this\_flag)
      
      *this\change = 1
      
      If *this\type = #PB_GadgetType_Text
        *this\text\padding\x = 1
      ElseIf *this\type = #PB_GadgetType_Button
        *this\text\padding\x = 4
        *this\text\padding\y = 4
      ElseIf *this\type = #PB_GadgetType_Editor
        *this\text\padding\y = 6
        *this\text\padding\x = 6
      ElseIf *this\type = #PB_GadgetType_String
        *this\text\padding\x = 3
        *this\text\padding\y = 0
        
      ElseIf *this\type = #__type_Option Or 
             *this\type = #__type_checkBox 
        *this\text\padding\x = *this\button\width + 8
      EndIf
      
      
      ; multiline
      If *this\type = #__type_text
        *this\text\multiLine =- 1
        
      ElseIf *this\type = #__type_Option Or 
             *this\type = #__type_checkBox Or 
             *this\type = #__type_HyperLink
        ; wrap text
        *this\text\multiline =- CountString(Text, #LF$)
        
      ElseIf *this\type = #__type_Editor
        If Not *this\text\multiLine
          *this\text\multiLine = 1
        EndIf
        
      ElseIf *this\type = #__type_string
        *this\text\multiLine = 0
      EndIf
      
      If Text.s
        SetText(*this, Text.s)
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Editor(X.l, Y.l, Width.l, Height.l, Flag.i = 0, round.i = 0)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      Protected *parent._s_widget = Opened()
      
      *this\round = round
      *this\_flag = Flag|#__text_left|#__text_top
      *this\x[#__c_frame] =- 2147483648
      *this\y[#__c_frame] =- 2147483648
      *this\type = #PB_GadgetType_Editor
      *this\color = _get_colors_()
      *this\color\back = $FFF9F9F9
      
      If Flag & #__flag_vertical = #__flag_vertical
        *this\vertical = #True
      EndIf
      
      
      ; - Create Text
      If *this\type = #PB_GadgetType_Editor
        *this\class = "Text"
        ; *this\color\back =- 1 
        
        *this\index[#__s_1] =- 1
        *this\index[#__s_2] = *this\index[#__s_1]
        
        ; PB 
        *this\fs = constants::_check_(Flag, #__flag_borderLess, #False) * #__border_scroll
        *this\bs = *this\fs
        
        ;If *this\vertical
        *this\text\padding\y = 6
        ;Else
        *this\text\padding\x = 6
        ;EndIf
        
        *this\mode\check = 3 ; multiselect
        *this\mode\fullselection = constants::_check_(Flag, #__flag_fullselection, #False)*7
        *this\mode\alwaysselection = constants::_check_(Flag, #__flag_alwaysselection)
        *this\mode\gridlines = constants::_check_(Flag, #__flag_gridlines)
        
        *this\row\margin\hide = constants::_check_(Flag, #__text_numeric, #False)
        *this\row\margin\color\front = $C8000000 ; \color\back[0] 
        *this\row\margin\color\back = $C8F0F0F0  ; \color\back[0] 
        
        _set_text_flag_(*this, flag)
        If Not *this\text\multiLine
          *this\text\multiLine = 1
        EndIf
        *this\change = 1
      EndIf
      
      _set_align_flag_(*this, *parent, flag)
      SetParent(*this, *parent, #PB_Default)
      
      Area(*this,1,0,0,0,0)
      Resize(*this, x,y,width,height)
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i String(x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, round.l = 0)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      Protected *parent._s_widget = Opened()
      
      *this\round = round
      *this\x[#__c_frame] =- 2147483648
      *this\y[#__c_frame] =- 2147483648
      *this\type = #__type_String
      *this\color = _get_colors_()
      *this\color\fore =- 1
      *this\color\back = $FFF9F9F9
      
      If Flag & #__flag_vertical = #__flag_vertical
        *this\vertical = #True
      EndIf
      
      If *this\text\multiline
        *this\row\margin\hide = 0;Bool(Not Flag&#__string_numeric)
        *this\row\margin\color\front = $C8000000 ; \color\back[0] 
        *this\row\margin\color\back = $C8F0F0F0  ; \color\back[0] 
      Else
        *this\row\margin\hide = 1
        *this\text\numeric = Bool(Flag&#__string_numeric)
      EndIf
      
      _set_text_flag_(*this, flag|#__text_center| (Bool(Not flag & #__text_center) * #__text_left))
      
      ; - Create Text
      If *this\type = #PB_GadgetType_String
        *this\class = "String"
        ; *this\color\back =- 1 
        
        ; PB 
        If Flag & #__flag_borderless = #False
          *this\fs = 1
          *this\bs = *this\fs
        EndIf
        
        *this\text\padding\X = 3
        *this\text\padding\y = 0
        *this\text\caret\x = *this\text\padding\X
        
        *this\text\multiline = 0
        Text = RemoveString(Text, #LF$) ; +  #LF$
        
        SetText(*This, Text)
      EndIf
      
      _set_align_flag_(*this, *parent, flag)
      SetParent(*this, *parent, #PB_Default)
      
      If Bool(flag & #__flag_anchorsGadget = #__flag_anchorsGadget)
        a_add(*this)
      EndIf
      
      Area(*this,1,0,0,0,0)
      Resize(*this, x,y,width,height)
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Text(x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, round.l = 0)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      Protected *parent._s_widget = Opened()
      
      *this\round = round
      *this\x[#__c_frame] =- 2147483648
      *this\y[#__c_frame] =- 2147483648
      *this\type = #__type_text
      
      If Flag & #__flag_vertical = #__flag_vertical
        *this\vertical = #True
      EndIf
      
      _set_text_flag_(*this, flag)
      
      ; - Create Text
      If *this\type = #PB_GadgetType_Text
        *this\class = "Text"
        
        *this\color\fore =- 1
        *this\color\back = _get_colors_()\fore
        *this\color\front = _get_colors_()\front
        
        ; PB 
        If Flag & #__text_border = #__text_border 
          *this\fs = 1
          *this\bs = *this\fs
          *this\color\frame = _get_colors_()\frame
        EndIf
        
        *this\text\X = 1
        *this\text\multiline =- 1
        SetText(*This, Text)
      EndIf
      
      _set_align_flag_(*this, *parent, flag)
      SetParent(*this, *parent, #PB_Default)
      
      If Bool(flag & #__flag_anchorsGadget = #__flag_anchorsGadget)
        a_add(*this)
      EndIf
      
      Resize(*this, x,y,width,height)
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Button(x.l,y.l,width.l,height.l, Text.s, Flag.i = 0, Image.i = -1, round.l = 0)
      Protected *this._s_widget = AllocateStructure(_s_widget)
      Protected *parent._s_widget = Opened()
      
      *this\round = round
      *this\x[#__c_frame] =- 2147483648
      *this\y[#__c_frame] =- 2147483648
      *this\type = #__type_button
      *this\_flag = Flag|#__flag_center
      
      If Flag & #__flag_vertical = #__flag_vertical
        *this\vertical = #True
      EndIf
      
      _set_text_flag_(*this, *this\_flag)
      
      If *this\Image\img <> Image
        _set_image_(*this, *this\Image, Image)
      EndIf
      
      _set_align_(*this\image, 
                  constants::_check_(*this\_flag, #__flag_left),
                  constants::_check_(*this\_flag, #__flag_top),
                  constants::_check_(*this\_flag, #__flag_right),
                  constants::_check_(*this\_flag, #__flag_bottom),
                  constants::_check_(*this\_flag, #__flag_center))
      
;       If *this\image\change
;         *this\type = #__type_buttonimage
;       EndIf
      
      ; - Create Text
      If *this\type = #PB_GadgetType_Button
        *this\class = "Button"
        
        *this\color = _get_colors_()
        *this\_state = #__s_front|#__s_back|#__s_frame
        
        ; PB 
        ; If Flag & #__text_border = #__text_border 
        *this\fs = 1
        *this\bs = *this\fs
        
        *this\text\padding\x = 4
        *this\text\padding\y = 4
        
        SetText(*This, Text)
      EndIf
      
      _set_align_flag_(*this, *parent, flag)
      SetParent(*this, *parent, #PB_Default)
      
      If flag & #__flag_anchorsGadget = #__flag_anchorsGadget
        a_add(*this)
      EndIf
      ;       If flag & #__flag_noscrollbars = #False
      ;         Area(*this, 1, 0, 0, 0, 0)
      ;       EndIf
      Resize(*this, x,y,width,height)
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Option(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i = 0)
      Protected *this._s_widget = AllocateStructure(_s_widget) 
      Protected *parent._s_widget = Opened()
      ;flag|#__text_center
      
      If Root()\count\childrens
        If widget()\type = #__type_Option
          *this\_group = widget()\_group 
        Else
          *this\_group = widget() 
        EndIf
      Else
        *this\_group = Opened()
      EndIf
      
      *this\x[#__c_frame] =- 2147483648
      *this\y[#__c_frame] =- 2147483648
      
      *this\type = #__type_Option
      *this\class = #PB_Compiler_Procedure
      
      *this\fs = 0 : *this\bs = *this\fs
      
      If Flag & #__flag_vertical = #__flag_vertical
        *this\vertical = #True
      EndIf
      
      _set_text_flag_(*this, flag|#__text_center| (Bool(Not flag & #__text_center) * #__text_left))
      
      ;       *this\color\back =- 1; _get_colors_(); - 1
      ;       *this\color\fore =- 1
      
      ; *this\_state = #__s_front
      *this\color\fore =- 1
      *this\color\back = _get_colors_()\fore
      *this\color\front = _get_colors_()\front
      
      
      *this\button\color = _get_colors_()
      *this\button\color\back = $ffffffff
      
      *this\button\round = 7
      *this\button\width = 15
      *this\button\height = *this\button\width
      *this\text\padding\x = *this\button\width + 8
      
      *this\text\multiline =- CountString(Text, #LF$)
      
      _set_align_flag_(*this, *parent, flag)
      SetParent(*this, *parent, #PB_Default)
      
      If Bool(flag & #__flag_anchorsGadget = #__flag_anchorsGadget)
        a_add(*this)
        ;         a_set(*this)
      EndIf
      Resize(*this, x,y,width,height)
      If Text.s
        SetText(*this, Text.s)
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Checkbox(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i = 0)
      Protected *this._s_widget = AllocateStructure(_s_widget) 
      Protected *parent._s_widget = Opened()
      
      *this\x[#__c_frame] =- 2147483648
      *this\y[#__c_frame] =- 2147483648
      
      *this\type = #__type_checkBox
      *this\class = #PB_Compiler_Procedure
      
      *this\fs = 0 : *this\bs = *this\fs
      If Flag & #__flag_vertical = #__flag_vertical
        *this\vertical = #True
      EndIf
      
      
      _set_text_flag_(*this, flag|#__text_center| (Bool(Not flag & #__text_center) * #__text_left))
      
      *this\mode\threestate = constants::_check_(Flag, #PB_CheckBox_ThreeState)
      *this\text\multiline =- CountString(Text, #LF$)
      
      ; *this\_state = #__s_front
      *this\color\fore =- 1
      *this\color\back = _get_colors_()\fore
      *this\color\front = _get_colors_()\front
      
      *this\button\color = _get_colors_()
      *this\button\color\back = $ffffffff
      
      *this\button\round = 2
      *this\button\height = 15
      *this\button\width = *this\button\height
      *this\text\padding\x = *this\button\width + 8
      
      _set_align_flag_(*this, *parent, flag)
      SetParent(*this, *parent, #PB_Default)
      
      If Bool(flag & #__flag_anchorsGadget = #__flag_anchorsGadget)
        a_add(*this)
        ;         a_set(*this)
      EndIf
      Resize(*this, x,y,width,height)
      If Text.s
        SetText(*this, Text.s)
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i HyperLink(X.l,Y.l,Width.l,Height.l, Text.s, Color.i, Flag.i = 0)
      Protected *this._s_widget = AllocateStructure(_s_widget) 
      Protected *parent._s_widget = Opened()
      
      *this\x[#__c_frame] =- 2147483648
      *this\y[#__c_frame] =- 2147483648
      
      *this\type = #__type_HyperLink
      *this\cursor = #PB_Cursor_Hand
      *this\class = #PB_Compiler_Procedure 
      
      *this\fs = 0 : *this\bs = *this\fs
      
      _set_text_flag_(*this, flag|#__text_center);, 3)
      
      *this\mode\lines = constants::_check_(Flag, #PB_HyperLink_Underline)
      *this\text\multiline =- CountString(Text, #LF$)
      
      *this\_state = #__s_front
      *this\color\fore[#__s_0] =- 1
      *this\color\back[#__s_0] = _get_colors_()\fore
      *this\color\front[#__s_0] = _get_colors_()\front
      *this\color\front[#__s_1] = Color
      
      _set_align_flag_(*this, *parent, flag)
      SetParent(*this, *parent, #PB_Default)
      
      If Bool(flag & #__flag_anchorsGadget = #__flag_anchorsGadget)
        a_add(*this)
        ;         a_set(*this)
      EndIf
      Resize(*this, x,y,width,height)
      If Text.s
        SetText(*this, Text.s)
      EndIf
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i ButtonImage(x.l,y.l,width.l,height.l, Image.i =-1 , Flag.i = 0, round.l = 0)
      ProcedureReturn Button(x,y,width,height, "", Flag, Image, round)
    EndProcedure
    
    ;- 
    Procedure.i MDI(x.l,y.l,width.l,height.l, Flag.i = 0) ; , Menu.i, SubMenu.l, FirstMenuItem.l)
      ProcedureReturn Create(Opened(), #PB_Compiler_Procedure, #__type_MDI, x,y,width,height, 0,0,0, #__scroll_buttonsize, flag|#__flag_nogadgets, 0, 1)
    EndProcedure
    
    Procedure.i Panel(x.l,y.l,width.l,height.l, Flag.i = 0)
      ProcedureReturn Create(Opened(), #PB_Compiler_Procedure, #__type_Panel, x,y,width,height, 0,0,0, #__scroll_buttonsize, flag|#__flag_noscrollbars, 0, 0)
    EndProcedure
    
    Procedure.i Container(x.l,y.l,width.l,height.l, Flag.i = 0)
      ProcedureReturn Create(Opened(), #PB_Compiler_Procedure, #__type_container, x,y,width,height, 0,0,0, #__scroll_buttonsize, flag|#__flag_noscrollbars, 0, 0)
    EndProcedure
    
    Procedure.i ScrollArea(x.l,y.l,width.l,height.l, ScrollAreaWidth.l, ScrollAreaHeight.l, ScrollStep.l = 1, Flag.i = 0)
      ProcedureReturn Create(Opened(), #PB_Compiler_Procedure, #__type_ScrollArea, x,y,width,height, ScrollAreaWidth,ScrollAreaHeight,0, #__scroll_buttonsize, flag, 0, ScrollStep)
    EndProcedure
    
    Procedure.i Frame(x.l,y.l,width.l,height.l, Text.s, Flag.i = 0)
      Protected Size = 16, *this._s_widget = AllocateStructure(_s_widget) 
      ;_set_last_parameters_(*this, #__type_Frame, Flag, Opened())
      Protected *parent._s_widget = Opened()
      
      With *this
        \x =- 1
        \y =- 1
        \container =- 2
        \color = _get_colors_()
        \color\alpha = 255
        \color\back = $FFF9F9F9
        
        \__height = 16
        
        \bs = 1
        \fs = 1
        
        ;       ; \text = AllocateStructure(_s_text)
        ;       \text\edit\string = Text.s
        ;       \text\string.s = Text.s
        ;       \text\change = 1
        _set_text_flag_(*this, flag, 2, - 22)
        
        *this\text\padding\x = 5
        ;*this\text\align\vertical = Bool(Not *this\text\align\top And Not *this\text\align\bottom)
        ;*this\text\align\horizontal = Bool(Not *this\text\align\left And Not *this\text\align\right)
        
        _set_align_flag_(*this, *parent, flag)
        SetParent(*this, *parent, #PB_Default)
        
        
        If Bool(flag & #__flag_anchorsGadget = #__flag_anchorsGadget)
          a_add(*this)
          ;           a_set(*this)
        EndIf
        Resize(*this, X,Y,Width,Height)
        If Text.s
          SetText(*this, Text.s)
        EndIf
        
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Image(x.l,y.l,width.l,height.l, image.i, Flag.i = 0) ; , Menu.i, SubMenu.l, FirstMenuItem.l)
      ProcedureReturn Create(Opened(), #PB_Compiler_Procedure, #__type_Image, x,y,width,height, 0,0,image, #__scroll_buttonsize, flag, 0, 1)
    EndProcedure
    
    ;- 
    Procedure ToolBar(*parent._s_widget, flag.i = #PB_ToolBar_Small)
      ProcedureReturn ListView(0,0,*parent\width[#__c_inner],20, flag)
    EndProcedure
    
    Procedure ToolTip(*this._s_widget, text.s, item =- 1)
     
     *this\tt\text\string = text 
    EndProcedure
    
    ;- 
    Procedure.b Draw(*this._s_widget)
      With *this
        ; drawing font
        _drawing_font_(*this)
        
        ;         If *this\transform
        ;           DrawingMode(#PB_2DDrawing_Outlined)
        ;           Box(*this\x, *this\y, *this\width, *this\height, $ffe0e0e0)
        ;         EndIf
        
        Select \type
          Case #__type_Window         : Window_Draw(*this)
          Case #__type_container      : ScrollArea_Draw(*this)
          Case #__type_ScrollArea     : ScrollArea_Draw(*this)
          Case #__type_MDI            : ScrollArea_Draw(*this)
          Case #__type_Image          : ScrollArea_Draw(*this)
            
          Case #__type_Panel          : Panel_Draw(*this)
            
          Case #__type_String         : Editor_Draw(*this)
          Case #__type_Editor         : Editor_Draw(*this)
            
          Case #__type_tree           : Tree_Draw(*this, *this\row\draws())
          Case #__type_property       : Tree_Draw(*this, *this\row\draws())
          Case #__type_listView       : Tree_Draw(*this, *this\row\draws())
            
          Case #__type_text           : Button_Draw(*this)
          Case #__type_button         : Button_Draw(*this)
          Case #__type_buttonimage    : Button_Draw(*this)
          Case #__type_Option         : Button_Draw(*this)
          Case #__type_checkBox       : Button_Draw(*this)
          Case #__type_HyperLink      : Button_Draw(*this)
            
          Case #__type_Spin ,
               #__type_tabBar,
               #__type_trackBar,
               #__type_ScrollBar,
               #__type_ProgressBar,
               #__type_Splitter       
            
            Bar_Draw(*this)
            
            ;             UnclipOutput()
            ;             DrawingMode(#PB_2DDrawing_Outlined)
            ;             Box(*this\x[#__c_clip], *this\y[#__c_clip], *this\width[#__c_clip], *this\height[#__c_clip], $ff00ffff)
            
        EndSelect
        
        ;         If *this\scroll And *this\scroll\v And *this\scroll\h
        ;           UnclipOutput()
        ;           DrawingMode(#PB_2DDrawing_Outlined)
        ;           ;Box(*this\x, *this\y, *this\width, *this\height, $ffffff00)
        ;           Box(*this\x[#__c_required], *this\y[#__c_required], *this\width[#__c_required], *this\height[#__c_required], $ffff00ff)
        ;           ;Box(*this\x[#__c_required], *this\y[#__c_required], *this\scroll\h\bar\max, *this\scroll\v\bar\max,$ff0000ff)
        ;           Box(*this\scroll\h\x, *this\scroll\v\y, *this\scroll\h\bar\page\len, *this\scroll\v\bar\page\len, $ff00ff00)
        ;           Box(*this\x[#__c_clip], *this\y[#__c_clip], *this\width[#__c_clip], *this\height[#__c_clip], $ff00ffff)
        ;         EndIf
        
        If *this\text\change <> 0
          *this\text\change = 0
        EndIf
        If *this\resize & #__resize_change
          *this\resize &~ #__resize_change
        EndIf
        
      EndWith
    EndProcedure
    
    Procedure   ReDraw(*this._s_widget)
      ;Debug  "" + Root()\repaint  + " " +  *this\root\repaint
      
      If StartDrawing( CanvasOutput(*this\root\canvas\gadget) )
        If *this\root\canvas\repaint <> #False
          *this\root\canvas\repaint = #False
        EndIf
        
        
        If Transform() And Transform()\grab > 1
          DrawImage(ImageID(Transform()\grab), 0,0)
          
          ; draw selector
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          Box(Transform()\id\x, Transform()\id\y, 
              Transform()\id\width, Transform()\id\height , $ff000000);Transform()\color[Transform()\state]\id) 
          
        Else
          If Not *this\root\text\fontID[1]
            *this\root\text\fontID[1] = PB_(GetGadgetFont)(#PB_Default)
            If Root()\text\fontID <> *this\root\text\fontID[1]
              Root()\text\fontID = *this\root\text\fontID[1]
            EndIf
          EndIf
          
          ; reset current drawing font
          ; to set new current drawing font
          *this\root\text\fontID[1] =- 1 
          
          If _is_root_(*this)
            ; 
            If *this\root\repaint = #True
              ;             CompilerIf  #PB_Compiler_OS = #PB_OS_MacOS
              ;               FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight())
              ;             CompilerElse
              FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $f0)
              ;             CompilerEndIf
              ; FillArea(0, 0, -1, $f0f0f0) 
            EndIf
            
            Protected count
            PushListPosition(widget())
            ForEach widget()
              ;             If  widget()\class = "Tree"
              ;               Draw(widget())
              ;             EndIf
              
              If widget()\root\canvas\gadget = *this\root\canvas\gadget And 
                 (Not widget()\hide And widget()\draw) And (widget()\width[#__c_clip] > 0 And widget()\height[#__c_clip] > 0)
                CompilerIf Not (#PB_Compiler_OS = #PB_OS_MacOS And Not Defined(fixme, #PB_Module))
                  ClipOutput( widget()\x[#__c_clip], 
                              widget()\y[#__c_clip], 
                              widget()\width[#__c_clip], 
                              widget()\height[#__c_clip])
                CompilerEndIf
                
                ;               If Focused() = widget()
                ;                 Debug "" + count  + " " +  widget()\width[#__c_clip] : count + 1
                ;               EndIf
                Draw(widget())
              EndIf
              
              If widget()\transform And (widget()\width[#__c_clip] = 0 And widget()\height[#__c_clip] = 0)
                UnclipOutput()
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                Box(widget()\x[#__c_inner], widget()\y[#__c_inner], widget()\width[#__c_inner], widget()\height[#__c_inner], $ff00ffff)
              EndIf
            Next
            PopListPosition(widget())
          Else
            Draw(widget())
          EndIf
          
          ; Draw anchors 
          If Transform()
            a_draw(Transform()\widget)
          EndIf
        EndIf
        
        StopDrawing()
      EndIf
    EndProcedure
    
    Procedure.i Post(eventtype.l, *this._s_widget, *button = #PB_All, *data = #Null)
      Protected result.i, root
      
      If eventtype = #PB_EventType_repaint
        If *this <> #PB_All
          ; Root() = *this\root
          ChangeCurrentElement(Root(), @*this\root\adress)
        EndIf
        
        If Root()\canvas\repaint = #False
          Root()\canvas\repaint = #True
          PostEvent(#PB_Event_Gadget, Root()\canvas\window, Root()\canvas\gadget, #PB_EventType_repaint, Root())
        EndIf
      Else
        This()\item = *button
        This()\event = eventtype
        This()\widget = *this
        This()\data = *data
        
        ; if bind called
        If *this And *this\root\count\events
          ; Debug eventtype
          
          If Not _is_root_(*this)
            If MapSize(*this\bind())
              PushMapPosition(*this\bind())
              If FindMapElement(*this\bind(), Hex(#PB_All)) Or FindMapElement(*this\bind(), Hex(eventtype))
                ForEach *this\bind()
                  If (*this\bind()\type = #PB_All Or
                      *this\bind()\type = eventtype) And 
                     *this\bind()\callback And 
                     *this\bind()\callback() = #PB_Ignore 
                    ProcedureReturn #PB_Ignore
                  EndIf
                Next
              EndIf
              PopMapPosition(*this\bind())
            EndIf
            
            If MapSize(*this\window\bind()) And Not _is_window_(*this) And Not _is_root_(*this\window) 
              PushMapPosition(*this\window\bind())
              If FindMapElement(*this\window\bind(), Hex(#PB_All)) Or
                 FindMapElement(*this\window\bind(), Hex(eventtype))
                
                
                ForEach *this\window\bind()
                  If (*this\window\bind()\type = #PB_All Or 
                      *this\window\bind()\type = eventtype) And
                     *this\window\bind()\callback And 
                     *this\window\bind()\callback() = #PB_Ignore 
                    ProcedureReturn #PB_Ignore
                  EndIf
                Next
              EndIf
              PopMapPosition(*this\window\bind())
            EndIf
          EndIf
          
          If MapSize(*this\root\bind())
            PushMapPosition(*this\root\bind())
            If FindMapElement(*this\root\bind(), Hex(#PB_All)) Or
               FindMapElement(*this\root\bind(), Hex(eventtype))
              
              ForEach *this\root\bind()
                If (*this\root\bind()\type = #PB_All Or 
                    *this\root\bind()\type = eventtype) And
                   *this\root\bind()\callback And 
                   *this\root\bind()\callback() = #PB_Ignore 
                  ProcedureReturn #PB_Ignore
                EndIf
              Next
            EndIf
            PopMapPosition(*this\root\bind())
          EndIf
          
        Else
          Select eventtype 
            Case #__Event_Focus, 
                 #__Event_lostFocus
              
              ForEach This()\post()
                If This()\post()\widget = *this And 
                   This()\post()\events() = eventtype
                  result = 1
                EndIf
              Next
              
              If Not result
                AddElement(This()\post())
                This()\post() = AllocateStructure(_s_bind)
                AddMapElement(This()\post()\events(), Hex(eventtype))
                This()\post()\events() = eventtype
                This()\post()\item = *button
                This()\post()\widget = *this
                This()\post()\data = *data
              EndIf
          EndSelect
        EndIf
      EndIf
      
      ProcedureReturn result
    EndProcedure
    
    Procedure.i Bind(*this._s_widget, *callback, eventtype.l = #PB_All)
      If *this = #PB_All And ListSize(Root())
        *this = Root()
      EndIf
      
      If Not *this
        ProcedureReturn #False
      EndIf
      
      *this\root\count\events + 1
      
      If Not FindMapElement(*this\bind(), Hex(eventtype))
        AddMapElement(*this\bind(), Hex(eventtype))
        *this\bind() = AllocateStructure(_s_bind) 
      Else
        If Not FindMapElement(*this\bind(), Hex(*callback))
          AddMapElement(*this\bind(), Hex(*callback))
          *this\bind() = AllocateStructure(_s_bind) 
        EndIf
      EndIf
      
      *this\bind()\widget = *this
      *this\bind()\type = eventtype
      *this\bind()\callback = *callback
      
      ;Debug ""+eventtype+" "+MapSize(*this\bind())
      
      If ListSize(This()\post())
        ForEach This()\post()
          ForEach This()\post()\events()
            ; Debug ""+This()\post()\widget +" "+ *this
            If eventtype = This()\post()\events() ; And This()\post()\widget = *this
                                                  ;Debug 54455
              Post(This()\post()\events(), This()\post()\widget, This()\post()\item, This()\post()\data)
              DeleteMapElement(This()\post()\events())
            EndIf
          Next
          DeleteElement(This()\post())
        Next
        ;ClearList(This()\post())
      EndIf
      
      ProcedureReturn *this\bind()
    EndProcedure
    
    Procedure.i Unbind(*callback, *this._s_widget = #PB_All, eventtype.l = #PB_All)
      ;       If *this\event
      ;         *this\event\type = 0
      ;         *this\event\callback = 0
      ;         FreeStructure(*this\event)
      ;         *this\event = 0
      ;       EndIf
      ;       
      ;       ProcedureReturn *this\event
    EndProcedure
    
    Procedure PBFlag(Type, Flag)
      Protected flags
      
      Select Type
        Case #PB_GadgetType_CheckBox
          If Flag & #PB_CheckBox_Right = #PB_CheckBox_Right
            Flag &~ #PB_CheckBox_Right
            flags | #__text_right
          EndIf
          If Flag & #PB_CheckBox_Center = #PB_CheckBox_Center
            Flag &~ #PB_CheckBox_Center
            flags | #__text_center
          EndIf
          
        Case #PB_GadgetType_Text
          If Flag & #PB_Text_Border = #PB_Text_Border
            Flag &~ #PB_Text_Border
            flags | #__text_border
          EndIf
          If Flag & #PB_Text_Center = #PB_Text_Center
            Flag &~ #PB_Text_Center
            flags | #__text_center
          EndIf
          If Flag & #PB_Text_Right = #PB_Text_Right
            Flag &~ #PB_Text_Right
            flags | #__text_right
          EndIf
          
        Case #PB_GadgetType_Button
          If Flag & #PB_Button_Left = #PB_Button_Left
            Flag &~ #PB_Button_Left
            flags | #__button_left
          EndIf
          If Flag & #PB_Button_Right = #PB_Button_Right
            Flag &~ #PB_Button_Right
            flags | #__button_right
          EndIf
          If Flag & #PB_Button_MultiLine = #PB_Button_MultiLine
            Flag &~ #PB_Button_MultiLine
            flags | #__button_multiline
          EndIf
          If Flag & #PB_Button_Toggle = #PB_Button_Toggle
            Flag &~ #PB_Button_Toggle
            flags | #__button_toggle
          EndIf
          If Flag & #PB_Button_Default = #PB_Button_Default
            Flag &~ #PB_Button_Default
            flags | #__button_default
          EndIf
          
        Case #PB_GadgetType_Tree
          If Flag & #PB_Tree_AlwaysShowSelection = #PB_Tree_AlwaysShowSelection
            Flag &~ #PB_Tree_AlwaysShowSelection
            flags | #__tree_alwaysselection
          EndIf
          If Flag & #PB_Tree_CheckBoxes = #PB_Tree_CheckBoxes
            Flag &~ #PB_Tree_CheckBoxes
            flags | #__tree_checkboxes 
          EndIf
          If Flag & #PB_Tree_ThreeState = #PB_Tree_ThreeState
            Flag &~ #PB_Tree_ThreeState
            flags | #__tree_threestate
          EndIf
          If Flag & #PB_Tree_NoButtons = #PB_Tree_NoButtons
            Flag &~ #PB_Tree_NoButtons
            flags | #__tree_nobuttons
          EndIf
          If Flag & #PB_Tree_NoLines = #PB_Tree_NoLines
            Flag &~ #PB_Tree_NoLines
            flags | #__tree_nolines
          EndIf
          
      EndSelect
      
      flags | Flag
      ProcedureReturn flags
    EndProcedure
    
    
    ;-  MAC OS
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      Procedure GetCurrentEvent()
        Protected app = CocoaMessage(0,0,"NSApplication sharedApplication")
        If app
          ProcedureReturn CocoaMessage(0,app,"currentEvent")
        EndIf
      EndProcedure
      
      Procedure.CGFloat GetWheelDeltaX()
        Protected wheelDeltaX.CGFloat = 0.0
        Protected currentEvent = GetCurrentEvent()
        If currentEvent
          CocoaMessage(@wheelDeltaX,currentEvent,"scrollingDeltaX")
        EndIf
        ProcedureReturn wheelDeltaX
      EndProcedure
      
      Procedure.CGFloat GetWheelDeltaY()
        Protected wheelDeltaY.CGFloat = 0.0
        Protected currentEvent = GetCurrentEvent()
        If currentEvent
          CocoaMessage(@wheelDeltaY,currentEvent,"scrollingDeltaY")
        EndIf
        ProcedureReturn wheelDeltaY
      EndProcedure
    CompilerEndIf
    
    ;-
    Procedure message_events()
      Protected result
      
      If this()\event = #PB_EventType_LeftClick
        Select this()\widget\index
          Case 4 : result = #PB_MessageRequester_Yes ; yes
          Case 5 : result = #PB_MessageRequester_No  ; no
          Case 6 : result = #PB_MessageRequester_Cancel ; cancel
        EndSelect
        
        SetData(this()\widget\window, result)
        PostEvent(#PB_Event_CloseWindow, EventWindow(), this()\widget\window)
      EndIf
    EndProcedure
    
    Procedure Message(Title.s, Text.s, Flag.i = #Null)
      Protected result
      Protected img =- 1, f1 =- 1, f2=8, width = 400, height = 120
      Protected bw = 85, bh = 25, iw = height-bh-f1 - f2*4 - 2-1
      Protected x = (Root()\width-width-#__border_size*2)/2
      Protected y = (Root()\height-height-#__caption_height-#__border_size*2)/2
      
      Protected window = Window(x,y, width, height, Title, #__window_titlebar)
      ;SetAlignment(widget(), #__align_center)
      Bind(widget(), @message_events())
      
      If Flag & #PB_MessageRequester_Info
        img = CatchImage(#PB_Any, ?img_info, ?end_img_info - ?img_info)
        
        DataSection
          img_info: 
          ; size : 1404 bytes
          Data.q $0A1A0A0D474E5089,$524448490D000000,$2800000028000000,$B8FE8C0000000608,$474B62060000006D
          Data.q $A0FF00FF00FF0044,$493105000093A7BD,$5F98CD8558544144,$3B3BBFC71C47144C,$54C0F03D7F7BB707
          Data.q $14DA0D5AD0348C10,$7C1A6360A90B6D6D,$6D03CAADF49898D3,$D1A87D7AD262545F,$B69B5F469AA9349A
          Data.q $680D82AB6C37D269,$A6220B47FA51A890,$DECFEE38E105102A,$053FB87D333B772E,$CCDD3CF850EE114A
          Data.q $0766FDFE767ECCDC,$F476DC569948E258,$5BCA94AD89227ADA,$3C10B9638C15E085,$7A59504C89240017
          Data.q $8055B371E2774802,$2E678FEAA9A17AFC,$06961711C3AC7F58,$EF905DD4CA91A322,$A159B0EAD38F5EA2
          Data.q $4D30000CA9417358,$1A3033484098DD06,$2C671601A343EB08,$EDD3F547A138B820,$DAFB560A82C89ABE
          Data.q $2E1D2C863E5562A8,$3CD50AAB359173CC,$8D8C00262FCE6397,$83FB0DA43FD7D187,$DDAAFF5D74F85C02
          Data.q $B3A477582D666357,$45754E5D9B42C73C,$16732AAEDD894565,$41FBABA3A6B0899B,$3FAB16311F45A424
          Data.q $8FDB82C66F4B707F,$1595D6EF9001DD5F,$69B32B24BD2B2529,$EA0DEEB7E6181FDC,$9D9F369A5BBB6326
          Data.q $A94FBDAEC7BBE0B7,$A732EAE5951BF5F4,$5C114204D2DD216D,$6B9C344C651BD9B9,$5F8FDB82CE66FAAA
          Data.q $5F57EDFEF90841DD,$8469F486ECB61D52,$C2634777AE971D35,$2A9E9FF5E072D5DC,$8DE85A9CB3A47758
          Data.q $4DCF559EDB963737,$0D1DD74741182C67,$C9DDD550E5F86C71,$E68DAFB555E65365,$79E522B2BAF36858
          Data.q $B2DAC765C78001C9,$8DAFB573522C2B62,$8F9455C8929B2E4E,$77B1059330B54E5C,$D579F26E672AD4E3
          Data.q $AC8D0E0F2BD2BD5F,$9F9532F8021F1304,$C910838758FEB56E,$816E0DF732515957,$DAAF81036D5F2CA9
          Data.q $C2E305A5E54F66D7,$73EED922E79850D2,$88B9E6F02BB0E0D9,$2241697952FB2AA2,$B51C5D50B8ACB1A3
          Data.q $69322368555B297F,$A654FC089009A54C,$1E34DD1B45EE65EE,$5F9F7579224403B7,$416D440905240B59
          Data.q $244059B47C668BBE,$56F2A644DDF22B00,$1EBC77E473482920,$E3DCB126CD5175A7,$E720A4816B952854
          Data.q $AA1C1F8C97DBB0A8,$3CE0A0A481CA0015,$2829A74C5DCDCD5F,$0F5481799C981CD6,$9356B8BCB2A56E0A
          Data.q $0B4C0AC3821950B0,$6188962AC4914B75,$8326E2692ED8B632,$32112C58C9006044,$ECE858E5B0989D1A
          Data.q $743677B1BE616735,$07BA4027E44A0623,$6C80F60B188E13D1,$829201DC00066B09,$8C96858E8E2EC9A6
          Data.q $805AC633A82068E1,$371FE43AD04336D4,$3E017C48017AE2C5,$292045C9C672091A,$FE17193FA6FF7E78
          Data.q $24BB170DC670F1B1,$228215E7B04759EC,$8381081FD341E657,$105A57F6BD342FFB,$B487FAFAA7631800
          Data.q $02CD8258AB7E1B4C,$7FAFA533BF1272D8,$0B4E95227E4D3348,$C2283FB0F4FD51EA,$448A12D9E3719E9A
          Data.q $A9D39441710FE231,$C02226AFBB60B4BC,$BE71A320F3D6FF0F,$B80C4880C5A02FD4,$EAE80059B3FE70FC
          Data.q $BFD96D3E2109AFBE,$33433E3653923D3E,$6181FDEF7925044E,$40CCA2BCC151695B,$BFB32F995BDBE050
          Data.q $4BD80C6A38598607,$EED1229FCE4E4FFB,$37BADFD58B1931AB,$9AC9DFBE734207A8,$31180DF76E30F1B1
          Data.q $484A73B9DC7FEBCE,$D7A5B83F9D2F4FFB,$F3E8DECDC7776C64,$77EFE7474D218F98,$BEA6C0F5ABB1CE75
          Data.q $E6D34B630E33E5E9,$D1DDEBF686899CB3,$30F1B1C9EBB3E0B1,$707F829A8EE8DF2E,$EB33FE99E7EAA9A1
          Data.q $92547BE745F7507E,$CF3D5948A6BB587F,$BB773989021B3939,$EE4FFEBB1CE0C06F,$17B5C8FDB00082A9
          Data.q $0D85E5765D9A9161,$D2CFBB3D8776A515,$B091079EAE8A2450,$58699FAF38C60FA6,$AAAC44AE240825E7
          Data.q $524EF9BCCF8048DA,$7CE63B71E6C2BC56,$B1F0FBBCC0BA9B3D,$B389F106710FE236,$E0B19105F4D4FFA4
          Data.q $4964FB2AA2BB5124,$96EF9053D965946A,$5542B5438A9C7B97,$AA218C9B953A9172,$F504091819AC204F
          Data.q $19C68C085CE323C7,$0AFC1667EBA1393B,$9132FEBD1DB62678,$0A88495AE54CAD78,$974C713C10AF0B93
          Data.q $C7A92409E9132188,$DA1DCE5A182B5934,$00FF3496B3E99DD4,$C5E52BD0901E71B2,$444E454900000000
          Data.b $AE,$42,$60,$82
          end_img_info:
        EndDataSection
      EndIf
      
      If Flag & #PB_MessageRequester_Error
        img = CatchImage(#PB_Any, ?img_error, ?end_img_error - ?img_error)
        
        DataSection
          img_error: 
          ; size : 1642 bytes
          Data.q $0A1A0A0D474E5089,$524448490D000000,$3000000030000000,$F902570000000608,$474B620600000087
          Data.q $A0FF00FF00FF0044,$491F06000093A7BD,$41D9ED8168544144,$CCEFF1C71DC7546C,$F6A06C4218C6ED7A
          Data.q $E448A410E515497A,$2070C40BB121A4E0,$46DC512B241A4E54,$124BD29004AB2039,$5150F4DA060B2630
          Data.q $52894889E9734815,$42B01552AB888955,$0A9535535581A8E4,$A69B1B838C151352,$0F5F9BEDFAF1DAF1
          Data.q $1B16F7DEBB3635DE,$DBF3D5DEB2E7A873,$8599BCFFBCCDEFCF,$8B999BBFFED0B685,$D94DFC3235B5A893
          Data.q $2AD241A8331E9177,$A24A50090AA21D50,$F4E23494382E38DF,$CDC2449B1FD5A692,$67C9F4601567BBF6
          Data.q $EA910FC176C73A56,$FB3E2C820C026811,$90FA231C4D0CFD92,$77E7A6B4722EFB8E,$3975B5B8601AF37D
          Data.q $E795079E6401C8E9,$718909C7B3E02570,$139E92E751637E23,$67B6C9EA403CB783,$16621CEA8257EE71
          Data.q $51DA72431163C9F8,$ED40125BADFBB67D,$B69198EA40D4D1ED,$E1CFD7F08E620A6A,$649A76066FAEE378
          Data.q $1CAF696A00B39BD2,$F8A5BF1E82DFA931,$B68B1E9F7E92E7EC,$10366C83462792C6,$9B483C679D1EDEDF
          Data.q $E5ADFDD3DFC7CA2B,$679B1D481A900EB3,$FD5FC5A1C6FDEE7C,$789EA5087457C832,$DF27E036FC740DB6
          Data.q $2EDEA7739A99E91B,$7D63573D4FD7C039,$091E176ECB121FEF,$3D92C5F7739E6BA1,$E3F8C8438CEC4B05
          Data.q $E338639DC7E0C287,$93E731F8D0BBE631,$A883C20B9CF064CA,$C03059C99BECC32E,$8A2A927678B696E8
          Data.q $6773962BC31DF31F,$5E32A40D35BC1ED7,$61AE34C8F7C47E20,$B482B75C33F7CFE9,$BD6DC8C3B3E18BF3
          Data.q $F3CE00E87774D0D6,$C8C73B8EC3301077,$1EAA53FC3F1397B7,$A3ED685DBED88879,$889BEB3C515EF88C
          Data.q $FBB987C6E2C3DC1F,$4F437B575A305FF5,$D8C99E55CF67C74C,$B432B0912802A16D,$0BD967DF31F98D05
          Data.q $2244C006A9AB295B,$95211F6B425F3AC4,$131BB7DFAF88CCC9,$17F2C3565D100089,$60D9F045FBE631B7
          Data.q $0C030246B6B523F0,$1BA0F14E30F0BF9F,$EF9127DDBFE58A36,$7DED884489AFFE4F,$0078CCC4F5CBAD05
          Data.q $A1A89BAF79FF3EF9,$AF17ABFAEFE27E38,$B54C2C7A40060436,$9FD33FDED83596F9,$D82EC4FA885E59F8
          Data.q $D0F7C463C6548EB0,$7ABDF473BC7CC6DA,$3F0026054BD3D308,$C1803039A9C479F1,$CC32DA5654B6183D
          Data.q $843D34389FD11F87,$875C6CC25F3AC4B5,$EFC7C8EAEF1236D6,$86D6458670FE883D,$6F207AF2E72123C2
          Data.q $EE229FADFBFAF81E,$E35C19F88FCEA52F,$89B8CABF4FF7EA1A,$F8B374EBF5EC6161,$5A3FDFED5BFB10EC
          Data.q $524EA5751007B45D,$7B2B97B0FD822695,$BC3B99AC09EB4E0F,$A8050B7237754E04,$6194D2B63B9F052A
          Data.q $FCB800F3AFA5E83E,$D12A27E1D9A4A295,$FA6EE7C74A0110E2,$3343761C4CC77B89,$A4788CCDAA213002
          Data.q $66EA532260530BFC,$3698EAEF136AB9F0,$377FBE21937FAE6C,$F026FF1923335366,$598BE240181C3102
          Data.q $3270DA691B56A7E1,$666A6EC0EAEF12D6,$08BE902F11299324,$7D1CEF04E7174011,$C4AF2272F4B8079D
          Data.q $9181BE3CC1EC0FC6,$C085D20F121D8CEC,$B0DECF8273F38800,$621F92BD2E59CCE6,$A6A48DE6EC4EC1E5
          Data.q $181F3A4E3C00A70C,$F4D5891F61D388C0,$FF7BBCB9F7DE3E68,$9675385AC3B9B564,$5373410C15F6BBCB
          Data.q $ECEB025E38B489F6,$8C7F569A4B00C0E9,$4B1CE3220F0C5CB8,$4FE0BA3BE3E5365B,$7F45AC8B952B4C1F
          Data.q $2DEA844889EFC9EC,$AA5D23C40BBE782D,$091207B8325CECFD,$630A823C3166F487,$4543837863E1F7F9
          Data.q $19E4E8B5A54439F1,$CBEF0864EAFCBD2E,$4131B94C3B5E0641,$2D1D5E40D37B9078,$4D6E25BF5A1CA4B8
          Data.q $EEB9F085E5489FE6,$FC565ABAD19F3B4E,$A7A63EFBBDAE05E4,$6E687C654A927037,$E61DAF030B4B7AA2
          Data.q $3330F5B7215D7F8E,$DF6577BFDC7F695E,$FAD5F0000A84AF5F,$73E133C7EE175E27,$6A27DF318E73D6A5
          Data.q $EF9E3E769954FD08,$47491E3068863728,$99CE42CECBFF3FEA,$D060C40EE915C4D7,$1E3436B2A80CBC02
          Data.q $1F8B0DAC8B0C0A89,$CEE0189ADA5B5132,$7C316769C9AF2793,$336A9850616065F1,$19C98BB16DA138F5
          Data.q $ED9F556C6E8B7D37,$3A0F0BB71BC70B7E,$03198A7793FCFF1A,$E71DB45BAAEEE677,$EFB1DD41BC6F9DDE
          Data.q $B7736A17C8317D2C,$077E9A22B2A5A1BF,$E37DE9DE572F3CD8,$B9BF6727F58E9E45,$86F6AD189E4B100B
          Data.q $B13618F9EBF4207E,$F1370F06153E967B,$E8769E1B43D0C703,$DA14BFE31CD96208,$607AA16C6FE6341E
          Data.q $630AEDEA7739AB6A,$7C039E94863A4956,$152AAF8DE711D25A,$E681F06F91FCB30F,$65624DA80766477A
          Data.q $DDC7F71DC8CBF889,$35C804BCEC3342D1,$388C1EF7C0FABD81,$AA70FBA106B9CB35,$887D7214F8B2AA07
          Data.q $FB5D3D9D6F3A4E8B,$B6859B67A164B9D9,$FEEC7FED695A16D0,$00006B709A860323,$42AE444E45490000
          Data.b $60,$82
          
          
          end_img_error:
        EndDataSection
      EndIf
      
      If Flag & #PB_MessageRequester_Warning
        img = CatchImage(#PB_Any, ?img_warning, ?end_img_warning - ?img_warning)
        
        DataSection
          img_warning: 
          ; size : 1015 bytes
          Data.q $0A1A0A0D474E5089,$524448490D000000,$2800000028000000,$B8FE8C0000000608,$474B62060000006D
          Data.q $A0FF00FF00FF0044,$49AC03000093A7BD,$DD98ED8558544144,$67339F8718551C6B,$6BA934DBB3B3B267
          Data.q $60255624DDDB3493,$785E2A42F0458295,$068C4AF69BDA17E3,$030B4150FDBB362A,$D9AC514B49409622
          Data.q $86FF825726F0546E,$2968A4290537B482,$7B79EF7CD1F26F42,$CCECECDD9B68DDB1,$3DE7337B07E4DE84
          Data.q $CE73DE666FECFBEF,$BE4895C549A28EC0,$D18003BEE526913D,$1BC8E3E7C60FAABF,$9FECC2827EF8A00B
          Data.q $A661997980015464,$5B7351EBFBE505F3,$47813B9850001351,$53C3D570C7AAE19E,$B23A91C71FB3F205
          Data.q $DEADAC5DE7CBF283,$8B8B83D4866AB9E2,$A3501A8AC0BD75C0,$F5C1DD1FC946EE17,$A401C06F62B271D5
          Data.q $FA6A26F924D8AC80,$7E5A30F4E54A0E48,$5560C8F125D550E7,$EF525E4622D61FC1,$09839A235B0F5C4F
          Data.q $6801C1363A672499,$22528E5162499C81,$1C849B7E9D4CA034,$9B0B11E8E79A47A4,$D4275B0ADE94A961
          Data.q $86766961DF69962D,$ACF075B2DD97A5A7,$D5E5ADCCBFD61B82,$E0E70AD6ED2BCBC9,$01C25A643259C2E2
          Data.q $267D976692740A74,$BDB1C9941DB6A94C,$00648F1BCF26FAD8,$B2C7BE9AE0658040,$5EA769DE2F46A039
          Data.q $1126BD12FA3A0EFB,$4936293C09200E18,$A54A016D72DDA26B,$768E93EC9BC50878,$2E521BC80E33910B
          Data.q $141140605A676E1D,$A093744937932ADA,$8281A48D7ED62F67,$15A3F82459547171,$403871C753A9C1DC
          Data.q $06470A2CF737C256,$804094E82C78A9F8,$D268304CD1725D32,$92EA1CB5051ED691,$7565900D8BC67CFC
          Data.q $D18BC6D5D9712E8E,$117CC62E3760194C,$10E54E54A025BC24,$2A40E3FD026F2319,$6858AA64C64A1498
          Data.q $61F477CD41DADA15,$27D00E40F641C4E3,$8096E855B9759636,$67D2AF1465F163F2,$8B1B13EAEAE0D8EC
          Data.q $535855B2BD295223,$321995650B7DF140,$C60B95CDEEFB4C6E,$B8D66D1F4CB2AB43,$D29243E17FBD28B6
          Data.q $084F4AD2B684774F,$4859A46E52C3D2B8,$3D5D0669FAB94043,$435D5C1B6F49A0CF,$B3ACF95CB8C88D26
          Data.q $D9AFD513076370D1,$EC1E3B578FDB0E23,$4DE1A355F6B926C1,$FEC232053D2E5280,$8171BCABDB194E87
          Data.q $9B43A3CCF63AB911,$1D8D8BF4930EEB37,$1B03C18628DF29A2,$2381EFADB70E37E8,$5E94A941C87A1FFF
          Data.q $4653A34D7B30E2C3,$57BCFD90E834E96B,$37AF4AA6517A9634,$506499A04FDF1404,$4BE860F68ADAA152
          Data.q $7B4EB6B20E173A18,$DF46D1F2B907EA58,$CA9492773F250FFD,$BBF30895BD7115D2,$BF527F49C6E93C04
          Data.q $2DC126EA5CA400A4,$73BAB8046E349A0E,$A6B8292C73E17BD5,$BB85E8D406B15816,$05103AFB551D0735
          Data.q $DA95C00E05160EAE,$1B16FD43CE570957,$DA5DBF1B621FD38E,$EA54075063860747,$5917BB61884A7336
          Data.q $FBD40FF52823CC02,$FE37EB4DCBBCBAE0,$9BF9A436D938F722,$8ED1D8C6E3DEF555,$2EE409553D03EE00
          Data.q $4900000000FAB21F
          Data.b $45,$4E,$44,$AE,$42,$60,$82
          end_img_warning:
        EndDataSection
      EndIf
      
      Container(f1,f1,width - f1*2, height-bh-f1 - f2*2-1) 
      Image(f2,f2,iw, iw, img, #PB_Image_Border);|#__flag_noscrollbars)
      Text(f2+iw+f2, f2, width - iw, iw, Text, #__text_center|#__text_left)
      CloseList()
      
      Button(width-bw-f2,height-bh-f2,bw,bh,"Ok", #__button_default)
      SetAlignment(widget(), #__align_bottom|#__align_right)
      
      If Flag & #PB_MessageRequester_YesNo Or 
         Flag & #PB_MessageRequester_YesNoCancel
        SetText(widget(), "Yes")
        Button(width-(bw+f2)*2-f2,height-bh-f2,bw,bh,"No")
        SetAlignment(widget(), #__align_bottom|#__align_right)
      EndIf
      
      If Flag & #PB_MessageRequester_YesNoCancel
        Button(width-(bw+f2)*3-f2*2,height-bh-f2,bw,bh,"Cansel")
        SetAlignment(widget(), #__align_bottom|#__align_right)
      EndIf
      
      WaitClose(window)
      
      result = GetData(window)
      ProcedureReturn result
    EndProcedure
    
  
    ;- 
    Procedure Events(*this._s_widget, eventtype.l, mouse_x.l, mouse_y.l, _wheel_x_.b = 0, _wheel_y_.b = 0)
      Static move_x, move_y
      Protected Repaint
      
      If Not _is_widget_(*this)
        If Not _is_root_(*this)
          Debug "not event widget - " + *this
        EndIf
        ProcedureReturn 0
      EndIf
      
      If *this\transform
       If eventtype = #PB_EventType_LeftButtonDown
         Debug 555
          Mouse()\selected = *this
       EndIf
          
        If Transform() 
          ; init selector coordinate
          If eventtype = #PB_EventType_DragStart
            _set_cursor_(Mouse()\selected, #PB_Cursor_Cross)
            
            If Transform()\widget And 
               Transform()\widget\container And 
               StartDrawing(CanvasOutput(Transform()\widget\root\canvas\gadget))
              Transform()\grab = GrabDrawingImage(#PB_Any, 0,0, Transform()\widget\root\width, Transform()\widget\root\height)
              StopDrawing()
            EndIf
          EndIf
          
          ; change selector coordinate
          If eventtype = #PB_EventType_MouseMove
            If Transform()\grab 
              If Mouse()\grid > 0
                mouse_x = (Mouse()\x / Mouse()\grid) * Mouse()\grid
                mouse_y = (Mouse()\y / Mouse()\grid) * Mouse()\grid
              Else
                mouse_x = Mouse()\x
                mouse_y = Mouse()\y
              EndIf
              
              If move_x <> mouse_x
                If move_x > mouse_x
                  Repaint =- 1
                Else
                  Repaint = 1
                EndIf
                move_x = mouse_x
              EndIf
              
              If move_y <> mouse_y
                If move_y > mouse_y
                  Repaint =- 2
                Else
                  Repaint = 2
                EndIf
                move_y = mouse_y
              EndIf
              
              If Repaint
                Transform()\id\x = Mouse()\delta\x + Mouse()\selected\x
                Transform()\id\y = Mouse()\delta\y + Mouse()\selected\y
                
                If Transform()\id\x > move_x
                  Transform()\id\width = Transform()\id\x - move_x
                  Transform()\id\x = move_x
                Else
                  Transform()\id\width = move_x - Transform()\id\x
                EndIf
                
                If Transform()\id\y > move_y
                  Transform()\id\height = Transform()\id\y - move_y
                  Transform()\id\y = move_y
                Else
                  Transform()\id\height = move_y - Transform()\id\y
                EndIf
                
                If Mouse()\selected\fs
                  Transform()\id\x + Mouse()\selected\fs
                  Transform()\id\y + Mouse()\selected\fs
                EndIf
                
                If Mouse()\grid > 0
                  Transform()\id\width + 1
                  Transform()\id\height + 1
                EndIf
              EndIf
            EndIf
          EndIf
          
          ; reset selector coordinate 
          If eventtype = #PB_EventType_LeftButtonUp
            _set_cursor_(Mouse()\selected, #PB_Cursor_Default)
            Mouse()\selected = 0
          EndIf
        EndIf
        
        Post(eventtype, *this, *this\index[#__s_1])
        
        
        ; events anchors on the widget
        If Transform() And Transform()\widget
          
          If eventtype = #PB_EventType_LeftButtonDown And Not Transform()\grab
            If Transform()\id[Transform()\index]\color\state <> #__s_2
              If Not (_from_point_(mouse_x, mouse_y, Transform()\id[Transform()\index]) And Transform()\index <> #__a_moved)
                If a_set(Entered())
                  Protected i : a_index(Repaint, i)
                  ; Post(#PB_EventType_StatusChange, Entered(), Transform()\index)
                EndIf
              EndIf
              
              If _from_point_(mouse_x, mouse_y, Transform()\id[Transform()\index])
                Transform()\id[Transform()\index]\color\state = #__s_2
              EndIf
              
              ;get anchor delta pos
              If Transform()\index
                If Transform()\index = #__a_moved
                  If Mouse()\grid > 0
                    mouse_x = (mouse_x / Mouse()\grid) * Mouse()\grid
                    mouse_y = (mouse_y / Mouse()\grid) * Mouse()\grid
                  EndIf
                  
                  Mouse()\delta\x = mouse_x - Entered()\x        
                  Mouse()\delta\y = mouse_y - Entered()\y
                Else
                  Mouse()\delta\x = mouse_x - Transform()\id[Transform()\index]\x
                  Mouse()\delta\y = mouse_y - Transform()\id[Transform()\index]\y
                EndIf
              EndIf
            EndIf
          EndIf 
            
            Repaint | a_events(eventtype)
        EndIf
        
        
        ProcedureReturn Repaint
      EndIf    
      
      If *this\type = #__type_window
        Repaint = Window_Events(*this, eventtype, mouse_x, mouse_y)
      EndIf
      
      If *this\type = #__type_property
        Repaint = Tree_Events(*this, eventtype, mouse_x, mouse_y)
      EndIf
      
      If *this\type = #PB_GadgetType_Tree
        Repaint = Tree_Events(*this, eventtype, mouse_x, mouse_y)
      EndIf
      
      If *this\type = #PB_GadgetType_ListView
        Repaint = ListView_Events(*this, eventtype, mouse_x, mouse_y)
      EndIf
      
      If *this\type = #PB_GadgetType_Editor 
        Repaint = Editor_Events(*this, eventtype, mouse_x, mouse_y)
      EndIf
      
      If *this\type = #PB_GadgetType_String
        Repaint = Editor_Events(*this, eventtype, mouse_x, mouse_y)
      EndIf
      
      If *this\type = #PB_GadgetType_Panel
        Repaint = Bar_Events(*this\gadget[#__panel_1], eventtype, mouse_x, mouse_y)
      EndIf
      
      ;- CheckBox_Events()
      If *this\type = #PB_GadgetType_Option Or
         *this\type = #PB_GadgetType_CheckBox
        
        Select eventtype
          Case #PB_EventType_LeftButtonDown : Repaint = #True
          Case #PB_EventType_LeftButtonUp   : Repaint = #True
          Case #PB_EventType_LeftClick
            If *this\type = #PB_GadgetType_CheckBox
              Repaint = SetState(*this, Bool(*this\button\state ! 1))
            Else
              Repaint = SetState(*this, 1)
            EndIf
            
            If Repaint
              Post(#PB_EventType_LeftClick, *this) 
            EndIf
        EndSelect
      EndIf
      
      ;- Button_Events()
      If *this\type = #PB_GadgetType_Button
        If *this\_state & #__s_toggled = #False
          Select eventtype
            Case #PB_EventType_MouseLeave     : Repaint = #True : *this\color\state = #__s_0 
            Case #PB_EventType_LeftButtonDown : Repaint = #True : *this\color\state = #__s_2
            Case #PB_EventType_MouseEnter     : Repaint = #True 
              If _is_selected_(*this)
                *this\color\state = #__s_2
              Else
                *this\color\state = #__s_1
              EndIf
          EndSelect
        EndIf
        
        If eventtype = #PB_EventType_LeftButtonUp 
          Repaint = #True
        EndIf
        
        If eventtype = #PB_EventType_LeftClick
          SetState(*this, Bool(Bool(*this\_state & #__s_toggled) ! 1))
          
          Post(#PB_EventType_LeftClick, *this) 
          Repaint = #True
        EndIf
        
        If *this\image[1]\id Or *this\image[2]\id
          *this\image = *this\image[1 + Bool(*this\color\state = #__s_2)]
        EndIf
      EndIf
      
      ;- Hyper_Events()
      If *this\type = #PB_GadgetType_HyperLink
        If eventtype <> #PB_EventType_MouseLeave And
           _from_point_(mouse_x - *this\x, mouse_y - *this\y, *this, [#__c_required])
          
          Select eventtype
            Case #PB_EventType_LeftClick : Post(eventtype, *this)
            Case #PB_EventType_LeftButtonUp   
              _set_cursor_(*this, *this\cursor)
              *this\color\state = #__s_1 
              Repaint = 1
              
            Case #PB_EventType_MouseMove 
              If *this\_state & #__s_selected = #False  
                _set_cursor_(*this, *this\cursor)
                *this\color\state = #__s_1 
                Repaint = 1
              EndIf
              
            Case #PB_EventType_LeftButtonDown 
              _set_cursor_(*this, #PB_Cursor_Default)
              *this\color\state = #__s_0 
              Repaint = 1
              
          EndSelect
        Else
          If *this\_state & #__s_selected = #False  
            _set_cursor_(*this, #PB_Cursor_Default)
            *this\color\state = #__s_0
            Repaint = 1
          EndIf
        EndIf
      EndIf
      
      ;
      If *this\type = #PB_GadgetType_Spin Or
         *this\type = #PB_GadgetType_tabBar Or
         *this\type = #PB_GadgetType_TrackBar Or
         *this\type = #PB_GadgetType_ScrollBar Or
         *this\type = #PB_GadgetType_ProgressBar Or
         *this\type = #PB_GadgetType_Splitter
        
        Repaint = Bar_Events(*this, eventtype, mouse_x, mouse_y, _wheel_x_, _wheel_y_)
      EndIf
      
      ;
      If MapSize(*this\bind()) 
        ;ForEach *this\bind()
        If This()\event <> eventtype  
          ;If FindMapElement(*this\bind()\events(), Hex(eventtype)) 
          If FindMapElement(*this\bind(), Hex(eventtype)) 
            Post(eventtype, *this, *this\index[#__s_1])
          EndIf
        EndIf
        ;Next
      EndIf
      
      ProcedureReturn Repaint
    EndProcedure
    
    Procedure CallBack()
      Protected Canvas.i = EventGadget()
      Protected eventtype.i = EventType()
      Protected Repaint, Change, enter, leave
      Protected Width = GadgetWidth(Canvas)
      Protected Height = GadgetHeight(Canvas)
      Protected mouse_x = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
      Protected mouse_y = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
      ;      mouse_x = DesktopMouseX() - GadgetX(Canvas, #PB_Gadget_ScreenCoordinate)
      ;      mouse_y = DesktopMouseY() - GadgetY(Canvas, #PB_Gadget_ScreenCoordinate)
      Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
      Protected *this._s_widget = GetGadgetData(Canvas)
      
      If Root() <> *this\root
        ; Root() = *this\root
        ChangeCurrentElement(Root(), @*this\root\adress)
      EndIf
      
      Select eventtype
        Case #__Event_repaint 
          Repaint = 1
          If #debug_repaint
            Debug " - -  Canvas repaint - -  "; + widget()\row\count
          EndIf
          
        Case #__Event_resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          Repaint = Resize(Root(), #PB_Ignore, #PB_Ignore, Width, Height)  
          
          ;           If Not _is_root_(*this)
          ;             Repaint = Resize(*this, #PB_Ignore, #PB_Ignore, Width, Height)  
          ;             ;            ; PushListPosition(widget())
          ;             ;         ForEach widget()
          ;             ;           Resize(widget(), #PB_Ignore, #PB_Ignore, Width, Height)  
          ;             ;         Next
          ;             ;         ; PopListPosition(widget())
          ;           EndIf
          
          Repaint = 1
          
      EndSelect
      
      ; set default value
      If eventtype = #__Event_leftButtonDown
        Mouse()\buttons | #PB_Canvas_LeftButton
        
      ElseIf eventtype = #__Event_rightButtonDown
        Mouse()\buttons | #PB_Canvas_RightButton
        
      ElseIf eventtype = #__Event_MiddleButtonDown
        Mouse()\buttons | #PB_Canvas_MiddleButton
        
      ElseIf eventtype = #__Event_MouseWheel
        Mouse()\wheel\y = GetGadgetAttribute(Root()\canvas\gadget, #PB_Canvas_WheelDelta)
        
      ElseIf eventtype = #__Event_Input 
        Keyboard()\input = GetGadgetAttribute(Root()\canvas\gadget, #PB_Canvas_Input)
        
      ElseIf (eventtype = #__Event_KeyUp Or
              eventtype = #__Event_KeyDown)
        Keyboard()\Key = GetGadgetAttribute(Root()\canvas\gadget, #PB_Canvas_Key)
        Keyboard()\key[1] = GetGadgetAttribute(Root()\canvas\gadget, #PB_Canvas_Modifiers)
      EndIf
      
      ; x&y mouse
      If (eventtype = #__Event_MouseMove Or 
          eventtype = #__Event_MouseEnter Or 
          eventtype = #__Event_MouseLeave)
        
        If Mouse()\x <> mouse_x
          Mouse()\x = mouse_x
          change = #True
        EndIf
        
        If Mouse()\y <> mouse_y
          Mouse()\y = mouse_y
          change = #True
        EndIf
        
        If (eventtype = #__Event_MouseEnter Or 
            eventtype = #__Event_MouseLeave) And 
           change And Not Mouse()\buttons 
          change =- 1
        EndIf
      EndIf
      
      ; enter&leave mouse events
      If change
        ; get at point
        If Root()\count\childrens
          LastElement(widget()) 
          Repeat                                 
            If _is_widget_(widget()) And
               Not widget()\hide And widget()\draw And 
               widget()\root\canvas\gadget = Root()\canvas\gadget And 
               _from_point_(mouse_x, mouse_y, widget(), [#__c_clip])
              
              *this = widget()
              
              ; scrollbars events
              If *this And *this\scroll
                If *this\scroll\v And Not *this\scroll\v\hide And *this\scroll\v\type And 
                   _from_point_(mouse_x,mouse_y, *this\scroll\v, [#__c_clip])
                  *this = *this\scroll\v
                ElseIf *this\scroll\h And Not *this\scroll\h\hide And *this\scroll\h\type And 
                       _from_point_(mouse_x,mouse_y, *this\scroll\h, [#__c_clip])
                  *this = *this\scroll\h
                EndIf
              EndIf
              
              ; tabbar events
              If *this And *this\gadget[#__panel_1] 
                If Not *this\gadget[#__panel_1]\hide And  *this\gadget[#__panel_1]\type And 
                   _from_point_(mouse_x,mouse_y, *this\gadget[#__panel_1], [#__c_clip])
                  *this = *this\gadget[#__panel_1]
                EndIf
              EndIf
              
              Break
            EndIf
          Until PreviousElement(widget()) = #False 
        EndIf
        
        If Not *this : *this = Root() : EndIf
        
        ; entered&leaved events 
        If Entered() <> *this
          If Entered() And Entered()\_state & #__s_entered And 
             Not (#__from_mouse_state And Child(*this, Entered()))
            Entered()\_state &~ #__s_entered
            
            Repaint | Events(Entered(), #__Event_MouseLeave, mouse_x, mouse_y)
            
            If #__from_mouse_state
              ;ChangeCurrentElement(widget(), Entered()\adress)
              SelectElement(widget(), Entered()\index)
              Repeat                 
                If widget()\draw And Child(Entered(), widget())
                  If widget()\_state & #__s_entered
                    widget()\_state &~ #__s_entered
                    
                    Repaint | Events(widget(), #__Event_MouseLeave, mouse_x, mouse_y)
                  EndIf
                EndIf
              Until PreviousElement(widget()) = #False 
            EndIf
            
            Entered() = *this
          EndIf
          
          If *this And
             *this\_state & #__s_entered = #False
            *this\_state | #__s_entered
            Entered() = *this
            
            If #__from_mouse_state
              ForEach widget()
                If widget() = Entered()
                  Break
                EndIf
                
                If widget()\draw And Child(Entered(), widget())
                  If widget()\_state & #__s_entered = #False
                    widget()\_state | #__s_entered
                    
                    Repaint | Events(widget(), #__Event_MouseEnter, mouse_x, mouse_y)
                  EndIf
                EndIf
              Next
            EndIf
            
            Repaint | Events(Entered(), #__Event_MouseEnter, mouse_x, mouse_y)
          EndIf
        EndIf  
      EndIf
      
;       ; events anchors on the widget
;       If Transform() And Transform()\widget
;         Repaint | a_events(eventtype)
;       EndIf
       
      ; set active widget
      If (eventtype = #__Event_leftButtonDown Or
          eventtype = #__Event_rightButtonDown) 
        
        If _is_widget_(Entered()) 
          Focused() = Entered()
          Entered()\_state | #__s_selected
          Entered()\time_down = ElapsedMilliseconds()
          
          If eventtype = #__Event_leftButtonDown And Entered()\transform 
;             If Transform()\id[Transform()\index]\color\state <> #__s_2
;               If Not (_from_point_(mouse_x, mouse_y, Transform()\id[Transform()\index]) And Transform()\index <> #__a_moved)
;                 If a_set(Entered())
;                   Protected i : a_index(Repaint, i)
;                   ; Post(#PB_EventType_StatusChange, Entered(), Transform()\index)
;                 EndIf
;               EndIf
;               
;               If _from_point_(mouse_x, mouse_y, Transform()\id[Transform()\index])
;                 Transform()\id[Transform()\index]\color\state = #__s_2
;               EndIf
;               
;               ;get anchor delta pos
;               If Transform()\index
;                 If Transform()\index = #__a_moved
;                   If Mouse()\grid > 0
;                     mouse_x = (mouse_x / Mouse()\grid) * Mouse()\grid
;                     mouse_y = (mouse_y / Mouse()\grid) * Mouse()\grid
;                   EndIf
;                   
;                   Mouse()\delta\x = mouse_x - Entered()\x        
;                   Mouse()\delta\y = mouse_y - Entered()\y
;                 Else
;                   Mouse()\delta\x = mouse_x - Transform()\id[Transform()\index]\x
;                   Mouse()\delta\y = mouse_y - Transform()\id[Transform()\index]\y
;                 EndIf
;               EndIf
;             EndIf
;             
;             Repaint = 1
          Else
            
            If Entered()\bar\from > 0
              Debug "   debug >> "+ #PB_Compiler_Procedure +" ( "+#PB_Compiler_Line +" )"
              ; bar mouse delta pos
              If Entered()\bar\from = #__b_3
                Mouse()\delta\x = mouse_x - Entered()\bar\thumb\pos
                Mouse()\delta\y = mouse_y - Entered()\bar\thumb\pos
              EndIf
            Else
              Debug "   debug >> "+ #PB_Compiler_Procedure +" ( "+#PB_Compiler_Line +" )"
              Mouse()\delta\x = mouse_x - Entered()\x[#__c_draw]
              Mouse()\delta\y = mouse_y - Entered()\y[#__c_draw]
            EndIf
            
            ;           If Entered()\child  
            ;             Repaint | SetActive(Entered()\parent)
            ;           Else
            Repaint | SetActive(Entered())
            ;           EndIf
          EndIf
        EndIf
      EndIf
      
      ;
      If     eventtype = #__Event_repaint 
        
      ElseIf eventtype = #__Event_leftClick 
      ElseIf eventtype = #__Event_leftDoubleClick 
      ElseIf eventtype = #__Event_rightClick 
      ElseIf eventtype = #__Event_rightDoubleClick 
        
      ElseIf eventtype = #__Event_DragStart 
      ElseIf eventtype = #__Event_Focus
        
      ElseIf eventtype = #__Event_lostFocus
        If GetActive()
          ; если фокус получил PB gadget
          ; то убираем фокус с виджета
          Repaint | Events(GetActive(), #__Event_lostFocus, mouse_x, mouse_y)
          
          If GetActive()\gadget And GetActive() <> GetActive()\gadget
            Repaint | Events(GetActive()\gadget, #__Event_lostFocus, mouse_x, mouse_y)
            GetActive()\gadget = 0
          EndIf
          
          ; GetActive() = 0
        EndIf
        
      ElseIf eventtype = #__Event_MouseEnter 
        If Entered() And 
           Entered()\_state & #__s_entered = #False
          Entered()\_state | #__s_entered
          ; Debug "enter " + Entered()\class
          
          Repaint | Events(Entered(), #__Event_MouseEnter, mouse_x, mouse_y)
        EndIf
        
      ElseIf eventtype = #__Event_MouseLeave 
        If Entered() And 
           Entered()\_state & #__s_entered
          Entered()\_state &~ #__s_entered
          ; Debug "leave " + Entered()\class
          
          Repaint | Events(Entered(), #__Event_MouseLeave, mouse_x, mouse_y)
        EndIf
        
      ElseIf eventtype = #__Event_MouseMove 
        If change
          If Mouse()\buttons And
             Mouse()\drag = #False ; And Entered() And _from_point_(Mouse()\x, Mouse()\y, Entered(), [#__c_inner])
            
            ; mouse drag start
            Mouse()\drag = #True
            repaint | Events(Entered(), #__Event_DragStart, mouse_x, mouse_y)
          Else
            ; mouse move from entered widget
            If Entered()
              Repaint | Events(Entered(), eventtype, mouse_x, mouse_y)
            EndIf
            
            ; mouse move from selected widget
            If Focused() And
               Focused() <> Entered() And 
               Focused()\_state & #__s_selected
              Repaint | Events(Focused(), eventtype, mouse_x, mouse_y)
            EndIf
          EndIf
        EndIf
        
      ElseIf eventtype = #__Event_leftButtonUp Or 
             eventtype = #__Event_rightButtonUp Or
             eventtype = #__Event_MiddleButtonUp
        
        ; reset mouse buttons
        If Mouse()\buttons
          If eventtype = #__Event_leftButtonUp
            Mouse()\buttons &~ #PB_Canvas_LeftButton
          ElseIf eventtype = #__Event_rightButtonUp
            Mouse()\buttons &~ #PB_Canvas_RightButton
          ElseIf eventtype = #__Event_MiddleButtonUp
            Mouse()\buttons &~ #PB_Canvas_MiddleButton
          EndIf
          
          ; up mouse buttons
          If Not Mouse()\buttons And
             _is_widget_(Focused()) And
             Focused()\_state & #__s_selected 
            
            ; up buttons events
            Repaint | Events(Focused(), eventtype, mouse_x, mouse_y)
            Focused()\_state &~ #__s_selected ; ???
            
            If Focused()\_state & #__s_entered
              If eventtype = #__Event_leftButtonUp
                Repaint | Events(Focused(), #__Event_leftClick, mouse_x, mouse_y)
              EndIf
              If eventtype = #__Event_rightButtonUp
                Repaint | Events(Focused(), #__Event_rightClick, mouse_x, mouse_y)
              EndIf
              
              If (Focused()\time_click And (ElapsedMilliseconds() - Focused()\time_click) < DoubleClickTime())
                If eventtype = #__Event_leftButtonUp
                  Repaint | Events(Focused(), #__Event_leftDoubleClick, mouse_x, mouse_y)
                EndIf
                If eventtype = #__Event_rightButtonUp
                  Repaint | Events(Focused(), #__Event_rightDoubleClick, mouse_x, mouse_y)
                EndIf
                
                Focused()\time_click = 0
              Else
                Focused()\time_click = ElapsedMilliseconds()
              EndIf
            EndIf
            
            Mouse()\delta\x = 0
            Mouse()\delta\y = 0
            Mouse()\drag = 0
          EndIf
        EndIf
        
      ElseIf eventtype = #__Event_Input Or
             eventtype = #__Event_KeyDown Or
             eventtype = #__Event_KeyUp
        
        ; keyboard events
        If Focused()
          Repaint | Events(Focused(), eventtype, mouse_x, mouse_y)
        EndIf
        
      Else
        If eventtype <> #__Event_MouseMove
          change = 1
        EndIf
        
        If Entered() And change
          Repaint | Events(Entered(), eventtype, mouse_x, mouse_y)
        EndIf
        If Focused() And Entered() <> Focused() And Focused()\_state & #__s_selected And change 
          Repaint | Events(Focused(), eventtype, mouse_x, mouse_y)
        EndIf
      EndIf
      
      If Repaint 
         ReDraw(Root())
         ProcedureReturn Repaint
      EndIf
    EndProcedure
    
    Procedure CW_resize()
      Protected canvas = GetWindowData(EventWindow())
      ; Protected *this._s_widget = GetGadgetData(Canvas)
      ResizeGadget(canvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow()) - GadgetX(canvas)*2, WindowHeight(EventWindow()) - GadgetY(canvas)*2)
    EndProcedure
    
    Procedure CW_Active()
      Protected Repaint
      Protected canvas = GetWindowData(EventWindow())
      Protected *this._s_widget = GetGadgetData(Canvas)
      
    EndProcedure
    
    Procedure CW_Deactive()
      Protected Repaint
      Protected canvas = GetWindowData(EventWindow())
      Protected *this._s_widget = GetGadgetData(Canvas)
      
      If Root() <> *this\root
        ChangeCurrentElement(Root(), @*this\root\adress)
        ; Root() = *this\root
      EndIf
      
      If GetActive()
        Repaint | Events(GetActive(), #__Event_lostFocus, Mouse()\x, Mouse()\y)
        
        If GetActive()\gadget And GetActive() <> GetActive()\gadget
          Repaint | Events(GetActive()\gadget, #__Event_lostFocus, Mouse()\x, Mouse()\y)
          GetActive()\gadget = 0
        EndIf
        
        If Repaint 
          ReDraw(Root())
        EndIf 
        
        GetActive() = 0
      EndIf
    EndProcedure
    
    ;-
    Procedure   Open(window, x.l = 0,y.l = 0,width.l = #PB_Ignore,height.l = #PB_Ignore, flag.i = #Null, *CallBack = #Null, Canvas = #PB_Any)
      If width = #PB_Ignore And
         height = #PB_Ignore
        flag | #PB_Canvas_Container
      EndIf
      
      If Not IsWindow(window) 
        window = GetWindow(Root())
        
        If Not (IsWindow(window) And widget() = Root()\canvas\container)
          window = OpenWindow(#PB_Any, widget()\x,widget()\y,widget()\width,widget()\height, "", #PB_Window_BorderLess)
        EndIf
      EndIf
      
      If width = #PB_Ignore
        width = WindowWidth(window, #PB_Window_InnerCoordinate) - x*2
      EndIf
      
      If height = #PB_Ignore
        height = WindowHeight(window, #PB_Window_InnerCoordinate) - y*2
      EndIf
      
      Protected g = CanvasGadget(Canvas, X, Y, Width, Height, Flag|#PB_Canvas_Keyboard) : If Canvas =- 1 : Canvas = g : EndIf
      
      AddElement(Root()) 
      Root() = AllocateStructure(_s_root)
      Root()\adress = Root()
      Root()\class = "Root"
      
      Opened() = Root()
      Entered() = Root()
      Root()\root = Root()
      Root()\parent = Root()
      Root()\window = Root()
      Root()\container = #__type_root
      
      Root()\canvas\window = Window
      Root()\canvas\gadget = Canvas
      Root()\text\fontID = PB_(GetGadgetFont)(#PB_Default)
      
      ; 
      GetActive() = Root()
      GetActive()\root = Root()
      
      SetGadgetData(Canvas, Root())
      SetWindowData(window, Canvas)
      
      Resize(Root(), 0,0,width,height) ;??
      
      If flag & #PB_Canvas_Container = #PB_Canvas_Container
        If ListSize(widget())
          If widget()\container =- 1
            _set_align_flag_(widget(), Root(), #__flag_autosize)
            Root()\canvas\container = widget()
            OpenList(widget())
            SetParent(widget(), Root())
          EndIf
        Else
          Root()\canvas\container =- 1
        EndIf
        
        BindEvent(#PB_Event_SizeWindow, @CW_resize(), Window);, Canvas)
      EndIf
      
      BindEvent(#PB_Event_ActivateWindow, @CW_Active(), Window);, Canvas)
      BindEvent(#PB_Event_DeactivateWindow, @CW_Deactive(), Window);, Canvas)
      
      ; z - order
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        SetWindowLongPtr_( GadgetID(Canvas), #GWL_STYLE, GetWindowLongPtr_( GadgetID(Canvas), #GWL_STYLE ) | #WS_cLIPSIBLINGS )
        SetWindowPos_( GadgetID(Canvas), #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
      CompilerEndIf
      
      If Not *CallBack
        Root()\repaint = #True
      Else
        BindGadgetEvent(Canvas, *CallBack)
      EndIf
      BindGadgetEvent(Canvas, @CallBack())
      
      PostEvent(#PB_Event_Gadget, Window, Canvas, #PB_EventType_Resize)
      ProcedureReturn Root()
    EndProcedure
    
    Procedure.i Window(X.l,Y.l,Width.l,Height.l, Text.s, Flag.i = 0, *parent._s_widget = 0)
      
      Width + #__border_size*2
      Height + Bool(Flag)*#__caption_height+#__border_size*2
      
      If Not ListSize(Root())
        Protected root = Open(OpenWindow(#PB_Any, X,Y,Width,Height, "", #PB_Window_BorderLess, *parent))
        Flag | #__flag_autosize
        x = 0
        y = 0
      EndIf
      
      Protected *this._s_widget = AllocateStructure(_s_widget) 
      
      If *parent
        If Root() = *parent 
          Root()\parent = *this
        EndIf
      Else
        If Root()\canvas\container > 1
          *parent = Root()\canvas\container 
        Else
          *parent = Root()
        EndIf
      EndIf
      
      With *this
        If root
          Root()\canvas\container = *this
        EndIf
        
        *this\container =- 1
        *this\x[#__c_frame] =- 2147483648
        *this\y[#__c_frame] =- 2147483648
        *this\index[#__s_1] =- 1
        *this\index[#__s_2] = 0
        
        
        *this\type = #__type_Window
        *this\class = #PB_Compiler_Procedure
        
        *this\color = _get_colors_()
        *this\color\back = $FFF9F9F9
        
        ; Background image
        \image\img =- 1
        
        
        ;       \mode\window\sizeGadget = constants::_check_(flag, #__Window_SizeGadget)
        ; ;       \mode\window\systemMenu = constants::_check_(flag, #__Window_SystemMenu)
        ; ;       \mode\window\MinimizeGadget = constants::_check_(flag, #__Window_MinimizeGadget)
        ; ;       \mode\window\MaximizeGadget = constants::_check_(flag, #__Window_MaximizeGadget)
        ;       \mode\window\titleBar = constants::_check_(flag, #__Window_titleBar)
        ;       \mode\window\tool = constants::_check_(flag, #__Window_tool)
        ;       \mode\window\borderless = constants::_check_(flag, #__Window_borderLess)
        
        \caption\round = 4
        \caption\_padding = \caption\round
        \caption\color = _get_colors_()
        
        ;\caption\hide = constants::_check_(flag, #__flag_borderless)
        \caption\hide = constants::_check_(flag, #__Window_titleBar, #False)
        \caption\button[0]\hide = constants::_check_(flag, #__Window_SystemMenu, #False)
        \caption\button[1]\hide = constants::_check_(flag, #__Window_MaximizeGadget, #False)
        \caption\button[2]\hide = constants::_check_(flag, #__Window_MinimizeGadget, #False)
        \caption\button[3]\hide = 1
        
        \caption\button[0]\color = colors::*this\red
        \caption\button[1]\color = colors::*this\blue
        \caption\button[2]\color = colors::*this\green
        
        *this\caption\button[0]\color\state = 1
        *this\caption\button[1]\color\state = 1
        *this\caption\button[2]\color\state = 1
        
        \caption\button[0]\round = 4 + 3
        \caption\button[1]\round = \caption\button[0]\round
        \caption\button[2]\round = \caption\button[0]\round
        \caption\button[3]\round = \caption\button[0]\round
        
        \caption\button[0]\width = 12 + 2
        \caption\button[0]\height = 12 + 2
        
        \caption\button[1]\width = \caption\button[0]\width
        \caption\button[1]\height = \caption\button[0]\height
        
        \caption\button[2]\width = \caption\button[0]\width
        \caption\button[2]\height = \caption\button[0]\height
        
        \caption\button[3]\width = \caption\button[0]\width*2
        \caption\button[3]\height = \caption\button[0]\height
        
        If \caption\button[1]\hide = 0 Or 
           \caption\button[2]\hide = 0
          \caption\button[0]\hide = 0
        EndIf
        
        If \caption\button[0]\hide = 0
          \caption\hide = 0
        EndIf
        
        If Not \caption\hide 
          *this\__height = constants::_check_(flag, #__flag_borderless, #False) * #__caption_height
          *this\round = 7
        EndIf
        
        If Text And \caption\height
          \caption\text\padding\x = 5
          \caption\text\string = Text
        EndIf
        
        *this\fs = constants::_check_(flag, #__flag_borderless, #False) * #__border_size
        
        _set_align_flag_(*this, *parent, flag)
        SetParent(*this, *parent, #PB_Default)
        
        If flag & #__Window_NoGadgets = #False
          OpenList(*this)
        EndIf
        
        ; this before resize() and after setparent()
        If Bool(flag & #__flag_anchorsGadget = #__flag_anchorsGadget)
          a_add(*this)
        EndIf
        
        If flag & #__Window_NoActivate = #False And Not *this\transform
          SetActive(*this)
        EndIf 
        
        If *this\fs And Not *this\transform
          *this\bs = *this\fs
        EndIf
        
        Resize(*this, X,Y,Width,Height)
      EndWith
      
      ProcedureReturn *this
    EndProcedure
    
    Procedure.i Gadget(Type.l, Gadget.i, X.l, Y.l, Width.l, Height.l, Text.s = "", *param1 = #Null, *param2 = #Null, *param3 = #Null, Flag.i = #Null,  window = -1, *CallBack = #Null)
      Protected *this, g
      
      If  window = -1
        window = GetActiveWindow()
      EndIf
      
      Flag = PBFlag(Type, Flag) | #__flag_autosize
      
      Open(Window, x,y,Width,Height, #Null, *CallBack, Gadget)
      
      Select Type
        Case #PB_GadgetType_Tree      : *this = Tree(0, 0, Width, Height, flag)
        Case #PB_GadgetType_Text      : *this = Text(0, 0, Width, Height, Text, flag)
        Case #PB_GadgetType_Button    : *this = Button(0, 0, Width, Height, Text, flag)
        Case #PB_GadgetType_Option    : *this = Option(0, 0, Width, Height, Text, flag)
        Case #PB_GadgetType_CheckBox  : *this = Checkbox(0, 0, Width, Height, Text, flag)
        Case #PB_GadgetType_HyperLink : *this = HyperLink(0, 0, Width, Height, Text, *param1, flag)
        Case #PB_GadgetType_Splitter  : *this = Splitter(0, 0, Width, Height, *param1, *param2, flag)
      EndSelect
      
      If Gadget =- 1
        Gadget = GetGadget(Root())
        g = Gadget
      Else
        g = GadgetID(Gadget)
      EndIf
      SetGadgetData(Gadget, *this)
      
      Entered() = *this
      
      ProcedureReturn g
    EndProcedure
    
    Procedure.i Free(*this._s_widget)
      Protected result.i
      
      With *this
        If *this
          If \scroll
            If \scroll\v : FreeStructure(\scroll\v) : \scroll\v = 0 : EndIf
            If \scroll\h : FreeStructure(\scroll\h)  : \scroll\h = 0 : EndIf
            ; *this\scroll = 0
          EndIf
          
          If \type = #PB_GadgetType_Splitter
            If \gadget[#__split_1] : FreeStructure(\gadget[#__split_1]) : \gadget[#__split_1] = 0 : EndIf
            If \gadget[#__split_2] : FreeStructure(\gadget[#__split_2])  : \gadget[#__split_2] = 0 : EndIf
          EndIf
          
          If \gadget[#__panel_1]
          EndIf
          
          If *this\parent 
            If *this\parent\scroll\v = *this
              FreeStructure(*this\parent\scroll\v) : *this\parent\scroll\v = 0
            EndIf
            If *this\parent\scroll\h = *this
              FreeStructure(*this\parent\scroll\h)  : *this\parent\scroll\h = 0
            EndIf
            
            If *this\parent\type = #PB_GadgetType_Splitter
              If *this\parent\gadget[#__split_1] = *this
                FreeStructure(*this\parent\gadget[#__split_1]) : *this\parent\gadget[#__split_1] = 0
              EndIf
              If *this\parent\gadget[#__split_2] = *this
                FreeStructure(*this\parent\gadget[#__split_2])  : *this\parent\gadget[#__split_2] = 0
              EndIf
            EndIf
          EndIf
          
          
          Debug  " free - " + ListSize(widget())  + " " +  *this\root\count\childrens  + " " +  *this\parent\count\childrens
          If *this\parent And
             *this\parent\count\childrens 
            
            LastElement(widget())
            Repeat
              If widget() = *this Or Child(widget(), *this)
                
                If widget()\root\count\childrens > 0 
                  widget()\root\count\childrens - 1
                  If widget()\parent <> widget()\root
                    widget()\parent\count\childrens - 1
                  EndIf
                  DeleteElement(widget(), 1)
                EndIf
                
                If Not *this\root\count\childrens
                  Break
                EndIf
              ElseIf PreviousElement(widget()) = 0
                Break
              EndIf
            ForEver
          EndIf
          Debug  "   free - " + ListSize(widget())  + " " +  *this\root\count\childrens  + " " +  *this\parent\count\childrens
          
          
          
          If Entered() = *this
            Entered() = *this\parent
          EndIf
          If Focused() = *this
            Focused() = *this\parent
          EndIf
          
          ; *this = 0
          ;ClearStructure(*this, _s_widget)
        EndIf
      EndWith
      
      ProcedureReturn result
    EndProcedure
    
  EndModule
  ;- <<< 
CompilerEndIf


;- 
Macro Uselib(_name_)
  UseModule _name_
  UseModule constants
  UseModule structures
EndMacro



; XIncludeFile "../examples/empty5.pb"

Uselib(widget)
 
;
; This code is automatically generated by the FormDesigner.
; Manual modification is possible to adjust existing commands, but anything else will be dropped when the code is compiled.
; Event procedures needs to be put in another source file.
;

;- 
EnableExplicit
UsePNGImageDecoder()
    
;- ENUMs
Enumeration 
  #_pi_group_0 
  #_pi_id
  #_pi_class
  #_pi_text
  
  #_pi_group_1 
  #_pi_x
  #_pi_y
  #_pi_width
  #_pi_height
  
  #_pi_group_2 
  #_pi_disable
  #_pi_hide
EndEnumeration

Enumeration 
  #_ei_leftclick
  #_ei_change
  #_ei_enter
  #_ei_leave
EndEnumeration

;- GLOBALs
Global window_ide, 
       canvas_ide

Global Splitter_ide, 
       Splitter_design, 
       splitter_debug, 
       Splitter_inspector, 
       splitter_help

Global toolbar_design, 
       listview_debug, 
       id_help_text

Global id_design_panel, 
       id_design_form,
       id_design_code

Global id_inspector_panel,
       id_inspector_tree, 
       id_elements_tree,
       id_properties_tree, 
       id_events_tree

Global group_1
Global group_select,
       group_drag, 
       NewList group_list()

UsePNGImageDecoder()

Global img = LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") 

;-
;- PUBLICs
Procedure.i GetClassType(Class.s)
  Protected Result.i
  
  Select Trim(Class.s)
    Case "Button"         : Result = #PB_GadgetType_Button
    Case "ButtonImage"    : Result = #PB_GadgetType_ButtonImage
    Case "Calendar"       : Result = #PB_GadgetType_Calendar
    Case "Canvas"         : Result = #PB_GadgetType_Canvas
    Case "CheckBox"       : Result = #PB_GadgetType_CheckBox
    Case "ComboBox"       : Result = #PB_GadgetType_ComboBox
    Case "Container"      : Result = #PB_GadgetType_Container
    Case "Date"           : Result = #PB_GadgetType_Date
    Case "Editor"         : Result = #PB_GadgetType_Editor
    Case "ExplorerCombo"  : Result = #PB_GadgetType_ExplorerCombo
    Case "ExplorerList"   : Result = #PB_GadgetType_ExplorerList
    Case "ExplorerTree"   : Result = #PB_GadgetType_ExplorerTree
    Case "Frame"          : Result = #PB_GadgetType_Frame
    Case "HyperLink"      : Result = #PB_GadgetType_HyperLink
    Case "Image"          : Result = #PB_GadgetType_Image
    Case "IPAddress"      : Result = #PB_GadgetType_IPAddress
    Case "ListIcon"       : Result = #PB_GadgetType_ListIcon
    Case "ListView"       : Result = #PB_GadgetType_ListView
    Case "MDI"            : Result = #PB_GadgetType_MDI
    Case "OpenGL"         : Result = #PB_GadgetType_OpenGL
    Case "Option"         : Result = #PB_GadgetType_Option
      ;Case "Popup"          : Result = #PB_GadgetType_Popup
    Case "Panel"          : Result = #PB_GadgetType_Panel
      ;Case "Property"       : Result = #PB_GadgetType_Property
    Case "ProgressBar"    : Result = #PB_GadgetType_ProgressBar
    Case "Scintilla"      : Result = #PB_GadgetType_Scintilla
    Case "ScrollArea"     : Result = #PB_GadgetType_ScrollArea
    Case "ScrollBar"      : Result = #PB_GadgetType_ScrollBar
    Case "Shortcut"       : Result = #PB_GadgetType_Shortcut
    Case "Spin"           : Result = #PB_GadgetType_Spin
    Case "Splitter"       : Result = #PB_GadgetType_Splitter
    Case "String"         : Result = #PB_GadgetType_String
    Case "Text"           : Result = #PB_GadgetType_Text
    Case "TrackBar"       : Result = #PB_GadgetType_TrackBar
    Case "Tree"           : Result = #PB_GadgetType_Tree
    Case "Unknown"        : Result = #PB_GadgetType_Unknown
    Case "Web"            : Result = #PB_GadgetType_Web
    Case "Window"         : Result = #__Type_Window
  EndSelect
  
  ProcedureReturn Result
EndProcedure

Procedure.i elements_list_fill(*id, Directory$)
  Protected ZipFile$ = Directory$ + "SilkTheme.zip"
  
  If FileSize(ZipFile$) < 1
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ZipFile$ = #PB_Compiler_Home+"themes\SilkTheme.zip"
    CompilerElse
      ZipFile$ = #PB_Compiler_Home+"themes/SilkTheme.zip"
    CompilerEndIf
    If FileSize(ZipFile$) < 1
      MessageRequester("Designer Error", "Themes\SilkTheme.zip Not found in the current directory" +#CRLF$+ "Or in PB_Compiler_Home\themes directory" +#CRLF$+#CRLF$+ "Exit now", #PB_MessageRequester_Error|#PB_MessageRequester_Ok)
      End
    EndIf
  EndIf
  ;   Directory$ = GetCurrentDirectory()+"images/" ; "";
  ;   Protected ZipFile$ = Directory$ + "images.zip"
  
  
  If FileSize(ZipFile$) > 0
    ; UsePNGImageDecoder()
    
    CompilerIf #PB_Compiler_Version > 522
      UseZipPacker()
    CompilerEndIf
    
    Protected PackEntryName.s, ImageSize, *Image, Image, ZipFile
    ZipFile = OpenPack(#PB_Any, ZipFile$, #PB_PackerPlugin_Zip)
    
    If ZipFile  
      If ExaminePack(ZipFile)
        While NextPackEntry(ZipFile)
          
          PackEntryName.S = PackEntryName(ZipFile)
          ImageSize = PackEntrySize(ZipFile)
          If ImageSize
            *Image = AllocateMemory(ImageSize)
            UncompressPackMemory(ZipFile, *Image, ImageSize)
            Image = CatchImage(#PB_Any, *Image, ImageSize)
            PackEntryName.S = ReplaceString(PackEntryName.S,".png","")
            If PackEntryName.S="application_form" 
              PackEntryName.S="vd_windowgadget"
            EndIf
            
            PackEntryName.S = ReplaceString(PackEntryName.S,"page_white_edit","vd_scintillagadget")   ;vd_scintillagadget.png not found. Use page_white_edit.png instead
            
            Select PackEntryType(ZipFile)
              Case #PB_Packer_File
                If Image
                  If FindString(Left(PackEntryName.S, 3), "vd_")
                    PackEntryName.S = ReplaceString(PackEntryName.S,"vd_"," ")
                    PackEntryName.S = Trim(ReplaceString(PackEntryName.S,"gadget",""))
                    
                    Protected Left.S = UCase(Left(PackEntryName.S,1))
                    Protected Right.S = Right(PackEntryName.S,Len(PackEntryName.S)-1)
                    PackEntryName.S = Left.S+Right.S
                    
                    If FindString(LCase(PackEntryName.S), "cursor")
                      
                      ;Debug "add cursor"
                      AddItem(*id, 0, PackEntryName.S, Image)
                      SetItemData(*id, 0, Image)
                      
                      ;                   ElseIf FindString(LCase(PackEntryName.S), "window")
                      ;                     
                      ;                     Debug "add window"
                      ;                     AddItem(*id, 1, PackEntryName.S, Image)
                      ;                     SetItemData(*id, 1, Image)
                      
                    ;ElseIf FindString(LCase(PackEntryName.S), "buttonimage")
                    ElseIf FindString(LCase(PackEntryName.S), "window")
                      AddItem(*id, -1, PackEntryName.S, Image)
                      SetItemData(*id, CountItems(*id)-1, Image)
                    ElseIf FindString(LCase(PackEntryName.S), "image")
                      AddItem(*id, -1, PackEntryName.S, Image)
                      SetItemData(*id, CountItems(*id)-1, Image)
                    ElseIf FindString(LCase(PackEntryName.S), "button")
                      AddItem(*id, -1, PackEntryName.S, Image)
                      SetItemData(*id, CountItems(*id)-1, Image)
                    ElseIf FindString(LCase(PackEntryName.S), "string")
                      AddItem(*id, -1, PackEntryName.S, Image)
                      SetItemData(*id, CountItems(*id)-1, Image)
                    ElseIf FindString(LCase(PackEntryName.S), "text")
                      AddItem(*id, -1, PackEntryName.S, Image)
                      SetItemData(*id, CountItems(*id)-1, Image)
                    ElseIf FindString(LCase(PackEntryName.S), "container")
                      AddItem(*id, -1, PackEntryName.S, Image)
                      SetItemData(*id, CountItems(*id)-1, Image)
                    ElseIf FindString(LCase(PackEntryName.S), "panel")
                      AddItem(*id, -1, PackEntryName.S, Image)
                      SetItemData(*id, CountItems(*id)-1, Image)
                    ElseIf FindString(LCase(PackEntryName.S), "scrollarea")
                      AddItem(*id, -1, PackEntryName.S, Image)
                      SetItemData(*id, CountItems(*id)-1, Image)
                    EndIf
                  EndIf
                EndIf    
            EndSelect
            
            FreeMemory(*Image)
          EndIf
        Wend  
      EndIf
      
      ; select cursor
      SetState(*id, 0)
      ClosePack(ZipFile)
    EndIf
  EndIf
EndProcedure


;-
Procedure Points(Steps = 5, BoxColor = 0, PlotColor = 0)
  Static ID
  Protected hDC, x,y
  
  If Not ID
    ;Steps - 1
    
    ExamineDesktops()
    Protected width = DesktopWidth(0)   
    Protected height = DesktopHeight(0)
    ID = CreateImage(#PB_Any, width, height, 32, #PB_Image_Transparent)
    
    If PlotColor = 0 : PlotColor = RGBA(1,1,1, 255) : EndIf
    If BoxColor = 0 : BoxColor = RGBA(236,236,236, 255) : EndIf
    
    If StartDrawing(ImageOutput(ID))
      DrawingMode(#PB_2DDrawing_AllChannels)
      ;Box(0, 0, width, height, BoxColor)
      
      For x = 0 To width - 1
        
        For y = 0 To height - 1
          
          ;If x > 0 And y > 0
          Plot(x, y, PlotColor)
          ;EndIf
          
          y + Steps
        Next
        
        x + Steps
      Next
      
      StopDrawing()
    EndIf
  EndIf
  
  ProcedureReturn ID
EndProcedure


;-
Macro update_properties_id(_gadget_, _value_)
  SetItemText(_gadget_, #_pi_id,      GetItemText(_gadget_, #_pi_id)      +Chr(10)+Str(_value_))
EndMacro

Macro update_properties_class(_gadget_, _value_)
  SetItemText(_gadget_, #_pi_class,   GetItemText(_gadget_, #_pi_class)   +Chr(10)+GetClass(_value_)+"_"+GetCount(_value_))
EndMacro

Macro update_properties_text(_gadget_, _value_)
  SetItemText(_gadget_, #_pi_text,    GetItemText(_gadget_, #_pi_text)    +Chr(10)+GetText(_value_))
EndMacro

Macro update_properties_disable(_gadget_, _value_)
  SetItemText(_gadget_, #_pi_disable, GetItemText(_gadget_, #_pi_disable) +Chr(10)+Str(Disable(_value_)))
EndMacro

Macro update_properties_hide(_gadget_, _value_)
  SetItemText(_gadget_, #_pi_hide,    GetItemText(_gadget_, #_pi_hide)    +Chr(10)+Str(Hide(_value_)))
EndMacro

Macro update_properties_coordinate(_gadget_, _value_)
  SetItemText(_gadget_, #_pi_x,       GetItemText(_gadget_, #_pi_x)       +Chr(10)+Str(X(_value_, #__c_container)))
  SetItemText(_gadget_, #_pi_y,       GetItemText(_gadget_, #_pi_y)       +Chr(10)+Str(Y(_value_, #__c_container)))
  SetItemText(_gadget_, #_pi_width,   GetItemText(_gadget_, #_pi_width)   +Chr(10)+Str(Width(_value_)))
  SetItemText(_gadget_, #_pi_height,  GetItemText(_gadget_, #_pi_height)  +Chr(10)+Str(Height(_value_)))
EndMacro

Macro update_properties(_gadget_, _value_)
  update_properties_id(_gadget_, _value_)
  update_properties_class(_gadget_, _value_)
  
  update_properties_text(_gadget_, _value_)
  update_properties_coordinate(_gadget_, _value_)
  
  update_properties_disable(_gadget_, _value_)
  update_properties_hide(_gadget_, _value_)
EndMacro


;-
Procedure.s FlagFromFlag( Type, flag.i ) ; 
  Protected flags.S
  
  Select type
    Case #PB_GadgetType_Text
      If flag & #__text_center
        flags + "#PB_Text_Center|"
      EndIf
      If flag & #__text_right
        flags + "#PB_Button_Right|"
      EndIf
      If flag & #__text_border
        flags + "#PB_Text_Border|"
      EndIf
      
    Case #PB_GadgetType_Button
      If flag & #__button_left
        flags + "#PB_Button_Left|"
      EndIf
      If flag & #__button_right
        flags + "#PB_Button_Right|"
      EndIf
      If flag & #__button_multiline
        flags + "#PB_Button_MultiLine|"
      EndIf
      If flag & #__button_toggle
        flags + "#PB_Button_Toggle|"
      EndIf
      If flag & #__button_default
        flags + "#PB_Button_Default|"
      EndIf
      
    Case #PB_GadgetType_Container
      If flag & #__flag_borderless
        flags + "#PB_Container_BorderLess|"
      EndIf
      ;         If flag & #__flag_flat
      ;           flags + "#PB_Container_Border|"
      ;         EndIf
      
  EndSelect
  
  ProcedureReturn Trim(flags, "|")
EndProcedure

Procedure$ add_line(*new._s_widget, Handle$) ; Ok
  Protected ID$, Result$, param1$, param2$, param3$, Text$, flag$
  
  flag$ = FlagFromFlag(*new\type, *new\_flag)
  
  Select Asc(Handle$)
    Case '#'        : ID$ = Handle$           : Handle$ = ""
    Case '0' To '9' : ID$ = Chr(Asc(Handle$)) : Handle$ = ""
    Default         : ID$ = "#PB_Any"         : Handle$ + " = "
  EndSelect
  
  Text$ = Chr(34)+*new\text\string+Chr(34)
  
  If *new\class = "Window"
    Result$ = Handle$ +"Window("+ *new\x +", "+ *new\y +", "+ *new\width +", "+ *new\height
  Else
    ; type_$ = "Gadget("+ID$+", "
    Result$ = Handle$ + *new\class +"("+ *new\x +", "+ *new\y +", "+ *new\width +", "+ *new\height
  EndIf
  
  Select *new\class
    Case "Window" : Result$ +", "+ Text$                                                                          
      If param1$ : Result$ +", "+ param1$ : EndIf 
      
    Case "ScrollArea"    : Result$ +", "+ param1$ +", "+ param2$    
      If param3$ : Result$ +", "+ param3$ : EndIf 
      
    Case "Calendar"      
      If param1$ : Result$ +", "+ param1$ : EndIf 
      If param1$ : Result$ +", "+ param1$ : EndIf 
      
    Case "Button"        : Result$ +", "+ Text$                                                                               
    Case "String"        : Result$ +", "+ Text$                                                                               
    Case "Text"          : Result$ +", "+ Text$                                                                                 
    Case "CheckBox"      : Result$ +", "+ Text$                                                                             
    Case "Option"        : Result$ +", "+ Text$
    Case "Frame"         : Result$ +", "+ Text$                                                                                
    Case "Web"           : Result$ +", "+ Text$
    Case "Date"          : Result$ +", "+ Text$              
    Case "ExplorerList"  : Result$ +", "+ Text$                                                                         
    Case "ExplorerTree"  : Result$ +", "+ Text$                                                                         
    Case "ExplorerCombo" : Result$ +", "+ Text$                                                                        
      
    Case "HyperLink"     : Result$ +", "+ Text$ +", "+ param1$                                                       
    Case "ListIcon"      : Result$ +", "+ Text$ +", "+ param1$                                                        
      
    Case "Image"         : Result$ +", "+ param1$   
    Case "Scintilla"     : Result$ +", "+ param1$
    Case "Shortcut"      : Result$ +", "+ param1$
    Case "ButtonImage"   : Result$ +", "+ param1$                                                                                             
      
    Case "TrackBar"      : Result$ +", "+ param1$ +", "+ param2$                                                                         
    Case "Spin"          : Result$ +", "+ param1$ +", "+ param2$                                                                             
    Case "Splitter"      : Result$ +", "+ param1$ +", "+ param2$                                                                         
    Case "MDI"           : Result$ +", "+ param1$ +", "+ param2$                                                                              
    Case "ProgressBar"   : Result$ +", "+ param1$ +", "+ param2$                                                                      
    Case "ScrollBar"     : Result$ +", "+ param1$ +", "+ param2$ +", "+ param3$                                                 
  EndSelect
  
  If flag$ : Result$ +", "+ flag$ : EndIf 
  
  Result$+")" 
  
  ProcedureReturn Result$
EndProcedure

Procedure add_code(*new._s_widget, Class.s, Position.i, SubLevel.i)
  Protected code.s 
  
  ;   code = Space((*new\level-2)*4) +
  ;          Class +" = "+ 
  ;          *new\class +"(" + 
  ;          *new\x +", "+
  ;          *new\y +", "+ 
  ;          *new\width +", "+ 
  ;          *new\height +", "+ 
  ;          *new\text\string +", "+ 
  ;          FlagFromFlag(*new\type, *new\_flag)+
  ;          ")"
  
  code = Space((*new\level-2)*4) + add_line(*new._s_widget, Class.s)
  
  ;   ForEach widget()
  ;     If Child(widget(), id_design_form)
  ;       Debug widget()\class
  ;     EndIf
  ;   Next
  
  If IsGadget(listview_debug)
    AddGadgetItem(listview_debug, Position, code)
  Else
    AddItem(listview_debug, Position, code)
  EndIf
EndProcedure


;-
Declare events_element()

Procedure  GetItemChildrens(*this._s_widget, Item.l, Column.l = 0)
  Protected result
  
  If *this\count\items ; row\count
    If _no_select_(*this\row\_s(), Item) 
      ProcedureReturn #False
    EndIf
    
    Result = *this\row\_s()\childrens
  EndIf
  
  ProcedureReturn result
EndProcedure


Procedure add_element(gadget.i, *new._s_widget, Class.s)
  Protected img =- 1
  Protected Parent = GetParent(*new)
  Protected Position = GetData(Parent) 
  ; Protected Position = GetState(gadget) + 1
  Protected i, CountItems = CountItems(gadget)
  Protected *Sublevel, SubLevel ;= GetLevel(Parent) - 1 ; level mdi minus
  
  ; get childrens position and sublevel
  For i = 0 To CountItems - 1
    If Parent = GetItemData(gadget, i)
      SubLevel = GetItemAttribute(gadget, i, #PB_Tree_SubLevel) + 1
      Position = (i+1)
    EndIf
    
    If SubLevel <= GetItemAttribute(gadget, i, #PB_Tree_SubLevel)
      Position = (i+1)
    EndIf
  Next 
  
  SetText(*new, Class)
  SetData(*new, Position)
  
  ; update this widget date item
  For i = Position To CountItems - 1
    SetData( GetItemData(gadget, i), i + 1)
  Next 
  
  Position = GetData(*new)
  
  ; img = GetItemData(id_elements_tree, GetState(id_elements_tree))
  CountItems = CountItems(id_elements_tree)
  
  For i = 0 To CountItems - 1
    If StringField(Class, 1, "_") = GetItemText(id_elements_tree, i)
      img = GetItemData(id_elements_tree, i)
      Break
    EndIf
  Next  
  
  ; add to inspector
  AddItem(gadget, Position, Class.s, img, SubLevel)
  SetItemData(gadget, Position, *new)
  ; SetItemState(gadget, Position, #PB_Tree_Selected)
  SetState(gadget, Position)
  
  ;   If IsGadget(listview_debug)
  ;     AddGadgetItem(listview_debug, Position, Class.s, 0, SubLevel)
  ;     SetGadgetItemData(listview_debug, Position, *new)
  ;     ; SetGadgetItemState(listview_debug, Position, #PB_Tree_Selected)
  ;     SetGadgetState(listview_debug, Position) ; Bug
  ;   EndIf
  
  ; Debug  " pos "+Position + "   (debug >> "+ #PB_Compiler_Procedure +" ( "+#PB_Compiler_Line +" ))"
  add_code(*new, Class, Position, SubLevel)
  
  ProcedureReturn Position
EndProcedure

Procedure create_element(*parent._s_widget, class.s, x.l,y.l, width.l=0, height.l=0)
  Protected *new._s_widget, *param1, *param2, *param3
  Protected Position =- 1, flag.i
  
  If *parent 
    If Not *parent\transform
      a_add(*parent)
    EndIf
    
    If Mouse()\grid
      x = (x/Mouse()\grid) * Mouse()\grid
      y = (y/Mouse()\grid) * Mouse()\grid
      width = (width/Mouse()\grid) * Mouse()\grid + 1
      height = (height/Mouse()\grid) * Mouse()\grid + 1
    EndIf
    
    class.s = LCase(Trim(class))
    OpenList(*parent, GetState(*parent)) 
    
    ; create elements
    Select class
      Case "window"    
        If GetType(*parent) = #PB_GadgetType_MDI
          *new = AddItem(*parent, #PB_Any, "", - 1, flag)
          Resize(*new, #PB_Ignore, #PB_Ignore,width,height)
        Else
          *new = Window(x,y,width,height, "", flag, *parent)
        EndIf
        
        Bind(*new, @events_element())
        
      Case "container"   : *new = Container(x,y,width,height, flag)                             : CloseList()
      Case "panel"       : *new = Panel(x,y,width,height, flag) : AddItem(*new, -1, class+"_0") : CloseList()
      Case "scrollarea"  : *new = ScrollArea(x,y,width,height, *param1, *param2, *param3, flag) : CloseList()
        
      Case "image"       : *new = Image(x,y,width,height, img, flag)
      Case "buttonimage" : *new = ButtonImage(x,y,width,height, img, flag)
        
      Case "button"      : *new = Button(x,y,width,height, "", flag) 
      Case "string"      : *new = String(x,y,width,height, "", flag)
      Case "text"        : *new = Text(x,y,width,height, "", flag)
    EndSelect
    
    If *new
      If *new\container =- 1
        SetImage(*new, Points(Mouse()\grid-1))
      EndIf
      
      Class.s = GetClass(*new)+"_"+GetCount(*new)
      add_element(id_inspector_tree, *new, Class.s)
    EndIf
    
    CloseList() 
  EndIf
  
  ProcedureReturn *new
EndProcedure


Procedure events_element()
  Protected e_type = this()\event
  Protected e_widget = this()\widget
  
  If this()\widget\container
    Select e_type 
      Case #PB_EventType_LeftButtonDown
        If group_select 
          group_drag = e_widget
          Debug 8888
          Transform()\grab = 1
        EndIf
        
        If GetState(id_elements_tree) > 0
          If Not Transform()
            Transform()._structure_(transform)
          EndIf
          Transform()\grab = 1
        EndIf
        
      Case #PB_EventType_MouseEnter
        If GetState(id_elements_tree) > 0
          SetCursor(e_widget, #PB_Cursor_Cross)
        EndIf
        
      Case #PB_EventType_MouseLeave
        If GetState(id_elements_tree) > 0 
          If Not Pressed()
            SetCursor(e_widget, #PB_Cursor_Default)
          EndIf
        EndIf
        
      
    EndSelect
  EndIf
  
  Select e_type 
    Case #PB_EventType_MouseMove
    Case #PB_EventType_LeftButtonUp
      If Transform()\grab
        If GetState(id_elements_tree) > 0
            
          If Not Transform()\id\width
            Transform()\id\width = 50
            Transform()\id\x = Mouse()\delta\x + Focused()\x
          EndIf
          
          If Not Transform()\id\height
            Transform()\id\height = 50
            Transform()\id\y = Mouse()\delta\y + Focused()\y
          EndIf
          
          Transform()\id\x - Focused()\x[#__c_inner]
          Transform()\id\y - Focused()\y[#__c_inner]
          
          create_element(e_widget, 
                         GetText(id_elements_tree),
                         Transform()\id\x,
                         Transform()\id\y, 
                         Transform()\id\width, 
                         Transform()\id\height)
          
          
          SetState(id_elements_tree, 0)
        EndIf
        
        If group_drag And 
           group_select And 
           GetState(id_elements_tree) = 0
          
          ClearList(group_list())
          
          ForEach widget()
            If child(widget(), e_widget) And Intersect(widget(), Transform()\id) And widget() <> Transform()\widget
              Debug widget()\class +"_"+ widget()\count\index ; Str(widget()\index-widget()\window\index)
              AddElement(group_list()) 
              group_list() = widget()
            EndIf
          Next
          
          group_drag = 0
        EndIf
        
        Transform()\grab = 0
      EndIf
      
      
    Case #PB_EventType_StatusChange
      SetState(id_inspector_tree, GetData(e_widget))
      If IsGadget(listview_debug)
        SetGadgetState(listview_debug, GetData(e_widget))
      EndIf
      update_properties(id_properties_tree, e_widget)
      
    Case #PB_EventType_Resize
      update_properties_coordinate(id_properties_tree, e_widget)
      
  EndSelect
  
EndProcedure


;-
Procedure events_ide()
  Protected *this._s_widget
  Protected e_type = this()\event
  Protected e_item = this()\item
  Protected e_widget = this()\widget
  
  Select e_type
    Case #PB_EventType_StatusChange
      SetText(id_help_text, GetItemText(e_widget, e_item))
      
    Case #PB_EventType_Change
      If e_widget = id_inspector_tree
        *this = GetItemData(e_widget, GetState(e_widget))
        
        If *this And
           a_set(*this)
        EndIf
        
        ; SetActive(e_widget)
      EndIf
      
    Case #PB_EventType_MouseEnter
      Debug "id_elements - enter"
      ;       If GetState(id_elements_tree) > 0 
      ;         SetCursor(this()\widget, #PB_Cursor_Default)
      ;       EndIf
      
    Case #PB_EventType_MouseLeave
      Debug "id_elements - leave"
      ;       If GetState(id_elements_tree) > 0 
      ;         SetCursor(this()\widget, ImageID(GetItemData(id_elements_tree, GetState(id_elements_tree))))
      ;       EndIf
      
    Case #PB_EventType_LeftClick
      If e_widget = id_elements_tree
        Debug "click"
        ; SetCursor(this()\widget, ImageID(GetItemData(id_elements_tree, GetState(id_elements_tree))))
      EndIf
      
      If getclass(e_widget) = "ToolBar"
        Select GetData(e_widget)
          Case 1
            If Getstate(e_widget)  
              ; group
              group_select = e_widget
              ; SetAtributte(e_widget, #PB_Button_PressedImage)
            Else
              ; un group
              group_select = 0
            EndIf
            
          Case 3
            ForEach group_list()
              Debug group_list()
              Resize(group_list(), Transform()\widget\x, #PB_Ignore, #PB_Ignore, #PB_Ignore)
            Next
            
          Case 4
          
            
        EndSelect
      EndIf
      
  EndSelect
EndProcedure



Macro ToolBarButton(_button_, _image_, _mode_=0, _text_="")
; #PB_ToolBar_Normal: the button will act as standard button (Default)
; #PB_ToolBar_Toggle: the button will act as toggle button
  
    ;ButtonImage(2 + ((Bool(MacroExpandedCount>1) * 32) * (MacroExpandedCount-1)), 2,30,30,_image_)
  ButtonImage(2+((widget()\x+widget()\width) * Bool(MacroExpandedCount - 1)), 2,30,30,_image_, _mode_)
  ;widget()\color = widget()\parent\color
  ;widget()\text\padding\x = 0
  widget()\class = "ToolBar"
  widget()\data = _button_
  ;SetData(widget(), _button_)
  Bind(widget(), @events_ide())
EndMacro

Macro Separator()
  Text(2+widget()\x+widget()\width, 2,1,30,"")
  Button(widget()\x+widget()\width, 2+4,1,24,"")
  SetData(widget(), - MacroExpandedCount)
  Text(widget()\x+widget()\width, 2,1,30,"")
EndMacro


  
Procedure create_ide(x=100,y=100,width=800,height=600)
  Define flag = #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget
  Define root = widget::Open(OpenWindow(#PB_Any, x,y,width,height, "ide", flag))
  window_ide = widget::GetWindow(root)
  canvas_ide = widget::GetGadget(root)
  
  
  toolbar_design = Container(0,0,0,0) 
  ;ToolBar(toolbar, window, flags)
  
  group_1 = ToolBarButton(1, - 1, #__button_Toggle)
  SetAttribute(widget(), #PB_Button_Image, CatchImage(#PB_Any,?group_un))
  SetAttribute(widget(), #PB_Button_PressedImage, CatchImage(#PB_Any,?group))
  
  ;ToolBarButton(2, CatchImage(#PB_Any,?group_un))
  Separator()
  ToolBarButton(3, CatchImage(#PB_Any,?group_left))
  ToolBarButton(4, CatchImage(#PB_Any,?group_right))
  Separator()
  ToolBarButton(5, CatchImage(#PB_Any,?group_top))
  ToolBarButton(6, CatchImage(#PB_Any,?group_bottom))
  Separator()
  ToolBarButton(7, CatchImage(#PB_Any,?group_width))
  ToolBarButton(8, CatchImage(#PB_Any,?group_height))
  CloseList()
  
  ;   id_design_panel = Panel(0,0,0,0) ; , #__bar_vertical) : OpenList(id_design_panel)
  ;   AddItem(id_design_panel, -1, "Form")
  ;   id_design_form = MDI(0,0,0,0, #__flag_autosize) 
  ;   
  ;   AddItem(id_design_panel, -1, "Code")
  ;   id_design_code = Editor(0,0,0,0, #__flag_autosize) 
  ;   CloseList()
  
  id_inspector_tree = Tree(0,0,0,0)
  listview_debug = Editor(0,0,0,0) ; ListView(0,0,0,0) 
  
  id_design_form = MDI(0,0,0,0) 
  id_design_panel = id_design_form
  ;id_design_code = listview_debug
  
  id_inspector_panel = Panel(0,0,0,0)
  
  AddItem(id_inspector_panel, -1, "elements", 0, 0) 
  id_elements_tree = Tree(0,0,0,0, #__flag_autosize|#__flag_NoButtons|#__flag_NoLines)
  
  AddItem(id_inspector_panel, -1, "properties", 0, 0)  
  id_properties_tree = Tree_Properties(0,0,0,0, #__flag_autosize)
  If id_properties_tree
    AddItem(id_properties_tree, #_pi_group_0,  "Common")
    AddItem(id_properties_tree, #_pi_id,       "ID"      , #PB_GadgetType_String, 1)
    AddItem(id_properties_tree, #_pi_class,    "Class"   , #PB_GadgetType_String, 1)
    AddItem(id_properties_tree, #_pi_text,     "Text"    , #PB_GadgetType_String, 1)
    
    AddItem(id_properties_tree, #_pi_group_1,  "Layout")
    AddItem(id_properties_tree, #_pi_x,        "X"       , #PB_GadgetType_Spin, 1)
    AddItem(id_properties_tree, #_pi_y,        "Y"       , #PB_GadgetType_Spin, 1)
    AddItem(id_properties_tree, #_pi_width,    "Width"   , #PB_GadgetType_Spin, 1)
    AddItem(id_properties_tree, #_pi_height,   "Height"  , #PB_GadgetType_Spin, 1)
    
    AddItem(id_properties_tree, #_pi_group_2,  "State")
    AddItem(id_properties_tree, #_pi_disable,  "Disable" , #PB_GadgetType_ComboBox, 1)
    AddItem(id_properties_tree, #_pi_hide,     "Hide"    , #PB_GadgetType_ComboBox, 1)
  EndIf
  
  AddItem(id_inspector_panel, -1, "events", 0, 0)  
  id_events_tree = Tree_Properties(0,0,0,0, #__flag_autosize) 
  AddItem(id_events_tree, #_ei_leftclick,  "LeftClick")
  AddItem(id_events_tree, #_ei_change,  "Change")
  AddItem(id_events_tree, #_ei_enter,  "Enter")
  AddItem(id_events_tree, #_ei_leave,  "Leave")
  
  CloseList()
  
  id_help_text  = Text(0,0,0,0, "help for the inspector", #__text_border)
  
  
  Splitter_design = widget::Splitter(0,0,0,0, toolbar_design,id_design_panel, #PB_Splitter_FirstFixed|#PB_Splitter_Separator)
  Splitter_inspector = widget::Splitter(0,0,0,0, id_inspector_tree,id_inspector_panel, #PB_Splitter_FirstFixed)
  splitter_debug = widget::Splitter(0,0,0,0, Splitter_design,listview_debug, #PB_Splitter_SecondFixed)
  splitter_help = widget::Splitter(0,0,0,0, Splitter_inspector,id_help_text, #PB_Splitter_SecondFixed)
  Splitter_ide = widget::Splitter(0,0,0,0, splitter_debug,splitter_help, #__flag_autosize|#PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
  
  ; set splitters default minimum size
  widget::SetAttribute(Splitter_ide, #PB_Splitter_FirstMinimumSize, 500)
  widget::SetAttribute(Splitter_ide, #PB_Splitter_SecondMinimumSize, 120)
  widget::SetAttribute(splitter_help, #PB_Splitter_SecondMinimumSize, 30)
  widget::SetAttribute(splitter_debug, #PB_Splitter_SecondMinimumSize, 100)
  widget::SetAttribute(Splitter_inspector, #PB_Splitter_FirstMinimumSize, 100)
  widget::SetAttribute(Splitter_design, #PB_Splitter_FirstMinimumSize, 20)
  ; widget::SetAttribute(Splitter_design, #PB_Splitter_SecondMinimumSize, $ffffff)
  
  ; set splitters dafault positions
  widget::SetState(Splitter_ide, widget::width(Splitter_ide)-220)
  widget::SetState(splitter_help, widget::height(splitter_help)-80)
  widget::SetState(splitter_debug, widget::height(splitter_debug)-150)
  widget::SetState(Splitter_inspector, 150)
  widget::SetState(Splitter_design, 30)
  
  
  Bind(id_inspector_tree, @events_ide())
  
  ;Bind(id_elements_tree, @events_ide())
  Bind(id_elements_tree, @events_ide(), #PB_EventType_LeftClick)
  Bind(id_elements_tree, @events_ide(), #PB_EventType_Change)
  Bind(id_elements_tree, @events_ide(), #PB_EventType_StatusChange)
  
  Bind(id_elements_tree, @events_ide(), #PB_EventType_MouseEnter)
  Bind(id_elements_tree, @events_ide(), #PB_EventType_MouseLeave)
  ProcedureReturn window_ide
EndProcedure

;-
CompilerIf #PB_Compiler_IsMainFile 
  Define event
  create_ide()
  
  elements_list_fill(id_elements_tree, GetCurrentDirectory()+"Themes/")
  
;   ; example 1
;   ;   ;OpenList(id_design_form)
;   Define *window = create_element(id_design_form, "window", 10, 10, 350, 200)
;   Define *container = create_element(*window, "container", 130, 20, 220, 140)
;   create_element(*container, "button", 10, 20, 30, 30)
;   create_element(*window, "button", 10, 20, 100, 30)
;   
;   Define item = 1
;   SetState(id_inspector_tree, item)
;   If IsGadget(listview_debug)
;     SetGadgetState(listview_debug, item)
;   EndIf
;   Define *container2 = create_element(*container, "container", 60, 10, 220, 140)
;   create_element(*container2, "button", 10, 20, 30, 30)
;   
;   SetState(id_inspector_tree, 0)
;   create_element(*window, "button", 10, 130, 100, 30)
;   
;   ;   Define *window = create_element(id_design_form, "window", 10, 10)
;   ;   Define *container = create_element(*window, "container", 80, 10)
;   ;   create_element(*container, "button", -10, 20)
;   ;   create_element(*window, "button", 10, 20)
;   ;   ;CloseList()
  
  ; example 2
  ;   ;OpenList(id_design_form)
  SetState(group_1, 1) : group_select = group_1
  
  Define *window = create_element(id_design_form, "window", 10, 10, 400, 250)
  create_element(*window, "button", 25, 25, 50, 30)
  create_element(*window, "button", 25, 65, 50, 30)
  create_element(*window, "text", 25, 65+40, 50, 30)
  create_element(*window, "text", 25, 65+40*2, 50, 30)
  
  Define *container = create_element(*window, "container", 100, 25, 265, 170)
  create_element(*container, "button", 25, 25, 50, 30)
  create_element(*container, "button", 25, 65, 50, 30)
  create_element(*container, "text", 25, 65+40, 50, 30)
  create_element(*container, "text", 25, 65+40*2, 50, 30)
  
  Define *container2 = create_element(*container, "container", 100, 25, 165, 140)
  create_element(*container2, "button", 25, 25, 50, 30)
  create_element(*container2, "button", 25, 65, 50, 30)
  create_element(*container2, "text", 25, 65+40, 50, 30)
  create_element(*container2, "text", 25, 65+40*2, 50, 30)
  
  Repeat 
    event = WaitWindowEvent() 
    
    ;     Select EventWindow()
    ;       Case window_ide 
    ;         ide_window_events(event)
    ;     EndSelect
    
  Until event = #PB_Event_CloseWindow
CompilerEndIf


DataSection   ; Include Images
  IncludePath "../../IDE/include/Images"
  group:            : IncludeBinary "group.png"
  group_un:         : IncludeBinary "group_un.png"
  group_top:        : IncludeBinary "group_top.png"
  group_left:       : IncludeBinary "group_left.png"
  group_right:      : IncludeBinary "group_right.png"
  group_bottom:     : IncludeBinary "group_bottom.png"
  group_width:      : IncludeBinary "group_width.png"
  group_height:     : IncludeBinary "group_height.png"
  
  ThisPC:           : IncludeBinary "ThisPC.png"
EndDataSection
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------X+f------LXf---f-----------------------------
; EnableXP