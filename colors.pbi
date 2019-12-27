﻿DeclareModule colors
  UseModule Structures
  
  Define this._s_color 
  
  With this                          
    \state = 0
    \alpha[0] = 255
    \alpha[1] = 255
    
    ; - Серые цвета
    ; Цвета по умолчанию
    \front[0] = $80000000
    \fore[0] = $FFF6F6F6
    \back[0] = $FFE8E8E8
    \frame[0] = $FFBABABA
    
    ; Цвета если курсор на виджете
    \front[1] = $80000000
    \fore[1] = $FFF2F2F2 
    \back[1] = $FFDCDCDC 
    \frame[1] = $FFB0B0B0 
    
    ; Цвета если нажали на виджет
    \front[2] = $FFFEFEFE
    \fore[2] = $FFE2E2E2
    \back[2] = $FFB4B4B4
    \frame[2] = $FF6F6F6F
    
    ;     ;- Серые цвета 
    ;         ; Цвета по умолчанию
    ;         \front[0] = $FF000000
    ;         \fore[0] = $FFFCFCFC ; $FFF6F6F6 
    ;         \back[0] = $FFE2E2E2 ; $FFE8E8E8 ; 
    ;         \line[0] = $FFA3A3A3
    ;         \frame[0] = $FFA5A5A5 ; $FFBABABA
    ;         
    ;         ; Цвета если мышь на виджете
    ;         \front[1] = $FF000000
    ;         \fore[1] = $FFF5F5F5 ; $FFF5F5F5 ; $FFEAEAEA
    ;         \back[1] = $FFEAEAEA ; $FFCECECE ; 
    ;         \line[1] = $FF5B5B5B
    ;         \frame[1] = $FFCECECE ; $FF8F8F8F
    ;         
    ;         ; Цвета если нажали на виджет
    ;         \front[2] = $FFFFFFFF
    ;         \fore[2] = $FFE2E2E2
    ;         \back[2] = $FFB4B4B4
    ;         \line[2] = $FFFFFFFF
    ;         \frame[2] = $FF6F6F6F
    
    ;     ;- Зеленые цвета
    ;                 ; Цвета по умолчанию
    ;                 \front[0] = $FF000000
    ;                 \fore[0] = $FFFFFFFF
    ;                 \back[0] = $FFDAFCE1  
    ;                 \frame[0] = $FF6AFF70 
    ;                 
    ;                 ; Цвета если мышь на виджете
    ;                 \front[1] = $FF000000
    ;                 \fore[1] = $FFE7FFEC
    ;                 \back[1] = $FFBCFFC5
    ;                 \frame[1] = $FF46E064 ; $FF51AB50
    ;                 
    ;                 ; Цвета если нажали на виджет
    ;                 \front[2] = $FFFEFEFE
    ;                 \fore[2] = $FFC3FDB7
    ;                 \back[2] = $FF00B002
    ;                 \frame[2] = $FF23BE03
    
    ;- Синие цвета
    ; Цвета по умолчанию
    \front[0] = $80000000
    \fore[0] = $FFF8F8F8 
    \back[0] = $80E2E2E2
    \frame[0] = $80C8C8C8
    
    ; Цвета если мышь на виджете
    \front[1] = $80000000
    \fore[1] = $FFFAF8F8
    \back[1] = $80FCEADA
    \frame[1] = $80FFC288
    
    ; Цвета если нажали на виджет
    \front[2] = $FFFEFEFE
    \fore[2] = $FFE9BA81;$C8FFFCFA
    \back[2] = $FFE89C3D; $80E89C3D
    \frame[2] = $FFDC9338; $80DC9338
    
    ;     ; Цвета если нажали на виджет
    ;     \front[2] = $80000000
    ;     \fore[2] = $FFFDF7EF
    ;     \back[2] = $FFFBD9B7
    ;     \frame[2] = $FFE59B55
    
    
    
    
    
    ; Цвета если отключили виджет
    \front[3] = $FFBABABA
    \fore[3] = $FFF6F6F6 
    \back[3] = $FFE2E2E2 
    \frame[3] = $FFCECECE
  EndWith
EndDeclareModule

Module colors
EndModule

; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP