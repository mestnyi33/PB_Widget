﻿CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElse
  IncludePath "../../"
CompilerEndIf

XIncludeFile "module_macros.pbi"
XIncludeFile "module_constants.pbi"
XIncludeFile "module_structures.pbi"
XIncludeFile "module_scroll.pbi"

EnableExplicit
UsePNGImageDecoder()

Structure items
  type.l
  index.l
  
  atPoint.i
  
  text.s
  x.i
  y.i
  width.i
  height.i
  Color.l
  Color1.l
  Color2.l
  
EndStructure

Structure canvasitem
  img.i
  x.i
  y.i
  width.i
  height.i
  alphatest.i
  
  List Items.items()
  
EndStructure

;- STRUCTURE
Structure Coordinate
  y.l[3]
  x.l[3]
  Height.l[3]
  Width.l[3]
EndStructure

Structure Mouse
  X.l
  Y.l
  Buttons.l
EndStructure

Structure Canvas
  Mouse.Mouse
  Gadget.l[3]
  Window.l
  
  Input.c
  Key.l[2]
  
EndStructure

Structure Gadget Extends Coordinate
  FontID.l
  Canvas.Canvas
  
  Pos.l[2] ; 0 = Pos ; 1 = PosFixed
  CaretPos.l[2] ; 0 = Pos ; 1 = PosFixed
  CaretLength.l
  
  ImageID.l[3]
  Color.l[3]
  
  Image.Coordinate
  
  fSize.l
  bSize.l
  Hide.b[2]
  Disable.b[2]
  
  Scroll.Coordinate
  vScroll.Scroll_S
  hScroll.Scroll_S
  
  Type.l
  InnerCoordinate.Coordinate
  
  Repaint.l
  
  List Items.Gadget()
  List Columns.Gadget()
EndStructure

Enumeration
  #MyCanvas = 1   ; just to test whether a number different from 0 works now
EndEnumeration

Global *v.Scroll_S=AllocateStructure(Scroll_S)
Global *h.Scroll_S=AllocateStructure(Scroll_S)

Global isCurrentItem=#False
Global currentItemXOffset.i, currentItemYOffset.i
Global Event.i, x.i, y.i, drag.i, hole.i, Width, Height
Global NewList ilements.canvasitem()

Procedure Addilement (List ilements.canvasitem(), x, y, img, alphatest=0)
  If AddElement(ilements())
    ilements()\img    = img
    ilements()\x      = x
    ilements()\y      = y
    ilements()\width  = ImageWidth(img)
    ilements()\height = ImageHeight(img)
    ilements()\alphatest = alphatest
  EndIf
EndProcedure

Procedure AddItem(Gadget, Item,Text.s,Image.l=-1,Flag.l=0)
  ;Protected *This.Gadget = GetGadgetData(Gadget)
  
  AddElement(ilements()\Items())
  With ilements()\Items()
    \type = Item ; Val(Text.s)
    \width = 8
    \text.s = Text.s
    
    If \type = 2
      \Color = $A1A9F6
      \Color1 = $FFFFFF
      \Color2 = $A1A9F6
    ElseIf \type = 0 
      \Color = $F6C9A1
      \Color1 = $FFFFFF
      \Color2 = $F6C9A1
    EndIf
  EndWith

  
  ProcedureReturn Item
EndProcedure

