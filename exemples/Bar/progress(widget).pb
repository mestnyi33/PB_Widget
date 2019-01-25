﻿IncludePath "../../"
XIncludeFile "module_bar.pbi"

;
; Module name   : ProgressBar
; Author        : mestnyi
; Last updated  : Dec 29, 2018
; Forum link    : https://www.purebasic.fr/english/viewtopic.php?f=12&t=70663
; 

DeclareModule ProgressBar
  EnableExplicit
  
  ;- STRUCTURE
  Structure Canvas
    Gadget.i
    Window.i
  EndStructure
  
  Structure Gadget Extends Bar::Coordinate_S
    Canvas.Canvas
    *Bar.Bar::Bar_S
  EndStructure
  
  ;- DECLARE
  Declare GetState(Gadget.i)
  Declare SetState(Gadget.i, State.i)
  Declare GetAttribute(Gadget.i, Attribute.i)
  Declare SetAttribute(Gadget.i, Attribute.i, Value.i)
  Declare Gadget(Gadget, X.i, Y.i, Width.i, Height.i, Min.i, Max.i, Flag.i=0)
  
EndDeclareModule

Module ProgressBar
  
  ;- PROCEDURE
  Procedure Draw(*This.Gadget)
    With *This
      If StartDrawing(CanvasOutput(\Canvas\Gadget))
        Bar::Draw(\Bar)
       StopDrawing()
      EndIf
    EndWith 
  EndProcedure
  
  Procedure Canvas_Events(EventGadget.i, EventType.i)
    Protected Repaint.i, Mouse_X.i, Mouse_Y.i, *This.Gadget = GetGadgetData(EventGadget)
    
    If *This 
      With *This
        \Canvas\Window = EventWindow()
        Mouse_X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
        Mouse_Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
        
        Select EventType
          Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
            Bar::Resize(*This\Bar, #PB_Ignore, #PB_Ignore, GadgetWidth(\Canvas\Gadget), GadgetHeight(\Canvas\Gadget))
            Repaint = 1
       EndSelect
        
        Repaint | Bar::CallBack(\Bar, EventType, Mouse_X, Mouse_Y)
        
        If Repaint 
          If \Bar\Change 
            PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change) 
          EndIf
          
          Draw(*This)
        EndIf
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure Canvas_CallBack()
    ; Canvas events bug fix
    Protected Result.b
    Static MouseLeave.b
    Protected EventGadget.i = EventGadget()
    Protected EventType.i = EventType()
    Protected Width = GadgetWidth(EventGadget)
    Protected Height = GadgetHeight(EventGadget)
    Protected MouseX = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
    
    ; Это из за ошибки в мак ос и линукс
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS Or #PB_Compiler_OS = #PB_OS_Linux
      Select EventType 
        Case #PB_EventType_MouseEnter 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons) Or MouseLeave =- 1
            EventType = #PB_EventType_MouseMove
            MouseLeave = 0
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons)
            EventType = #PB_EventType_MouseMove
            MouseLeave = 1
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          If GetActiveGadget()<>EventGadget
            SetActiveGadget(EventGadget)
          EndIf
          
        Case #PB_EventType_LeftButtonUp
          If MouseLeave = 1 And Not Bool((MouseX>=0 And MouseX<Width) And (MouseY>=0 And MouseY<Height))
            MouseLeave = 0
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
              Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
              EventType = #PB_EventType_MouseLeave
            CompilerEndIf
          Else
            MouseLeave =- 1
            Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
            EventType = #PB_EventType_LeftClick
          EndIf
          
        Case #PB_EventType_LeftClick : ProcedureReturn 0
      EndSelect
    CompilerEndIf
    
    Result | Canvas_Events(EventGadget, EventType)
    
    ProcedureReturn Result
  EndProcedure
  
  ;- PUBLIC
  Procedure SetAttribute(Gadget.i, Attribute.i, Value.i)
    Protected *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      Select Attribute
        Case #PB_ProgressBar_Minimum : Attribute = Bar::#PB_Bar_Minimum
        Case #PB_ProgressBar_Maximum : Attribute = Bar::#PB_Bar_Maximum
      EndSelect
      
      If Bar::SetAttribute(*This\Bar, Attribute, Value)
        Draw(*This)
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetAttribute(Gadget.i, Attribute.i)
    Protected Result, *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      Select Attribute
        Case #PB_ProgressBar_Minimum : Attribute = Bar::#PB_Bar_Minimum
        Case #PB_ProgressBar_Maximum : Attribute = Bar::#PB_Bar_Maximum
      EndSelect
      
      Result = Bar::GetAttribute(*This\Bar, Attribute)
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetState(Gadget.i, State.i)
    Protected *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      If Bar::SetState(*This\Bar, State)
        If \Bar\Change 
          PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change) 
        EndIf
        
        Draw(*This)
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetState(Gadget.i)
    Protected *This.Gadget = GetGadgetData(Gadget)
    ProcedureReturn Bar::GetState(*This\Bar)
  EndProcedure
  
  Procedure Gadget(Gadget, X.i, Y.i, Width.i, Height.i, Min.i, Max.i, Flag.i=0)
    Protected *This.Gadget=AllocateStructure(Gadget)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    
    If *This
      With *This
        \Canvas\Gadget = Gadget
        \Bar = Bar::Progress(0,0, Width, Height, Min, Max, Flag)
