﻿IncludePath "../"
XIncludeFile "tree().pb"
;XIncludeFile "widgets().pbi"


UseModule Tree

Macro AddGadgetItem(Gadget, Position, Text, ImageID=-1, Flags=0)
  Tree::AddItem(GetGadgetData(Gadget), Position, Text, ImageID, Flags)
EndMacro

If OpenWindow(0, 0, 0, 355, 180, "Tree", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    Gadget(0, 10, 10, 160, 160, #PB_Tree_Collapse)                                         ; TreeGadget standard
    Gadget(1, 180, 10, 160, 160, #PB_Tree_CheckBoxes | #PB_Tree_NoLines | #PB_Tree_AlwaysShowSelection | #PB_Tree_Collapse)  ; TreeGadget with Checkboxes + NoLines
    
    For i = 0 To 1
      ID = GetGadgetData(i)
      
      For a = 0 To 10
        AddItem (ID, -1, "Normal Item "+Str(a), 0, 0) ; if you want to add an image, use
        AddItem (ID, -1, "Node "+Str(a), 0, 0)        ; ImageID(x) as 4th parameter
        AddItem(ID, -1, "Sub-Item 1", 0, 1)    ; These are on the 1st sublevel
        AddItem(ID, -1, "Sub-Item 2", 0, 1)
        AddItem(ID, -1, "Sub-Item 3", 0, 1)
        AddItem(ID, -1, "Sub-Item 4", 0, 1)
        AddItem (ID, -1, "File "+Str(a), 0, 0) ; sublevel 0 again
      Next
    Next
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP