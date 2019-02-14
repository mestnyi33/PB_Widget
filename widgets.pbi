﻿;
;  ^^
; (oo)\__________
; (__)\          )\/\
;      ||------w||
;      ||       ||
;

DeclareModule Widget
  EnableExplicit
  #Anchors = 9
  
  
  ;- - STRUCTUREs
  ;- - Mouse_S
  Structure Mouse_S
    X.i
    Y.i
    at.i ; at point widget
    Wheel.i ; delta
    Buttons.i ; state
    *Delta.Mouse_S
  EndStructure
  
  ;- - Canvas_S
  Structure Canvas_S
    Mouse.Mouse_S
    Gadget.i[3]
    Window.i
    *Widget.Widget_S
    
    Input.c
    Key.i[2]
  EndStructure
  
  ;- - Coordinate_S
  Structure Coordinate_S
    y.i[4]
    x.i[4]
    height.i[4]
    width.i[4]
  EndStructure
  
  ;- - Box_S
  Structure Box_S Extends Coordinate_S
    Size.i[4]
    Hide.b[4]
    Checked.b[2] 
    ;Toggle.b
    
    ArrowSize.a[3]
    ArrowType.b[3]
    
    ThreeState.b
    *Color.Color_S[4]
  EndStructure
  
  ;- - Color_S
  Structure Color_S
    State.b ; entered; selected; focused; lostfocused
    Front.i[4]
    Line.i[4]
    Fore.i[4]
    Back.i[4]
    Frame.i[4]
    Alpha.a[2]
  EndStructure
  
  ;- - Page_S
  Structure Page_S
    Pos.i
    len.i
  EndStructure
  
  ;- - Align_S
  Structure Align_S
    X.i
    y.i
    x1.i
    y1.i
    Left.b
    Top.b
    Right.b
    Bottom.b
    Vertical.b
    Horizontal.b
  EndStructure
  
  
  ;- - WindowFlag_S
  Structure WindowFlag_S
    SystemMenu.b     ; 13107200   - #PB_Window_SystemMenu      ; Enables the system menu on the Window Title bar (Default).
    MinimizeGadget.b ; 13238272   - #PB_Window_MinimizeGadget  ; Adds the minimize Gadget To the Window Title bar. #PB_Window_SystemMenu is automatically added.
    MaximizeGadget.b ; 13172736   - #PB_Window_MaximizeGadget  ; Adds the maximize Gadget To the Window Title bar. #PB_Window_SystemMenu is automatically added.
    SizeGadget.b     ; 12845056   - #PB_Window_SizeGadget      ; Adds the sizeable feature To a Window.
    Invisible.b      ; 268435456  - #PB_Window_Invisible       ; Creates the Window but don't display.
    TitleBar.b       ; 12582912   - #PB_Window_TitleBar        ; Creates a Window With a titlebar.
    Tool.b           ; 4          - #PB_Window_Tool            ; Creates a Window With a smaller titlebar And no taskbar entry. 
    BorderLess.b     ; 2147483648 - #PB_Window_BorderLess      ; Creates a Window without any borders.
    ScreenCentered.b ; 1          - #PB_Window_ScreenCentered  ; Centers the Window in the middle of the screen. X,Y parameters are ignored.
    WindowCentered.b ; 2          - #PB_Window_WindowCentered  ; Centers the Window in the middle of the Parent Window ('ParentWindowID' must be specified).
                     ;                X,Y parameters are ignored.
    Maximize.b       ; 16777216   - #PB_Window_Maximize        ; Opens the Window maximized. (Note  ; on Linux, Not all Windowmanagers support this)
    Minimize.b       ; 536870912  - #PB_Window_Minimize        ; Opens the Window minimized.
    NoGadgets.b      ; 8          - #PB_Window_NoGadgets       ; Prevents the creation of a GadgetList. UseGadgetList() can be used To do this later.
    NoActivate.b     ; 33554432   - #PB_Window_NoActivate      ; Don't activate the window after opening.
  EndStructure
  
  ;- - Flag_S
  Structure Flag_S
    Window.WindowFlag_S
    InLine.b
    Lines.b
    Buttons.b
    GridLines.b
    CheckBoxes.b
    FullSelection.b
    AlwaysSelection.b
    MultiSelect.b
    ClickSelect.b
  EndStructure
  
  ;- - Image_S
  Structure Image_S
    y.i[3]
    x.i[3]
    height.i
    width.i
    
    Index.i
    ImageID.i
    Change.b
    
    Align.Align_S
  EndStructure
  
  ;- - Text_S
  Structure Text_S Extends Coordinate_S
    ;Big.i[3]
    Pos.i
    Len.i
    Caret.i[3] ; 0 = Pos ; 1 = PosFixed
    
    FontID.i
    String.s[3]
    Change.b
    
    Lower.b
    Upper.b
    Pass.b
    Editable.b
    Numeric.b
    MultiLine.b
    Vertical.b
    Rotate.f
    
    Align.Align_S
  EndStructure
  
  ;- - Bar_S
  Structure Bar_S Extends Coordinate_S
    *Window.Widget_S ; adress window
    *Parent.Widget_S ; adress parent
    *s.Scroll_S      ; 
    
    *SplitterFirst.Widget_S
    *SplitterSecond.Widget_S
    First.i
    Second.i
    
    Ticks.b  ; track bar
    Smooth.b ; progress bar
    
    ;     StructureUnion
    ;     EndStructureUnion
    
    at.b
    Type.b[3] ; [2] for splitter
    Radius.a
    Cursor.i[2]
    
    Max.i
    Min.l
    *Step
    Hide.b[2]
    *Box.Box_S
    
    Focus.b
    Change.i[2]
    Resize.b
    Vertical.b
    Inverted.b
    Direction.i
    
    Page.Page_S
    Area.Page_S
    Thumb.Page_S
    Color.Color_S[4]
  EndStructure
  
  ;- - Scroll_S
  Structure Scroll_S
    y.i
    x.i
    height.i
    width.i
    
    *v.Widget_S
    *h.Widget_S
  EndStructure
  
  ;- - Items_S
  Structure Items_S Extends Coordinate_S
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    *a.Items_S
    Drawing.i
    
    Image.Image_S
    Text.Text_S[4]
    *Box.Box_S
    
    State.b
    Hide.b[2]
    Caret.i[3]  ; 0 = Pos ; 1 = PosFixed
    Vertical.b
    Radius.a
    
    change.b
    sublevel.i
    sublevellen.i
    
    childrens.i
    *data      ; set/get item data
  EndStructure
  
  ;- - Widget_S
  Structure Widget_S Extends Bar_S
    index.i[3]  ; Index[0] of new list element ; inex[1]-entered ; index[2]-selected
    adress.i
    Drawing.i
    Container.i
    CountItems.i[2]
    Interact.i
    
    State.i
    o_i.i ; parent opened item
    p_i.i ; index parent tab item
    *a.Items_S
    *data
    
    *Deactive.Widget_S
    
    *Popup.Widget_S
    *anchor.Anchor_S[#Anchors+1]
    *OptionGroup.Widget_S
    
    fs.i 
    bs.i
    Grid.i
    Enumerate.i
    TabHeight.i
    
    
    List *Childrens.Widget_S()
    List *Items.Items_S()
    List *Columns.Widget_S()
    ;List *Draws.Items_S()
    
    Flag.Flag_S
    *Text.Text_S[4]
    *Image.Image_S[2]
    clip.Coordinate_S
    *Align.Align_S
    
    sublevellen.i
    Drag.i[2]
    Attribute.i
    Canvas.Canvas_S
    repaint.i
  EndStructure
  
  ;- - Anchor_S
  Structure Anchor_S
    X.i[2] ; [1] - delta_x
    Y.i[2] ; [1] - delta_y
    Width.i
    Height.i
    
    Pos.i ; anchor position on the widget
    State.i ; mouse state 
    Cursor.i[2]
    
    Color.Color_S[4]
  EndStructure
  
  ;- - Default_S
  Structure Default_S
    Canvas.Canvas_S
    Type.i
    Event.i
    *Function
    *This.Widget_S
    *Last.Widget_S
    
    *Active.Widget_S
    *Focus.Widget_S
  EndStructure
  
  
  
  ;-
  ;- - DECLAREs CONSTANTs
  ;{
  Enumeration #PB_Event_FirstCustomValue
    #PB_Event_Widget
  EndEnumeration
  
  Enumeration #PB_EventType_FirstCustomValue
    CompilerIf #PB_Compiler_Version<547 : #PB_EventType_Resize : CompilerEndIf
    
    #PB_EventType_Free
    #PB_EventType_Create
    
    #PB_EventType_Repaint
    #PB_EventType_ScrollChange
  EndEnumeration
  
  ;   EnumerationBinary (#PB_Window_BorderLess<<1)
  ;     #PB_Window_Transparent 
  ;     #PB_Window_Flat
  ;     #PB_Window_Single
  ;     #PB_Window_Double
  ;     #PB_Window_Raised
  ;     #PB_Window_MoveGadget
  ;     #PB_Window_CloseGadget
  ;   EndEnumeration
  ;   
  ;   EnumerationBinary (#PB_Container_Double<<1)
  ;     #PB_Container_Transparent 
  ;   EndEnumeration
  ;   
  ;   EnumerationBinary (#PB_Gadget_ActualSize<<1)
  ;     #PB_Gadget_Left   
  ;     #PB_Gadget_Top    
  ;     #PB_Gadget_Right  
  ;     #PB_Gadget_Bottom 
  ;     
  ;     #PB_Gadget_VCenter
  ;     #PB_Gadget_HCenter
  ;     #PB_Gadget_Full
  ;     #PB_Gadget_Center = (#PB_Gadget_HCenter|#PB_Gadget_VCenter)
  ;   EndEnumeration
  
  ;   Enumeration - 7 ; Type
  ;     #_Type_Message
  ;     #_Type_PopupMenu
  ;     #_Type_Desktop
  ;     #_Type_StatusBar
  ;     #_Type_Menu           ;  "Menu"
  ;     #_Type_Toolbar        ;  "Toolbar"
  ;     #_Type_Window         ;  "Window"
  ;     #_Type_Unknown        ;  "Create" 0
  ;     #_Type_Button         ;  "Button"
  ;     #_Type_String         ;  "String"
  ;     #_Type_Text           ;  "Text"
  ;     #_Type_CheckBox       ;  "CheckBox"
  ;     #_Type_Option         ;  "Option"
  ;     #_Type_ListView       ;  "ListView"
  ;     #_Type_Frame          ;  "Frame"
  ;     #_Type_ComboBox       ;  "ComboBox"
  ;     #_Type_Image          ;  "Image"
  ;     #_Type_HyperLink      ;  "HyperLink"
  ;     #_Type_Container      ;  "Container"
  ;     #_Type_ListIcon       ;  "ListIcon"
  ;     #_Type_IPAddress      ;  "IPAddress"
  ;     #_Type_ProgressBar    ;  "ProgressBar"
  ;     #_Type_ScrollBar      ;  "ScrollBar"
  ;     #_Type_ScrollArea     ;  "ScrollArea"
  ;     #_Type_TrackBar       ;  "TrackBar"
  ;     #_Type_Web            ;  "Web"
  ;     #_Type_ButtonImage    ;  "ButtonImage"
  ;     #_Type_Calendar       ;  "Calendar"
  ;     #_Type_Date           ;  "Date"
  ;     #_Type_Editor         ;  "Editor"
  ;     #_Type_ExplorerList   ;  "ExplorerList"
  ;     #_Type_ExplorerTree   ;  "ExplorerTree"
  ;     #_Type_ExplorerCombo  ;  "ExplorerCombo"
  ;     #_Type_Spin           ;  "Spin"
  ;     #_Type_Tree           ;  "Tree"
  ;     #_Type_Panel          ;  "Panel"
  ;     #_Type_Splitter       ;  "Splitter"
  ;     #_Type_MDI           
  ;     #_Type_Scintilla      ;  "Scintilla"
  ;     #_Type_Shortcut       ;  "Shortcut"
  ;     #_Type_Canvas         ;  "Canvas"
  ;     
  ;     #_Type_ImageButton    ;  "ImageButton"
  ;     #_Type_Properties     ;  "Properties"
  ;     
  ;     #_Type_StringImageButton    ;  "ImageButton"
  ;     #_Type_StringButton         ;  "ImageButton"
  ;     #_Type_AnchorButton         ;  "ImageButton"
  ;     #_Type_ComboButton          ;  "ImageButton"
  ;     #_Type_DropButton           ;  "ImageButton"
  ;     
  ;   EndEnumeration
  
  #PB_GadgetType_Popup =- 10
  #PB_GadgetType_Property = 40
  #PB_GadgetType_Window =- 1
  ;
  #PB_Bar_Minimum = 1
  #PB_Bar_Maximum = 2
  #PB_Bar_PageLength = 3
  
  #PB_Bar_NoButtons = 5
  #PB_Bar_Direction = 6
  
  EnumerationBinary 4
    #PB_Bar_Smooth 
    #PB_Bar_Inverted 
    #PB_Bar_Ticks 
  EndEnumeration
  
  #PB_Flag_NoButtons = #PB_Tree_NoButtons                     ; 2 1 Hide the '+' node buttons.
  #PB_Flag_NoLines = #PB_Tree_NoLines                         ; 1 2 Hide the little lines between each nodes.
  #PB_Flag_CheckBoxes = #PB_Tree_CheckBoxes                   ; 4 256 Add a checkbox before each Item.
                                                              ; #PB_Flag_ThreeState = #PB_Tree_ThreeState                   ; 8 65535 The checkboxes can have an "in between" state.
  
  
  #PB_Widget_First = 1<<7
  #PB_Widget_Second = 1<<8
  #PB_Widget_FirstFixed = 1<<9
  #PB_Widget_SecondFixed = 1<<10
  #PB_Widget_FirstMinimumSize = 1<<11
  #PB_Widget_SecondMinimumSize = 1<<12
  
  EnumerationBinary WidgetFlags
    #PB_Center
    #PB_Right
    #PB_Left = 4
    #PB_Top
    #PB_Bottom
    #PB_Vertical 
    #PB_Horizontal
    
    #PB_Toggle
    #PB_BorderLess
    
    #PB_Text_Numeric
    #PB_Text_ReadOnly
    #PB_Text_LowerCase 
    #PB_Text_UpperCase
    #PB_Text_Password
    #PB_Text_WordWrap
    #PB_Text_MultiLine 
    #PB_Text_InLine
    
    #PB_Flag_Double
    #PB_Flag_Flat
    #PB_Flag_Raised
    #PB_Flag_Single
    
    #PB_Flag_GridLines
    #PB_Flag_Invisible
    
    #PB_Flag_MultiSelect
    #PB_Flag_ClickSelect
    
    #PB_Flag_AutoSize
    #PB_Flag_AutoRight
    #PB_Flag_AutoBottom
    #PB_Flag_AnchorsGadget
    
    #PB_Flag_FullSelection; = 512 ; #PB_ListIcon_FullRowSelect
    
    #PB_Flag_Limit
  EndEnumeration
  
  If (#PB_Flag_Limit>>1) > 2147483647 ; 8589934592
    Debug "Исчерпан лимит в x32 ("+Str(#PB_Flag_Limit>>1)+")"
  EndIf
  
  #PB_Full = #PB_Left|#PB_Right|#PB_Top|#PB_Bottom
  #PB_Gadget_FrameColor = 10
  
  ; Set/Get Attribute
  #PB_DisplayMode = 1<<13
  #PB_Image = 1<<13
  #PB_Text = 1<<14
  #PB_Flag = 1<<15
  #PB_State = 1<<16
  
  
  #PB_DisplayMode_Default =- 1
  
  Enumeration
    #PB_DisplayMode_SmallIcon ;  = #PB_ListIcon_LargeIcon                 ; 0 0
    #PB_DisplayMode_LargeIcon ;  = #PB_ListIcon_SmallIcon                 ; 1 1
  EndEnumeration
  
  EnumerationBinary Attribute
    #PB_State_Selected        ; = #PB_Tree_Selected                       ; 1
    #PB_State_Expanded        ; = #PB_Tree_Expanded                       ; 2
    #PB_State_Checked         ; = #PB_Tree_Checked                        ; 4
    #PB_State_Collapsed       ; = #PB_Tree_Collapsed                      ; 8
    
    #PB_Image_Center
    #PB_Image_Mosaic
    #PB_Image_Stretch
    #PB_Image_Proportionally
    
    #PB_DisplayMode_AlwaysShowSelection                                    ; 0 32 Even If the gadget isn't activated, the selection is still visible.
  EndEnumeration
  ;}
  
  ;-
  ;- - DECLAREs GLOBALs
  Global *Value.Default_S
  Global *Root.Widget_S = AllocateStructure(Default_S)
;   *Value = AllocateStructure(Default_S)
;   *Value\This = AllocateStructure(Widget_S)
  Global NewList *openedlist.Widget_S()
  
  ;-
  ;- - DECLAREs MACROs
  Macro PB(Function) : Function : EndMacro
  
  Macro Root()
    Widget::*Root
  EndMacro
  
  Macro Adress(_this_)
    Widget::_this_\Adress
  EndMacro
  
  ;   Macro IsBar(_this_)
  ;     Bool(_this_ And (_this_\Type = #PB_GadgetType_ScrollBar Or _this_\Type = #PB_GadgetType_TrackBar Or _this_\Type = #PB_GadgetType_ProgressBar Or _this_\Type = #PB_GadgetType_Splitter))
  ;   EndMacro
  
  Macro IsWidget(_this_)
    Bool(_this_>*Root And _this_<AllocateStructure(Widget_S)) * _this_ ; Bool(MemorySize(_this_)=MemorySize(AllocateStructure(Widget_S))) * _this_
  EndMacro
  
  ;   Define w  ;TypeOf(_this_)  ; 
  ;   Define *w.Widget_S=AllocateStructure(Widget_S)
  ;   Define *w1.Widget_S=AllocateStructure(Widget_S)
  ;   Debug ""+*w+" "+*w1+" "+MemorySize(*w)+" "+MemorySize(*w1)
  ;   Debug MemorySize(AllocateStructure(Widget_S))
  ;   Debug *value\this
  ;   Debug IsWidget(345345345999)
  
  
  Macro IsList(_index_, _list_)
    Bool(_index_ > #PB_Any And _index_ < ListSize(_list_))
  EndMacro
  
  Macro SelectList(_index_, _list_)
    Bool(IsList(_index_, _list_) And _index_ <> ListIndex(_list_) And SelectElement(_list_, _index_))
  EndMacro
  
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
  
  ; Then scroll bar start position
  Macro IsStart(_this_) : Bool(_this_\Page\Pos =< _this_\Min) : EndMacro
  
  ; Then scroll bar end position
  Macro IsStop(_this_) : Bool(_this_\Page\Pos >= (_this_\Max-_this_\Page\len)) : EndMacro
  
  ; Inverted scroll bar position
  Macro Invert(_this_, _scroll_pos_, _inverted_=#True)
    (Bool(_inverted_) * ((_this_\Min + (_this_\Max - _this_\Page\len)) - (_scroll_pos_)) + Bool(Not _inverted_) * (_scroll_pos_))
  EndMacro
  
  Macro Set_Image(_item_, _image_)
    IsImage(_image_)
    
    _item_\image\change = 1
    _item_\image\index = _image_
    
    If IsImage(_image_)
      _item_\image\imageID = ImageID(_image_)
      _item_\image\width = ImageWidth(_image_)
      _item_\image\height = ImageHeight(_image_)
    Else
      _item_\image\imageID = 0
      _item_\image\width = 0
      _item_\image\height = 0
    EndIf
  EndMacro
  
  Macro CheckFlag(_mask_, _flag_)
    ((_mask_ & _flag_) = _flag_)
  EndMacro
  
  ;-
  ;- - DECLAREs
  ;-
  Declare.i SetActive(*This.Widget_S)
  Declare.i Y(*This.Widget_S)
  Declare.i X(*This.Widget_S)
  Declare.i Width(*This.Widget_S)
  Declare.i Height(*This.Widget_S)
  Declare.i Draw(*This.Widget_S, Childrens=0)
  Declare.i GetState(*This.Widget_S)
  Declare.i SetState(*This.Widget_S, State.i)
  Declare.i GetAttribute(*This.Widget_S, Attribute.i)
  Declare.i SetAttribute(*This.Widget_S, Attribute.i, Value.i)
  Declare.i CallBack(*This.Widget_S, EventType.i, mouseX=0, mouseY=0)
  Declare.i SetColor(*This.Widget_S, ColorType.i, Color.i, State.i=0, Item.i=0)
  Declare.i Resize(*This.Widget_S, iX.i,iY.i,iWidth.i,iHeight.i);, *That.Widget_S=#Null)
  Declare.i Hide(*This.Widget_S, State.i=-1)
  Declare.i SetImage(*This.Widget_S, Image.i)
  Declare.i GetImage(*This.Widget_S)
  Declare.i GetType(*This.Widget_S)
  Declare.i SetData(*This.Widget_S, *Data)
  Declare.i GetData(*This.Widget_S)
  Declare.i SetText(*This.Widget_S, Text.s)
  Declare.s GetText(*This.Widget_S)
  Declare.i GetItemState(*This.Widget_S, Item.i)
  Declare.i SetItemState(*This.Widget_S, Item.i, State.i)
  Declare.i GetParent(*This.Widget_S)
  Declare.i GetParentItem(*This.Widget_S)
  Declare.i at(*this.Widget_S, MouseX.i, MouseY.i)
  Declare.i GetPosition(*This.Widget_S, Position.i)
  Declare.i SetPosition(*This.Widget_S, Position.i, *Widget_2 =- 1)
  Declare.i Free(*This.Widget_S)
  
  Declare.i SetAlignment(*This.Widget_S, Mode.i, Type.i=1)
  Declare.i SetItemData(*This.Widget_S, Item.i, *Data)
  Declare.i GetItemData(*This.Widget_S, Item.i)
  Declare.i CountItems(*This.Widget_S)
  Declare.i ClearItems(*This.Widget_S)
  Declare.i RemoveItem(*This.Widget_S, Item.i)
  Declare.i SetItemAttribute(*This.Widget_S, Item.i, Attribute.i, Value.i)
  Declare.i GetItemAttribute(*This.Widget_S, Item.i, Attribute.i)
  Declare.i Enumerate(*This.Integer, *Parent.Widget_S, Item.i=0)
  Declare.i SetItemText(*This.Widget_S, Item.i, Text.s)
  Declare.s GetItemText(*This.Widget_S, Item.i)
  Declare.i AddColumn(*This.Widget_S, Position.i, Title.s, Width.i)
  Declare.i SetFlag(*This.Widget_S, Flag.i)
  Declare.i GetItemImage(*This.Widget_S, Item.i)
  Declare.i SetItemImage(*This.Widget_S, Item.i, Image.i)
  Declare.i ReDraw(Canvas.i)
  
  Declare.i Scroll(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
  Declare.i Track(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
  Declare.i Progress(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
  Declare.i Splitter(X.i,Y.i,Width.i,Height.i, First.i, Second.i, Flag.i=0)
  Declare.i Image(X.i,Y.i,Width.i,Height.i, Image.i, Flag.i=0)
  Declare.i ScrollArea(X.i,Y.i,Width.i,Height.i, ScrollAreaWidth.i, ScrollAreaHeight.i, ScrollStep.i=1, Flag.i=0)
  Declare.i Button(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0, Image.i=-1)
  Declare.i Container(X.i,Y.i,Width.i,Height.i, Flag.i=0)
  Declare.i Frame(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
  Declare.i Panel(X.i,Y.i,Width.i,Height.i, Flag.i=0)
  Declare.i Text(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
  Declare.i Tree(X.i,Y.i,Width.i,Height.i, Flag.i=0)
  Declare.i Property(X.i,Y.i,Width.i,Height.i, SplitterPos.i = 80, Flag.i=0)
  Declare.i String(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
  Declare.i CheckBox(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
  Declare.i Option(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
  Declare.i ComboBox(X.i,Y.i,Width.i,Height.i, Flag.i=0)
  Declare.i HyperLink(X.i,Y.i,Width.i,Height.i, Text.s, Color.i, Flag.i=0)
  Declare.i ListView(X.i,Y.i,Width.i,Height.i, Flag.i=0)
  Declare.i Spin(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0, Increment.f=1, Radius.i=7)
  Declare.i ListIcon(X.i,Y.i,Width.i,Height.i, FirstColumnTitle.s, FirstColumnWidth.i, Flag.i=0)
  Declare.i Popup(*Widget.Widget_S, X.i,Y.i,Width.i,Height.i, Flag.i=0)
  Declare.i Window(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0, *Widget.Widget_S=0)
  
  Declare.i CloseList()
  Declare.i OpenList(*This.Widget_S, Item.i=0)
  Declare.i SetParent(*This.Widget_S, *Parent.Widget_S, Item.i=-1)
  Declare.i AddItem(*This.Widget_S, Item.i, Text.s, Image.i=-1, Flag.i=0)
  
  Declare.i Resizes(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i)
  Declare.i Updates(*Scroll.Scroll_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
  Declare.i Arrow(X,Y, Size, Direction, Color, Style.b = 1, Length = 1)
EndDeclareModule

Module Widget
  ;- MODULE
  ;
  Declare.i Events(*This.Widget_S, at.i, EventType.i, MouseScreenX.i, MouseScreenY.i, WheelDelta.i = 0)
  
  ;- GLOBALs
  Global Color_Default.Color_S
  
  
  *Value = AllocateStructure(Default_S)
  *Value\Type =- 1
  *Value\Canvas\Gadget =- 1
  *Value\Canvas\Window =- 1
  
  With Color_Default                          
    \State = 0
    \alpha = 255
    
    ; - Синие цвета
    ; Цвета по умолчанию
    \Front[0] = $80000000
    \Fore[0] = $FFF8F8F8 
    \Back[0] = $80E2E2E2
    \Frame[0] = $80C8C8C8
    
    ; Цвета если мышь на виджете
    \Front[1] = $80000000
    \Fore[1] = $FFFAF8F8
    \Back[1] = $80FCEADA
    \Frame[1] = $80FFC288
    
    ; Цвета если нажали на виджет
    \Front[2] = $FFFEFEFE
    \Fore[2] = $C8E9BA81;$C8FFFCFA
    \Back[2] = $C8E89C3D; $80E89C3D
    \Frame[2] = $C8DC9338; $80DC9338
  EndWith
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    Global _drawing_mode_
    
    ;     Macro PB(Function)
    ;       Function
    ;     EndMacro
    
    Macro DrawingMode(_mode_)
      PB(DrawingMode)(_mode_) : _drawing_mode_ = _mode_
    EndMacro
    
    Macro ClipOutput(x, y, width, height)
      PB(ClipOutput)(x, y, width, height)
      ClipOutput_(x, y, width, height)
    EndMacro
    
    Macro UnclipOutput()
      PB(UnclipOutput)()
      ClipOutput_(0, 0, OutputWidth(), OutputHeight())
    EndMacro
    
    Macro DrawText(x, y, Text, FrontColor=$ffffff, BackColor=0)
      DrawRotatedText_(x, y, Text, 0, FrontColor, BackColor)
    EndMacro
    
    Macro DrawRotatedText(x, y, Text, Angle, FrontColor=$ffffff, BackColor=0)
      DrawRotatedText_(x, y, Text, Angle, FrontColor, BackColor)
    EndMacro
    
    
    Procedure.i DrawRotatedText_(x.CGFloat, y.CGFloat, Text.s, Angle.CGFloat, FrontColor=$ffffff, BackColor=0)
      Protected.CGFloat r,g,b,a
      Protected.i Transform, NSString, Attributes, Color
      Protected Size.NSSize, Point.NSPoint
      
      If Text.s
        CocoaMessage(@Attributes, 0, "NSMutableDictionary dictionaryWithCapacity:", 2)
        
        r = Red(FrontColor)/255 : g = Green(FrontColor)/255 : b = Blue(FrontColor)/255 : a = 1
        Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
        CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSColor")
        
        r = Red(BackColor)/255 : g = Green(BackColor)/255 : b = Blue(BackColor)/255 : a = Bool(_drawing_mode_&#PB_2DDrawing_Transparent=0)
        Color = CocoaMessage(0, 0, "NSColor colorWithDeviceRed:@", @r, "green:@", @g, "blue:@", @b, "alpha:@", @a)
        CocoaMessage(0, Attributes, "setValue:", Color, "forKey:$", @"NSBackgroundColor")  
        
        NSString = CocoaMessage(0, 0, "NSString stringWithString:$", @Text)
        CocoaMessage(@Size, NSString, "sizeWithAttributes:", Attributes)
        
        If Angle
          CocoaMessage(0, 0, "NSGraphicsContext saveGraphicsState")
          
          y = OutputHeight()-y
          Transform = CocoaMessage(0, 0, "NSAffineTransform transform")
          CocoaMessage(0, Transform, "translateXBy:@", @x, "yBy:@", @y)
          CocoaMessage(0, Transform, "rotateByDegrees:@", @Angle)
          x = 0 : y = -Size\height
          CocoaMessage(0, Transform, "translateXBy:@", @x, "yBy:@", @y)
          CocoaMessage(0, Transform, "concat")
          CocoaMessage(0, NSString, "drawAtPoint:@", @Point, "withAttributes:", Attributes)
          
          CocoaMessage(0, 0,  "NSGraphicsContext restoreGraphicsState")
        Else
          Point\x = x : Point\y = OutputHeight()-Size\height-y
          CocoaMessage(0, NSString, "drawAtPoint:@", @Point, "withAttributes:", Attributes)
        EndIf
      EndIf
    EndProcedure
    
    Procedure.i ClipOutput_(x.i, y.i, width.i, height.i)
      Protected Rect.NSRect
      Rect\origin\x = x 
      Rect\origin\y = OutputHeight()-height-y
      Rect\size\width = width 
      Rect\size\height = height
      
      CocoaMessage(0, CocoaMessage(0, 0, "NSBezierPath bezierPathWithRect:@", @Rect), "setClip")
      ;CocoaMessage(0, CocoaMessage(0, 0, "NSBezierPath bezierPathWithRect:@", @Rect), "addClip")
    EndProcedure
  CompilerEndIf
  
  Macro SetAutoSize(_this_, _state_)
    If Bool(_state_) : x=0 : y=0
      _this_\Align = AllocateStructure(Align_S)
      _this_\Align\Left = 1
      _this_\Align\Top = 1
      _this_\Align\Right = 1
      _this_\Align\Bottom = 1
    EndIf
  EndMacro
  
  Macro SetLastParent(_this_, _type_)
    _this_\Type = _type_
    _this_\Canvas\Gadget = *Value\Canvas\Gadget
    _this_\Canvas\Window = *Value\Canvas\Window
    
    ; Set parent
    If LastElement(*openedlist())
      If _this_\Type = #PB_GadgetType_Option
        If ListSize(*openedlist()\Childrens()) 
          If *openedlist()\Childrens()\Type = #PB_GadgetType_Option
            _this_\OptionGroup = *openedlist()\Childrens()\OptionGroup 
          Else
            _this_\OptionGroup = *openedlist()\Childrens() 
          EndIf
        Else
          _this_\OptionGroup = *openedlist()
        EndIf
      EndIf
      SetParent(_this_, *openedlist(), *openedlist()\o_i)
    EndIf
  EndMacro
  
  Macro ThumbLength(_this_)
    Round(_this_\Area\len - (_this_\Area\len / (_this_\Max-_this_\Min)) * ((_this_\Max-_this_\Min) - _this_\Page\len), #PB_Round_Nearest)
    : If _this_\Thumb\Len > _this_\Area\Len : _this_\Thumb\Len = _this_\Area\Len : EndIf 
    : If _this_\Box : If _this_\Vertical And Bool(_this_\Type <> #PB_GadgetType_Spin) : _this_\Box\Height[3] = _this_\Thumb\len : Else : _this_\Box\Width[3] = _this_\Thumb\len : EndIf : EndIf
  EndMacro
  
  Macro ThumbPos(_this_, _scroll_pos_)
    (_this_\Area\Pos + Round((_scroll_pos_-_this_\Min) * (_this_\Area\len / (_this_\Max-_this_\Min)), #PB_Round_Nearest)) 
    : If _this_\Thumb\Pos < _this_\Area\Pos : _this_\Thumb\Pos = _this_\Area\Pos : EndIf 
    : If _this_\Thumb\Pos > _this_\Area\Pos+_this_\Area\Len : _this_\Thumb\Pos = (_this_\Area\Pos+_this_\Area\Len)-_this_\Thumb\Len : EndIf 
    : If _this_\Box : If _this_\Vertical And Bool(_this_\Type <> #PB_GadgetType_Spin) : _this_\Box\y[3] = _this_\Thumb\Pos : Else : _this_\Box\x[3] = _this_\Thumb\Pos : EndIf : EndIf
  EndMacro
  
  Procedure.i Match(Value.i, Grid.i, Max.i=$7FFFFFFF)
    ProcedureReturn ((Bool(Value>Max) * Max) + (Bool(Grid And Value<Max) * (Round((Value/Grid), #PB_Round_Nearest) * Grid)))
  EndProcedure
  
  Macro AddChildren(_parent_, _this_)
    LastElement(_parent_\Childrens()) : If AddElement(_parent_\Childrens()) : _parent_\Childrens() = _this_  : _parent_\Childrens()\adress = @_parent_\Childrens() : _parent_\CountItems + 1 : EndIf
  EndMacro
  
  ;-
  ;- Anchors
  Macro Draw_Anchors(_this_)
    If _this_\anchor
      DrawingMode(#PB_2DDrawing_Outlined)
      If _this_\anchor[9] : Box(_this_\anchor[9]\x, _this_\anchor[9]\y, _this_\anchor[9]\width, _this_\anchor[9]\height ,_this_\anchor[9]\color[_this_\anchor[9]\State]\frame) : EndIf
      
      DrawingMode(#PB_2DDrawing_Default)
      If _this_\anchor[1] : Box(_this_\anchor[1]\x, _this_\anchor[1]\y, _this_\anchor[1]\width, _this_\anchor[1]\height ,_this_\anchor[1]\color[_this_\anchor[1]\State]\back) : EndIf
      If _this_\anchor[2] : Box(_this_\anchor[2]\x, _this_\anchor[2]\y, _this_\anchor[2]\width, _this_\anchor[2]\height ,_this_\anchor[2]\color[_this_\anchor[2]\State]\back) : EndIf
      If _this_\anchor[3] : Box(_this_\anchor[3]\x, _this_\anchor[3]\y, _this_\anchor[3]\width, _this_\anchor[3]\height ,_this_\anchor[3]\color[_this_\anchor[3]\State]\back) : EndIf
      If _this_\anchor[4] : Box(_this_\anchor[4]\x, _this_\anchor[4]\y, _this_\anchor[4]\width, _this_\anchor[4]\height ,_this_\anchor[4]\color[_this_\anchor[4]\State]\back) : EndIf
      If _this_\anchor[5] And Not _this_\Container : Box(_this_\anchor[5]\x, _this_\anchor[5]\y, _this_\anchor[5]\width, _this_\anchor[5]\height ,_this_\anchor[5]\color[_this_\anchor[5]\State]\back) : EndIf
      If _this_\anchor[6] : Box(_this_\anchor[6]\x, _this_\anchor[6]\y, _this_\anchor[6]\width, _this_\anchor[6]\height ,_this_\anchor[6]\color[_this_\anchor[6]\State]\back) : EndIf
      If _this_\anchor[7] : Box(_this_\anchor[7]\x, _this_\anchor[7]\y, _this_\anchor[7]\width, _this_\anchor[7]\height ,_this_\anchor[7]\color[_this_\anchor[7]\State]\back) : EndIf
      If _this_\anchor[8] : Box(_this_\anchor[8]\x, _this_\anchor[8]\y, _this_\anchor[8]\width, _this_\anchor[8]\height ,_this_\anchor[8]\color[_this_\anchor[8]\State]\back) : EndIf
      
      DrawingMode(#PB_2DDrawing_Outlined)
      If _this_\anchor[1] : Box(_this_\anchor[1]\x, _this_\anchor[1]\y, _this_\anchor[1]\width, _this_\anchor[1]\height ,_this_\anchor[1]\color[_this_\anchor[1]\State]\frame) : EndIf
      If _this_\anchor[2] : Box(_this_\anchor[2]\x, _this_\anchor[2]\y, _this_\anchor[2]\width, _this_\anchor[2]\height ,_this_\anchor[2]\color[_this_\anchor[2]\State]\frame) : EndIf
      If _this_\anchor[3] : Box(_this_\anchor[3]\x, _this_\anchor[3]\y, _this_\anchor[3]\width, _this_\anchor[3]\height ,_this_\anchor[3]\color[_this_\anchor[3]\State]\frame) : EndIf
      If _this_\anchor[4] : Box(_this_\anchor[4]\x, _this_\anchor[4]\y, _this_\anchor[4]\width, _this_\anchor[4]\height ,_this_\anchor[4]\color[_this_\anchor[4]\State]\frame) : EndIf
      If _this_\anchor[5] : Box(_this_\anchor[5]\x, _this_\anchor[5]\y, _this_\anchor[5]\width, _this_\anchor[5]\height ,_this_\anchor[5]\color[_this_\anchor[5]\State]\frame) : EndIf
      If _this_\anchor[6] : Box(_this_\anchor[6]\x, _this_\anchor[6]\y, _this_\anchor[6]\width, _this_\anchor[6]\height ,_this_\anchor[6]\color[_this_\anchor[6]\State]\frame) : EndIf
      If _this_\anchor[7] : Box(_this_\anchor[7]\x, _this_\anchor[7]\y, _this_\anchor[7]\width, _this_\anchor[7]\height ,_this_\anchor[7]\color[_this_\anchor[7]\State]\frame) : EndIf
      If _this_\anchor[8] : Box(_this_\anchor[8]\x, _this_\anchor[8]\y, _this_\anchor[8]\width, _this_\anchor[8]\height ,_this_\anchor[8]\color[_this_\anchor[8]\State]\frame) : EndIf
    EndIf
  EndMacro
  
  Macro Resize_Anchors(_this_)
    If _this_\anchor[1] 
      _this_\anchor[1]\x = _this_\x-_this_\anchor[1]\width+_this_\anchor[1]\Pos
      _this_\anchor[1]\y = _this_\y+(_this_\height-_this_\anchor[1]\height)/2
    EndIf
    If _this_\anchor[2] 
      _this_\anchor[2]\x = _this_\x+(_this_\width-_this_\anchor[2]\width)/2
      _this_\anchor[2]\y = _this_\y-_this_\anchor[2]\height+_this_\anchor[2]\Pos
    EndIf
    If  _this_\anchor[3]
      _this_\anchor[3]\x = _this_\x+_this_\width-_this_\anchor[3]\Pos
      _this_\anchor[3]\y = _this_\y+(_this_\height-_this_\anchor[3]\height)/2
    EndIf
    If _this_\anchor[4] 
      _this_\anchor[4]\x = _this_\x+(_this_\width-_this_\anchor[4]\width)/2
      _this_\anchor[4]\y = _this_\y+_this_\height-_this_\anchor[4]\Pos
    EndIf
    If _this_\anchor[5] 
      _this_\anchor[5]\x = _this_\x-_this_\anchor[5]\width+_this_\anchor[5]\Pos
      _this_\anchor[5]\y = _this_\y-_this_\anchor[5]\height+_this_\anchor[5]\Pos
    EndIf
    If _this_\anchor[6] 
      _this_\anchor[6]\x = _this_\x+_this_\width-_this_\anchor[6]\Pos
      _this_\anchor[6]\y = _this_\y-_this_\anchor[6]\height+_this_\anchor[6]\Pos
    EndIf
    If _this_\anchor[7] 
      _this_\anchor[7]\x = _this_\x+_this_\width-_this_\anchor[7]\Pos
      _this_\anchor[7]\y = _this_\y+_this_\height-_this_\anchor[7]\Pos
    EndIf
    If _this_\anchor[8] 
      _this_\anchor[8]\x = _this_\x-_this_\anchor[8]\width+_this_\anchor[8]\Pos
      _this_\anchor[8]\y = _this_\y+_this_\height-_this_\anchor[8]\Pos
    EndIf
    If _this_\anchor[9] 
      _this_\anchor[9]\x = _this_\x
      _this_\anchor[9]\y = _this_\y
      _this_\anchor[9]\width = _this_\width
      _this_\anchor[9]\height = _this_\height
    EndIf
  EndMacro
  
  Procedure Events_Anchors(*This.Widget_S, mouse_x,mouse_y)
    With *This
      Protected px,py,Grid = \Grid
      
      If \Parent
        px = \Parent\x[2]
        py = \Parent\y[2]
      EndIf
      
      Protected mx = Match(mouse_x-px, Grid)
      Protected my = Match(mouse_y-py, Grid)
      Protected mw = Match((\x+\Width-Bool(Grid>1))-mouse_x, Grid)+Bool(Grid>1)
      Protected mh = Match((\y+\height-Bool(Grid>1))-mouse_y, Grid)+Bool(Grid>1)
      Protected mxw = Match(mouse_x-\x, Grid)+Bool(Grid>1)
      Protected myh = Match(mouse_y-\y, Grid)+Bool(Grid>1)
      
      Select \anchor
        Case \anchor[1] : Resize(*This, mx, #PB_Ignore, mw, #PB_Ignore)
        Case \anchor[2] : Resize(*This, #PB_Ignore, my, #PB_Ignore, mh)
        Case \anchor[3] : Resize(*This, #PB_Ignore, #PB_Ignore, mxw, #PB_Ignore)
        Case \anchor[4] : Resize(*This, #PB_Ignore, #PB_Ignore, #PB_Ignore, myh)
          
        Case \anchor[5] 
          If \Container
            Resize(*This, mx, my, #PB_Ignore, #PB_Ignore)
          Else
            Resize(*This, mx, my, mw, mh)
          EndIf
        Case \anchor[6] : Resize(*This, #PB_Ignore, my, mxw, mh)
        Case \anchor[7] : Resize(*This, #PB_Ignore, #PB_Ignore, mxw, myh)
        Case \anchor[8] : Resize(*This, mx, #PB_Ignore, mw, myh)
          
        Case \anchor[9] 
          If Not \Container
            Resize(*This, mx, my, #PB_Ignore, #PB_Ignore)
          EndIf
      EndSelect
    EndWith
  EndProcedure
  
  Procedure CallBack_Anchors(*This.Widget_S, EventType.i, Buttons.i, MouseScreenX.i,MouseScreenY.i)
    Protected i 
    Static Result.i, *p.Widget_S
    
    With *This
      Select EventType 
        Case #PB_EventType_MouseMove
          If *p And *p\anchor
            Protected x = MouseScreenX-*p\anchor\x[1]
            Protected y = MouseScreeny-*p\anchor\y[1]
            
            Events_Anchors(*p, x,y)
            
            ProcedureReturn 1
            
          ElseIf Not Buttons
            For i = #Anchors To 1 Step - 1
              If \anchor[i]
                If (MouseScreenX>\anchor[i]\X And MouseScreenX=<\anchor[i]\X+\anchor[i]\Width And 
                    MouseScreenY>\anchor[i]\Y And MouseScreenY=<\anchor[i]\Y+\anchor[i]\Height)
                  
                  If \anchor <> \anchor[i] : \anchor = \anchor[i]
                    If Not \anchor[i]\State
                      \anchor[i]\State = 1
                    EndIf
                    
                    \anchor[i]\Cursor[1] = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
                    SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \anchor[i]\Cursor)
                    If i<>5
                      Result = 1
                    EndIf
                  EndIf
                  
                ElseIf \anchor[i]\State = 1
                  \anchor[i]\State = 0
                  \anchor = 0
                  
                  If GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor) <> \anchor[i]\Cursor[1]
                    SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \anchor[i]\Cursor[1])
                  EndIf
                  Result = 0
                EndIf
              EndIf
            Next
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          
          If \anchor : \anchor\State = 2 : *p = *This 
            SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \anchor\Cursor)
            \anchor\x[1] = MouseScreenX-\anchor\x
            \anchor\y[1] = MouseScreenY-\anchor\y
            ProcedureReturn 0
          EndIf
          
        Case #PB_EventType_LeftButtonUp
          If \anchor : \anchor\State = 1 : *p = 0
            SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \anchor\Cursor[1])
            ProcedureReturn 0
          EndIf
          
      EndSelect
      
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure SetAnchors(*This.Widget_S, State)
    ; ProcedureReturn
    
    Structure DataBuffer
      cursor.i[#Anchors+1]
    EndStructure
    
    Protected i, *Cursor.DataBuffer = ?CursorsBuffer
    
    With *This
      If \Parent
        If \Parent\Type = #PB_GadgetType_Splitter
          ProcedureReturn
        EndIf
        
        \Grid = \Parent\Grid
      Else
        If \Container
          \Grid = 5
        Else
          \Grid = 5
        EndIf
      EndIf
      
      If State
        
        For i = 1 To #Anchors
          \anchor[i] = AllocateStructure(Anchor_S)
          \anchor[i]\Color[0]\Frame = $000000
          \anchor[i]\Color[1]\Frame = $FF0000
          \anchor[i]\Color[2]\Frame = $0000FF
          
          \anchor[i]\Color[0]\Back = $FFFFFF
          \anchor[i]\Color[1]\Back = $FFFFFF
          \anchor[i]\Color[2]\Back = $FFFFFF
          
          \anchor[i]\Width = 6
          \anchor[i]\Height = 6
          
          If \Container And i = 5
            \anchor[5]\Width * 2
            \anchor[5]\Height * 2
          EndIf
          
          \anchor[i]\Pos = \anchor[i]\Width-3
        Next i
        
      EndIf
    EndWith
    
    DataSection
      CursorsBuffer:
      Data.i 0
      Data.i #PB_Cursor_LeftRight
      Data.i #PB_Cursor_UpDown
      Data.i #PB_Cursor_LeftRight
      Data.i #PB_Cursor_UpDown
      Data.i #PB_Cursor_LeftUpRightDown
      Data.i #PB_Cursor_LeftDownRightUp
      Data.i #PB_Cursor_LeftUpRightDown
      Data.i #PB_Cursor_LeftDownRightUp
      Data.i #PB_Cursor_Arrows
    EndDataSection
  EndProcedure
  
  ;-
  Procedure.i SetAlignment(*This.Widget_S, Mode.i, Type.i=1)
    With *This
      Select Type
        Case 1 ; widget
          If \Parent
            If Not \Align
              \Align.Align_S = AllocateStructure(Align_S)
            EndIf
            
            \Align\Right = 0
            \Align\Bottom = 0
            \Align\Left = 0
            \Align\Top = 0
            \Align\Horizontal = 0
            \Align\Vertical = 0
            
            If Mode&#PB_Right=#PB_Right
              \Align\x = (\Parent\Width-\Parent\bs*2 - (\x-\Parent\x-\Parent\bs)) - \Width
              \Align\Right = 1
            EndIf
            If Mode&#PB_Bottom=#PB_Bottom
              \Align\y = (\Parent\height-\Parent\bs*2 - (\y-\Parent\y-\Parent\bs)) - \height
              \Align\Bottom = 1
            EndIf
            If Mode&#PB_Left=#PB_Left
              \Align\Left = 1
              If Mode&#PB_Right=#PB_Right
                \Align\x1 = (\Parent\Width - \Parent\bs*2) - \Width
              EndIf
            EndIf
            If Mode&#PB_Top=#PB_Top
              \Align\Top = 1
              If Mode&#PB_Bottom=#PB_Bottom
                \Align\y1 = (\Parent\height -\Parent\bs*2)- \height
              EndIf
            EndIf
            
            If Mode&#PB_Center=#PB_Center
              \Align\Horizontal = 1
              \Align\Vertical = 1
            EndIf
            If Mode&#PB_Horizontal=#PB_Horizontal
              \Align\Horizontal = 1
            EndIf
            If Mode&#PB_Vertical=#PB_Vertical
              \Align\Vertical = 1
            EndIf
            
            Resize(\Parent, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          EndIf
        Case 2 ; text
        Case 3 ; image
      EndSelect
    EndWith
  EndProcedure
  
  Procedure.s Make(*This.Widget_S, Text.s)
    Protected String.s, i.i, Len.i
    
    With *This
      If \Text\Numeric And Text.s <> #LF$
        Static Dot, Minus
        Protected Chr.s, Input.i, left.s, count.i
        
        Len = Len(Text.s) 
        For i = 1 To Len 
          Chr = Mid(Text.s, i, 1)
          Input = Asc(Chr)
          
          Select Input
            Case '0' To '9', '.','-'
            Case 'Ю','ю','Б','б',44,47,60,62,63 : Input = '.' : Chr = Chr(Input)
            Default
              Input = 0
          EndSelect
          
          If Input
            If \Type = #PB_GadgetType_IPAddress
              left.s = Left(\Text\String, \Text\Caret)
              Select CountString(left.s, ".")
                Case 0 : left.s = StringField(left.s, 1, ".")
                Case 1 : left.s = StringField(left.s, 2, ".")
                Case 2 : left.s = StringField(left.s, 3, ".")
                Case 3 : left.s = StringField(left.s, 4, ".")
              EndSelect                                           
              count = Len(left.s+Trim(StringField(Mid(\Text\String, \Text\Caret+1), 1, "."), #LF$))
              If count < 3 And (Val(left.s) > 25 Or Val(left.s+Chr.s) > 255)
                Continue
                ;               ElseIf Mid(\Text\String, \Text\Caret + 1, 1) = "."
                ;                 \Text\Caret + 1 : \Text\Caret[1]=\Text\Caret
              EndIf
            EndIf
            
            If Not Dot And Input = '.' And Mid(\Text\String, \Text\Caret + 1, 1) <> "."
              Dot = 1
            ElseIf Input <> '.' And count < 3
              Dot = 0
            Else
              Continue
            EndIf
            
            If Not Minus And Input = '-' And Mid(\Text\String, \Text\Caret + 1, 1) <> "-"
              Minus = 1
            ElseIf Input <> '-'
              Minus = 0
            Else
              Continue
            EndIf
            
            String.s + Chr
          EndIf
        Next
        
      ElseIf \Text\Pass
        Len = Len(Text.s) 
        For i = 1 To Len : String.s + "●" : Next
        
      Else
        Select #True
          Case \Text\Lower : String.s = LCase(Text.s)
          Case \Text\Upper : String.s = UCase(Text.s)
          Default
            String.s = Text.s
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn String.s
  EndProcedure
  
  Procedure.s Wrap (*This.Widget_S, Text.s, Width.i, Mode=-1, nl$=#LF$, DelimList$=" "+Chr(9))
    Protected.i CountString, i, start, ii, found, length
    Protected line$, ret$="", LineRet$="", TextWidth
    
    ;     Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
    ;     Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
    ;     Text.s = ReplaceString(Text.s, #CR$, #LF$)
    ;     Text.s + #LF$
    ;  
    
    
    CountString = CountString(Text.s, #LF$) 
    ; Protected time = ElapsedMilliseconds()
    
    ; ;     Protected Len
    ; ;     Protected *s_0.Character = @Text.s
    ; ;     Protected *e_0.Character = @Text.s 
    ; ;     #SOC = SizeOf (Character)
    ; ;       While *e_0\c 
    ; ;         If *e_0\c = #LF
    ; ;           Len = (*e_0-*s_0)>>#PB_Compiler_Unicode
    ; ;           line$ = PeekS(*s_0, Len) ;Trim(, #LF$)
    
    For i = 1 To CountString
      line$ = StringField(Text.s, i, #LF$)
      start = Len(line$)
      length = start
      
      ; Get text len
      While length > 1
        ; Debug ""+TextWidth(RTrim(Left(Line$, length))) +" "+ GetTextWidth(RTrim(Left(Line$, length)), length)
        If width > TextWidth(RTrim(Left(Line$, length))) ; GetTextWidth(RTrim(Left(Line$, length)), length) ;   
          Break
        Else
          length - 1
        EndIf
      Wend 
      
      ;  Debug ""+start +" "+ length
      While start > length 
        If mode
          For ii = length To 0 Step - 1
            If mode = 2 And CountString(Left(line$,ii), " ") > 1     And width > 71 ; button
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
        EndIf
        
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
          ; Debug ""+TextWidth(RTrim(Left(Line$, length))) +" "+ GetTextWidth(RTrim(Left(Line$, length)), length)
          If width > TextWidth(RTrim(Left(Line$, length))) ; GetTextWidth(RTrim(Left(Line$, length)), length) ; 
            Break
          Else
            length - 1
          EndIf
        Wend 
        
      Wend   
      
      ret$ + LineRet$ + line$ + #CR$+nl$
      LineRet$=""
    Next
    
    ; ;       *s_0 = *e_0 + #SOC : EndIf : *e_0 + #SOC : Wend
    ;Debug  ElapsedMilliseconds()-time
    ; MessageRequester("",Str( ElapsedMilliseconds()-time))
    
    If Width > 1
      ProcedureReturn ret$ ; ReplaceString(ret$, " ", "*")
    EndIf
  EndProcedure
  
  Procedure.i Arrow(X.i,Y.i, Size.i, Direction.i, Color.i, Style.b = 1, Length.i = 1)
    Protected I
    
    If Not Length
      Style =- 1
    EndIf
    Length = (Size+2)/2
    
    
    If Direction = 1 ; top
      If Style > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size 
          LineXY((X+1+i)+Size,(Y+i-1)-(Style),(X+1+i)+Size,(Y+i-1)+(Style),Color)         ; Левая линия
          LineXY(((X+1+(Size))-i),(Y+i-1)-(Style),((X+1+(Size))-i),(Y+i-1)+(Style),Color) ; правая линия
        Next
      Else : x-1 : y-1
        For i = 1 To Length 
          If Style =- 1
            LineXY(x+i, (Size+y), x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y), x+Length, y, Color)
          Else
            LineXY(x+i, (Size+y)-i/2, x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y)-i/2, x+Length, y, Color)
          EndIf
        Next 
        i = Bool(Style =- 1) 
        LineXY(x, (Size+y)+Bool(i=0), x+Length, y+1, Color) 
        LineXY(x+Length*2, (Size+y)+Bool(i=0), x+Length, y+1, Color) ; bug
      EndIf
    ElseIf Direction = 3 ; bottom
      If Style > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size
          LineXY((X+1+i),(Y+i)-(Style),(X+1+i),(Y+i)+(Style),Color) ; Левая линия
          LineXY(((X+1+(Size*2))-i),(Y+i)-(Style),((X+1+(Size*2))-i),(Y+i)+(Style),Color) ; правая линия
        Next
      Else : x-1 : y+1
        For i = 0 To Length 
          If Style =- 1
            LineXY(x+i, y, x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y, x+Length, (Size+y), Color)
          Else
            LineXY(x+i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
          EndIf
        Next
      EndIf
    ElseIf Direction = 0 ; в лево
      If Style > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; в лево
          LineXY(((X+1)+i)-(Style),(((Y+1)+(Size))-i),((X+1)+i)+(Style),(((Y+1)+(Size))-i),Color) ; правая линия
          LineXY(((X+1)+i)-(Style),((Y+1)+i)+Size,((X+1)+i)+(Style),((Y+1)+i)+Size,Color)         ; Левая линия
        Next  
      Else : x-1 : y-1
        For i = 1 To Length
          If Style =- 1
            LineXY((Size+x), y+i, x, y+Length, Color)
            LineXY((Size+x), y+Length*2-i, x, y+Length, Color)
          Else
            LineXY((Size+x)-i/2, y+i, x, y+Length, Color)
            LineXY((Size+x)-i/2, y+Length*2-i, x, y+Length, Color)
          EndIf
        Next 
        i = Bool(Style =- 1) 
        LineXY((Size+x)+Bool(i=0), y, x+1, y+Length, Color) 
        LineXY((Size+x)+Bool(i=0), y+Length*2, x+1, y+Length, Color)
      EndIf
    ElseIf Direction = 2 ; в право
      If Style > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; в право
          LineXY(((X+1)+i)-(Style),((Y+1)+i),((X+1)+i)+(Style),((Y+1)+i),Color) ; Левая линия
          LineXY(((X+1)+i)-(Style),(((Y+1)+(Size*2))-i),((X+1)+i)+(Style),(((Y+1)+(Size*2))-i),Color) ; правая линия
        Next
      Else : y-1 : x+1
        For i = 0 To Length 
          If Style =- 1
            LineXY(x, y+i, Size+x, y+Length, Color)
            LineXY(x, y+Length*2-i, Size+x, y+Length, Color)
          Else
            LineXY(x+i/2-Bool(i=0), y+i, Size+x, y+Length, Color)
            LineXY(x+i/2-Bool(i=0), y+Length*2-i, Size+x, y+Length, Color)
          EndIf
        Next
      EndIf
    EndIf
    
  EndProcedure
  
  Procedure.i Pos(*This.Widget_S, ThumbPos.i)
    Protected ScrollPos.i
    
    With *This
      ScrollPos = \Min + Round((ThumbPos - \Area\Pos) / (\Area\len / (\Max-\Min)), #PB_Round_Nearest)
      ScrollPos = Round(ScrollPos/(\Step + Bool(Not \Step)), #PB_Round_Nearest) * \Step
      If (\Vertical And \Type = #PB_GadgetType_TrackBar)
        ScrollPos = Invert(*This, ScrollPos, \inverted)
      EndIf
    EndWith
    
    ProcedureReturn ScrollPos
  EndProcedure
  
  ;-
  Macro Resize_Splitter(_this_)
    If _this_\Vertical
      Resize(_this_\SplitterFirst, 0, 0, _this_\width, _this_\Thumb\Pos-_this_\y)
      Resize(_this_\SplitterSecond, 0, (_this_\Thumb\Pos+_this_\Thumb\len)-_this_\y, _this_\width, _this_\height-((_this_\Thumb\Pos+_this_\Thumb\len)-_this_\y))
    Else
      Resize(_this_\SplitterFirst, 0, 0, _this_\Thumb\Pos-_this_\x, _this_\height)
      Resize(_this_\SplitterSecond, (_this_\Thumb\Pos+_this_\Thumb\len)-_this_\x, 0, _this_\width-((_this_\thumb\Pos+_this_\thumb\len)-_this_\x), _this_\height)
    EndIf
  EndMacro
  
  Macro Resize_Childrens(_this_, _change_x_, _change_y_)
    ForEach _this_\Childrens()
      Resize(_this_\Childrens(), (_this_\Childrens()\x-_this_\x-_this_\bs) + _change_x_, (_this_\Childrens()\y-_this_\y-_this_\bs-_this_\TabHeight) + _change_y_, #PB_Ignore, #PB_Ignore)
    Next
  EndMacro
  
  Procedure Tree_AddItem(*This.Widget_S,Item.i,Text.s,Image.i=-1,sublevel.i=0)
    Static *last.Items_S
    
    If Not *This
      ProcedureReturn 0
    EndIf
    
    With *This
      ;{ Генерируем идентификатор
      If 0 > Item Or Item > ListSize(\items()) - 1
        LastElement(\items())
        AddElement(\items()) 
        Item = ListIndex(\items())
      Else
        SelectElement(\items(), Item)
        ;       PreviousElement(\items())
        ;       If \a\sublevel = \items()\sublevel
        ;          \a = \items()
        ;       EndIf
        
        ;       SelectElement(\items(), Item)
        If \a\sublevel = *last\sublevel
          \a = *last
        EndIf
        
        If \items()\sublevel>sublevel
          sublevel=\items()\sublevel
        EndIf
        InsertElement(\items())
        
        PushListPosition(\items())
        While NextElement(\items())
          \items()\index = ListIndex(\items())
        Wend
        PopListPosition(\items())
      EndIf
      ;}
      
      \items() = AllocateStructure(Items_S)
      \items()\Box = AllocateStructure(Box_S)
      
      If subLevel
        If sublevel>ListIndex(\items())
          sublevel=ListIndex(\items())
        EndIf
      EndIf
      
      If \a
        If subLevel = \a\subLevel 
          \items()\a = \a\a
        ElseIf subLevel > \a\subLevel 
          \items()\a = \a
          *last = \items()
        ElseIf \a\a
          \items()\a = \a\a\a
        EndIf
        
        If \items()\a And subLevel > \items()\a\subLevel
          sublevel = \items()\a\sublevel + 1
          \items()\a\childrens + 1
          ;             \items()\a\Box\Checked = 1
          ;             \items()\hide = 1
        EndIf
      Else
        \items()\a = \items()
      EndIf
      
      
      \a = \items()
      \items()\change = 1
      \items()\index= Item
      \items()\index[1] =- 1
      \items()\text\change = 1
      \items()\text\string.s = Text.s
      \items()\sublevel = sublevel
      \items()\height = \Text\height
      
      Set_Image(\items(), Image)
      
      \items()\y = \s\height
      \s\height + \items()\height
      
      \Image = AllocateStructure(Image_S)
      \image\imageID = \items()\image\imageID
      \image\width = \items()\image\width+4
      \CountItems + 1
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure ListIcon_AddItem(*This.Widget_S,Item.i,Text.s,Image.i=-1,sublevel.i=0)
    Static *last.Items_S
    Static adress.i
    Protected Childrens.i, hide.b, height.i
    
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      height = 16
    CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      height = 20
    CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
      height = 18
    CompilerEndIf
    
    If Not *This
      ProcedureReturn -1
    EndIf
    
    With *This
      ForEach \Columns()
        
        ;{ Генерируем идентификатор
        If 0 > Item Or Item > ListSize(\Columns()\items()) - 1
          LastElement(\Columns()\items())
          AddElement(\Columns()\items()) 
          Item = ListIndex(\Columns()\items())
        Else
          SelectElement(\Columns()\items(), Item)
          ;       PreviousElement(\Columns()\items())
          ;       If \a\sublevel = \Columns()\items()\sublevel
          ;          \a = \Columns()\items()
          ;       EndIf
          
          ;       SelectElement(\Columns()\items(), Item)
          If \a\sublevel = *last\sublevel
            \a = *last
          EndIf
          
          If \Columns()\items()\sublevel>sublevel
            sublevel=\Columns()\items()\sublevel
          EndIf
          InsertElement(\Columns()\items())
          
          PushListPosition(\Columns()\items())
          While NextElement(\Columns()\items())
            \Columns()\items()\index = ListIndex(\Columns()\items())
          Wend
          PopListPosition(\Columns()\items())
        EndIf
        ;}
        
        \Columns()\items() = AllocateStructure(Items_S)
        \Columns()\items()\Box = AllocateStructure(Box_S)
        
        If subLevel
          If sublevel>ListIndex(\Columns()\items())
            sublevel=ListIndex(\Columns()\items())
          EndIf
        EndIf
        
        If \a
          If subLevel = \a\subLevel 
            \Columns()\items()\a = \a\a
          ElseIf subLevel > \a\subLevel 
            \Columns()\items()\a = \a
            *last = \Columns()\items()
          ElseIf \a\a
            \Columns()\items()\a = \a\a\a
          EndIf
          
          If \Columns()\items()\a And subLevel > \Columns()\items()\a\subLevel
            sublevel = \Columns()\items()\a\sublevel + 1
            \Columns()\items()\a\childrens + 1
            ;             \Columns()\items()\a\Box\Checked = 1
            ;             \Columns()\items()\hide = 1
          EndIf
        Else
          \Columns()\items()\a = \Columns()\items()
        EndIf
        
        
        \a = \Columns()\items()
        \Columns()\items()\change = 1
        \Columns()\items()\index= Item
        \Columns()\items()\index[1] =- 1
        \Columns()\items()\text\change = 1
        \Columns()\items()\text\string.s = Text.s
        \Columns()\items()\sublevel = sublevel
        \Columns()\items()\height = \Text\height
        
        Set_Image(\Columns()\items(), Image)
        
        \Columns()\items()\y = \s\height
        \s\height + \Columns()\items()\height
        
        \image\imageID = \Columns()\items()\image\imageID
        \image\width = \Columns()\items()\image\width+4
        \CountItems + 1
        
        
        \Columns()\Items()\text\string.s = StringField(Text.s, ListIndex(\Columns()) + 1, #LF$)
        \Columns()\Color = Color_Default
        \Columns()\Color\Fore[0] = 0 
        \Columns()\Color\Fore[1] = 0
        \Columns()\Color\Fore[2] = 0
        
        \Columns()\Items()\Y = \s\height
        \Columns()\Items()\height = height
        \Columns()\Items()\change = 1
        
        \image\width = \Columns()\Items()\image\width
        ;         If ListIndex(\Columns()\Items()) = 0
        ;           PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
        ;         EndIf
      Next
      
      \s\height + height
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure Property_AddItem(*This.Widget_S,Item.i,Text.s,Image.i=-1,sublevel.i=0)
    Static *adress.Items_S
    
    If Not *This
      ProcedureReturn 0
    EndIf
    
    With *This
      ;{ Генерируем идентификатор
      If Item =- 1 Or Item > ListSize(\items()) - 1
        LastElement(\items())
        AddElement(\items()) 
        Item = ListIndex(\items())
      Else
        SelectElement(\items(), Item)
        If \items()\sublevel>sublevel
          sublevel=\items()\sublevel 
        EndIf
        
        InsertElement(\items())
        
        PushListPosition(\items())
        While NextElement(\items())
          \items()\index= ListIndex(\items())
        Wend
        PopListPosition(\items())
      EndIf
      ;}
      
      \items() = AllocateStructure(Items_S)
      \items()\Box = AllocateStructure(Box_S)
      
      If subLevel
        If sublevel>ListIndex(\items())
          sublevel=ListIndex(\items())
        EndIf
        
        PushListPosition(\items()) 
        While PreviousElement(\items()) 
          If subLevel = \items()\subLevel
            *adress = \items()\a
            Break
          ElseIf subLevel > \items()\subLevel
            *adress = \items()
            Break
          EndIf
        Wend 
        PopListPosition(\items()) 
        
        If *adress
          If subLevel > *adress\subLevel
            sublevel = *adress\sublevel + 1
            *adress\childrens + 1
            ;             *adress\Box\Checked = 1
            ;             \items()\hide = 1
          EndIf
        EndIf
      EndIf
      
      \items()\change = 1
      \items()\index= Item
      \items()\index[1] =- 1
      \items()\a = *adress
      \items()\text\change = 1
      
      Protected Type$ = Trim(StringField(Text, 1, " "))
      Protected Info$ = Trim(StringField(Text, 2, " ")) 
      
      If sublevel
        If Info$ : Info$+":" : EndIf
      EndIf
      
      Protected Title$ = Trim(StringField(Text, 3, " "))
      
      
      \items()\text\string.s = Info$
      \items()\text[1]\string.s = Title$
      \items()\sublevel = sublevel
      \items()\height = \Text\height
      
      Set_Image(\items(), Image)
      \CountItems + 1
    EndWith
    
    ProcedureReturn Item
  EndProcedure
  
  Procedure InitEvent( *This.Widget_S)
    If *This
      With *This
        ;If ListSize(\Childrens())
        ForEach \Childrens()
          \Childrens()\Canvas\Gadget = \Canvas\Gadget
          
          If \Childrens()\Deactive
            If \Childrens()\Deactive <> \Childrens()
              Events(\Childrens()\Deactive, \Childrens()\Deactive\at, #PB_EventType_LostFocus, 0, 0)
            EndIf
            
            Events(\Childrens(), \Childrens()\at, #PB_EventType_Focus, 0, 0)
            \Childrens()\Deactive = 0
          EndIf
          
          If ListSize(\Childrens()\Childrens())
            InitEvent(\Childrens())
          EndIf
        Next
      ;EndIf
    EndWith
    EndIf
  EndProcedure
  
  Procedure Move(*This.Widget_S, Width)
    Protected Left,Right
    
    With *This
      Right =- TextWidth(Mid(\Text\String.s, \Items()\Text\Pos, \Text\Caret))
      Left = (Width + Right)
      
      If \S\X < Right
        ; Scroll::SetState(\S\h, -Right)
        \S\X = Right
      ElseIf \S\X > Left
        ; Scroll::SetState(\S\h, -Left) 
        \S\X = Left
      ElseIf (\S\X < 0 And \Canvas\Input = 65535 ) : \Canvas\Input = 0
        \S\X = (Width-\Items()\Text[3]\Width) + Right
        If \S\X>0 : \S\X=0 : EndIf
      EndIf
    EndWith
    
    ProcedureReturn Left
  EndProcedure
  
  
  ;-
  ;- DRAWING
  Procedure.i Draw_Box(X,Y, Width, Height, Type, Checked, Color, BackColor, Radius, Alpha=255) 
    Protected I, checkbox_backcolor
    
    DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
    If Checked
      BackColor = $F67905&$FFFFFF|255<<24
      BackColor($FFB775&$FFFFFF|255<<24) 
      FrontColor($F67905&$FFFFFF|255<<24)
    Else
      BackColor = $7E7E7E&$FFFFFF|255<<24
      BackColor($FFFFFF&$FFFFFF|255<<24)
      FrontColor($EEEEEE&$FFFFFF|255<<24)
    EndIf
    
    LinearGradient(X,Y, X, (Y+Height))
    RoundBox(X,Y,Width,Height, Radius,Radius)
    BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
    
    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
    RoundBox(X,Y,Width,Height, Radius,Radius, BackColor)
    
    If Checked
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      If Type = 1
        Circle(x+5,y+5,2,Color&$FFFFFF|alpha<<24)
      ElseIf Type = 3
        For i = 0 To 1
          LineXY((X+2),(i+Y+6),(X+3),(i+Y+7),Color&$FFFFFF|alpha<<24) ; Левая линия
          LineXY((X+7+i),(Y+2),(X+4+i),(Y+8),Color&$FFFFFF|alpha<<24) ; правая линия
                                                                      ;           LineXY((X+1),(i+Y+5),(X+3),(i+Y+7),Color&$FFFFFF|alpha<<24) ; Левая линия
                                                                      ;           LineXY((X+8+i),(Y+3),(X+3+i),(Y+8),Color&$FFFFFF|alpha<<24) ; правая линия
        Next
      EndIf
    EndIf
    
  EndProcedure
  
  Procedure.i Draw_String(*This.Widget_S, scroll_x,scroll_y)
    
    With *This
      Protected Alpha = \color\alpha<<24
      
      ; Draw frame
      If \Color\Back
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color\Back&$FFFFFF|Alpha)
      EndIf
      
      ;       If \Text\Change : \Text\Change = #False
      ;         \Text\Width = TextWidth(\Text\String.s) 
      ;         
      ;         If \Text\FontID 
      ;           \Text\Height = TextHeight("A") 
      ;         Else
      ;           \Text\Height = *This\Text\Height[1]
      ;         EndIf
      ;       EndIf 
      
      If \Text[1]\Change : \Text[1]\Change = #False
        \Text[1]\Width = TextWidth(\Text[1]\String.s) 
      EndIf 
      
      If \Text[3]\Change : \Text[3]\Change = #False 
        \Text[3]\Width = TextWidth(\Text[3]\String.s)
      EndIf 
      
      If \Text[2]\Change : \Text[2]\Change = #False 
        \Text[2]\X = \Text\X+\Text[1]\Width
        ; Debug "get caret "+\Text[3]\Len
        \Text[2]\Width = TextWidth(\Text[2]\String.s) ;+ Bool(\Text\Len = \Text[2]\Len Or \Text[2]\Len =- 1 Or \Text[3]\Len = 0) * *This\Flag\FullSelection ; TextWidth() - bug in mac os
        \Text[3]\X = \Text[2]\X+\Text[2]\Width
      EndIf 
      
      Protected IT,Text_Y,Text_X, X,Y, Width,Height, Drawing
      Protected angle.f
      
      
      Height = \Text\Height
      Y = \Text\Y
      Text_X = \Text\X
      Text_Y = \Text\Y
      Angle = Bool(\Text\Vertical) * *This\Text\Rotate
      Protected Front_BackColor_1 = *This\Color\Front[*This\Color\State]&$FFFFFF|*This\color\alpha<<24
      Protected Front_BackColor_2 = *This\Color\Front[2]&$FFFFFF|*This\color\alpha<<24 
      
      ; Draw string
      If \Text[2]\Len And *This\Color\Front <> *This\Color\Front[2]
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          If (*This\Text\Caret[1] > *This\Text\Caret And *This\index[2] = *This\index[1]) Or
             (\index = *This\index[1] And *This\index[2] > *This\index[1])
            \Text[3]\X = \Text\X+TextWidth(Left(\Text\String.s, *This\Text\Caret[1])) 
            
            If *This\index[2] = *This\index[1]
              \Text[2]\X = \Text[3]\X-\Text[2]\Width
            EndIf
            
            If \Text[3]\String.s
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawRotatedText(\Text[3]\X, Text_Y, \Text[3]\String.s, angle, Front_BackColor_1)
            EndIf
            
            If *This\Color\Fore[2]
              DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
              BoxGradient(\Vertical,\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,\Color\Fore[2]&$FFFFFF|\color\alpha<<24,\Color\Back[2]&$FFFFFF|\color\alpha<<24,\Radius)
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, \Color\Back[2]&$FFFFFF|\color\alpha<<24 )
            EndIf
            
            If \Text[2]\String.s
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s+\Text[2]\String.s, angle, Front_BackColor_2)
            EndIf
            
            If \Text[1]\String.s
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s, angle, Front_BackColor_1)
            EndIf
          Else
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawRotatedText(Text_X, Text_Y, \Text\String.s, angle, Front_BackColor_1)
            
            If *This\Color\Fore[2]
              DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
              BoxGradient(\Vertical,\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,\Color\Fore[2]&$FFFFFF|\color\alpha<<24,\Color\Back[2]&$FFFFFF|\color\alpha<<24,\Radius)
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, \Color\Back[2]&$FFFFFF|\color\alpha<<24)
            EndIf
            
            If \Text[2]\String.s
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawRotatedText(\Text[2]\X, Text_Y, \Text[2]\String.s, angle, Front_BackColor_2)
            EndIf
          EndIf
        CompilerElse
          If \Text[1]\String.s
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawRotatedText(Text_X, Text_Y, \Text[1]\String.s, angle, Front_BackColor_1)
          EndIf
          
          If *This\Color\Fore[2]
            DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            BoxGradient(\Vertical,\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height,\Color\Fore[2]&$FFFFFF|\color\alpha<<24,\Color\Back[2]&$FFFFFF|\color\alpha<<24,\Radius)
          Else
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, \Color\Back[2]&$FFFFFF|\color\alpha<<24)
          EndIf
          
          If \Text[2]\String.s
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawRotatedText(\Text[2]\X, Text_Y, \Text[2]\String.s, angle, Front_BackColor_2)
          EndIf
          
          If \Text[3]\String.s
            DrawingMode(#PB_2DDrawing_Transparent)
            DrawRotatedText(\Text[3]\X, Text_Y, \Text[3]\String.s, angle, Front_BackColor_1)
          EndIf
        CompilerEndIf
        
      Else
        If \Text[2]\Len
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Box(\Text[2]\X, Y, \Text[2]\Width+\Text[2]\Width[2], Height, \Color\Back[2]&$FFFFFF|\color\alpha<<24)
        EndIf
        
        If \Color\State = 2
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, angle, Front_BackColor_2)
        Else
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawRotatedText(Text_X, Text_Y, \Text[0]\String.s, angle, Front_BackColor_1)
        EndIf
      EndIf
      
      ; Draw caret
      If \Text\Editable And \Focus : DrawingMode(#PB_2DDrawing_XOr)   
        Line(\Text\X + \Text[1]\Width + Bool(\Text\Caret[1] > \Text\Caret) * \Text[2]\Width - Bool(#PB_Compiler_OS = #PB_OS_Windows), \Text\y, 1, \Text\Height, $FFFFFFFF)
      EndIf
      
      
      ; Draw frame
      If \Color\Frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw_Window(*This.Widget_S, scroll_x,scroll_y)
    With *This 
      Protected sx,sw,x = \x
      Protected px=2,py
      Protected start, stop
      
      Protected State_3 = \Color\State
      Protected Alpha = \color\alpha<<24
      
      ; Draw caption frame
      If \Box\Color\back[State_3]<>-1
        If \Box\Color\Fore[\Focus*2]
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        Else
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        EndIf
        BoxGradient( \Vertical, \Box\x, \Box\y, \Box\width, \Box\height, \Box\Color\Fore[\Focus*2], \Box\Color\Back[\Focus*2], \Radius, \Box\color\alpha)
      EndIf
      
      ; Draw image
      If \image\ImageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\ImageID, \image\x, \image\y, \color\alpha)
      EndIf
      
      ; Draw string
      If \Text\String
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front[\Focus*2]&$FFFFFF|Alpha)
      EndIf
      Protected Radius = 4
      
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      RoundBox( \Box\x[1], \Box\y[1], \Box\width[1], \Box\height[1], Radius, Radius, $FF0000FF&$FFFFFF|\color[1]\alpha<<24)
      RoundBox( \Box\x[2], \Box\y[2], \Box\width[2], \Box\height[2], Radius, Radius, $FFFF0000&$FFFFFF|\color[2]\alpha<<24)
      RoundBox( \Box\x[3], \Box\y[3], \Box\width[3], \Box\height[3], Radius, Radius, $FF00FF00&$FFFFFF|\color[3]\alpha<<24)
      
      ; Draw caption frame
      If \Color\Frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[1], \Y+\bs-\fs, \Width[1], \TabHeight+\fs, \Radius, \Radius, \Color\Frame&$FFFFFF|Alpha)
      EndIf
      
      ; Draw background  
      If \Color\back[State_3]<>-1
        If \Color\Fore[State_3]
          DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        Else
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        EndIf
        BoxGradient( \Vertical, \X[2], \Y[2], \Width[2], \Height[2], \Color\Fore, \Color\Back, \Radius, \color\alpha)
      EndIf
      
      ; Draw background image
      If \image[1]\ImageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\ImageID, \image[1]\x, \image[1]\y, \color\alpha)
      EndIf
      
      ; Draw inner frame 
      If \Color\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \x[1], \y[1], \width[1], \height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|Alpha)
      EndIf
      
      ; Draw out frame
      If \Color\Frame[State_3] 
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X, \Y, \Width, \Height, \Radius, \Radius, \Color\Frame[State_3]&$FFFFFF|Alpha)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Draw_Scroll(*This.Widget_S, scroll_x,scroll_y)
    Protected.i State_0, State_1, State_2, State_3, Alpha, LinesColor
    
    With *This 
      ; ClipOutput(\x,\y,\width,\height)
      
      ;       Debug ""+Str(\Area\Pos+\Area\len) +" "+ \Box\x[2]
      ;       Debug ""+Str(\Area\Pos+\Area\len) +" "+ \Box\y[2]
      ;Debug \width
      State_0 = \Color[0]\State
      State_1 = \Color[1]\State
      State_2 = \Color[2]\State
      State_3 = \Color[3]\State
      Alpha = \color\alpha<<24
      LinesColor = \Color[3]\Front[State_3]&$FFFFFF|Alpha
      
      ; Draw scroll bar background
      If \Color\Back[State_0]<>-1
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
       ; RoundBox( \X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color\Back[State_0]&$FFFFFF|Alpha)
        RoundBox( \X, \Y, \Width, \Height, \Radius, \Radius, \Color\Back[State_0]&$FFFFFF|Alpha)
      EndIf
      
      ; Draw line
      If \Color\Line[State_0]<>-1
        If \Vertical
          Line( \X, \Y, 1, \Page\len + Bool(\height<>\Page\len), \Color\Line[State_0]&$FFFFFF|Alpha)
        Else
          Line( \X, \Y, \Page\len + Bool(\width<>\Page\len), 1, \Color\Line[State_0]&$FFFFFF|Alpha)
        EndIf
      EndIf
      
      If \Thumb\len 
        ; Draw thumb  
        If \Color[3]\back[State_3]<>-1
          If \Color[3]\Fore[State_3]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          BoxGradient( \Vertical, \Box\x[3], \Box\y[3], \Box\Width[3], \Box\Height[3], \Color[3]\Fore[State_3], \Color[3]\Back[State_3], \Radius, \color\alpha)
        EndIf
        
        ; Draw thumb frame
        If \Color[3]\Frame[State_3]<>-1
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox( \Box\x[3], \Box\y[3], \Box\Width[3], \Box\Height[3], \Radius, \Radius, \Color[3]\Frame[State_3]&$FFFFFF|Alpha)
        EndIf
      EndIf
      
      If \Box\Size[1]
        ; Draw buttons
        If \Color[1]\back[State_1]<>-1
          If \Color[1]\Fore[State_1]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          BoxGradient( \Vertical, \Box\x[1], \Box\y[1], \Box\Width[1], \Box\Height[1], \Color[1]\Fore[State_1], \Color[1]\Back[State_1], \Radius, \color\alpha)
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        ; Draw buttons frame
        If \Color[1]\Frame[State_1]
          RoundBox( \Box\x[1], \Box\y[1], \Box\Width[1], \Box\Height[1], \Radius, \Radius, \Color[1]\Frame[State_1]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        Arrow( \Box\x[1]+( \Box\Width[1]-\Box\ArrowSize[1])/2, \Box\y[1]+( \Box\Height[1]-\Box\ArrowSize[1])/2, \Box\ArrowSize[1], Bool( \Vertical),
               (Bool(Not IsStart(*This)) * \Color[1]\Front[State_1] + IsStart(*This) * \Color[1]\Frame[0])&$FFFFFF|Alpha, \Box\ArrowType[1])
      EndIf
      
      If \Box\Size[2]
        ; Draw buttons
        If \Color[2]\back[State_2]<>-1
          If \Color[2]\Fore[State_2]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          BoxGradient( \Vertical, \Box\x[2], \Box\y[2], \Box\Width[2], \Box\Height[2], \Color[2]\Fore[State_2], \Color[2]\Back[State_2], \Radius, \color\alpha)
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        ; Draw buttons frame
        If \Color[2]\Frame[State_2]
          RoundBox( \Box\x[2], \Box\y[2], \Box\Width[2], \Box\Height[2], \Radius, \Radius, \Color[2]\Frame[State_2]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        Arrow( \Box\x[2]+( \Box\Width[2]-\Box\ArrowSize[2])/2, \Box\y[2]+( \Box\Height[2]-\Box\ArrowSize[2])/2, \Box\ArrowSize[2], Bool( \Vertical)+2, 
               (Bool(Not IsStop(*This)) * \Color[2]\Front[State_2] + IsStop(*This) * \Color[2]\Frame[0])&$FFFFFF|Alpha, \Box\ArrowType[2])
      EndIf
      
      If \Thumb\len And \Color[3]\Fore[State_3]<>-1  ; Draw thumb lines
        If \Focus And Not State_3 = 2
          LinesColor = $FF0000FF
        EndIf
        
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Protected size = \Box\ArrowSize[2]+3
        
        If \Vertical
          Line( \Box\x[3]+(\Box\Width[3]-(size-1))/2, \Box\y[3]+\Box\Height[3]/2-3,size,1, LinesColor)
          Line( \Box\x[3]+(\Box\Width[3]-(size-1))/2, \Box\y[3]+\Box\Height[3]/2,size,1, LinesColor)
          Line( \Box\x[3]+(\Box\Width[3]-(size-1))/2, \Box\y[3]+\Box\Height[3]/2+3,size,1, LinesColor)
        Else
          Line( \Box\x[3]+\Box\Width[3]/2-3, \Box\y[3]+(\Box\Height[3]-(size-1))/2,1,size, LinesColor)
          Line( \Box\x[3]+\Box\Width[3]/2, \Box\y[3]+(\Box\Height[3]-(size-1))/2,1,size, LinesColor)
          Line( \Box\x[3]+\Box\Width[3]/2+3, \Box\y[3]+(\Box\Height[3]-(size-1))/2,1,size, LinesColor)
        EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Draw_Spin(*This.Widget_S, scroll_x,scroll_y)
    Protected.i State_0, State_1, State_2, State_3, Alpha, LinesColor
    
    With *This 
      State_0 = \Color[0]\State
      State_1 = \Color[1]\State
      State_2 = \Color[2]\State
      State_3 = \Color[3]\State
      Alpha = \color\alpha<<24
      LinesColor = \Color[3]\Front[State_3]&$FFFFFF|Alpha
      
      ; Draw scroll bar background
      If \Color\Back[State_0]<>-1
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color\Back[State_0]&$FFFFFF|Alpha)
      EndIf
      
      ; Draw string
      If \Text\String
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\Text\x, \Text\y, \Text\String, \Color\Front[State_3]&$FFFFFF|Alpha)
      EndIf
      ; Draw_String(*This.Widget_S, scroll_x,scroll_y)
      
      If \Box\Size[2]
        Protected Radius = \height[2]/7
        If Radius > 4
          Radius = 7
        EndIf
        
        ; Draw buttons
        If \Color[1]\back[State_1]<>-1
          If \Color[1]\Fore[State_1]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          BoxGradient( \Vertical, \Box\x[1], \Box\y[1], \Box\Width[1], \Box\Height[1], \Color[1]\Fore[State_1], \Color[1]\Back[State_1], Radius, \color\alpha)
        EndIf
        
        ; Draw buttons
        If \Color[2]\back[State_2]<>-1
          If \Color[2]\Fore[State_2]
            DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
          EndIf
          BoxGradient( \Vertical, \Box\x[2], \Box\y[2], \Box\Width[2], \Box\Height[2], \Color[2]\Fore[State_2], \Color[2]\Back[State_2], Radius, \color\alpha)
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        
        ; Draw buttons frame
        If \Color[1]\Frame[State_1]
          RoundBox( \Box\x[1], \Box\y[1], \Box\Width[1], \Box\Height[1], Radius, Radius, \Color[1]\Frame[State_1]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw buttons frame
        If \Color[2]\Frame[State_2]
          RoundBox( \Box\x[2], \Box\y[2], \Box\Width[2], \Box\Height[2], Radius, Radius, \Color[2]\Frame[State_2]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        Arrow( \Box\x[1]+( \Box\Width[1]-\Box\ArrowSize[1])/2, \Box\y[1]+( \Box\Height[1]-\Box\ArrowSize[1])/2, \Box\ArrowSize[1], Bool(\Vertical)*3,
               (Bool(Not IsStart(*This)) * \Color[1]\Front[State_1] + IsStart(*This) * \Color[1]\Frame[0])&$FFFFFF|Alpha, \Box\ArrowType[1])
        
        ; Draw arrows
        Arrow( \Box\x[2]+( \Box\Width[2]-\Box\ArrowSize[2])/2, \Box\y[2]+( \Box\Height[2]-\Box\ArrowSize[2])/2, \Box\ArrowSize[2], Bool(Not \Vertical)+1, 
               (Bool(Not IsStop(*This)) * \Color[2]\Front[State_2] + IsStop(*This) * \Color[2]\Frame[0])&$FFFFFF|Alpha, \Box\ArrowType[2])
        
        
        Line(\Box\x[1]-2, \y[2],1,\height[2], \Color\Frame&$FFFFFF|Alpha)
      EndIf      
    EndWith
  EndProcedure
  
  Procedure.i Draw_ScrollArea(*This.Widget_S, scroll_x,scroll_y)
    With *This 
      ; draw background
      If \Color\Back<>-1
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color\Back&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ; Draw background image
      If \image[1]\ImageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\ImageID, \image[1]\x, \image[1]\y, \color\alpha)
      EndIf
      
      ; 1 - frame
      If \Color\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|\color\alpha<<24)
      EndIf
      
      If \s And (\s\v And \s\h)
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(\s\h\x-GetState(\s\h), \s\v\y-GetState(\s\v), \s\h\Max, \s\v\Max, $FFFF0000)
        Box(\s\h\x, \s\v\y, \s\h\Page\Len, \s\v\Page\Len, $FF00FF00)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Draw_Container(*This.Widget_S, scroll_x,scroll_y)
    With *This 
      ; draw background
      If \Color\Back<>-1
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color\Back&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ; Draw background image
      If \image[1]\ImageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\ImageID, \image[1]\x, \image[1]\y, \color\alpha)
      EndIf
      
      ; 1 - frame
      If \Color\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|\color\alpha<<24)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Draw_Frame(*This.Widget_S, scroll_x,scroll_y)
    With *This 
      If \Text\String.s
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ;       ; Draw background image
      ;       If \image[1]\ImageID
      ;         DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
      ;         DrawAlphaImage(\image[1]\ImageID, \image[1]\x, \image[1]\y, \color\alpha)
      ;       EndIf
      
      ; 1 - frame
      If \Color\Frame<>-1
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Protected h = \TabHeight/2
        Box(\x[1], \y+h, 6, \fs, \Color\Frame&$FFFFFF|\color\alpha<<24)
        Box(\Text\x+\Text\width+3, \y+h, \width[1]-((\Text\x+\Text\width)-\x)-3, \fs, \Color\Frame&$FFFFFF|\color\alpha<<24)
        
        Box(\x[1], \Y[1]-h, \fs, \height[1]+h, \Color\Frame&$FFFFFF|\color\alpha<<24)
        Box(\x[1]+\width[1]-\fs, \Y[1]-h, \fs, \height[1]+h, \Color\Frame&$FFFFFF|\color\alpha<<24)
        Box(\x[1], \Y[1]+\height[1]-\fs, \width[1], \fs, \Color\Frame&$FFFFFF|\color\alpha<<24)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Draw_Panel(*This.Widget_S, scroll_x,scroll_y)
    Protected State_3.i, Alpha.i, Color_Frame.i
    
    With *This 
      Alpha = \color\alpha<<24
      
      Protected sx,sw,x = \x
      Protected start, stop
      
      Protected clip_x = \clip\x+\Box\Size[1]+3
      Protected clip_width = \clip\width-\Box\Size[1]-\Box\Size[2]-6
      
      ; draw background
      If \Color\Back<>-1
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, $FFFFFF&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ; Draw background image
      If \image[1]\ImageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image[1]\ImageID, \image[1]\x, \image[1]\y, \color\alpha)
      EndIf
      
      If \width[2]>(\Box\width[1]+\Box\width[2]+4)
        ClipOutput(clip_x, \clip\y, clip_width, \clip\height)
        
        ForEach \items()
          If \index[2] = \items()\index
            State_3 = 2
            \items()\y = \y+2
            \items()\Height=\TabHeight-1
          Else
            State_3 = \items()\State
            \items()\y = \y+4
            \items()\Height=\TabHeight-4-1
          EndIf
          Color_Frame = \Color\Frame[State_3]&$FFFFFF|Alpha
          
          \items()\image\x[1] = 8 ; Bool(\items()\image\width) * 4
          
          If \items()\Text\Change
            \items()\Text\width = TextWidth(\items()\Text\String)
            \items()\Text\height = TextHeight("A")
          EndIf
          
          \items()\x = 2+x-\Page\Pos+\Box\Size[1]+1
          \items()\width = \items()\Text\width + \items()\image\x[1]*2 + \items()\image\width + Bool(\items()\image\width) * 3
          x + \items()\width + 1
          
          \items()\image\x = \items()\x+\items()\image\x[1] - 1
          \items()\image\y = \items()\y+(\items()\height-\items()\image\height)/2
          
          \items()\Text\x = \items()\image\x + \items()\image\width + Bool(\items()\image\width) * 3
          \items()\Text\y = \items()\y+(\items()\height-\items()\Text\height)/2
          
          \items()\Drawing = Bool(Not \items()\hide And \items()\x+\items()\width>\x+\bs And \items()\x<\x+\width-\bs)
          
          If \items()\Drawing
            ; Draw thumb  
            If \Color\back[State_3]<>-1
              If \Color\Fore[State_3]
                DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
              EndIf
              BoxGradient( \Vertical, \items()\X, \items()\Y, \items()\Width, \items()\Height, \Color\Fore[State_3], Bool(State_3 <> 2)*\Color\Back[State_3] + (Bool(State_3 = 2)*\Color\Front[State_3]), \Radius, \color\alpha)
            EndIf
            
            ; Draw string
            If \items()\Text\String
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawText(\items()\Text\x, \items()\Text\y, \items()\Text\String.s, \Color\Front[0]&$FFFFFF|Alpha)
            EndIf
            
            ; Draw image
            If \items()\image\imageID
              DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
              DrawAlphaImage(\items()\image\imageID, \items()\image\x, \items()\image\y, \color\alpha)
            EndIf
            
            ; Draw thumb frame
            If \Color\Frame[State_3] 
              DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
              
              If State_3 = 2
                Line(\items()\X, \items()\Y, \items()\Width, 1, Color_Frame)                     ; top
                Line(\items()\X, \items()\Y, 1, \items()\Height, Color_Frame)                    ; left
                Line((\items()\X+\items()\width)-1, \items()\Y, 1, \items()\Height, Color_Frame) ; right
              Else
                RoundBox( \items()\X, \items()\Y, \items()\Width, \items()\Height, \Radius, \Radius, Color_Frame)
              EndIf
            EndIf
          EndIf
          
          \items()\Text\Change = 0
          
          If State_3 = 2
            sx = \items()\x
            sw = \items()\width
            start = Bool(\items()\x=<\x[2]+\Box\Size[1]+1 And \items()\x+\items()\width>=\x[2]+\Box\Size[1]+1)*2
            stop = Bool(\items()\x=<\x[2]+\width[2]-\Box\Size[2]-2 And \items()\x+\items()\width>=\x[2]+\width[2]-\Box\Size[2]-2)*2
          EndIf
          
        Next
        
        ClipOutput(\clip\x, \clip\y, \clip\width, \clip\height)
        
        If ListSize(\items())
          Protected Value = \Box\Size[1]+((\items()\x+\items()\width+\Page\Pos)-\x[2])
          
          If \Max <> Value : \Max = Value
            \Area\Pos = \X[2]+\Box\Size[1]
            \Area\len = \width[2]-(\Box\Size[1]+\Box\Size[2])
            \Thumb\len = ThumbLength(*This)
            ;\Step = 10;\Thumb\len
            
            If \Change > 0 And SelectElement(\Items(), \Change-1)
              Protected State = (\Box\Size[1]+((\items()\x+\items()\width+\Page\Pos)-\x[2]))-\Page\Len ;
                                                                                                       ;               Debug (\Box\Size[1]+(\items()\x+\items()\width)-\x[2])-\Page\len
                                                                                                       ;               Debug State
              If State < \Min : State = \Min : EndIf
              If State > \Max-\Page\len
                If \Max > \Page\len 
                  State = \Max-\Page\len
                Else
                  State = \Min 
                EndIf
              EndIf
              
              \Page\Pos = State
            EndIf
          EndIf
        EndIf
        
        ; Линии на концах для красоты
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        If Not IsStart(*This)
          Line(\Box\x[1]+\Box\width[1]+1, \Box\y[1], 1, \TabHeight-5+start, \Color\Frame[start]&$FFFFFF|Alpha)
        EndIf
        If Not IsStop(*This)
          Line(\Box\x[2]-2, \Box\y[1], 1, \TabHeight-5+stop, \Color\Frame[stop]&$FFFFFF|Alpha)
        EndIf
      EndIf
      
      ; 1 - frame
      If \Color\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        Line(\X[2], \Y+\TabHeight, \Area\Pos-\x+2, 1, \Color\Frame&$FFFFFF|Alpha)
        
        Line(\Area\Pos, \Y+\TabHeight, sx-\Area\Pos, 1, \Color\Frame&$FFFFFF|Alpha)
        Line(sx+sw, \Y+\TabHeight, \width-((sx+sw)-\x), 1, \Color\Frame&$FFFFFF|Alpha)
        
        Line(\Box\x[2]-2, \Y+\TabHeight, \Area\Pos-\x+2, 1, \Color\Frame&$FFFFFF|Alpha)
        
        Line(\X, \Y+\TabHeight, 1, \Height-\TabHeight, \Color\Frame&$FFFFFF|Alpha)
        Line(\X+\width-1, \Y+\TabHeight, 1, \Height-\TabHeight, \Color\Frame&$FFFFFF|Alpha)
        Line(\X, \Y+\height-1, \width, 1, \Color\Frame&$FFFFFF|Alpha)
      EndIf
      
    EndWith
    
    With *This
      If \Box\Size[1] Or \Box\Size[2]
        ; Draw buttons
        
        If \Color[1]\State 
          DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox( \Box\x[1], \Box\y[1], \Box\Width[1], \Box\Height[1], \Radius, \Radius, \Box\Color[1]\Back[\Color[1]\State]&$FFFFFF|Alpha)
          DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox( \Box\x[1], \Box\y[1], \Box\Width[1], \Box\Height[1], \Radius, \Radius, \Box\Color[1]\Frame[\Color[1]\State]&$FFFFFF|Alpha)
        EndIf
        
        If \Color[2]\State 
          DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          RoundBox( \Box\x[2], \Box\y[2], \Box\Width[2], \Box\Height[2], \Radius, \Radius, \Box\Color[2]\Back[\Color[2]\State]&$FFFFFF|Alpha)
          DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          RoundBox( \Box\x[2], \Box\y[2], \Box\Width[2], \Box\Height[2], \Radius, \Radius, \Box\Color[2]\Frame[\Color[2]\State]&$FFFFFF|Alpha)
        EndIf
        
        ; Draw arrows
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        Arrow( \Box\x[1]+( \Box\Width[1]-\Box\ArrowSize[1])/2, \Box\y[1]+( \Box\Height[1]-\Box\ArrowSize[1])/2, \Box\ArrowSize[1], Bool( \Vertical),
               (Bool(Not IsStart(*This)) * \Box\Color[1]\Front[\Color[1]\State] + IsStart(*This) * \Box\Color[1]\Frame[0])&$FFFFFF|Alpha, \Box\ArrowType[1])
        
        Arrow( \Box\x[2]+( \Box\Width[2]-\Box\ArrowSize[2])/2, \Box\y[2]+( \Box\Height[2]-\Box\ArrowSize[2])/2, \Box\ArrowSize[2], Bool( \Vertical)+2, 
               (Bool(Not IsStop(*This)) * \Box\Color[2]\Front[\Color[2]\State] + IsStop(*This) * \Box\Color[2]\Frame[0])&$FFFFFF|Alpha, \Box\ArrowType[2])
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Draw_Progress(*This.Widget_S, scroll_x,scroll_y)
    With *This 
      ; Draw progress
      If \Vertical
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\X+2,\y,\Width-4,\Thumb\Pos, \Radius, \Radius,\Color[3]\Back)
        
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(\X+2,\y+2,\Width-4,\Thumb\Pos-2, \Radius, \Radius,\Color[3]\Frame)
        
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\X+2,\Thumb\Pos+\y,\Width-4,(\height-\Thumb\Pos), \Radius, \Radius,\Color[3]\Back[2])
        
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawRotatedText(\x+(\width+TextHeight("A")+2)/2, \y+(\height-TextWidth("%"+Str(\Page\Pos)))/2, "%"+Str(\Page\Pos), Bool(\Vertical) * 270, 0)
      Else
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\Thumb\Pos,\Y+2,\width-(\Thumb\Pos-\x),\height-4, \Radius, \Radius,\Color[3]\Back)
        
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(\Thumb\Pos,\Y+2,\width-(\Thumb\Pos-\x)-2,\height-4, \Radius, \Radius,\Color[3]\Frame)
        
        DrawingMode(#PB_2DDrawing_Default)
        RoundBox(\X,\Y+2,(\Thumb\Pos-\x),\height-4, \Radius, \Radius,\Color[3]\Back[2])
        
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawText(\x+(\width-TextWidth("%"+Str(\Page\Pos)))/2, \y+(\height-TextHeight("A"))/2, "%"+Str(\Page\Pos),0)
        
        ;Debug ""+\x+" "+\Thumb\Pos
      EndIf
      
      ; 2 - frame
      If \Color\Back<>-1
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox( \X+1, \Y+1, \Width-2, \Height-2, \Radius, \Radius, \Color\Back)
      EndIf
      
      ; 1 - frame
      If \Color[3]\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox( \X, \Y, \Width, \Height, \Radius, \Radius, \Color[3]\Frame)
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Draw_Property(*This.Widget_S, scroll_x,scroll_y)
    Protected y_point,x_point, level,iY, start,i, back_color=$FFFFFF, point_color=$7E7E7E, box_color=$7E7E7E
    Protected hide_color=$FEFFFF, box_size = 9,box_1_size = 12, alpha = 255, item_alpha = 255
    Protected line_size=8, box_1_pos.b = 0, checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = -1
    Protected Drawing.I, text_color, State_3
    
    
    Protected IsVertical,Pos, Size, X,Y,Width,Height, fColor, Color
    Protected Radius.d = 2, Border=1, Circle=1, Separator=0
    
    
    With *This
      If *This > 0
        If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
        DrawingMode(#PB_2DDrawing_Default)
        Box(\x, \y, \width, \height, back_color)
        
        If ListSize(\items())
          
          X = \X
          Y = \Y
          Width = \Width 
          Height = \Height
          
          ; Позиция сплиттера 
          Size = \Thumb\len
          
          If \Vertical
            Pos = \Thumb\Pos-y
          Else
            Pos = \Thumb\Pos-x
          EndIf
          
          
          ; set vertical bar state
          If \s\v\Max And \Change > 0
            If (\Change*\Text\height-\s\h\Page\len) > \s\h\Max
              \s\h\Page\Pos = (\Change*\Text\height-\s\h\Page\len)
            EndIf
          EndIf
          
          \s\Width=0
          \s\height=0
          
          ForEach \items()
            ;             If Not \items()\Text\change And Not \Resize And Not \Change
            ;               Break
            ;             EndIf
            
            ;             If Not ListIndex(\items())
            ;             EndIf
            
            If Not \items()\hide 
              \items()\width=\s\h\Page\len
              \items()\x=\s\h\x-\s\h\Page\Pos
              \items()\y=(\s\v\y+\s\height)-\s\v\Page\Pos
              
              If \items()\text\change = 1
                \items()\text\height = TextHeight("A")
                \items()\text\width = TextWidth(\items()\text\string.s)
              EndIf
              
              \items()\sublevellen=2+\items()\x+((Bool(\flag\Buttons) * \sublevellen)+\items()\sublevel * \sublevellen)
              
              \items()\box\width = box_size
              \items()\box\height = box_size
              \items()\box\x = \items()\sublevellen-(\sublevellen+\items()\box\width)/2
              \items()\box\y = (\items()\y+\items()\height)-(\items()\height+\items()\box\height)/2
              
              If \items()\image\imageID
                \items()\image\x = 3+\items()\sublevellen
                \items()\image\y = \items()\y+(\items()\height-\items()\image\height)/2
                
                \image\imageID = \items()\image\imageID
                \image\width = \items()\image\width+4
              EndIf
              
              \items()\text\x = 3+\items()\sublevellen+\image\width
              \items()\text\y = \items()\y+(\items()\height-\items()\text\height)/2
              
              If \flag\CheckBoxes
                \items()\box\x+\sublevellen-2
                \items()\text\x+\sublevellen-2
                \items()\image\x+\sublevellen-2 
                
                \items()\box\width[1] = box_1_size
                \items()\box\height[1] = box_1_size
                
                \items()\box\x[1] = \items()\x+4
                \items()\box\y[1] = (\items()\y+\items()\height)-(\items()\height+\items()\box\height[1])/2
              EndIf
              
              \s\height+\items()\height
              
              If \s\Width < (\items()\text\x-\x+\items()\text\width)+\s\h\Page\Pos
                \s\Width = (\items()\text\x-\x+\items()\text\width)+\s\h\Page\Pos
              EndIf
            EndIf
            
            \items()\Drawing = Bool(Not \items()\hide And \items()\y+\items()\height>\y+\bs And \items()\y<\y+\height-\bs)
            ;             If \items()\Drawing And Not Drawing
            ;               Drawing = @\items()
            ;             EndIf
            
            \items()\text\change = 0
            \items()\change = 0
          Next
          
          ; Задаем размеры скролл баров
          If \s\v And \s\v\Page\Len And \s\v\Max<>\s\height And 
             Widget::SetAttribute(\s\v, #PB_Bar_Maximum, \s\height)
            Widget::Resizes(\s, \x-\s\h\x+1, \y-\s\v\y+1, #PB_Ignore, #PB_Ignore)
            \s\v\Step = \Text\height
          EndIf
          
          If \s\h And \s\h\Page\Len And \s\h\Max<>\s\Width And 
             Widget::SetAttribute(\s\h, #PB_Bar_Maximum, \s\Width)
            Widget::Resizes(\s, \x-\s\h\x+1, \y-\s\v\y+1, #PB_Ignore, #PB_Ignore)
          EndIf
          
          
          
          ForEach \items()
            ;           If Drawing
            ;             \Drawing = Drawing
            ;           EndIf
            ;           
            ;           If \Drawing
            ;             ChangeCurrentElement(\items(), \Drawing)
            ;             Repeat 
            If \items()\Drawing
              \items()\width = \s\h\Page\len
              State_3 = \items()\State
              
              ; Draw selections
              If Not \items()\Childrens And \flag\FullSelection
                If State_3 = 1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+1+\s\h\Page\Pos,\items()\y+1,\items()\width-2,\items()\height-2, \Color\Back[State_3]&$FFFFFFFF|item_alpha<<24)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+\s\h\Page\Pos,\items()\y,\items()\width,\items()\height, \Color\Frame[State_3]&$FFFFFFFF|item_alpha<<24)
                EndIf
                
                If State_3 = 2
                  If \Focus : item_alpha = 200
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\s\h\Page\Pos,\items()\y+1,\items()\width-2,\items()\height-2, $E89C3D&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\s\h\Page\Pos,\items()\y,\items()\width,\items()\height, $DC9338&back_color|item_alpha<<24)
                  Else
                    ;If \flag\AlwaysSelection
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\s\h\Page\Pos,\items()\y+1,\items()\width-2,\items()\height-2, $E2E2E2&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\s\h\Page\Pos,\items()\y,\items()\width,\items()\height, $C8C8C8&back_color|item_alpha<<24)
                    ;EndIf
                  EndIf
                EndIf
              EndIf
              
              ; Draw boxes
              If \flag\Buttons And \items()\childrens
                If box_type=-1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Widget::Arrow(\items()\box\X[0]+(\items()\box\Width[0]-6)/2,\items()\box\Y[0]+(\items()\box\height[0]-6)/2, 6, Bool(Not \items()\Box\Checked)+2, \Color\Front[Bool(\Focus) * State_3]&$FFFFFFFF|alpha<<24, 0,0) 
                Else
                  DrawingMode(#PB_2DDrawing_Gradient)
                  BackColor($FFFFFF) : FrontColor($EEEEEE)
                  LinearGradient(\items()\box\x, \items()\box\y, \items()\box\x, (\items()\box\y+\items()\box\height))
                  RoundBox(\items()\box\x+1,\items()\box\y+1,\items()\box\width-2,\items()\box\height-2,box_type,box_type)
                  BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  RoundBox(\items()\box\x,\items()\box\y,\items()\box\width,\items()\box\height,box_type,box_type,box_color&$FFFFFF|alpha<<24)
                  
                  Line(\items()\box\x+2,\items()\box\y+\items()\box\height/2 ,\items()\box\width/2+1,1, box_color&$FFFFFF|alpha<<24)
                  If \items()\Box\Checked : Line(\items()\box\x+\items()\box\width/2,\items()\box\y+2,1,\items()\box\height/2+1, box_color&$FFFFFF|alpha<<24) : EndIf
                EndIf
              EndIf
              
              ; Draw plot
              If \flag\Lines 
                x_point=\items()\box\x+\items()\box\width/2
                y_point=\items()\box\y+\items()\box\height/2
                
                If x_point>\x+\fs
                  ; Horisontal plot
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Line(x_point,y_point,line_size,1, point_color&$FFFFFF|alpha<<24)
                  
                  ; Vertical plot
                  If \items()\a 
                    start=Bool(Not \items()\sublevel)
                    
                    If start 
                      start = (\y+\fs*2+\items()\a\height/2)-\s\v\Page\Pos
                    Else 
                      start = \items()\a\y+\items()\a\height+\items()\a\height/2-line_size
                    EndIf
                    
                    Line(x_point,start,1,y_point-start, point_color&$FFFFFF|alpha<<24)
                  EndIf
                EndIf
              EndIf
              
              ; Draw checkbox
              If \flag\CheckBoxes
                Draw_Box(\items()\box\x[1],\items()\box\y[1],\items()\box\width[1],\items()\box\height[1], 3, \items()\Box\Checked[1], checkbox_color, box_color, 2, alpha);, box_type)
              EndIf
              
              ; Draw image
              If \items()\image\imageID
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\items()\image\imageID, \items()\image\x, \items()\image\y, alpha)
              EndIf
              
              
              ClipOutput(\clip\x,\clip\y,\clip\width-(\width-(\Thumb\Pos-\x)),\clip\height)
              
              ; Draw string
              If \items()\text\string.s
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawText(\items()\text\x, \items()\text\y, \items()\text\string.s, \Color\Front[Bool(\Focus) * State_3]&$FFFFFFFF|alpha<<24)
              EndIf
              
              ClipOutput(\clip\x+(\Thumb\Pos-\x),\clip\y,\clip\width-(\Thumb\Pos-\x),\clip\height)
              
              ;\items()\text[1]\x[1] = 5
              \items()\text[1]\x = \x+\items()\text[1]\x[1]+\Thumb\len
              \items()\text[1]\y = \items()\text\y
              ; Draw string
              If \items()\text[1]\string.s
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawText(\items()\text[1]\x+pos, \items()\text[1]\y, \items()\text[1]\string.s, \Color\Front[Bool(\Focus) * State_3]&$FFFFFFFF|alpha<<24)
              EndIf
              
              ClipOutput(\clip\x,\clip\y,\clip\width,\clip\height)
            EndIf
            
            ;             Until Not NextElement(\items())
            ;           EndIf
          Next
          
          ; Draw Splitter
          DrawingMode(#PB_2DDrawing_Outlined) 
          Line((X+Pos)+Size/2,Y,1,Height, \Color\Frame)
        EndIf
        
        
        ;         If \bs
        ;           DrawingMode(#PB_2DDrawing_Outlined)
        ;           Box(\x, \y, \width, \height, $ADADAE)
        ;         EndIf
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i Draw_Tree(*This.Widget_S, scroll_x,scroll_y)
    Protected y_point,x_point, level,iY, start,i, back_color=$FFFFFF, point_color=$7E7E7E, box_color=$7E7E7E
    Protected hide_color=$FEFFFF,alpha = 255, item_alpha = 255
    Protected box_1_pos.b = 0, checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = -1
    Protected Drawing.I, text_color, State_3
    
    With *This
      If *This > 0
        If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
        DrawingMode(#PB_2DDrawing_Default)
        Box(\x, \y, \width, \height, back_color)
        
        If ListSize(\items())
          
          ; set vertical bar state
          If \s And \s\v\Max And \Change > 0
            \s\v\Max = \s\height
            ; \s\v\Max = \CountItems*\Text\height
            ; Debug ""+Str(\Change*\Text\height-\s\v\Page\len+\s\v\Thumb\len) +" "+ \s\v\Max
            If (\Change*\Text\height-\s\v\Page\len) <> \s\v\Page\Pos  ;> \s\v\Max
                                                                      ; \s\v\Page\Pos = (\Change*\Text\height-\s\v\Page\len)
              SetState(\s\v, (\Change*\Text\height-\s\v\Page\len))
              Debug ""+\s\v\Page\Pos+" "+Str(\Change*\Text\height-\s\v\Page\len)  +" "+\s\v\Max                                               
              
            EndIf
          EndIf
          
          If \s
            \s\Width=0
            \s\height=0
          EndIf
          
          ; Resize items
          ForEach \items()
            ;\items()\height = 20
            ;             If Not \items()\Text\change And Not \Resize And Not \Change
            ;               Break
            ;             EndIf
            
            ;             If Not ListIndex(\items())
            ;               \s\Width=0
            ;               \s\height=0
            ;             EndIf
            
            If Not \items()\hide 
              \items()\width=\s\h\Page\len
              \items()\x=\s\h\x-\s\h\Page\Pos
              \items()\y=(\s\v\y+\s\height)-\s\v\Page\Pos
              
              If \items()\text\change = 1
                
                \items()\text\height = TextHeight("A")
                \items()\text\width = TextWidth(\items()\text\string.s)
              EndIf
              
              \items()\sublevellen=2+\items()\x+((Bool(\flag\Buttons) * \sublevellen)+\items()\sublevel * \sublevellen)
              
              \items()\box\width = \flag\Buttons
              \items()\box\height = \flag\Buttons
              \items()\box\x = \items()\sublevellen-(\sublevellen+\items()\box\width)/2
              \items()\box\y = (\items()\y+\items()\height)-(\items()\height+\items()\box\height)/2
              
              If \items()\image\imageID
                \items()\image\x = 3+\items()\sublevellen
                \items()\image\y = \items()\y+(\items()\height-\items()\image\height)/2
                
                \image\imageID = \items()\image\imageID
                \image\width = \items()\image\width+4
              EndIf
              
              \items()\text\x = 3+\items()\sublevellen+\image\width
              \items()\text\y = \items()\y+(\items()\height-\items()\text\height)/2
              
              If \flag\CheckBoxes
                \items()\box\x+\sublevellen-2
                \items()\text\x+\sublevellen-2
                \items()\image\x+\sublevellen-2 
                
                \items()\box\width[1] = \flag\CheckBoxes
                \items()\box\height[1] = \flag\CheckBoxes
                
                \items()\box\x[1] = \items()\x+4
                \items()\box\y[1] = (\items()\y+\items()\height)-(\items()\height+\items()\box\height[1])/2
              EndIf
              
              \s\height+\items()\height
              
              If \s\Width < (\items()\text\x-\x+\items()\text\width)+\s\h\Page\Pos
                \s\Width = (\items()\text\x-\x+\items()\text\width)+\s\h\Page\Pos
              EndIf
            EndIf
            
            \items()\Drawing = Bool(Not \items()\hide And \items()\y+\items()\height>\y+\bs And \items()\y<\y+\height-\bs)
            ;             If \items()\Drawing And Not Drawing
            ;               Drawing = @\items()
            ;             EndIf
            
            \items()\text\change = 0
            \items()\change = 0
          Next
          
          ; set vertical scrollbar max value
          If \s\v And \s\v\Page\Len And \s\v\Max<>\s\height And 
             Widget::SetAttribute(\s\v, #PB_Bar_Maximum, \s\height) : \s\v\Step = \Text\height
            Widget::Resizes(\s, 0,0, #PB_Ignore, #PB_Ignore)
          EndIf
          
          ; set horizontal scrollbar max value
          If \s\h And \s\h\Page\Len And \s\h\Max<>\s\Width And 
             Widget::SetAttribute(\s\h, #PB_Bar_Maximum, \s\Width)
            Widget::Resizes(\s, 0,0, #PB_Ignore, #PB_Ignore)
          EndIf
          
          ; Draw items
          ForEach \items()
            
            
            ;           If Drawing
            ;             \Drawing = Drawing
            ;           EndIf
            ;           
            ;           If \Drawing
            ;             ChangeCurrentElement(\items(), \Drawing)
            ;             Repeat 
            
            If \items()\Drawing
              \items()\width=\s\h\Page\len
              State_3 = \items()\State
              
              ; Draw selections
              If \flag\FullSelection
                If State_3 = 1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+1+\s\h\Page\Pos,\items()\y+1,\items()\width-2,\items()\height-2, \Color\Back[State_3]&$FFFFFFFF|item_alpha<<24)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\items()\x+\s\h\Page\Pos,\items()\y,\items()\width,\items()\height, \Color\Frame[State_3]&$FFFFFFFF|item_alpha<<24)
                EndIf
                
                If State_3 = 2
                  If \Focus : item_alpha = 200
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\s\h\Page\Pos,\items()\y+1,\items()\width-2,\items()\height-2, $E89C3D&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\s\h\Page\Pos,\items()\y,\items()\width,\items()\height, $DC9338&back_color|item_alpha<<24)
                  Else
                    ;If \flag\AlwaysSelection
                    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+1+\s\h\Page\Pos,\items()\y+1,\items()\width-2,\items()\height-2, $E2E2E2&back_color|item_alpha<<24)
                    
                    DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                    Box(\items()\x+\s\h\Page\Pos,\items()\y,\items()\width,\items()\height, $C8C8C8&back_color|item_alpha<<24)
                    ;EndIf
                  EndIf
                EndIf
              EndIf
              
              ; Draw boxes
              If \flag\Buttons And \items()\childrens
                If box_type=-1
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Widget::Arrow(\items()\box\X[0]+(\items()\box\Width[0]-6)/2,\items()\box\Y[0]+(\items()\box\height[0]-6)/2, 6, Bool(Not \items()\Box\Checked)+2, \Color\Front[Bool(\Focus) * State_3]&$FFFFFFFF|alpha<<24, 0,0) 
                Else
                  DrawingMode(#PB_2DDrawing_Gradient)
                  BackColor($FFFFFF) : FrontColor($EEEEEE)
                  LinearGradient(\items()\box\x, \items()\box\y, \items()\box\x, (\items()\box\y+\items()\box\height))
                  RoundBox(\items()\box\x+1,\items()\box\y+1,\items()\box\width-2,\items()\box\height-2,box_type,box_type)
                  BackColor(#PB_Default) : FrontColor(#PB_Default) ; bug
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  RoundBox(\items()\box\x,\items()\box\y,\items()\box\width,\items()\box\height,box_type,box_type,box_color&$FFFFFF|alpha<<24)
                  
                  Line(\items()\box\x+2,\items()\box\y+\items()\box\height/2 ,\items()\box\width/2+1,1, box_color&$FFFFFF|alpha<<24)
                  If \items()\Box\Checked : Line(\items()\box\x+\items()\box\width/2,\items()\box\y+2,1,\items()\box\height/2+1, box_color&$FFFFFF|alpha<<24) : EndIf
                EndIf
              EndIf
              
              ; Draw plot
              If \flag\Lines 
                x_point=\items()\box\x+\items()\box\width/2
                y_point=\items()\box\y+\items()\box\height/2
                
                If x_point>\x+\fs
                  ; Horisontal plot
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Line(x_point,y_point,\Flag\Lines,1, point_color&$FFFFFF|alpha<<24)
                  
                  ; Vertical plot
                  If \items()\a 
                    start=Bool(Not \items()\sublevel)
                    
                    If start 
                      start = (\y+\fs*2+\items()\a\height/2)-\s\v\Page\Pos
                    Else 
                      start = \items()\a\y+\items()\a\height+\items()\a\height/2-\Flag\Lines
                    EndIf
                    
                    Line(x_point,start,1,y_point-start, point_color&$FFFFFF|alpha<<24)
                  EndIf
                EndIf
              EndIf
              
              ; Draw checkbox
              If \flag\CheckBoxes
                Draw_Box(\items()\box\x[1],\items()\box\y[1],\items()\box\width[1],\items()\box\height[1], 3, \items()\Box\Checked[1], checkbox_color, box_color, 2, alpha);, box_type)
              EndIf
              
              ; Draw image
              If \items()\image\imageID
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\items()\image\imageID, \items()\image\x, \items()\image\y, alpha)
              EndIf
              
              ; Draw string
              If \items()\text\string.s
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawText(\items()\text\x, \items()\text\y, \items()\text\string.s, \Color\Front[Bool(\Focus) * State_3]&$FFFFFFFF|alpha<<24)
              EndIf
            EndIf
            
            ;             Until Not NextElement(\items())
            ;           EndIf
          Next
          
        EndIf
        
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i Draw_Text(*This.Widget_S, scroll_x,scroll_y)
    Protected i.i, y.i
    
    With *This
      Protected Alpha = \color\alpha<<24
      
      ; Draw string
      If \Text\String
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front&$FFFFFF|Alpha)
          
        CompilerElse
          Protected *Sta.Character = @\Text\String.s
          Protected *End.Character = @\Text\String.s 
          #SOC = SizeOf(Character)
          
          While *End\c 
            If *End\c = #LF
              DrawText(\Text\x, \Text\y+y, PeekS(*Sta, (*End-*Sta)>>#PB_Compiler_Unicode), \Color\Front&$FFFFFF|Alpha)
              *Sta = *End + #SOC 
              y+\Text\height
            EndIf 
            *End + #SOC 
          Wend
          
          ;         For i=1 To \CountItems
          ;           DrawText(\Text\x, \Text\y+y, StringField(\Text\String.s, i, #LF$), \Color\Front&$FFFFFF|Alpha)
          ;           y+\Text\height
          ;         Next
        CompilerEndIf  
      EndIf
      
      ; Draw frame
      If \Color\Frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw_CheckBox(*This.Widget_S, scroll_x,scroll_y)
    Protected i.i, y.i
    
    With *This
      Protected Alpha = \color\alpha<<24
      \box\x = \x[2]+3
      \box\y = \y[2]+(\height[2]-\Box\height)/2
      
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      RoundBox( \box\x,\box\y,\box\width,\box\height, \Radius, \Radius, \Color\Back&$FFFFFF|Alpha)
      
      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
      RoundBox( \box\x,\box\y,\box\width,\box\height, \Radius, \Radius, \Color\Frame[\Focus*2]&$FFFFFF|Alpha)
      
      If \box\Checked = #PB_Checkbox_Checked
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        For i = 0 To 2
          LineXY((\box\X+3),(i+\box\Y+8),(\box\X+7),(i+\box\Y+9), \Color\Frame[\Focus*2]&$FFFFFF|Alpha) 
          LineXY((\box\X+10+i),(\box\Y+3),(\box\X+6+i),(\box\Y+10), \Color\Frame[\Focus*2]&$FFFFFF|Alpha)
        Next
      ElseIf \box\Checked = #PB_Checkbox_Inbetween
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox( \box\x+2,\box\y+2,\box\width-4,\box\height-4, \Radius-2, \Radius-2, \Color\Frame[\Focus*2]&$FFFFFF|Alpha)
      EndIf
      
      ; Draw string
      If \Text\String
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front&$FFFFFF|Alpha)
          
        CompilerElse
          Protected *Sta.Character = @\Text\String.s
          Protected *End.Character = @\Text\String.s 
          #SOC = SizeOf(Character)
          
          While *End\c 
            If *End\c = #LF
              DrawText(\Text\x, \Text\y+y, PeekS(*Sta, (*End-*Sta)>>#PB_Compiler_Unicode), \Color\Front&$FFFFFF|Alpha)
              *Sta = *End + #SOC 
              y+\Text\height
            EndIf 
            *End + #SOC 
          Wend
          
          ;         For i=1 To \CountItems
          ;           DrawText(\Text\x, \Text\y+y, StringField(\Text\String.s, i, #LF$), \Color\Front&$FFFFFF|Alpha)
          ;           y+\Text\height
          ;         Next
        CompilerEndIf  
      EndIf
      
      ; Draw frame
      If \Color\Frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw_Option(*This.Widget_S, scroll_x,scroll_y)
    Protected i.i, y.i
    Protected line_size=8, box_1_pos.b = 0, checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = -1, box_color=$7E7E7E
    
    With *This
      Protected Alpha = \color\alpha<<24
      Protected Radius = \box\width/2
      \box\x = \x[2]+3
      \box\y = \y[2]+(\height[2]-\Box\width)/2
      
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      RoundBox( \box\x,\box\y,\box\width,\box\width, Radius, Radius, \Color\Back&$FFFFFF|Alpha)
      
      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
      Circle(\box\x+Radius,\box\y+Radius, Radius, \Color\Frame[\Focus*2]&$FFFFFF|Alpha)
      
      If \box\Checked > 0
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Circle(\box\x+Radius,\box\y+Radius, 2, \Color\Frame[\Focus*2]&$FFFFFFFF|Alpha)
      EndIf
      
      ; Draw string
      If \Text\String
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front&$FFFFFF|Alpha)
          
        CompilerElse
          Protected *Sta.Character = @\Text\String.s
          Protected *End.Character = @\Text\String.s 
          #SOC = SizeOf(Character)
          
          While *End\c 
            If *End\c = #LF
              DrawText(\Text\x, \Text\y+y, PeekS(*Sta, (*End-*Sta)>>#PB_Compiler_Unicode), \Color\Front&$FFFFFF|Alpha)
              *Sta = *End + #SOC 
              y+\Text\height
            EndIf 
            *End + #SOC 
          Wend
          
          ;         For i=1 To \CountItems
          ;           DrawText(\Text\x, \Text\y+y, StringField(\Text\String.s, i, #LF$), \Color\Front&$FFFFFF|Alpha)
          ;           y+\Text\height
          ;         Next
        CompilerEndIf  
      EndIf
      
      ; Draw frame
      If \Color\Frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  Procedure.i Draw_Splitter(*This.Widget_S, scroll_x,scroll_y)
    Protected IsVertical,Pos, Size, X,Y,Width,Height, fColor, Color
    Protected Radius.d = 2, Border=1, Circle=1, Separator=0
    
    With *This
      Protected Alpha = \color\alpha<<24
      
      If *This > 0
        X = \X
        Y = \Y
        Width = \Width 
        Height = \Height
        
        ; Позиция сплиттера 
        Size = \Thumb\len
        
        If \Vertical
          Pos = \Thumb\Pos-y
        Else
          Pos = \Thumb\Pos-x
        EndIf
        
        If Border And (Pos > 0 And pos < \Area\len)
          fColor = \Color\Frame&$FFFFFF|Alpha;\Color[3]\Frame[0]
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend) 
          If \Vertical
            If \Type[1]<>#PB_GadgetType_Splitter
              Box(X,Y,Width,Pos,fColor) 
            EndIf
            If \Type[2]<>#PB_GadgetType_Splitter
              Box( X,Y+(Pos+Size),Width,(Height-(Pos+Size)),fColor)
            EndIf
          Else
            If \Type[1]<>#PB_GadgetType_Splitter
              Box(X,Y,Pos,Height,fColor) 
            EndIf 
            If \Type[2]<>#PB_GadgetType_Splitter
              Box(X+(Pos+Size), Y,(Width-(Pos+Size)),Height,fColor)
            EndIf
          EndIf
        EndIf
        
        If Circle
          Color = $FF000000;\Color[3]\Frame[\Color[3]\State]
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend) 
          If \Vertical ; horisontal
            Circle(X+((Width-Radius)/2-((Radius*2+2)*2+2)),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2-(Radius*2+2)),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2+(Radius*2+2)),Y+Pos+Size/2,Radius,Color)
            Circle(X+((Width-Radius)/2+((Radius*2+2)*2+2)),Y+Pos+Size/2,Radius,Color)
          Else
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2-((Radius*2+2)*2+2)),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2-(Radius*2+2)),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2+(Radius*2+2)),Radius,Color)
            Circle(X+Pos+Size/2,Y+((Height-Radius)/2+((Radius*2+2)*2+2)),Radius,Color)
          EndIf
          
        ElseIf Separator
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend) 
          If \Vertical
            ;Box(X,(Y+Pos),Width,Size,Color)
            Line(X,(Y+Pos)+Size/2,Width,1,\Color\Frame&$FFFFFF|Alpha)
          Else
            ;Box(X+Pos,Y,Size,Height,Color)
            Line((X+Pos)+Size/2,Y,1,Height,\Color\Frame&$FFFFFF|Alpha)
          EndIf
        EndIf
        
        ; ;         If \Vertical
        ; ;           ;Box(\Box\x[3], \Box\y[3]+\Box\Height[3]-\Thumb\len, \Box\Width[3], \Thumb\len, $FF0000)
        ; ;           Box(X,Y,Width,Height/2,$FF0000)
        ; ;         Else
        ; ;           ;Box(\Box\x[3]+\Box\Width[3]-\Thumb\len, \Box\y[3], \Thumb\len, \Box\Height[3], $FF0000)
        ; ;           Box(X,Y,Width/2,Height,$FF0000)
        ; ;         EndIf
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Draw_Track(*This.Widget_S, scroll_x,scroll_y)
    With *This 
      Protected i, a = 3
      DrawingMode(#PB_2DDrawing_Default)
      Box(*This\X[0],*This\Y[0],*This\Width[0],*This\Height[0],\Color[0]\Back)
      
      If \Vertical
        DrawingMode(#PB_2DDrawing_Default)
        Box(\X[0]+5,\Y[0],a,\Height[0],\Color[3]\Frame)
        Box(\X[0]+5,\Y[0]+\Thumb\Pos,a,(\y+\height)-\Thumb\Pos,\Color[3]\Back[2])
      Else
        DrawingMode(#PB_2DDrawing_Default)
        Box(\X[0],\Y[0]+5,\Width[0],a,\Color[3]\Frame)
        Box(\X[0],\Y[0]+5,\Thumb\Pos-\x,a,\Color[3]\Back[2])
      EndIf
      
      If \Vertical
        DrawingMode(#PB_2DDrawing_Default)
        Box(\Box\x[3],\Box\y[3],\Box\Width[3]/2,\Box\Height[3],\Color[3]\Back[\Color[3]\State])
        
        Line(\Box\x[3],\Box\y[3],1,\Box\Height[3],\Color[3]\Frame[\Color[3]\State])
        Line(\Box\x[3],\Box\y[3],\Box\Width[3]/2,1,\Color[3]\Frame[\Color[3]\State])
        Line(\Box\x[3],\Box\y[3]+\Box\Height[3]-1,\Box\Width[3]/2,1,\Color[3]\Frame[\Color[3]\State])
        Line(\Box\x[3]+\Box\Width[3]/2,\Box\y[3],\Box\Width[3]/2,\Box\Height[3]/2+1,\Color[3]\Frame[\Color[3]\State])
        Line(\Box\x[3]+\Box\Width[3]/2,\Box\y[3]+\Box\Height[3]-1,\Box\Width[3]/2,-\Box\Height[3]/2-1,\Color[3]\Frame[\Color[3]\State])
        
      Else
        DrawingMode(#PB_2DDrawing_Default)
        Box(\Box\x[3],\Box\y[3],\Box\Width[3],\Box\Height[3]/2,\Color[3]\Back[\Color[3]\State])
        
        Line(\Box\x[3],\Box\y[3],\Box\Width[3],1,\Color[3]\Frame[\Color[3]\State])
        Line(\Box\x[3],\Box\y[3],1,\Box\Height[3]/2,\Color[3]\Frame[\Color[3]\State])
        Line(\Box\x[3]+\Box\Width[3]-1,\Box\y[3],1,\Box\Height[3]/2,\Color[3]\Frame[\Color[3]\State])
        Line(\Box\x[3],\Box\y[3]+\Box\Height[3]/2,\Box\Width[3]/2+1,\Box\Height[3]/2,\Color[3]\Frame[\Color[3]\State])
        Line(\Box\x[3]+\Box\Width[3]-1,\Box\y[3]+\Box\Height[3]/2,-\Box\Width[3]/2-1,\Box\Height[3]/2,\Color[3]\Frame[\Color[3]\State])
      EndIf
      
      If \Ticks
        Protected PlotStep = 5;(\width)/(\Max-\Min)
        
        For i=3 To (\Width-PlotStep)/2 
          If Not ((\X+i-3)%PlotStep)
            Box(\X+i, \Y[3]+\Box\Height[3]-4, 1, 4, $FF808080)
          EndIf
        Next
        For i=\Width To (\Width-PlotStep)/2+3 Step - 1
          If Not ((\X+i-6)%PlotStep)
            Box(\X+i, \Box\y[3]+\Box\Height[3]-4, 1, 4, $FF808080)
          EndIf
        Next
      EndIf
      
      
    EndWith
  EndProcedure
  
  Procedure.i Draw_Image(*This.Widget_S, scroll_x,scroll_y)
    With *This 
      
      ClipOutput(\x[2],\y[2],\s\h\Page\len,\s\v\Page\len)
      
      ; Draw image
      If \image\imageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\imageID, \image\x, \image\y, \color\alpha)
      EndIf
      
      ClipOutput(\clip\x,\clip\y,\clip\width,\clip\height)
      
      ; 2 - frame
      If \Color\Back<>-1
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox( \X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, \Color\Back)
      EndIf
      
      ; 1 - frame
      If \Color\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(\X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame)
      EndIf
    EndWith
    
    With *This\s
      ; Scroll area coordinate
      Box(\h\x-\h\Page\Pos, \v\y-\v\Page\Pos, \h\Max, \v\Max, $FF0000)
      
      ; page coordinate
      Box(\h\x, \v\y, \h\Page\Len, \v\Page\Len, $00FF00)
    EndWith
  EndProcedure
  
  Procedure.i Draw_Button(*This.Widget_S, scroll_x,scroll_y)
    With *This
      Protected State = \Color\State
      Protected Alpha = \color\alpha<<24
      
      ; Draw background  
      If \Color\back[State]<>-1
        If \Color\Fore[State]
          DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        EndIf
        BoxGradient( \Vertical, \X[2], \Y[2], \Width[2], \Height[2], \Color\Fore[State], \Color\Back[State], \Radius, \color\alpha)
      EndIf
      
      ; Draw image
      If \image\imageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\imageID, \image\x, \image\y, \color\alpha)
      EndIf
      
      ; Draw string
      If \Text\String
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front[State]&$FFFFFF|Alpha)
      EndIf
      
      ; Draw frame
      If \Color\Frame[State] 
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame[State]&$FFFFFF|Alpha)
      EndIf
      
    EndWith 
  EndProcedure
  
  Procedure.i Draw_ComboBox(*This.Widget_S, scroll_x,scroll_y)
    With *This
      Protected State = \Color\State
      Protected Alpha = \color\alpha<<24
      
      If \Box\Checked
        State = 2
      EndIf
      
      ; Draw background  
      If \Color\back[State]<>-1
        If \Color\Fore[State]
          DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
        EndIf
        BoxGradient( \Vertical, \X[2], \Y[2], \Width[2], \Height[2], \Color\Fore[State], \Color\Back[State], \Radius, \color\alpha)
      EndIf
      
      ; Draw image
      If \image\imageID
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawAlphaImage(\image\imageID, \image\x, \image\y, \color\alpha)
      EndIf
      
      ; Draw string
      If \Text\String
        ClipOutput(\clip\x,\clip\y,\clip\width-\Box\width-\Text\x[2],\clip\height)
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front[State]&$FFFFFF|Alpha)
        ClipOutput(\clip\x,\clip\y,\clip\width,\clip\height)
      EndIf
      
      \Box\x = \x+\width-\Box\width -\Box\ArrowSize/2
      \Box\Height = \height[2]
      \Box\y = \y
      
      ; Draw arrows
      DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      Arrow(\Box\x+(\Box\Width-\Box\ArrowSize)/2, \Box\y+(\Box\Height-\Box\ArrowSize)/2, \Box\ArrowSize, Bool(\Box\Checked)+2, \Color\Front[State]&$FFFFFF|Alpha, \Box\ArrowType)
      
      ; Draw frame
      If \Color\Frame[State] 
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame[State]&$FFFFFF|Alpha)
      EndIf
      
    EndWith 
  EndProcedure
  
  Procedure.i Draw_HyperLink(*This.Widget_S, scroll_x,scroll_y)
    Protected i.i, y.i
    
    With *This
      Protected Alpha = \color\alpha<<24
      
      ; Draw string
      If \Text\String
        DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
        
        If \Flag\Lines
          Line(\Text\x, \Text\y+\Text\height-2, \Text\width, 1, \Color\Front[\Color\State]&$FFFFFF|Alpha)
        EndIf
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          DrawText(\Text\x, \Text\y, \Text\String.s, \Color\Front[\Color\State]&$FFFFFF|Alpha)
          
        CompilerElse
          Protected *Sta.Character = @\Text\String.s
          Protected *End.Character = @\Text\String.s 
          #SOC = SizeOf(Character)
          
          While *End\c 
            If *End\c = #LF
              DrawText(\Text\x, \Text\y+y, PeekS(*Sta, (*End-*Sta)>>#PB_Compiler_Unicode), \Color\Front[\Color\State]&$FFFFFF|Alpha)
              *Sta = *End + #SOC 
              y+\Text\height
            EndIf 
            *End + #SOC 
          Wend
          
          ;         For i=1 To \CountItems
          ;           DrawText(\Text\x, \Text\y+y, StringField(\Text\String.s, i, #LF$), \Color\Front&$FFFFFF|Alpha)
          ;           y+\Text\height
          ;         Next
        CompilerEndIf  
      EndIf
      
      ; Draw frame
      If \Color\Frame
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox( \X[1], \Y[1], \Width[1], \Height[1], \Radius, \Radius, \Color\Frame&$FFFFFF|Alpha)
      EndIf
    EndWith 
  EndProcedure
  
  Procedure Draw_ListIcon(*This.Widget_S, scroll_x,scroll_y)
    Protected State_3.i, Alpha.i=255
    Protected y_point,x_point, level,iY, i, back_color=$FFFFFF, point_color=$7E7E7E, box_color=$7E7E7E
    Protected hide_color=$FEFFFF
    Protected checkbox_color = $FFFFFF, checkbox_backcolor, box_type.b = -1
    Protected Drawing.I, text_color, GridLines=*This\Flag\GridLines, FirstColumn.i
    
    With *This 
      Alpha = 255<<24
      Protected item_alpha = Alpha
      Protected sx, sw, y, x = \x[2]-\s\h\Page\Pos
      Protected start, stop, n
      
      ; draw background
      If \Color\Back<>-1
        DrawingMode( #PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X[2], \Y[2], \Width[2], \Height[2], \Radius, \Radius, $FFFFFF&$FFFFFF|\color\alpha<<24)
      EndIf
      
      ; ;       If \width[2]>1;(\Box\width[1]+\Box\width[2]+4)
      ForEach \Columns()
        FirstColumn = Bool(Not ListIndex(\Columns()))
        n = Bool(\flag\CheckBoxes)*16 + Bool(\Image\width)*28
        
        
        y = \y[2]-\s\v\Page\Pos
        \Columns()\y = \y+\bs-\fs
        \Columns()\Height=\TabHeight
        
        If \Columns()\Text\Change
          \Columns()\Text\width = TextWidth(\Columns()\Text\String)
          \Columns()\Text\height = TextHeight("A")
        EndIf
        
        \Columns()\x = x + n : x + \Columns()\width + 1
        
        \Columns()\image\x = \Columns()\x+\Columns()\image\x[1] - 1
        \Columns()\image\y = \Columns()\y+(\Columns()\height-\Columns()\image\height)/2
        
        \Columns()\Text\x = \Columns()\image\x + \Columns()\image\width + Bool(\Columns()\image\width) * 3
        \Columns()\Text\y = \Columns()\y+(\Columns()\height-\Columns()\Text\height)/2
        
        \Columns()\Drawing = Bool(Not \Columns()\hide And \Columns()\x+\Columns()\width>\x[2] And \Columns()\x<\x[2]+\width[2])
        
        
        ForEach \Columns()\items()
          If Not \Columns()\items()\hide 
            If \Columns()\items()\text\change = 1
              \Columns()\items()\text\height = TextHeight("A")
              \Columns()\items()\text\width = TextWidth(\Columns()\items()\text\string.s)
            EndIf
            
            \Columns()\items()\width=\Columns()\width
            \Columns()\items()\x=\Columns()\x
            \Columns()\items()\y=y ; + GridLines
            
            ;\Columns()\items()\sublevellen=2+\Columns()\items()\x+((Bool(\flag\Buttons) * \sublevellen)+\Columns()\items()\sublevel * \sublevellen)
            
            If FirstColumn
              If \flag\CheckBoxes 
                \Columns()\items()\box\width[1] = \Flag\CheckBoxes
                \Columns()\items()\box\height[1] = \Flag\CheckBoxes
                
                \Columns()\items()\box\x[1] = \x[2] + 4 - \s\h\Page\Pos
                \Columns()\items()\box\y[1] = (\Columns()\items()\y+\Columns()\items()\height)-(\Columns()\items()\height+\Columns()\items()\box\height[1])/2
              EndIf
              
              If \Columns()\items()\image\imageID 
                \Columns()\items()\image\x = \Columns()\x - \Columns()\items()\image\width - 6
                \Columns()\items()\image\y = \Columns()\items()\y+(\Columns()\items()\height-\Columns()\items()\image\height)/2
                
                \image\imageID = \Columns()\items()\image\imageID
                \image\width = \Columns()\items()\image\width+4
              EndIf
            EndIf
            
            \Columns()\items()\text\x = \Columns()\Text\x
            \Columns()\items()\text\y = \Columns()\items()\y+(\Columns()\items()\height-\Columns()\items()\text\height)/2
            \Columns()\items()\Drawing = Bool(\Columns()\items()\y+\Columns()\items()\height>\y[2] And \Columns()\items()\y<\y[2]+\height[2])
            
            y + \Columns()\items()\height + \Flag\GridLines + GridLines * 2
          EndIf
          
          If \index[2] = \Columns()\items()\index
            State_3 = 2
          Else
            State_3 = \Columns()\items()\State
          EndIf
          
          If \Columns()\items()\Drawing
            ; Draw selections
            If \flag\FullSelection And FirstColumn
              If State_3 = 1
                DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                Box(\x[2],\Columns()\items()\y+1,\s\h\Page\len,\Columns()\items()\height, \Color\Back[State_3]&$FFFFFFFF|Alpha)
                
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                Box(\x[2],\Columns()\items()\y,\s\h\Page\len,\Columns()\items()\height, \Color\Frame[State_3]&$FFFFFFFF|Alpha)
              EndIf
              
              If State_3 = 2
                If \Focus
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\x[2],\Columns()\items()\y+1,\s\h\Page\len,\Columns()\items()\height-2, $E89C3D&back_color|Alpha)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\x[2],\Columns()\items()\y,\s\h\Page\len,\Columns()\items()\height, $DC9338&back_color|Alpha)
                  
                ElseIf \flag\AlwaysSelection
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  Box(\x[2],\Columns()\items()\y+1,\s\h\Page\len,\Columns()\items()\height-2, $E2E2E2&back_color|Alpha)
                  
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                  Box(\x[2],\Columns()\items()\y,\s\h\Page\len,\Columns()\items()\height, $C8C8C8&back_color|Alpha)
                EndIf
              EndIf
            EndIf
            
            If \Columns()\Drawing 
              ;\Columns()\items()\width = \s\h\Page\len
              
              ; Draw checkbox
              If \flag\CheckBoxes And FirstColumn
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                RoundBox(\Columns()\items()\box\x[1],\Columns()\items()\box\y[1],\Columns()\items()\box\width[1],\Columns()\items()\box\height[1], 3, 3, \Color\Front[Bool(\Focus)*State_3]&$FFFFFF|Alpha)
                
                If \Columns()\items()\box\Checked[1] = #PB_Checkbox_Checked
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  For i =- 1 To 1
                    LineXY((\Columns()\items()\box\X[1]+2),(i+\Columns()\items()\box\Y[1]+7),(\Columns()\items()\box\X[1]+6),(i+\Columns()\items()\box\Y[1]+8), \Color\Front[Bool(\Focus)*State_3]&$FFFFFF|Alpha) 
                    LineXY((\Columns()\items()\box\X[1]+9+i),(\Columns()\items()\box\Y[1]+2),(\Columns()\items()\box\X[1]+5+i),(\Columns()\items()\box\Y[1]+9), \Color\Front[Bool(\Focus)*State_3]&$FFFFFF|Alpha)
                  Next
                ElseIf \Columns()\items()\box\Checked[1] = #PB_Checkbox_Inbetween
                  DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
                  RoundBox(\Columns()\items()\box\x[1]+2,\Columns()\items()\box\y[1]+2,\Columns()\items()\box\width[1]-4,\Columns()\items()\box\height[1]-4, 3-2, 3-2, \Color\Front[Bool(\Focus)*State_3]&$FFFFFF|Alpha)
                EndIf
              EndIf
              
              ; Draw image
              If \Columns()\items()\image\imageID And FirstColumn 
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawAlphaImage(\Columns()\items()\image\imageID, \Columns()\items()\image\x, \Columns()\items()\image\y, 255)
              EndIf
              
              ; Draw string
              If \Columns()\items()\text\string.s
                DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
                DrawText(\Columns()\items()\text\x, \Columns()\items()\text\y, \Columns()\items()\text\string.s, \Color\Front[Bool(\Focus) * State_3]&$FFFFFFFF|\color\alpha<<24)
              EndIf
              
              ; Draw grid line
              If \Flag\GridLines
                DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
                Line(\Columns()\items()\X-n, \Columns()\items()\Y+\Columns()\items()\Height + GridLines, \Columns()\width+n+1 + (\width[2]-(\Columns()\x-\x[2]+\Columns()\width)), 1, \Color\Frame&$FFFFFF|\color\alpha<<24)                   ; top
              EndIf
            EndIf
          EndIf
          
          \Columns()\items()\text\change = 0
          \Columns()\items()\change = 0
        Next
        
        
        If \Columns()\Drawing
          ; Draw thumb  
          If \Color\back[\Columns()\State]<>-1
            If \Color\Fore[\Columns()\State]
              DrawingMode( #PB_2DDrawing_Gradient|#PB_2DDrawing_AlphaBlend)
            EndIf
            
            If FirstColumn And n
              BoxGradient( \Vertical, \x[2], \Columns()\Y, n, \Columns()\Height, \Color\Fore[0]&$FFFFFF|\color\alpha<<24, \Color\Back[0]&$FFFFFF|\color\alpha<<24, \Radius, \color\alpha)
            ElseIf ListIndex(\Columns()) = ListSize(\Columns()) - 1
              BoxGradient( \Vertical, \Columns()\X+\Columns()\Width, \Columns()\Y, 1 + (\width[2]-(\Columns()\x-\x[2]+\Columns()\width)), \Columns()\Height, \Color\Fore[0]&$FFFFFF|\color\alpha<<24, \Color\Back[0]&$FFFFFF|\color\alpha<<24, \Radius, \color\alpha)
            EndIf
            
            BoxGradient( \Vertical, \Columns()\X, \Columns()\Y, \Columns()\Width, \Columns()\Height, \Color\Fore[\Columns()\State], Bool(\Columns()\State <> 2) * \Color\Back[\Columns()\State] + (Bool(\Columns()\State = 2) * \Color\Front[\Columns()\State]), \Radius, \color\alpha)
          EndIf
          
          ; Draw string
          If \Columns()\Text\String
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawText(\Columns()\Text\x, \Columns()\Text\y, \Columns()\Text\String.s, \Color\Front[0]&$FFFFFF|Alpha)
          EndIf
          
          ; Draw image
          If \Columns()\image\imageID
            DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_AlphaBlend)
            DrawAlphaImage(\Columns()\image\imageID, \Columns()\image\x, \Columns()\image\y, \color\alpha)
          EndIf
          
          ; Draw line 
          If FirstColumn And n
            Line(\Columns()\X-1, \Columns()\Y, 1, \Columns()\height + Bool(\Flag\GridLines) * \height[1], \Color\Frame&$FFFFFF|\color\alpha<<24)                     ; left
          EndIf
          Line(\Columns()\X+\Columns()\width, \Columns()\Y, 1, \Columns()\height + Bool(\Flag\GridLines) * \height[1], \Color\Frame&$FFFFFF|\color\alpha<<24)      ; right
          Line(\x[2], \Columns()\Y+\Columns()\Height-1, \width[2], 1, \Color\Frame&$FFFFFF|\color\alpha<<24)                                                       ; bottom
          
          If \Columns()\State = 2
            DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            RoundBox(\Columns()\X, \Columns()\Y+1, \Columns()\Width, \Columns()\Height-2, \Radius, \Radius, \Color\Frame[\Columns()\State]&$FFFFFF|\color\alpha<<24)
          EndIf
        EndIf
        
        \Columns()\Text\Change = 0
      Next
      
      \s\height = (y+\s\v\Page\Pos)-\y[2]-1;\Flag\GridLines
                                           ; set vertical scrollbar max value
      If \s\v And \s\v\Page\Len And \s\v\Max<>\s\height And 
         SetAttribute(\s\v, #PB_Bar_Maximum, \s\height) : \s\v\Step = \Text\height
        Resizes(\s, 0,0, #PB_Ignore, #PB_Ignore)
      EndIf
      
      ; set horizontal scrollbar max value
      \s\width = (x+\s\h\Page\Pos)-\x[2]-Bool(Not \s\v\Hide)*\s\v\width+n
      If \s\h And \s\h\Page\Len And \s\h\Max<>\s\width And 
         SetAttribute(\s\h, #PB_Bar_Maximum, \s\width)
        Resizes(\s, 0,0, #PB_Ignore, #PB_Ignore)
      EndIf
      
      ; 1 - frame
      If \Color\Frame<>-1
        DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
        RoundBox(\X, \Y, \Width, \Height, \Radius, \Radius, \Color\Frame&$FFFFFF|\color\alpha<<24)
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Draw(*This.Widget_S, Childrens=0)
    Protected x,y
    
    If *This > 0 And *This\Type 
      With *This
        CompilerIf #PB_Compiler_OS <>#PB_OS_MacOS 
          DrawingFont(GetGadgetFont(-1))
        CompilerEndIf
        
        ; Get text size
        If (\Text And \Text\Change)
          \Text\width = TextWidth(\Text\String.s[1])
          \Text\height = TextHeight("A")
        EndIf
        
        If \Image 
          If (\Image\Change Or \Resize Or \Change)
            ; Image default position
            If \image\imageID
              If (\Type = #PB_GadgetType_Image)
                \image\x[1] = \image\x[2] + (Bool(\s\h\Page\len>\image\width And (\image\Align\Right Or \image\Align\Horizontal)) * (\s\h\Page\len-\image\width)) / (\image\Align\Horizontal+1)
                \image\y[1] = \image\y[2] + (Bool(\s\v\Page\len>\image\height And (\image\Align\Bottom Or \image\Align\Vertical)) * (\s\v\Page\len-\image\height)) / (\image\Align\Vertical+1)
                \image\y = \s\y+\image\y[1]+\y[2]
                \image\x = \s\x+\image\x[1]+\x[2]
                
              ElseIf (\Type = #PB_GadgetType_Window)
                \image\x[1] = \image\x[2] + (Bool(\image\Align\Right Or \image\Align\Horizontal) * (\width-\image\width)) / (\image\Align\Horizontal+1)
                \image\y[1] = \image\y[2] + (Bool(\image\Align\Bottom Or \image\Align\Vertical) * (\height-\image\height)) / (\image\Align\Vertical+1)
                \image\x = \image\x[1]+\x[2]
                \image\y = \image\y[1]+\y+\bs+(\TabHeight-\image\height)/2
                \Text\x[2] = \image\x[2] + \image\width
              Else
                \image\x[1] = \image\x[2] + (Bool(\image\Align\Right Or \image\Align\Horizontal) * (\width-\image\width)) / (\image\Align\Horizontal+1)
                \image\y[1] = \image\y[2] + (Bool(\image\Align\Bottom Or \image\Align\Vertical) * (\height-\image\height)) / (\image\Align\Vertical+1)
                \image\x = \image\x[1]+\x[2]
                \image\y = \image\y[1]+\y[2]
              EndIf
            EndIf
          EndIf
          
          Protected image_width = \Image\width
        EndIf
        
        If \Text And (\Text\Change Or \Resize Or \Change)
          ; Make multi line text
          If \Text\MultiLine > 0
            \Text\String.s = Wrap(*This, \Text\String.s[1], \Width-\bs*2, \Text\MultiLine)
            \CountItems = CountString(\Text\String.s, #LF$)
          Else
            \Text\String.s = \Text\String.s[1]
          EndIf
          
          ; Text default position
          If \Text\String
            \Text\x[1] = \Text\x[2] + (Bool((\Text\Align\Right Or \Text\Align\Horizontal)) * (\width[2]-\Text\width-image_width)) / (\Text\Align\Horizontal+1)
            \Text\y[1] = \Text\y[2] + (Bool((\Text\Align\Bottom Or \Text\Align\Vertical)) * (\height[2]-\Text\height)) / (\Text\Align\Vertical+1)
            
            If \Type = #PB_GadgetType_Frame
              \Text\x = \Text\x[1]+\x[2]+8
              \Text\y = \Text\y[1]+\y
              
            ElseIf \Type = #PB_GadgetType_Window
              \Text\x = \Text\x[1]+\x[2]+5
              \Text\y = \Text\y[1]+\y+\bs+(\TabHeight-\Text\height)/2
            Else
              \Text\x = \Text\x[1]+\x[2]
              \Text\y = \Text\y[1]+\y[2]
            EndIf
          EndIf
        EndIf
        
        ; 
        If \height>0 And \width>0 And Not \hide And \color\alpha 
          ClipOutput(\clip\x,\clip\y,\clip\width,\clip\height)
          
          If \Image[1] And \Container
            \image[1]\x = \x[2] 
            \image[1]\y = \y[2]
          EndIf
          ;           
          Select \Type
            Case -1 : Draw_Window(*This, x,y)
            Case #PB_GadgetType_HyperLink : Draw_HyperLink(*This, x,y)
            Case #PB_GadgetType_Property : Draw_Property(*This, x,y)
            Case #PB_GadgetType_String : Draw_String(*This, x,y)
            Case #PB_GadgetType_ListIcon : Draw_ListIcon(*This, x,y)
            Case #PB_GadgetType_ListView : Draw_Tree(*This, x,y)
            Case #PB_GadgetType_Tree : Draw_Tree(*This, x,y)
            Case #PB_GadgetType_Text : Draw_Text(*This, x,y)
            Case #PB_GadgetType_ComboBox : Draw_ComboBox(*This, x,y)
            Case #PB_GadgetType_CheckBox : Draw_CheckBox(*This, x,y)
            Case #PB_GadgetType_Option : Draw_Option(*This, x,y)
            Case #PB_GadgetType_Panel : Draw_Panel(*This, x,y)
            Case #PB_GadgetType_Frame : Draw_Frame(*This, x,y)
            Case #PB_GadgetType_Image : Draw_Image(*This, x,y)
            Case #PB_GadgetType_Button : Draw_Button(*This, x,y)
            Case #PB_GadgetType_TrackBar : Draw_Track(*This, x,y)
            Case #PB_GadgetType_Spin : Draw_Spin(*This, x,y)
            Case #PB_GadgetType_ScrollBar : Draw_Scroll(*This, x,y)
            Case #PB_GadgetType_Splitter : Draw_Splitter(*This, x,y)
            Case #PB_GadgetType_Container : Draw_Container(*This, x,y)
            Case #PB_GadgetType_ProgressBar : Draw_Progress(*This, x,y)
            Case #PB_GadgetType_ScrollArea : Draw_ScrollArea(*This, x,y)
          EndSelect
          
          
          If \s 
            ; ClipOutput(\clip\x,\clip\y,\clip\width,\clip\height)
            If \s\v And \s\v\Type And Not \s\v\Hide : Draw_Scroll(\s\v, x,y) : EndIf
            If \s\h And \s\h\Type And Not \s\h\Hide : Draw_Scroll(\s\h, x,y) : EndIf
          EndIf
          
          ; Draw Childrens
          If Childrens And ListSize(\Childrens())
            ForEach \Childrens() 
              ; Only selected item widgets draw
              If \Childrens()\p_i = Bool(\Type = #PB_GadgetType_Panel) * \index[2]
                Draw(\Childrens(), Childrens) 
              EndIf
            Next
          EndIf
          
          ; Demo clip
          If \clip\width>0 And \clip\height>0
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\clip\x,\clip\y,\clip\width,\clip\height, $0000FF)
          EndIf
          
          ; Demo coordinate
          If \width>0 And \height>0
            DrawingMode(#PB_2DDrawing_Outlined)
            Box(\x,\y,\width,\height, $00FF00)
          EndIf
          
          UnclipOutput()
          Draw_Anchors(*This)
        EndIf
        
        ; reset 
        \Change = 0
        \Resize = 0
        If \Text
          \Text\Change = 0
        EndIf
        If \Image
          \image\change = 0
        EndIf
        
        *Value\Type =- 1 
        ;*Value\This = 0
      EndWith 
    EndIf
  EndProcedure
  
  Procedure.i ReDraw(Canvas.i)
    Protected *This.Widget_S = GetGadgetData(Canvas)
    
    If *This 
      With *This
        InitEvent(*This)
        
        If StartDrawing(CanvasOutput(\Canvas\Gadget))
          ;DrawingMode(#PB_2DDrawing_Default)
          ;Box(0,0,OutputWidth(),OutputHeight(), *This\Color\Back)
          FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
          
          Draw(*This, 1)
          
          StopDrawing()
        EndIf
      EndWith
    EndIf
  EndProcedure
  
  
  ;-
  Procedure Draw_Popup(*This.Widget_S)
    With *This
      
      If StartDrawing(CanvasOutput(\Canvas\Gadget))
        ;  Debug ""+Widgets("Widgets_0") +" "+\Childrens()
        ;       DrawingMode(#PB_2DDrawing_Default)
        ;       Box(0,0,OutputWidth(),OutputHeight(), winBackColor)
        FillMemory(DrawingBuffer(), DrawingBufferPitch() * OutputHeight(), $FF)
        
        ForEach \Childrens()
          ;           If ListSize(\Childrens()\Items())
          ;             Debug \Childrens()\Items()\Text\String
          ;           EndIf
          Draw(\Childrens())
        Next
        
        StopDrawing()
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure CallBack_Popup()
    Protected Repaint, *This.Widget_S
    
    Select Event()
      Case #PB_Event_ActivateWindow
        *This.Widget_S = GetWindowData(EventWindow())
        
        PostEvent(#PB_Event_Gadget, EventWindow(), *This\Canvas\Gadget, #PB_EventType_LeftButtonDown)
        SetActiveWindow(*This\Canvas\Widget\Canvas\Window)
        ;SetActiveGadget(*This\Canvas\Widget\Canvas\Gadget)
        SetText(*This\Canvas\Widget, GetItemText(*This\Childrens(), *This\Childrens()\index[1]))
        ;*This\Canvas\Widget\Canvas\Mouse\Buttons = 0
        *This\Canvas\Widget\Color\State = 0
        *This\Canvas\Widget\Box\Checked = 0
        HideWindow(EventWindow(), 1)
        *This = 0
        
      Case #PB_Event_Repaint
        *This.Widget_S = GetWindowData(EventWindow())
      Case #PB_Event_Gadget
        *This.Widget_S = GetGadgetData(EventGadget())
    EndSelect
    
    If *This
      With *This
        If ListSize(\Childrens())
          ForEach \Childrens()
            Repaint | CallBack(\Childrens(), EventType())
          Next
        EndIf
        
        If Repaint
          Draw_Popup(*This)
          If EventType() = #PB_EventType_LeftButtonDown
            *This\Canvas\Mouse\Buttons = 0
            *This\Childrens()\Canvas\Mouse\Buttons = 0
            
            ;PostEvent(#PB_Event_Widget, *This\Canvas\Widget\Canvas\Window, *This\Canvas\Widget\Canvas\Gadget, #PB_EventType_Change)
            ; HideWindow(EventWindow(), 1)
          EndIf
        EndIf
      EndWith
    EndIf
  EndProcedure
  
  Procedure.i Popup(*Widget.Widget_S, X.i,Y.i,Width.i,Height.i, Flag.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S) 
    
    With *This
      If *This
        \Type = #PB_GadgetType_Popup
        
        If X=#PB_Ignore 
          X = *Widget\x+GadgetX(*Widget\Canvas\Gadget, #PB_Gadget_ScreenCoordinate)
        EndIf
        If Y=#PB_Ignore 
          Y = *Widget\y+*Widget\height+GadgetY(*Widget\Canvas\Gadget, #PB_Gadget_ScreenCoordinate)
        EndIf
        If Width=#PB_Ignore
          Width = *Widget\width
        EndIf
        If Height=#PB_Ignore
          Height = *Widget\height
        EndIf
        
        If IsWindow(*Widget\Canvas\Window)
          Protected WindowID = WindowID(*Widget\Canvas\Window)
        EndIf
        
        ; Debug "show tooltip "+\string
        ;         If Not Window
        \Canvas\Widget = *Widget
        \Canvas\Window = OpenWindow(#PB_Any, X,Y,Width,Height, "", #PB_Window_BorderLess|#PB_Window_NoActivate|(Bool(#PB_Compiler_OS<>#PB_OS_Windows)*#PB_Window_Tool), WindowID) ;|#PB_Window_NoGadgets
        \Canvas\Gadget = CanvasGadget(#PB_Any,0,0,Width,Height)
        Resize(*This, 0,0, width, Height)
        
        SetWindowData(\Canvas\Window, *This)
        SetGadgetData(\Canvas\Gadget, *This)
        
        ;BindEvent(#PB_Event_SizeWindow, @CallBack_Popup(), \Canvas\Window, \Canvas\Gadget )
        BindEvent(#PB_Event_ActivateWindow, @CallBack_Popup(), \Canvas\Window);, \Canvas\Gadget )
                                                                              ;BindEvent(#PB_Event_Repaint, @CallBack_Popup(), \Canvas\Window, \Canvas\Gadget )
        BindGadgetEvent(\Canvas\Gadget, @CallBack_Popup())
        ;Draw_Popup(*This)
        ;         ;         Else
        ;         ;           ResizeWindow(Window, \x[1],\y[1],\width,\height[1])
        ;         ;           SetGadgetText(GetWindowData(Window), \string)
        ;         ;           HideWindow(Window, 0, #PB_Window_NoActivate)
        ;         ;         EndIf
        ;       ElseIf IsWindow(Window)
        ;         ;         HideWindow(Window, 1, #PB_Window_NoActivate)
        ;         CloseWindow(Window)
        ;         ;  Debug "hide tooltip "
      EndIf
    EndWith  
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Display_Popup(*This.Widget_S, *Widget.Widget_S, x.i=#PB_Ignore,y.i=#PB_Ignore)
    With *This
      If X=#PB_Ignore 
        X = \x+GadgetX(\Canvas\Gadget, #PB_Gadget_ScreenCoordinate)
      EndIf
      If Y=#PB_Ignore 
        Y = \y+\height+GadgetY(\Canvas\Gadget, #PB_Gadget_ScreenCoordinate)
      EndIf
      
      If StartDrawing(CanvasOutput(*Widget\Canvas\Gadget))
        
        ForEach *Widget\Childrens()\Items()
          If *Widget\Childrens()\items()\text\change = 1
            *Widget\Childrens()\items()\text\height = TextHeight("A")
            *Widget\Childrens()\items()\text\width = TextWidth(*Widget\Childrens()\items()\text\string.s)
          EndIf
          
          If *Widget\Childrens()\s\Width < (10+*Widget\Childrens()\items()\text\width)+*Widget\Childrens()\s\h\Page\Pos
            *Widget\Childrens()\s\Width = (10+*Widget\Childrens()\items()\text\width)+*Widget\Childrens()\s\h\Page\Pos
          EndIf
        Next
        
        StopDrawing()
      EndIf
      
      Protected *Tree.Widget_S = *Widget\Childrens()
      *Tree\Focus=1
      Protected Width = *Tree\s\width + *Tree\bs*2 
      Protected Height = *Tree\s\height + *Tree\bs*2 ; CountItems * *Tree\Text\height + *Tree\bs*2
      
      If Width < \width
        Width = \width
      EndIf
      
      Resize(*Widget, 0,0, width, Height )
      ResizeWindow(*Widget\Canvas\Window, x, y, width, Height)
      ResizeGadget(*Widget\Canvas\Gadget, #PB_Ignore, #PB_Ignore, width, Height)
      ;Resize(*Widget, 0,0, width, Height )
    EndWith
    
    Draw_Popup(*Widget)
  EndProcedure
  
  ;-
  ;- ADD & GET & SET
  ;-
  Procedure.i at(*This.Widget_S, MouseX.i, MouseY.i)
    Protected *Result.Widget_S, X.i,Y.i,Width.i,Height.i
    
    If Not *This
      *This = GetGadgetData(EventGadget())
    EndIf
    
    With *This
      If *This And \CountItems ; ListSize(\Childrens()) ; Not *Value\Canvas\Mouse\Buttons
        PushListPosition(\Childrens()) ;
        LastElement(\Childrens())      ; Что бы начать с последнего элемента
        Repeat                         ; Перебираем с низу верх
          X = \Childrens()\clip\X
          Y = \Childrens()\clip\Y
          Width = X+\Childrens()\clip\Width
          Height = Y+\Childrens()\clip\Height
          
          If Not \Childrens()\Hide And \Childrens()\p_i = Bool(\Type = #PB_GadgetType_Panel) * \index[2] And ;\Childrens()\p_i = *This\index[2] And 
             (MouseX >=  X And MouseX < Width And MouseY >=  Y And MouseY < Height)
            If ListSize(\Childrens()\Childrens()) 
              *Result = at(\Childrens(), MouseX, MouseY)
              If Not *Result
                *Result = \Childrens()
              EndIf
            Else
              *Result = \Childrens()
            EndIf
            
            Break
          EndIf
          
        Until PreviousElement(\Childrens()) = #False 
        PopListPosition(\Childrens())
      EndIf
    EndWith
    
    ; scrollbars events
    If *Result And *Result\s
      If *Result\s\v And Not *Result\s\v\Hide And *Result\s\v\Type And (MouseX>*Result\s\v\x And MouseX=<*Result\s\v\x+*Result\s\v\Width And  MouseY>*Result\s\v\y And MouseY=<*Result\s\v\y+*Result\s\v\Height)
        *Result = *Result\s\v
      ElseIf *Result\s\h And Not *Result\s\h\Hide And *Result\s\h\Type And (MouseX>*Result\s\h\x And MouseX=<*Result\s\h\x+*Result\s\h\Width And  MouseY>*Result\s\h\y And MouseY=<*Result\s\h\y+*Result\s\h\Height)
        *Result = *Result\s\h
      EndIf
    EndIf
        
    If *Result
      With *Result 
        \Canvas\Mouse\X = MouseX
        \Canvas\Mouse\Y = MouseY
        *Value\Canvas\Mouse\X = MouseX
        *Value\Canvas\Mouse\Y = MouseY
        
        If \Box And (MouseX>\Box\x[1] And MouseX=<\Box\x[1]+\Box\Width[1] And  MouseY>\Box\y[1] And MouseY=<\Box\y[1]+\Box\Height[1])
          \at = 1
        ElseIf \Box And (MouseX>\Box\x[3] And MouseX=<\Box\x[3]+\Box\Width[3] And MouseY>\Box\y[3] And MouseY=<\Box\y[3]+\Box\Height[3])
          \at = 3
        ElseIf \Box And (MouseX>\Box\x[2] And MouseX=<\Box\x[2]+\Box\Width[2] And MouseY>\Box\y[2] And MouseY=<\Box\y[2]+\Box\Height[2])
          \at = 2
        Else
          \at =- 1
        EndIf 
      EndWith
    EndIf
    
    ProcedureReturn *Result
  EndProcedure
  
  Procedure.i X(*This.Widget_S)
    Protected Result.i
    
    If *This
      With *This
        If Not \Hide[1] And \Color\Alpha
          Result = \X
        Else
          Result = \X+\Width
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Y(*This.Widget_S)
    Protected Result.i
    
    If *This
      With *This
        If Not \Hide[1] And \Color\Alpha
          Result = \Y
        Else
          Result = \Y+\Height
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Width(*This.Widget_S)
    Protected Result.i
    
    If *This
      With *This
        If Not \Hide[1] And \Width And \Color\Alpha
          Result = \Width
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Height(*This.Widget_S)
    Protected Result.i
    
    If *This
      With *This
        If Not \Hide[1] And \Height And \Color\Alpha
          Result = \Height
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i CountItems(*This.Widget_S)
    ProcedureReturn *This\CountItems
  EndProcedure
  
  Procedure.i Hides(*This.Widget_S, State.i)
    With *This
      If State
        \Hide = 1
      Else
        \Hide = \Hide[1]
        If \s And \s\v And \s\h
          \s\v\Hide = \s\v\Hide[1]
          \s\h\Hide = \s\h\Hide[1]
        EndIf
      EndIf
      
      If ListSize(\Childrens())
        ForEach \Childrens()
          Hides(\Childrens(), State)
        Next
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Hide(*This.Widget_S, State.i=-1)
    With *This
      If State.i=-1
        ProcedureReturn \Hide 
      Else
        \Hide = State
        \Hide[1] = \Hide
        
        If ListSize(\Childrens())
          ForEach \Childrens()
            Hides(\Childrens(), State)
          Next
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i ClearItems(*This.Widget_S) 
    With *This
      \CountItems = 0
      \Text\Change = 1 
      If \Text\Editable
        \Text\String = #LF$
      EndIf
      
      ClearList(\Items())
      \s\v\Hide = 1
      \s\h\Hide = 1
      
      ;       If Not \Repaint : \Repaint = 1
      ;        PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
      ;       EndIf
    EndWith
  EndProcedure
  
  Procedure.i RemoveItem(*This.Widget_S, Item.i) 
    With *This
      \CountItems = ListSize(\Items()) ; - 1
      \Text\Change = 1
      
      If \CountItems =- 1 
        \CountItems = 0 
        \Text\String = #LF$
        ;         If Not \Repaint : \Repaint = 1
        ;           PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
        ;         EndIf
      Else
        Debug Item
        If SelectElement(\Items(), Item)
          DeleteElement(\Items())
        EndIf
        
        \Text\String = RemoveString(\Text\String, StringField(\Text\String, Item+1, #LF$) + #LF$)
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Enumerate(*This.Integer, *Parent.Widget_S, Item.i=0)
    Protected Result.i
    
    With *Parent
      If Not *This
        ProcedureReturn 0
      EndIf
      
      If Not \Enumerate
        Result = FirstElement(\Childrens())
      Else
        Result = NextElement(\Childrens())
      EndIf
      
      \Enumerate = Result
      
      If Result
        If \Childrens()\p_i <> Item
          ProcedureReturn Enumerate(*This, *Parent, Item)
        EndIf
        
        PokeI(*This, PeekI(@\Childrens()))
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Free(*This.Widget_S)
    Protected Result.i
    
    With *This
      If *This
        If \s
          If \s\v
            FreeStructure(\s\v) : \s\v = 0
          EndIf
          If \s\h
            FreeStructure(\s\h)  : \s\h = 0
          EndIf
          FreeStructure(\s) : \s = 0
        EndIf
        
        If \Box
          FreeStructure(\Box) : \Box = 0
        EndIf
        
        If \Image
          FreeStructure(\Image) : \Image = 0
        EndIf
        
        If \Image[1]
          FreeStructure(\Image[1]) : \Image[1] = 0
        EndIf
        
        If \Text
          FreeStructure(\Text) : \Text = 0
        EndIf
        
        FreeStructure(*This) 
        *Value\Active = 0
        *Value\Focus = 0
        
        If \Parent And ListSize(\Parent\Childrens()) : \Parent\CountItems - 1
          ChangeCurrentElement(\Parent\Childrens(), Adress(*This))
          Result = DeleteElement(\Parent\Childrens())
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  
  ;- ADD
  Procedure.i AddItem(*This.Widget_S, Item.i, Text.s, Image.i=-1, Flag.i=0)
    With *This
      
      Select \Type
        Case #PB_GadgetType_Panel
          LastElement(\items())
          AddElement(\items())
          
          ; last opened item of the parent
          \o_i = ListIndex(\Items())
          
          \items() = AllocateStructure(Items_S)
          \items()\index = ListIndex(\items())
          \items()\Text\String = Text.s
          \items()\Text\Change = 1
          \items()\height = \TabHeight
          \CountItems + 1 
          
          Set_Image(\items(), Image)
          
        Case #PB_GadgetType_Property
          ProcedureReturn Property_AddItem(*This, Item.i,Text.s,Image, Flag)
          
        Case #PB_GadgetType_Tree, #PB_GadgetType_ListView
          ProcedureReturn Tree_AddItem(*This, Item.i,Text.s,Image, Flag)
          
        Case #PB_GadgetType_ListIcon
          ProcedureReturn ListIcon_AddItem(*This, Item.i,Text.s,Image, Flag)
          
        Case #PB_GadgetType_ComboBox
          Protected *Tree.Widget_S = \Popup\Childrens()
          
          LastElement(*Tree\items())
          AddElement(*Tree\items())
          
          *Tree\items() = AllocateStructure(Items_S)
          *Tree\items()\Box = AllocateStructure(Box_S)
          
          *Tree\items()\index = ListIndex(*Tree\items())
          *Tree\items()\Text\String = Text.s
          *Tree\items()\Text\Change = 1
          *Tree\items()\height = \Text\height
          *Tree\CountItems + 1 
          
          *Tree\items()\y = *Tree\s\height
          *Tree\s\height + *Tree\items()\height
          
          Set_Image(*Tree\items(), Image)
      EndSelect
      
    EndWith
  EndProcedure
  
  Procedure.i AddColumn(*This.Widget_S, Position.i, Title.s, Width.i)
    With *This
      LastElement(\Columns())
      AddElement(\Columns()) 
      \Columns() = AllocateStructure(Widget_S)
      
      If Position =- 1
        Position = ListIndex(\Columns())
      EndIf
      
      \Columns()\index[1] =- 1
      \Columns()\index[2] =- 1
      \Columns()\index = Position
      \Columns()\width = Width
      \Columns()\image\x[1] = 5
      \Columns()\text\change = 1
      \Columns()\x = \x[2]+\s\width
      \Columns()\height = \TabHeight
      \Columns()\text\string.s = Title.s
      \s\height = \bs*2+\Columns()\height
      \s\width + Width + 1
    EndWith
  EndProcedure
  
  
  ;- GET
  Procedure.i GetFocus()
    ProcedureReturn *Value\Focus
  EndProcedure
  
  Procedure.i GetActive()
    ProcedureReturn *Value\Active
  EndProcedure
  
  Procedure.i GetParent(*This.Widget_S)
    ProcedureReturn *This\Parent
  EndProcedure
  
  Procedure.i GetWindow(*This.Widget_S)
    ProcedureReturn *This\Window
  EndProcedure
  
  Procedure.i GetParentItem(*This.Widget_S)
    ProcedureReturn *This\p_i
  EndProcedure
  
  Procedure.i GetPosition(*This.Widget_S, Position.i)
    Protected Result.i
    
    With *This
      If *This And \Parent
        ; 
        If (\Type = #PB_GadgetType_ScrollBar And 
            \Parent\Type = #PB_GadgetType_ScrollArea) Or
           \Parent\Type = #PB_GadgetType_Splitter
          *This = \Parent
        EndIf
        
        Select Position
          Case #PB_List_First  : Result = FirstElement(\Parent\Childrens())
          Case #PB_List_Before : ChangeCurrentElement(\Parent\Childrens(), Adress(*This)) : Result = PreviousElement(\Parent\Childrens())
          Case #PB_List_After  : ChangeCurrentElement(\Parent\Childrens(), Adress(*This)) : Result = NextElement(\Parent\Childrens())
          Case #PB_List_Last   : Result = LastElement(\Parent\Childrens())
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetState(*This.Widget_S)
    Protected Result.i
    
    With *This
      Select \Type
        Case #PB_GadgetType_Option,
             #PB_GadgetType_CheckBox 
          Result = \Box\Checked
          
        Case #PB_GadgetType_Tree : Result = \index[2]
        Case #PB_GadgetType_ListView : Result = \index[2]
        Case #PB_GadgetType_Panel : Result = \index[2]
        Case #PB_GadgetType_Image : Result = \image\index
          
        Case #PB_GadgetType_ScrollBar, 
             #PB_GadgetType_TrackBar, 
             #PB_GadgetType_ProgressBar,
             #PB_GadgetType_Splitter 
          Result = Invert(*This, \Page\Pos, \inverted)
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetAttribute(*This.Widget_S, Attribute.i)
    Protected Result.i
    
    With *This
      Select \Type
        Case #PB_GadgetType_Button
          Select Attribute 
            Case #PB_Button_Image ; 1
              Result = \image\index
          EndSelect
          
        Case #PB_GadgetType_Splitter
          Select Attribute
            Case #PB_Splitter_FirstMinimumSize : Result = \Box\Size[1]
            Case #PB_Splitter_SecondMinimumSize : Result = \Box\Size[2] - \Box\Size[3]
          EndSelect 
          
        Default 
          Select Attribute
            Case #PB_Bar_Minimum : Result = \Min  ; 1
            Case #PB_Bar_Maximum : Result = \Max  ; 2
            Case #PB_Bar_Inverted : Result = \inverted
            Case #PB_Bar_NoButtons : Result = \Box\Size ; 4
            Case #PB_Bar_Direction : Result = \Direction
            Case #PB_Bar_PageLength : Result = \Page\len ; 3
          EndSelect
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetItemAttribute(*This.Widget_S, Item.i, Attribute.i)
    Protected Result.i
    
    With *This
      Select \Type
        Case #PB_GadgetType_Tree
          ForEach \items()
            If \items()\index= Item 
              Select Attribute
                Case #PB_Tree_SubLevel
                  Result = \items()\sublevel
                  
              EndSelect
              Break
            EndIf
          Next
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetItemImage(*This.Widget_S, Item.i)
  EndProcedure
  
  Procedure.i GetItemState(*This.Widget_S, Item.i)
    Protected Result.i
    
    With *This
      Select \Type
        Case #PB_GadgetType_Tree,
             #PB_GadgetType_ListView
          
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetItemData(*This.Widget_S, Item.i)
    Protected Result.i
    
    With *This
      PushListPosition(\items()) 
      ForEach \items()
        If \items()\index = Item 
          Result = \items()\data
          ; Debug \items()\Text\String
          Break
        EndIf
      Next
      PopListPosition(\items())
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.s GetItemText(*This.Widget_S, Item.i)
    Protected Result.s
    
    With *This
      ForEach \items()
        If \items()\index = Item 
          Result = \items()\Text\String.s
          Break
        EndIf
      Next
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i GetData(*This.Widget_S)
    ProcedureReturn *This\data
  EndProcedure
  
  Procedure.i GetImage(*This.Widget_S)
    ProcedureReturn *This\image\index
  EndProcedure
  
  Procedure.s GetText(*This.Widget_S)
    If *This\Text
      ProcedureReturn *This\Text\String.s
    EndIf
  EndProcedure
  
  Procedure.i GetType(*This.Widget_S)
    ProcedureReturn *This\Type
  EndProcedure
  
  
  ;- SET
  Procedure.i CloseList()
    If LastElement(*openedlist())
      If *openedlist()\Type = #PB_GadgetType_Popup
        Draw_Popup(*openedlist())
      EndIf
      
      DeleteElement(*openedlist())
    EndIf
  EndProcedure
  
  Procedure.i OpenList(*This.Widget_S, Item.i=0)
    With *This
      If IsWindow(*This)
        If Not Bool(IsGadget(Item) And GadgetType(Item) = #PB_GadgetType_Canvas)
          Item = CanvasGadget(#PB_Any, 0,0, WindowWidth(*This, #PB_Window_InnerCoordinate), WindowHeight(*This, #PB_Window_InnerCoordinate), #PB_Canvas_Keyboard)
        EndIf
        
        *value\Canvas\window = *This
        *value\Canvas\gadget = Item
        
        *This = AllocateStructure(Widget_S)
        \x =- 1
        \y =- 1
        \Container =- 5
        \Type =-5
        \color\alpha = 255
        \Canvas\window = *value\Canvas\window 
        \Canvas\gadget = *value\Canvas\gadget
        
        Resize(*This, 0, 0, GadgetWidth(Item), GadgetHeight(Item))
        SetGadgetData(Item, *This)
        
        LastElement(*openedlist())
        If AddElement(*openedlist())
          *openedlist() = *This 
        EndIf
        
        *Root = *openedlist()
        *Root\adress = @*openedlist()
        
        ProcedureReturn *This
        
      ElseIf *This > 0
        
        If \Type = #PB_GadgetType_Window
          \Window = *This
        EndIf
        
        LastElement(*openedlist())
        If AddElement(*openedlist())
          *openedlist() = *This 
          *openedlist()\o_i = Item
        EndIf
      EndIf
      
      
    EndWith
    
    ProcedureReturn *This\Container
  EndProcedure
  
  Procedure.i SetParent(*This.Widget_S, *Parent.Widget_S, Item.i=-1)
    Protected x,y
    
    With *This
      If *This > 0
        If Item.i=-1
          Item = *Parent\index[2]
        EndIf
        
        If \Parent <> *Parent Or \p_i <> Item
          x = \x[3]
          y = \y[3]
          
          If \Parent And ListSize(\Parent\Childrens())
            ChangeCurrentElement(\Parent\Childrens(), Adress(*This)) : DeleteElement(\Parent\Childrens())
            PostEvent(#PB_Event_Gadget, \Parent\Canvas\Window, \Parent\Canvas\Gadget, #PB_EventType_Repaint)
            If \Parent<>*Parent
              PostEvent(#PB_Event_Gadget, *Parent\Canvas\Window, *Parent\Canvas\Gadget, #PB_EventType_Repaint)
            EndIf
          EndIf
          
          \p_i = Item
          \Parent = *Parent
          \Window = *Parent\Window
          \Canvas = \Parent\Canvas
          \Hide = Bool(\p_i > 0 Or \Parent\Hide)
          
          If \Parent\s
            x-\Parent\s\h\Page\Pos
            y-\Parent\s\v\Page\Pos
          EndIf
          
          AddChildren(\Parent, *This)
          Resize(*This, x, y, #PB_Ignore, #PB_Ignore)
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetPosition(*This.Widget_S, Position.i, *Widget_2 =- 1) ; Ok SetStacking()
    
    With *This
      If *This And \Parent
        ;
        If (\Type = #PB_GadgetType_ScrollBar And 
            \Parent\Type = #PB_GadgetType_ScrollArea) Or
           \Parent\Type = #PB_GadgetType_Splitter
          *This = \Parent
        EndIf
        
        ChangeCurrentElement(\Parent\Childrens(), Adress(*This))
        
        If *Widget_2 =- 1
          Select Position
            Case #PB_List_First  : MoveElement(\Parent\Childrens(), #PB_List_First)
            Case #PB_List_Before : PreviousElement(\Parent\Childrens()) : MoveElement(\Parent\Childrens(), #PB_List_After, Adress(\Parent\Childrens()))
            Case #PB_List_After  : NextElement(\Parent\Childrens())     : MoveElement(\Parent\Childrens(), #PB_List_Before, Adress(\Parent\Childrens()))
            Case #PB_List_Last   : MoveElement(\Parent\Childrens(), #PB_List_Last)
          EndSelect
          
        ElseIf *Widget_2
          Select Position
            Case #PB_List_Before : MoveElement(\Parent\Childrens(), #PB_List_Before, *Widget_2)
            Case #PB_List_After  : MoveElement(\Parent\Childrens(), #PB_List_After, *Widget_2)
          EndSelect
        EndIf
        
       ; \Parent\Childrens()\Adress = @\Parent\Childrens()
        
      EndIf 
    EndWith
    
  EndProcedure
  
  Procedure.i SetFocus(*This.Widget_S)
    ; Возвращаемые значения
    ; Если функция завершается успешно, возвращаемое значения - дескриптор до этого активного окна.
    
    Protected repaint, Window.i, MouseScreenX, MouseScreenY
    
    With *This
      MouseScreenX = \Canvas\Mouse\X
      MouseScreenY = \Canvas\Mouse\y
      
      If *Value\Active <> \Window
        ; Set foreground window
        SetPosition(\Window, #PB_List_Last)
        
        If *Value\Active
          *Value\Active\repaint | Events(*Value\Active, *Value\Active\at, #PB_EventType_LostFocus, MouseScreenX, MouseScreenY)
        EndIf
        
        \Window\repaint | Events(\Window, \at, #PB_EventType_Focus, MouseScreenX, MouseScreenY)
        *Value\Active = \Window
      EndIf
      
      If *Value\Focus <> *This And \Type <> #PB_GadgetType_Window 
        If *Value\Focus
          *Value\Focus\repaint | Events(*Value\Focus, *Value\Focus\at, #PB_EventType_LostFocus, MouseScreenX, MouseScreenY)
        EndIf
        
        \repaint | Events(*This, \at, #PB_EventType_Focus, MouseScreenX, MouseScreenY)
        *Value\Focus = *This
      EndIf
      
    EndWith
    
    ProcedureReturn repaint
  EndProcedure
  
  Procedure.i SetActive(*This.Widget_S)
    ; Возвращаемые значения
    ; Если функция завершается успешно, возвращаемое значения - дескриптор до этого активного окна.
    Protected Result.i
    
    With *This
      If \Window And *Value\Active <> \Window
        If *Value\Active 
          \Window\Deactive = *Value\Active 
          *Value\Active\Focus = 0
          *Value\Active\anchor = 0 
        EndIf
        If Not \Window\Deactive 
          \Window\Deactive = \Window 
        EndIf
        \Window\anchor = \Window\anchor[9]
        
        If *Value\Focus ; Если деактивировали окно то убираем также якорь с гаджета
          If *Value\Focus\Window = \Window\Deactive
            *Value\Focus\Focus = 0
            *Value\Focus\anchor = 0 
          ElseIf *Value\Focus\Window = \Window
            *Value\Focus\Focus = 1
            *Value\Focus\anchor = *Value\Focus\anchor[9] 
          EndIf
        EndIf
        
        Result = \Window\Deactive
        *Value\Active = \Window
        \Window\Focus = 1
      EndIf
      
      If *This And *Value\Focus <> *This And \Type <> #PB_GadgetType_Window ; And \Type <> #PB_GadgetType_Button 
        If *Value\Focus
          \Deactive = *Value\Focus 
          *Value\Focus\anchor = 0 
          *Value\Focus\Focus = 1
        EndIf
        If Not \Deactive 
          \Deactive = *This 
        EndIf
        \anchor = \anchor[9]
        *Value\Focus = *This
        \Focus = 1
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetForeground(*This.Widget_S)
    Protected repaint
    
    With *This
      ; SetActiveGadget(\Canvas\Gadget)
      SetPosition(\Window, #PB_List_Last)
      SetActive(*This)
    EndWith
    
    ProcedureReturn repaint
  EndProcedure
  
  Procedure.i SetFlag(*This.Widget_S, Flag.i)
    
    With *This
      If Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget
        SetAnchors(*This, 1)
        Resize_Anchors(*This)
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure.i SetText(*This.Widget_S, Text.s)
    Protected Result.i, Len.i, String.s, i.i
    If Text.s="" : Text.s=#LF$ : EndIf
    
    With *This
      If \Text\String.s[1] <> Text.s
        \Text\String.s[1] = Make(*This, Text.s)
        
        If \Text\String.s[1]
          If \Text\MultiLine
            Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
            Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
            Text.s = ReplaceString(Text.s, #CR$, #LF$)
            
            If \Text\MultiLine > 0
              Text.s + #LF$
            EndIf
            
            \Text\String.s[1] = Text.s
            \CountItems = CountString(\Text\String.s[1], #LF$)
          Else
            \Text\String.s[1] = RemoveString(\Text\String.s[1], #LF$) ; + #LF$
                                                                      ; \Text\String.s = RTrim(ReplaceString(\Text\String.s[1], #LF$, " ")) + #LF$
          EndIf
          
          \Text\String.s = \Text\String.s[1]
          \Text\Len = Len(\Text\String.s[1])
          \Text\Change = #True
          Result = #True
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetState(*This.Widget_S, State.i)
    Protected Result.b, Direction.i ; Направление и позиция скролла (вверх,вниз,влево,вправо)
    
    With *This
      If *This > 0
        Select \Type
          Case #PB_GadgetType_CheckBox
            Select State
              Case #PB_Checkbox_Unchecked,
                   #PB_Checkbox_Checked
                \Box\Checked = State
                ProcedureReturn 1
                
              Case #PB_Checkbox_Inbetween
                If \Box\ThreeState 
                  \Box\Checked = State
                  ProcedureReturn 1
                EndIf
            EndSelect
            
          Case #PB_GadgetType_Option
            If \OptionGroup And \Box\Checked <> State
              If \OptionGroup\OptionGroup <> *This
                If \OptionGroup\OptionGroup
                  \OptionGroup\OptionGroup\Box\Checked = 0
                EndIf
                \OptionGroup\OptionGroup = *This
              EndIf
              \Box\Checked = State
              ProcedureReturn 1
            EndIf
            
          Case #PB_GadgetType_ComboBox
            Protected *t.Widget_S = \Popup\Childrens()
            
            If State < 0 : State = 0 : EndIf
            If State > *t\CountItems - 1 : State = *t\CountItems - 1 :  EndIf
            
            If *t\index[2] <> State
              If *t\index[2] >= 0 And SelectElement(*t\items(), *t\index[2]) 
                *t\items()\State = 0
              EndIf
              
              If SelectElement(*t\items(), State)
                *Value\Type = #PB_EventType_Change
                *Value\This = *This
                
                *t\items()\State = 2
                *t\Change = State+1
                
                \Text\String[1] = *t\Items()\Text\String
                ;                 \Text[1]\String = \Text\String[1]
                ;                 \Text\Caret = 1
                ;                 \Text\Caret[1] = \Text\Caret
                \Text\Change = 1
                
                ;Debug #PB_GadgetType_ComboBox;\Type
                PostEvent(#PB_Event_Widget, *Value\Canvas\Window, *This, #PB_EventType_Change)
                PostEvent(#PB_Event_Gadget, *Value\Canvas\Window, *Value\Canvas\Gadget, #PB_EventType_Repaint)
              EndIf
              
              *t\index[2] = State
              ProcedureReturn 1
            EndIf
            
          Case #PB_GadgetType_Tree, #PB_GadgetType_ListView
            If State < 0 : State = 0 : EndIf
            If State > \CountItems - 1 : State = \CountItems - 1 :  EndIf
            
            If \index[2] <> State
              If \index[2] >= 0 And SelectElement(\items(), \index[2]) 
                \items()\State = 0
              EndIf
              
              If SelectElement(\items(), State)
                *Value\Type = #PB_EventType_Change
                *Value\This = *This
                
                \items()\State = 2
                \Change = State+1
                
                PostEvent(#PB_Event_Widget, *Value\Canvas\Window, *This, #PB_EventType_Change)
                PostEvent(#PB_Event_Gadget, *Value\Canvas\Window, *Value\Canvas\Gadget, #PB_EventType_Repaint)
              EndIf
              
              \index[2] = State
              ProcedureReturn 1
            EndIf
            
          Case #PB_GadgetType_Image
            Result = Set_Image(*This, State)
            
            If Result
              If \s
                SetAttribute(\s\v, #PB_Bar_Maximum, \image\height)
                SetAttribute(\s\h, #PB_Bar_Maximum, \image\width)
                
                \Resize = 1<<1|1<<2|1<<3|1<<4 
                Resize(*This, \x, \y, \width, \height) 
                \Resize = 0
              EndIf
            EndIf
            
          Case #PB_GadgetType_Panel
            If State < 0 : State = 0 : EndIf
            If State > \CountItems - 1 : State = \CountItems - 1 :  EndIf
            
            If \index[2] <> State : \index[2] = State
              
              ForEach \Childrens()
                Hides(\Childrens(), Bool(\Childrens()\p_i<>State))
              Next
              
              \Change = State+1
              Result = 1
            EndIf
            
          Default
            If (\Vertical And \Type = #PB_GadgetType_TrackBar)
              State = Invert(*This, State, \inverted)
            EndIf
            
            If State < \Min
              State = \Min 
            EndIf
            
            If State > \Max-\Page\len
              If \Max > \Page\len 
                State = \Max-\Page\len
              Else
                State = \Min 
              EndIf
            EndIf
            
            If \Page\Pos <> State 
              \Thumb\Pos = ThumbPos(*This, State)
              
              If \inverted
                If \Page\Pos > State
                  \Direction = Invert(*This, State, \inverted)
                Else
                  \Direction =- Invert(*This, State, \inverted)
                EndIf
              Else
                If \Page\Pos > State
                  \Direction =- State
                Else
                  \Direction = State
                EndIf
              EndIf
              
              *Value\Type = #PB_EventType_Change
              *Value\This = *This
              
              \Change = \Page\Pos - State
              \Page\Pos = State
              
              If \Type = #PB_GadgetType_Spin
                \Text\String.s[1] = Str(\Page\Pos) : \Text\Change = 1
                
              ElseIf \Type = #PB_GadgetType_Splitter
                Resize_Splitter(*This)
                
              ElseIf \Parent
                \Parent\Change =- 1
                
                If \Parent\s
                  If \Vertical
                    \Parent\s\y =- \Page\Pos
                    Resize_Childrens(\Parent, 0, \Change)
                  Else
                    \Parent\s\x =- \Page\Pos
                    Resize_Childrens(\Parent, \Change, 0)
                  EndIf
                EndIf
              EndIf
              
              Result = #True
            EndIf
        EndSelect
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetAttribute(*This.Widget_S, Attribute.i, Value.i)
    Protected Resize.i
    
    With *This
      If *This > 0
        Select \Type
          Case #PB_GadgetType_Button
            Select Attribute 
              Case #PB_Button_Image
                Set_Image(*This, Value)
                ProcedureReturn 1
            EndSelect
            
          Case #PB_GadgetType_Splitter
            Select Attribute
              Case #PB_Splitter_FirstMinimumSize : \Box\Size[1] = Value
              Case #PB_Splitter_SecondMinimumSize : \Box\Size[2] = \Box\Size[3] + Value
            EndSelect 
            
            If \Vertical
              \Area\Pos = \Y+\Box\Size[1]
              \Area\len = (\Height-\Box\Size[1]-\Box\Size[2])
            Else
              \Area\Pos = \X+\Box\Size[1]
              \Area\len = (\Width-\Box\Size[1]-\Box\Size[2])
            EndIf
            
            ProcedureReturn 1
            
          Case #PB_GadgetType_Image
            Select Attribute
              Case #PB_DisplayMode
                
                Select Value
                  Case 0 ; Default
                    \image\Align\Vertical = 0
                    \image\Align\Horizontal = 0
                    
                  Case 1 ; Center
                    \image\Align\Vertical = 1
                    \image\Align\Horizontal = 1
                    
                  Case 3 ; Mosaic
                  Case 2 ; Stretch
                    
                  Case 5 ; Proportionally
                EndSelect
                
                ;Resize = 1
                \Resize = 1<<1|1<<2|1<<3|1<<4
                Resize(*This, \x, \y, \width, \height)
                \Resize = 0
            EndSelect
            
          Default
            
            Select Attribute
              Case #PB_Bar_NoButtons : Resize = 1
                \Box\Size[0] = Value
                \Box\Size[1] = Value
                \Box\Size[2] = Value
                
              Case #PB_Bar_Inverted
                \inverted = Bool(Value)
                \Page\Pos = Invert(*This, \Page\Pos)
                \Thumb\Pos = ThumbPos(*This, \Page\Pos)
                ProcedureReturn 1
                
              Case #PB_Bar_Minimum ; 1 -m&l
                If \Min <> Value 
                  \Min = Value
                  \Page\Pos + Value
                  
                  If \Page\Pos > \Max-\Page\len
                    If \Max > \Page\len 
                      \Page\Pos = \Max-\Page\len
                    Else
                      \Page\Pos = \Min 
                    EndIf
                  EndIf
                  
                  If \Max > \Min
                    \Thumb\Pos = ThumbPos(*This, \Page\Pos)
                    \Thumb\len = ThumbLength(*This)
                  Else
                    \Thumb\Pos = \Area\Pos
                    \Thumb\len = \Area\len
                    
                    If \Vertical 
                      \Box\y[3] = \Thumb\Pos  
                      \Box\Height[3] = \Thumb\len
                    Else 
                      \Box\x[3] = \Thumb\Pos 
                      \Box\Width[3] = \Thumb\len
                    EndIf
                  EndIf
                  
                  Resize = 1
                EndIf
                
              Case #PB_Bar_Maximum ; 2 -m&l
                If \Max <> Value
                  \Max = Value
                  
                  If \Page\len > \Max 
                    \Page\Pos = \Min
                  EndIf
                  
                  \Thumb\Pos = ThumbPos(*This, \Page\Pos)
                  
                  If \Max > \Min
                    \Thumb\len = ThumbLength(*This)
                  Else
                    \Thumb\len = \Area\len
                    
                    If \Vertical 
                      \Box\Height[3] = \Thumb\len
                    Else 
                      \Box\Width[3] = \Thumb\len
                    EndIf
                  EndIf
                  
                  If \Step = 0
                    \Step = 1
                  EndIf
                  
                  Resize = 1
                EndIf
                
              Case #PB_Bar_PageLength ; 3 -m&l
                If \Page\len <> Value
                  If Value > (\Max-\Min)
                    If \Max = 0 
                      \Max = Value 
                    EndIf
                    Value = (\Max-\Min)
                    \Page\Pos = \Min
                  EndIf
                  \Page\len = Value
                  
                  \Thumb\Pos = ThumbPos(*This, \Page\Pos)
                  
                  If \Page\len > \Min
                    \Thumb\len = ThumbLength(*This)
                  Else
                    \Thumb\len = \Box\Size[3]
                  EndIf
                  
                  If \Step = 0
                    \Step = 1
                  EndIf
                  If \Step < 2 And \Page\len
                    \Step = (\Max-\Min) / \Page\len 
                  EndIf
                  
                  Resize = 1
                EndIf
                
            EndSelect
            
        EndSelect
        
        If Resize
          \Resize = 1<<1|1<<2|1<<3|1<<4
          \Hide = Resize(*This, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          \Resize = 0
          ProcedureReturn 1
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i SetItemAttribute(*This.Widget_S, Item.i, Attribute.i, Value.i)
    Protected Result.i
    
    With *This
      Select \Type
        Case #PB_GadgetType_Panel
          If SelectElement(\items(), Item)
            Select Attribute 
              Case #PB_Button_Image
                Result = Set_Image(\items(), Value)
            EndSelect
          EndIf
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemImage(*This.Widget_S, Item.i, Image.i)
    Protected Result.i
    
    With *This
      Select Item
        Case 0
          \image[Item]\change = 1
          
          If IsImage(Image)
            \image[Item]\index = Image
            \image[Item]\imageID = ImageID(Image)
            \image[Item]\width = ImageWidth(Image)
            \image[Item]\height = ImageHeight(Image)
          Else
            \image[Item]\index =- 1
            \image[Item]\imageID = 0
            \image[Item]\width = 0
            \image[Item]\height = 0
          EndIf
      EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemState(*This.Widget_S, Item.i, State.i)
    Protected Result, sublevel
    
    With *This
      Select \Type
        Case #PB_GadgetType_ListView
          If (\Flag\MultiSelect Or \Flag\ClickSelect)
            Result = SelectElement(\items(), Item) 
            If Result 
              \items()\State = Bool(State)+1
            EndIf
          EndIf
          
        Case #PB_GadgetType_Tree
          
          If Item < 0 : Item = 0 : EndIf
          If Item > \CountItems : Item = \CountItems :  EndIf
          ;       
          ;       If \index[2] <> Item
          ;         If \index[2] >= 0 And SelectElement(\items(), \index[2]) 
          ;           \items()\State = 0
          ;         EndIf
          ;         
          ;         If SelectElement(\items(), Item)
          ;           *Value\Type = #PB_EventType_Change
          ;           *Value\Widget = *This
          ;           \items()\State = 2
          ;           \Change = Item+1
          ;           
          ;           PostEvent(#PB_Event_Widget, *Value\Window, *This, #PB_EventType_Change)
          ;           PostEvent(#PB_Event_Gadget, *Value\Window, *Value\Gadget, #PB_EventType_Repaint)
          ;         EndIf
          ;         
          ;         \index[2] = Item
          ;         ProcedureReturn 1
          ;       EndIf
          
          
          ; If (\Flag\MultiSelect Or \Flag\ClickSelect)
          PushListPosition(\Items())
          Result = SelectElement(\Items(), Item) 
          If Result 
            If State&#PB_Tree_Selected
              \Items()\Index[1] = \Items()\Index
              \Items()\State = Bool(State)+1
            EndIf
            
            \Items()\Box\Checked = Bool(State&#PB_Tree_Collapsed)
            
            If \Items()\Box\Checked Or State&#PB_Tree_Expanded
              
              sublevel = \Items()\sublevel
              
              PushListPosition(\Items())
              While NextElement(\Items())
                If sublevel = \Items()\sublevel
                  Break
                ElseIf sublevel < \Items()\sublevel 
                  If State&#PB_Tree_Collapsed
                    \Items()\hide = 1
                  ElseIf State&#PB_Tree_Expanded
                    \Items()\hide = 0
                  EndIf
                EndIf
              Wend
            EndIf
            
          EndIf
          PopListPosition(\Items())
          ; EndIf
          
          ;          If \index[1] >= 0 And SelectElement(\items(), \index[1]) 
          ;                 Protected sublevel.i
          ;                 
          ;                 If (MouseScreenY > (\items()\box\y[1]) And MouseScreenY =< ((\items()\box\y[1]+\items()\box\height[1]))) And 
          ;                    ((MouseScreenX > \items()\box\x[1]) And (MouseScreenX =< (\items()\box\x[1]+\items()\box\width[1])))
          ;                   
          ;                   \items()\Box\Checked[1] ! 1
          ;                 ElseIf (\flag\buttons And \items()\childrens) And
          ;                        (MouseScreenY > (\items()\box\y[0]) And MouseScreenY =< ((\items()\box\y[0]+\items()\box\height[0]))) And 
          ;                        ((MouseScreenX > \items()\box\x[0]) And (MouseScreenX =< (\items()\box\x[0]+\items()\box\width[0])))
          ;                   
          ;                   sublevel = \items()\sublevel
          ;                   \items()\Box\Checked ! 1
          ;                   \Change = 1
          ;                   
          ;                   PushListPosition(\items())
          ;                   While NextElement(\items())
          ;                     If sublevel = \items()\sublevel
          ;                       Break
          ;                     ElseIf sublevel < \items()\sublevel And \items()\a
          ;                       \items()\hide = Bool(\items()\a\Box\Checked Or \items()\a\hide) * 1
          ;                     EndIf
          ;                   Wend
          ;                   PopListPosition(\items())
          ;                   
          ;                 ElseIf \index[2] <> \index[1] : \items()\State = 2
          ;                   If \index[2] >= 0 And SelectElement(\items(), \index[2])
          ;                     \items()\State = 0
          ;                   EndIf
          ;                   \index[2] = \index[1]
          ;                 EndIf
          ;                 
          ;                 Repaint = 1
          ;               EndIf
      EndSelect     
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemData(*This.Widget_S, Item.i, *Data)
    Protected Result.i
    ;   Debug "SetItemData "+Item +" "+ *Data
    ;     
    With *This
      PushListPosition(\items()) 
      ForEach \items()
        If \items()\index = Item  ;  ListIndex(\items()) = Item ;  
          \items()\data = *Data
          Break
        EndIf
      Next
      PopListPosition(\items())
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemText(*This.Widget_S, Item.i, Text.s)
    Protected Result.i
    
    With *This
      ForEach \items()
        If \items()\index = Item 
          
          If \Type = #PB_GadgetType_Property
            \items()\text[1]\string.s = Text
          Else
            \items()\text\string.s = Text
          EndIf
          
          ;\items()\Text\String.s = Text.s
          Break
        EndIf
      Next
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetData(*This.Widget_S, *Data)
    Protected Result.i
    
    With *This
      \data = *Data
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetImage(*This.Widget_S, Image.i)
    Protected i.i, Result.i = IsImage(Image)
    
    With *This
      i = Bool(\Container)
      
      \image[i]\change = 1
      
      If IsImage(Image)
        \image[i]\index = Image
        \image[i]\imageID = ImageID(Image)
        \image[i]\width = ImageWidth(Image)
        \image[i]\height = ImageHeight(Image)
      Else
        \image[i]\index =- 1
        \image[i]\imageID = 0
        \image[i]\width = 0
        \image[i]\height = 0
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetColor(*This.Widget_S, ColorType.i, Color.i, State.i=0, Item.i=0)
    Protected Result, Count 
    State =- 1
    If Item < 0 
      Item = 0 
    ElseIf Item > 3 
      Item = 3 
    EndIf
    
    With *This
      If State =- 1
        Count = 2
        \Color\State = 0
      Else
        Count = State
        \Color\State = State
      EndIf
      
      For State = \Color\State To Count
        
        Select ColorType
          Case #PB_Gadget_LineColor
            If \Color[Item]\Line[State] <> Color 
              \Color[Item]\Line[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_BackColor
            If \Color[Item]\Back[State] <> Color 
              \Color[Item]\Back[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_FrontColor
            If \Color[Item]\Front[State] <> Color 
              \Color[Item]\Front[State] = Color
              Result = #True
            EndIf
            
          Case #PB_Gadget_FrameColor
            If \Color[Item]\Frame[State] <> Color 
              \Color[Item]\Frame[State] = Color
              Result = #True
            EndIf
            
        EndSelect
        
      Next
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  ;-
  ;- CHANGE
  Procedure.i Resize(*This.Widget_S, X.i,Y.i,Width.i,Height.i)
    Protected Lines.i, Change_x, Change_y, Change_width, Change_height
    
    If *This > 0
      If Not Bool(X=#PB_Ignore And Y=#PB_Ignore And Width=#PB_Ignore And Height=#PB_Ignore)
        *Value\Type = #PB_EventType_Resize
        *Value\This = *This
      EndIf
      
      With *This
        If \Parent And \Parent\Type <> #PB_GadgetType_Splitter And 
           \Align And \Align\Left And \Align\Top And \Align\Right And \Align\Bottom
          X = 0
          Y = 0
          Width = \Parent\width[2]
          Height = \Parent\height[2]
        EndIf
        
        ; Set widget coordinate
        If X<>#PB_Ignore : If \Parent : \x[3] = X : X+\Parent\x+\Parent\bs : EndIf : If \X <> X : Change_x = x-\x : \X = X : \x[2] = \x+\bs : \x[1] = \x[2]-\fs : \Resize | 1<<1 : EndIf : EndIf  
        If Y<>#PB_Ignore : If \Parent : \y[3] = Y : Y+\Parent\y+\Parent\bs+\Parent\TabHeight : EndIf : If \Y <> Y : Change_y = y-\y : \Y = Y : \y[2] = \y+\bs+\TabHeight : \y[1] = \y[2]-\fs : \Resize | 1<<2 : EndIf : EndIf  
        ; If Width<>#PB_Ignore : If \Width <> Width : Change_width = width-\width : \Width = Width : \width[2] = \width-\bs*2 : \width[1] = \width[2]+\fs*2 : \Resize | 1<<3 : EndIf : EndIf  
        ; If Height<>#PB_Ignore : If \Height <> Height : Change_height = height-\height : \Height = Height : \height[2] = \height-\bs*2-\TabHeight : \height[1] = \height[2]+\fs*2 : \Resize | 1<<4 : EndIf : EndIf 
        If Width<>#PB_Ignore : If \Width <> Width : Change_width = width-\width : \Width = Width+Bool(\Type=-1)*(\bs*2) : \width[2] = width-Bool(\Type<>-1)*(\bs*2) : \width[1] = \width[2]+\fs*2 : \Resize | 1<<3 : EndIf : EndIf  
        If Height<>#PB_Ignore : If \Height <> Height : Change_height = height-\height : \Height = Height+Bool(\Type=-1)*(\TabHeight+\bs*2) : \height[2] = height-Bool(\Type<>-1)*(\TabHeight+\bs*2) : \height[1] = \height[2]+\fs*2 : \Resize | 1<<4 : EndIf : EndIf 
        
        If \Box And \Resize
          \hide[1] = Bool(\Page\len And Not ((\Max-\Min) > \Page\Len))
          
          If \Box\Size
            \Box\Size[1] = \Box\Size
            \Box\Size[2] = \Box\Size
          EndIf
          
          If \Max
            If \Vertical And Bool(\Type <> #PB_GadgetType_Spin)
              \Area\Pos = \Y[2]+\Box\Size[1]
              \Area\len = \Height[2]-(\Box\Size[1]+\Box\Size[2]) - Bool(\Thumb\len>0 And (\Type = #PB_GadgetType_Splitter))*\Thumb\len
            Else
              \Area\Pos = \X[2]+\Box\Size[1]
              \Area\len = \width[2]-(\Box\Size[1]+\Box\Size[2]) - Bool(\Thumb\len>0 And (\Type = #PB_GadgetType_Splitter))*\Thumb\len
            EndIf
          EndIf
          
          If (\Type <> #PB_GadgetType_Splitter) And Bool(\Resize & (1<<4 | 1<<3))
            \Thumb\len = ThumbLength(*This)
            
            If (\Area\len > \Box\Size)
              If \Box\Size
                If (\Thumb\len < \Box\Size)
                  \Area\len = Round(\Area\len - (\Box\Size[2]-\Thumb\len), #PB_Round_Nearest)
                  \Thumb\len = \Box\Size[2] 
                EndIf
              Else
                If (\Thumb\len < \Box\Size[3]) And (\Type <> #PB_GadgetType_ProgressBar)
                  \Area\len = Round(\Area\len - (\Box\Size[3]-\Thumb\len), #PB_Round_Nearest)
                  \Thumb\len = \Box\Size[3]
                EndIf
              EndIf
            Else
              \Thumb\len = \Area\len 
            EndIf
          EndIf
          
          If \Area\len > 0 And \Type <> #PB_GadgetType_Panel
            If IsStop(*This) And (\Type = #PB_GadgetType_ScrollBar)
              SetState(*This, \Max)
            EndIf
            
            \Thumb\Pos = ThumbPos(*This, \Page\Pos)
          EndIf
          
          Select \Type
            Case #PB_GadgetType_Window
              \Box\x = \x[2]
              \Box\y = \y+\bs
              \Box\width = \width[2]
              \Box\height = \TabHeight
              
              \Box\width[1] = \Box\Size
              \Box\width[2] = \Box\Size
              \Box\width[3] = \Box\Size
              
              \Box\height[1] = \Box\Size
              \Box\height[2] = \Box\Size
              \Box\height[3] = \Box\Size
              
              \Box\x[1] = \x[2]+\width[2]-\Box\width[1]-5
              \Box\y[1] = \y+\bs+(\TabHeight-\Box\Size)/2
              
              If \Box\Hide[2]
                \Box\x[2] = \Box\x[1]
              Else
                \Box\x[2] = \Box\x[1]-\Box\width[2]-5
              EndIf
              
              If \Box\Hide[3]
                \Box\x[3] = \Box\x[1]
              Else
                \Box\x[3] = \Box\x[2]-\Box\width[3]-5
              EndIf
              
              \Box\y[2] = \Box\y[1]
              \Box\y[3] = \Box\y[1]
              
            Case #PB_GadgetType_Panel
              \Page\len = \Width[2]-2
              
              If IsStop(*This)
                If \Max < \Min : \Max = \Min : EndIf
                
                If \Max > \Max-\Page\len
                  If \Max > \Page\len
                    \Max = \Max-\Page\len
                  Else
                    \Max = \Min 
                  EndIf
                EndIf
                
                \Page\Pos = \Max
                \Thumb\Pos = ThumbPos(*This, \Page\Pos)
              EndIf
              
              \Box\x[1] = \x[2]+1
              \Box\y[1] = \y[2]-\TabHeight+\bs+2
              \Box\x[2] = \x[2]+\width[2]-\Box\width[2]-1
              \Box\y[2] = \Box\y[1]
              
              \Box\width[1] = \Box\Size : \Box\height[1] = \TabHeight-1-4
              \Box\width[2] = \Box\Size : \Box\height[2] = \Box\height[1]
              
            Case #PB_GadgetType_Spin
              If \Vertical
                \Box\y[1] = \y[2]+\Height[2]/2+Bool(\Height[2]%2) : \Box\Height[1] = \Height[2]/2 : \Box\Width[1] = \Box\Size[2] : \Box\x[1] = \x[2]+\width[2]-\Box\Size[2] ; Top button coordinate
                \Box\y[2] = \y[2] : \Box\Height[2] = \Height[2]/2 : \Box\Width[2] = \Box\Size[2] : \Box\x[2] = \x[2]+\width[2]-\Box\Size[2]                                 ; Bottom button coordinate
              Else
                \Box\y[1] = \y[2] : \Box\Height[1] = \Height[2] : \Box\Width[1] = \Box\Size[2]/2 : \Box\x[1] = \x[2]+\width[2]-\Box\Size[2]                                 ; Left button coordinate
                \Box\y[2] = \y[2] : \Box\Height[2] = \Height[2] : \Box\Width[2] = \Box\Size[2]/2 : \Box\x[2] = \x[2]+\width[2]-\Box\Size[2]/2                               ; Right button coordinate
              EndIf
              
            Default
              Lines = Bool(\Type=#PB_GadgetType_ScrollBar)
              
              If \Vertical
                If \Box\Size
                  \Box\x[1] = \x[2] + Lines : \Box\y[1] = \y[2] : \Box\Width[1] = \Width - Lines : \Box\Height[1] = \Box\Size[1]                         ; Top button coordinate on scroll bar
                  \Box\x[2] = \x[2] + Lines : \Box\Width[2] = \Width - Lines : \Box\Height[2] = \Box\Size[2] : \Box\y[2] = \y[2]+\height[2]-\Box\Size[2] ; (\Area\Pos+\Area\len)   ; Bottom button coordinate on scroll bar
                EndIf
                \Box\x[3] = \x[2] + Lines : \Box\Width[3] = \Width - Lines : \Box\y[3] = \Thumb\Pos : \Box\Height[3] = \Thumb\len                        ; Thumb coordinate on scroll bar
              ElseIf \Box 
                If \Box\Size
                  \Box\x[1] = \x[2] : \Box\y[1] = \y[2] + Lines : \Box\Height[1] = \Height - Lines : \Box\Width[1] = \Box\Size[1]                        ; Left button coordinate on scroll bar
                  \Box\y[2] = \y[2] + Lines : \Box\Height[2] = \Height - Lines : \Box\Width[2] = \Box\Size[2] : \Box\x[2] = \x[2]+\width[2]-\Box\Size[2] ; (\Area\Pos+\Area\len)  ; Right button coordinate on scroll bar
                EndIf
                \Box\y[3] = \y[2] + Lines : \Box\Height[3] = \Height - Lines : \Box\x[3] = \Thumb\Pos : \Box\Width[3] = \Thumb\len                       ; Thumb coordinate on scroll bar
              EndIf
          EndSelect
          
        EndIf 
        
        ; set clip coordinate
        If \Parent And \x < \Parent\clip\x+\Parent\bs : \clip\x = \Parent\clip\x+\Parent\bs : Else : \clip\x = \x : EndIf
        If \Parent And \y < \Parent\clip\y+\Parent\bs+\Parent\TabHeight : \clip\y = \Parent\clip\y+\Parent\bs+\Parent\TabHeight : Else : \clip\y = \y : EndIf
        
        If \Parent And \Parent\s And \Parent\s\v And \Parent\s\h
          Protected v=Bool(\Parent\width=\Parent\clip\width And Not \Parent\s\v\Hide And \Parent\s\v\type = #PB_GadgetType_ScrollBar)*(\Parent\s\v\width) ;: If Not v : v = \Parent\bs : EndIf
          Protected h=Bool(\Parent\height=\Parent\clip\height And Not \Parent\s\h\Hide And \Parent\s\h\type = #PB_GadgetType_ScrollBar)*(\Parent\s\h\height) ;: If Not h : h = \Parent\bs : EndIf
        EndIf
        
        If \Parent And \x+\width>\Parent\clip\x+\Parent\clip\width-v-\Parent\bs : \clip\width = \Parent\clip\width-v-\Parent\bs-(\clip\x-\Parent\clip\x) : Else : \clip\width = \width-(\clip\x-\x) : EndIf
        If \Parent And \y+\height>=\Parent\clip\y+\Parent\clip\height-h-\Parent\bs : \clip\height = \Parent\clip\height-h-\Parent\bs-(\clip\y-\Parent\clip\y) : Else : \clip\height = \height-(\clip\y-\y) : EndIf
        
        ; Resize scrollbars
        If \s And \s\v And \s\h
          Resizes(\s, 0,0, \Width[2],\Height[2])
        EndIf
        
        ; Resize childrens
        If ListSize(\Childrens())
          If \Type = #PB_GadgetType_Splitter
            Resize_Splitter(*This)
          Else
            ForEach \Childrens()
              If \Childrens()\Align
                If \Childrens()\Align\Horizontal
                  x = (\width[2] - (\Childrens()\Align\x+\Childrens()\width))/2
                ElseIf \Childrens()\Align\Right And Not \Childrens()\Align\Left
                  x = (\width[2] - (\Childrens()\Align\x+\Childrens()\width));+Bool(\Grid>1)
                Else
                  If \x[2]
                    x = (\Childrens()\x-\x[2]) + Change_x 
                  Else
                    x = 0
                  EndIf
                EndIf
                
                If \Childrens()\Align\Vertical
                  y = (\height[2] - (\Childrens()\Align\y+\Childrens()\height))/2 
                ElseIf \Childrens()\Align\Bottom And Not \Childrens()\Align\Top
                  y = (\height[2] - (\Childrens()\Align\y+\Childrens()\height));+Bool(\Grid>1)
                Else
                  If \y[2]
                    y = (\Childrens()\y-\y[2]) + Change_y 
                  Else
                    y = 0
                  EndIf
                EndIf
                
                If \Childrens()\Align\Top And \Childrens()\Align\Bottom
                  Height = \height[2]-\Childrens()\Align\y1;+Bool(\Grid>1)
                Else
                  Height = #PB_Ignore
                EndIf
                
                If \Childrens()\Align\Left And \Childrens()\Align\Right
                  Width = \width[2]-\Childrens()\Align\x1;+Bool(\Grid>1)
                Else
                  Width = #PB_Ignore
                EndIf
                
                Resize(\Childrens(), x, y, Width, Height)
              Else
                Resize(\Childrens(), (\Childrens()\x-\x[2]) + Change_x, (\Childrens()\y-\y[2]) + Change_y, #PB_Ignore, #PB_Ignore)
              EndIf
            Next
          EndIf
        EndIf
        
        ; anchors widgets
        Resize_Anchors(*This)
        
        ProcedureReturn \hide[1]
      EndWith
    EndIf
    
  EndProcedure
  
  Procedure.i Updates(*Scroll.Scroll_S, ScrollArea_X, ScrollArea_Y, ScrollArea_Width, ScrollArea_Height)
    With *Scroll
      Protected iWidth = X(\v)-(\v\Width-\v\Radius/2)+1, iHeight = Y(\h)-(\h\Height-\h\Radius/2)+1
      Static hPos, vPos : vPos = \v\Page\Pos : hPos = \h\Page\Pos
      
      ; Вправо работает как надо
      If ScrollArea_Width<\h\Page\Pos+iWidth 
        ScrollArea_Width=\h\Page\Pos+iWidth
        ; Влево работает как надо
      ElseIf ScrollArea_X>\h\Page\Pos And
             ScrollArea_Width=\h\Page\Pos+iWidth 
        ScrollArea_Width = iWidth 
      EndIf
      
      ; Вниз работает как надо
      If ScrollArea_Height<\v\Page\Pos+iHeight
        ScrollArea_Height=\v\Page\Pos+iHeight 
        ; Верх работает как надо
      ElseIf ScrollArea_Y>\v\Page\Pos And
             ScrollArea_Height=\v\Page\Pos+iHeight 
        ScrollArea_Height = iHeight 
      EndIf
      
      If ScrollArea_X>0 : ScrollArea_X=0 : EndIf
      If ScrollArea_Y>0 : ScrollArea_Y=0 : EndIf
      
      If ScrollArea_X<\h\Page\Pos : ScrollArea_Width-ScrollArea_X : EndIf
      If ScrollArea_Y<\v\Page\Pos : ScrollArea_Height-ScrollArea_Y : EndIf
      
      If \v\max<>ScrollArea_Height : SetAttribute(\v, #PB_Bar_Maximum, ScrollArea_Height) : EndIf
      If \h\max<>ScrollArea_Width : SetAttribute(\h, #PB_Bar_Maximum, ScrollArea_Width) : EndIf
      
      If \v\Page\len<>iHeight : SetAttribute(\v, #PB_Bar_PageLength, iHeight) : EndIf
      If \h\Page\len<>iWidth : SetAttribute(\h, #PB_Bar_PageLength, iWidth) : EndIf
      
      If ScrollArea_Y<0 : SetState(\v, (ScrollArea_Height-ScrollArea_Y)-ScrollArea_Height) : EndIf
      If ScrollArea_X<0 : SetState(\h, (ScrollArea_Width-ScrollArea_X)-ScrollArea_Width) : EndIf
      
      ;     \v\hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \h) 
      ;     \h\hide = Resize(\h, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v)
      \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\Y + Bool(\h\Hide) * \h\Height) - \v\Y) ; #PB_Ignore, \h) 
      \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\X + Bool(\v\Hide) * \v\Width) - \h\X, #PB_Ignore)  ; #PB_Ignore, #PB_Ignore, \v)
      
      If \v\hide : \v\Page\Pos = 0 : If vPos : \v\hide = vPos : EndIf : Else : \v\Page\Pos = vPos : \h\Width = iWidth+\v\Width : EndIf
      If \h\hide : \h\Page\Pos = 0 : If hPos : \h\hide = hPos : EndIf : Else : \h\Page\Pos = hPos : \v\Height = iHeight+\h\Height : EndIf
      
      ProcedureReturn Bool(ScrollArea_Height>=iHeight Or ScrollArea_Width>=iWidth)
    EndWith
  EndProcedure
  
  Procedure.i Resizes(*Scroll.Scroll_S, X.i,Y.i,Width.i,Height.i)
    With *Scroll
      If y=#PB_Ignore : y = \v\Y : EndIf
      If x=#PB_Ignore : x = \h\X : EndIf
      If Width=#PB_Ignore : Width = \v\X-\h\X+\v\width : EndIf
      If Height=#PB_Ignore : Height = \h\Y-\v\Y+\h\height : EndIf
      
      ;       If \v\Parent
      ;         y - \v\Parent\bs
      ;       EndIf
      
      \v\Page\len = Height - Bool(Not \h\hide) * \h\height
      \h\Page\len = Width - Bool(Not \v\hide) * \v\width
      
      \v\Hide = Resize(\v, Width+x-\v\Width, y, #PB_Ignore, \v\Page\len)
      \h\Hide = Resize(\h, x, Height+y-\h\Height, \h\Page\len, #PB_Ignore)
      
      \v\Page\len = Height - Bool(Not \h\hide) * \h\height
      \h\Page\len = Width - Bool(Not \v\hide) * \v\width
      
      \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, \v\Page\len); + Bool(\v\Radius And Not \h\Hide And Not \v\Hide)*4)
      \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, \h\Page\len, #PB_Ignore); + Bool(\h\Radius And Not \v\Hide And Not \h\hide)*4, #PB_Ignore)
      
      If Not \v\Hide 
        \h\Hide = Resize(\h, #PB_Ignore, #PB_Ignore, (\v\x-\h\x)+Bool(\v\Radius)*4, #PB_Ignore)
      EndIf
      If Not \h\Hide 
        \v\Hide = Resize(\v, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\h\y-\v\y)+Bool(\h\Radius)*4)
      EndIf
      ProcedureReturn 1 ; Bool(Not Bool(\v\Hide And \h\Hide))
    EndWith
  EndProcedure
  
  ;-
  ;- EDITABLE
  Procedure.i Remove(*This.Widget_S)
    With *This
      If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
      \Text\String.s[1] = RemoveString(\Text\String.s[1], \Text[2]\String.s, #PB_String_CaseSensitive, \Text\Pos+\Text\Caret, 1)
      \Text\Len = Len(\Text\String.s[1])
    EndWith
  EndProcedure
  
  Procedure.i SelLimits(*This.Widget_S)
    Protected i, char.i
    
    Macro _is_selection_end_(_char_)
      Bool((_char_ > = ' ' And _char_ = < '/') Or 
           (_char_ > = ':' And _char_ = < '@') Or 
           (_char_ > = '[' And _char_ = < 96) Or 
           (_char_ > = '{' And _char_ = < '~'))
    EndMacro
    
    With *This
      char = Asc(Mid(\Text\String.s[1], \Text\Caret + 1, 1))
      If _is_selection_end_(char)
        \Text\Caret + 1
        \Text[2]\Len = 1 
      Else
        ; |<<<<<< left edge of the word 
        For i = \Text\Caret To 1 Step - 1
          char = Asc(Mid(\Text\String.s[1], i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Text\Caret[1] = i
        
        ; >>>>>>| right edge of the word
        For i = \Text\Caret To \Text\Len
          char = Asc(Mid(\Text\String.s[1], i, 1))
          If _is_selection_end_(char)
            Break
          EndIf
        Next 
        
        \Text\Caret = i - 1
        \Text[2]\Len = \Text\Caret[1] - \Text\Caret
      EndIf
    EndWith           
  EndProcedure
  
  Procedure Caret(*This.Widget_S, Line.i = 0)
    Static LastLine.i,  LastItem.i
    Protected Item.i, SelectionLen.i=0
    Protected Position.i =- 1, i.i, Len.i, X.i, FontID.i, String.s, 
              CursorX.i, Distance.f, MinDistance.f = Infinity()
    
    With *This
      If \s
        X = (\Text\X+\s\X)
      Else
        X = \Text\X
      EndIf
      
      Len = \Text\Len
      FontID = \Text\FontID
      String.s = \Text\String.s[1]
      
      If \Canvas\Gadget And StartDrawing(CanvasOutput(\Canvas\Gadget)) 
        If FontID : DrawingFont(FontID) : EndIf
        
        For i = 0 To Len
          CursorX = X + TextWidth(Left(String.s, i))
          Distance = (\Canvas\Mouse\X-CursorX)*(\Canvas\Mouse\X-CursorX)
          
          ; Получаем позицию коpректора
          If MinDistance > Distance 
            MinDistance = Distance
            Position = i
          EndIf
        Next
        
        StopDrawing()
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure SelectionText(*This.Widget_S) ; Ok
    Static Caret.i =- 1, Caret1.i =- 1, Line.i =- 1
    Protected Position.i
    
    With *This
      If Caret <> *This\Text\Caret Or Line <> *This\index[1] Or (*This\Text\Caret[1] >= 0 And Caret1 <> *This\Text\Caret[1])
        \Text[2]\String.s = ""
        
        If *This\index[2] = *This\index[1]
          If *This\Text\Caret[1] > *This\Text\Caret 
            ; |<<<<<< to left
            Position = *This\Text\Caret
            \Text[2]\Len = (*This\Text\Caret[1]-Position)
          Else 
            ; >>>>>>| to right
            Position = *This\Text\Caret[1]
            \Text[2]\Len = (*This\Text\Caret-Position)
          EndIf
          ; Если выделяем снизу вверх
        Else
          ; Три разних поведения при виделении текста 
          ; когда курсор переходит за предели виджета
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
            If *This\Text\Caret > *This\Text\Caret[1]
              ; <<<<<|
              Position = *This\Text\Caret[1]
              \Text[2]\Len = \Text\Len-Position
            Else
              ; >>>>>|
              Position = 0
              \Text[2]\Len = *This\Text\Caret[1]
            EndIf
            
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
            If *This\Text\Caret[1] > *This\Text\Caret 
              ; |<<<<<< to left
              Position = *This\Text\Caret
              \Text[2]\Len = (*This\Text\Caret[1]-Position)
            Else 
              ; >>>>>>| to right
              Position = *This\Text\Caret[1]
              \Text[2]\Len = (*This\Text\Caret-Position)
            EndIf
            
          CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
            If *This\index[1] > *This\index[2]
              ; <<<<<|
              Position = *This\Text\Caret[1]
              \Text[2]\Len = \Text\Len-Position
            Else
              ; >>>>>|
              Position = 0
              \Text[2]\Len = *This\Text\Caret[1]
            EndIf 
          CompilerEndIf
          
        EndIf
        
        \Text[1]\String.s = Left(*This\Text\String.s[1], \Text\Pos+Position) : \Text[1]\Change = #True
        If \Text[2]\Len > 0
          \Text[2]\String.s = Mid(\Text\String.s[1], 1+\Text\Pos+Position, \Text[2]\Len) : \Text[2]\Change = #True
        EndIf
        \Text[3]\String.s = Trim(Right(*This\Text\String.s[1], *This\Text\Len-(\Text\Pos+Position + \Text[2]\Len)), #LF$) : \Text[3]\Change = #True
        
        Line = *This\index[1]
        Caret = *This\Text\Caret
        Caret1 = *This\Text\Caret[1]
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  Procedure ToLeft(*This.Widget_S)
    Protected Repaint
    
    With *This
      If \Text[2]\Len
        If \Text\Caret > \Text\Caret[1] 
          Swap \Text\Caret, \Text\Caret[1]
        EndIf  
      ElseIf \Text\Caret[1] > 0 
        \Text\Caret - 1 
      EndIf
      
      If \Text\Caret[1] <> \Text\Caret
        \Text\Caret[1] = \Text\Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToRight(*This.Widget_S)
    Protected Repaint
    
    With *This
      If \Text[2]\Len 
        If \Text\Caret > \Text\Caret[1] 
          Swap \Text\Caret, \Text\Caret[1]
        EndIf
      ElseIf \Text\Caret[1] < \Text\Len
        \Text\Caret[1] + 1 
      EndIf
      
      If \Text\Caret <> \Text\Caret[1] 
        \Text\Caret = \Text\Caret[1] 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToDelete(*This.Widget_S)
    Protected Repaint
    
    With *This
      If \Text\Caret[1] < \Text\Len
        If \Text[2]\Len 
          Remove(*This)
        Else
          \Text\String.s[1] = Left(\Text\String.s[1], \Text\Pos+\Text\Caret) + Mid(\Text\String.s[1],  \Text\Pos+\Text\Caret + 2)
          \Text\Len = Len(\Text\String.s[1]) 
        EndIf
        
        \Text\Change =- 1
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToInput(*This.Widget_S)
    Static Dot, Minus, Color.i
    Protected Repaint, Input, Input_2, Chr.s
    
    With *This
      If \Canvas\input
        Chr.s = Make(*This, Chr(\Canvas\input))
        
        If Chr.s
          If \Text[2]\Len 
            Remove(*This)
          EndIf
          
          \Text\Caret + 1
          ; \items()\Text\String.s[1] = \items()\Text[1]\String.s + Chr(\Canvas\input) + \items()\Text[3]\String.s ; сним не выравнивается строка при вводе слов
          \Text\String.s[1] = InsertString(\Text\String.s[1], Chr.s, \Text\Pos+\Text\Caret)
          \Text\Len = Len(\Text\String.s[1]) 
          \Text\Caret[1] = \Text\Caret 
          \Text\Change =- 1
        Else
          ;\Default = *This
        EndIf
        
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToBack(*This.Widget_S)
    Protected Repaint, String.s 
    
    If *This\Canvas\input : *This\Canvas\input = 0
      ToInput(*This) ; Сбросить Dot&Minus
    EndIf
    
    With *This
      \Canvas\input = 65535
      
      If \Text[2]\Len
        If \Text\Caret > \Text\Caret[1] 
          Swap \Text\Caret, \Text\Caret[1]
        EndIf  
        Remove(*This)
        
      ElseIf \Text\Caret[1] > 0 
        \Text\String.s[1] = Left(\Text\String.s[1], \Text\Pos+\Text\Caret - 1) + Mid(\Text\String.s[1],  \Text\Pos+\Text\Caret + 1)
        \Text\Len = Len(\Text\String.s[1])  
        \Text\Caret - 1 
      EndIf
      
      If \Text\Caret[1] <> \Text\Caret
        \Text\Caret[1] = \Text\Caret 
        \Text\Change =- 1
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Editable(*This.Widget_S, EventType.i, MouseScreenX.i, MouseScreenY.i)
    Protected Repaint.i, Control.i, Caret.i, String.s
    
    If *This
      *This\index[1] = 0
      
      With *This
        Select EventType
          Case #PB_EventType_LeftButtonUp
            If *This\Canvas\Gadget And #PB_Cursor_Default = GetGadgetAttribute(*This\Canvas\Gadget, #PB_Canvas_Cursor)
              SetGadgetAttribute(*This\Canvas\Gadget, #PB_Canvas_Cursor, *This\Cursor)
            EndIf
            
            If *This\Text\Editable And *This\Drag[1] : *This\Drag[1] = 0
              If \Text\Caret[2] > 0 And Not Bool(\Text\Caret[2] < *This\Text\Caret + 1 And *This\Text\Caret + 1 < \Text\Caret[2] + \Text[2]\Len)
                
                *This\Text\String.s[1] = RemoveString(*This\Text\String.s[1], \Text[2]\String.s, #PB_String_CaseSensitive, \Text\Caret[2], 1)
                
                If \Text\Caret[2] > *This\Text\Caret 
                  \Text\Caret[2] = *This\Text\Caret 
                  *This\Text\Caret[1] = *This\Text\Caret + \Text[2]\Len
                Else
                  \Text\Caret[2] = (*This\Text\Caret-\Text[2]\Len)
                  *This\Text\Caret[1] = \Text\Caret[2]
                EndIf
                
                *This\Text\String.s[1] = InsertString(*This\Text\String.s[1], \Text[2]\String.s, \Text\Pos+\Text\Caret[2] + 1)
                *This\Text\Len = Len(*This\Text\String.s[1])
                \Text\String.s[1] = InsertString(\Text\String.s[1], \Text[2]\String.s, \Text\Pos+\Text\Caret[2] + 1)
                \Text\Len = Len(\Text\String.s[1])
                
                *This\Text\Change =- 1
                \Text\Caret[2] = 0
                Repaint =- 1
              EndIf
            Else
              Repaint =- 1
              \Text\Caret[2] = 0
            EndIf
            
          Case #PB_EventType_LeftButtonDown
            Caret = Caret(*This)
            
            If \Text\Caret[1] =- 1 : \Text\Caret[1] = 0
              *This\Text\Caret = 0
              *This\Text\Caret[1] = \Text\Len
              \Text[2]\Len = \Text\Len
              Repaint =- 1
            Else
              Repaint = 1
              
              If \Text[2] And \Text[2]\Len
                If *This\Text\Caret[1] > *This\Text\Caret : *This\Text\Caret[1] = *This\Text\Caret : EndIf
                
                If *This\Text\Caret[1] < Caret And Caret < *This\Text\Caret[1] + \Text[2]\Len
                  SetGadgetAttribute(*This\Canvas\Gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
                  \Text\Caret[2] = *This\Text\Caret[1] + 1
                Else
                  Repaint =- 1
                EndIf
              Else
                Repaint =- 1
              EndIf
              
              *This\Text\Caret = Caret
              *This\Text\Caret[1] = *This\Text\Caret
            EndIf 
            
          Case #PB_EventType_LeftDoubleClick 
            \Text\Caret[1] =- 1 ; Запоминаем что сделали двойной клик
            SelLimits(*This)    ; Выделяем слово
            Repaint =- 1
            
          Case #PB_EventType_MouseMove
            If *This\Canvas\Mouse\Buttons & #PB_Canvas_LeftButton 
              Caret = Caret(*This)
              If *This\Text\Caret <> Caret
                
                If \Text\Caret[2] ; *This\Cursor <> GetGadgetAttribute(*This\Canvas\Gadget, #PB_Canvas_Cursor)
                  If \Text\Caret[2] < Caret + 1 And Caret + 1 < \Text\Caret[2] + \Text[2]\Len
                    SetGadgetAttribute(*This\Canvas\Gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
                  Else
                    \Text[1]\String.s = Left(*This\Text\String.s[1], \Text\Pos+*This\Text\Caret) : \Text[1]\Change = #True
                  EndIf
                  
                  *This\Text\Caret[1] = Caret
                  Repaint = 1
                Else
                  Repaint =- 1
                EndIf
                
                *This\Text\Caret = Caret
              EndIf
            EndIf
        EndSelect
        
        CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
          Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Command)
        CompilerElse
          Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Control)
        CompilerEndIf
        
        Select EventType
          Case #PB_EventType_Input
            If Not Control
              Repaint = ToInput(*This)
            EndIf
            
          Case #PB_EventType_KeyUp
            Repaint = #True 
            
          Case #PB_EventType_KeyDown
            Select *This\Canvas\Key
              Case #PB_Shortcut_Home : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *This\Text\Caret = 0 : *This\Text\Caret[1] = *This\Text\Caret : Repaint = #True 
              Case #PB_Shortcut_End : \Text[2]\String.s = "" : \Text[2]\Len = 0 : *This\Text\Caret = \Text\Len : *This\Text\Caret[1] = *This\Text\Caret : Repaint = #True 
                
              Case #PB_Shortcut_Left, #PB_Shortcut_Up : Repaint = ToLeft(*This) ; Ok
              Case #PB_Shortcut_Right, #PB_Shortcut_Down : Repaint = ToRight(*This) ; Ok
              Case #PB_Shortcut_Back : Repaint = ToBack(*This)
              Case #PB_Shortcut_Delete : Repaint = ToDelete(*This)
                
              Case #PB_Shortcut_A
                If Control
                  *This\Text\Caret = 0
                  *This\Text\Caret[1] = \Text\Len
                  \Text[2]\Len = \Text\Len
                  Repaint = 1
                EndIf
                
              Case #PB_Shortcut_X
                If Control And \Text[2]\String.s 
                  SetClipboardText(\Text[2]\String.s)
                  Remove(*This)
                  *This\Text\Caret[1] = *This\Text\Caret
                  \Text\Len = Len(\Text\String.s[1])
                  Repaint = #True 
                EndIf
                
              Case #PB_Shortcut_C
                If Control And \Text[2]\String.s 
                  SetClipboardText(\Text[2]\String.s)
                EndIf
                
              Case #PB_Shortcut_V
                If Control
                  Protected ClipboardText.s = GetClipboardText()
                  
                  If ClipboardText.s
                    If \Text[2]\String.s
                      Remove(*This)
                    EndIf
                    
                    Select #True
                      Case *This\Text\Lower : ClipboardText.s = LCase(ClipboardText.s)
                      Case *This\Text\Upper : ClipboardText.s = UCase(ClipboardText.s)
                      Case *This\Text\Numeric 
                        If Val(ClipboardText.s)
                          ClipboardText.s = Str(Val(ClipboardText.s))
                        EndIf
                    EndSelect
                    
                    \Text\String.s[1] = InsertString(\Text\String.s[1], ClipboardText.s, *This\Text\Caret + 1)
                    *This\Text\Caret + Len(ClipboardText.s)
                    *This\Text\Caret[1] = *This\Text\Caret
                    \Text\Len = Len(\Text\String.s[1])
                    Repaint = #True
                  EndIf
                EndIf
                
            EndSelect 
            
        EndSelect
        
        If Repaint =- 1
          SelectionText(*This)
        EndIf
        
      EndWith
    EndIf  
    
    ProcedureReturn Repaint
  EndProcedure
  
  ;- 
  Procedure.i Events(*This.Widget_S, at.i, EventType.i, MouseScreenX.i, MouseScreenY.i, WheelDelta.i = 0)
    Static delta, cursor, lastat.i, Buttons.i
    Protected Repaint.i
    
    If *This > 0
      
      *Value\Type = EventType
      *Value\This = *This
      
      With *This
        
        Protected window = \Canvas\Window
        Protected canvas = \canvas\Gadget
        
;         If \anchor[1]
;           If EventType = #PB_EventType_MouseEnter
;             If (\Type = #PB_GadgetType_Splitter And at = 3)
;               \Cursor[1] = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
;               SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \Cursor)
;             Else
;               \Cursor[1] = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
;               SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \Cursor)
;             EndIf
;           EndIf
;           
;           ;           If EventType = #PB_EventType_LeftButtonDown 
;           ;             If *Value\Focus <> *This
;           ;               If *Value\Focus
;           ;                 PostEvent(#PB_Event_Widget, *Value\Canvas\Window, *Value\Focus, #PB_EventType_StatusChange, #PB_EventType_LostFocus)
;           ;               EndIf
;           ;               PostEvent(#PB_Event_Widget, *Value\Canvas\Window, *This, #PB_EventType_StatusChange, #PB_EventType_Focus)
;           ;               PostEvent(#PB_Event_Gadget, *Value\Canvas\Window, *Value\Canvas\Gadget, #PB_EventType_Repaint)
;           ;               
;           ;               *Value\Focus = *This
;           ;             EndIf
;           ;           EndIf
;           ProcedureReturn - 1
;         EndIf
        
        Select EventType 
          Case #PB_EventType_MouseMove, #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp
            ; Columns at point
            If ListSize(\Columns())
              ForEach \Columns()
                If \Columns()\Drawing
                  If \at=-1 And (MouseScreenX>=\Columns()\X And MouseScreenX=<\Columns()\X+\Columns()\Width+1 And 
                                 MouseScreenY>=\Columns()\Y And MouseScreenY=<\Columns()\Y+\Columns()\Height)
                    
                    If EventType = #PB_EventType_LeftButtonDown
                      \index[1] = \Columns()\index
                      ;\Columns()\State = 2
                      Buttons = 1
                      
                    ElseIf Not Buttons 
                      If (MouseScreenX<\Columns()\X+2 Or MouseScreenX>\Columns()\X+\Columns()\Width-2)
                        ;Debug \Columns()\Text\String
                        If Not \Canvas\Mouse\Buttons And \cursor <> GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
                          \cursor[1] = GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
                          SetGadgetAttribute(canvas, #PB_Canvas_Cursor, \cursor)
                        EndIf
                        \Columns()\State = 0
                      Else
                        If Not \Canvas\Mouse\Buttons And \cursor[1] <> GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
                          SetGadgetAttribute(canvas, #PB_Canvas_Cursor, \cursor[1])
                        EndIf
                        \Columns()\State = 1
                      EndIf
                    EndIf
                    
                    
                    repaint=1
                    
                  ElseIf \Columns()\State = 1
                    \Columns()\State = 0
                    \index[1] =- 1
                    
                    If Not \Canvas\Mouse\Buttons And \cursor[1] <> GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
                      \cursor[1] = GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
                      ;Debug 7807897  
                      SetGadgetAttribute(canvas, #PB_Canvas_Cursor, \cursor)
                      \Columns()\State = 0
                    EndIf
                    ;                     
                    repaint=1
                  EndIf
                EndIf
                
                ; columns items at point
                ForEach \Columns()\items()
                  If \Columns()\items()\Drawing
                    If \at=-1 And (MouseScreenX>\X[2] And MouseScreenX=<\X[2]+\Width[2] And 
                                   MouseScreenY>\Columns()\items()\Y And MouseScreenY=<\Columns()\items()\Y+\Columns()\items()\Height)
                      
                      If \Columns()\index[1] <> \Columns()\items()\index
                        \Columns()\index[1] = \Columns()\items()\index
                        If Not \Columns()\items()\State
                          \Columns()\items()\State = 1
                        EndIf
                        
                        ; Debug \Columns()\index[1]
                        
                        repaint=1
                      EndIf
                      
                    ElseIf \Columns()\items()\State = 1
                      \Columns()\items()\State = 0
                      \Columns()\index[1] =- 1
                      repaint=1
                    EndIf
                  EndIf
                Next
                
              Next 
              
              If Buttons
                PushListPosition(\Columns())
                If \index[1] >=0 And SelectElement(\Columns(), \index[1])
                  If (\Canvas\Mouse\X-\Columns()\x) < 0
                    \Columns()\width = 0
                  Else
                    \Columns()\width = \Canvas\Mouse\X-\Columns()\x
                  EndIf
                EndIf
                PopListPosition(\Columns())
              EndIf
              
              If EventType = #PB_EventType_LeftButtonUp
                If \index[1] >=0
                  PushListPosition(\Columns())
                  SelectElement(\Columns(), \index[1])
                  \Columns()\State = 0
                  PopListPosition(\Columns())
                  Buttons=0
                EndIf
                \Columns()\State = 1
              EndIf
              
              
            Else
              
              ; items at point
              ForEach \items()
                If \items()\Drawing
                  If \at=-1 And (MouseScreenX>\items()\X And MouseScreenX=<\items()\X+\items()\Width And 
                                 MouseScreenY>\items()\Y And MouseScreenY=<\items()\Y+\items()\Height)
                    
                    If \index[1] <> \items()\index
                      \index[1] = \items()\index
                      If Not \items()\State
                        \items()\State = 1
                      EndIf
                      
                      If \Change[1] <> \index[1]
                        
                        If \Type = #PB_GadgetType_Tree Or (Not \items()\Childrens And \Type = #PB_GadgetType_Property )
                          PostEvent(#PB_Event_Widget, *Value\Canvas\Window, *This, #PB_EventType_StatusChange, \index[1])
                        EndIf
                        
                        \Change[1] = \index[1]
                      EndIf
                      
                      repaint=1
                    EndIf
                    
                  ElseIf \items()\State = 1
                    \items()\State = 0
                    \index[1] =- 1
                    repaint=1
                  EndIf
                EndIf
              Next
              
            EndIf
        EndSelect
        
        Select EventType
          Case #PB_EventType_Focus : Repaint = 1
            If \Text And CountString(\Text\String, "_")
              If \Type =- 1
                Debug "Active "+ Val(StringField(\Text\String, 2, "_")) ; +\Type +" "+ at +" "+ *This
              Else
                Debug "Focus "+ Val(StringField(\Text\String, 2, "_")) ; +\Type +" "+ at +" "+ *This
              EndIf
            Else
              Debug "events() Focus " +\Type +" "+ at +" "+ *This
            EndIf
            
          Case #PB_EventType_LostFocus : Repaint = 1
            If \Text And CountString(\Text\String, "_")
              If \Type =- 1
                Debug "DeActive "+ Val(StringField(\Text\String, 2, "_")) ; +\Type +" "+ at +" "+ *This
              Else
                Debug "LostFocus "+ Val(StringField(\Text\String, 2, "_")) ; +\Type +" "+ at +" "+ *This
              EndIf
            Else
              Debug "events() LostFocus " +\Type +" "+ at +" "+ *This
            EndIf
            
          Case #PB_EventType_LeftButtonUp : Repaint = 1 : delta = 0
            ;             Debug "events() LeftButtonUp "+\Type +" "+ at +" "+ *This
            
          Case #PB_EventType_LeftClick 
            ;             Debug "events() LeftClick "+\Type +" "+ at +" "+ *This
            
            If \Type = #PB_GadgetType_Button
              PostEvent(#PB_Event_Widget, *Value\Canvas\Window, *This, #PB_EventType_LeftClick, \index[1])
              ;  PostEvent(#PB_Event_Gadget, *Value\Canvas\Window, *Value\Gadget, #PB_EventType_Repaint)
              Repaint = #True
            EndIf
            
          Case #PB_EventType_LeftDoubleClick 
            
            If \Type = #PB_GadgetType_ScrollBar
              If at =- 1
                If \Vertical And Bool(\Type <> #PB_GadgetType_Spin)
                  Repaint = (MouseScreenY-\Thumb\len/2)
                Else
                  Repaint = (MouseScreenX-\Thumb\len/2)
                EndIf
                
                Repaint = SetState(*This, Pos(*This, Repaint))
              EndIf
            EndIf
            
          Case #PB_EventType_LeftButtonDown
            ;             Debug "events() LeftButtonDown "+\Type +" "+ at +" "+ *This
            
            Select \Type 
              Case #PB_GadgetType_Window
                If at = 1
                  PostEvent(#PB_Event_CloseWindow, *Value\Canvas\Window, *This)
                EndIf
                
              Case #PB_GadgetType_ComboBox
                \Box\Checked ! 1
                
                If \Box\Checked
                  Display_Popup(*This, \Popup)
                  HideWindow(\Popup\Canvas\Window, 0, #PB_Window_NoActivate)
                Else
                  HideWindow(\Popup\Canvas\Window, 1)
                EndIf
                
              Case #PB_GadgetType_HyperLink
                If \cursor[1] <> GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
                  SetGadgetAttribute(canvas, #PB_Canvas_Cursor, \cursor[1])
                EndIf
                
              Case #PB_GadgetType_Option
                Repaint = SetState(*This, 1)
                
              Case #PB_GadgetType_Panel
                
                Protected State
                
                Select at
                  Case 1
                    State = \Page\Pos - \Step
                    
                    If State < \Min
                      State = \Min 
                    EndIf
                    
                    If State > \Max-\Page\len
                      If \Max > \Page\len 
                        State = \Max-\Page\len
                      Else
                        State = \Min 
                      EndIf
                    EndIf
                    
                    \Page\Pos = State
                    Repaint = 1
                    
                  Case 2
                    State = \Page\Pos + \Step
                    
                    If State < \Min
                      State = \Min 
                    EndIf
                    
                    If State > \Max-\Page\len
                      If \Max > \Page\len 
                        State = \Max-\Page\len
                      Else
                        State = \Min 
                      EndIf
                    EndIf
                    
                    \Page\Pos = State
                    Repaint = 1
                    
                  Default
                    If \index[1]<>-1
                      Repaint = SetState(*This, \index[1])
                    EndIf
                EndSelect
                
                
              Case #PB_GadgetType_CheckBox
                Repaint = SetState(*This, Bool(\Box\Checked=#PB_Checkbox_Checked) ! 1)
                
              Case #PB_GadgetType_ScrollBar, #PB_GadgetType_Spin
                Select at
                  Case 1 : Repaint = SetState(*This, (\Page\Pos - \Step)) ; Up button
                  Case 2 : Repaint = SetState(*This, (\Page\Pos + \Step)) ; Down button
                EndSelect
                
              Case #PB_GadgetType_ListIcon
                If SelectElement(\Columns(), 0) And \Columns()\index[1] >= 0
                  If SelectElement(\Columns()\items(), \Columns()\index[1]) 
                    Protected _sublevel.i
                    
                    If (MouseScreenY > (\Columns()\items()\box\y[1]) And MouseScreenY =< ((\Columns()\items()\box\y[1]+\Columns()\items()\box\height[1]))) And 
                       ((MouseScreenX > \Columns()\items()\box\x[1]) And (MouseScreenX =< (\Columns()\items()\box\x[1]+\Columns()\items()\box\width[1])))
                      
                      \Columns()\items()\Box\Checked[1] ! 1
                    ElseIf (\flag\buttons And \Columns()\items()\childrens) And
                           (MouseScreenY > (\Columns()\items()\box\y[0]) And MouseScreenY =< ((\Columns()\items()\box\y[0]+\Columns()\items()\box\height[0]))) And 
                           ((MouseScreenX > \Columns()\items()\box\x[0]) And (MouseScreenX =< (\Columns()\items()\box\x[0]+\Columns()\items()\box\width[0])))
                      
                      _sublevel = \Columns()\items()\sublevel
                      \Columns()\items()\Box\Checked ! 1
                      \Change = 1
                      
                      PushListPosition(\Columns()\items())
                      While NextElement(\Columns()\items())
                        If _sublevel = \Columns()\items()\sublevel
                          Break
                        ElseIf _sublevel < \Columns()\items()\sublevel And \Columns()\items()\a
                          \Columns()\items()\hide = Bool(\Columns()\items()\a\Box\Checked Or \Columns()\items()\a\hide) * 1
                        EndIf
                      Wend
                      PopListPosition(\Columns()\items())
                      
                    ElseIf \index[2] <> \Columns()\index[1] : \Columns()\items()\State = 2
                      If \index[2] >= 0 And SelectElement(\Columns()\items(), \index[2])
                        \Columns()\items()\State = 0
                      EndIf
                      \index[2] = \Columns()\index[1]
                    EndIf
                    
                    Repaint = 1
                  EndIf
                EndIf
                
              Default
                If ListSize(\items())
                  If \index[1] >= 0 And SelectElement(\items(), \index[1]) 
                    Protected sublevel.i
                    
                    If (MouseScreenY > (\items()\box\y[1]) And MouseScreenY =< ((\items()\box\y[1]+\items()\box\height[1]))) And 
                       ((MouseScreenX > \items()\box\x[1]) And (MouseScreenX =< (\items()\box\x[1]+\items()\box\width[1])))
                      
                      \items()\Box\Checked[1] ! 1
                    ElseIf (\flag\buttons And \items()\childrens) And
                           (MouseScreenY > (\items()\box\y[0]) And MouseScreenY =< ((\items()\box\y[0]+\items()\box\height[0]))) And 
                           ((MouseScreenX > \items()\box\x[0]) And (MouseScreenX =< (\items()\box\x[0]+\items()\box\width[0])))
                      
                      sublevel = \items()\sublevel
                      \items()\Box\Checked ! 1
                      \Change = 1
                      
                      PushListPosition(\items())
                      While NextElement(\items())
                        If sublevel = \items()\sublevel
                          Break
                        ElseIf sublevel < \items()\sublevel And \items()\a
                          \items()\hide = Bool(\items()\a\Box\Checked Or \items()\a\hide) * 1
                        EndIf
                      Wend
                      PopListPosition(\items())
                      
                    ElseIf \index[2] <> \index[1] : \items()\State = 2
                      If \index[2] >= 0 And SelectElement(\items(), \index[2])
                        \items()\State = 0
                      EndIf
                      \index[2] = \index[1]
                    EndIf
                    
                    Repaint = 1
                  EndIf
                EndIf
            EndSelect
            
            ; scrollbar & splitter
            If at = 3                                                  ; Thumb button
              If \Vertical And Bool(\Type <> #PB_GadgetType_Spin)
                delta = MouseScreenY - \Thumb\Pos
              Else
                delta = MouseScreenX - \Thumb\Pos
              EndIf
            EndIf
            
          Case #PB_EventType_MouseMove
            
            If delta
              If \Vertical And Bool(\Type <> #PB_GadgetType_Spin)
                Repaint = (MouseScreenY-delta)
              Else
                Repaint = (MouseScreenX-delta)
              EndIf
              
              Repaint = SetState(*This, Pos(*This, Repaint))
            Else
              If lastat <> at
                If lastat > 0
                  \Color[lastat]\State = 0
                EndIf
                
                If \Max And ((at = 1 And IsStart(*This)) Or (at = 2 And IsStop(*This)))
                  \Color[at]\State = 0
                  
                ElseIf at>0
                  \Color[at]\State = 1
                  \Color[at]\Alpha = 255
                  
                ElseIf at =- 1
                  \Color[1]\State = 0
                  \Color[2]\State = 0
                  \Color[3]\State = 0
                  
                  \Color[1]\Alpha = 128
                  \Color[2]\Alpha = 128
                  \Color[3]\Alpha = 128
                EndIf
                
                Repaint = #True
                lastat = at
              EndIf
            EndIf
            
          Case #PB_EventType_MouseWheel
            
            If WheelDelta <> 0
              If WheelDelta < 0 ; up
                If \Step = 1
                  Repaint + ((\Max-\Min) / 100)
                Else
                  Repaint + \Step
                EndIf
                
              ElseIf WheelDelta > 0 ; down
                If \Step = 1
                  Repaint - ((\Max-\Min) / 100)
                Else
                  Repaint - \Step
                EndIf
              EndIf
              
              Repaint = SetState(*This, (\Page\Pos + Repaint))
            EndIf  
            
          Case #PB_EventType_MouseEnter
            If IsGadget(canvas)
              \Cursor[1] = GetGadgetAttribute(canvas, #PB_Canvas_Cursor)
              SetGadgetAttribute(canvas, #PB_Canvas_Cursor, \Cursor)
              ;             Debug "events() MouseEnter " +" "+ at +" "+ *This;+\Type +" "+ \Cursor[1]  +" "+ \Cursor
            EndIf
            
          Case #PB_EventType_MouseLeave
            If IsGadget(canvas)
              SetGadgetAttribute(canvas, #PB_Canvas_Cursor, \cursor[1])
              ;             Debug "events() MouseLeave " +" "+ at +" "+ *This;+\Type +" "+ \Cursor[1]  +" "+ \Cursor
            EndIf
            
        EndSelect
        
        Select EventType
          Case #PB_EventType_MouseLeave
            
            \Color\State = 0
            If at>0
              \Color[at]\State = 0
            EndIf
            
            
            ; Debug \Type
            ; For list
            If \Type <> #PB_GadgetType_Panel And \index[1]>=0 And SelectElement(\items(), \index[1])
              If \items()\State = 1
                \items()\State = 0
                \index[1] =- 1
              EndIf
            EndIf
            
            Repaint = #True
            
          Case #PB_EventType_LeftButtonDown, #PB_EventType_LeftButtonUp, #PB_EventType_MouseEnter
            
            Select \Type 
              Case #PB_GadgetType_Button, #PB_GadgetType_ComboBox, #PB_GadgetType_HyperLink
                \Color\State = 1+Bool(EventType=#PB_EventType_LeftButtonDown)
              Case #PB_GadgetType_Window
              Default
                
                If at>0 And EventType<>#PB_EventType_MouseEnter
                  \Color[at]\State = 1+Bool(EventType=#PB_EventType_LeftButtonDown)
                EndIf
            EndSelect
            
            ;             If \Type = #PB_GadgetType_Property
            ;               If at = 3
            ;                 \Cursor[1] = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
            ;                 SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \Cursor)
            ;               EndIf
            ;             ElseIf ((\Type = #PB_GadgetType_Splitter Or \Type = #PB_GadgetType_Property) And at = 3)
            ;               \Cursor[1] = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
            ;               SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \Cursor)
            ;             Else
            ;               \Cursor[1] = GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor)
            ;               SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, \Cursor)
            ;             EndIf
            
            
        EndSelect
        
        If \Text And \Text\Editable
          Repaint | Editable(*This, EventType, MouseScreenX.i, MouseScreenY.i)
        EndIf
        
        
      EndWith
    EndIf  
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*This.Widget_S, EventType.i, MouseScreenX.i=0, MouseScreenY.i=0)
    Protected repaint.i, Canvas = EventGadget()
    ;Static lastat.i, Down.i, *Lastat.Widget_S, *Last.Widget_S, *mouseat.Widget_S
    
    With *This
      If *This
;         ; anchors events
;         If CallBack_Anchors(*This, EventType.i, \Canvas\Mouse\Buttons, MouseScreenX.i,MouseScreenY.i)
;           ProcedureReturn 1
;         EndIf
        
        If *Value\Last <> *This
          If *Value\Last And *Value\Last <> \Parent And Not *Value\Last\Canvas\Mouse\Buttons
            Events(*Value\Last, *Value\Last\at, #PB_EventType_MouseLeave, MouseScreenX, MouseScreenY)
          EndIf
          
          If Not *Value\Last Or (*Value\Last And *Value\Last\Parent <> *This)
            If \Canvas\Mouse\Buttons
              Debug 5757555
            Else
              Events(*This, \at, #PB_EventType_MouseEnter, MouseScreenX, MouseScreenY)
            EndIf
          EndIf
          
          ;         If *This\Window
          ;           Debug *This\Window\Text\String
          ;         EndIf
          
          *Value\Last = *This
          repaint = 1
        EndIf
        
        
        Select EventType 
          Case #PB_EventType_MouseMove, #PB_EventType_MouseEnter, #PB_EventType_MouseLeave
            If *Value\Last = *This 
              If \Canvas\Mouse\Buttons
                If \anchor
                  ;Events_Anchors(*This, *Value\Canvas\Mouse\x, *Value\Canvas\Mouse\y)
                  Resize(*This, *Value\Canvas\Mouse\x-\Canvas\Mouse\Delta\x, *Value\Canvas\Mouse\y-\Canvas\Mouse\Delta\y, #PB_Ignore, #PB_Ignore)
                  repaint = 1
                EndIf
              EndIf
              
              repaint | Events(*This, \at, #PB_EventType_MouseMove, MouseScreenX, MouseScreenY)
            EndIf
            
          Case #PB_EventType_LeftButtonDown, #PB_EventType_RightButtonDown
            If *Value\Last = *This : \State = 2
              SetForeground(*This.Widget_S)
              
              If \anchor
                ; Поднимаем гаджет
                Static *Pos : *Pos = GetPosition(*This, #PB_List_After)
                SetPosition(*This, #PB_List_Last)
              EndIf
              
              repaint | Events(*This, \at, EventType, MouseScreenX, MouseScreenY)
              repaint = 1
            EndIf
            
          Case #PB_EventType_LeftButtonUp, #PB_EventType_RightButtonUp
            If *Value\Focus And *Value\Focus\State = 2 : *Value\Focus\State = 1 : *Value\Focus\Canvas\Mouse\Buttons = 0
              repaint | Events(*Value\Focus, *Value\Focus\at, EventType, MouseScreenX, MouseScreenY)
              
              If \anchor And *Pos
                ; Возврашаем на место
                SetPosition(*This, #PB_List_Before, *Pos)
              EndIf
            
              If Bool(MouseScreenX>=*Value\Focus\X And MouseScreenX<*Value\Focus\X+*Value\Focus\Width And 
                      MouseScreenY>*Value\Focus\Y And MouseScreenY=<*Value\Focus\Y+*Value\Focus\Height) 
                
                If *Value\Focus = *This       
                  If EventType = #PB_EventType_LeftButtonUp
                    repaint | Events(*Value\Focus, *Value\Focus\at, #PB_EventType_LeftClick, MouseScreenX, MouseScreenY)
                  EndIf
                  If EventType = #PB_EventType_RightClick
                    repaint | Events(*Value\Focus, *Value\Focus\at, #PB_EventType_RightClick, MouseScreenX, MouseScreenY)
                  EndIf
                EndIf
                
                ;                 If *Value\Last = *This
                ;                   repaint | Events(*Value\Last, *Value\Last\at, #PB_EventType_MouseEnter, MouseScreenX, MouseScreenY)
                ;                 EndIf
                
              Else
                *Value\Focus\State = 0
                repaint | Events(*Value\Focus, *Value\Focus\at, #PB_EventType_MouseLeave, MouseScreenX, MouseScreenY)
              EndIf
            EndIf
            repaint = 1
            
            ; active widget key state
          Case #PB_EventType_Input, 
               #PB_EventType_KeyDown, 
               #PB_EventType_KeyUp
            
            \Canvas\input = GetGadgetAttribute(Canvas, #PB_Canvas_Input)
            \Canvas\Key = GetGadgetAttribute(Canvas, #PB_Canvas_Key)
            \Canvas\Key[1] = GetGadgetAttribute(Canvas, #PB_Canvas_Modifiers)
            
            If *Value\Focus = *This Or *This = *Value\Active
              repaint | Events(*This, 0, EventType, MouseScreenX, MouseScreenY)
            EndIf
            
        EndSelect
      EndIf
      
      Select EventType 
        Case #PB_EventType_LeftButtonDown, 
             #PB_EventType_MiddleButtonDown, 
             #PB_EventType_RightButtonDown 
          If *This
            
            \Canvas\Mouse\Delta = AllocateStructure(Mouse_S)
            \Canvas\Mouse\Delta\X = \Canvas\Mouse\x-\x[3]
            \Canvas\Mouse\Delta\Y = \Canvas\Mouse\y-\y[3]
            
            \Canvas\Mouse\Buttons = 1
          EndIf
          *Value\Canvas\Mouse\Buttons = 1
          
        Case #PB_EventType_LeftButtonUp, 
             #PB_EventType_MiddleButtonUp,
             #PB_EventType_RightButtonUp 
          ;Debug *Value\Active\Canvas\Mouse\Buttons
          If *Value\Focus And *Value\Focus\Canvas\Mouse\Buttons
            ;*Value\Focus
            Debug 9797987
          EndIf
          
          If *This
            If \Canvas\Mouse\Delta
              FreeStructure(\Canvas\Mouse\Delta)
              \Canvas\Mouse\Delta = 0
            EndIf
            
            \Canvas\Mouse\Buttons = 0
          EndIf
          *Value\Canvas\Mouse\Buttons = 0
          
      EndSelect
    EndWith
    
    ProcedureReturn repaint
  EndProcedure
  
  
  ;-
  Procedure.i Bar(Type.i, Size.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7, SliderLen.i=7, Parent.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S)
    
    With *This
      \X =- 1
      \Y =- 1
      \Type = Type
      \Parent = Parent
      \Radius = Radius
      \Ticks = Bool(Flag&#PB_Bar_Ticks=#PB_Bar_Ticks)
      \Smooth = Bool(Flag&#PB_Bar_Smooth=#PB_Bar_Smooth)
      \Vertical = Bool(Flag&#PB_Vertical=#PB_Vertical)
      \Box = AllocateStructure(Box_S)
      \Box\Size[3] = SliderLen ; min thumb size
      
      \Box\ArrowSize[1] = 4
      \Box\ArrowSize[2] = 4
      \Box\ArrowType[1] =- 1 ; -1 0 1
      \Box\ArrowType[2] =- 1 ; -1 0 1
      
      ; Цвет фона скролла
      \color[0]\alpha = 255
      \color\alpha[1] = 0
      \Color\State = 0
      \Color\Back = $FFF9F9F9
      \Color\Frame = \Color\Back
      \Color\Line = $FFFFFFFF
      
      \Color[1] = Color_Default
      \Color[2] = Color_Default
      \Color[3] = Color_Default
      
      \color[1]\alpha = 255
      \color[2]\alpha = 255
      \color[3]\alpha = 255
      \color[1]\alpha[1] = 128
      \color[2]\alpha[1] = 128
      \color[3]\alpha[1] = 128
      
      If Not Bool(Flag&#PB_Bar_NoButtons=#PB_Bar_NoButtons)
        If Size < 21
          \Box\Size = Size - 1
        Else
          \Box\Size = 17
        EndIf
        
        If \Vertical
          \width = Size
        Else
          \height = Size
        EndIf
      EndIf
      
      If \Min <> Min : SetAttribute(*This, #PB_Bar_Minimum, Min) : EndIf
      If \Max <> Max : SetAttribute(*This, #PB_Bar_Maximum, Max) : EndIf
      If \Page\len <> Pagelength : SetAttribute(*This, #PB_Bar_PageLength, Pagelength) : EndIf
      If Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted) : SetAttribute(*This, #PB_Bar_Inverted, #True) : EndIf
      
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Scroll(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, PageLength.i, Flag.i=0, Radius.i=7)
    Protected *This.Widget_S, Size
    Protected Vertical = (Bool(Flag&#PB_Splitter_Vertical) * #PB_Vertical)
    
    If Vertical
      Size = width
    Else
      Size =  height
    EndIf
    
    *This = Bar(#PB_GadgetType_ScrollBar, Size, Min, Max, PageLength, Flag|Vertical, Radius)
    SetLastParent(*This, #PB_GadgetType_ScrollBar) 
    SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
    SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
    Resize(*This, X,Y,Width,Height)
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Progress(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
    Protected *This.Widget_S
    Protected Smooth = Bool(Flag&#PB_ProgressBar_Smooth) * #PB_Bar_Smooth ; |(Bool(#PB_Vertical) * #PB_Bar_Inverted)
    Protected Vertical = Bool(Flag&#PB_ProgressBar_Vertical) * (#PB_Vertical|#PB_Bar_Inverted)
    
    *This = Bar(#PB_GadgetType_ProgressBar, 0, Min, Max, 0, Smooth|Vertical|#PB_Bar_NoButtons, 0)
    SetLastParent(*This, #PB_GadgetType_ProgressBar) 
    SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
    SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
    Resize(*This, X,Y,Width,Height)
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Track(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0)
    Protected *This.Widget_S
    Protected Ticks = Bool(Flag&#PB_TrackBar_Ticks) * #PB_Bar_Ticks
    Protected Vertical = Bool(Flag&#PB_TrackBar_Vertical) * (#PB_Vertical|#PB_Bar_Inverted)
    
    *This = Bar(#PB_GadgetType_TrackBar, 0, Min, Max, 0, Ticks|Vertical|#PB_Bar_NoButtons, 0)
    SetLastParent(*This, #PB_GadgetType_TrackBar)
    SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
    SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
    Resize(*This, X,Y,Width,Height)
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Splitter(X.i,Y.i,Width.i,Height.i, First.i, Second.i, Flag.i=0)
    Protected Vertical = Bool(Not Flag&#PB_Splitter_Vertical) * #PB_Vertical
    Protected Auto = Bool(Flag&#PB_Flag_AutoSize) * #PB_Flag_AutoSize
    Protected *Bar.Widget_S, *This.Widget_S, Max : If Vertical : Max = Height : Else : Max = Width : EndIf
    
    *This = Bar(0, 0, 0, Max, 0, Auto|Vertical|#PB_Bar_NoButtons, 0, 7)
    SetLastParent(*This, #PB_GadgetType_Splitter) 
    SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
    SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
    Resize(*This, X,Y,Width,Height)
 
   With *This
     \Thumb\len = 7
      \SplitterFirst = First
      \SplitterSecond = Second
      
      If \SplitterFirst
        \Type[1] = \SplitterFirst\Type
      EndIf
      
      If \SplitterSecond
        \Type[2] = \SplitterSecond\Type
      EndIf
      
      SetParent(\SplitterFirst, *This)
      SetParent(\SplitterSecond, *This)
      
      If \Vertical
        \Cursor = #PB_Cursor_UpDown
        SetState(*This, \height/2-1)
      Else
        \Cursor = #PB_Cursor_LeftRight
        SetState(*This, \width/2-1)
      EndIf
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Spin(X.i,Y.i,Width.i,Height.i, Min.i, Max.i, Flag.i=0, Increment.f=1, Radius.i=7)
    Protected *This.Widget_S = AllocateStructure(Widget_S)
    SetLastParent(*This, #PB_GadgetType_Spin) 
    
    ;Flag | Bool(Not Flag&#PB_Vertical) * (#PB_Bar_Inverted)
    
    With *This
      \X =- 1
      \Y =- 1
      
      \fs = 1
      \bs = 2
      
      \Text = AllocateStructure(Text_S)
      \Text\Align\Vertical = 1
      ;\Text\Align\Horizontal = 1
      \Text\x[2] = 5
      
      ;\Radius = Radius
      \Ticks = Bool(Flag&#PB_Bar_Ticks=#PB_Bar_Ticks)
      \Smooth = Bool(Flag&#PB_Bar_Smooth=#PB_Bar_Smooth)
      \Vertical = Bool(Not Flag&#PB_Vertical=#PB_Vertical)
      \Box = AllocateStructure(Box_S)
      
      \Text\String.s[1] = Str(Min)
      \Text\Change = 1
      
      \Box\ArrowSize[1] = 4
      \Box\ArrowSize[2] = 4
      \Box\ArrowType[1] =- 1 ; -1 0 1
      \Box\ArrowType[2] =- 1 ; -1 0 1
      
      ; Цвет фона скролла
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFFFFFFF
      \Text\Editable = 1
      
      \Color[1] = Color_Default
      \Color[2] = Color_Default
      \Color[3] = Color_Default
      
      \color[1]\alpha = 255
      \color[2]\alpha = 255
      \color[3]\alpha = 255
      \color[1]\alpha[1] = 128
      \color[2]\alpha[1] = 128
      \color[3]\alpha[1] = 128
      
      
      \Box\Size[2] = 17
      
      If \Min <> Min : SetAttribute(*This, #PB_Bar_Minimum, Min) : EndIf
      If \Max <> Max : SetAttribute(*This, #PB_Bar_Maximum, Max) : EndIf
      
      If Bool(Flag&#PB_Bar_Inverted=#PB_Bar_Inverted) : SetAttribute(*This, #PB_Bar_Inverted, #True) : EndIf
      ;\Page\len = 10
      \Step = 1
      
    EndWith
    
    SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
    SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
    Resize(*This, X,Y,Width,Height)
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Image(X.i,Y.i,Width.i,Height.i, Image.i, Flag.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    SetLastParent(*This, #PB_GadgetType_Image) 
    
    With *This
      \X =- 1
      \Y =- 1
      \Color = Color_Default
      \color\alpha = 255
      
      \fs = 1
      \bs = 2
      
      \Image = AllocateStructure(Image_S)
      Set_Image(*This, Image)
      
      \s = AllocateStructure(Scroll_S) 
      \s\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *This)
      \s\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *This)
      
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Button(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0, Image.i=-1)
    Protected *This.Widget_S = AllocateStructure(Widget_S) 
    SetLastParent(*This, #PB_GadgetType_Button) 
    
    With *This
      \X =- 1
      \Y =- 1
      \Color = Color_Default
      \color\alpha = 255
      
      \fs = 1
      
      \Text = AllocateStructure(Text_S)
      \Text\Align\Vertical = 1
      \Text\Align\Horizontal = 1
      
      \Image = AllocateStructure(Image_S)
      \image\Align\Vertical = 1
      \image\Align\Horizontal = 1
      
      SetText(*This, Text.s)
      Set_Image(*This, Image)
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      ;       Width=Match(Width,\Grid)+Bool(\Grid>1)
      ;       Height=Match(Height,\Grid)+Bool(\Grid>1)
      SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i HyperLink(X.i,Y.i,Width.i,Height.i, Text.s, Color.i, Flag.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S) 
    SetLastParent(*This, #PB_GadgetType_HyperLink) 
    
    With *This
      \X =- 1
      \Y =- 1
      \Cursor = #PB_Cursor_Hand
      \Color = Color_Default
      \color\alpha = 255
      
      \fs = 1
      \Color\Front[1] = Color
      \Color\Front[2] = Color
      
      \Text = AllocateStructure(Text_S)
      \Text\Align\Vertical = 1
      ;\Text\Align\Horizontal = 1
      \Text\MultiLine = 1
      \Text\x[2] = 5
      
      \Image = AllocateStructure(Image_S)
      \image\Align\Vertical = 1
      ;\image\Align\Horizontal = 1
      
      \Flag\Lines = Bool(Flag&#PB_HyperLink_Underline=#PB_HyperLink_Underline)
      
      SetText(*This, Text.s)
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      ;       Width=Match(Width,\Grid)+Bool(\Grid>1)
      ;       Height=Match(Height,\Grid)+Bool(\Grid>1)
      SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Text(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S) 
    SetLastParent(*This, #PB_GadgetType_Text)
    
    With *This
      \X =- 1
      \Y =- 1
      \Color = Color_Default
      \color\alpha = 255
      
      \fs = 1
      
      \Text = AllocateStructure(Text_S)
      \Text\x[2] = 3
      \Text\y[2] = 0
      
      Flag|#PB_Text_MultiLine|#PB_Text_ReadOnly;|#PB_Flag_BorderLess
      
      If Bool(Flag&#PB_Text_WordWrap)
        Flag&~#PB_Text_MultiLine
        \Text\MultiLine =- 1
      EndIf
      
      If Bool(Flag&#PB_Text_MultiLine)
        Flag&~#PB_Text_WordWrap
        \Text\MultiLine = 1
      EndIf
      
      SetText(*This, Text.s)
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i ComboBox(X.i,Y.i,Width.i,Height.i, Flag.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    SetLastParent(*This, #PB_GadgetType_ComboBox)
    
    With *This
      \X =- 1
      \Y =- 1
      \Color = Color_Default
      \color\alpha = 255
      
      \fs = 1
      \index[1] =- 1
      \index[2] =- 1
      
      \Text = AllocateStructure(Text_S)
      \Text\Align\Vertical = 1
      ;\Text\Align\Horizontal = 1
      \Text\x[2] = 5
      \Text\height = 20
      
      \Image = AllocateStructure(Image_S)
      \image\Align\Vertical = 1
      ;\image\Align\Horizontal = 1
      
      \Box = AllocateStructure(Box_S)
      \Box\height = Height
      \Box\width = 15
      \Box\ArrowSize = 4
      \Box\ArrowType =- 1
      
      \index[1] =- 1
      \index[2] =- 1
      
      \sublevellen = 18
      \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \Flag\FullSelection = 1
      \Flag\AlwaysSelection = 1
      
      \Flag\Lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)*12; Это еще будет размер чек бокса
      
      \Canvas\Window = *Value\Canvas\Window
      \Canvas\Gadget = *Value\Canvas\Gadget
      
      \Popup = Popup(*This, 0,0,0,0)
      OpenList(\Popup)
      Tree(0,0,0,0, #PB_Flag_AutoSize|#PB_Flag_NoLines|#PB_Flag_NoButtons) : \Popup\Childrens()\s\h\height=0
      CloseList()
      
      
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i CheckBox(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S) 
    SetLastParent(*This, #PB_GadgetType_CheckBox) 
    
    With *This
      \X =- 1
      \Y =- 1
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFFFFFFF
      \Color\Frame = $FF7E7E7E
      
      \fs = 1
      
      \Text = AllocateStructure(Text_S)
      \Text\Align\Vertical = 1
      \Text\MultiLine = 1
      \Text\x[2] = 25
      
      \Radius = 3
      \Box = AllocateStructure(Box_S)
      \Box\height = 15
      \Box\width = 15
      \Box\ThreeState = Bool(Flag&#PB_CheckBox_ThreeState=#PB_CheckBox_ThreeState)
      
      
      SetText(*This, Text.s)
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Option(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S) 
    SetLastParent(*This, #PB_GadgetType_Option) 
      
    With *This
      \X =- 1
      \Y =- 1
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFFFFFFF
      \Color\Frame = $FF7E7E7E
      
      \fs = 1
      
      \Text = AllocateStructure(Text_S)
      \Text\Align\Vertical = 1
      \Text\MultiLine = 1
      \Text\x[2] = 25
      
      \Box = AllocateStructure(Box_S)
      \Box\height = 15
      \Box\width = 15
      \Radius = 0
      
      
      SetText(*This, Text.s)
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i String(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S) 
    SetLastParent(*This, #PB_GadgetType_String)
    
    With *This
      \X =- 1
      \Y =- 1
      \s = AllocateStructure(Scroll_S) 
      \Cursor = #PB_Cursor_IBeam
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFFFFFFF
      
      \bs = 1
      \fs = 1
      
      \Text = AllocateStructure(Text_S)
      \Text[1] = AllocateStructure(Text_S)
      \Text[2] = AllocateStructure(Text_S)
      \Text[3] = AllocateStructure(Text_S)
      \Text\Editable = 1
      \Text\x[2] = 3
      \Text\y[2] = 0
      \Text\Align\Vertical = 1
      
      SetText(*This, Text.s)
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Tree(X.i,Y.i,Width.i,Height.i, Flag.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    SetLastParent(*This, #PB_GadgetType_Tree)
    
    With *This
      \X =- 1
      \Y =- 1
      ;\Cursor = #PB_Cursor_Hand
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \index[1] =- 1
      \index[2] =- 1
      
      \Image = AllocateStructure(Image_S)
      \Text = AllocateStructure(Text_S)
      \Text\height = 20
      
      \sublevellen = 18
      \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \Flag\FullSelection = 1
      \Flag\AlwaysSelection = 1
      
      \Flag\Lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \s = AllocateStructure(Scroll_S) 
      \s\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *This)
      \s\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *This)
       
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i ListIcon(X.i,Y.i,Width.i,Height.i, FirstColumnTitle.s, FirstColumnWidth.i, Flag.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    SetLastParent(*This, #PB_GadgetType_ListIcon)
    
    With *This
      \X =- 1
      \Y =- 1
      \Cursor = #PB_Cursor_LeftRight
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \index[1] =- 1
      \index[2] =- 1
      \Text\height = 20
      \TabHeight = 24
      
      \sublevellen = 18
      \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \Flag\FullSelection = 1
      \Flag\AlwaysSelection = 1
      
      \Flag\Lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \s = AllocateStructure(Scroll_S) 
      \s\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *This)
      \s\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *This)
      
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
      
      AddColumn(*This, 0, FirstColumnTitle, FirstColumnWidth)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i ListView(X.i,Y.i,Width.i,Height.i, Flag.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    SetLastParent(*This, #PB_GadgetType_ListView)
    
    With *This
      \X =- 1
      \Y =- 1
      ;\Cursor = #PB_Cursor_Hand
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \index[1] =- 1
      \index[2] =- 1
      
      
      \Text = AllocateStructure(Text_S)
      If StartDrawing(CanvasOutput(*Value\Canvas\Gadget))
        
        \Text\height = TextHeight("A")
        
        StopDrawing()
      EndIf
      
      \sublevellen = 0
      \Flag\Lines = 0
      \flag\buttons = 0
      
      \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \Flag\FullSelection = 1
      \Flag\AlwaysSelection = 1
      \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \s = AllocateStructure(Scroll_S) 
      \s\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *This)
      \s\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *This)
       
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Frame(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    SetLastParent(*This, #PB_GadgetType_Frame)
    
    With *This
      \X =- 1
      \Y =- 1
      \Container =- 2
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \TabHeight = 16
      
      \bs = 1
      \fs = 1
      
      \Text = AllocateStructure(Text_S)
      \Text\String.s[1] = Text.s
      \Text\Change = 1
      
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Property(X.i,Y.i,Width.i,Height.i, SplitterPos.i = 80, Flag.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    SetLastParent(*This, #PB_GadgetType_Property)
    
    With *This
      \X =- 1
      \Y =- 1
      
      \Box = AllocateStructure(Box_S)
      \Thumb\len = 7
      \Box\Size[3] = 7 ; min thumb size
      SetAttribute(*This, #PB_Bar_Maximum, Width) 
      
      ;\Container = 1
      
      
      \Cursor = #PB_Cursor_LeftRight
      SetState(*This, SplitterPos)
      
      
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \index[1] =- 1
      \index[2] =- 1
      
      \Image = AllocateStructure(Image_S)
      
      \Text = AllocateStructure(Text_S)
      \Text\height = 20
      
      \sublevellen = 18
      \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
      \Flag\MultiSelect = Bool(flag&#PB_Flag_MultiSelect)
      \Flag\ClickSelect = Bool(flag&#PB_Flag_ClickSelect)
      \Flag\FullSelection = 1
      \Flag\AlwaysSelection = 1
      
      \Flag\Lines = Bool(Not flag&#PB_Flag_NoLines)*8
      \flag\buttons = Bool(Not flag&#PB_Flag_NoButtons)*9 ; Это еще будет размер чек бокса
      \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)*12; Это еще будет размер чек бокса
      
      \fs = 1
      \bs = 2
      
      \s = AllocateStructure(Scroll_S) 
      \s\v = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Height, #PB_Vertical, 7, 7, *This)
      \s\h = Bar(#PB_GadgetType_ScrollBar,Size,0,0,Width, 0, 7, 7, *This)
       
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  ;- Containers
  Procedure.i ScrollArea(X.i,Y.i,Width.i,Height.i, ScrollAreaWidth.i, ScrollAreaHeight.i, ScrollStep.i=1, Flag.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    SetLastParent(*This, #PB_GadgetType_ScrollArea)
    
    With *This
      \X =- 1
      \Y =- 1
      \Container = 1
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \fs = 1
      \bs = 2
      
      ; Background image
      \Image[1] = AllocateStructure(Image_S)
      
      \s = AllocateStructure(Scroll_S) 
      \s\v = Bar(#PB_GadgetType_ScrollBar,Size,0,ScrollAreaHeight,Height, #PB_Vertical, 7, 7, *This)
      \s\h = Bar(#PB_GadgetType_ScrollBar,Size, 0,ScrollAreaWidth,Width, 0, 7, 7, *This)
;       Resize(\s\v, #PB_Ignore,#PB_Ignore,Size,#PB_Ignore)
;       Resize(\s\h, #PB_Ignore,#PB_Ignore,#PB_Ignore,Size)
      
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      ;       Width=Match(Width,\Grid)+Bool(\Grid>1)
      ;       Height=Match(Height,\Grid)+Bool(\Grid>1)
      SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
      OpenList(*This)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Container(X.i,Y.i,Width.i,Height.i, Flag.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    SetLastParent(*This, #PB_GadgetType_Container) 
    
    With *This
      \X =- 1
      \Y =- 1
      \Container = 1
      \Color = Color_Default
      \color\alpha = 255
      \color\Fore = 0
      \color\Back = $FFF6F6F6
      
      \index[1] =- 1
      \index[2] = 0
      
      \fs = 1
      \bs = Bool(Not Flag&#PB_Flag_AnchorsGadget)
      
      ; Background image
      \Image[1] = AllocateStructure(Image_S)
      
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      ;       Width=Match(Width,\Grid)+Bool(\Grid>1)
      ;       Height=Match(Height,\Grid)+Bool(\Grid>1)
      SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
      OpenList(*This)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Panel(X.i,Y.i,Width.i,Height.i, Flag.i=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    SetLastParent(*This, #PB_GadgetType_Panel)
      
    With *This
      \X =- 1
      \Y =- 1
      \Container = 1
      \Color = Color_Default
      \color\alpha = 255
      \Color\Back = $FFF9F9F9
      
      \index[1] =- 1
      \index[2] = 0
      
      \Box = AllocateStructure(Box_S)
      \Box\Size = 13 
      
      \Box\ArrowSize[1] = 6
      \Box\ArrowSize[2] = 6
      \Box\ArrowType[1] =- 1
      \Box\ArrowType[2] =- 1
      
      \Box\Color[1] = Color_Default
      \Box\Color[2] = Color_Default
      
      \Box\color[1]\alpha = 255
      \Box\color[2]\alpha = 255
      
      \Page\len = Width
      
      \TabHeight = 25
      \Step = 10
      
      \fs = 1
      \bs = Bool(Not Flag&#PB_Flag_AnchorsGadget)
      
      ; Background image
      \Image[1] = AllocateStructure(Image_S)
      
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      ;       Width=Match(Width,\Grid)+Bool(\Grid>1)
      ;       Height=Match(Height,\Grid)+Bool(\Grid>1)
      SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
      OpenList(*This)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Window(X.i,Y.i,Width.i,Height.i, Text.s, Flag.i=0, *Widget.Widget_S=0)
    Protected Size = 16, *This.Widget_S = AllocateStructure(Widget_S) 
    
;     If LastElement(*openedlist()) And *openedlist()\Type =- 1
;       CloseList()
;     EndIf
    
    If Not *Widget And LastElement(*openedlist()) 
      ChangeCurrentElement(*openedlist(), Adress(Root()))
      While NextElement(*openedlist())
        DeleteElement(*openedlist())
      Wend
    EndIf
    
    SetLastParent(*This, #PB_GadgetType_Window) 
      
    With *This
      \X =- 1
      \Y =- 1
      \Container =- 1
      \Color = Color_Default
      \color\Fore = 0
      \color\Back = $FFF0F0F0
      \color\alpha = 255
      \Color[1]\Alpha = 128
      \Color[2]\Alpha = 128
      \Color[3]\Alpha = 128
      
      \index[1] =- 1
      \index[2] = 0
      \TabHeight = 25
      
      \Image = AllocateStructure(Image_S)
      \image\x[2] = 5 ; padding 
      
      \Text = AllocateStructure(Text_S)
      \Text\Align\Horizontal = 1
      
      \Box = AllocateStructure(Box_S)
      \Box\Size = 12
      \Box\Color = Color_Default
      \Box\color\alpha = 255
      
      ;       \Box\Color[1]\Alpha = 128
      ;       \Box\Color[2]\Alpha = 128
      ;       \Box\Color[3]\Alpha = 128
      
      
      \Flag\Window\SizeGadget = Bool(Flag&#PB_Window_SizeGadget)
      \Flag\Window\SystemMenu = Bool(Flag&#PB_Window_SystemMenu)
      \Flag\Window\BorderLess = Bool(Flag&#PB_Window_BorderLess)
      
      \fs = 1
      \bs = Bool(Not Flag&#PB_Flag_AnchorsGadget)
      
      ; Background image
      \Image[1] = AllocateStructure(Image_S)
      
      SetText(*This, Text.s)
      SetAutoSize(*This, Bool(Flag&#PB_Flag_AutoSize=#PB_Flag_AutoSize))
      ;       Width=Match(Width,\Grid)+Bool(\Grid>1)
      ;       Height=Match(Height,\Grid)+Bool(\Grid>1)
      SetAnchors(*This, Bool(Flag&#PB_Flag_AnchorsGadget=#PB_Flag_AnchorsGadget))
      Resize(*This, X.i,Y.i,Width.i,Height)
      OpenList(*This)
      SetActive(*This)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
EndModule

;-
Macro GetActiveWidget()
  Widget::*Value\Focus
EndMacro

Macro EventWidget()
  Bool(Not IsGadget(Widget::PB(EventGadget)())) * Widget::PB(EventGadget)() + Bool(IsGadget(Widget::PB(EventGadget)())) * Widget::*Value\This
EndMacro

Macro WidgetEvent()
  Bool(Not IsGadget(Widget::PB(EventGadget)())) * Widget::PB(EventType)() + Bool(IsGadget(Widget::PB(EventGadget)())) * Widget::*Value\Type
EndMacro

Macro EventGadget()
  (Bool(Event()<>Widget::#PB_Event_Widget) * Widget::PB(EventGadget)() + Bool(Event()=Widget::#PB_Event_Widget) * Widget::*Value\Canvas\Gadget)
EndMacro

DeclareModule Helper
  Declare.i Image(X.i,Y.i,Width.i,Height.i, Title.s, Flag.i=0)
EndDeclareModule

Module Helper
  
  Procedure.i Image(X.i,Y.i,Width.i,Height.i, Title.s, Flag.i=0)
    Protected *Window.Widget::Widget_S = Widget::Window(X.i,Y.i,Width.i,Height.i, Title.s, Flag.i)
    
  EndProcedure
EndModule

;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseModule Widget
  
  Global.i gEvent, gQuit, value, direction, x=10,y=10
  Global *i.Widget_S
  Global *s.Widget_S
  Global *p.Widget_S
  
  Global *sp.Widget_S
  Global *sp.Widget_S
  
  Procedure Canvas_Events(Canvas.i, EventType.i)
    Protected Repaint, *This.Widget_S
    Protected Width = GadgetWidth(Canvas)
    Protected Height = GadgetHeight(Canvas)
    Protected MouseX = GetGadgetAttribute(Canvas, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(Canvas, #PB_Canvas_MouseY)
    Protected WheelDelta = GetGadgetAttribute(EventGadget(), #PB_Canvas_WheelDelta)
    Protected *w = GetGadgetData(Canvas)
    
    Select EventType
        ;Case #PB_EventType_Repaint : Repaint = EventData()
      Case #PB_EventType_Resize : Repaint = 1
        Resize(*w, #PB_Ignore, #PB_Ignore, Width, Height)
      Default
        
        If EventType() = #PB_EventType_LeftButtonDown
          SetActiveGadget(Canvas)
        EndIf
        
        *This = at(*w, MouseX, MouseY)
        
        If *This
          Repaint | CallBack(*This, EventType(), MouseX, MouseY)
          
          Select EventType
            Case #PB_EventType_LeftButtonDown
              
              
              Repaint = 1
          EndSelect
        EndIf
        
    EndSelect
    
    If Repaint 
      ReDraw(Canvas)
    EndIf
    
  EndProcedure
  
  Procedure Canvas_CallBack()
    ; Canvas events bug fix
    Protected Result.b
    Static MouseLeave.b
    Protected EventGadget.i = EventGadget()
    Protected EventType.i = EventType()
    Protected Width = GadgetWidth(EventGadget)
    Protected Height = GadgetHeight(EventGadget)
    Protected MouseX = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseX)
    Protected MouseY = GetGadgetAttribute(EventGadget, #PB_Canvas_MouseY)
    
    ; Это из за ошибки в мак ос и линукс
    CompilerIf #PB_Compiler_OS = #PB_OS_MacOS Or #PB_Compiler_OS = #PB_OS_Linux
      Select EventType 
        Case #PB_EventType_MouseEnter 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons) Or MouseLeave =- 1
            EventType = #PB_EventType_MouseMove
            MouseLeave = 0
          EndIf
          
        Case #PB_EventType_MouseLeave 
          If GetGadgetAttribute(EventGadget, #PB_Canvas_Buttons)
            EventType = #PB_EventType_MouseMove
            MouseLeave = 1
          EndIf
          
        Case #PB_EventType_LeftButtonDown
          If GetActiveGadget()<>EventGadget
            SetActiveGadget(EventGadget)
          EndIf
          
        Case #PB_EventType_LeftButtonUp
          If MouseLeave = 1 And Not Bool((MouseX>=0 And MouseX<Width) And (MouseY>=0 And MouseY<Height))
            MouseLeave = 0
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
              Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
              EventType = #PB_EventType_MouseLeave
            CompilerEndIf
          Else
            MouseLeave =- 1
            Result | Canvas_Events(EventGadget, #PB_EventType_LeftButtonUp)
            EventType = #PB_EventType_LeftClick
          EndIf
          
        Case #PB_EventType_LeftClick : ProcedureReturn 0
      EndSelect
    CompilerEndIf
    
    Result | Canvas_Events(EventGadget, EventType)
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure Window_0_Resize()
    ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-20, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-50)
    ResizeGadget(10, #PB_Ignore, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-35, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-10, #PB_Ignore)
  EndProcedure
  
  Procedure Window_0()
    If OpenWindow(0, 0, 0, 600, 600, "Demo inverted scrollbar direction", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
      ButtonGadget   (10,    5,   565, 590,  30, "start change scrollbar", #PB_Button_Toggle)
      
      CanvasGadget(1, 10,10, 580, 550, #PB_Canvas_Keyboard|#PB_Canvas_Container)
      SetGadgetAttribute(1, #PB_Canvas_Cursor, #PB_Cursor_Hand)
      BindGadgetEvent(1, @Canvas_CallBack())
      Define Editable = #PB_Flag_AnchorsGadget
      
      If OpenList(0, 1)
        Define w=Window(150, 50, 280, 200, "Window_1", Editable)
        
        *i.Widget_S  = Image(0, 0, 0, 0, 0)
        *s.Widget_S  = ScrollArea(0, 0, 0, 0, 250,250) : closelist() : SetState(*s\s\h, 45)
        *p.Widget_S  = Progress(0, 0, 0, 0, 0,100,0) : SetState(*p, 50)
        
        *sp.Widget_S = Splitter(10, 10, 360,  330, *i, *s)
        *sp.Widget_S = Splitter(10, 10, 360,  330, *p, *sp, #PB_Splitter_Vertical|#PB_Flag_AutoSize)
        
        Window(280, 100, 280, 200, "Window_2", Editable)
        
        Container(30,30,280-60, 200-60, Editable)
        Container(20,20,280-60, 200-60, Editable)
        Button(100, 20, 80, 80, "Button_1", Editable)
        Button(130, 80, 80, 80, "Button_2", Editable)
        Button(70, 80, 80, 80, "Button_3", Editable)
        CloseList()
        CloseList()
        
        Window(20, 150, 280, 200, "Window_3", Editable)
        
        ScrollArea(30,30,280-60, 200-60, 300, 250)
        SetState(Option(10, 10, 100, 21, "Option_2", Editable), 1)
        SetState(Option(10, 30, 100, 21, "Option_2", Editable), 1)
        
        Button(100, 20, 80, 80, "Button_1", Editable)
        Button(130, 80, 80, 80, "Button_2", Editable)
        Button(70, 80, 80, 80, "Button_3", Editable)
        CloseList()
        
        
        SetPosition(w, #PB_List_Last)
        ReDraw(1)
      EndIf
      
      BindEvent(#PB_Event_SizeWindow, @Window_0_Resize(), 0)
    EndIf
  EndProcedure
  
  Window_0()
  
  direction = 1
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
      Case #PB_Event_Timer
        ;         If IsStart(*Bar_0)
        ;           direction = 1
        ;         EndIf
        ;         If IsStop(*Bar_0)
        ;           direction =- 1
        ;         EndIf
        ;         
        ;         value + direction
        ;         
        ;         If SetState(*Bar_0, value)
        ;           ;PostEvent(#PB_Event_Gadget, 0, 1, -1)
        ;           ReDraw(1)
        ;         EndIf
        
      Case #PB_Event_Gadget
        
        ;         Select EventGadget()
        ;           Case 10
        ;             value = GetState(*Bar_0)
        ;             If GetGadgetState(10)
        ;               AddWindowTimer(0, 1, 10)
        ;             Else
        ;               RemoveWindowTimer(0, 1)
        ;             EndIf
        ;         EndSelect
        ;         
        ;         ; Get interaction with the scroll bar
        ;         CallBack(*Bar_0, EventType())
        ;         
        ;         If WidgetEventType() = #PB_EventType_Change
        ;           SetWindowTitle(0, "Change scroll direction "+ Str(GetAttribute(EventWidget(), #PB_Bar_Direction)))
        ;         EndIf
        ;         
        ;         ReDraw(1)
    EndSelect
    
  Until gQuit
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ---------------------------------------------------------------------------------------------------------------------v---------------------z----------------+-+XGQw-88v-
; EnableXP