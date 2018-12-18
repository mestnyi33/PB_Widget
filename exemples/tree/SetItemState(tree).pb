﻿CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElse
  IncludePath "../../"
CompilerEndIf

XIncludeFile "module_macros.pbi"
XIncludeFile "module_constants.pbi"
XIncludeFile "module_structures.pbi"
XIncludeFile "module_scroll.pbi"
XIncludeFile "module_text.pbi"
XIncludeFile "module_editor.pbi"
XIncludeFile "module_tree.pbi"

LN=150; количесвто итемов 

If OpenWindow(0, 100, 50, 530, 700, "treeGadget", #PB_Window_SystemMenu)
  TreeGadget(0, 10, 10, 250, 680)
  tree::Gadget(1, 270, 10, 250, 680, #PB_Flag_FullSelection|#PB_Flag_GridLines)
  *w=GetGadgetData(1)
  
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    tree::AddItem (*w, -1, "Item "+Str(a), 0);,1)
    tree::SetItemState(*w, a, 1) ; set (beginning with 0) the tenth item as the active one
  Next
  Debug Str(ElapsedMilliseconds()-time) + " - add widget items time count - " + tree::CountItems(*w)
  
  
  ; HideGadget(0, 1)
  Define time = ElapsedMilliseconds()
  For a = 0 To LN
    AddGadgetItem (0, -1, "Item "+Str(a), 0);, Random(5)+1)
    SetGadgetItemState(0, a, 1) ; set (beginning with 0) the tenth item as the active one
  Next
  Debug Str(ElapsedMilliseconds()-time) + " - add gadget items time count - " + CountGadgetItems(0)
  ; HideGadget(0, 0)
  
  Repeat : Event=WaitWindowEvent()
  Until  Event= #PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -
; EnableXP