﻿XIncludeFile "../../../widgets.pbi" 

EnableExplicit
Uselib( widget )
Global i

Procedure events_gadgets( )
  ClearDebugOutput( )
  ; Debug ""+EventGadget( )+ " - widget  event - " +EventType( )+ "  state - " +GetGadgetState( EventGadget( ) ) ; 
  
  Select EventType( )
    Case #PB_EventType_LeftClick
     SetState( GetWidget( EventGadget( ) ), GetGadgetState( EventGadget( ) ) )
     Debug  ""+ EventGadget( ) +" - gadget change state " + GetGadgetState( EventGadget( ) )
     
 EndSelect
EndProcedure

Procedure events_widgets( )
  ClearDebugOutput( )
  ; Debug ""+Str( EventWidget( )\index - 1 )+ " - widget  event - " +WidgetEventType( )+ "  state - " GetState( EventWidget( ) ) ; 
  
  Select WidgetEventType( )
    Case #PB_EventType_Change
      SetGadgetState( GetIndex( EventWidget( ) ), GetState( EventWidget( ) ) )
      Debug  Str( GetIndex( EventWidget( ) ) )+" - widget change state " + GetState( EventWidget( ) )
      
  EndSelect
EndProcedure

Define cr.s = #LF$, text.s = "this long" + cr + " multiline " + cr + "text"
  
If Open( OpenWindow( #PB_Any, 0, 0, 160+160, 110, "CheckBoxGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered ) )
  CheckBoxGadget( 0, 10, 10, 140, 20, "CheckBox 1" )
  CheckBoxGadget( 1, 10, 35, 140, 40, text, #PB_CheckBox_ThreeState )
  CheckBoxGadget( 2, 10, 80, 140, 20, "CheckBox 3" )
  SetGadgetState( 0, #PB_Checkbox_Checked )   ; set first option as active one
  SetGadgetState( 1, #PB_Checkbox_Inbetween )   ; set second option as active one
  
  For i = 0 To 2
    BindGadgetEvent( i, @events_gadgets( ) )
  Next
  
  CheckBox( 10+160, 10, 140, 20, "CheckBox 1" )
  CheckBox( 10+160, 35, 140, 40, text, #PB_CheckBox_ThreeState );, #__text_center )
  CheckBox( 10+160, 80, 140, 20, "CheckBox 3", #__text_right )
  SetState( GetWidget( 0 ), #PB_Checkbox_Checked )   ; set first option as active one
  SetState( GetWidget( 1 ), #PB_Checkbox_Inbetween )   ; set second option as active one
  ;Bind( #PB_All, @events_widgets( ) )
  
  For i = 0 To 2
    Bind( GetWidget( i ), @events_widgets( ) )
  Next
  
  WaitClose( )
EndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP