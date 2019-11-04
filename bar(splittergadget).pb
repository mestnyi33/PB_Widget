﻿; IncludePath "/Users/as/Documents/GitHub/Widget/"
XIncludeFile "bar().pbi"

; Module name   : Splitter
; Author        : mestnyi
; Last updated  : Sep 20, 2018
; Forum link    : https://www.purebasic.fr/english/viewtopic.php?f=12&t=70662
; 

DeclareModule Splitter
  EnableExplicit
  
  ;- STRUCTURE
  Structure Canvas
    Gadget.i
    Window.i
  EndStructure
  
  Structure Gadget ;Extends Bar::COORDINATE
    x.i[4]
    y.i[4]
    width.i[4]
    height.i[4]
    
    Type.i
    fSize.i
    bSize.i
    
    Canvas.Canvas
    Color.Bar::_S_color
    *widget.Bar::_S_widget
  EndStructure
  
  
  ;- DECLARE
  Declare GetState(Gadget.i)
  Declare SetState(Gadget.i, State.i)
  Declare GetAttribute(Gadget.i, Attribute.i)
  Declare SetAttribute(Gadget.i, Attribute.i, Value.i)
  Declare Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, First.i, Second.i, Flag.i=0)
  
EndDeclareModule

Module Splitter
  
  ;- PROCEDURE
  
  Procedure ReDraw(*This.Gadget)
    With *This
      If StartDrawing(CanvasOutput(\Canvas\Gadget))
        FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $F0)
        
        Bar::Draw(\widget)
        StopDrawing()
      EndIf
    EndWith  
  EndProcedure
  
  Procedure CallBack()
    Protected WheelDelta.i, Mouse_X.i, Mouse_Y.i, *This.Gadget = GetGadgetData(EventGadget())
    
    With *This
      \Canvas\Window = EventWindow()
      Mouse_X = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseX)
      Mouse_Y = GetGadgetAttribute(\Canvas\Gadget, #PB_Canvas_MouseY)
      
      Select EventType()
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          \Width = GadgetWidth(\Canvas\Gadget)
          \Height = GadgetHeight(\Canvas\Gadget)
          
          ; Inner coordinae
          If \widget\bar\Vertical
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
          
          Bar::Resize(\widget, \X[2], \Y[2], \Width[2], \Height[2]) 
          ReDraw(*This)
      EndSelect
      
      If Bar::CallBack(\widget, EventType(), Mouse_X, Mouse_Y)
        ReDraw(*This)
      EndIf
    EndWith
    
  EndProcedure
  
  ;- PUBLIC
  Procedure SetAttribute(Gadget.i, Attribute.i, Value.i)
    Protected *This.Gadget = GetGadgetData(Gadget)
    
    With *This
;       Select Attribute
;         Case #PB_Splitter_FirstGadget : Attribute = Bar::#PB_Bar_First
;         Case #PB_Splitter_SecondGadget : Attribute = Bar::#PB_Bar_Second
;         Case #PB_Splitter_FirstMinimumSize : Attribute = Bar::#PB_Bar_FirstMinimumSize
;         Case #PB_Splitter_SecondMinimumSize : Attribute = Bar::#PB_Bar_SecondMinimumSize
;       EndSelect
      
      If Bar::SetAttribute(*This\widget, Attribute, Value)
        ReDraw(*This)
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetAttribute(Gadget.i, Attribute.i)
    Protected Result, *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      Select Attribute
        Case #PB_Splitter_FirstGadget    : Result = \widget\splitter\first
        Case #PB_Splitter_SecondGadget   : Result = \widget\splitter\second
        Case #PB_Splitter_FirstMinimumSize    : Result = \widget\bar\button[Bar::#bb_1]\len
        Case #PB_Splitter_SecondMinimumSize   : Result = \widget\bar\button[Bar::#bb_2]\len
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetState(Gadget.i, State.i)
    Protected *This.Gadget = GetGadgetData(Gadget)
    
    With *This
      If Bar::SetState(*This\widget, State) : ReDraw(*This)
        PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Change)
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetState(Gadget.i)
    Protected *This.Gadget = GetGadgetData(Gadget)
    ProcedureReturn *This\widget\bar\Page\Pos
  EndProcedure
  
  Procedure Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, First.i, Second.i, Flag.i=0)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard|#PB_Canvas_Container) : CloseGadgetList() : If Gadget=-1 : Gadget=g : EndIf
    Protected *This.Gadget = AllocateStructure(Gadget)
    
    ;CocoaMessage(0,GadgetID(Gadget), "setParent", GadgetID(Gadget_1)); NSWindowAbove = 1
    CompilerIf #PB_Compiler_OS = #PB_OS_Linux
      gtk_widget_reparent_( GadgetID(First), GadgetID(Gadget) )
      gtk_widget_reparent_( GadgetID(Second), GadgetID(Gadget) )
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
      SetParent_( GadgetID(First), GadgetID(Gadget) )
      SetParent_( GadgetID(Second), GadgetID(Gadget) )
    CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
      CocoaMessage (0, GadgetID (Gadget), "addSubview:", GadgetID (First)) 
      CocoaMessage (0, GadgetID (Gadget), "addSubview:", GadgetID (Second)) 
      