;         \Bar\Color[3]\Fore[0] = 0
;         \Bar\Color[3]\Fore[2] = 0
        
        Draw(*This)
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @Canvas_CallBack())
      EndIf
    EndWith
    
    ProcedureReturn Gadget
  EndProcedure
EndModule


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  Procedure v_GadgetCallBack()
    SetWindowTitle(EventWindow(), Str(GetGadgetState(EventGadget())))
    ProgressBar::SetState(12, GetGadgetState(EventGadget()))
  EndProcedure
  
  Procedure v_CallBack()
    SetWindowTitle(EventWindow(), Str(ProgressBar::GetState(EventGadget())))
    SetGadgetState(2, ProgressBar::GetState(EventGadget()))
  EndProcedure
  
  Procedure h_GadgetCallBack()
    ProgressBar::SetState(11, GetGadgetState(EventGadget()))
  EndProcedure
  
  Procedure h_CallBack()
    SetGadgetState(1, ProgressBar::GetState(EventGadget()))
  EndProcedure
  
  If OpenWindow(0, 0, 0, 605, 200, "ProgressBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    TextGadget    (-1, 10,  20, 250, 20,"ProgressBar Standard  (50/100)", #PB_Text_Center)
    ProgressBarGadget(0, 10,  40, 250, 33, 0, 100)
    SetGadgetState(0, 50)
    TextGadget    (-1, 10, 100, 250, 20, "ProgressBar Smooth  (50/200)", #PB_Text_Center)
    ProgressBarGadget(1, 10, 120, 250, 20, 0, 200, #PB_ProgressBar_Smooth)
    SetGadgetState(1, 50)
    TextGadget    (-1,  50, 180, 240, 20, "ProgressBar Vertical  (100/300)", #PB_Text_Right)
    ProgressBarGadget(2, 270, 10, 20, 170, 0, 300, #PB_ProgressBar_Vertical)
    SetGadgetState(2, 100)
    
    TextGadget    (-1, 300+10,  20, 250, 20,"ProgressBar Standard  (50/100)", #PB_Text_Center)
    ProgressBar::Gadget(10, 300+10,  40, 250, 33, 0, 100)
    ProgressBar::SetState(10, 50)
    ;ProgressBar::SetState(10, 100)
    TextGadget    (-1, 300+10, 100, 250, 20, "ProgressBar Smooth  (50/200)", #PB_Text_Center)
    ProgressBar::Gadget(11, 300+10, 120, 250, 20, 0, 200, #PB_ProgressBar_Smooth)
    ProgressBar::SetState(11, 50)
    TextGadget    (-1,  300+50, 180, 240, 20, "ProgressBar Vertical  (100/300)", #PB_Text_Right)
    ProgressBar::Gadget(12, 300+270, 10, 20, 170, 0, 300, #PB_ProgressBar_Vertical)
    ProgressBar::SetState(12, 100)
    
    BindGadgetEvent(1,@h_GadgetCallBack())
    BindGadgetEvent(11,@h_CallBack(), #PB_EventType_Change)
    BindGadgetEvent(2,@v_GadgetCallBack())
    BindGadgetEvent(12,@v_CallBack(), #PB_EventType_Change)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -f-----
; EnableXP