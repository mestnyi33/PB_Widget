﻿XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseLib( widget )
  
  Define h = 185, bh = 26
  Define *g1, *g2, *g3, *g4, *g5, *g6
  
  If Open(#PB_Any, 0, 0, 680, 60+h, "splitter thumb position then resized", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    *g1 = Editor(     30, 30, 200, h)
    SetText(*g1, "left 00000000000000000000000000000000000")
    AddItem(*g1, -1, "left 00000000000000000000000000000000000")
    
    *g2 = Editor( 30+210, 30, 200, h, #__text_center|#__text_top)
    SetText(*g2, "0000000000000000000 center 00000000000000000000" )
    AddItem(*g2, -1, "0000000000000000000 center 00000000000000000000" )
    
    *g3 = Editor( 30+420, 30, 200, h, #__text_right|#__text_top)
    SetText(*g3, "00000000000000000000000000000000000 right" )
    AddItem(*g3, -1, "00000000000000000000000000000000000 right" )
    
    *g4 = Splitter( 0,0,0,0, *g1,*g2, #PB_Splitter_Vertical|#PB_Splitter_FirstFixed)
    *g5 = Splitter( 30,30,620,h, *g4,*g3, #PB_Splitter_Vertical)
    *g6 = Splitter( 30,30,620,h, *g5,#Null)
    
    SetState(*g4, 200)
    SetState(*g5, 200*2)
    SetState(*g6, h)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = -
; EnableXP