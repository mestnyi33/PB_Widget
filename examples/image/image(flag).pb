﻿
IncludePath "../../"
XIncludeFile "widgets.pbi"
; ;XIncludeFile "../empty.pb"
UseLib(widget)

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png") ; world.png") ; File.bmp") ; Измените путь/имя файла на собственное изображение 32x32 пикселя
    End
  EndIf
  
  Define cr.s = #LF$, text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  Global *this._s_widget, gadget, Button_type, Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  Global Button_6, Button_7, Button_8
  
  Define vert=100, horiz=100, width=400, height=400
  
  Procedure events_widgets()
    Protected flag
    
    Select this()\event
      Case #PB_EventType_LeftClick
        Select this()\widget
          Case *this
            If Flag(*this, #__button_toggle)
              SetState(Button_4, GetState(this()\widget))
            EndIf
            
          Case Button_type 
            If GetState(this()\widget)
              Hide(*this, 1)
              HideGadget(gadget, 0)
              If Splitter_0
                SetAttribute(Splitter_0, #PB_Splitter_SecondGadget, gadget)
              EndIf
              SetText(Button_type, "widget")
            Else
              Hide(*this, 0)
              HideGadget(gadget, 1)
              If Splitter_0
                SetAttribute(Splitter_0, #PB_Splitter_SecondGadget, *this)
              EndIf
              SetText(Button_type, "gadget")
            EndIf
            
          Case Button_0 : flag = #__button_default
          Case Button_1 : flag = #__button_multiline
          Case Button_2 : flag = #__button_left
          Case Button_3 : flag = #__button_right
          Case Button_4 : flag = #__button_toggle
          Case Button_5 : flag = #__text_top
          Case Button_6 : flag = #__text_bottom
          Case Button_7 : flag = #__text_invert
          Case Button_8 : flag = #__text_vertical
        EndSelect
        
        If flag
          Flag(*this, flag, GetState(this()\widget))
        EndIf
        Post(#__event_repaint, #PB_All)
    EndSelect
    
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 0, 0, width+180, height+70, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    gadget = ButtonGadget(#PB_Any, 100, 100, 250, 200, text, #PB_Button_MultiLine) 
    HideGadget(gadget,1)
   *this = widget::Image(100, 100, 250, 250, 0) 
     ;*this = widget::Editor(100, 100, 250, 250, #__text_wordwrap) : SetText(*this, get_text())
    
    Define y = 10
    ; flag
    Button_type = widget::Button(width+45,   y, 100, 26, "gadget", #__button_toggle) 
    Button_0 = widget::Button(width+45, y+30*1, 100, 26, "autosize", #__button_toggle) 
    Button_1 = widget::Button(width+45, y+30*2, 100, 26, "strech", #__button_toggle) 
    Button_4 = widget::Button(width+45, y+30*3, 100, 26, "proportional", #__button_toggle) 
    
    Button_5 = widget::Button(width+45, y+30*4, 100, 26, "top", #__button_toggle) 
    Button_2 = widget::Button(width+45, y+30*5, 45, 26, "left", #__button_toggle) 
    Button_3 = widget::Button(width+45 + 55, y+30*5, 45, 26, "right", #__button_toggle) 
    Button_6 = widget::Button(width+45, y+30*6, 100, 26, "bottom", #__button_toggle) 
    
;     Button_8 = widget::Button(width+45, y+30*7, 100, 26, "vertical", #__button_toggle) 
;     Button_7 = widget::Button(width+45, y+30*8, 100, 26, "invert", #__button_toggle) 
    Bind(#PB_All, @events_widgets())
    
    ; set button toggled state
    SetState(Button_1, Flag(*this, #__flag_proportional))
    SetState(Button_5, Flag(*this, #__flag_top))
    SetState(Button_2, Flag(*this, #__flag_left))
    SetState(Button_3, Flag(*this, #__flag_right))
    SetState(Button_6, Flag(*this, #__flag_bottom))
    
    Hide(Button_type, 1)
    
    ;     Splitter_0 = widget::Splitter(0, 0, 0, 0, #Null, *this, #PB_Splitter_FirstFixed)
    ;     Splitter_1 = widget::Splitter(0, 0, 0, 0, #Null, Splitter_0, #PB_Splitter_FirstFixed|#PB_Splitter_Vertical)
    ;     Splitter_2 = widget::Splitter(0, 0, 0, 0, Splitter_1, #Null, #PB_Splitter_SecondFixed)
    ;     Splitter_3 = widget::Splitter(10, 10, width, height, Splitter_2, #Null, #PB_Splitter_Vertical|#PB_Splitter_SecondFixed)
    ;     SetState(Splitter_3, width-40-horiz)
    ;     SetState(Splitter_2, height-40-vert)
    ;     SetState(Splitter_0, vert)
    ;     SetState(Splitter_1, horiz)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = 8-
; EnableXP