Procedure Draw (canvas.i, List ilements.canvasitem())
  Protected iWidth = Scroll::X(*v), iHeight = Scroll::Y(*h)
  
  If StartDrawing(CanvasOutput(canvas))
    
    ClipOutput(0,0, iWidth, iHeight)
    
    DrawingMode(#PB_2DDrawing_Default)
    Box(0, 0, iWidth, iHeight, RGB(255,255,255))
    
    ForEach ilements()
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      DrawImage(ImageID(ilements()\img),ilements()\x - *h\Page\Pos,ilements()\y - *v\Page\Pos) ; draw all images with z-order
      
      ForEach ilements()\Items()
        
        If ilements()\Items()\type = 0
          ilements()\Items()\x = ilements()\x
          ilements()\Items()\y = ilements()\y+8+(ListIndex(ilements()\Items())*10)
          
          DrawingMode(#PB_2DDrawing_Default)
          Circle(ilements()\Items()\x, ilements()\Items()\y, ilements()\Items()\width/2, ilements()\Items()\Color2)
          
          DrawingMode(#PB_2DDrawing_Outlined)
          Circle(ilements()\Items()\x, ilements()\Items()\y, ilements()\Items()\width/2, ilements()\Items()\Color1)
        ElseIf ilements()\Items()\type = 2
          ilements()\Items()\x = ilements()\x+ilements()\width
          ilements()\Items()\y = ilements()\y+8+(ListIndex(ilements()\Items())*10)
          
          DrawingMode(#PB_2DDrawing_Default)
          Circle(ilements()\Items()\x, ilements()\Items()\y, ilements()\Items()\width/2, ilements()\Items()\Color2)
          
          DrawingMode(#PB_2DDrawing_Outlined)
          Circle(ilements()\Items()\x, ilements()\Items()\y, ilements()\Items()\width/2, ilements()\Items()\Color1)
        EndIf
        
      Next
    Next
    
    UnclipOutput()
    
    Scroll::Draw(*v)
    Scroll::Draw(*h)
    
    StopDrawing()
  EndIf
EndProcedure

Procedure.i HitTest (List ilements.canvasitem(), x, y)
  Shared currentItemXOffset.i, currentItemYOffset.i
  Protected alpha.i, isCurrentItem.i = #False
  
  If LastElement(ilements()) ; search for hit, starting from end (z-order)
    Repeat
      If x >= ilements()\x - *h\Page\Pos And x < ilements()\x - *h\Page\Pos + ilements()\width
        If y >= ilements()\y - *v\Page\Pos And y < ilements()\y - *v\Page\Pos + ilements()\height
          alpha = 255
          
          If ilements()\alphatest And ImageDepth(ilements()\img)>31
            If StartDrawing(ImageOutput(ilements()\img))
              DrawingMode(#PB_2DDrawing_AlphaChannel)
              alpha = Alpha(Point(x-ilements()\x, y-ilements()\y)) ; get alpha
              StopDrawing()
            EndIf
          EndIf
          
          If alpha
            MoveElement(ilements(), #PB_List_Last)
            isCurrentItem = #True
            currentItemXOffset = x - ilements()\x
            currentItemYOffset = y - ilements()\y
            Break
          EndIf
        EndIf
      EndIf
    Until PreviousElement(ilements()) = 0
  EndIf
  
  ProcedureReturn isCurrentItem
EndProcedure

Procedure.i iHitTest (List ilements.canvasitem(), x, y)
  Shared currentItemXOffset.i, currentItemYOffset.i
  Protected alpha.i, isCurrentItem.i = #False
  
  If LastElement(ilements()) ; search for hit, starting from end (z-order)
    Repeat
      Debug ilements()\y
      
      If x >= ilements()\x - *h\Page\Pos And x < ilements()\x - *h\Page\Pos + ilements()\width
        If y >= ilements()\y - *v\Page\Pos And y < ilements()\y - *v\Page\Pos + ilements()\height
          
          ForEach ilements()\Items()
            
            If x >= ilements()\Items()\x - *h\Page\Pos And x < ilements()\Items()\x - *h\Page\Pos + ilements()\Items()\width
              ; If y >= ilements()\Items()\y - *v\Page\Pos And y < ilements()\Items()\y - *v\Page\Pos + ilements()\Items()\height
              Debug ilements()\Items()\y
              
            EndIf
            ; EndIf
          Next
          
        EndIf
      EndIf
    Until PreviousElement(ilements()) = 0
  EndIf
  
  ProcedureReturn isCurrentItem
EndProcedure



; Addilement(ilements(),  10, 10, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/ToolBar/Copy.png"))
; Addilement(ilements(), 100,100, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/ToolBar/Copy.png"))
; Addilement(ilements(),  50,200, LoadImage(#PB_Any, #PB_Compiler_Home + "Examples/Sources/Data/ToolBar/Copy.png"))

hole = CreateImage(#PB_Any,50,50,32)
Define Text.s = Str(0)
If StartDrawing(ImageOutput(hole))
  DrawingMode(#PB_2DDrawing_AllChannels)
  Box(0,0,OutputWidth(),OutputHeight(),RGBA($00,$FF,$FF,$FF))
  DrawText((OutputWidth()-TextWidth(Text.s))/2, (OutputHeight()-TextHeight(Text.s))/2, Text.s)
  StopDrawing()
EndIf
Addilement(ilements(),10,10,hole,1)

Addilement(ilements(),10,10,hole,1)

AddItem(0, 0, "doCaption")
AddItem(0, 0, "doHide")
AddItem(0, 2, "onCreate")
AddItem(0, 2, "onClick")



hole = CreateImage(#PB_Any,50,50,32)
Define Text.s = Str(1)
If StartDrawing(ImageOutput(hole))
  DrawingMode(#PB_2DDrawing_AllChannels)
  Box(0,0,OutputWidth(),OutputHeight(),RGBA($00,$FF,$FF,$FF))
  DrawText((OutputWidth()-TextWidth(Text.s))/2, (OutputHeight()-TextHeight(Text.s))/2, Text.s)
  StopDrawing()
EndIf
Addilement(ilements(),170,70,hole,1)

AddItem(1, 0, "doCaption")
AddItem(1, 0, "doColor")



Macro GetScrollCoordinate()
  ScrollX = ilements()\x
  ScrollY = ilements()\Y
  ScrollWidth = ilements()\x+ilements()\width
  ScrollHeight = ilements()\Y+ilements()\height
  
  PushListPosition(ilements())
  ForEach ilements()
    If ScrollX > ilements()\x : ScrollX = ilements()\x : EndIf
    If ScrollY > ilements()\Y : ScrollY = ilements()\Y : EndIf
    If ScrollWidth < ilements()\x+ilements()\width : ScrollWidth = ilements()\x+ilements()\width : EndIf
    If ScrollHeight < ilements()\Y+ilements()\height : ScrollHeight = ilements()\Y+ilements()\height : EndIf
  Next
  PopListPosition(ilements())
EndMacro

Procedure ScrollUpdates(*v.Scroll_S, *h.Scroll_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  Protected iWidth = Scroll::X(*v), iHeight = Scroll::Y(*h)
  Static hPos, vPos : vPos = *v\Page\Pos : hPos = *h\Page\Pos
  
  ; Вправо работает как надо
  If ScrollArea_Width<*h\Page\Pos+iWidth 
    ScrollArea_Width=*h\Page\Pos+iWidth
    ; Влево работает как надо
  ElseIf ScrollArea_X>*h\Page\Pos And
         ScrollArea_Width=*h\Page\Pos+iWidth 
    ScrollArea_Width = iWidth 
  EndIf
  
  ; Вниз работает как надо
  If ScrollArea_Height<*v\Page\Pos+iHeight
    ScrollArea_Height=*v\Page\Pos+iHeight 
    ; Верх работает как надо
  ElseIf ScrollArea_Y>*v\Page\Pos And
         ScrollArea_Height=*v\Page\Pos+iHeight 
    ScrollArea_Height = iHeight 
  EndIf
  
  If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
  If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
  
  If ScrollArea_X<*h\Page\Pos : ScrollArea_Width-ScrollArea_X : EndIf
  If ScrollArea_Y<*v\Page\Pos : ScrollArea_Height-ScrollArea_Y : EndIf
  
  If *v\Max<>ScrollArea_Height : Scroll::SetAttribute(*v, #PB_ScrollBar_Maximum, ScrollArea_Height) : EndIf
  If *h\Max<>ScrollArea_Width : Scroll::SetAttribute(*h, #PB_ScrollBar_Maximum, ScrollArea_Width) : EndIf
  
  If *v\Page\Length<>iHeight : Scroll::SetAttribute(*v, #PB_ScrollBar_PageLength, iHeight) : EndIf
  If *h\Page\Length<>iWidth : Scroll::SetAttribute(*h, #PB_ScrollBar_PageLength, iWidth) : EndIf
  
  If ScrollArea_Y<0 : Scroll::SetState(*v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
  If ScrollArea_X<0 : Scroll::SetState(*h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
  
  *v\Hide = Scroll::Resize(*v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *h) 
  *h\Hide = Scroll::Resize(*h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, *v)
  
  ;   If *v\Hide : *v\Page\Pos = 0 : Else : *v\Page\Pos = vPos : *h\Width = iWidth+*v\Width : EndIf
  ;   If *h\Hide : *h\Page\Pos = 0 : Else : *h\Page\Pos = hPos : *v\Height = iHeight+*h\Height : EndIf
  
  If *v\Hide : *v\Page\Pos = 0 : If vPos : *v\Hide = vPos : EndIf : Else : *v\Page\Pos = vPos : *h\Width = iWidth+*v\Width : EndIf
  If *h\Hide : *h\Page\Pos = 0 : If hPos : *h\Hide = hPos : EndIf : Else : *h\Page\Pos = hPos : *v\Height = iHeight+*h\Height : EndIf
  
  ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
EndProcedure

Procedure CallBack()
  Protected Repaint
  Protected Event = EventType()
  Protected Canvas = EventGadget()
  Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
  Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
  Protected Buttons = GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons)
  Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
  Protected Width = GadgetWidth(Canvas)
  Protected Height = GadgetHeight(Canvas)
  Protected ScrollX, ScrollY, ScrollWidth, ScrollHeight
  
  If Scroll::CallBack(*v, Event, MouseX, MouseY, WheelDelta) 
    Repaint = #True 
  EndIf
  If Scroll::CallBack(*h, Event, MouseX, MouseY, WheelDelta) 
    Repaint = #True 
  EndIf
  
  Select Event
    Case #PB_EventType_LeftButtonUp
      GetScrollCoordinate()
      
      If (ScrollX<0 Or ScrollY<0)
        PushListPosition(ilements())
        ForEach ilements()
          If ScrollX<0
            *h\Page\Pos =- ScrollX
            ilements()\X-ScrollX
          EndIf
          If ScrollY<0
            *v\Page\Pos =- ScrollY
            ilements()\Y-ScrollY
          EndIf
        Next
        PopListPosition(ilements())
      EndIf
      
  EndSelect     
  
  
  If (*h\Buttons Or *v\Buttons)
    Select Event
      Case #PB_EventType_LeftButtonUp
        Debug "----------Up---------"
        GetScrollCoordinate()
        ScrollUpdates(*v,*h, ScrollX, ScrollY, ScrollWidth, ScrollHeight)
        ;           Protected iWidth = Width-Scroll::Width(*v), iHeight = Height-Scroll::Height(*h)
        ;   
        ;         Debug ""+*h\Hide+" "+ScrollX+" "+Str(ScrollWidth-iWidth)
        ;         Debug ""+*v\Hide+" "+ScrollY+" "+Str(ScrollHeight-iHeight)
        
        PushListPosition(ilements())
        ForEach ilements()
          ;           If *h\Hide And (ScrollWidth-Width)>0 : ilements()\X-(ScrollWidth-Width) : EndIf
          ;           If *v\Hide And (ScrollHeight-Height)>0 : ilements()\Y-(ScrollHeight-Height) : EndIf
          If *h\Hide>1 : ilements()\X-*h\Hide : EndIf
          If *v\Hide>1 : ilements()\Y-*v\Hide : EndIf
        Next
        PopListPosition(ilements())
        
        
    EndSelect
  Else
    Select Event
      Case #PB_EventType_LeftButtonUp : Drag = #False
      Case #PB_EventType_LeftButtonDown
        isCurrentItem = HitTest(ilements(), Mousex, Mousey)
        Debug  iHitTest(ilements(), Mousex, Mousey)
        
        If isCurrentItem 
          Repaint = #True 
          Drag = #True
        EndIf
        
      Case #PB_EventType_MouseMove
        If Drag = #True
          If isCurrentItem
            If LastElement(ilements())
              ilements()\x = Mousex - currentItemXOffset
              ilements()\y = Mousey - currentItemYOffset
              SetWindowTitle(EventWindow(), Str(ilements()\x))
              
              GetScrollCoordinate()
              Repaint = Scroll::Updates(*v,*h, ScrollX, ScrollY, ScrollWidth, ScrollHeight)
            EndIf
          EndIf
        EndIf
        
      Case #PB_EventType_Resize : ResizeGadget(Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
        GetScrollCoordinate()
        
        If *h\Max<>ScrollWidth : Scroll::SetAttribute(*h, #PB_ScrollBar_Maximum, ScrollWidth) : EndIf
        If *v\Max<>ScrollHeight : Scroll::SetAttribute(*v, #PB_ScrollBar_Maximum, ScrollHeight) : EndIf
        
        Scroll::Resizes(*v, *h, 0, 0, Width, Height)
        Repaint = #True
        
    EndSelect
  EndIf 
  
  If Repaint : Draw(#MyCanvas, ilements()) : EndIf
EndProcedure

Procedure ResizeCallBack()
  ResizeGadget(#MyCanvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-20)
EndProcedure


If Not OpenWindow(0, 0, 0, 420, 420, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 
  MessageRequester("Fatal error", "Program terminated.")
  End
EndIf

;
CanvasGadget(#MyCanvas, 10, 10, 400, 400)

*v = Scroll::Create(#MyCanvas,-1, 380, 0,  20, 380, 0, 0, 0, #PB_ScrollBar_Vertical)
*h = Scroll::Create(#MyCanvas,-1, 0, 380, 380,  20, 0, 0, 0, 0)

PostEvent(#PB_Event_Gadget, 0,#MyCanvas,#PB_EventType_Resize)
BindGadgetEvent(#MyCanvas, @CallBack())
BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)

Repeat
  Event = WaitWindowEvent()
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -----------
; EnableXP