;       Protected Point.NSPoint
;       Point\x = 100
;       Point\y = 100
;       CocoaMessage (0, WindowID (0), "center")
;       CocoaMessage (0, WindowID (0), "setFrameTopLeftPoint:@", @Point) ; Установить верхнюю левую координату окна
;       CocoaMessage (0, WindowID (0), "setFrameOrigin:@", @Point) ; Установить нижнюю левую координату окна
    CompilerEndIf
    
    If *This
      With *This
        \Type = #PB_GadgetType_Splitter
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
        
        \widget = Bar::Splitter(\X[2], \Y[2], \Width[2], \Height[2], First, Second, Flag)
        
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @CallBack())
        ReDraw(*This)
      EndIf
    EndWith
    
    ProcedureReturn Gadget
  EndProcedure
EndModule


CompilerIf #PB_Compiler_IsMainFile
UseModule Bar
  Global g_Canvas, NewList *List._S_bar()
  
  
  Procedure ReDraw(Canvas)
    If StartDrawing(CanvasOutput(Canvas))
      FillMemory( DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $F0)
      
      ForEach *List()
        If Not *List()\hide
          Draw(*List())
        EndIf
      Next
      
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
    ;     Protected *this._S_bar = GetGadgetData(Canvas)
    
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
    Next
    
    If Repaint 
      ReDraw(Canvas)
    EndIf
  EndProcedure
  
  Global Button_0, Button_1, Button_2, Button_3, Button_4, Button_5, Splitter_0, Splitter_1, Splitter_2, Splitter_3, Splitter_4
  
  If OpenWindow(0, 0, 0, 850, 280, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
    Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
    
    Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
    Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
    Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
    Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically
    
    Splitter_0 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    Splitter_1 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
;         SetGadgetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
;         SetGadgetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
    Splitter_2 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Splitter_1, Button_5, #PB_Splitter_Separator)
    Splitter_3 = SplitterGadget(#PB_Any, 0, 0, 0, 0, Button_2, Splitter_2, #PB_Splitter_Separator)
    Splitter_4 = SplitterGadget(#PB_Any, 10, 10, 410, 210, Splitter_0, Splitter_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
      ;   SetGadgetState(Splitter_1, 20)
    
    TextGadget(#PB_Any, 110, 235, 210, 40, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )
   
    Button_0 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 0") ; as they will be sized automatically
    Button_1 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 1") ; as they will be sized automatically
    
    Button_2 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 2") ; No need to specify size or coordinates
    Button_3 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 3") ; as they will be sized automatically
    Button_4 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 4") ; No need to specify size or coordinates
    Button_5 = ButtonGadget(#PB_Any, 0, 0, 0, 0, "Button 5") ; as they will be sized automatically
    
    Splitter_0 = Splitter::Gadget(#PB_Any, 0, 0, 0, 0, Button_0, Button_1, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_FirstFixed)
    Splitter_1 = Splitter::Gadget(#PB_Any, 0, 0, 0, 0, Button_3, Button_4, #PB_Splitter_Vertical|#PB_Splitter_Separator|#PB_Splitter_SecondFixed)
;         Splitter::SetAttribute(Splitter_1, #PB_Splitter_FirstMinimumSize, 40)
;         Splitter::SetAttribute(Splitter_1, #PB_Splitter_SecondMinimumSize, 40)
    Splitter_2 = Splitter::Gadget(#PB_Any, 0, 0, 0, 0, Splitter_1, Button_5, #PB_Splitter_Separator)
    Splitter_3 = Splitter::Gadget(#PB_Any, 0, 0, 0, 0, Button_2, Splitter_2, #PB_Splitter_Separator)
    Splitter_4 = Splitter::Gadget(#PB_Any, 430, 10, 410, 210, Splitter_0, Splitter_3, #PB_Splitter_Vertical|#PB_Splitter_Separator)
       ;  Splitter::SetState(Splitter_1, 20)
    
    TextGadget(#PB_Any, 530, 235, 210, 40, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf

CompilerEndIf
; ;- EXAMPLE
; CompilerIf #PB_Compiler_IsMainFile
;   Procedure v_GadgetCallBack()
;     Splitter::SetState(13, GetGadgetState(EventGadget()))
;   EndProcedure
;   
;   Procedure v_CallBack()
;     SetGadgetState(3, Splitter::GetState(EventGadget()))
;   EndProcedure
;   
;   Procedure h_GadgetCallBack()
;     Splitter::SetState(12, GetGadgetState(EventGadget()))
;   EndProcedure
;   
;   Procedure h_CallBack()
;     SetGadgetState(2, Splitter::GetState(EventGadget()))
;   EndProcedure
;   
;   
;   If OpenWindow(0, 0, 0, 460, 180, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
;     #Button1  = 0
;     #Button2  = 1
;     #Splitter = 2
;     
;     ButtonGadget(#Button1, 0, 0, 0, 0, "Button 1") ; No need to specify size or coordinates
;     ButtonGadget(#Button2, 0, 0, 0, 0, "Button 2") ; as they will be sized automatically
;     SplitterGadget(#Splitter, 5, 5, 220, 120, #Button1, #Button2, #PB_Splitter_Separator)
;     
;     SetGadgetAttribute(#Splitter, #PB_Splitter_FirstMinimumSize, 20)
;     SetGadgetAttribute(#Splitter, #PB_Splitter_SecondMinimumSize, 20)
;     
;     TextGadget(33, 10, 135, 210, 40, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )
;     
;     #Button3  = 3
;     #Button4  = 4
;     #Splitter1 = 6
;     
;     ButtonGadget(#Button3, 0, 0, 0, 0, "Button 1") ; No need to specify size or coordinates
;     ButtonGadget(#Button4, 0, 0, 0, 0, "Button 2") ; as they will be sized automatically
;     Splitter::Gadget(#Splitter1, 235, 5, 220, 120, #Button3, #Button4, #PB_Splitter_Separator)
;     
;     Splitter::SetAttribute(#Splitter1, #PB_Splitter_FirstMinimumSize, 20)
;     Splitter::SetAttribute(#Splitter1, #PB_Splitter_SecondMinimumSize, 20)
;     
;     TextGadget(30, 10, 135, 210, 40, "Above GUI part shows two automatically resizing buttons inside the 220x120 SplitterGadget area.",#PB_Text_Center )
;     
;     
;     Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
;   EndIf
; CompilerEndIf
; IDE Options = PureBasic 5.62 (Windows - x86)
; Folding = ------
; EnableXP