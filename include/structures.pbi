﻿XIncludeFile "constants.pbi"

;-
CompilerIf Not Defined(structures, #PB_Module)
  DeclareModule structures
    #__count_anchors_ = constants::#__anchors+1
    Prototype pFunc()
    
    ;{ 
    ;- - _s_point
    Structure _s_point
      y.l[5] ; убрать 
      x.l[constants::#__c]
    EndStructure
    
    ;- - _s_coordinate
    Structure _s_coordinate Extends _s_point
      width.l
      height.l
    EndStructure
    
    ;- - _s_color
    Structure _s_color
      state.b; entered; selected; disabled;
      front.i[4]
      line.i[4]
      fore.i[4]
      back.i[4]
      frame.i[4]
      alpha.a[2]
    EndStructure
    
    ;- - _s_align
    Structure _s_align
      delta._s_coordinate
      _left.l
      _top.l
      _right.l
      _bottom.l
      
      left.b
      top.b
      right.b
      bottom.b
      
      ; proportional.b
      autosize.b
      v.b
      h.b
    EndStructure
    
    ;- - _s_arrow
    Structure _s_arrow
      size.a
      type.b
      direction.b
    EndStructure
    
    ;- - _s_page
    Structure _s_page
      pos.l
      len.l
      *end
      change.f
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
      
      *color._s_color
    EndStructure
    
    ;- - _s_padding
    Structure _s_padding
      left.l
      top.l
      right.l
      bottom.l
    EndStructure
    
    ;- - _s_syntax
    Structure _s_syntax
      List *word._s_edit()
    EndStructure
    
    ;- - _s_text
    Structure _s_text Extends _s_edit
      ;     ;     Char.c
      fontID.i[2]
      
      StructureUnion
        pass.b
        lower.b
        upper.b
        numeric.b
      EndStructureUnion
      
      editable.b
      multiline.b
      
      invert.b
      rotate.f
      
      edit._s_edit[4]
      caret._s_caret
      align._s_align
      syntax._s_syntax
      padding._s_point
    EndStructure
    
    ;- - _s_image
    Structure _s_image
      y.l
      x.l
      height.l
      width.l
      
      index.i[3] ;
      ; index[0] - IsImage()
      ; index[1] - Image()
      ; index[2] - ImageID()
      
      padding._s_point
      align._s_align
    EndStructure
    
    ;- - _s_button
    Structure _s_button 
      y.l
      x.l
      height.l
      width.l
      
      len.l ; to >> size.l
      state.l ; normal; entered; selected; disabled
      
      ; [3]fixed = thumb delta pos 
      ; [1..2]fixed = splitter\bar\fixed
      fixed.l 
      
      hide.b
      round.a
      interact.b
      
      arrow._s_arrow
      color._s_color
      
      
      
;       padding._s_point
;       align._s_align
    EndStructure
    
    ;- - _s_tabs
    Structure _s_tabs Extends _s_coordinate
      index.l  ; Index of new list element
      hide.b
      draw.b
      round.a
      text._s_text
      img._s_image
      color._s_color
    EndStructure
    
    ;- - _s_bar
    Structure _s_bar
      ; replace
      ; index = state
      ; fixed = state[1]
      
      ; splitter - fixed button index 
      ; tab - set state button index 
      fixed.l  
      mode.i
      
      index.l ; selected button index  
      from.l  ; entered button index
      
      max.l
      min.l
      hide.b
      
      change.b ; tab items to redraw
      percent.f
      increment.f
      vertical.b
      inverted.b
      direction.l
      
      page._s_page
      area._s_page
      thumb._s_page  
      button._s_button[4]
      
      List *_s._s_tabs()
    EndStructure
    
    ;     ;- - _s_tab
    ;     Structure _s_tab
    ;       bar._s_bar
    ;       ;List *_s._s_tabs()
    ;     EndStructure
    
    ;- - _s_transform
    Structure _s_transforms
      y.l
      x.l
      width.l
      height.l
      cursor.l
      color._s_color[4]
    EndStructure
    
    ;- - _s_transforms
    Structure _s_transform
      *main._s_widget
      *widget._s_widget
      
      *grab ; grab image handle
      pos.l
      size.l
      index.l
      id._s_transforms[#__count_anchors_]
    EndStructure
    
    ;- - _s_mode
    Structure _s_mode
;       SystemMenu.b     ; 13107200   - #PB_Window_SystemMenu      ; Enables the system menu on the Window Title bar (Default).
;       MinimizeGadget.b ; 13238272   - #PB_Window_minimizeGadget  ; Adds the minimize Gadget To the Window Title bar. #PB_Window_SystemMenu is automatically added.
;       MaximizeGadget.b ; 13172736   - #PB_Window_maximizeGadget  ; Adds the maximize Gadget To the Window Title bar. #PB_Window_SystemMenu is automatically added.
;       SizeGadget.b     ; 12845056   - #PB_Window_SizeGadget      ; Adds the sizeable feature To a Window.
;       Invisible.b      ; 268435456  - #PB_Window_invisible       ; creates the Window but don't display.
;       TitleBar.b       ; 12582912   - #PB_Window_titleBar        ; creates a Window With a titlebar.
;       Tool.b           ; 4          - #PB_Window_tool            ; creates a Window With a smaller titlebar And no taskbar entry. 
;       Borderless.b     ; 2147483648 - #PB_Window_borderless      ; creates a Window without any borders.
;       ScreenCentered.b ; 1          - #PB_Window_ScreenCentered  ; Centers the Window in the middle of the screen. X,Y parameters are ignored.
;       WindowCentered.b ; 2          - #PB_Window_windowCentered  ; Centers the Window in the middle of the Parent Window ('ParentWindowID' must be specified).
;                        ;                X,Y parameters are ignored.
;       Maximize.b       ; 16777216   - #PB_Window_maximize        ; Opens the Window maximized. (Note  ; on Linux, Not all Windowmanagers support this)
;       Minimize.b       ; 536870912  - #PB_Window_minimize        ; Opens the Window minimized.
;       NoGadgets.b      ; 8          - #PB_Window_noGadgets       ; Prevents the creation of a GadgetList. UseGadgetList() can be used To do this later.
;       NoActivate.b     ; 33554432   - #PB_Window_noActivate      ; Don't activate the window after opening.
      
      ;inline.b
      lines.b
      buttons.b
      gridlines.b
      
      check.b  
      
      fullselection.b
      alwaysselection.b
      
      collapse.b
      
      threestate.b
      
      iconsize.b  ; small/large
      
      transform.b ; add anchors on the widget (to size and move)
    EndStructure
    
    ;- - _s_caption
    Structure _s_caption
      y.l[5]
      x.l[5]
      height.l[5]
      width.l[5]
      
      text._s_text
      button._s_button[4]
      color._s_color
      
      interact.b
      hide.b
      round.b
      _padding.b
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
      img._s_image
      color._s_color
    EndStructure
    
    ;- - _s_scroll
    Structure _s_scroll Extends _s_coordinate
      align._s_align
      ;padding.b
      
      *v._s_widget      ; vertical scrollbar
      *h._s_widget      ; horizontal scrollbar
    EndStructure
    
    ;- - _s_popup
    Structure _s_popup
      gadget.i
      window.i
      
      ; *Widget._s_widget
    EndStructure
    
    ;- - _s_count
    Structure _s_count
      index.l
      type.l
      items.l
      events.l
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
      
      img._s_image
      text._s_text[4]
      box._s_button[2]
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
      _state.l
      sublevel.l
      sublevellen.l
      
      len.l ; ?????? ?????? ??????? ?????
      childrens.l
      
      *last._s_rows
      *first._s_rows
      *after._s_rows
      *before._s_rows
      
      l._s_line_ ; 
      *parent._s_rows
      box._s_button[2]
      *option_group._s_rows
      
      ; edit
      margin._s_edit
      
      ;
      index.l  ; Index of new list element
      hide.b
      draw.b
      round.a
      
      text._s_text
      img._s_image
      color._s_color
      *data  ; set/get item data
    EndStructure
    
    ;- - _s_row
    Structure _s_row
      draw.l ;???????
      Map *i()
      
      ; list view
      drag.b
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
      box._s_button           ; editor - edit rectangle
      
      *entered._s_rows    ; at point item
      *selected._s_rows   ; pushed at point item
      List _s._s_rows()
    EndStructure
    
    ;- - _s_bind
    Structure _s_bind 
      *callback.pFunc
      *widget._s_widget     ; EventWidget()
      item.l                ; EventItem()
      *data                 ; EventData()
      *type
      
      Map *events()
    EndStructure
    
    ;- - _s_widget
    Structure _s_widget 
      *_drawing ; drawing_mode
      *_drawing_alpha
      
      ; side.l[4] ; sidebar сторона 
                        ;       *v._s_widget      ; vertical scrollbar
                        ;       *h._s_widget      ; horizontal scrollbar
      
      *first._s_widget
      *last._s_widget
      *after._s_widget
      *before._s_widget
      
      child.b           ; is the widget composite?
      
      *container        ; 
      *adress           ; widget list adress
      *root._s_root     ; this root
      *parent._s_widget ; this parent
      *window._s_widget ; this parent window       ; root()\active\window
      
      *gadget._s_widget[3] 
      ; \root\gadget[0] = active gadget
      ; \gadget[0] = active child gadget 
      ; \gadget[1] = panel() tabbar gadget
      ; \gadget[1] = splitter() first gadget
      ; \gadget[2] = splitter() second gadget
      
      *index[3]  
      ; \index[0] = widget index 
      ; \index[1] = panel opened item index
      ; \index[2] = panel selected item index
      ; \index[1] = tab entered item index
      ; \index[2] = tab selected item index
      
      *_flag
      _state.l
      _item.l    ; parent panel tab index
      *_group._s_widget ; = option() group gadget  
      
      
      draw.b
      type.b
      class.s  
      level.l 
      hide.b[2] 
      
      y.l[constants::#__c]
      x.l[constants::#__c]
      height.l[6];constants::#__c]
      width.l[6] ;constants::#__c]
      
      
      *errors
      notify.l ; оповестить об изменении
      interact.i 
      
      change.l
      round.a
      cursor.l[2]
      vertical.b
      
      fs.i 
      bs.i
      
      __height.i ; 
      __width.i
      
      repaint.i
      resize.b
      
      mode._s_mode
      count._s_count
      combo_box._s_button
      caption._s_caption
      scroll._s_scroll 
      color._s_color[4]
      row._s_row
      bar._s_bar
      
      button._s_button ; checkbox; optionbox
      img._s_image
      text._s_text 
      
      *data
      *align._s_align
      *selector._s_transform[#__count_anchors_]
      
      Map *bind._s_bind()
      *mouse_drag
      
      *time_click
      *time_down
      
      ; event_queue ; очередь событий
    EndStructure
    
    ;- - _s_mouse
    Structure _s_mouse Extends _s_point
      *widget._s_widget     ; at point element
                    ;;*selected._s_widget   ; at point pushed element
      
      *grid
      drag.b[2]
      change.b
      buttons.l 
      wheel._s_point
      delta._s_point
    EndStructure
    
    ;- - _s_keyboard
    Structure _s_keyboard
      *widget._s_widget     ; keyboard focused element
      change.b
      input.c
      key.i[2]
    EndStructure
    
    ;- - _s_canvas
    Structure _s_canvas
      *widget._s_widget     ; opened list element
      container.i
      window.i
      gadget.i
      repaint.b
    EndStructure
    
    ;- - _s_root
    Structure _s_root Extends _s_widget
      canvas._s_canvas
      *transform._s_transform
    EndStructure
    
    ;- - _s_this
    Structure _s_this
      mouse._s_mouse        ; Mouse()\
      keyboard._s_keyboard  ; Keyboard()\
      *callback.pFunc
      
      List *_root._s_root() ; 
      *active._s_widget     ; GetActiveWindow()\
      *widget._s_widget     ; EventWidget()
      
      *event                 ; EventType()
      *item                 ; EventItem()
      *data                 ; EventData()
      
      List *_childrens._s_widget()
      List *post._s_bind()
      Map *_bind._s_bind()
    EndStructure
    
    Global *event._s_this = AllocateStructure(_s_this)
    
  EndDeclareModule 
  
  Module structures 
    
  EndModule 
CompilerEndIf
; IDE Options = PureBasic 5.72 (MacOS X - x64)
; Folding = --v+fP-
; EnableXP