﻿XIncludeFile "../../widgets.pbi" : Uselib(widget)

Procedure events_gadgets()
  ClearDebugOutput()
  ; Debug ""+EventGadget()+ " - widget  event - " +EventType()+ "  state - " +GetGadgetState(EventGadget()) ; 
  
  Select EventType()
    Case #PB_EventType_LeftClick
     SetState(GetWidget(EventGadget()), GetGadgetState(EventGadget()))
     Debug  ""+ EventGadget() +" - gadget change " + GetGadgetState(EventGadget())
  EndSelect
EndProcedure

Procedure events_widgets()
  ClearDebugOutput()
  ; Debug ""+Str(*event\widget\index - 1)+ " - widget  event - " +*event\type+ "  state - " GetState(*event\widget) ; 
  
  Select *event\type
    Case #PB_EventType_Change
      SetGadgetState((*event\widget\index - 1), GetState(*event\widget))
      Debug  Str(*event\widget\index - 1)+" - widget change " + GetState(*event\widget)
  EndSelect
EndProcedure

If Open(OpenWindow(#PB_Any, 0, 0, 230+230, 200, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered))
    #Button1  = 0
    #Button2  = 1
    #Splitter = 2

    ButtonGadget(#Button1, 0, 0, 0, 0, "Button 1") ; No need to specify size or coordinates
    ButtonGadget(#Button2, 0, 0, 0, 0, "Button 2") ; as they will be sized automatically
    SplitterGadget(#Splitter, 5, 5, 220, 120, #Button1, #Button2, #PB_Splitter_Separator)
    BindGadgetEvent(#Splitter, @events_gadgets())
    
    TextGadget(3, 10, 135, 210, 60, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Border|#PB_Text_Center )

    Button(0+230, 0, 0, 0, "Button 1") ; No need to specify size or coordinates
    Button(0+230, 0, 0, 0, "Button 2") ; as they will be sized automatically
    Splitter(5+230, 5, 220, 120, GetWidget(#Button1), GetWidget(#Button2));, #PB_Splitter_Separator)
    Bind(GetWidget(#Splitter), @events_widgets())
    
    Text(10+230, 135, 210, 60, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#__text_border|#__text_center|#__text_top )

    Repeat
    Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP