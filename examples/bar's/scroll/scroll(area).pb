﻿XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib( widget )
  
  Structure IMAGES Extends _s_COORDINATE
    img.i
    alphatest.i
  EndStructure
  
  Global MyCanvas
  Global *current=#False
  Global currentItemXOffset.i, currentItemYOffset.i
  Global Event.i, drag.i, hole.i
  Global x=200,y=150, Width=320, Height=320
  
  Global *this.allocate( widget )
  Global NewList Images.IMAGES( )
  Declare  Canvas_Draw( canvas.i, List Images.IMAGES( ) )
  
  Macro Area_Draw( _this_ )
    widget::bar_updates( _this_,
                         _this_\scroll\h\x, 
                         _this_\scroll\v\y, 
                         (_this_\scroll\v\x+_this_\scroll\v\width)-_this_\scroll\h\x,
                         (_this_\scroll\h\y+_this_\scroll\h\height)-_this_\scroll\v\y )
    
    If Not _this_\scroll\v\hide
      widget::Draw( _this_\scroll\v )
    EndIf
    If Not _this_\scroll\h\hide
      widget::Draw( _this_\scroll\h )
    EndIf
    
    UnclipOutput( )
    DrawingMode( #PB_2DDrawing_Outlined )
    Box( x, y, Width, Height, RGB( 0,255,0 ) )
    Box( _this_\scroll\h\x, _this_\scroll\v\y, _this_\scroll\h\bar\page\len, _this_\scroll\v\bar\page\len, RGB( 0,0,255 ) )
    
    ; Box( _this_\x[#__c_required], _this_\y[#__c_required], _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, RGB( 255,0,0 ) )
    Box( _this_\scroll\h\x -_this_\scroll\h\bar\page\pos, _this_\scroll\v\y - _this_\scroll\v\bar\page\pos, _this_\scroll\h\bar\max, _this_\scroll\v\bar\max, RGB( 255,0,0 ) )
  EndMacro
  
  Macro Area_Use( _canvas_window_, _canvas_gadget_ = #PB_Any )
    Open( _canvas_window_, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, "", #PB_Canvas_Keyboard, 0, _canvas_gadget_ )
  EndMacro
  
  Macro Area_Create( _parent_, _x_, _y_, _width_, _height_, _frame_size_, _scrollbar_size_, _flag_=#Null)
    _parent_\fs = _frame_size_
    _parent_\scroll\v = widget::scroll( _x_+_width_-_scrollbar_size_, _y_, _scrollbar_size_, 0, 0, 0, 0, #__bar_Vertical|_flag_, 11 )
    _parent_\scroll\h = widget::scroll( _x_, _y_+_height_-_scrollbar_size_, 0,  _scrollbar_size_, 0, 0, 0, _flag_, 11 )
    widget::bar_Resizes( _parent_, _x_+_parent_\fs, _y_+_parent_\fs, _width_-_parent_\fs*2, _height_-_parent_\fs*2 )
  EndMacro                                                  
  
  Macro Area_Bind( _parent_, _callback_)
    If _callback_
      Bind( _parent_\scroll\v, _callback_ )
      Bind( _parent_\scroll\h, _callback_ )
      ;Bind( root( ), 0 ) 
    EndIf
  EndMacro                                                  
  
  Procedure Area_Events( )
    
    Select WidgetEventType( )
      Case #PB_EventType_Change
        Debug "changing scroller values - "+EventWidget( )\bar\page\change +" "+ WidgetEventData( )
        
        PushListPosition(  Images( )  )
        If EventWidget( )\vertical
          ForEach Images( ) : Images( )\Y + EventWidget( )\bar\page\change : Next
          *this\y[#__c_required] =- EventWidget( )\bar\page\pos + EventWidget( )\y
          
        Else
          ForEach Images( ) : Images( )\X + EventWidget( )\bar\page\change : Next
          *this\x[#__c_required] =- EventWidget( )\bar\page\pos + EventWidget( )\x
          
        EndIf
        PopListPosition( Images( ) )
        
        ; Debug EventWidget( )\bar\page\change
        
        Canvas_Draw( MyCanvas, Images( ) ) 
        ;PostEvent( #PB_Event_Repaint, EventWindow( ), EventGadget( ), #PB_EventType_Repaint ); , EventWidget( )\bar\page\change )
    EndSelect
    
  EndProcedure
  
  
  ;   Procedure bUpdate( )
  ;     Debug "  "+*this\scroll\h\x +" "+ *this\scroll\v\y +" "+ Str((*this\scroll\v\x+*this\scroll\v\width)-*this\scroll\h\x) +" "+ Str((*this\scroll\h\y+*this\scroll\h\height)-*this\scroll\v\y)
  ;     ;widget::bar_Updates( *this, *this\scroll\h\x, *this\scroll\v\y, (*this\scroll\v\x+*this\scroll\v\width)-*this\scroll\h\x, (*this\scroll\h\y+*this\scroll\h\height)-*this\scroll\v\y )
  ;   
  ;   EndProcedure
  ;   
  ;-
  Procedure Canvas_Draw( canvas.i, List Images.IMAGES( ) )
    Protected round
    
    ;Debug Images( )\x
    *this\x[#__c_required] = Images( )\x 
    *this\y[#__c_required] = Images( )\Y
    *this\width[#__c_required] = Images( )\x+Images( )\width - *this\x[#__c_required]
    *this\height[#__c_required] = Images( )\Y+Images( )\height - *this\y[#__c_required]
    
    PushListPosition( Images( ) )
    ForEach Images( )
      If *this\x[#__c_required] > Images( )\x : *this\x[#__c_required] = Images( )\x : EndIf
      If *this\y[#__c_required] > Images( )\y : *this\y[#__c_required] = Images( )\y : EndIf
    Next
    ForEach Images( )
      If *this\width[#__c_required] < Images( )\x+Images( )\width - *this\x[#__c_required] : *this\width[#__c_required] = Images( )\x+Images( )\width - *this\x[#__c_required] : EndIf
      If *this\height[#__c_required] < Images( )\Y+Images( )\height - *this\y[#__c_required] : *this\height[#__c_required] = Images( )\Y+Images( )\height - *this\y[#__c_required] : EndIf
    Next
    PopListPosition( Images( ) )
    
    If StartDrawing( CanvasOutput( canvas ) )
      DrawingMode( #PB_2DDrawing_Default )
      Box( 0, 0, OutputWidth( ), OutputHeight( ), RGB( 255,255,255 ) )
      
      If GetGadgetState(5)
        UnclipOutput()
        DrawingMode( #PB_2DDrawing_Outlined )
        ForEach Images( )
          round = Bool(Images( )\alphatest And ImageDepth( Images( )\img ) > 31) * 50
          RoundBox( Images( )\x, Images( )\y, Images( )\width, Images( )\height,round, round, RGB( 255,255,0 )) ; draw all images with z-order
        Next
        ClipOutput(*this\scroll\h\x, *this\scroll\v\y, *this\scroll\h\bar\page\len, *this\scroll\v\bar\page\len )
      EndIf
      
      DrawingMode( #PB_2DDrawing_AlphaBlend )
      ForEach Images( )
        DrawImage( ImageID( Images( )\img ), Images( )\x, Images( )\y ) ; draw all images with z-order
      Next
      
      ;;Debug *this\y[#__c_required]
      ;       FirstElement(Images( ))
      ;       Debug ""+Images( )\x +" "+ *this\scroll\h\bar\page\pos
      
      Area_Draw( *this )
      
      StopDrawing( )
    EndIf
  EndProcedure
  
  Procedure.i Canvas_HitTest( List Images.IMAGES( ), mouse_x, mouse_y )
    Shared currentItemXOffset.i, currentItemYOffset.i
    Protected alpha.i, *current = #False
    Protected scroll_x ; = *this\scroll\h\bar\Page\Pos
    Protected scroll_y ;= *this\scroll\v\bar\Page\Pos
    
    If LastElement( Images( ) ) And 
       Not AtPoint( *this\scroll\v, mouse_x, mouse_y ) And
       Not AtPoint( *this\scroll\h, mouse_x, mouse_y ) ; And AtBox( *this\scroll\h\x, *this\scroll\v\y, *this\scroll\h\bar\page\len,*this\scroll\v\bar\page\len, mouse_x, mouse_y )
                                                       ; search for hit, starting from end ( z-order )
      Repeat
        If mouse_x >= Images( )\x - scroll_x And mouse_x < Images( )\x+ Images( )\width - scroll_x 
          If mouse_y >= Images( )\y - scroll_y And mouse_y < Images( )\y + Images( )\height - scroll_y
            alpha = 255
            
            If Images( )\alphatest And ImageDepth( Images( )\img ) > 31
              If StartDrawing( ImageOutput( Images( )\img ) )
                DrawingMode( #PB_2DDrawing_AlphaChannel )
                alpha = Alpha( Point( mouse_x - Images( )\x - scroll_x, mouse_y - Images( )\y - scroll_y ) ) ; get alpha
                StopDrawing( )
              EndIf
            EndIf
            
            If alpha
              MoveElement( Images( ), #PB_List_Last )
              *current = @Images( )
              currentItemXOffset = mouse_x - Images( )\x - scroll_x
              currentItemYOffset = mouse_y - Images( )\y - scroll_y
              Break
            EndIf
          EndIf
        EndIf
      Until PreviousElement( Images( ) ) = 0
    EndIf
    
    ProcedureReturn *current
  EndProcedure
  
  Procedure Canvas_AddImage( List Images.IMAGES( ), x, y, img, alphatest=0 )
    If AddElement( Images( ) )
      Images( )\img    = img
      Images( )\x          = x
      Images( )\y          = y
      Images( )\width  = ImageWidth( img )
      Images( )\height = ImageHeight( img )
      Images( )\alphatest = alphatest
    EndIf
  EndProcedure
  
  Procedure Canvas_SetCursor( mouse_x, mouse_y, cur = #PB_Cursor_Default )
    Static set_cursor 
    Protected cursor
    
    If cur <> #PB_Cursor_Default
      cursor = cur
    Else
      If Not Mouse( )\buttons
        If Bool( Canvas_HitTest( Images( ), mouse_x, mouse_y ) ) 
          cursor = #PB_Cursor_Hand
        Else 
          cursor = #PB_Cursor_Default
        EndIf
      EndIf
    EndIf
    
    If set_cursor <> cursor
      set_cursor = cursor
      SetGadgetAttribute( MyCanvas, #PB_Canvas_Cursor, cursor )
    EndIf
  EndProcedure
  
  Procedure Canvas_CallBack( )
    Protected Repaint
    Protected Event = EventType( )
    Protected Canvas = EventGadget( )
    Protected MouseX ;= GetGadgetAttribute( Canvas, #PB_Canvas_MouseX )
    Protected MouseY ;= GetGadgetAttribute( Canvas, #PB_Canvas_MouseY )
                     Width = GadgetWidth( Canvas ) - x*2
                     Height = GadgetHeight( Canvas ) - y*2
    widget::EventHandler( )
    
    MouseX = widget::Mouse( )\x
    MouseY = widget::Mouse( )\y
;     Width = widget::Root( )\width - x*2
;     Height = widget::Root( )\height - y*2
    
    Select Event
      Case #PB_EventType_Repaint
        Repaint = #True
        
      Case #PB_EventType_LeftButtonUp : Drag = #False
        Canvas_SetCursor( Mousex, Mousey )
        
      Case #PB_EventType_LeftButtonDown
        Drag = Bool( Canvas_HitTest( Images( ), Mousex, Mousey ) )
        If Drag 
          Canvas_SetCursor( Mousex, Mousey, #PB_Cursor_Arrows )
          Repaint = #True 
        EndIf
        
      Case #PB_EventType_MouseMove
        If Drag = #True
          If LastElement( Images( ) )
            If Images( )\x <> Mousex - currentItemXOffset
              Images( )\x = Mousex - currentItemXOffset
              Repaint = #True
            EndIf
            
            If Images( )\y <> Mousey - currentItemYOffset
              Images( )\y = Mousey - currentItemYOffset
              Repaint = #True
            EndIf
          EndIf
        Else 
          Canvas_SetCursor( Mousex, Mousey )
        EndIf
        
      Case #PB_EventType_Resize 
        ResizeGadget( Canvas, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore ) ; Bug ( 562 )
        
        widget::bar_Resizes( *this, x+*this\fs, y+*this\fs, width-*this\fs*2, height-*this\fs*2 )
        
        Repaint = #True
    EndSelect
    
    If Repaint 
      Canvas_Draw( MyCanvas, Images( ) ) 
    EndIf
  EndProcedure
  
  ;-
  
  Define yy = 90
  Define xx = 0
  
  Procedure Window_Resize()
    ResizeGadget(MyCanvas, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-10-100)
  EndProcedure
  
  If Not OpenWindow( 0, 0, 0, Width+x*2+20+xx, Height+y*2+20+yy, "Move/Drag Canvas Image", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered ) 
    MessageRequester( "Fatal error", "Program terminated." )
    End
  EndIf
  
  BindEvent(#PB_Event_SizeWindow, @Window_Resize(), 0)
  ;
  CheckBoxGadget(2, 10, 10, 80,20, "vertical") : SetGadgetState(2, 1)
  CheckBoxGadget(3, 10, 30, 80,20, "invert")
  CheckBoxGadget(4, 10, 50, 80,20, "noButtons")
  CheckBoxGadget(5, 10, 70, 80,20, "clipoutput") : SetGadgetState(5, 1)
  
  If CreateImage(0, 200, 80)
    
    StartDrawing(ImageOutput(0))
    
    FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
    
    DrawingMode(#PB_2DDrawing_Default)
    Box(5, 10, 30, 2, RGB( 0,255,0 ))
    Box(5, 10+25, 30, 2, RGB( 0,0,255 ))
    Box(5, 10+50, 30, 2, RGB( 255,0,0 ))
    
    DrawingMode(#PB_2DDrawing_Transparent)
    DrawText(40, 5, "frame - (coordinate color)",0,0)
    DrawText(40, 30, "page - (coordinate color)",0,0)
    DrawText(40, 55, "max - (coordinate color)",0,0)
    
    StopDrawing() ; This is absolutely needed when the drawing operations are finished !!! Never forget it !
    
  EndIf
  ImageGadget(#PB_Any, Width+x*2+20-210,10,200,80, ImageID(0) )
  
  ;
  MyCanvas = CanvasGadget( #PB_Any, xx+10, yy+10, Width+x*2, Height+y*2, #PB_Canvas_Keyboard ) 
  BindGadgetEvent(MyCanvas, @Canvas_CallBack())
  Area_Use( 0, MyCanvas)
  ;MyCanvas = GetGadget( Open( 0, xx+10, yy+10, Width+x*2, Height+y*2, "", #PB_Canvas_Keyboard, @Canvas_CallBack( ) ) )
  
  ; add new images
  Canvas_AddImage( Images( ), x-80, y-20, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/PureBasic.bmp" ) )
  Canvas_AddImage( Images( ), x+100,y+100, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/Geebee2.bmp" ) )
  Canvas_AddImage( Images( ), x+210,y+250, LoadImage( #PB_Any, #PB_Compiler_Home + "examples/sources/Data/AlphaChannel.bmp" ) )
  
  hole = CreateImage( #PB_Any,100,100,32 )
  If StartDrawing( ImageOutput( hole ) )
    DrawingMode( #PB_2DDrawing_AllChannels )
    Box( 0,0,OutputWidth(),OutputHeight(),RGBA( $00,$00,$00,$00 ) )
    Circle( 50,50,48,RGBA( $00,$FF,$FF,$FF ) )
    Circle( 50,50,30,RGBA( $00,$00,$00,$00 ) )
    StopDrawing( )
  EndIf
  Canvas_AddImage( Images( ),x+180,y+180,hole,#True )
                   Width = GadgetWidth( MyCanvas ) - x*2
                     Height = GadgetHeight( MyCanvas ) - y*2
    
  ;
  Area_Create( *this, x,y,width,height, 2,20 )
  Area_Bind( *this, @Area_Events( ) ) 
  
  Define vButton = GetAttribute(*this\Scroll\v, #__bar_buttonsize)
  Define hButton = GetAttribute(*this\Scroll\h, #__bar_buttonsize)
  
  
  Repeat
    Event = WaitWindowEvent( )
    
    If event = #PB_Event_Repaint
      Select EventType( )
        Case #PB_EventType_Repaint
          Canvas_Draw( MyCanvas, Images( ) ) 
          
      EndSelect
    EndIf
    
    Select Event
      Case #PB_Event_Gadget
        Select EventGadget()
          Case 2
            If GetGadgetState(2)
              SetGadgetState(3, GetAttribute(*this\scroll\v, #__bar_invert))
            Else
              SetGadgetState(3, GetAttribute(*this\scroll\h, #__bar_invert))
            EndIf
            
          Case 3
            If GetGadgetState(2)
              SetAttribute(*this\scroll\v, #__bar_invert, Bool(GetGadgetState(3)))
              SetWindowTitle(0, Str(GetState(*this\scroll\v)))
            Else
              SetAttribute(*this\scroll\h, #__bar_invert, Bool(GetGadgetState(3)))
              SetWindowTitle(0, Str(GetState(*this\scroll\h)))
            EndIf
            Canvas_Draw(MyCanvas, Images( ))
            
          Case 4
            If GetGadgetState(2)
              SetAttribute(*this\scroll\v, #__bar_buttonsize, Bool( Not GetGadgetState(4)) * vButton)
              SetWindowTitle(0, Str(GetState(*this\scroll\v)))
            Else
              SetAttribute(*this\scroll\h, #__bar_buttonsize, Bool( Not GetGadgetState(4)) * hButton)
              SetWindowTitle(0, Str(GetState(*this\scroll\h)))
            EndIf
            Canvas_Draw(MyCanvas, Images( ))
            
          Case 5
            Canvas_Draw(MyCanvas, Images( ))
            
        EndSelect
    EndSelect
    
  Until Event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = ---------
; EnableXP