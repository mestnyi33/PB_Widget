﻿IncludePath "../../"
XIncludeFile "widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  Uselib(widget)
  EnableExplicit
  
  Global w_this, w_flag
  
  Procedure events_widgets()
    Static _2click
    
    Select this()\event
      Case #PB_EventType_LeftButtonDown
        If _2click = 2
          _2click = 0
          ClearItems(w_flag)
        EndIf
        AddItem(w_flag, -1, "down")
        
      Case #PB_EventType_LeftButtonUp    : AddItem(w_flag, -1, " up")
      Case #PB_EventType_LeftClick       : AddItem(w_flag, -1, "  click") : _2click + 1
      Case #PB_EventType_LeftDoubleClick : AddItem(w_flag, -1, "   2_click") : _2click = 2
    EndSelect
    
    SetState(w_flag, countitems(w_flag) - 1)
  EndProcedure
  
  If Open(OpenWindow(#PB_Any, 0, 0, 170, 300, "flag", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    
    w_flag = widget::Tree(10, 10, 150, 200, #__tree_nobuttons | #__tree_nolines) 
    w_this = widget::Button(10, 220, 150, 70, "Click me", #__button_multiline );| #__button_toggle) 
    
  
    widget::Bind(w_this, @events_widgets(), #PB_EventType_LeftButtonDown)
    widget::Bind(w_this, @events_widgets(), #PB_EventType_LeftButtonUp)
    widget::Bind(w_this, @events_widgets(), #PB_EventType_LeftClick)
    widget::Bind(w_this, @events_widgets(), #PB_EventType_LeftDoubleClick)
    
    widget::Bind(w_this, @events_widgets(), #PB_EventType_MouseEnter)
    widget::Bind(w_this, @events_widgets(), #PB_EventType_MouseLeave)
    
    widget::WaitClose()
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP