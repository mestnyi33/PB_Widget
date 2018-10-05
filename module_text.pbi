﻿CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
CompilerEndIf

;-
DeclareModule Text
  
  EnableExplicit
  UseModule Constants
  UseModule Structures
  
  ;- DECLAREs
  Declare.i Draw(*This.Widget)
  Declare.s GetText(*This.Widget)
  Declare.i SetText(*This.Widget, Text.s)
  Declare.i SetFont(*This.Widget, FontID.i)
  Declare.i GetColor(*This.Widget, ColorType.i)
  Declare.i SetColor(*This.Widget, ColorType.i, Color.i)
  Declare.i Resize(*This.Widget, X.i,Y.i,Width.i,Height.i)
  ;Declare.i CallBack(*This.Widget, EventType.i, MouseX.i, MouseY.i)
  Declare.i Widget(*This.Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.s Wrap (Text.s, Width.i, Mode=-1, DelimList$=" "+Chr(9), nl$=#LF$)
  
EndDeclareModule

Module Text
  
  ;- MACROS
  Macro BoxGradient(_type_, _x_,_y_,_width_,_height_,_color_1_,_color_2_, _radius_=0, _alpha_=255)
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
  
  ;- PROCEDUREs
  Procedure.s Wrap (Text.s, Width.i, Mode=-1, DelimList$=" "+Chr(9), nl$=#LF$)
    Protected line$, ret$="", LineRet$=""
    Protected.i CountString, i, start, ii, found, length
    
    Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
    Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
    Text.s = ReplaceString(Text.s, #CR$, #LF$)
    Text.s + #LF$
    
    CountString = CountString(Text.s, #LF$) 
    
    For i = 1 To CountString
      line$ = StringField(Text.s, i, #LF$)
      start = Len(line$)
      length = start
      
      ; Get text len
      While length > 1
        If width > TextWidth(RTrim(Left(line$, length)))
          Break
        Else
          length - 1 
        EndIf
      Wend
      
      While start > length 
        For ii = length To 0 Step - 1
          If mode =- 1 And CountString(Left((line$),ii), " ") > 1      And width > 71 ; button
            found + FindString(delimList$, Mid(RTrim(line$),ii,1))
            If found <> 2
              Continue
            EndIf
          Else
            found = FindString(delimList$, Mid(line$,ii,1))
          EndIf
          
          If found
            start = ii
            Break
          EndIf
        Next
        
        If found
          found = 0
        Else
          start = length
        EndIf
        
        LineRet$ + Left(line$, start) + nl$
        line$ = LTrim(Mid(line$, start+1))
        start = Len(line$)
        length = start
        
        ; Get text len
        While length > 1
          If width > TextWidth(RTrim(Left(line$, length)))
            Break
          Else
            length - 1 
          EndIf
        Wend
      Wend
      
      ret$ +  LineRet$ + line$ + nl$
      LineRet$=""
    Next
    
    ProcedureReturn ret$ ; ReplaceString(ret$, " ", "*")
  EndProcedure
  
  Procedure _Draw(*This.Widget)
    Protected String.s, String1.s, String2.s, String3.s, String4.s, StringWidth, CountString
    Protected IT,Text_Y,Text_X,TxtHeight,Width,Height
    
    If *This
      With *This
        If \FontID : DrawingFont(\FontID) : EndIf
        Box(\X[1],\Y[1],\Width[1],\Height[1],\Color\Back)
        
        If \Text\String.s
          If \Text\Change
            \Text\Height = TextHeight("A")
            \Text\Width = TextWidth(\Text\String.s)
            \Text\Change = 0
          EndIf
          
          TxtHeight=\Text\Height
          Width = \Width[2]
          Height = \Height[2]
          
          
          If \Text\MultiLine
            String.s = Wrap(\Text\String.s, \Width[2]-\Text\X*2) 
            CountString = CountString(String, #LF$)
          ElseIf \Text\WordWrap
            String.s = Wrap(\Text\String.s, \Width[2]-\Text\X*2, 1) 
            CountString = CountString(String, #LF$)
          Else
            String.s = \Text\String.s
            CountString = 1
          EndIf
          
          If CountString
            If Bool((\Text\Align & #PB_Text_Bottom) = #PB_Text_Bottom) 
              Text_Y=(Height-(TxtHeight * CountString)-Text_Y) 
            ElseIf Bool((\Text\Align & #PB_Text_Middle) = #PB_Text_Middle) 
              Text_Y=((Height-(TxtHeight * CountString))/2) 
            EndIf
            
            For IT = 1 To CountString
              If \Text\Y+Text_Y < \bSize : Text_Y+TxtHeight : Continue : EndIf
              
              String4 = StringField(String, IT, #LF$)
              StringWidth = TextWidth(RTrim(String4))
              
              If Bool((\Text\Align & #PB_Text_Right) = #PB_Text_Right) 
                Text_X=(Width-StringWidth-\Text\X) 
              ElseIf Bool((\Text\Align & #PB_Text_Center) = #PB_Text_Center) 
                Text_X=(Width-StringWidth)/2 
              EndIf
              
              ; If Text_X<\Text\X : Text_X=\Text\X : EndIf
              
              ;               DrawingMode(#PB_2DDrawing_Transparent)
              ;               DrawText(\X[1]+Text_X, \Y[1]+Text_Y, String4.s, \Color\Front)
              DrawingMode(#PB_2DDrawing_Transparent)
              If \Vertical
                DrawRotatedText(\X[1]+\Text\Y+Text_Y+\Text\Height, \Y[1]+\Text\X+Text_X, String4.s, 270, \Color\Front)
                Text_Y+TxtHeight : If Text_Y > (Width) : Break : EndIf
              Else
                DrawText(\X[1]+Text_X, \Y[1]+Text_Y, String4.s, \Color\Front)
                Text_Y+TxtHeight : If Text_Y > (Height-TxtHeight) : Break : EndIf
              EndIf
              
              ; Text_Y+TxtHeight : If Text_Y > (Height-TxtHeight) : Break : EndIf
            Next
          EndIf
          
          
          
          ; Debug ElapsedMilliseconds()-time
          
          
        EndIf
        
        
        DrawingMode(#PB_2DDrawing_Default)
        Box(\X[1],\Y[1],\Width[1]-\Text\X,\Text\Y,\Color\Back)
        Box(\X[1]+\Width[1]-\Text\X,\Y[1],\Text\X,\Height[1]-\Text\Y,\Color\Back)
        Box(\X[1]+\Text\X,\Y[1]+\Height[1]-\Text\Y,\Width[1]-\Text\X,\Text\Y,\Color\Back)
        Box(\X[1],\Y[1]+\Text\Y,\Text\X,\Height[1]-\Text\Y,\Color\Back)
        
        If \fSize
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\X[1],\Y[1],\Width[1],\Height[1],\Color\Frame)
        EndIf
        
      EndWith  
    EndIf
    
  EndProcedure
  
  Procedure.i Draw(*This.Widget)
    Protected String.s, String1.s, String2.s, String3.s, String4.s, StringWidth, CountString
    Protected IT,Text_Y,Text_X,TxtHeight,Width,Height
    
    With *This
      If Not \Hide
        If \FontID : DrawingFont(\FontID) : EndIf
        DrawingMode(\DrawingMode)
        BoxGradient(\Vertical,\X[1],\Y[1],\Width[1],\Height[1],\Color[1]\Fore,\Color[1]\Back)
        
        
        If \Text\String.s
          If \Text\Change
            \Text\Height = TextHeight("A")
            \Text\Width = TextWidth(\Text\String.s)
            \Text\Change = 0
          EndIf
          
          TxtHeight=\Text\Height
          
          If \Vertical
            Width = \Height[1]-\Text\X*2
            Height = \Width[1]-\Text\y*2
          Else
            Width = \Width[1]-\Text\X*2
            Height = \Height[1]-\Text\y*2
          EndIf
          
          If \Text\MultiLine
            String.s = Text::Wrap(\Text\String.s, Width)
            CountString = CountString(String, #LF$)
          ElseIf \Text\WordWrap
            String.s = Text::Wrap(\Text\String.s, Width, 0)
            CountString = CountString(String, #LF$)
          Else
            String.s = \Text\String.s
            CountString = 1
          EndIf
          
          If CountString
            If Bool((\Text\Align & #PB_Text_Bottom) = #PB_Text_Bottom) 
              Text_Y=(Height-(\Text\Height*CountString)-Text_Y) 
            ElseIf Bool((\Text\Align & #PB_Text_Middle) = #PB_Text_Middle) 
              Text_Y=((Height-(\Text\Height*CountString))/2)
            EndIf
            
            
            For IT = 1 To CountString
              If \Text\Y+Text_Y < \bSize : Text_Y+TxtHeight : Continue : EndIf
              
              String4 = StringField(String, IT, #LF$)
              StringWidth = TextWidth(RTrim(String4))
              
              If Bool((\Text\Align & #PB_Text_Right) = #PB_Text_Right) 
                Text_X=(Width-StringWidth-\Text\X) 
              ElseIf Bool((\Text\Align & #PB_Text_Center) = #PB_Text_Center) 
                Text_X=(Width-StringWidth)/2 
              EndIf
              
              
              ;               DrawingMode(#PB_2DDrawing_Outlined)
              ;               Box(\X[1],Text_Y,\Width[1],\Text\Height,0)
              
              DrawingMode(#PB_2DDrawing_Transparent)
              If \Vertical
                DrawRotatedText(\X[1]+\Text\Y+Text_Y+\Text\Height, \Y[1]+\Text\X+Text_X, String4.s, 270, \Color\Front)
                Text_Y+TxtHeight : If Text_Y > (Width) : Break : EndIf
              Else
                DrawText(\X[1]+\Text\X+Text_X, \Y[1]+\Text\Y+Text_Y, String4.s, \Color\Front)
                Text_Y+TxtHeight : If Text_Y > (Height-TxtHeight) : Break : EndIf
              EndIf
              
            Next
          EndIf
          
        EndIf
        
        
        ;         DrawingMode(\DrawingMode)
        ;         If \Width > \Text\X
        ;           BoxGradient(\Vertical,\X[1],\Y[1]+\Text\Y,\Text\X,\Height[1]-\Text\Y,\Color[1]\Fore,\Color[1]\Back)
        ;           BoxGradient(\Vertical,\X[1]+\Width[1]-\Text\X,\Y[1],\Text\X,\Height[1]-\Text\Y,\Color[1]\Fore,\Color[1]\Back)
        ;         EndIf
        ;         If \Height > \Text\Y
        ;           BoxGradient(\Vertical,\X[1],\Y[1],\Width[1]-\Text\X,\Text\Y,\Color[1]\Fore,\Color[1]\Back)
        ;           BoxGradient(\Vertical,\X[1]+\Text\X,\Y[1]+\Height[1]-\Text\Y,\Width[1]-\Text\X,\Text\Y,\Color[1]\Fore,\Color[1]\Back)
        ;         EndIf
        ;       
        If \fSize
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(\X[1],\Y[1],\Width[1],\Height[1],\Color\Frame)
        EndIf
        
      EndIf
    EndWith 
    
  EndProcedure
  
  Procedure.s GetText(*This.Widget)
    ProcedureReturn *This\Text\String.s
  EndProcedure
  
  Procedure.i SetText(*This.Widget, Text.s)
    Protected Result
    
    If *This\Text\String.s <> Text.s
      *This\Text\String.s = Text.s
      *This\Text\Change = #True
      Result = #True
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetFont(*This.Widget, FontID.i)
    Protected Result
    
    If *This\FontID <> FontID
      *This\FontID = FontID
      Result = #True
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetColor(*This.Widget, ColorType.i, Color.i)
    Protected Result
    
    With *This
      Select ColorType
        Case #PB_Gadget_LineColor
          If \Color\Line <> Color 
            \Color\Line = Color
            Result = #True
          EndIf
          
        Case #PB_Gadget_BackColor
          If \Color[1]\Back <> Color 
            \Color[1]\Back = Color
            Result = #True
          EndIf
          
        Case #PB_Gadget_FrontColor
          If \Color\Front <> Color 
            \Color\Front = Color
            Result = #True
          EndIf
          
        Case #PB_Gadget_FrameColor
          If \Color\Frame <> Color 
            \Color\Frame = Color
            Result = #True
          EndIf
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetColor(*This.Widget, ColorType.i)
    Protected Color.i
    
    With *This
      Select ColorType
        Case #PB_Gadget_LineColor  : Color = \Color\Line
        Case #PB_Gadget_BackColor  : Color = \Color\Back
        Case #PB_Gadget_FrontColor : Color = \Color\Front
        Case #PB_Gadget_FrameColor : Color = \Color\Frame
      EndSelect
    EndWith
    
    ProcedureReturn Color
  EndProcedure
  
  Procedure.i Resize(*This.Widget, X.i,Y.i,Width.i,Height.i)
    Protected Result
    
    With *This
      If X<>#PB_Ignore 
        \X[0] = X 
        \X[2]=X+\bSize
        \X[1]=\X[2]-\fSize
        Result = 1
      EndIf
      If Y<>#PB_Ignore 
        \Y[0] = Y
        \Y[2]=Y+\bSize
        \Y[1]=\Y[2]-\fSize
        Result = 2
      EndIf
      If Width<>#PB_Ignore 
        \Width[0] = Width 
        \Width[2] = \Width-\bSize*2
        \Width[1] = \Width[2]+\fSize*2
        Result = 3
      EndIf
      If Height<>#PB_Ignore 
        \Height[0] = Height 
        \Height[2] = \Height-\bSize*2
        \Height[1] = \Height[2]+\fSize*2
        Result = 4
      EndIf
      
      ProcedureReturn Result
    EndWith
  EndProcedure
  
  Procedure.i CallBack(*This.Widget, EventType.i, MouseX.i, MouseY.i)
    Protected Result
    
    With *This
      
      ProcedureReturn Result
    EndWith
  EndProcedure
  
  Procedure Widget(*This.Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Text
        \fSize = Bool(Flag&#PB_Text_Border)
        \bSize = \fSize
        
        If Resize(*This, X,Y,Width,Height)
          \Color[1]\Frame = $C0C0C0
          \Color[1]\Back = $F0F0F0
          
          \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
          \Text\WordWrap = Bool(Flag&#PB_Text_WordWrap)
          If Not \Text\WordWrap
            \Text\MultiLine = 1;Bool(Flag&#PB_Text_MultiLine)
          EndIf
          
          If \Vertical
            \Text\X = \fSize 
            \Text\y = \fSize+4 ; 2,6,1
          Else
            \Text\X = \fSize+4 ; 2,6,12 
            \Text\y = \fSize
          EndIf
          
          If Bool(Flag&#PB_Text_Center) : \Text\Align | #PB_Text_Center : EndIf
          If Bool(Flag&#PB_Text_Middle) : \Text\Align | #PB_Text_Middle : EndIf
          If Bool(Flag&#PB_Text_Right)  : \Text\Align | #PB_Text_Right : EndIf
          If Bool(Flag&#PB_Text_Bottom) : \Text\Align | #PB_Text_Bottom : EndIf
          
          \Text\String.s = Text.s
          \Text\Change = #True
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn *This
  EndProcedure
EndModule


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  UseModule Text
  Global *Text.Widget = AllocateStructure(Widget)
  
  Procedure Canvas_CallBack()
    Select EventType()
      Case #PB_EventType_Resize
        If Resize(*Text, #PB_Ignore, #PB_Ignore, GadgetWidth(EventGadget()), #PB_Ignore)
          If StartDrawing(CanvasOutput(EventGadget()))
            Draw(*Text)
            StopDrawing()
          EndIf
        EndIf
        
    EndSelect
  EndProcedure
  
  
  Procedure ResizeCallBack()
    ResizeGadget(0, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, #PB_Ignore)
    ResizeGadget(16, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, #PB_Ignore)
    SetWindowTitle(0, Str(WindowWidth(EventWindow(), #PB_Window_FrameCoordinate)-20)+" - Text on the canvas")
  EndProcedure
  
  Define cr.s = #LF$
  LoadFont(0, "Courier", 14)
  Text.s = "Vertical & Horizontal" + cr + "   Centered   Text in   " + cr + "Multiline StringGadget"
  ; Debug "len - "+Len(Text)
  
  If OpenWindow(0, 0, 0, 104, 690, "Text on the canvas", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ;EditorGadget(0, 10, 10, 380, 330, #PB_Editor_WordWrap) : SetGadgetText(0, Text.s)
    TextGadget(0, 10, 10, 380, 330, Text.s, #PB_Text_Center) 
    ;ButtonGadget(0, 10, 10, 380, 330, Text.s) 
    SetGadgetColor(0, #PB_Gadget_BackColor, $CCBFB4)
    SetGadgetColor(0, #PB_Gadget_FrontColor, $D57A2E)
    SetGadgetFont(0,FontID(0) )
    
    g=16
    CanvasGadget(g, 10, 350, 380, 330) 
    
    *Text\Canvas\Gadget = g
    *Text\Type = #PB_GadgetType_Text
    *Text\FontID = GetGadgetFont(#PB_Default)
    
    Widget(*Text,0, 0, 380, 330, Text.s, #PB_Text_Center);|#PB_Text_Middle );| #PB_Text_WordWrap);
    SetColor(*Text, #PB_Gadget_BackColor, $CCBFB4)
    SetColor(*Text, #PB_Gadget_FrontColor, $D56F1A)
    SetFont(*Text, FontID(0))
    
    SetGadgetData(g, *Text)
    BindGadgetEvent(g, @Canvas_CallBack())
    ;Draw(*This)
    
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore)
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; CursorPosition = 502
; FirstLine = 483
; Folding = -------------
; EnableXP