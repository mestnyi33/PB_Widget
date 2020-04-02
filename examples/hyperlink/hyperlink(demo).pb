﻿XIncludeFile "../../widgets.pbi" : Uselib(widget)

Procedure events_gadgets()
  ;ClearDebugOutput()
  ; Debug ""+EventGadget()+ " - widget  event - " +EventType()+ "  state - " +GetGadgetState(EventGadget()) ; 
  
  Select EventType()
    Case #PB_EventType_LeftClick
     SetState(GetWidget(EventGadget()), GetGadgetState(EventGadget()))
     Debug  ""+ EventGadget() +" - gadget change " + GetGadgetState(EventGadget())
  EndSelect
EndProcedure

Procedure events_widgets()
  ;ClearDebugOutput()
  ; Debug ""+Str(*event\widget\index - 1)+ " - widget  event - " +*event\type+ "  state - " GetState(*event\widget) ; 
  
  Select *event\type
    Case #PB_EventType_LeftClick
      SetGadgetState((*event\widget\index - 1), GetState(*event\widget))
      Debug  Str(*event\widget\index - 1)+" - widget change " + GetState(*event\widget)
  EndSelect
EndProcedure

; Shows possible flags of ButtonGadget in action...
If Open(OpenWindow(#PB_Any, 0, 0, 270+270, 100, "HyperLinkGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
  HyperLinkGadget(0, 10, 10, 250,20,"Red HyperLink", RGB(255,0,0))
  HyperLinkGadget(1, 10, 40, 250,40,"Arial Underlined Green HyperLink", RGB(0,255,0), #PB_HyperLink_Underline)
  SetGadgetFont(1, LoadFont(0, "Arial", 14))
  SetGadgetColor(1, #PB_Gadget_FrontColor, $ff0000)
  SetGadgetColor(1, #PB_Gadget_BackColor, $0000ff)
    
  For i = 0 To 1
    BindGadgetEvent(i, @events_gadgets())
  Next
  
  HyperLink(10+270, 10, 250,20,"Red HyperLink", RGB(255,0,0))
  HyperLink(10+270, 40, 250,40,"Arial Underlined Green HyperLink", RGB(0,255,0), #PB_HyperLink_Underline)
  SetFont(GetWidget(1), LoadFont(0, "Arial", 14))
  SetColor(GetWidget(1), #PB_Gadget_FrontColor, $ffff0000)
  SetColor(GetWidget(1), #PB_Gadget_BackColor, $ff0000ff)
  
  ;Bind(#PB_All, @events_widgets())
  
  For i = 0 To 1
    Bind(GetWidget(i), @events_widgets())
  Next
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = v
; EnableXP