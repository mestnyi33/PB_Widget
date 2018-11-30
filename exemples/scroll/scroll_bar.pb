﻿CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElse
  IncludePath "../../"
CompilerEndIf

XIncludeFile "module_macros.pbi"
XIncludeFile "module_constants.pbi"
XIncludeFile "module_structures.pbi"
XIncludeFile "module_scroll.pbi"
;
; Module name   : ScrollBar
; Author        : mestnyi
; Last updated  : Sep 20, 2018
; Forum link    : https://www.purebasic.fr/english/viewtopic.php?f=12&t=70662
; 

DeclareModule ScrollBar
  EnableExplicit
  
  ;- STRUCTURE
  Structure Canvas
    Gadget.l
    Window.l
  EndStructure
  
  Structure Gadget Extends structures::Coordinate_S
    Type.l
    fSize.l
    bSize.l
    
    Canvas.Canvas
    Color.structures::Color_S
    Scroll.structures::Scroll_S
  EndStructure
  
  
  ;- DECLARE
  Declare GetState(Gadget.l)
  Declare SetState(Gadget.l, State.l)
  Declare GetAttribute(Gadget.l, Attribute.l)
  Declare SetAttribute(Gadget.l, Attribute.l, Value.l)
  Declare Gadget(Gadget, X.l, Y.l, Width.l, Height.l, Min.l, Max.l, Pagelength.l, Flag.l=0)
  
EndDeclareModule

Module ScrollBar
  
  ;- PROCEDURE
  
  Procedure Draw(*This.Gadget)
    With *This
      If StartDrawing(CanvasOutput(\Canvas\Gadget))
        
        If \fSize
          DrawingMode(#PB_2DDrawing_Default)
          If \Scroll\bar\Vertical
            Line(\X[1],\Y[1]-1,\Width,1,\Color\Frame)
            Line(\X[1]+\Width[1],\Y[1],1,\Height,\Color\Frame)
            Line(\X[1],\Y[1]+\Height[1],\Width,1,\Color\Frame)
          Else
            Line(\X[1]-1,\Y[1],1,\Height,\Color\Frame)
            Line(\X[1],\Y[1]+\Height[1],\Width,1,\Color\Frame)
            Line(\X[1]+\Width[1],\Y[1],1,\Height,\Color\Frame)
          EndIf
        EndIf
        
        Scroll::Draw(*This\Scroll)
        StopDrawing()
      EndIf
    EndWith  
  EndProcedure
  
  Procedure CallBack()
    Protected WheelDelta.l, Mouse_X.l, Mouse_Y.l, *This.Gadget = GetGadgetData(EventGadget())
    
    With *This
      \Canvas\Window = EventWindow()
      Mouse_X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
      Mouse_Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
      WheelDelta = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_WheelDelta)
      
      Select EventType()
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          \Width = GadgetWidth(\Canvas\Gadget)
          \Height = GadgetHeight(\Canvas\Gadget)
          
            ; Inner coordinae
          If \Scroll\bar\Vertical
            \X[2]=\bSize
            \Y[2]=\bSize*2
            \Width[2] = \Width-\bSize*3
            \Height[2] = \Height-\bSize*4
          Else
            \X[2]=\bSize*2
            \Y[2]=\bSize
            \Width[2] = \Width-\bSize*4
            \Height[2] = \Height-\bSize*3
          EndIf
          
          ; Frame coordinae
          \X[1]=\X[2]-\fSize
          \Y[1]=\Y[2]-\fSize
          \Width[1] = \Width[2]+\fSize*2
          \Height[1] = \Height[2]+\fSize*2
          
          Scroll::Resize(\Scroll, \X[2], \Y[2], \Width[2], \Height[2]) : Draw(*This)
      EndSelect
      
      If Scroll::CallBack(\Scroll, EventType(), Mouse_X, Mouse_Y, WheelDelta) : Draw(*This)
        If \Scroll\bar\Buttons : PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change) : EndIf
      EndIf
    EndWith
    
  EndProcedure
  
  ;- PUBLIC
  Procedure SetAttribute(Gadget.l, Attribute.l, Value.l)
    Protected *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      If Scroll::SetAttribute(*This\Scroll, Attribute, Value)
        Draw(*This)
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetAttribute(Gadget.l, Attribute.l)
    Protected Result, *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      Select Attribute
        Case #PB_ScrollBar_Minimum    : Result = \Scroll\bar\Min
        Case #PB_ScrollBar_Maximum    : Result = \Scroll\bar\Max
        Case #PB_ScrollBar_PageLength : Result = \Scroll\bar\Page\len
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetState(Gadget.l, State.l)
    Protected *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      If Scroll::SetState(*This\Scroll, State) : Draw(*This)
        PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change)
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetState(Gadget.l)
    Protected *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      ProcedureReturn \Scroll\bar\Page\Pos
    EndWith
  EndProcedure
  
  Procedure Gadget(Gadget, X.l, Y.l, Width.l, Height.l, Min.l, Max.l, Pagelength.l, Flag.l=0)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    Protected *This.Gadget = AllocateStructure(Gadget)
    
    If *This
      With *This
        \Type = #PB_GadgetType_ScrollBar
        \Canvas\Gadget = Gadget
        \Width = Width
        \Height = Height
        
        \fSize = 0
        \bSize = \fSize
        
        ; Inner coordinae
        If Flag&#PB_ScrollBar_Vertical
          \X[2]=\bSize
          \Y[2]=\bSize*2
          \Width[2] = \Width-\bSize*3
          \Height[2] = \Height-\bSize*4
        Else
          \X[2]=\bSize*2
          \Y[2]=\bSize
          \Width[2] = \Width-\bSize*4
          \Height[2] = \Height-\bSize*3
        EndIf
        
        ; Frame coordinae
        \X[1]=\X[2]-\fSize
        \Y[1]=\Y[2]-\fSize
        \Width[1] = \Width[2]+\fSize*2
        \Height[1] = \Height[2]+\fSize*2
        
        \Color\Frame = $C0C0C0
        
        Scroll::Widget(\Scroll, \X[2], \Y[2], \Width[2], \Height[2], Min, Max, PageLength, Flag)
        \Scroll\bar\Type[1]=1 
        \Scroll\bar\Type[2]=1
        \Scroll\bar\Size[1]=6 
        \Scroll\bar\Size[2]=6
        
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @CallBack())
        Draw(*This)
      EndIf
    EndWith
    
    ProcedureReturn Gadget
  EndProcedure
