﻿;                                                       - PB
;                               Separator( [*address] ) - ToolBarSeparator( )
;                                                         ToolBarID( #ToolBar )
;                                                         IsToolBar( #ToolBar )
;                          ToolBar( *parent [, flags] ) - CreateToolBar( #ToolBar, WindowID [, Flags] )
;                  DisableItem( *address, item, state ) - DisableToolBarButton( #ToolBar, Button, State )
;                                      Free( *address ) - FreeToolBar( #ToolBar )
;                        GetItemState( *address, item ) - GetToolBarButtonState( #ToolBar, Button )
;                 SetItemState( *address, item, state ) - SetToolBarButtonState( #ToolBar, Button, State )
;                 SetItemText( *address, item, text.s ) - ToolBarButtonText( #ToolBar, Button, Text$ )
;                                    Height( *address ) - ToolBarHeight( #ToolBar )
;      AddItem( *address, button, text.s, image, mode ) - ToolBarImageButton( #Button, ImageID [, Mode [, Text$]] )
;       AddItem( *address, button, text.s, icon, mode ) - ToolBarStandardButton( #Button, #ButtonIcon [, Mode [, Text$]] )
;                 ToolTipItem( *address, item, text.s ) - ToolBarToolTip( #ToolBar, Button, Text$ )
;
;                         GetItemText( *address, item ) - 
;                        GetItemImage( *address, item ) - 
;                 SetItemImage( *address, item, image ) - 

XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  Uselib(widget)
  UsePNGImageDecoder()
  
  Global *toolbar._s_widget, th=24
  
  Procedure _ToolBar( *parent._s_WIDGET, flag.i = #PB_ToolBar_Small )
    ;*parent\MenuBarHeight = 32;+2 + 6
    *parent\ToolBarHeight = 32;+2 + 6
    *parent\tab\widget = Create( *parent, *parent\class+"_"+#PB_Compiler_Procedure, #__type_ToolBar, 0,0,0,0, 0,0,0, #Null$, flag | #__flag_child, 0,0,30 )
    Resize( *parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
    ProcedureReturn *parent\tab\widget
  EndProcedure
    
  Macro ToolBarButton( _button_, _image_, _mode_=0, _text_="" )
    If widget( )\tab\widget
      AddItem( widget( )\tab\widget, _button_, _text_, _image_, _mode_)
    EndIf
  EndMacro
  
  Macro Separator( )
    If widget( )\tab\widget
      AddItem( widget( )\tab\widget, 65535, "|", #Null, #Null )
    EndIf
  EndMacro
  
  Macro DisableButton( _this_, _button_, _state_ )
    
  EndMacro
  
  
  If OpenWindow(0, 100, 200, 195, 260, "ToolBar example", #PB_Window_SystemMenu | #PB_Window_SizeGadget)
    
    If CreateToolBar(0, WindowID(0), #PB_ToolBar_Small)
      ToolBarImageButton(0, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"))
      ToolBarImageButton(1, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "open")
      ToolBarImageButton(2, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"))
      
      ToolBarSeparator()
      
      ToolBarImageButton(3, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
      ToolBarToolTip(0, 3, "Cut")
      
      ToolBarImageButton(4, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
      ToolBarToolTip(0, 4, "Copy")
      
      ToolBarImageButton(5, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
      ToolBarToolTip(0, 5, "Paste")
      
      ToolBarSeparator()
      
      ToolBarImageButton(6, LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"))
      ToolBarToolTip(0, 6, "Find a document")
    EndIf
    
    DisableToolBarButton(0, 2, 1) ; Disable the button '2'
  EndIf
  
  
  If Open( #PB_Any, 300, 200, 300, 380, "", #PB_Window_BorderLess )
    Window( 0, 0, 195, 260, "ToolBar example", #PB_Window_SystemMenu | #PB_Window_SizeGadget )
    *toolbar = _ToolBar( widget( ) )
    
    If *toolbar
      ToolBarButton(0, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/New.png"))
      ToolBarButton(1, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Open.png"), #PB_ToolBar_Normal, "open")
      ToolBarButton(2, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Save.png"));, #PB_ToolBar_Normal, "save")
      
      Separator( )
      
      ToolBarButton(3, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
      ; ToolTip(*toolbar, 3, "Cut")
      
      ToolBarButton(4, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
      ; ToolTip(*toolbar, 4, "Copy")
      
      ToolBarButton(5, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png"))
      ; ToolTip(*toolbar, 5, "Paste")
      
      Separator( )
      
      ToolBarButton(6, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Find.png"))
      ; ToolTip(*toolbar, 6, "Find a document")
    EndIf
       
    DisableButton(*toolbar, 2, 1) ; Disable the button '2'
       
    Bind( root( ), #PB_Default )
  EndIf
  
  
  Define Event, Quit
  Repeat
    Event = WaitWindowEvent()
    
    Select Event
        
      Case #PB_Event_Menu
        Debug Str(EventMenu())+" - event item"
        
      Case #PB_Event_CloseWindow  ; If the user has pressed on the close button
        Quit = 1
        
    EndSelect
    
  Until Quit = 1
  
  
  End   ; All resources are automatically freed
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP