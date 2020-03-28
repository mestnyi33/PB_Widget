﻿IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  ; Shows possible flags of ButtonGadget in action...
  UseLib(Widget)
  EnableExplicit
  
  Global *B_0, *B_1, *B_2, *B_3, *B_4, *B_5
  Global *Button_0._S_widget
  Global *Button_1._S_widget
  
  UsePNGImageDecoder()
  
  If Not LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")
    End
  EndIf
  If Not LoadImage(10, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png")
    End
  EndIf
  
  Procedure _Events()
    Debug "window "+EventWindow()+" widget "+EventGadget()+" eventtype "+EventType()+" eventdata "+EventData()
  EndProcedure
  
  LoadFont(0, "Arial", 18-Bool(#PB_Compiler_OS=#PB_OS_Windows)*4)
  
  If OpenWindow(0, 0, 0, 222+222, 205+70, "Buttons on the canvas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ButtonGadget(0, 10, 10, 200, 20, "Standard Button")
    ButtonGadget(1, 10, 40, 200, 20, "Left Button", #PB_Button_Left)
    ButtonGadget(2, 10, 70, 200, 20, "Right Button", #PB_Button_Right)
    ButtonGadget(3, 10,100, 200, 60, "Multiline Button  (longer text gets automatically wrapped)");, #PB_Button_MultiLine)
    ButtonGadget(4, 10,170, 200, 60, "Multiline Button  (longer text gets automatically multiline)", #PB_Button_MultiLine|#PB_Button_Default)
    ButtonGadget(5, 10,170+70, 200, 20, "Toggle Button", #PB_Button_Toggle)
    
    Open(0,  222, 0, 222, 205+70)
    
    Button(10, 10, 200, 20, "Standard Button", 0,-1,8)
    Button(10, 40, 200, 20, "Left Button", #__button_left)
    Button(10, 70, 200, 20, "Right Button", #__button_right)
    Button(10,100, 200, 60, "Multiline Button  (longer text gets automatically wrapped)");, #__text_wordwrap, 4)
    Button(10,170, 200, 60, "Multiline Button  (longer text gets automatically multiline)", #__button_multiline|#__button_default, 4)
    Button(10,170+70, 200, 25, "Toggle Button", #__button_toggle)
    
  EndIf
  
  
  Global c2
  Procedure ResizeCallBack()
    Protected Width = WindowWidth(EventWindow(), #PB_Window_InnerCoordinate) 
    Protected Height = WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)
    
    Resize(*Button_0, Width-85, #PB_Ignore, #PB_Ignore, Height-30)
    Resize(*Button_1, #PB_Ignore, #PB_Ignore, Width-100, #PB_Ignore)
    ResizeGadget(c2, 10, 10, Width-20, Height-20)
    SetWindowTitle(EventWindow(), Str(*Button_1\width))
  EndProcedure
  
;   Procedure ResizeCallBack()
;     ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
;   EndProcedure
  
  LoadFont(0, "Courier", 14)
  
  If OpenWindow(11, 0, 0, 260, 160, "Button on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    Open(11, 10, 10 , 240, 160)
    c2 = GetGadget(Root())
    
    *Button_0 = Button(270, 5,  60, 120, "Button (Vertical)", #__button_multiline|#__button_vertical);|#__button_inverted)
    SetColor(*Button_0, #__Color_Front, $D56F1A)
    SetFont(*Button_0, FontID(0))
    
    *Button_1 = Button(5, 42, 250,  60, "Button (Horisontal)", #__button_multiline,-1)
    SetColor(*Button_1, #__Color_fore, $0000FF)
    SetColor(*Button_1, #__Color_Back, $00FF00)
    SetColor(*Button_1, #__Color_Front, $FFFFFF) ; $4919D5)
    SetFont(*Button_1, FontID(0))
    
    
    ResizeWindow(11, #PB_Ignore, WindowY(0)+WindowHeight(0, #PB_Window_FrameCoordinate)+10, #PB_Ignore, #PB_Ignore)
    
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 11)
    PostEvent(#PB_Event_SizeWindow, 11, #PB_Ignore)
    
;     BindGadgetEvent(g, @CallBacks())
;     PostEvent(#PB_Event_Gadget, 11,11, #PB_EventType_Resize)
;     
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = --
; EnableXP