EndModule


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  Procedure v_GadgetCallBack()
    ScrollBar::SetState(13, GetGadgetState(EventGadget()))
  EndProcedure
  
  Procedure v_CallBack()
    SetGadgetState(3, ScrollBar::GetState(EventGadget()))
  EndProcedure
  
  Procedure h_GadgetCallBack()
    ScrollBar::SetState(12, GetGadgetState(EventGadget()))
  EndProcedure
  
  Procedure h_CallBack()
    SetGadgetState(2, ScrollBar::GetState(EventGadget()))
  EndProcedure
  

  If OpenWindow(0, 0, 0, 605, 140, "ScrollBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    TextGadget       (-1,  10, 25, 250,  20, "ScrollBar Standard  (start=50, page=30/100)",#PB_Text_Center)
    ScrollBarGadget  (2,  10, 42, 250,  20, 30, 100, 30)
    SetGadgetState   (2,  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  10,115, 250,  20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ScrollBarGadget  (3, 270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical)
    SetGadgetState   (3, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    TextGadget       (-1,  300+10, 25, 250,  20, "ScrollBar Standard  (start=50, page=30/100)",#PB_Text_Center)
    ScrollBar::Gadget  (12,  300+10, 42, 250,  20, 30, 100, 30)
    ScrollBar::SetState   (12,  50)   ; set 1st scrollbar (ID = 0) to 50 of 100
    TextGadget       (-1,  300+10,115, 250,  20, "ScrollBar Vertical  (start=100, page=50/300)",#PB_Text_Right)
    ScrollBar::Gadget  (13, 300+270, 10,  25, 120 ,0, 300, 50, #PB_ScrollBar_Vertical)
    ScrollBar::SetState   (13, 100)   ; set 2nd scrollbar (ID = 1) to 100 of 300
    
    
    BindGadgetEvent(2,@h_GadgetCallBack())
    BindGadgetEvent(12,@h_CallBack(), #PB_EventType_Change)
    BindGadgetEvent(3,@v_GadgetCallBack())
    BindGadgetEvent(13,@v_CallBack(), #PB_EventType_Change)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = ------
; EnableXP