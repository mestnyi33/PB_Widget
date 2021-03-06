﻿;XIncludeFile "widgets.pbi"
XIncludeFile "../widgets.pbi"

;
; This code is automatically generated by the FormDesigner.
; Manual modification is possible to adjust existing commands, but anything else will be dropped when the code is compiled.
; Event procedures needs to be put in another source file.
;

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile ;= 100
  EnableExplicit
  UseLib( Widget )
  
  
  Procedure IsContainer(*this._s_widget)
    ProcedureReturn *this\container
  EndProcedure
  
  Procedure SetImage(*this._s_widget, image)
    ;ProcedureReturn *this\container
  EndProcedure
  
  Procedure SetAnchors(*this._s_widget)
    ;ProcedureReturn *this\container
  EndProcedure
  
  Procedure GetAnchors(*this._s_widget)
    ProcedureReturn *this
  EndProcedure
  
  Procedure.i Type(Class.s)
    Protected Result.i
    
    Select Trim(Class.s)
      Case "Button"         : Result = #PB_GadgetType_Button
      Case "ButtonImage"    : Result = #PB_GadgetType_ButtonImage
      Case "Calendar"       : Result = #PB_GadgetType_Calendar
      Case "Canvas"         : Result = #PB_GadgetType_Canvas
      Case "CheckBox"       : Result = #PB_GadgetType_CheckBox
      Case "ComboBox"       : Result = #PB_GadgetType_ComboBox
      Case "Container"      : Result = #PB_GadgetType_Container
      Case "Date"           : Result = #PB_GadgetType_Date
      Case "Editor"         : Result = #PB_GadgetType_Editor
      Case "ExplorerCombo"  : Result = #PB_GadgetType_ExplorerCombo
      Case "ExplorerList"   : Result = #PB_GadgetType_ExplorerList
      Case "ExplorerTree"   : Result = #PB_GadgetType_ExplorerTree
      Case "Frame"          : Result = #PB_GadgetType_Frame
      Case "HyperLink"      : Result = #PB_GadgetType_HyperLink
      Case "Image"          : Result = #PB_GadgetType_Image
      Case "IPAddress"      : Result = #PB_GadgetType_IPAddress
      Case "ListIcon"       : Result = #PB_GadgetType_ListIcon
      Case "ListView"       : Result = #PB_GadgetType_ListView
      Case "MDI"            : Result = #PB_GadgetType_MDI
      Case "OpenGL"         : Result = #PB_GadgetType_OpenGL
      Case "Option"         : Result = #PB_GadgetType_Option
      ;Case "Popup"          : Result = #PB_GadgetType_Popup
      Case "Panel"          : Result = #PB_GadgetType_Panel
      ;Case "Property"       : Result = #PB_GadgetType_Property
      Case "ProgressBar"    : Result = #PB_GadgetType_ProgressBar
      Case "Scintilla"      : Result = #PB_GadgetType_Scintilla
      Case "ScrollArea"     : Result = #PB_GadgetType_ScrollArea
      Case "ScrollBar"      : Result = #PB_GadgetType_ScrollBar
      Case "Shortcut"       : Result = #PB_GadgetType_Shortcut
      Case "Spin"           : Result = #PB_GadgetType_Spin
      Case "Splitter"       : Result = #PB_GadgetType_Splitter
      Case "String"         : Result = #PB_GadgetType_String
      Case "Text"           : Result = #PB_GadgetType_Text
      Case "TrackBar"       : Result = #PB_GadgetType_TrackBar
      Case "Tree"           : Result = #PB_GadgetType_Tree
      Case "Unknown"        : Result = #PB_GadgetType_Unknown
      Case "Web"            : Result = #PB_GadgetType_Web
      Case "Window"         : Result = #__Type_Window
    EndSelect
    
    ProcedureReturn Result
  EndProcedure
  
  
  ;-
  ;- STRUCTURE
  Structure ArgumentStruct
    i.i 
    s.s
  EndStructure
  
  Structure ContentStruct
    File$
    Text$       ; Содержимое файла 
    String$     ; Строка к примеру: "OpenWindow(#Window_0, x, y, width, height, "Window_0", #PB_Window_SystemMenu)"
    Position.i  ; Положение Content-a в исходном файле
    Length.i    ; длинна Content-a в исходном файле
  EndStructure
  
  Structure Code_S
    Glob.ContentStruct
    Enum.ContentStruct
    Func.ContentStruct
    Decl.ContentStruct
    Even.ContentStruct
    Bind.ContentStruct
  EndStructure
  
  Structure ObjectStruct
    Count.i
    Index.i
    Adress.i
    Position.i ; Code.Code_S
    Map Code.ContentStruct()
    
    Type.ArgumentStruct   ; Type\s.s = OpenWindow;ButtonGadget;TextGadget
    Class.ArgumentStruct  ; Class\s.s = Window_0;Button_0;Text_0
    Object.ArgumentStruct ; Object\s.s = Window_0;Window_0_Button_0;Window_0_Text_0
    Parent.ArgumentStruct
    Window.ArgumentStruct
  EndStructure
  
  Structure FONT
    Object.ArgumentStruct
    Name$
    Height.i
    Style.i
  EndStructure
  
  Structure IMG
    Object.ArgumentStruct
    Name$
  EndStructure
  
  Structure ParseStruct Extends ObjectStruct
    Item.i
    SubLevel.i ; 
    Container.i
    Content.ContentStruct  
    
    X.ArgumentStruct 
    Y.ArgumentStruct
    Width.ArgumentStruct
    Height.ArgumentStruct
    Caption.ArgumentStruct
    Param1.ArgumentStruct
    Param2.ArgumentStruct
    Param3.ArgumentStruct
    Flag.ArgumentStruct
    
    Map Font.FONT()
    Map Img.IMG()
    ;Map Code.ContentStruct()
    
    Args$
  EndStructure
  
  Structure ThisStruct Extends ParseStruct
    Map get.ObjectStruct()
  EndStructure
  
  ;-
  Global NewList ParsePBObject.ParseStruct() 
  Global *this.ThisStruct = AllocateStructure(ThisStruct)
  
  Global Window_0, Canvas_0, winBackColor = $FFFFFF
  Global NewMap Widgets.i()
  Global *Widget._s_widget, *Parent._s_widget, x,y
  Global *Window._s_widget
  Global DragText.s, SubLevel.i, WE_Selecting
  
  
  ; point 
  If CreateImage(5, 600,600, 32,#PB_Image_Transparent) And StartDrawing(ImageOutput(5))
    DrawingMode(#PB_2DDrawing_AllChannels) 
    For x=0 To 600 Step 5
      For y=0 To 600 Step 5
        Line(x, y, 1,1, $FF000000)
      Next y
    Next x
    StopDrawing()
  EndIf
  
  Macro ULCase(String)
    InsertString(UCase(Left(String,1)), LCase(Right(String,Len(String)-1)), 2)
  EndMacro
  
  Procedure CO_Create(Type$, X, Y, Parent=-1)
    Protected GadgetList
    Protected Object, Position
    Protected Buffer.s, BuffType$, i.i, j.i
    
    With *this
      Select Type$
        Case "WindowGadget" : \Type\s.s = "WindowGadget"
        Case "Window" : \Type\s.s = "OpenWindow"
        Case "Menu", "ToolBar" : \Type\s.s = Type$
        Default 
          \Type\s.s=ULCase(Type$) + "Gadget"
          
          \Type\s.s = ReplaceString(\Type\s.s, "box","Box")
          \Type\s.s = ReplaceString(\Type\s.s, "link","Link")
          \Type\s.s = ReplaceString(\Type\s.s, "bar","Bar")
          \Type\s.s = ReplaceString(\Type\s.s, "area","Area")
          \Type\s.s = ReplaceString(\Type\s.s, "Ipa","IPA")
          
          \Type\s.s = ReplaceString(\Type\s.s, "view","View")
          \Type\s.s = ReplaceString(\Type\s.s, "icon","Icon")
          \Type\s.s = ReplaceString(\Type\s.s, "image","Image")
          \Type\s.s = ReplaceString(\Type\s.s, "combo","Combo")
          \Type\s.s = ReplaceString(\Type\s.s, "list","List")
          \Type\s.s = ReplaceString(\Type\s.s, "tree","Tree")
      EndSelect
      
      Protected *thisParse.ParseStruct = AddElement(ParsePBObject())
      If  *thisParse
        Restore Model 
        For i=1 To 1+33 ; gadget count
          For j=1 To 7  ; i.i count
            Read.s Buffer
            
            Select j
              Case 1  
                If \Type\s.s=Buffer
                  BuffType$ = Buffer
                EndIf
            EndSelect
            
            If BuffType$ = \Type\s.s
              Select j
                Case 1 
                  ParsePBObject()\Type\s.s=Buffer
                  If Buffer = "OpenWindow"
                    \Class\s.s=ReplaceString(Buffer, "Open","")+"_"
                  Else
                    \Class\s.s=ReplaceString(Buffer, "Gadget","")+"_"
                  EndIf
                  
                Case 2 : ParsePBObject()\Width\s.s=Buffer
                Case 3 : ParsePBObject()\Height\s.s=Buffer
                Case 4 : ParsePBObject()\Param1\s.s=Buffer
                Case 5 : ParsePBObject()\Param2\s.s=Buffer
                Case 6 : ParsePBObject()\Param3\s.s=Buffer
                Case 7 : ParsePBObject()\Flag\s.s=Buffer
              EndSelect
            EndIf
          Next  
          BuffType$ = ""
        Next  
        
        If \Flag\s.s
          ParsePBObject()\Flag\s.s = \Flag\s.s
        EndIf
        
        ;\Flag\i.i=CO_Flag(ParsePBObject()\Flag\s.s)
        \Class\s.s+\get(Str(Parent)+"_"+\Type\s.s)\Count
        \Caption\s.s = \Class\s.s
        
        ; Формируем имя объекта
        ParsePBObject()\Class\s.s = \Class\s.s
        If \get(Str(Parent))\Object\s.s
          \Object\s.s = \get(Str(Parent))\Object\s.s+"_"+\Class\s.s
          ;\Object\s.s = #Gadget$+Trim(Trim(Trim(Trim(\get(Str(Parent))\Object\s.s, "W"), "_"), "G"), "_")+"_"+\Class\s.s
        Else
          \Object\s.s = \Class\s.s
          ;\Object\s.s = #Window$+\Class\s.s
          ParsePBObject()\Flag\s.s="Flag"
        EndIf
        
        \X\i.i = X
        \Y\i.i = Y
        \Width\i.i = Val(ParsePBObject()\Width\s.s)
        \Height\i.i = Val(ParsePBObject()\Height\s.s)
        
        ParsePBObject()\X\s.s = Str(\X\i.i)
        ParsePBObject()\Y\s.s = Str(\Y\i.i)
        ParsePBObject()\Type\s.s = \Type\s.s
        ParsePBObject()\Object\s.s = \Object\s.s
        ParsePBObject()\Caption\s.s = \Caption\s.s
        
        If \Type\s.s = "SplitterGadget"      
          \Param1\i.i = *this\get(\Param1\s.s)\Object\i.i
          \Param2\i.i = *this\get(\Param2\s.s)\Object\i.i
        EndIf
        
        ParsePBObject()\Param1\s.s = \Param1\s.s
        ParsePBObject()\Param2\s.s = \Param2\s.s
        ParsePBObject()\Param3\s.s = \Param3\s.s
        ParsePBObject()\Param1\i.i = \Param1\i.i
        ParsePBObject()\Param2\i.i = \Param2\i.i
        ParsePBObject()\Param3\i.i = \Param3\i.i
        
        
        ; Загружаем выходной код
        If \Content\Text$=""
          Restore Content
          Read.s Buffer
          \Content\Text$ = Buffer
          \get(\Window\s.s)\Code("Code_Global")\Position = 16
          \get(\get(Str(Parent))\Object\s.s)\Code("Code_Object")\Position = 249+75+2
        EndIf
        
        ;CO_Insert(*ThisParse, Parent) 
        \Parent\i.i = Parent
      EndIf
      
      
    EndWith
    
    DataSection
      Model:
      ;{
      Data.s "WindowGadget","300","200","ParentID","0","0", "#PB_Window_SystemMenu"
      Data.s "OpenWindow","300","200","ParentID","0","0", "#PB_Window_SystemMenu"
      Data.s "ButtonGadget","80","20","0","0","0",""
      Data.s "StringGadget","80","20","0","0","0",""
      Data.s "TextGadget","80","20","0","0","0","#PB_Text_Border"
      Data.s "CheckBoxGadget","80","20","0","0","0",""
      Data.s "OptionGadget","80","20","0","0","0",""
      Data.s "ListViewGadget","150","150","0","0","0",""
      Data.s "FrameGadget","150","150","0","0","0",""
      Data.s "ComboBoxGadget","100","20","0","0","0",""
      Data.s "ImageGadget","120","120","0","0","0","#PB_Image_Border"
      Data.s "HyperLinkGadget","150","200","$0000FF","0","0",""
      Data.s "ContainerGadget","140","120","0","0","0", "#PB_Container_Flat"
      Data.s "ListIconGadget","180","180","0","0","0",""
      Data.s "IPAddressGadget","80", "20","0","0","0",""
      Data.s "ProgressBarGadget","80","20","0","0","0",""
      Data.s "ScrollBarGadget","80","20","0","0","0",""
      Data.s "ScrollAreaGadget","150","150","0","0","0",""
      Data.s "TrackBarGadget","180","150","0","0","0",""
      Data.s "WebGadget","100","20","0","0","0",""
      Data.s "ButtonImageGadget","20","20","0","0","0",""
      Data.s "CalendarGadget","150","200","0","0","0",""
      Data.s "DateGadget","80","20","0","0","0",""
      Data.s "EditorGadget","80","20","0","0","0",""
      Data.s "ExplorerListGadget","150","150","0","0","0",""
      Data.s "ExplorerTreeGadget","180","150","0","0","0",""
      Data.s "ExplorerComboGadget","100","20","0","0","0",""
      Data.s "SpinGadget","80","20","-1000","1000","0","#PB_Spin_Numeric"
      Data.s "TreeGadget","150","180","0","0","0",""
      Data.s "PanelGadget","140","120","0","0","0",""
      Data.s "SplitterGadget","180","100","0","0","0","#PB_Splitter_Separator"
      Data.s "MDIGadget","150","150","0","0","0",""
      Data.s "ScintillaGadget","180","150","0","0","0",""
      Data.s "ShortcutGadget","100","20","0","0","0",""
      Data.s "CanvasGadget","150","150","0","0","0",""
      ;}
      
      
      Content:
      ;{
      Data.s "EnableExplicit"+#CRLF$+
             ""+#CRLF$+
             "Declare Window_0_Events(Event.i)"+#CRLF$+
             ""+#CRLF$+
             "Procedure Window_0_CallBack()"+#CRLF$+
             "  Window_0_Events(Event())"+#CRLF$+
             "EndProcedure"+#CRLF$+
             ""+#CRLF$+
             "Procedure Window_0_Open(ParentID.i=0, Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered)"+#CRLF$+
             "  If IsWindow(Window_0)"+#CRLF$+
             "    SetActiveWindow(Window_0)"+#CRLF$+    
             "    ProcedureReturn Window_0"+#CRLF$+    
             "  EndIf"+#CRLF$+
             "  "+#CRLF$+  
             "  "+#CRLF$+  
             "  ProcedureReturn Window_0"+#CRLF$+
             "EndProcedure"+#CRLF$+
             ""+#CRLF$+
             "Procedure Window_0_Events(Event.i)"+#CRLF$+
             "  Select Event"+#CRLF$+
             "    Case #PB_Event_Gadget"+#CRLF$+
             "      Select EventType()"+#CRLF$+
             "        Case #PB_EventType_LeftClick"+#CRLF$+
             "          Select EventGadget()"+#CRLF$+
             "             "+#CRLF$+            
             "          EndSelect"+#CRLF$+
             "      EndSelect"+#CRLF$+
             "  EndSelect"+#CRLF$+
             "  "+#CRLF$+
             "  ProcedureReturn Event"+#CRLF$+
             "EndProcedure"+#CRLF$+
             ""+#CRLF$+
             "CompilerIf #PB_Compiler_IsMainFile"+#CRLF$+
             "  Window_0_Open()"+#CRLF$+
             "  "+#CRLF$+  
             "  While IsWindow(Window_0)"+#CRLF$+
             "    Define.i Event = WaitWindowEvent()"+#CRLF$+
             "    "+#CRLF$+
             "    Select EventWindow()"+#CRLF$+
             "      Case Window_0"+#CRLF$+
             "        If Window_0_Events( Event ) = #PB_Event_CloseWindow"+#CRLF$+
             "          CloseWindow(Window_0)"+#CRLF$+
             "          Break"+#CRLF$+
             "        EndIf"+#CRLF$+
             "        "+#CRLF$+
             "    EndSelect"+#CRLF$+
             "  Wend"+#CRLF$+
             "CompilerEndIf"
      ;}
      
    EndDataSection
    
  EndProcedure
  
  ;-
  Procedure.i Load_Widgets(Widget, Directory$)
    Protected ZipFile$ = Directory$ + "SilkTheme.zip"
    
    If FileSize(ZipFile$) < 1
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        ZipFile$ = #PB_Compiler_Home+"themes\SilkTheme.zip"
      CompilerElse
        ZipFile$ = #PB_Compiler_Home+"themes/SilkTheme.zip"
      CompilerEndIf
      If FileSize(ZipFile$) < 1
        MessageRequester("Designer Error", "Themes\SilkTheme.zip Not found in the current directory" +#CRLF$+ "Or in PB_Compiler_Home\themes directory" +#CRLF$+#CRLF$+ "Exit now", #PB_MessageRequester_Error|#PB_MessageRequester_Ok)
        End
      EndIf
    EndIf
    ;   Directory$ = GetCurrentDirectory()+"images/" ; "";
    ;   Protected ZipFile$ = Directory$ + "images.zip"
    
    
    If FileSize(ZipFile$) > 0
      UsePNGImageDecoder()
      
      CompilerIf #PB_Compiler_Version > 522
        UseZipPacker()
      CompilerEndIf
      
      Protected PackEntryName.s, ImageSize, *Image, Image, ZipFile
      ZipFile = OpenPack(#PB_Any, ZipFile$, #PB_PackerPlugin_Zip)
      
      If ZipFile  
        If ExaminePack(ZipFile)
          While NextPackEntry(ZipFile)
            
            PackEntryName.S = PackEntryName(ZipFile)
            ImageSize = PackEntrySize(ZipFile)
            If ImageSize
              *Image = AllocateMemory(ImageSize)
              UncompressPackMemory(ZipFile, *Image, ImageSize)
              Image = CatchImage(#PB_Any, *Image, ImageSize)
              PackEntryName.S = ReplaceString(PackEntryName.S,".png","")
              If PackEntryName.S="application_form" 
                PackEntryName.S="vd_windowgadget"
              EndIf
              
              PackEntryName.S = ReplaceString(PackEntryName.S,"page_white_edit","vd_scintillagadget")   ;vd_scintillagadget.png not found. Use page_white_edit.png instead
              
              Select PackEntryType(ZipFile)
                Case #PB_Packer_File
                  If Image
                    If FindString(Left(PackEntryName.S, 3), "vd_")
                      PackEntryName.S = ReplaceString(PackEntryName.S,"vd_"," ")
                      PackEntryName.S = Trim(ReplaceString(PackEntryName.S,"gadget",""))
                      
                      Protected Left.S = UCase(Left(PackEntryName.S,1))
                      Protected Right.S = Right(PackEntryName.S,Len(PackEntryName.S)-1)
                      PackEntryName.S = " "+Left.S+Right.S
                      
                      If FindString(LCase(PackEntryName.S), "cursor")
                        
                        ;Debug "add cursor"
                        AddItem(Widget, 0, PackEntryName.S, Image)
                        SetItemData(Widget, 0, Image)
                        
                        ;                   ElseIf FindString(LCase(PackEntryName.S), "window")
                        ;                     
                        ;                     Debug "add window"
                        ;                     AddItem(Widget, 1, PackEntryName.S, Image)
                        ;                     SetItemData(Widget, 1, Image)
                        
                      ElseIf FindString(LCase(PackEntryName.S), "buttonimage")
                      ElseIf FindString(LCase(PackEntryName.S), "window")
                        AddItem(Widget, -1, PackEntryName.S, Image)
                        SetItemData(Widget, CountItems(Widget)-1, Image)
                      ElseIf FindString(LCase(PackEntryName.S), "button")
                        AddItem(Widget, -1, PackEntryName.S, Image)
                        SetItemData(Widget, CountItems(Widget)-1, Image)
                      ElseIf FindString(LCase(PackEntryName.S), "container")
                        AddItem(Widget, -1, PackEntryName.S, Image)
                        SetItemData(Widget, CountItems(Widget)-1, Image)
                      ElseIf FindString(LCase(PackEntryName.S), "panel")
                        AddItem(Widget, -1, PackEntryName.S, Image)
                        SetItemData(Widget, CountItems(Widget)-1, Image)
                      ElseIf FindString(LCase(PackEntryName.S), "scrollarea")
                        AddItem(Widget, -1, PackEntryName.S, Image)
                        SetItemData(Widget, CountItems(Widget)-1, Image)
                      EndIf
                    EndIf
                  EndIf    
              EndSelect
              
              FreeMemory(*Image)
            EndIf
          Wend  
        EndIf
        
        ClosePack(ZipFile)
      EndIf
    EndIf
  EndProcedure
  
  Procedure.s Help_Widgets(Class.s)
    Protected Result.S
    
    Select LCase(Trim(Class.s))
      Case "window"
        Result.S = "Это окно (Window)"
        
      Case "cursor"
        Result.S = "Это курсор"
        
      Case "scintilla"
        Result.S = "Это редактор (Scintilla)"
        
      Case "button"
        Result.S = "Это кнопка (Button)"
        
      Case "buttonimage"
        Result.S = "Это кнопка картинка (ButtonImage)"
        
      Case "checkbox"
        Result.S = "Это переключатель (CheckBox)"
        
      Case "container"
        Result.S = "Это контейнер для других элементов (Container)"
        
      Case "combobox"
        Result.S = "Это выподающий список (ComboBox)"
        
      Default
        Result.S = "Подсказка еще не реализованно"
        
    EndSelect
    
    ProcedureReturn Result.S
  EndProcedure
  
  Procedure.s Help_Properties(Class.s)
    Protected Result.S
    
    Select Trim(Class.s, ":")
      Case "Text"
        Result.S = "Это надпись на виджете"
        
      Case "X"
        Result.S = "Это позиция по оси X"
        
      Case "Y"
        Result.S = "Это позиция по оси Y"
        
      Case "Width"
        Result.S = "Это ширина виджета"
        
      Case "Height"
        Result.S = "Это высота виджета"
        
      Default
        Result.S = "Подсказка еще не реализованно"
        
    EndSelect
    
    ProcedureReturn Result.S
  EndProcedure
  
  ;-
  Procedure Add_Code(Value.i, Position.i, SubLevel)
    Static OpenList, lastValue.i
    
    Protected Code.s = ""+
                       Code.s + GetClass(Value)+
                       Code.s + "( "+Str(Position)+
                       Code.s + ", "+Str(X(Value))+
                       Code.s + ", "+Str(Y(Value))+
                       Code.s + ", "+Str(Width(Value))+
                       Code.s + ", "+Str(Height(Value))+
                       Code.s + ", "+GetText(Value)+
                       ; Code.s + ", "+GetFlag(Value)
                       Code.s + ")"
    
    
    ;     If OpenList = GetParent(Value)
    ;       AddItem(Widgets("Code"), Position+1, "CloseList()" )
    ;     EndIf
    ;     
    ;     
    ;     If OpenList
    ;       Position + 1
    ;     EndIf
    
    If IsContainer(Value) > 0 ; And GetType(Value) <> #__type_window
      Debug "pos "+ Position + " "+ SubLevel
      ; OpenList = GetParent(Value)
      AddItem(Widgets("Code"), Position, Code.s )
      AddItem(Widgets("Code"), -1, "CloseList()" )
    Else
      AddItem(Widgets("Code"), Position, Code.s )
      Debug  ""+Position+ " "+ SubLevel
    EndIf
    
    lastValue = Value
  EndProcedure
  
  Procedure properties_update(Value.i)
    ;     SetState(Widgets("Inspector"), GetData(Value))
    ;     SetGadgetState(WE_Selecting, GetData(Value))
    
    SetItemText(Widgets("Properties"), 1, Str(Value))
    SetItemText(Widgets("Properties"), 2, GetClass(Value)+"_"+GetCount(Value))
    SetItemText(Widgets("Properties"), 3, GetText(Value))
    SetItemText(Widgets("Properties"), 5, Str(X(Value)))
    SetItemText(Widgets("Properties"), 6, Str(Y(Value)))
    SetItemText(Widgets("Properties"), 7, Str(Width(Value)))
    SetItemText(Widgets("Properties"), 8, Str(Height(Value)))
  EndProcedure
  
  Procedure GetPos_inspector(*this, SubLevel)
    Protected Tree = Widgets("Inspector")
    Protected i, Position = 1 ; Начальная позиция
    Protected CountItems = CountItems(Tree)
    ; Protected SubLevel = GetLevel(*This)
    
    For i = 0 To CountItems - 1
      If *this = GetItemData(Tree, i) 
        ; SubLevel = GetItemAttribute(Tree, i, #PB_Tree_SubLevel) + 1
        Position = (i+1)
        Break
      EndIf
    Next 
    
    For i = Position To CountItems - 1
      If SubLevel > GetItemAttribute(Tree, i, #PB_Tree_SubLevel) 
        Break
      Else
        SetData( GetItemData(Tree, i), i)
        
        Position = (i+1)
      EndIf
    Next 
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure AddPos_inspector(*this._s_widget, Class.s)
    Protected Tree = Widgets("Inspector")
    Protected Parent = GetParent(*this)
    Protected SubLevel = GetLevel(Parent)
    Protected Position = GetPos_inspector(Parent, SubLevel)
    ; Protected Class.s = GetClass(*This) +"_"+ GetCount(*This)
    
    AddItem(Tree, Position, Class.s, #PB_Default, SubLevel)
    SetItemData(Tree, Position, *this)
    SetState(Tree, Position)
    SetItemState(Tree, Position, #PB_Tree_Selected)
    
    AddGadgetItem(WE_Selecting, Position, Class.s, 0, SubLevel )
    SetGadgetItemData(WE_Selecting, Position, *this)
    SetGadgetState(WE_Selecting, Position) ; Bug
    SetGadgetItemState(WE_Selecting, Position, #PB_Tree_Selected)
    
    SetData(*this, Position)
    Add_Code(*this, Position-1, SubLevel)
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure.i Add_Widget(*parent._s_widget, Type, X=0,Y=0,Width=0,Height=0)
    Static X1, Y1
    Protected Position =- 1
    Protected *this._s_widget, Class.s
    
    If Not X
      x=x1
    EndIf
    
    If Not Y
      y=y1
    EndIf
    
    Select Type
      Case #__type_window    
        If Not Width
          Width=350
        EndIf
        
        If Not Height
          Height=200
        EndIf
        
      Case #PB_GadgetType_Container, #PB_GadgetType_ScrollArea, #PB_GadgetType_Panel, 
           #PB_GadgetType_Splitter, #PB_GadgetType_ListView, #PB_GadgetType_ListIcon, #PB_GadgetType_Image 
        
        If Not Width
          Width=220
        EndIf
        
        If Not Height
          Height=140
        EndIf
        
      Default
        If Not Width : Width=100 : EndIf
        If Not Height : Height=30 : EndIf
        
    EndSelect
    
    If *parent
      OpenList(*parent, 0)
    EndIf
    
    Select Type
      Case #__type_window     : *this = Window(10,10,Width+1,Height+1, "", #__flag_AnchorsGadget, *parent)
      Case #PB_GadgetType_Panel      : *this = Panel(X,Y,Width,Height, #__flag_AnchorsGadget)
      Case #PB_GadgetType_Container  : *this = Container(X,Y,Width,Height, #__flag_AnchorsGadget)
      Case #PB_GadgetType_ScrollArea : *this = ScrollArea(X,Y,Width,Height, 100, 100, 1, #__flag_AnchorsGadget)
      Case #PB_GadgetType_Button     : *this = Button(X,Y,Width,Height, "", #__flag_AnchorsGadget)
    EndSelect
    
    If *this\container
      SetImage(*this, 5)
      : X1 = 0 : Y1 = 0 
    EndIf
    
    X1 + 10
    Y1 + 10
    
    If *this
      Class.s = GetClass(*this)+"_"+GetCount(*this)
      SetText(*this, Class.s)
      
      AddPos_inspector(*this, Class.s)
      
      If SetAnchors(*this)
        properties_update(*this)
      EndIf
    EndIf
    
    If *parent : CloseList() : EndIf
    
    ProcedureReturn *this
  EndProcedure
  
  ;-
  Procedure.i GetSelectorX(*this._s_widget)
    ProcedureReturn Root()\anchor\x-*this\X[2]
  EndProcedure
  
  Procedure.i GetSelectorY(*this._s_widget)
    ProcedureReturn Root()\anchor\y-*this\Y[2]
  EndProcedure
  
  Procedure.i GetSelectorWidth(*this._s_widget)
    ProcedureReturn Root()\anchor\Width
  EndProcedure
  
  Procedure.i GetSelectorHeight(*this._s_widget)
    ProcedureReturn Root()\anchor\Height
  EndProcedure
  
  Procedure.i FreeSelector(*this._s_widget)
    *this\Root\anchor = 0
  EndProcedure
  
  Procedure.i SetSelector(*this._s_widget)
    *this\Root\anchor = AllocateStructure(_s_anchor)
  EndProcedure
  
  Procedure.i UpdateSelector(*this._s_widget)
    Protected MouseX, MouseY, DeltaX, DeltaY
    
    If *this And Not *this\Root\anchor And GetButtons(*this)
      *this\Root\anchor = AllocateStructure(_s_anchor)
    EndIf
    
    If *this And *this\Root\anchor
      MouseX = GetMouseX(*this)
      MouseY = GetMouseY(*this)
      ;       MouseX = *Value\Canvas\Mouse\X
      ;       MouseY = *Value\Canvas\Mouse\Y
      
      DeltaX = GetDeltaX(*this)
      DeltaY = GetDeltaY(*this)
      
      If GetDeltaX(*this) > GetMouseX(*this)
        DeltaX = GetMouseX(*this)
        MouseX = GetDeltaX(*this)
      EndIf
      
      If GetDeltaY(*this) > GetMouseY(*this)
        DeltaY = GetMouseY(*this)
        MouseY = GetDeltaY(*this)
      EndIf
      
      *this\Root\anchor\X = *this\X[2]+DeltaX
      *this\Root\anchor\Y = *this\Y[2]+DeltaY
      *this\Root\anchor\Width = MouseX-DeltaX
      *this\Root\anchor\Height = MouseY-DeltaY
      
      ReDraw(*this\Root)
    EndIf
    
    If *this\root\mouse\Drag
      ProcedureReturn *this
    EndIf
    
  EndProcedure
  
  
  ;-
  Procedure Widgets_Events(EventWidget.i, EventType.i, EventItem.i, EventData.i)
    Protected *this._s_widget, MouseX, MouseY, DeltaX, DeltaY
    Static Drag.i
    
    ; Protected EventWidget = EventWidget()
    ; Protected EventType = WidgetEvent()
    ; Protected EventItem = GetState(EventWidget)))
    
    Select EventWidget
      Case Widgets("Properties") 
        Select EventType 
          Case #PB_EventType_StatusChange
            SetText(Widgets("Properties_info"), Help_Properties(GetItemText(EventWidget, EventItem)))
            
        EndSelect
        
      Case Widgets("Widgets") 
        Select EventType
          Case #PB_EventType_LeftClick
            DragText = GetItemText(EventWidget, EventItem) 
            
          Case #PB_EventType_DragStart
            DragText = GetItemText(EventWidget, EventItem) 
            ; DragText(GetItemText(EventWidget, EventItem))
            ; SetItemAttribute(Widgets("Inspector_panel"), GetState(Widgets("Inspector_panel")), #PB_Button_Image, GetItemData(EventWidget, EventItem))
            
          Case #PB_EventType_StatusChange
            SetText(Widgets("Widgets_info"), Help_Widgets(GetItemText(EventWidget, EventItem)))
            SetItemAttribute(Widgets("Panel"), GetState(Widgets("Panel")), #PB_Button_Image, GetItemData(EventWidget, EventItem))
            
        EndSelect
        
      Case Widgets("Inspector") 
        Select EventType
          Case #PB_EventType_Change
            *this = GetItemData(EventWidget, GetState(EventWidget))
            
            If *this And SetAnchors(*this)
              Debug "изменено "+ GetState(EventWidget)
              SetGadgetState(WE_Selecting, GetState(EventWidget))
              properties_update(*this)
            EndIf
            
        EndSelect
        
      Default
        
        Select EventType 
          Case #PB_EventType_MouseMove
            If Drag
              If Not UpdateSelector(Drag)
                Drag = 0
              EndIf
            EndIf
            
          Case #PB_EventType_LeftButtonUp
            *this = GetAnchors(EventWidget)
            
            If *this
              Debug "изменено up "+ *this
              
              If DragText
                If Drag
                  Add_Widget(*this, Type(DragText), GetSelectorX(*this), GetSelectorY(*this), GetSelectorWidth(*this), GetSelectorHeight(*this)) ; DeltaX, DeltaY, MouseX-DeltaX, MouseY-DeltaY)
                  
                  FreeSelector(*this)
                  Drag = 0
                Else
                  
                  Add_Widget(*this, Type(DragText), GetMouseX(*this), GetMouseY(*this))
                  
                EndIf
                
                DragText = ""
              Else
                properties_update(*this)
              EndIf
            EndIf
            
          Case #PB_EventType_LeftButtonDown
            *this = GetAnchors(EventWidget)
            
            If *this   
              If DragText
                Drag = *this ; SetSelector(*This)
              Else
                If SetAnchors(*this)
                  Debug "изменено down"+ *this
                  SetState(Widgets("Inspector"), GetData(*this))
                  SetGadgetState(WE_Selecting, GetData(*this))
                  properties_update(*this)
                EndIf
              EndIf
            EndIf
            
          Case #PB_EventType_LeftClick
            Select EventWidget
              Case Widgets("Button_1")
                Debug 7777777
;                 *Window = Popup(EventWidget, #PB_Ignore,#PB_Ignore,280,130)
;                 
;                 OpenList(*Window)
;                 Widgets("Widgets_0") = Tree(0, 0, 280, 130, #__flag_NoButtons|#__flag_NoLines)
;                 Load_Widgets(Widgets("Widgets_0"), GetCurrentDirectory()+"Themes/")
;                 SetState(Widgets("Widgets_0"), 1)
;                 CloseList()
                
                ; Draw_Popup(*Window)
            EndSelect
            
        EndSelect
        
    EndSelect
    
  EndProcedure
  
  ;-
  Procedure Window_0_Resize()
    ResizeGadget(Canvas_0, #PB_Ignore, #PB_Ignore, WindowWidth(Window_0)-20, WindowHeight(Window_0)-50)
  EndProcedure
  
  Procedure Window_0_Open(x = 0, y = 0, width = 800, height = 600)
    Window_0 = OpenWindow(#PB_Any, x, y, width, height, "", #PB_Window_SystemMenu|#PB_Window_SizeGadget)
    BindEvent(#PB_Event_SizeWindow, @Window_0_Resize(), Window_0)
    
    WE_Selecting = TreeGadget(#PB_Any, 800-150, 40, 140, 550, #PB_Tree_AlwaysShowSelection) : AddGadgetItem(WE_Selecting, -1, "Proect")
    
    If Open(Window_0, 10, 40, 630, 550);, "IDE") ;+200
      Canvas_0 = GetGadget(Root())
      
;       ; Main panel
;       Widgets("Panel") = Panel(0, 0, 0, 0, #__flag_AutoSize) 
;       
;       ; panel tab new forms
;       AddItem(Widgets("Panel"), -1, "Form")
      Widgets("MDI") = ScrollArea(0, 0, 0, 0, 0, 780, 550, #__flag_AutoSize) : CloseList()
      
      
;       ; panel tab code
;       AddItem(Widgets("Panel"), -1, "Code")
;       Widgets("Code") = Text(0, 0, 180, 230, "Тут будут строки кода", #__Flag_AutoSize)
      Widgets("Code") = Tree(0, 0, 180, 230, #__flag_AutoSize)
;       CloseList()
      
      Widgets("Panel") = Splitter(0, 0, 780, 550, Widgets("MDI"),Widgets("Code"))
      
      ;{- inspector 
      ; create tree inspector
      Widgets("Inspector") = Tree(0, 0, 80, 30)
      AddItem(Widgets("Inspector"), -1, "Proect")
      
      ; create panel widget
      Widgets("Inspector_panel") = Panel(0, 0, 0, 0) 
      
      ; Panel tab "widgets"
      AddItem(Widgets("Inspector_panel"), -1, "Widgets")
      Widgets("Widgets") = Tree(0, 0, 80, 30, #__flag_NoButtons|#__flag_NoLines)
      Load_Widgets(Widgets("Widgets"), GetCurrentDirectory()+"Themes/")
      SetState(Widgets("Widgets"), 1)
      Widgets("Widgets_info") = Text(0, 0, 80, 30, "Тут будет инфо о виджете")
      Widgets("Widgets_splitter") = Splitter(1,1,778, 548, Widgets("Widgets"), Widgets("Widgets_info"), #__flag_AutoSize)
      SetState(Widgets("Widgets_splitter"), 450)
      
      ; Panel tab "properties"
      AddItem(Widgets("Inspector_panel"), -1, "Properties")
      Widgets("Properties") = Tree(0, 0, 150, 30, #__flag_AutoSize) ;   , 70
      ; SetColor(Widgets("Properties"))
      
      AddItem(Widgets("Properties"), -1, " Общее", -1, 0)
      AddItem(Widgets("Properties"), -1, "String Handle ", -1, 1)
      AddItem(Widgets("Properties"), -1, "String Class ", -1, 1)
      AddItem(Widgets("Properties"), -1, "String Text ", -1, 1)
      AddItem(Widgets("Properties"), -1, " Координаты", -1, 0)
      AddItem(Widgets("Properties"), -1, "Spin X 0|100", -1, 1)
      AddItem(Widgets("Properties"), -1, "Spin Y 0|200", -1, 1)
      AddItem(Widgets("Properties"), -1, "Spin Width 0|100", -1, 1)
      AddItem(Widgets("Properties"), -1, "Spin Height 0|200", -1, 1)
      AddItem(Widgets("Properties"), -1, " Поведение", -1, 0)
      AddItem(Widgets("Properties"), -1, "Button Puch C:\as\img\image.png", -1, 1)
      AddItem(Widgets("Properties"), -1, "ComboBox Disable True|False", -1, 1)
      AddItem(Widgets("Properties"), -1, "ComboBox Flag #_Event_Close|#_Event_Size|#_Event_Move", -1, 1)
      Widgets("Properties_info") = Text(0, 0, 80, 30, "Тут будет инфо о свойстве")
      Widgets("Properties_splitter") = Splitter(1,1,778, 548, Widgets("Properties"), Widgets("Properties_info"), #__flag_AutoSize)
      SetState(Widgets("Properties_splitter"), 450)
      
      ; Panel tab "events"
      AddItem(Widgets("Inspector_panel"), -1, "Events")
      Widgets("Events") = Text(0, 60, 180, 30, "Тут будет событие элементов", #__flag_AutoSize)
      Widgets("Events_info") = Text(0, 0, 80, 30, "Тут будет инфо о событии")
      Widgets("Events_splitter") = Splitter(1,1,778, 548, Widgets("Events"), Widgets("Events_info"), #__flag_AutoSize)
      SetState(Widgets("Events_splitter"), 450)
      CloseList()
      
      Widgets("Inspector_splitter") = Splitter(1,1,778, 548, Widgets("Inspector"), Widgets("Inspector_panel"))
      ;}
      
      Widgets("Splitter") = Splitter(1,1,778, 548, Widgets("Panel"), Widgets("Inspector_splitter"), #PB_Splitter_Vertical|#__flag_AutoSize)
      
      SetState(Widgets("Inspector_splitter"), 250)
      SetState(Widgets("Splitter"), 550)
    EndIf
    
    Define *n=Add_Widget(Widgets("MDI"), #__type_window)
    Define *c1=Add_Widget(*n, #PB_GadgetType_Container, 50, 5, 200, 90)
;     Define *c2=Add_Widget(*n, #PB_GadgetType_Container, 50, 105, 200, 90)
     Add_Widget(*c1, #PB_GadgetType_Button)
;     Add_Widget(*c2, #PB_GadgetType_Button)
;     Add_Widget(*c1, #PB_GadgetType_Button)
;     Add_Widget(*c2, #PB_GadgetType_Button)
;     Add_Widget(*c1, #PB_GadgetType_Button)
;     Add_Widget(*c2, #PB_GadgetType_Button)
     Add_Widget(*n, #PB_GadgetType_Button, 210, 75, 100, 50)
    ; ;     ;CloseList()
    
    ; Widgets events callback
    Bind(#PB_All, @Widgets_Events())
    ReDraw(Root())
  EndProcedure
  
  Procedure Window_0_Events(event)
    Select event
      Case #PB_Event_CloseWindow
        ProcedureReturn #False
        
      Case #PB_Event_Menu
        Select EventMenu()
        EndSelect
        
      Case #PB_Event_Gadget
        Select EventGadget()
        EndSelect
    EndSelect
    
    ProcedureReturn #True
  EndProcedure
  
  Window_0_Open()
  
  Repeat
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        Break
      Case #PB_Event_Gadget
        Select EventType()
          Case #PB_EventType_Change
            *this = GetGadgetItemData(EventGadget(), GetGadgetState(EventGadget()))
            
            If *this And SetAnchors(*this)
              ; Debug "  изменено "+ GetGadgetState(EventGadget())
              SetState(Widgets("Inspector"), GetGadgetState(EventGadget()))
              properties_update(*this)
              ReDraw(GetRoot(*this))
            EndIf
            
        EndSelect
    EndSelect
  ForEver
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = f------------0-----
; EnableXP