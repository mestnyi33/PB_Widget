﻿DeclareModule _struct_
  Prototype pFunc()
  
  CompilerIf Not Defined(__anchors, #PB_Constant)
    #__anchors = 9+4
  CompilerEndIf
  
  ;- - STRUCTUREs
  ;{ 
  ;- - _s_page
  Structure _s_page
    pos.l
    len.l
    *end
  EndStructure
  
  ;- - _s_point
  Structure _s_point
    y.l[4] ; убрать 
    x.l[4]
  EndStructure
  
  ;- - _s_coordinate
  Structure _s_coordinate Extends _s_point
    width.l
    height.l
  EndStructure
  
  ;- - _s_color
  Structure _s_color
    state.b ; entered; selected; disabled;
    front.i[4]
    line.i[4]
    fore.i[4]
    back.i[4]
    frame.i[4]
    alpha.a[2]
  EndStructure
  
  ;- - _s_mouse
  Structure _s_mouse Extends _s_point
    drag.b[2]
    change.b
    buttons.l 
    wheel._s_point
    delta._s_point
  EndStructure
  
  ;- - _s_keyboard
  Structure _s_keyboard
    change.b
    input.c
    key.i[2]
  EndStructure
  
  ;- - _s_align
  Structure _s_align
    width.l
    height.l
    
    left.b
    top.b
    right.b
    bottom.b
    vertical.b
    horizontal.b
    autosize.b
  EndStructure
  
  ;- - _s_arrow
  Structure _s_arrow
    size.a
    type.b
    direction.b
  EndStructure
  
  ;- - _s_button
  Structure _s_button Extends _s_coordinate
    len.l
    hide.b
    round.a
    ; switched.b
    interact.b
    arrow._s_arrow
    color._s_color
  EndStructure
  
  ;- - _s_box
  Structure _s_box Extends _s_button
    checked.b
  EndStructure
  
  ;- - _s_caption
  Structure _s_caption Extends _s_button
    button._s_button[3]
  EndStructure
  
  ;- - _s_transform
  Structure _s_transform Extends _s_coordinate
    hide.b
    cursor.l
    color._s_color[4]
  EndStructure
  
  ;- - _s_anchor
  Structure _s_anchor
    pos.l
    size.l
    index.l
    cursor.l
    delta._s_point
    *widget._s_widget
    id._s_transform[#__anchors+1]
  EndStructure
  
  ;- - _s_windowFlag
  Structure _s_windowFlag
    SystemMenu.b     ; 13107200   - #PB_Window_SystemMenu      ; Enables the system menu on the Window Title bar (Default).
    MinimizeGadget.b ; 13238272   - #PB_Window_minimizeGadget  ; Adds the minimize Gadget To the Window Title bar. #PB_Window_SystemMenu is automatically added.
    MaximizeGadget.b ; 13172736   - #PB_Window_maximizeGadget  ; Adds the maximize Gadget To the Window Title bar. #PB_Window_SystemMenu is automatically added.
    SizeGadget.b     ; 12845056   - #PB_Window_SizeGadget      ; Adds the sizeable feature To a Window.
    Invisible.b      ; 268435456  - #PB_Window_invisible       ; creates the Window but don't display.
    TitleBar.b       ; 12582912   - #PB_Window_titleBar        ; creates a Window With a titlebar.
    Tool.b           ; 4          - #PB_Window_tool            ; creates a Window With a smaller titlebar And no taskbar entry. 
    Borderless.b     ; 2147483648 - #PB_Window_borderless      ; creates a Window without any borders.
    ScreenCentered.b ; 1          - #PB_Window_ScreenCentered  ; Centers the Window in the middle of the screen. X,Y parameters are ignored.
    WindowCentered.b ; 2          - #PB_Window_windowCentered  ; Centers the Window in the middle of the Parent Window ('ParentWindowID' must be specified).
                     ;                X,Y parameters are ignored.
    Maximize.b       ; 16777216   - #PB_Window_maximize        ; Opens the Window maximized. (Note  ; on Linux, Not all Windowmanagers support this)
    Minimize.b       ; 536870912  - #PB_Window_minimize        ; Opens the Window minimized.
    NoGadgets.b      ; 8          - #PB_Window_noGadgets       ; Prevents the creation of a GadgetList. UseGadgetList() can be used To do this later.
    NoActivate.b     ; 33554432   - #PB_Window_noActivate      ; Don't activate the window after opening.
  EndStructure
  
  ;- - _s_flag
  Structure _s_flag
    Window._s_windowFlag
    inline.b
    lines.b
    buttons.b
    gridlines.b
    checkboxes.b
    fullselection.b
    alwaysselection.b
    multiselect.b
    clickselect.b
    
    collapse.b
    option_group.b
    threestate.b
    iconsize.b
    transform.b
  EndStructure
  
  ;- - _s_caret
  Structure _s_caret Extends _s_coordinate
    pos.l[3]
    time.l
  EndStructure
  
  ;- - _s_edit
  Structure _s_edit Extends _s_coordinate
    pos.l
    len.l
    
    string.s
    change.b
  EndStructure
  
  ;- - _s_text
  Structure _s_text Extends _s_edit
                    ;     ;     Char.c
    fontID.i
    count.l
    
    pass.b
    lower.b
    upper.b
    numeric.b
    editable.b
    multiline.b
    
    rotate.f
    padding.l
    
    edit._s_edit[4]
    caret._s_caret
    align._s_align
  EndStructure
  
 ;- - _s_bar
  Structure _s_bar
    max.l
    min.l
    mode.i
    
    hide.b
    change.l
    vertical.b
    inverted.b
    direction.l
    
    increment.f
    scrollstep.f
    
    page._s_page
    area._s_page
    thumb._s_page  
    button._s_button[4]
  EndStructure
  
  ;- - _s_image
  Structure _s_image
    y.l[3]
    x.l[3]
    height.l
    width.l
    
    index.l
    handle.i[2] ; - editor
    change.b
    padding.l
    
    align._s_align
  EndStructure
  
  ;- - _s_line_
  Structure _s_line_
    v._s_coordinate
    h._s_coordinate
  EndStructure
  
  ;- - _s_tt
  Structure _s_tt Extends _s_coordinate
    window.i
    gadget.i
    
    visible.b
    
    text._s_text
    image._s_image
    color._s_color
  EndStructure
  
  ;- - _s_splitter
  Structure _s_splitter
    *first._s_widget
    *second._s_widget
    
    fixed.l[3]
    
    g_first.b
    g_second.b
  EndStructure
  
  ;- - _s_scroll
  Structure _s_scroll Extends _s_coordinate
    *v._s_widget
    *h._s_widget
  EndStructure
  
  ;- - _s_popup
  Structure _s_popup
    gadget.i
    window.i
    
    ; *Widget._s_widget
  EndStructure
  
  ;- - _s_count
  Structure _s_count
    items.l
    
    childrens.l
  EndStructure
  
  ;- - _s_margin
  Structure _s_margin Extends _s_coordinate
    color._s_color
    hide.b
  EndStructure
  
  ;- - _s_items
  Structure _s_items Extends _s_coordinate
    index.l
    *parent._s_items
    draw.b
    hide.b
    
    image._s_image
    text._s_text[4]
    box._s_box[2]
    color._s_color
    
    ;state.b
    round.a
    
    sublevel.l
    childrens.l
    sublevellen.l
    
    *data      ; set/get item data
  EndStructure
  
  ;- - _s_rows
  Structure _s_rows Extends _s_coordinate 
    ; list view
    sublevel.l
    sublevellen.l
    
    len.l ; ?????? ?????? ??????? ?????
    fontID.i
    childrens.l
    
    l._s_line_ ; 
    *last._s_rows
    *first._s_rows
    *parent._s_rows
    box._s_box[2]
    *option_group._s_rows
    
    ; edit
    margin._s_edit
    
    ;
    index.l  ; Index of new list element
    hide.b
    draw.b
    round.a
    text._s_text
    image._s_image
    color._s_color
    *data  ; set/get item data
  EndStructure
  
  ;- - _s_row
  Structure _s_row
    ; list view
    drag.b
    FontID.i
    scrolled.b
    sublevel.l
    sublevellen.l
    
    *tt._s_tt
    *first._s_rows
    List *draws._s_rows()
    
    ; edit
    ;caret._s_caret
    ;color._s_color
    margin._s_margin
    
    ;
    count.l
    index.l
    box._s_box          ; editor - edit rectangle
    *selected._s_rows
    List _s._s_rows()
  EndStructure
  
  ;- - _s_tabs
  Structure _s_tabs Extends _s_coordinate
    index.l  ; Index of new list element
    hide.b
    draw.b
    round.a
    text._s_text
    image._s_image
    color._s_color
  EndStructure
  
  ;- - _s_tab
  Structure _s_tab
    index.l ; [3] ; index[0]-parent tab  ; inex[1]-entered tab ; index[2]-selected tab
    count.l       ; count tab items
    opened.l      ; parent open list item id
    scrolled.l    ; panel set state tab
    bar._s_bar
    
    List _s._s_tabs()
  EndStructure
  
  ;- - _s_widget
  Structure _s_widget 
    type.b ;[3] ; [2] for splitter
    
    y.l[5]
    x.l[5]
    height.l[5]
    width.l[5]
    
    *root._s_root     ; adress root
    *parent._s_widget ; adress parent
    *gadget._s_widget ; this\canvas\gadget ; root\active\gadget
    *window._s_widget ; this\canvas\window ; root\active\window
    
    *scroll._s_scroll 
    *splitter._s_splitter
    
    bar._s_bar
    caption._s_caption
    color._s_color[4]
    row._s_row
    tab._s_tab
    
    errors.b
    state.b     ; mouse current state(#normal=0;#entered=1;#selected=2;#disabled=3)
    index.i[3]  ; Index[#normal=0] of new list element ; inex[#entered=1] ; index[#selected=2]
    adress.i
    round.a
    from.l
    
    ;mode.l  ; track bar
    change.l[2]
    cursor.l[2]
    hide.b[2]
    vertical.b
    
    
    fs.i 
    bs.i
    grid.i
    enumerate.i
    __height.i ; 
    drawing.i
    container.i
    
    countitems.i[2]
    
    interact.i 
    attribute.i
    
    repaint.i
    resize.b
    
    
    *Popup._s_widget
    
    combo_box._s_box
    check_box._s_box
    option_box._s_box
    *option_group._s_widget
    
    
    class.s ; 
    type_index.l
    type_count.l
    
    level.l ; ??????????? ???????
    count._s_count
    List *childrens._s_widget()
    
    List *items._s_items()
    List *columns._s_widget()
    
    flag._s_flag
    text._s_text 
    image._s_image[2]
    *align._s_align
    
    *selector._s_transform[#__anchors+1]
    *event._s_event
    *data
  EndStructure
  
  ;- - _s_event
  Structure _s_event 
    type.l
    item.l
    *data
    
    *root._s_root
    *callback.pFunc
    *widget._s_widget
    *active._s_widget ; active window
    
    ;draw.b
  EndStructure
  
  ;- - _s_root
  Structure _s_root Extends _s_widget
    canvas.i
    *anchor._s_anchor
    
    *opened._s_widget    ; open list element
    *entered._s_widget   ; at point element
    *selected._s_widget  ; pushed at point element
    
    mouse._s_mouse
    keyboard._s_keyboard
    
    event_count.b
    List *event_list._s_event()
  EndStructure
  ;}
  
  
EndDeclareModule

Module _struct_
EndModule
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -------
; EnableXP