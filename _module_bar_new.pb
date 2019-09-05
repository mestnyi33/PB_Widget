﻿;
; Os              : All
; Version         : 3
; License         : Free
; Module name     : Scroll
; Author          : mestnyi
; PB version:     : 5.46 =< 5.62
; Last updated    : 3 Aug 2019
; Topic           : https://www.purebasic.fr/english/posting.php?mode=edit&f=12&p=521603
;

CompilerIf #PB_Compiler_IsMainFile
  DeclareModule Constant
    CompilerIf #PB_Compiler_Version =< 546
      Enumeration #PB_EventType_FirstCustomValue
        #PB_EventType_Resize
      EndEnumeration
    CompilerEndIf
  EndDeclareModule 
  Module Constant : EndModule : UseModule Constant
CompilerEndIf

;- >>> DECLAREMODULE
DeclareModule Widget
  EnableExplicit
  
  ;- CONSTANTs
  #PB_Bar_Vertical = 1
  
  #PB_Bar_Minimum = 1
  #PB_Bar_Maximum = 2
  #PB_Bar_PageLength = 3
  
  EnumerationBinary 4
    #PB_Bar_ArrowSize 
    #PB_Bar_ButtonSize 
    #PB_Bar_ScrollStep
    #PB_Bar_NoButtons 
    #PB_Bar_Direction 
    #PB_Bar_Inverted 
    #PB_Bar_Ticks
    
    #PB_Bar_First
    #PB_Bar_Second
    #PB_Bar_FirstFixed
    #PB_Bar_SecondFixed
    #PB_Bar_FirstMinimumSize
    #PB_Bar_SecondMinimumSize
  EndEnumeration
  
  #Normal = 0
  #Entered = 1
  #Selected = 2
  #Disabled = 3
  
  #_1 = 1
  #_2 = 2
  #_3 = 3
  
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    #PB_EventType_ScrollChange
  EndEnumeration
  
  Prototype pFunc(*this)
  Prototype pFunc2()
  
  ;- STRUCTUREs
  ;- - _S_event
  Structure _S_event
    widget.i
    type.l
    item.l
    *data
    *callback.pFunc2
  EndStructure
  
  ;- - _S_coordinate
  Structure _S_coordinate
    x.l
    y.l
    width.l
    height.l
  EndStructure
  
  ;- - _S_color
  Structure _S_color
    state.b
    alpha.a[2]
    front.l[4]
    fore.l[4]
    back.l[4]
    frame.l[4]
  EndStructure
  
  ;- - _S_page
  Structure _S_page
    pos.l
    len.l
    *end
  EndStructure
  
  ;- - _S_button
  Structure _S_button Extends _S_coordinate
    len.a
    arrow_size.a
    arrow_type.b
  EndStructure
  
  ;- - _S_scroll
  Structure _S_scroll Extends _S_coordinate
    *v._S_widget
    *h._S_widget
  EndStructure
  
  ;- - _S_splitter
  Structure _S_splitter
    *first;._S_widget
    *second;._S_widget
    
    g_first.b
    g_second.b
    
    *resize.pFunc
  EndStructure
  
  ;- - _S_widget
  Structure _S_widget Extends _S_coordinate
    type.l
    from.l
    focus.l
    radius.l
    
    hide.b[2]
    ; disable.b[2]
    vertical.b
    inverted.b
    direction.l
    scrollstep.l
    change.l
    mode.l
    cursor.l
    
    max.l
    min.l
    page._S_page
    area._S_page
    thumb._S_page
    color._S_color[4]
    button._S_button[4] 
    
    *event._S_event 
    *splitter._S_splitter
    *scroll._S_scroll
    *parent._S_widget
  EndStructure
  
  Global *event._S_event = AllocateStructure(_S_event)
  
  ;-
  ;- DECLAREs
  Declare.b Draw(*this)
  Declare.l Y(*this)
  Declare.l X(*this)
  Declare.l Width(*this)
  Declare.l Height(*this)
  Declare.b Hide(*this, State.b=#PB_Default)
  
  Declare.i GetState(*this)
  Declare.i GetAttribute(*this, Attribute.i)
  
  Declare.b SetState(*this, ScrollPos.l)
  Declare.l SetAttribute(*this, Attribute.l, Value.l)
  Declare.b SetColor(*this, ColorType.l, Color.l, Item.l=- 1, State.l=1)
  
  Declare.b Resize(*this, iX.l,iY.l,iWidth.l,iHeight.l)
  Declare.b CallBack(*this, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0)
  
  Declare.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l=0, Radius.l=0)
  Declare.i Progress(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l=0, Radius.l=0)
  Declare.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.l=0, Radius.l=0)
  Declare.i Track(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l=0, Radius.l=7)
  Declare.i ScrollArea(X.l,Y.l,Width.l,Height.l, AreaWidth.l, AreaHeight.l, ScrollStep.l=1, Flag.l=0, Radius.l=0)
  
  Declare.b Resizes(*scroll._S_scroll, X.l,Y.l,Width.l,Height.l)
  Declare.b Updates(*scroll._S_scroll, ScrollArea_X.l, ScrollArea_Y.l, ScrollArea_Width.l, ScrollArea_Height.l)
  Declare.b Arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
  
  Declare.b Post(eventtype.l, *this, item.l=#PB_All, *data=0)
  Declare.b Bind(*callBack, *this, eventtype.l=#PB_All)
  
  ;- MACROs
  Macro Widget()
    *event\widget
  EndMacro
  
  Macro Type()
    *event\type
  EndMacro
  
  Macro Item()
    *event\item
  EndMacro
  
  Macro Data()
    *event\data
  EndMacro
  
  ; Extract thumb len from (max area page) len
  ; Draw gradient box
  Macro _box_gradient_(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _radius_=0, _alpha_=255)
    BackColor(_color_1_&$FFFFFF|_alpha_<<24)
    FrontColor(_color_2_&$FFFFFF|_alpha_<<24)
    If _type_
      LinearGradient(_x_,_y_, (_x_+_width_), _y_)
    Else
      LinearGradient(_x_,_y_, _x_, (_y_+_height_))
    EndIf
    RoundBox(_x_,_y_,_width_,_height_, _radius_,_radius_)
    BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
  EndMacro
  
EndDeclareModule

;- >>> MODULE
Module Widget
  ;- GLOBALs
  Global def_colors._S_color
  
  With def_colors                          
    \state = 0
    \alpha[0] = 255
    \alpha[1] = 255
    
    ; - Синие цвета
    ; Цвета по умолчанию
    \front[#Normal] = $80000000
    \fore[#Normal] = $FFF6F6F6 ; $FFF8F8F8 
    \back[#Normal] = $FFE2E2E2 ; $80E2E2E2
    \frame[#Normal] = $FFBABABA; $80C8C8C8
    
    ; Цвета если мышь на виджете
    \front[#Entered] = $80000000
    \fore[#Entered] = $FFEAEAEA ; $FFFAF8F8
    \back[#Entered] = $FFCECECE ; $80FCEADA
    \frame[#Entered] = $FF8F8F8F; $80FFC288
    
    ; Цвета если нажали на виджет
    \front[#Selected] = $FFFEFEFE
    \fore[#Selected] = $FFE2E2E2 ; $C8E9BA81 ; $C8FFFCFA
    \back[#Selected] = $FFB4B4B4 ; $C8E89C3D ; $80E89C3D
    \frame[#Selected] = $FF6F6F6F; $C8DC9338 ; $80DC9338
    
    ; Цвета если дисабле виджет
    \front[#Disabled] = $FFBABABA
    \fore[#Disabled] = $FFF6F6F6 
    \back[#Disabled] = $FFE2E2E2 
    \frame[#Disabled] = $FFBABABA
    
  EndWith
  
  Macro _thumb_pos_(_this_, _scroll_pos_)
    (_this_\area\pos + Round(((_scroll_pos_)-_this_\min) * (_this_\area\len / (_this_\max-_this_\min)), #PB_Round_Nearest)) 
    
    If _this_\thumb\pos < _this_\area\pos 
      _this_\thumb\pos = _this_\area\pos 
    EndIf 
    
    If _this_\thumb\pos > _this_\area\end
      _this_\thumb\pos = _this_\area\end
    EndIf
    
    ; _start_
    If _this_\button[#_1]\len And _this_\button[#_1]\len <> 1
      If _scroll_pos_ = _this_\min
        _this_\color[#_1]\state = #Disabled
      Else
        _this_\color[#_1]\state = #Normal
      EndIf 
    EndIf
    
    If _this_\type=#PB_GadgetType_ScrollBar
      If _this_\Vertical 
        ; Top button coordinate on vertical scroll bar
        _this_\button[#_1]\x = _this_\X + Bool(_this_\type=#PB_GadgetType_ScrollBar) 
        _this_\button[#_1]\y = _this_\Y 
        _this_\button[#_1]\width = _this_\Width - Bool(_this_\type=#PB_GadgetType_ScrollBar) 
        _this_\button[#_1]\height = _this_\button[#_1]\len                   
      Else 
        ; Left button coordinate on horizontal scroll bar
        _this_\button[#_1]\x = _this_\X 
        _this_\button[#_1]\y = _this_\Y + Bool(_this_\type=#PB_GadgetType_ScrollBar) 
        _this_\button[#_1]\width = _this_\button[#_1]\len 
        _this_\button[#_1]\height = _this_\Height - Bool(_this_\type=#PB_GadgetType_ScrollBar)  
      EndIf
    Else
      _this_\button[#_1]\x = _this_\X
      _this_\button[#_1]\y = _this_\Y
      
      If _this_\Vertical
        _this_\button[#_1]\width = _this_\width
        _this_\button[#_1]\height = _this_\thumb\pos-_this_\y
      Else
        _this_\button[#_1]\width = _this_\thumb\pos-_this_\x
        _this_\button[#_1]\height = _this_\height
      EndIf
    EndIf
    
    ; _stop_
    If _this_\button[#_2]\len And _this_\button[#_2]\len <> 1
      If _scroll_pos_ = _this_\page\end
        _this_\color[#_2]\state = #Disabled
      Else
        _this_\color[#_2]\state = #Normal
      EndIf 
    EndIf
    
    If _this_\type=#PB_GadgetType_ScrollBar
      If _this_\Vertical 
        ; Botom button coordinate on vertical scroll bar
        _this_\button[#_2]\x = _this_\X + Bool(_this_\type=#PB_GadgetType_ScrollBar) 
        _this_\button[#_2]\width = _this_\Width - Bool(_this_\type=#PB_GadgetType_ScrollBar) 
        _this_\button[#_2]\height = _this_\button[#_2]\len 
        _this_\button[#_2]\y = _this_\Y+_this_\Height-_this_\button[#_2]\height
      Else 
        ; Right button coordinate on horizontal scroll bar
        _this_\button[#_2]\y = _this_\Y + Bool(_this_\type=#PB_GadgetType_ScrollBar) 
        _this_\button[#_2]\height = _this_\Height - Bool(_this_\type=#PB_GadgetType_ScrollBar) 
        _this_\button[#_2]\width = _this_\button[#_2]\len 
        _this_\button[#_2]\x = _this_\X+_this_\Width-_this_\button[#_2]\width 
      EndIf
      
    Else
      If _this_\Vertical
        _this_\button[#_2]\x = _this_\x
        _this_\button[#_2]\y = _this_\thumb\pos+_this_\thumb\len
        _this_\button[#_2]\width = _this_\Width
        _this_\button[#_2]\height = _this_\height-(_this_\thumb\pos+_this_\thumb\len-_this_\y)
      Else
        _this_\button[#_2]\x = _this_\thumb\pos+_this_\thumb\len
        _this_\button[#_2]\y = _this_\Y
        _this_\button[#_2]\width = _this_\Width-(_this_\thumb\pos+_this_\thumb\len-_this_\x)
        _this_\button[#_2]\height = _this_\height
      EndIf
    EndIf
    
    ; Thumb coordinate on scroll bar
    If _this_\thumb\len
      _this_\button[#_3]\len = _this_\thumb\len
      
      If _this_\Vertical
        _this_\button[#_3]\x = _this_\X + Bool(_this_\type=#PB_GadgetType_ScrollBar) 
        _this_\button[#_3]\width = _this_\Width - Bool(_this_\type=#PB_GadgetType_ScrollBar) 
        _this_\button[#_3]\y = _this_\thumb\pos
        _this_\button[#_3]\height = _this_\thumb\len                              
      Else
        _this_\button[#_3]\y = _this_\Y + Bool(_this_\type=#PB_GadgetType_ScrollBar) 
        _this_\button[#_3]\height = _this_\Height - Bool(_this_\type=#PB_GadgetType_ScrollBar) 
        _this_\button[#_3]\x = _this_\thumb\pos 
        _this_\button[#_3]\width = _this_\thumb\len                                  
      EndIf
      
    Else
      ; Эфект спин гаджета
      If _this_\Vertical
        _this_\button[#_2]\Height = _this_\Height/2 
        _this_\button[#_2]\y = _this_\y+_this_\button[#_2]\Height+Bool(_this_\Height%2) 
        
        _this_\button[#_1]\y = _this_\y 
        _this_\button[#_1]\Height = _this_\Height/2
        
      Else
        _this_\button[#_2]\width = _this_\width/2 
        _this_\button[#_2]\x = _this_\x+_this_\button[#_2]\width+Bool(_this_\width%2) 
        
        _this_\button[#_1]\x = _this_\x 
        _this_\button[#_1]\width = _this_\width/2
      EndIf
    EndIf
    
    ; Splitter childrens auto resize       
    If _this_\Splitter
      _this_\Splitter\resize(_this_)
    EndIf
    
    If _this_\change ;And _this_\event And *event 
                     ;       *event\widget = _this_
                     ;       *event\data = _this_\direction
                     ;       *event\type = #PB_EventType_StatusChange
                     ;       _this_\Event()
      Post(#PB_EventType_StatusChange, _this_, _this_\from, _this_\direction)
    EndIf
  EndMacro
  
  ; Inverted scroll bar position
  Macro _scroll_invert_(_this_, _scroll_pos_, _inverted_=#True)
    (Bool(_inverted_) * ((_this_\min + (_this_\max - _this_\page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
  
  Procedure.b splitter_size(*this._S_widget)
    If *this\splitter
      If *this\splitter\first
        If *this\splitter\g_first
          If (#PB_Compiler_OS = #PB_OS_MacOS) And *this\vertical
            ResizeGadget(*this\splitter\first, *this\button[1]\x, (*this\button[2]\height+*this\thumb\len)-*this\button[1]\y, *this\button[1]\width, *this\button[1]\height)
          Else
            ResizeGadget(*this\splitter\first, *this\button[1]\x, *this\button[1]\y, *this\button[1]\width, *this\button[1]\height)
          EndIf
        Else
          Resize(*this\splitter\first, *this\button[1]\x, *this\button[1]\y, *this\button[1]\width, *this\button[1]\height)
          splitter_size(*this\splitter\first)
        EndIf
      EndIf
      
      If *this\splitter\second
        If *this\splitter\g_second
          If (#PB_Compiler_OS = #PB_OS_MacOS) And *this\vertical
            ResizeGadget(*this\splitter\second, *this\button[2]\x, (*this\button[1]\height+*this\thumb\len)-*this\button[2]\y, *this\button[2]\width, *this\button[2]\height)
          Else
            ResizeGadget(*this\splitter\second, *this\button[2]\x, *this\button[2]\y, *this\button[2]\width, *this\button[2]\height)
          EndIf
        Else
          Resize(*this\splitter\second, *this\button[2]\x, *this\button[2]\y, *this\button[2]\width, *this\button[2]\height)
          splitter_size(*this\splitter\second)
        EndIf   
      EndIf   
    EndIf
  EndProcedure
  
  
  
  ;-
  ;- - DRAW
  Procedure.b Arrow(X.l,Y.l, Size.l, Direction.l, Color.l, Style.b = 1, Length.l = 1)
    Protected I
    
    If Not Length
      Style =- 1
    EndIf
    Length = (Size+2)/2
    
    
    If Direction = 1 ; top
      If Style > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size 
          LineXY((X+1+i)+Size,(Y+i-1)-(Style),(X+1+i)+Size,(Y+i-1)+(Style),Color)         ; Левая линия
          LineXY(((X+1+(Size))-i),(Y+i-1)-(Style),((X+1+(Size))-i),(Y+i-1)+(Style),Color) ; правая линия
        Next
      Else : x-1 : y-1
        For i = 1 To Length 
          If Style =- 1
            LineXY(x+i, (Size+y), x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y), x+Length, y, Color)
          Else
            LineXY(x+i, (Size+y)-i/2, x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y)-i/2, x+Length, y, Color)
          EndIf
        Next 
        i = Bool(Style =- 1) 
        LineXY(x, (Size+y)+Bool(i=0), x+Length, y+1, Color) 
        LineXY(x+Length*2, (Size+y)+Bool(i=0), x+Length, y+1, Color) ; bug
      EndIf
    ElseIf Direction = 3 ; bottom
      If Style > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size
          LineXY((X+1+i),(Y+i)-(Style),(X+1+i),(Y+i)+(Style),Color) ; Левая линия
          LineXY(((X+1+(Size*2))-i),(Y+i)-(Style),((X+1+(Size*2))-i),(Y+i)+(Style),Color) ; правая линия
        Next
      Else : x-1 : y+1
        For i = 0 To Length 
          If Style =- 1
            LineXY(x+i, y, x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y, x+Length, (Size+y), Color)
          Else
            LineXY(x+i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
          EndIf
        Next
      EndIf
    ElseIf Direction = 0 ; в лево
      If Style > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; в лево
          LineXY(((X+1)+i)-(Style),(((Y+1)+(Size))-i),((X+1)+i)+(Style),(((Y+1)+(Size))-i),Color) ; правая линия
          LineXY(((X+1)+i)-(Style),((Y+1)+i)+Size,((X+1)+i)+(Style),((Y+1)+i)+Size,Color)         ; Левая линия
        Next  
      Else : x-1 : y-1
        For i = 1 To Length
          If Style =- 1
            LineXY((Size+x), y+i, x, y+Length, Color)
            LineXY((Size+x), y+Length*2-i, x, y+Length, Color)
          Else
            LineXY((Size+x)-i/2, y+i, x, y+Length, Color)
            LineXY((Size+x)-i/2, y+Length*2-i, x, y+Length, Color)
          EndIf
        Next 
        i = Bool(Style =- 1) 
        LineXY((Size+x)+Bool(i=0), y, x+1, y+Length, Color) 
        LineXY((Size+x)+Bool(i=0), y+Length*2, x+1, y+Length, Color)
      EndIf
    ElseIf Direction = 2 ; в право
      If Style > 0 : y-1 : x + 1
        Size / 2
        For i = 0 To Size 
          ; в право
          LineXY(((X+1)+i)-(Style),((Y+1)+i),((X+1)+i)+(Style),((Y+1)+i),Color) ; Левая линия
          LineXY(((X+1)+i)-(Style),(((Y+1)+(Size*2))-i),((X+1)+i)+(Style),(((Y+1)+(Size*2))-i),Color) ; правая линия
        Next
      Else : y-1 : x+1
        For i = 0 To Length 
          If Style =- 1
            LineXY(x, y+i, Size+x, y+Length, Color)
            LineXY(x, y+Length*2-i, Size+x, y+Length, Color)
          Else
            LineXY(x+i/2-Bool(i=0), y+i, Size+x, y+Length, Color)
            LineXY(x+i/2-Bool(i=0), y+Length*2-i, Size+x, y+Length, Color)
          EndIf
        Next
      EndIf
    EndIf
    
  EndProcedure
  
  Procedure.b Draw_Scroll(*this._S_widget)
    With *this
      
      If Not \hide And \color\alpha
        ; Draw scroll bar background
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X,\Y,\Width,\height,\Radius,\Radius,\Color\Back&$FFFFFF|\color\alpha<<24)
        
        If \Vertical
          Line( \x, \y, 1, \page\len + Bool(\height<>\page\len), \color\front&$FFFFFF|\color\alpha<<24) ;   $FF000000) ;
        Else
          Line( \x, \y, \page\len + Bool(\width<>\page\len), 1, \color\front&$FFFFFF|\color\alpha<<24) ;   $FF000000) ;
        EndIf
        
        If \thumb\len
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\Vertical,\button[#_3]\x,\button[#_3]\y,\button[#_3]\width,\button[#_3]\height,\Color[3]\fore[\color[3]\state],\Color[3]\Back[\color[3]\state], \Radius, \color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#_3]\x,\button[#_3]\y,\button[#_3]\width,\button[#_3]\height,\Radius,\Radius,\Color[3]\frame[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          
          Protected h=9
          ; Draw thumb lines
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          If \Vertical
            Line(\button[#_3]\x+(\button[#_3]\width-h)/2,\button[#_3]\y+\button[#_3]\height/2-3,h,1,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_3]\x+(\button[#_3]\width-h)/2,\button[#_3]\y+\button[#_3]\height/2,h,1,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_3]\x+(\button[#_3]\width-h)/2,\button[#_3]\y+\button[#_3]\height/2+3,h,1,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          Else
            Line(\button[#_3]\x+\button[#_3]\width/2-3,\button[#_3]\y+(\button[#_3]\height-h)/2,1,h,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_3]\x+\button[#_3]\width/2,\button[#_3]\y+(\button[#_3]\height-h)/2,1,h,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
            Line(\button[#_3]\x+\button[#_3]\width/2+3,\button[#_3]\y+(\button[#_3]\height-h)/2,1,h,\Color[3]\front[\color[3]\state]&$FFFFFF|\color\alpha<<24)
          EndIf
        EndIf
        
        If \button\len
          ; Draw buttons
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\Vertical,\button[#_1]\x,\button[#_1]\y,\button[#_1]\width,\button[#_1]\height,\Color[1]\fore[\color[1]\state],\Color[1]\Back[\color[1]\state], \Radius, \color\alpha)
          _box_gradient_(\Vertical,\button[#_2]\x,\button[#_2]\y,\button[#_2]\width,\button[#_2]\height,\Color[2]\fore[\color[2]\state],\Color[2]\Back[\color[2]\state], \Radius, \color\alpha)
          
          ; Draw buttons frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#_1]\x,\button[#_1]\y,\button[#_1]\width,\button[#_1]\height,\Radius,\Radius,\Color[1]\frame[\color[1]\state]&$FFFFFF|\color\alpha<<24)
          RoundBox(\button[#_2]\x,\button[#_2]\y,\button[#_2]\width,\button[#_2]\height,\Radius,\Radius,\Color[2]\frame[\color[2]\state]&$FFFFFF|\color\alpha<<24)
          
          ; Draw arrows
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\button[#_1]\x+(\button[#_1]\width-\button[#_1]\arrow_size)/2,\button[#_1]\y+(\button[#_1]\height-\button[#_1]\arrow_size)/2, \button[#_1]\arrow_size, Bool(\Vertical), \Color[1]\front[\color[1]\state]&$FFFFFF|\color\alpha<<24, \button[#_1]\arrow_type)
          Arrow(\button[#_2]\x+(\button[#_2]\width-\button[#_2]\arrow_size)/2,\button[#_2]\y+(\button[#_2]\height-\button[#_2]\arrow_size)/2, \button[#_2]\arrow_size, Bool(\Vertical)+2, \Color[2]\front[\color[2]\state]&$FFFFFF|\color\alpha<<24, \button[#_2]\arrow_type)
        EndIf
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.b Draw_Track(*this._S_widget)
    With *This
      
      If Not \Hide
        Protected _pos_ = 6, _size_ = 4
        
        DrawingMode(#PB_2DDrawing_Default)
        Box(\X,\Y,\Width,\Height,\Color\Back)
        
        If \Vertical
          ; _frame_(*this, _pos_, _size_)
          ; Back
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \X+_pos_,\thumb\pos+\thumb\len-\button[#_2]\len,_size_,\Height-(\thumb\pos+\thumb\len-\y),\Color[#_2]\fore[\color[#_2]\state],\Color[#_2]\back[\color[#_2]\state], Bool(\radius))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\X+_pos_,\thumb\pos+\thumb\len-\button[#_2]\len,_size_,\Height-(\thumb\pos+\thumb\len-\y),Bool(\radius),Bool(\radius),\Color[#_2]\frame[\color[#_2]\state])
          
          ; Back
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \X+_pos_,\Y+\button[#_1]\len,_size_,\thumb\pos-\y,\Color[#_1]\fore[\color[#_1]\state],\Color[#_1]\back[\color[#_1]\state], Bool(\radius))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\X+_pos_,\Y+\button[#_1]\len,_size_,\thumb\pos-\y,Bool(\radius),Bool(\radius),\Color[#_1]\frame[\color[#_1]\state])
        Else
          ; _frame_(*this, _pos_, _size_)
          
          ; Back
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \X+\button[#_1]\len,\Y+_pos_,\thumb\pos-\x,_size_,\Color[#_1]\fore[\color[#_1]\state],\Color[#_1]\back[\color[#_1]\state], Bool(\radius))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\X+\button[#_1]\len,\Y+_pos_,\thumb\pos-\x,_size_,Bool(\radius),Bool(\radius),\Color[#_1]\frame[\color[#_1]\state])
          
          DrawingMode(#PB_2DDrawing_Gradient)
          _box_gradient_(\vertical, \thumb\pos+\thumb\len-\button[#_2]\len,\Y+_pos_,\Width-(\thumb\pos+\thumb\len-\x),_size_,\Color[#_2]\fore[\color[#_2]\state],\Color[#_2]\back[\color[#_2]\state], Bool(\radius))
          
          DrawingMode(#PB_2DDrawing_Outlined)
          RoundBox(\thumb\pos+\thumb\len-\button[#_2]\len,\Y+_pos_,\Width-(\thumb\pos+\thumb\len-\x),_size_,Bool(\radius),Bool(\radius),\Color[#_2]\frame[\color[#_2]\state])
        EndIf
        
        
        If \thumb\len
          Protected i, track_pos.f, _thumb_ = (\thumb\len/2)
          DrawingMode(#PB_2DDrawing_XOr)
          
          If \vertical
            If \mode = #PB_Bar_Ticks
              For i=0 To \page\end-\min
                track_pos = (\area\pos + Round(i * (\area\len / (\max-\min)), #PB_Round_Nearest)) + _thumb_
                Line(\button[3]\x+\button[3]\width-4,track_pos,4, 1,\Color[3]\Frame)
              Next
            Else
              Line(\button[3]\x+\button[3]\width-4,\area\pos + _thumb_,4, 1,\Color[3]\Frame)
              Line(\button[3]\x+\button[3]\width-4,\area\pos + \area\len + _thumb_,4, 1,\Color[3]\Frame)
            EndIf
          Else
            If \mode = #PB_Bar_Ticks
              For i=0 To \page\end-\min
                track_pos = (\area\pos + Round(i * (\area\len / (\max-\min)), #PB_Round_Nearest)) + _thumb_
                Line(track_pos, \button[3]\y+\button[3]\height-4,1,4,\Color[3]\Frame)
              Next
            Else
              Line(\area\pos + _thumb_, \button[3]\y+\button[3]\height-4,1,4,\Color[3]\Frame)
              Line(\area\pos + \area\len + _thumb_, \button[3]\y+\button[3]\height-4,1,4,\Color[3]\Frame)
            EndIf
          EndIf
          
          ; Draw thumb
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          _box_gradient_(\Vertical,\button[#_3]\x+Bool(\vertical),\button[#_3]\y+Bool(Not \vertical),\button[#_3]\len,\button[#_3]\len,\Color[3]\fore[2],\Color[3]\Back[2], \Radius, \color\alpha)
          
          ; Draw thumb frame
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox(\button[#_3]\x+Bool(\vertical),\button[#_3]\y+Bool(Not \vertical),\button[#_3]\len,\button[#_3]\len,\Radius,\Radius,\Color[3]\frame[2]&$FFFFFF|\color\alpha<<24)
          
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Arrow(\button[#_3]\x+(\button[#_3]\len-\button[#_3]\arrow_size)/2+Bool(\Vertical),\button[#_3]\y+(\button[#_3]\len-\button[#_3]\arrow_size)/2+Bool(Not \Vertical), 
                \button[#_3]\arrow_size, Bool(\Vertical)+Bool(Not \inverted And \direction>0)*2+Bool(\inverted And \direction=<0)*2, \Color[#_3]\frame[\color[#_3]\state]&$FFFFFF|\color\alpha<<24, \button[#_3]\arrow_type)
          
        EndIf
        
      EndIf
      
    EndWith 
    
  EndProcedure
  
  Procedure.b Draw_Progress(*this._S_widget)
    With *this 
      
      If \Vertical
        ; Normal Back
        DrawingMode(#PB_2DDrawing_Gradient)
        _box_gradient_(\vertical, \X,\Y,\width,\thumb\pos-\y,\Color[#_1]\fore[\color[#_1]\state],\Color[#_1]\back[\color[#_1]\state])
        
        ; Selected Back 
        DrawingMode(#PB_2DDrawing_Gradient)
        _box_gradient_(\vertical,\x, \thumb\pos+\thumb\len,\width,\height-(\thumb\pos+\thumb\len-\y),\Color[#_2]\fore[\color[#_2]\state],\Color[#_2]\back[\color[#_2]\state])
        
        ; Frame
        DrawingMode(#PB_2DDrawing_Outlined)
        If \thumb\pos <> \area\pos
          Line(\X,\Y,1,\thumb\pos-\y,\Color[#_1]\frame[\color[#_1]\state])
          Line(\X,\Y,\width,1,\Color[#_1]\frame[\color[#_1]\state])
          Line(\X+\width-1,\Y,1,\thumb\pos-\y,\Color[#_1]\frame[\color[#_1]\state])
        Else
          Line(\X,\Y,\width,1,\Color[#_2]\frame[\color[#_2]\state])
        EndIf
        
        ; Frame
        DrawingMode(#PB_2DDrawing_Outlined)
        If \thumb\pos <> \area\end
          Line(\x,\thumb\pos+\thumb\len,1,\height-(\thumb\pos+\thumb\len-\y),\Color[#_2]\frame[\color[#_2]\state])
          Line(\x,\Y+\height-1,\width,1,\Color[#_2]\frame[\color[#_2]\state])
          Line(\x+\width-1,\thumb\pos+\thumb\len,1,\height-(\thumb\pos+\thumb\len-\y),\Color[#_2]\frame[\color[#_2]\state])
        Else
          Line(\x,\Y+\height-1,\width,1,\Color[#_1]\frame[\color[#_1]\state])
        EndIf
        
      Else
        ; Selected Back
        DrawingMode(#PB_2DDrawing_Gradient)
        _box_gradient_(\vertical, \X,\Y,\thumb\pos-\x,\height,\Color[#_1]\fore[\color[#_1]\state],\Color[#_1]\back[\color[#_1]\state])
        
        ; Normal Back
        DrawingMode(#PB_2DDrawing_Gradient)
        _box_gradient_(\vertical, \thumb\pos+\thumb\len,\Y,\Width-(\thumb\pos+\thumb\len-\x),\height,\Color[#_2]\fore[\color[#_2]\state],\Color[#_2]\back[\color[#_2]\state])
        
        ; Frame
        DrawingMode(#PB_2DDrawing_Outlined)
        If \thumb\pos <> \area\pos
          Line(\X,\Y,\thumb\pos-\x,1,\Color[#_1]\frame[\color[#_1]\state])
          Line(\X,\Y,1,\height,\Color[#_1]\frame[\color[#_1]\state])
          Line(\X,\Y+\height-1,\thumb\pos-\x,1,\Color[#_1]\frame[\color[#_1]\state])
        Else
          Line(\X,\Y,1,\height,\Color[#_2]\frame[\color[#_2]\state])
        EndIf
        
        ; Frame
        DrawingMode(#PB_2DDrawing_Outlined)
        If \thumb\pos <> \area\end
          Line(\thumb\pos+\thumb\len,\Y,\Width-(\thumb\pos+\thumb\len-\x),1,\Color[#_2]\frame[\color[#_2]\state])
          Line(\x+\width-1,\Y,1,\height,\Color[#_2]\frame[\color[#_2]\state])
          Line(\thumb\pos+\thumb\len,\Y+\height-1,\Width-(\thumb\pos+\thumb\len-\x),1,\Color[#_2]\frame[\color[#_2]\state])
        Else
          Line(\x+\width-1,\Y,1,\height,\Color[#_1]\frame[\color[#_1]\state])
        EndIf
      EndIf
      
      ; Text
      If \mode
        If \vertical
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_XOr)
          DrawRotatedText(\x+(\width-TextHeight("A"))/2, \y+(\height+TextWidth("%"+Str(\Page\Pos)))/2, "%"+Str(\Page\Pos), Bool(\Vertical) * 90, \Color[3]\frame)
          ; DrawRotatedText(\x+(\width+TextHeight("A")+Bool(#PB_Compiler_OS = #PB_OS_MacOS)*2)/2, \y+(\height-TextWidth("%"+Str(\Page\Pos)))/2, "%"+Str(\Page\Pos), Bool(\Vertical) * 270, \Color[3]\frame)
        Else
          DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_XOr)
          DrawText(\x+(\width-TextWidth("%"+Str(\Page\Pos)))/2, \y+(\height-TextHeight("A"))/2, "%"+Str(\Page\Pos),\Color[3]\frame)
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.b Draw_Splitter(*this._S_widget)
    Protected Pos, Size, X,Y,Width,Height, Color, Radius.d = 2
    
    With *this
      If *this > 0
        X = \X
        Y = \Y
        Width = \Width 
        Height = \Height
        
        If \mode
          DrawingMode(#PB_2DDrawing_Outlined)
          Protected *first._S_widget = \splitter\first
          Protected *second._S_widget = \splitter\second
          
          If Not \splitter\g_first And (Not *first Or (*first And Not *first\splitter))
            Box(\button[#_1]\x,\button[#_1]\y,\button[#_1]\width,\button[#_1]\height,\Color[3]\frame[\color[1]\state])
          EndIf
          If Not \splitter\g_second And (Not *second Or (*second And Not *second\splitter))
            Box(\button[#_2]\x,\button[#_2]\y,\button[#_2]\width,\button[#_2]\height,\Color[3]\frame[\color[2]\state])
          EndIf
        EndIf
        
        If \mode = #PB_Splitter_Separator
          ; Позиция сплиттера 
          Size = \Thumb\len/2
          Pos = \Thumb\Pos+Size
          
          Color = \Color[3]\Frame[2]
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend) 
          If \Vertical ; horisontal
            Circle(X+((Width-Radius)/2-((Radius*2+2)*2+2)),Pos,Radius,Color)
            Circle(X+((Width-Radius)/2-(Radius*2+2)),      Pos,Radius,Color)
            Circle(X+((Width-Radius)/2),                   Pos,Radius,Color)
            Circle(X+((Width-Radius)/2+(Radius*2+2)),      Pos,Radius,Color)
            Circle(X+((Width-Radius)/2+((Radius*2+2)*2+2)),Pos,Radius,Color)
          Else
            Circle(Pos,Y+((Height-Radius)/2-((Radius*2+2)*2+2)),Radius,Color)
            Circle(Pos,Y+((Height-Radius)/2-(Radius*2+2)),      Radius,Color)
            Circle(Pos,Y+((Height-Radius)/2),                   Radius,Color)
            Circle(Pos,Y+((Height-Radius)/2+(Radius*2+2)),      Radius,Color)
            Circle(Pos,Y+((Height-Radius)/2+((Radius*2+2)*2+2)),Radius,Color)
          EndIf
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.b Draw_ScrollArea(*this._S_widget)
    Protected Pos, Size, X,Y,Width,Height, Color, Radius.d = 2
    
    With *this
      If *this > 0
        X = \X
        Y = \Y
        Width = \Width 
        Height = \Height
        
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(\x,\y,\width,\height,\Color[3]\frame[\color[1]\state])
        
        If \scroll
          Draw_Scroll(\scroll\v)
          Draw_Scroll(\scroll\h)
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.b Draw(*this._S_widget)
    With *this
      CompilerIf #PB_Compiler_OS <>#PB_OS_MacOS 
        DrawingFont(GetGadgetFont(-1))
      CompilerEndIf
      
      Select \type
        Case #PB_GadgetType_ScrollArea
          Draw_ScrollArea(*this)
        Case #PB_GadgetType_ProgressBar
          Draw_Progress(*this)
        Case #PB_GadgetType_ScrollBar
          Draw_Scroll(*this)
        Case #PB_GadgetType_Splitter
          Draw_Splitter(*this)
        Case #PB_GadgetType_TrackBar
          Draw_Track(*this)
      EndSelect
      
    EndWith
  EndProcedure
  
  ;-
  Procedure.l X(*this._S_widget)
    ProcedureReturn *this\x + Bool(*this\hide[1]) * *this\width
  EndProcedure
  
  Procedure.l Y(*this._S_widget)
    ProcedureReturn *this\y + Bool(*this\hide[1]) * *this\height
  EndProcedure
  
  Procedure.l Width(*this._S_widget)
    ProcedureReturn Bool(Not *this\hide[1]) * *this\width
  EndProcedure
  
  Procedure.l Height(*this._S_widget)
    ProcedureReturn Bool(Not *this\hide[1]) * *this\height
  EndProcedure
  
  Procedure.b Hide(*this._S_widget, State.b = #PB_Default)
    *this\hide ! Bool(*this\hide <> State And State <> #PB_Default)
    ProcedureReturn *this\hide
  EndProcedure
  
  ;- GET
  Procedure.i GetState(*this._S_widget)
    ProcedureReturn *this\page\pos
  EndProcedure
  
  Procedure.i GetAttribute(*this._S_widget, Attribute.i)
    Protected Result.i
    
    With *this
      Select Attribute
        Case #PB_Bar_Minimum : Result = \min  ; 1
        Case #PB_Bar_Maximum : Result = \max  ; 2
        Case #PB_Bar_PageLength : Result = \page\len
        Case #PB_Bar_Inverted : Result = \inverted
        Case #PB_Bar_Direction : Result = \direction
        Case #PB_Bar_NoButtons : Result = \button\len 
        Case #PB_Bar_ScrollStep : Result = \scrollstep
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  ;- SET
  Procedure.i SetPos(*this._S_widget, ThumbPos.i)
    Protected ScrollPos.i, Result.i
    
    With *this
      If ThumbPos < \area\pos : ThumbPos = \area\pos : EndIf
      If ThumbPos > \area\end : ThumbPos = \area\end : EndIf
      
      If \thumb\end <> ThumbPos 
        \thumb\end = ThumbPos
        
        ; from thumb pos get scroll pos 
        If \area\end <> ThumbPos
          ScrollPos = \min + Round((ThumbPos - \area\pos) / (\area\len / (\max-\min)), #PB_Round_Nearest)
        Else
          ScrollPos = \page\end
        EndIf
        
        If (#PB_GadgetType_TrackBar = \type Or \type = #PB_GadgetType_ProgressBar) And \vertical
          ScrollPos = _scroll_invert_(*this, ScrollPos, \inverted)
        EndIf
        
        Result = SetState(*this, ScrollPos)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b SetState(*this._S_widget, ScrollPos.l)
    Protected Result.b
    
    With *this
      If ScrollPos < \min : ScrollPos = \min : EndIf
      
      If \max And ScrollPos > \max-\page\len
        If \max > \page\len 
          ScrollPos = \max-\page\len
        Else
          ScrollPos = \min 
        EndIf
      EndIf
      
      ;       If ScrollPos > \page\end 
      ;         ScrollPos = \page\end 
      ;         Debug \page\end
      ;       EndIf
      
      If Not ((#PB_GadgetType_TrackBar = \type Or \type = #PB_GadgetType_ProgressBar) And \vertical)
        ScrollPos = _scroll_invert_(*this, ScrollPos, \inverted)
      EndIf
      
      If \page\pos <> ScrollPos
        \change = \page\pos - ScrollPos
        
        If \type = #PB_GadgetType_TrackBar Or 
           \type = #PB_GadgetType_ProgressBar
          
          If \page\pos > ScrollPos
            \direction =- ScrollPos
          Else
            \direction = ScrollPos
          EndIf
        Else
          If \page\pos > ScrollPos
            If \inverted
              \direction = _scroll_invert_(*this, ScrollPos, \inverted)
            Else
              \direction =- ScrollPos
            EndIf
          Else
            If \inverted
              \direction =- _scroll_invert_(*this, ScrollPos, \inverted)
            Else
              \direction = ScrollPos
            EndIf
          EndIf
        EndIf
        
        \page\pos = ScrollPos
        \thumb\pos = _thumb_pos_(*this, _scroll_invert_(*this, ScrollPos, \inverted))
        ; Debug ""+\thumb\pos+" "+\area\end+" "+\page\pos+" "+\page\end+" "+\page\len+" "+\max+" "+\min+" "+\height
        
        Result = #True
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.l SetAttribute(*this._S_widget, Attribute.l, Value.l)
    Protected Result.l
    
    With *this
      Select Attribute
        Case #PB_Bar_ScrollStep 
          \scrollstep = Value
          
        Case #PB_Bar_FirstMinimumSize
          \button[#_1]\len = Value
          Result = #True
          
        Case #PB_Bar_SecondMinimumSize
          \button[#_2]\len = Value
          Result = #True
          
        Case #PB_Bar_NoButtons
          If \button\len <> Value
            \button\len = Value
            \button[#_1]\len = Value
            \button[#_2]\len = Value
            Result = #True
          EndIf
          
        Case #PB_Bar_Inverted
          If \inverted <> Bool(Value)
            \inverted = Bool(Value)
            \thumb\pos = _thumb_pos_(*this, _scroll_invert_(*this, \page\pos, \inverted))
          EndIf
          
        Case #PB_Bar_Minimum
          If \min <> Value
            \min = Value
            \page\pos = Value
            Result = #True
          EndIf
          
        Case #PB_Bar_Maximum
          If \max <> Value
            If \min > Value
              \max = \min + 1
            Else
              \max = Value
            EndIf
            
            Result = #True
          EndIf
          
        Case #PB_Bar_PageLength
          If \page\len <> Value
            If Value > (\max-\min) 
              \max = Value ; Если этого page_length вызвать раньше maximum то не правильно работает
              \page\len = (\max-\min)
            Else
              \page\len = Value
            EndIf
            
            Result = #True
          EndIf
          
      EndSelect
      
      If Result
        \hide = Resize(*this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.b SetColor(*this._S_widget, ColorType.l, Color.l, Item.l=- 1, State.l=1)
    Protected Result
    
    With *this
      Select ColorType
        Case #PB_Gadget_LineColor
          If Item=- 1
            \Color\front[State] = Color
          Else
            \Color[Item]\front[State] = Color
          EndIf
          
        Case #PB_Gadget_BackColor
          If Item=- 1
            \Color\Back[State] = Color
          Else
            \Color[Item]\Back[State] = Color
          EndIf
          
        Case #PB_Gadget_FrontColor
        Default ; Case #PB_Gadget_FrameColor
          If Item=- 1
            \Color\frame[State] = Color
          Else
            \Color[Item]\frame[State] = Color
          EndIf
          
      EndSelect
    EndWith
    
    ; ResetColor(*this)
    
    ProcedureReturn Bool(Color)
  EndProcedure
  
  ;-
  Procedure.b Resize(*this._S_widget, X.l,Y.l,Width.l,Height.l)
    Protected Result
    
    With *this
      If X<>#PB_Ignore 
        \X = X 
      EndIf 
      If Y<>#PB_Ignore 
        \Y = Y 
      EndIf 
      If Width<>#PB_Ignore 
        \Width = Width 
      EndIf 
      If Height<>#PB_Ignore 
        \Height = height 
      EndIf
      
      ;
      If (\max-\min) >= \page\len
        If \Vertical
          \Area\pos = \Y + \button[1]\len
          \Area\len = \Height - (\button[1]\len + \button[2]\len)
        Else
          \Area\pos = \X + \button[1]\len
          \Area\len = \Width - (\button[1]\len + \button[2]\len)
        EndIf
        
        If \Area\len > \button\len
          \thumb\len = Round(\area\len - (\area\len / (\max-\min)) * ((\max-\min) - \page\len), #PB_Round_Nearest)
          
          If \thumb\len > \area\len 
            ; Debug " line-" + #PB_Compiler_Line + "   \thumb\len > \area\len"
            \thumb\len = \area\len 
          EndIf 
          
          If \thumb\len > \button\len
            ; Debug " line-" + #PB_Compiler_Line + "   \thumb\len > \button\len"
            \area\end = \area\pos + (\area\len-\thumb\len)
          Else
            ; Debug " line-" + #PB_Compiler_Line +" \thumb\len-"+ \thumb\len +" \button\len-"+ \button\len + "   \thumb\len =< \button\len"
            \area\len = \area\len - (\button\len-\thumb\len)
            \area\end = \area\pos + (\area\len-\thumb\len)                              
            \thumb\len = \button\len
          EndIf
        Else
          ; Debug " line-" + #PB_Compiler_Line + "   \Area\len > 0 And \Area\len =< \button\len"
          \thumb\len = 0
          If \Vertical
            \Area\pos = \Y
            \Area\len = \Height
          Else
            \Area\pos = \X
            \Area\len = \Width 
          EndIf
          \area\end = \area\pos + (\area\len - \thumb\len)
        EndIf
        
        If \Area\len > 0
          \page\end = \max - \page\len
          \thumb\pos = _thumb_pos_(*this, _scroll_invert_(*this, \page\pos, \inverted))
          
          If \type <> #PB_GadgetType_TrackBar And \thumb\pos = \area\end
            ; Debug " line-" + #PB_Compiler_Line +" "+  \type 
            SetState(*this, \max)
          EndIf
        EndIf
      EndIf
      
      If \scroll
        Resizes(\scroll, \x+2,\y+2,\width-4,\height-4)
      EndIf
      
      \hide[1] = Bool(Not ((\max-\min) > \page\len))
      ProcedureReturn \hide[1]
    EndWith
  EndProcedure
  
  Procedure.b Updates(*scroll._S_scroll, ScrollArea_X.l, ScrollArea_Y.l, ScrollArea_Width.l, ScrollArea_Height.l)
    With *scroll
      Protected iWidth = (\v\x + Bool(\v\hide) * \v\width) - \h\x, iHeight = (\h\y + Bool(\h\hide) * \h\height) - \v\y
      ;Protected iWidth = \h\page\len, iHeight = \v\page\len
      Static hPos, vPos : vPos = \v\page\pos : hPos = \h\page\pos
      
      ; Вправо работает как надо
      If ScrollArea_Width<\h\page\pos+iWidth 
        ScrollArea_Width=\h\page\pos+iWidth
        ; Влево работает как надо
      ElseIf ScrollArea_X>\h\page\pos And
             ScrollArea_Width=\h\page\pos+iWidth 
        ScrollArea_Width = iWidth 
      EndIf
      
      ; Вниз работает как надо
      If ScrollArea_Height<\v\page\pos+iHeight
        ScrollArea_Height=\v\page\pos+iHeight 
        ; Верх работает как надо
      ElseIf ScrollArea_Y>\v\page\pos And
             ScrollArea_Height=\v\page\pos+iHeight 
        ScrollArea_Height = iHeight 
      EndIf
      
      If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
      If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
      
      If ScrollArea_X<\h\page\pos : ScrollArea_Width-ScrollArea_X : EndIf
      If ScrollArea_Y<\v\page\pos : ScrollArea_Height-ScrollArea_Y : EndIf
      
      If \v\max<>ScrollArea_Height : SetAttribute(\v, #PB_ScrollBar_Maximum, ScrollArea_Height) : EndIf
      If \h\max<>ScrollArea_Width : SetAttribute(\h, #PB_ScrollBar_Maximum, ScrollArea_Width) : EndIf
      
      If \v\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      ;       If -\v\page\pos > ScrollArea_Y : SetState(\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
      ;       If -\h\page\pos > ScrollArea_X : SetState(\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
      If -\v\page\pos > ScrollArea_Y And ScrollArea_Y<>\v\Page\Pos 
        SetState(\v, -ScrollArea_Y)
      EndIf
      
      If -\h\page\pos > ScrollArea_X And ScrollArea_X<>\h\Page\Pos 
        SetState(\h, -ScrollArea_X) 
      EndIf
      
      \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y + Bool(\h\hide) * \h\height) - \v\y + Bool(Not \h\hide And \v\Radius And \h\Radius)*(\v\width/4))
      \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x + Bool(\v\hide) * \v\width) - \h\x + Bool(Not \v\hide And \v\Radius And \h\Radius)*(\h\height/4), #PB_Ignore)
      
      *Scroll\Y =- \v\Page\Pos
      *Scroll\X =- \h\Page\Pos
      *Scroll\width = \v\Max
      *Scroll\height = \h\Max
      
      
      
      If \v\hide : \v\page\pos = 0 : If vPos : \v\hide = vPos : EndIf : Else : \v\page\pos = vPos : EndIf
      If \h\hide : \h\page\pos = 0 : If hPos : \h\hide = hPos : EndIf : Else : \h\page\pos = hPos : EndIf
      
      ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
    EndWith
  EndProcedure
  
  Procedure.b Resizes(*scroll._S_scroll, X.l,Y.l,Width.l,Height.l )
    With *scroll
      Protected iHeight, iWidth
      
      If y=#PB_Ignore : y = \v\y : EndIf
      If x=#PB_Ignore : x = \h\x : EndIf
      If Width=#PB_Ignore : Width = \v\x-\h\x+\v\width : EndIf
      If Height=#PB_Ignore : Height = \h\y-\v\y+\h\height : EndIf
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\width And \v\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      \v\hide = Resize(\v, Width+x-\v\width, y, #PB_Ignore, \v\page\len)
      \h\hide = Resize(\h, x, Height+y-\h\height, \h\page\len, #PB_Ignore)
      
      iHeight = Height - Bool(Not \h\hide And \h\height) * \h\height
      iWidth = Width - Bool(Not \v\hide And \v\width) * \v\width
      
      If \v\width And \v\page\len<>iHeight : SetAttribute(\v, #PB_ScrollBar_PageLength, iHeight) : EndIf
      If \h\height And \h\page\len<>iWidth : SetAttribute(\h, #PB_ScrollBar_PageLength, iWidth) : EndIf
      
      If \v\page\len <> \v\height : \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\page\len) : EndIf
      If \h\page\len <> \h\width : \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, \h\page\len, #PB_Ignore) : EndIf
      
      If Not \v\hide And \v\width 
        \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x) + Bool(\v\Radius And \h\Radius)*(\v\width/4), #PB_Ignore)
      EndIf
      If Not \h\hide And \h\height
        \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y) + Bool(\v\Radius And \h\Radius)*(\h\height/4))
      EndIf
      
      ProcedureReturn #True
    EndWith
  EndProcedure
  
  ;-
  Macro _bar_(_this_, _min_, _max_, _page_length_, _flag_, _radius_=0)
    *event\widget = _this_
    _this_\scrollstep = 1
    _this_\radius = _radius_
    
    ; Цвет фона скролла
    _this_\color\alpha[0] = 255
    _this_\color\alpha[1] = 0
    
    _this_\color\back = $FFF9F9F9
    _this_\color\frame = _this_\color\back
    _this_\color\front = $FFFFFFFF ; line
    
    _this_\color[#_1] = def_colors
    _this_\color[#_2] = def_colors
    _this_\color[#_3] = def_colors
    
    _this_\vertical = Bool(_flag_&#PB_Bar_Vertical=#PB_Bar_Vertical)
    _this_\inverted = Bool(_flag_&#PB_Bar_Inverted=#PB_Bar_Inverted)
    
    If _this_\min <> _min_ : SetAttribute(_this_, #PB_Bar_Minimum, _min_) : EndIf
    If _this_\max <> _max_ : SetAttribute(_this_, #PB_Bar_Maximum, _max_) : EndIf
    If _this_\page\len <> _page_length_ : SetAttribute(_this_, #PB_Bar_PageLength, _page_length_) : EndIf
  EndMacro
  
  Procedure.i Scroll(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, PageLength.l, Flag.l=0, Radius.l=0)
    Protected *this._S_widget = AllocateStructure(_S_widget)
    _bar_(*this, min, max, PageLength, Flag, Radius)
    
    With *this
      \type = #PB_GadgetType_ScrollBar
      \button[#_1]\arrow_type = 1
      \button[#_2]\arrow_type = 1
      \button[#_1]\arrow_size = 6
      \button[#_2]\arrow_size = 6
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If Not Bool(Flag&#PB_Bar_NoButtons=#PB_Bar_NoButtons)
        If \vertical
          If width < 21
            \button\len = width - 1
          Else
            \button\len = 17
          EndIf
        Else
          If height < 21
            \button\len = height - 1
          Else
            \button\len = 17
          EndIf
        EndIf
        
        \button[#_1]\len = \button\len
        \button[#_2]\len = \button\len
      EndIf
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Track(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l=0, Radius.l=7)
    Protected *this._S_widget = AllocateStructure(_S_widget)
    _bar_(*this, min, max, 0, Flag, Radius)
    
    With *this
      \type = #PB_GadgetType_TrackBar
      \inverted = \vertical
      \mode = Bool(Flag&#PB_Bar_Ticks=#PB_Bar_Ticks) * #PB_Bar_Ticks
      \color[1]\state = Bool(Not \vertical) * #Selected
      \color[2]\state = Bool(\vertical) * #Selected
      \button\len = 15
      \button[#_1]\len = 1
      \button[#_2]\len = 1
      
      \button[#_3]\arrow_size = 6
      \button[#_3]\arrow_type = 1
      
      \cursor = #PB_Cursor_Hand
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Progress(X.l,Y.l,Width.l,Height.l, Min.l, Max.l, Flag.l=0, Radius.l=0)
    Protected *this._S_widget = AllocateStructure(_S_widget)
    _bar_(*this, min, max, 0, Flag, Radius)
    
    With *this
      \type = #PB_GadgetType_ProgressBar
      \inverted = \vertical
      \color[1]\state = Bool(Not \vertical) * #Selected
      \color[2]\state = Bool(\vertical) * #Selected
      \mode = 1
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Splitter(X.l,Y.l,Width.l,Height.l, First.i, Second.i, Flag.l=0, Radius.l=0)
    Protected *this._S_widget = AllocateStructure(_S_widget)
    _bar_(*this, 0, 0, 0, Flag, Radius)
    
    With *this
      \type = #PB_GadgetType_Splitter
      \vertical ! 1 ; = Bool(Flag&#PB_Splitter_Vertical=0)
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      If \vertical
        \max = Height-\button\len
        \cursor = #PB_Cursor_UpDown
      Else
        \max = Width-\button\len
        \cursor = #PB_Cursor_LeftRight
      EndIf
      
      \Splitter = AllocateStructure(_S_splitter)
      \Splitter\first = First
      \Splitter\second = Second
      \splitter\resize = @splitter_size()
      \splitter\g_first = IsGadget(First)
      \splitter\g_second = IsGadget(Second)
      
      If Bool(Flag&#PB_Splitter_Separator)
        \mode = #PB_Splitter_Separator
        \button\len = 7
      Else
        \mode = 1
        \button\len = 3
      EndIf
      
      SetState(*this, \max/2+1)
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
      
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i ScrollArea(X.l,Y.l,Width.l,Height.l, AreaWidth.l, AreaHeight.l, ScrollStep.l=1, Flag.l=0, Radius.l=0)
    Protected *this._S_widget = AllocateStructure(_S_widget)
    
    With *this
      \type = #PB_GadgetType_ScrollArea
      
      If Width = #PB_Ignore : Width = 0 : EndIf
      If Height = #PB_Ignore : Height = 0 : EndIf
      
      \scroll = AllocateStructure(_S_scroll)
      \scroll\v = Scroll(0,0,17,0,0,AreaHeight,0, #PB_Bar_Vertical)
      \scroll\h = Scroll(0,0,0,17,0,AreaWidth,0, 0)
      
      If (Width+Height)
        Resize(*this, X,Y,Width,Height)
      EndIf
    EndWith
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  Procedure.b Post(eventtype.l, *this._S_widget, item.l=#PB_All, *data=0)
    If *this\event And 
       (*this\event\type = #PB_All Or 
        *this\event\type = eventtype)
      
      *event\widget = *this
      *event\type = eventtype
      *event\data = *data
      *event\item = item
      
      ;If *this\event\callback
      *this\event\callback()
      ;EndIf
    EndIf
  EndProcedure
  
  Procedure.b Bind(*callBack, *this._S_widget, eventtype.l=#PB_All)
    *this\event = AllocateStructure(_S_event)
    *this\event\type = eventtype
    *this\event\callback = *callBack
  EndProcedure
  
  Procedure.b CallBack(*this._S_widget, EventType.l, MouseX.l, MouseY.l, WheelDelta.l=0)
    Protected Result, from
    Static LastX, LastY, Last, *thisis._S_widget, Cursor, Drag, Down
    
    With *this
      
      If \splitter And \from <> #_3
        If \splitter\first And Not \splitter\g_first
          If CallBack(\splitter\first, EventType, MouseX, MouseY)
            ProcedureReturn 1
          EndIf
        EndIf
        If \splitter\second And Not \splitter\g_second
          If CallBack(\splitter\second, EventType, MouseX, MouseY)
            ProcedureReturn 1
          EndIf
        EndIf
      EndIf
      
      ; get at point buttons
      If Down ; GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
        from = \from 
      Else
        If Not \hide And (Mousex>=\x And Mousex<\x+\Width And Mousey>\y And Mousey=<\y+\height) 
          If \button 
            If \button[#_3]\len And (MouseX>\button[#_3]\x And MouseX=<\button[#_3]\x+\button[#_3]\width And MouseY>\button[#_3]\y And MouseY=<\button[#_3]\y+\button[#_3]\height)
              from = #_3
            ElseIf \button[#_2]\len And (MouseX>\button[#_2]\x And MouseX=<\button[#_2]\x+\button[#_2]\Width And MouseY>\button[#_2]\y And MouseY=<\button[#_2]\y+\button[#_2]\height)
              from = #_2
            ElseIf \button[#_1]\len And (MouseX>\button[#_1]\x And MouseX=<\button[#_1]\x+\button[#_1]\Width And  MouseY>\button[#_1]\y And MouseY=<\button[#_1]\y+\button[#_1]\height)
              from = #_1
            Else
              from =- 1
            EndIf
            
            If \type = #PB_GadgetType_TrackBar
              Select from
                Case #_1, #_2
                  from =- 1
              EndSelect
              ; ElseIf \type = #PB_GadgetType_ProgressBar
              ;  from = 0
            EndIf
            
          Else
            from =- 1
          EndIf 
        EndIf 
      EndIf
      
      ; get
      Select EventType
        Case #PB_EventType_MouseWheel  
          If *thisis = *this
            Select WheelDelta
              Case-1 : Result = SetState(*this, \page\pos - (\max-\min)/30)
              Case 1 : Result = SetState(*this, \page\pos + (\max-\min)/30)
            EndSelect
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If Not Drag : \from = 0 : from = 0 : LastX = 0 : LastY = 0 : EndIf
        Case #PB_EventType_LeftButtonUp : Down = 0 :  Drag = 0 :  LastX = 0 : LastY = 0
        Case #PB_EventType_LeftButtonDown : Down = 1
          If from : \from = from : Drag = 1 : *thisis = *this : EndIf
          
          Select from
            Case - 1
              If *thisis = *this
                If \Vertical
                  Result = SetPos(*this, (MouseY-\thumb\len/2))
                Else
                  Result = SetPos(*this, (MouseX-\thumb\len/2))
                EndIf
                
                \from = 3
              EndIf
            Case 1 
              If \button[from]\len > 1 And \color[from]\state <> #Disabled
                If \inverted
                  Result = SetState(*this, _scroll_invert_(*this, (\page\pos + \scrollstep), \inverted))
                Else
                  Result = SetState(*this, _scroll_invert_(*this, (\page\pos - \scrollstep), \inverted))
                EndIf
              EndIf
            Case 2 
              If \button[from]\len > 1 And \color[from]\state <> #Disabled
                If \inverted
                  Result = SetState(*this, _scroll_invert_(*this, (\page\pos - \scrollstep), \inverted))
                Else
                  Result = SetState(*this, _scroll_invert_(*this, (\page\pos + \scrollstep), \inverted))
                EndIf
              EndIf
              
            Case 3 : LastX = MouseX - \thumb\pos : LastY = MouseY - \thumb\pos
          EndSelect
          
        Case #PB_EventType_MouseMove
          If Drag
            
            If *thisis = *this And Bool(LastX|LastY) 
              If \Vertical
                Result = SetPos(*this, (MouseY-LastY))
              Else
                Result = SetPos(*this, (MouseX-LastX))
              EndIf
            EndIf
            
          Else
            If from
              If \from <> from
                If *thisis > 0 
                  CallBack(*thisis, #PB_EventType_MouseLeave, MouseX, MouseY) 
                EndIf
                
                If *thisis <> *this 
                  ;Debug "Мышь находится внутри"
                  Cursor = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                  SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default)
                  *thisis = *this
                EndIf
                
                EventType = #PB_EventType_MouseEnter
                \from = from
              EndIf
            ElseIf *thisis = *this
              If Cursor <> GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                ;Debug "Мышь находится снаружи"
                SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, Cursor)
              EndIf
              EventType = #PB_EventType_MouseLeave
              \from = 0
              *thisis = 0
              ;               Last = 0
            EndIf
            
          EndIf
          
      EndSelect
      
      ; set colors
      Select EventType
        Case #PB_EventType_Focus : \focus = 1 : Result = #True
        Case #PB_EventType_LostFocus : \focus = 0 : Result = #True
        Case #PB_EventType_LeftButtonDown,
             #PB_EventType_LeftButtonUp, 
             #PB_EventType_MouseEnter,
             #PB_EventType_MouseLeave
          Static cursor_change
          
          If from > 0 And \color[from]\state <> #Disabled
            If \button[from]\len > 1
              \color[from]\state = #Entered + Bool(EventType=#PB_EventType_LeftButtonDown)
              
              ; Post(EventType, *this)
            EndIf
            
            ; Set splitter cursor
            If from = #_3 And \type = #PB_GadgetType_Splitter
              cursor_change = 1
              SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \cursor)
            EndIf
            
          ElseIf Not Drag And Not from 
            If \color\state <> #Disabled : \color\state = #Normal : EndIf
            If \button[#_1]\len > 1 And \color[#_1]\state <> #Disabled : \color[#_1]\state = #Normal : EndIf
            If \button[#_2]\len > 1 And \color[#_2]\state <> #Disabled : \color[#_2]\state = #Normal : EndIf
            If \button[#_3]\len > 1 And \color[#_3]\state <> #Disabled : \color[#_3]\state = #Normal : EndIf
            
            ; Reset splitter cursor
            If cursor_change : cursor_change = 0
              SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default)
            EndIf
          EndIf
          
          Result = #True
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  ;-
  ;- - ENDMODULE
  ;-
EndModule


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule Widget
  Global g_Canvas, NewList *List._S_widget()
  
  
  Procedure ReDraw(Canvas)
    If StartDrawing(CanvasOutput(Canvas))
      FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $F6)
      
      ; PushListPosition(*List())
      ForEach *List()
        If Not *List()\hide
          Draw(*List())
        EndIf
      Next
      ; PopListPosition(*List())
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure.i Canvas_Events()
    Protected Canvas.i = EventGadget()
    Protected EventType.i = EventType()
    Protected Repaint
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    ;      MouseX = DesktopMouseX()-GadgetX(Canvas, #PB_Gadget_ScreenCoordinate)
    ;      MouseY = DesktopMouseY()-GadgetY(Canvas, #PB_Gadget_ScreenCoordinate)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected *callback = GetGadgetData(Canvas)
    ;     Protected *this._S_widget = GetGadgetData(Canvas)
    
    Select EventType
      Case #PB_EventType_Resize ; : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                                ;          ForEach *List()
                                ;            Resize(*List(), #PB_Ignore, #PB_Ignore, Width, Height)  
                                ;          Next
        Repaint = 1
        
      Case #PB_EventType_LeftButtonDown
        SetActiveGadget(Canvas)
        
    EndSelect
    
    ForEach *List()
      Repaint | CallBack(*List(), EventType, MouseX, MouseY)
      
      If *List()\change
        
        
        
        *List()\change = 0
      EndIf
    Next
    
    If Repaint 
      ReDraw(Canvas)
    EndIf
  EndProcedure
  
  Procedure ev()
    Debug ""+Widget() +" "+ Type() +" "+ Item() +" "+ Data()     ;  EventWindow() +" "+ EventGadget() +" "+ 
  EndProcedure
  
  Procedure ev2()
    Debug "  "+Widget() +" "+ Type() +" "+ Item() +" "+ Data()   ;  EventWindow() +" "+ EventGadget() +" "+ 
  EndProcedure
  
  
    Procedure BindScrollDatas()
    SetWindowTitle(0, "ScrollAreaGadget " +
                      "(" +
                      GetGadgetAttribute(0, #PB_ScrollArea_X) +
                      "," +                      
                      GetGadgetAttribute(0, #PB_ScrollArea_Y) +
                      ")" )
  EndProcedure
  
  If OpenWindow(0, 0, 0, 810, 240, "ScrollAreaGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ScrollAreaGadget(0, 10, 10, 390,220, 575, 555, 30)
      ButtonGadget  (1, 10, 10, 230, 30,"Button 1")
      ButtonGadget  (2, 50, 50, 230, 30,"Button 2")
      ButtonGadget  (3, 90, 90, 230, 30,"Button 3")
      TextGadget    (4,130,130, 230, 20,"This is the content of a ScrollAreaGadget!",#PB_Text_Right)
      CloseGadgetList()
  
    BindGadgetEvent(0, @ BindScrollDatas())
  
    g_Canvas = CanvasGadget(-1, 405, 5, 400,230, #PB_Canvas_Container)
    BindGadgetEvent(g_Canvas, @Canvas_Events())
    PostEvent(#PB_Event_Gadget, 0,g_Canvas, #PB_EventType_Resize)
    
    AddElement(*List()) : *List() = ScrollArea(5, 5, 390,220, 575, 555, 30)
;       ButtonGadget  (1, 10, 10, 230, 30,"Button 1")
;       ButtonGadget  (2, 50, 50, 230, 30,"Button 2")
;       ButtonGadget  (3, 90, 90, 230, 30,"Button 3")
;       TextGadget    (4,130,130, 230, 20,"This is the content of a ScrollAreaGadget!",#PB_Text_Right)
;       CloseList()
  
    Repeat
      Select WaitWindowEvent()
        Case  #PB_Event_CloseWindow
          End
        Case  #PB_Event_Gadget
          Select EventGadget()
            Case 0
              MessageRequester("Info","A Scroll has been used ! (" +
                                      GetGadgetAttribute(0, #PB_ScrollArea_X) +
                                      "," +                      
                                      GetGadgetAttribute(0, #PB_ScrollArea_Y) +
                                      ")" ,#PB_MessageRequester_Ok)
            Case 1
              MessageRequester("Info","Button 1 was pressed!",#PB_MessageRequester_Ok)
            Case 2
              MessageRequester("Info","Button 2 was pressed!",#PB_MessageRequester_Ok)
            Case 3
              MessageRequester("Info","Button 3 was pressed!",#PB_MessageRequester_Ok)
          EndSelect
      EndSelect
    ForEver
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -------------------f------------------+--
; EnableXP