﻿XIncludeFile "../../widgets.pbi" 
Uselib(widget)

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UsePNGImageDecoder()
  
  Procedure call()
;     Repeat 
;         If WaitWindowEvent() = #PB_Event_CloseWindow
; ;           If EventWindow() = _window_ 
; ;               Debug " - close2 - " +EventWindow() ; +" "+ GetWindow(_window_)
; ;             Break
; ;           EndIf
;         EndIf
;       ForEver
    
;     Define Message.MSG
;     While GetMessage_( Message, 0, 0, 0 )
;       Debug Message
;       Select Message
;           
;       EndSelect
;     Wend
  
  EndProcedure
  
  Procedure events_()
    Debug " "+ this()\event +" "+ this()\widget\index
    
    If this()\event = #PB_EventType_CloseWindow
      Debug "close"
      Message("","",#PB_MessageRequester_Ok)
      ;CallCFunctionFast(@call())
      
      ProcedureReturn #PB_Ignore
    EndIf
  EndProcedure
  
  Open(OpenWindow(#PB_Any, 150, 150, 500, 400, "PB (window_1)", #__Window_SizeGadget | #__Window_SystemMenu))
  
  Window(100,100,200,200,"", #__window_systemmenu|#__window_maximizegadget|#__window_minimizegadget)
  
  Bind(widget(), @events_())
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.62 (Windows - x86)
; CursorPosition = 33
; FirstLine = 9
; Folding = -
; EnableXP