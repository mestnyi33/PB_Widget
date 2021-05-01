﻿XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib(widget)
  
  Global i, x = 220, panel, butt1, butt2
  Global._s_WIDGET *panel, *butt0, *butt1, *butt2
  
  If Bind( Open( #PB_Any, 0, 0, x+170, 170, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered ), #PB_Default )
    
   panel = PanelGadget(#PB_Any, 10, 65, 160,95 ) 
    For i = 0 To 5 
      AddGadgetItem( panel, i, Hex(i) ) 
      If i
        ButtonGadget(#PB_Any, 10,5,80,35, "_"+Str(i) ) 
      EndIf
    Next 
    CloseGadgetList( )
    
    OpenGadgetList( panel, 0 )
    ButtonGadget(#PB_Any, 10,5,80,35, "_0" ) 
    CloseGadgetList( )
    
    ;
    butt1 = ButtonGadget(#PB_Any, 10,5,80,25, "*butt1" ) 
    butt2 = ButtonGadget(#PB_Any, 10,35,80,25, "*butt2" ) 
    
    SetGadgetState( panel, 2 )
    
    
    ;
    *panel = Panel( x, 65, 160,95 ) 
    For i = 0 To 5 
      AddItem( *panel, i, Hex(i) ) 
      If i
        Button( 10,5,80,35, "_"+Str(i) ) 
      EndIf
    Next 
    CloseList( )
    
    OpenList( *panel, 0 )
    Button( 20,25,80,35, "_0" ) 
    CloseList( )
    
;     *butt0 = Button( 20,25,80,35, "_0" )
;     SetParent( *butt0, *panel, 0 )
    
    ;
    *butt1 = Button( x,5,80,25, "*butt1" ) 
    *butt2 = Button( x,35,80,25, "*butt2" ) 
    
    If *panel
      SetState( *panel, 2 )
    EndIf
    
    Debug "----panel all childrens-----"
    If StartEnumerate( *panel )
      Debug widget( )\text\string
      
      StopEnumerate( )
    EndIf
    
    Define line.s
    Debug "---->>"
    ForEach widget( )
      line = "  "+ widget( )\class +" "
      
      If widget( )\before
        line + widget( )\before\class+"_"+widget( )\before\text\string +" <<  "
      Else
        line + "-------- <<  " 
      EndIf
      
      line + widget( )\text\string
      
      If widget( )\after
        line +"  >> "+ widget( )\after\class+"_"+widget( )\after\text\string
      Else
        line + "  >> --------" 
      EndIf
      
      Debug line
    Next
    Debug "<<----"
    
    
    Repeat: Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf   
CompilerEndIf
   
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --
; EnableXP