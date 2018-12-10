﻿; ++ надо исправить на последней строке ентер дает ошибку
; + если есть вертикальный скроллбар авто прокручивает в конец файла
; - горизонтальный скролл не перемешает текст если строка выбрана
; - при выделении не прокручивает текст
; - при перемещении корета вниз не прокручивается страница
; + если добавить слова в конец текста и нажать ентер есть ошибки
; + если добавить букву в конец текста потом убрать с помошью бекспейс затем нажать ентер то переносится удаленная буква
; + если выделить слова в одной строке и нажать бекспейс затем нажать ентер то переносятся удаленые слова
; + При переходе на предыдущую строку если переходящая строка длинее предыдушего была ошибка перемещения корета на предыдущей строке
; + когда выделяем 2-3 строки затем вырезаем затем ставляем, курсон не перемещается правильно
; - после запуска если шелкнуть в начале строки курсор оказывается в конце строки и строка выделяется полностью
; - если текст веденный спомощью settext() шире ширины виджета то additem() не работает



CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
  ;  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
  ;  IncludePath "/Users/as/Documents/GitHub/Widget/"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
  ;  IncludePath "/Users/a/Documents/GitHub/Widget/"
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_draw.pbi"
  
  XIncludeFile "module_macros.pbi"
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
  XIncludeFile "module_scroll.pbi"
  XIncludeFile "module_text.pbi"
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
CompilerEndIf

DeclareModule Editor
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
  
  ;- - DECLAREs MACROs
  Macro Resize(_adress_, _x_,_y_,_width_,_height_) : Text::Resize(_adress_, _x_,_y_,_width_,_height_) : EndMacro
  Declare.i Update(*This.Widget_S)
  
  ;- DECLARE
  Declare.i SetItemState(*This.Widget_S, Item.i, State.i)
  Declare GetState(*This.Widget_S)
  Declare.s GetText(*This.Widget_S)
  Declare.i ClearItems(*This.Widget_S)
  Declare.i CountItems(*This.Widget_S)
  Declare.i RemoveItem(*This.Widget_S, Item.i)
  Declare SetState(*This.Widget_S, State.i)
  Declare GetAttribute(*This.Widget_S, Attribute.i)
  Declare SetAttribute(*This.Widget_S, Attribute.i, Value.i)
  Declare SetText(*This.Widget_S, Text.s, Item.i=0)
  Declare SetFont(*This.Widget_S, FontID.i)
  Declare.i AddItem(*This.Widget_S, Item.i,Text.s,Image.i=-1,Flag.i=0)
  
  Declare.i Make(*This.Widget_S)
  Declare.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
  Declare.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
  Declare.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
EndDeclareModule

Module Editor
  Global *Buffer = AllocateMemory(10000000)
  Global *Pointer = *Buffer

  Procedure.i Update(*This.Widget_S)
    *This\Text\String.s = PeekS(*Buffer)
    *This\Text\Change = 1
    FreeMemory(*Buffer)
  EndProcedure
  
  
  ; ;   UseModule Constant
  ;- PROCEDURE
  ;-
  Procedure.i Caret(*This.Widget_S, Line.i = 0)
    Static LastLine.i =- 1,  LastItem.i =- 1
    Protected Item.i, SelectionLen.i
    Protected Position.i =- 1, i.i, Len.i, X.i, FontID.i, String.s, 
              CursorX.i, Distance.f, MinDistance.f = Infinity()
    
    With *This
      If Line < 0 And FirstElement(*This\Items())
        ; А если выше всех линии текста,
        ; то позиция коректора начало текста.
        Position = 0
      ElseIf Line < ListSize(*This\Items()) And 
             SelectElement(*This\Items(), Line)
        ; Если находимся на линии текста, 
        ; то получаем позицию коректора.
        
        If ListSize(\Items())
          X = (\Items()\Text\X+\Scroll\X)
          Len = \Items()\Text\Len
          FontID = \Items()\Text\FontID
          String.s = \Items()\Text\String.s
          If Not FontID : FontID = \Text\FontID : EndIf
          
          If StartDrawing(CanvasOutput(\Canvas\Gadget)) 
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
            
            SelectionLen = Bool(Not \Flag\FullSelection)*7
            
            ; Длина переноса строки
            PushListPosition(\Items())
            If \Canvas\Mouse\Y < \Y+(\Text\Height/2+1)
              Item.i =- 1 
            Else
              Item.i = ((((\Canvas\Mouse\Y-\Y-\Text\Y)-\Scroll\Y) / (\Text\Height/2+1)) - 1)/2
            EndIf
            
            If LastLine <> \Index[1] Or LastItem <> Item
              \Items()\Text[2]\Width[2] = 0
              
              If (\Items()\Text\String.s = "" And Item = \Index[1] And Position = len) Or
                 \Index[2] > \Index[1] Or                                            ; Если выделяем снизу вверх
                 (\Index[2] =< \Index[1] And \Index[1] = Item And Position = len) Or ; Если позиция курсора неже половини высоты линии
                 (\Index[2] < \Index[1] And                                          ; Если выделяем сверху вниз
                  PreviousElement(*This\Items()))                                    ; то выбираем предыдущую линию
                
                If Position = len And Not \Items()\Text[2]\Len : \Items()\Text[2]\Len = 1
                  \Items()\Text[2]\X = \Items()\Text\X+\Items()\Text\Width
                EndIf 
                
                If Not SelectionLen
                  \Items()\Text[2]\Width[2] = \Items()\Width-\Items()\Text\Width
                Else
                  \Items()\Text[2]\Width[2] = SelectionLen
                EndIf
              EndIf
              
              LastItem = Item
              LastLine = \Index[1]
            EndIf
            PopListPosition(\Items())
            
            StopDrawing()
          EndIf
        EndIf
        
      ElseIf LastElement(*This\Items())
        ; Иначе, если ниже всех линии текста,
        ; то позиция коректора конец текста.
        Position = \Items()\Text\Len
      EndIf
    EndWith
    
    ProcedureReturn Position
  EndProcedure
  
  
  Procedure SelectionText(*This.Widget_S) ; Ok
    Static Caret.i =- 1, Caret1.i =- 1, Line.i =- 1
    Protected Pos.i, Len.i
    
    With *This
      ;Debug "7777    "+\Text\Caret +" "+ \Text\Caret[1] +" "+\Index[1] +" "+ \Index[2] +" "+ \Items()\Text\String
      
      If (Caret <> \Text\Caret Or Line <> \Index[1] Or (\Text\Caret[1] >= 0 And Caret1 <> \Text\Caret[1]))
        \Items()\Text[2]\String.s = ""
        
        PushListPosition(\Items())
        If \Index[2] = \Index[1]
          If \Text\Caret[1] = \Text\Caret And \Items()\Text[2]\Len > 0 
            \Items()\Text[2]\Len = 0 
            \Items()\Text[2]\Width = 0 
          EndIf
          If PreviousElement(\Items()) And \Items()\Text[2]\Len > 0 
            \Items()\Text[2]\Width[2] = 0 
            \Items()\Text[2]\Len = 0 
          EndIf
        ElseIf \Index[2] > \Index[1]
          If PreviousElement(\Items()) And \Items()\Text[2]\Len > 0 
            \Items()\Text[2]\Len = 0 
          EndIf
        Else
          If NextElement(\Items()) And \Items()\Text[2]\Len > 0 
            \Items()\Text[2]\Len = 0 
          EndIf
        EndIf
        PopListPosition(\Items())
        
        If \Index[2] = \Index[1]
          If \Text\Caret[1] = \Text\Caret 
            Pos = \Text\Caret[1]
            ;             If \Text\Caret[1] = \Items()\Text\Len
            ;              ; Debug 555
            ;             ;  Len =- 1
            ;             EndIf
            ; Если выделяем с право на лево
          ElseIf \Text\Caret[1] > \Text\Caret 
            ; |<<<<<< to left
            Pos = \Text\Caret
            Len = (\Text\Caret[1]-Pos)
          Else 
            ; >>>>>>| to right
            Pos = \Text\Caret[1]
            Len = (\Text\Caret-Pos)
          EndIf
          
          ; Если выделяем снизу вверх
        ElseIf \Index[2] > \Index[1]
          ; <<<<<|
          Pos = \Text\Caret
          Len = \Items()\Text\Len-Pos
          Len | Bool(\Items()\Text\Len=Pos) ; 
        Else
          ; >>>>>|
          Pos = 0
          Len = \Text\Caret
        EndIf
        
        Text::Change(*This, Pos, Len)
        
        Line = \Index[1]
        Caret = \Text\Caret
        Caret1 = \Text\Caret[1]
      EndIf
    EndWith
    
    ProcedureReturn Pos
  EndProcedure
  
  
  
  ;-
  ;- PUBLIC
  Procedure.i Change(*This.Widget_S, Pos.i, Len.i)
    With *This
      \Items()\Text[2]\Pos = Pos
      \Items()\Text[2]\Len = Len
      
      ; lines string/pos/len/state
      \Items()\Text[1]\Change = #True
      \Items()\Text[1]\Len = \Items()\Text[2]\Pos
      \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Items()\Text[1]\Len) 
      
      \Items()\Text[3]\Change = #True
      \Items()\Text[3]\Pos = (\Items()\Text[2]\Pos + \Items()\Text[2]\Len)
      \Items()\Text[3]\Len = (\Items()\Text\Len - \Items()\Text[3]\Pos)
      \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text[3]\Len) 
      
      If \Items()\Text[1]\Len = \Items()\Text[3]\Pos
        \Items()\Text[2]\String.s = ""
        \Items()\Text[2]\Width = 0
      Else
        \Items()\Text[2]\Change = #True 
        \Items()\Text[2]\String.s = Mid(\Items()\Text\String.s, 1 + \Items()\Text[2]\Pos, \Items()\Text[2]\Len) 
      EndIf
      
      ; text string/pos/len/state
      If (\index[2] > \index[1] Or \index[2] = \Items()\index)
        \Text[1]\Len = (\Items()\Text[0]\Pos + \Items()\Text[1]\len)
        \Text[1]\String.s = Left(\Text\String.s, \Text[1]\Len) 
        \Text[2]\Pos = \Text[1]\Len
        \Text[1]\Change = #True
      EndIf
      
      If (\index[2] < \index[1] Or \index[2] = \Items()\index) 
        \Text[3]\Pos = (\Items()\Text[0]\Pos + \Items()\Text[3]\Pos)
        \Text[3]\Len = (\Text\Len - \Text[3]\Pos)
        \Text[3]\String.s = Right(\Text\String.s, \Text[3]\Len) 
        \Text[3]\Change = #True
      EndIf
      
      If \Text[1]\Len = \Text[3]\Pos
        \Text[2]\Len = 0
        \Text[2]\String.s = ""
      Else
        \Text[2]\Change = #True 
        \Text[2]\Len = (\Text[3]\Pos-\Text[2]\Pos)
        \Text[2]\String.s = Mid(\Text\String.s[2], 1 + \Text[2]\Pos, \Text[2]\Len) 
      EndIf
       ;Debug "chang "+\Text[1]\String.s;Left(\Text\String.s, pos)
      
    EndWith
  EndProcedure
  
  Procedure.i SelReset(*This.Widget_S)
    With *This
      PushListPosition(\Items())
      ForEach \Items() 
        If \Items()\Text[2]\Len <> 0
          \Items()\Text[2]\Len = 0 
          \Items()\Text[2]\Width[2] = 0 
          \Items()\Text[1]\String = ""
          \Items()\Text[2]\String = "" 
          \Items()\Text[3]\String = ""
          \Items()\Text[2]\Width = 0 
        EndIf
      Next
      PopListPosition(\Items())
    EndWith
  EndProcedure
  
  Procedure.i SelSet(*This.Widget_S)
    With *This
      PushListPosition(\Items())
      ForEach \Items() 
        \Items()\Text[2]\Len = \Items()\Text\Len 
        \Items()\Text[2]\Width[2] = \Flag\FullSelection
        \Items()\Text[1]\String = ""
        \Items()\Text[2]\String = "" 
        \Items()\Text[3]\String = ""
        \Items()\Text[2]\Width = 0 
      Next
      PopListPosition(\Items())
    EndWith
  EndProcedure
  
  Procedure.i Paste(*This.Widget_S, Chr.s, Count.i=0)
    Protected Repaint, String.s
    
    With *This
      If \Index[1] <> \Index[2] ; Это значить строки выделени
        If \Index[2] > \Index[1] : Swap \Index[2], \Index[1] : EndIf
        
        ;           PushListPosition(\Items())
        If SelectElement(\Items(), \Index[2])
          String.s = Left(\Text\String.s, \Items()\Text\Pos) + \Items()\Text[1]\String.s + Chr.s
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          \Text\Caret = \Items()\Text[1]\Len 
        EndIf   
        
        If SelectElement(\Items(), \Index[1])
          String.s + \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Text\Pos+\Items()\Text\Len))
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
        EndIf
        ;           PopListPosition(\Items())
        
        If Count
          \Index[2] + Count
        ElseIf Chr.s = #LF$ ; to return
          \Index[2] + 1
          \Text\Caret = 0
        EndIf
        
        \Text\Caret[1] = \Text\Caret
        \Index[1] = \Index[2]
        \Text\String.s = String.s
        \Text\Len = Len(\Text\String.s)
        \Text\Change =- 1 ; - 1 post event change widget
        Repaint = 1 
      EndIf
      
      ;         SelectElement(\items(), \index[2]) 
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Cut(*This.Widget_S)
    ProcedureReturn Paste(*This.Widget_S, "")
  EndProcedure
  
  Procedure.i Insert(*This.Widget_S, Chr.s)
    Static Dot, Minus, Color.i
    Protected Repaint, Input, Input_2, String.s, Count.i
    
    With *This
      Chr.s = Text::Make(*This, Chr.s)
      
      If Chr.s
        Count = CountString(Chr.s, #LF$)
        
        If Not Paste(*This, Chr.s, Count)
          If \Items()\Text[2]\Len 
            If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
            \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Text\Pos+\Text\Caret, 1)
            \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          EndIf
          
          \Items()\Text[1]\Change = 1
          \Items()\Text[1]\String.s + Chr.s
          \Items()\Text[1]\len = Len(\Items()\Text[1]\String.s)
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          String.s = InsertString(\Text\String.s, Chr.s, \Items()\Text\Pos+\Text\Caret + 1)
          
          If Count
            \Index[2] + Count
            \Index[1] = \Index[2] 
            \Text\Caret = Len(StringField(Chr.s, 1 + Count, #LF$))
          Else
            \Text\Caret + Len(Chr.s) 
          EndIf
          
          \Text\Caret[1] = \Text\Caret 
          \Text\String.s = String.s
          \Text\Len = Len(\Text\String.s)
          \Text\Change =- 1 ; - 1 post event change widget
        EndIf
        
        SelectElement(\items(), \index[2]) 
        Repaint = 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  ;- - KeyBoard
  Procedure.i ToUp(*This.Widget_S)
    Protected Repaint
    ; Если дошли до начала строки то 
    ; переходим в конец предыдущего итема
    
    With *This
      If (\Index[2] > 0 And \Index[1] = \Index[2]) : \Index[2] - 1 : \Index[1] = \Index[2]
        SelectElement(\Items(), \Index[2])
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToDown(*This.Widget_S)
    Protected Repaint
    ; Если дошли до начала строки то 
    ; переходим в конец предыдущего итема
    
    With *This
      If (\Index[1] < ListSize(\Items()) - 1 And \Index[1] = \Index[2]) : \Index[2] + 1 : \Index[1] = \Index[2]
        SelectElement(\Items(), \Index[2]) 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToLeft(*This.Widget_S) ; Ok
    Protected Repaint
    
    With *This
      If \Items()\Text[2]\Len
        If \Index[2] > \Index[1] 
          Swap \Index[2], \Index[1]
          
          If SelectElement(\Items(), \Index[2]) 
            \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret[1]) 
            \Items()\Text[1]\Change = #True
          EndIf
        ElseIf \Index[1] > \Index[2] And 
               \Text\Caret[1] > \Text\Caret
          Swap \Text\Caret[1], \Text\Caret
        ElseIf \Text\Caret > \Text\Caret[1] 
          Swap \Text\Caret, \Text\Caret[1]
        EndIf
        
        If \Index[1] <> \Index[2]
          SelReset(*This)
          \Index[1] = \Index[2]
          Repaint =- 1
        EndIf
      ElseIf \Text\Caret[1] > 0
        If \Text\Caret > \items()\text\len
          \Text\Caret = \items()\text\len
        EndIf
        \Text\Caret - 1 
      EndIf
      
      If \Text\Caret[1] <> \Text\Caret
        \Text\Caret[1] = \Text\Caret 
        Repaint =- 1 
      ElseIf Not Repaint And ToUp(*This.Widget_S)
        \Text\Caret = \Items()\Text\Len
        \Text\Caret[1] = \Text\Caret
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure ToRight(*This.Widget_S) ; Ok
    Protected Repaint
    
    With *This
      If \Items()\Text[2]\Len
        If \Index[1] > \Index[2] 
          Swap \Index[1], \Index[2] 
          Swap \Text\Caret, \Text\Caret[1]
          
          If SelectElement(\Items(), \Index[2]) 
            \Items()\Text[1]\String.s = Left(\Items()\Text\String.s, \Text\Caret[1]) 
            \Items()\Text[1]\Change = #True
          EndIf
        ElseIf \Index[2] = \Index[1] And 
               \Text\Caret > \Text\Caret[1] 
          Swap \Text\Caret, \Text\Caret[1]
        EndIf
        
        If \Index[1] <> \Index[2]
          SelReset(*This)
          \Index[1] = \Index[2]
          Repaint =- 1
        EndIf
      ElseIf \Text\Caret[1] < \Items()\Text\Len 
        \Text\Caret[1] + 1 
      EndIf
      
      If \Text\Caret <> \Text\Caret[1]
        \Text\Caret = \Text\Caret[1] 
        Repaint =- 1 
      ElseIf Not Repaint And ToDown(*This)
        \Text\Caret[1] = 0
        \Text\Caret = \Text\Caret[1]
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToInput(*This.Widget_S)
    Protected Repaint
    
    With *This
      If \Canvas\Input
        Repaint = Insert(*This, Chr(\Canvas\Input))
        
        If Not Repaint
          \Default = *This
        EndIf
        
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToReturn(*This.Widget_S) ; Ok
    Protected Repaint, String.s, Count=0, Chr.s = #LF$
    
    With  *This
      If \Index[1] <> \Index[2] ; Это значить строки выделени
        If \Index[2] > \Index[1] : Swap \Index[2], \Index[1] : EndIf
        
        ;           PushListPosition(\Items())
        If SelectElement(\Items(), \Index[2])
          String.s = Left(\Text\String.s, \Items()\Text\Pos) + \Items()\Text[1]\String.s + Chr.s
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          \Text\Caret = \Items()\Text[1]\Len 
        EndIf   
        
        If SelectElement(\Items(), \Index[1])
          String.s + \Items()\Text[3]\String.s + Right(\Text\String.s, \Text\Len-(\Items()\Text\Pos+\Items()\Text\Len))
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
        EndIf
        ;           PopListPosition(\Items())
        
        If Count
          \Index[2] + Count
        ElseIf Chr.s = #LF$ ; to return
          \Index[2] + 1
          \Text\Caret = 0
        EndIf
        
        \Text\Caret[1] = \Text\Caret
        \Index[1] = \Index[2]
        \Text\String.s = String.s
        \Text\Len = Len(\Text\String.s)
        \Text\Change =- 1 ; - 1 post event change widget
        Repaint = 1 
      ;;;  EndIf
      Else ;If Not Paste(*This, #LF$)
       \Text\String.s[2] = Left(\Text\String.s[2], \Items()\Text\Pos+\Text\Caret) + #CR$+#LF$ + Mid(\Text\String.s[2], \Items()\Text\Pos+\Text\Caret + 1) 
        
        \Index[2] + 1
        \Text\Caret = 0
        \Text\Caret[1] = \Text\Caret
        \Index[1] = \Index[2]
        \Text\String.s[2] = String.s
        \Text\Len = Len(String.s)
        \Text\Change =- 1 ; - 1 post event change widget
        
        \Text\String.s = ReplaceString(RemoveString(String.s, #LF$), #CR$, #LF$)
        Debug \Text\String.s
      EndIf
      
      Repaint = #True
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToBack(*This.Widget_S)
    Protected Repaint, String.s, Cut.i
    ;ProcedureReturn Text::ToReturn(*This,"")
    
    If *This\Canvas\Input : *This\Canvas\Input = 0
      ;  ToInput(*This) ; Сбросить Dot&Minus
    EndIf
    
    With *This 
      If Not Cut(*This)
        If \Items()\Text[2]\Len
          If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len
          \Items()\Text\Change = 1
          
          \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Text\Pos+\Text\Caret, 1)
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          \Text\Change =- 1 ; - 1 post event change widget
          
        ElseIf \Text\Caret[1] > 0 
          \Items()\Text\String.s = Left(\Items()\Text\String.s, \Text\Caret[1] - 1) + \Items()\Text[3]\String.s
          \Items()\Text\Len = Len(\Items()\Text\String.s)
          \Items()\Text\Change = 1
          
          
          \Text\String.s[2] = Left(\Text\String.s[2], (\Items()\Text\Pos+\Text\Caret) - 1) + Mid(\Text\String.s[2],  \Items()\Text\Pos + \Text\Caret + 1)
           \text[1]\change = 1
        
          \Text\Change =- 1 ; - 1 post event change widget
          \Text\Caret - 1 
        Change(*This, \Text\Caret,0)
          ;\Text\String.s[2] = \Text[1]\String.s + \Text[3]\String.s ;Left(\Text\String.s[2], (\Items()\Text\Pos+\Text\Caret) - 1) + Mid(\Text\String.s[2],  \Items()\Text\Pos + \Text\Caret)
          
          
        Else
          ; Если дошли до начала строки то 
          ; переходим в конец предыдущего итема
          If \Index[2] > 0 
            \Text\String.s[2] = RemoveString(\Text\String.s[2], #LF$, #PB_String_CaseSensitive, \Items()\Text\Pos+\Text\Caret, 1)
            
            ToUp(*This)
            
            \Text\Caret = \Items()\Text\Len - 1
            \Text\Change =- 1 ; - 1 post event change widget
          EndIf
          
        EndIf
      EndIf
      
      If \Text\Change
         \Text\String.s = ReplaceString(RemoveString(\Text\String.s[2], #LF$), #CR$, #LF$)
         \Text\Len = Len(\Text\String.s[2])  
         \Text\Caret[1] = \Text\Caret 
         ;;Debug \text[1]\string ; Mid(\Text\String.s, \Items()\Text\Pos+\Text\Caret) 
          Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i ToDelete(*This.Widget_S)
    Protected Repaint, String.s
    
    With *This 
      If Not Cut(*This)
        If \Items()\Text[2]\Len
          If \Text\Caret > \Text\Caret[1] : \Text\Caret = \Text\Caret[1] : EndIf
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = \Items()\Text[1]\Len + \Items()\Text[3]\Len
          \Items()\Text\Change = 1
          
          \Text\String.s = RemoveString(\Text\String.s, \Items()\Text[2]\String.s, #PB_String_CaseSensitive, \Items()\Text\Pos+\Text\Caret, 1)
          \Items()\Text[2]\Len = 0 : \Items()\Text[2]\String.s = "" : \Items()\Text[2]\change = 1
          \Text\Change =- 1 ; - 1 post event change widget
          
        ElseIf \Text\Caret[1] < \Items()\Text\Len
          \Items()\Text[3]\String.s = Right(\Items()\Text\String.s, \Items()\Text\Len - \Text\Caret - 1)
          
          \Items()\Text\String.s = \Items()\Text[1]\String.s + \Items()\Text[3]\String.s
          \Items()\Text\Len = Len(\Items()\Text\String.s)
          \Items()\Text\Change = 1
          
          \Text\String.s = Left(\Text\String.s, \Items()\Text\Pos+\Text\Caret) + Right(\Text\String.s,  \Text\Len - (\Items()\Text\Pos + \Text\Caret) - 1)
          \Text\Change =- 1 ; - 1 post event change widget
        Else
          If \Index[2] < (\Text\Count-1) ; ListSize(\items()) - 1
            \Text\String.s = RemoveString(\Text\String.s, #LF$, #PB_String_CaseSensitive, \Items()\Text\Pos+\Text\Caret, 1)
            \Text\Change =- 1 ; - 1 post event change widget
          EndIf
        EndIf
      EndIf
      
      If \Text\Change
        \Text\Len = Len(\Text\String.s)  
        \Text\Caret[1] = \Text\Caret 
        Repaint =- 1 
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  ;-
  Procedure.i Text_AddLine(*This.Widget_S, Line.i, Text.s)
    Protected Result.i, String.s, i.i
    
    With *This
      If (Line > \Text\Count Or Line < 0)
        Line = \Text\Count
      EndIf
      
      For i = 0 To \Text\Count
        If Line = i
          If String.s
            String.s +#LF$+ Text
          Else
            String.s + Text
          EndIf
        EndIf
        
        If String.s
          String.s +#LF$+ StringField(\Text\String.s, i + 1, #LF$) 
        Else
          String.s + StringField(\Text\String.s, i + 1, #LF$)
        EndIf
      Next : \Text\Count = i
      
      If \Text\String.s <> String.s
        \Text\String.s = String.s
        \Text\Len = Len(String.s)
        \Text\Change = 1
        Result = 1
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Text_memAddLine(*This.Widget_S, Line.i, Text.s)
    Protected Result.i, String.s, i.i
    
    With *This
      If (Line > \Text\Count Or Line < 0)
        Line = \Text\Count
      EndIf
      
      For i = 0 To \Text\Count
        If Line = i
          If String.s
            String.s +#LF$+ Text
          Else
            String.s + Text
          EndIf
        EndIf
        
        If String.s
          String.s +#LF$+ StringField(\Text\String.s, i + 1, #LF$) 
        Else
          String.s + StringField(\Text\String.s, i + 1, #LF$)
        EndIf
      Next : \Text\Count = i
      
      If \Text\String.s <> String.s
        \Text\String.s = String.s
        \Text\Len = Len(String.s)
        \Text\Change = 1
        Result = 1
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i Make(*This.Widget_S)
    Protected String1.s, String2.s, String3.s, Count.i
    
    With *This
      If ListSize(\Lines())
        \Text\Count = 0;CountString(\text\string, #LF$)
        
        ForEach \Lines()
          If \Lines()\Index =- 1 : \Text\Count + 1
            If String1.s
              String1.s +#LF$+ \Lines()\Text\String.s 
            Else
              String1.s + \Lines()\Text\String.s
            EndIf
          EndIf
        Next : String1.s + #LF$
        
        ForEach \Lines()
          If \Lines()\Index = \Text\Count
            If String2.s
              String2.s +#LF$+ \Lines()\Text\String.s 
            Else
              String2.s + \Lines()\Text\String.s
            EndIf
            DeleteElement(\Lines())
          EndIf
        Next : String2.s + #LF$
        
        ForEach \Lines()
          If \Lines()\Index > 0
            If String3.s
              String3.s +#LF$+ \Lines()\Text\String.s 
            Else
              String3.s + \Lines()\Text\String.s
            EndIf
          EndIf
        Next : String3.s + #LF$
         
        \Text\String.s = String1.s + String2.s + \Text\String.s + String3.s
        \Text\Count = CountString(\Text\string, #LF$)
        \Text\Len = Len(\Text\String.s)
        \Text\Change = 1
        
        ; ;         ForEach \Lines()
; ;         ;  Text_AddLine(*This,\Lines()\Index, \Lines()\Text\String.s)
; ;         Next 
        ClearList(\Lines())
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i AddItem(*This.Widget_S, Item.i,Text.s,Image.i=-1,Flag.i=0)
    Static Y
    Protected *Item
    
    If *This
      With *This
        CopyMemoryString(PeekS(@Text)+#LF$, @*Pointer) ; 3
        
        ;ProcedureReturn 
        ;{ Генерируем идентификатор
        If Item < 0 Or Item > ListSize(\Lines()) - 1
          LastElement(\Lines())
          *Item = AddElement(\Lines()) 
        Else
          SelectElement(\Lines(), Item)
          *Item = InsertElement(\Lines())
        EndIf
        ;}
        
        If *Item
          \Lines()\Index = Item ; ListIndex(\Lines())
          \Lines()\Text\String.s = Text.s
          
          
          If ListIndex(\Lines()) = 0
            If StartDrawing(CanvasOutput(\Canvas\Gadget))
              If \Text\FontID : DrawingFont(\Text\FontID) : EndIf
              \Text\Height[1] = TextHeight("A") + Bool(\Text\Count<>1 And \Flag\GridLines)
              \Text\Height = \Text\Height[1]
              StopDrawing()
            EndIf
          EndIf
          
          ;{ Генерируем идентификатор
            If Item < 0 Or Item > ListSize(\Items()) - 1
              LastElement(\Items())
              *Item = AddElement(\Items()) 
              Item = ListIndex(\Items())
            Else
              SelectElement(\Items(), Item)
              *Item = InsertElement(\Items())
            EndIf
            ;}
            
            
            Text::AddLine(*This, Item.i, Text.s)
            
            If Bool(Y>=0 And Y=<\height)
            
            
;             ;\Text\Change = 1 ; надо посмотрет почему надо его вызивать раньше вед не нужно было
;             ;Debug ""+\Height +" "+ y
;             
;             If Not \Repaint : \Repaint = 1
             ; PostEvent(#PB_Event_Gadget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_Repaint)
;             EndIf
            ;Text::ReDraw(*This)
          EndIf
          
        ;  \Scroll\Height = Y
          Y + \Text\Height[1]
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn *Item
  EndProcedure
  
  Procedure SetAttribute(*This.Widget_S, Attribute.i, Value.i)
    With *This
      
    EndWith
  EndProcedure
  
  Procedure GetAttribute(*This.Widget_S, Attribute.i)
    Protected Result
    
    With *This
      ;       Select Attribute
      ;         Case #PB_ScrollBar_Minimum    : Result = \Scroll\min
      ;         Case #PB_ScrollBar_Maximum    : Result = \Scroll\max
      ;         Case #PB_ScrollBar_PageLength : Result = \Scroll\pageLength
      ;       EndSelect
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetItemState(*This.Widget_S, Item.i, State.i)
    Protected Result
    
    With *This
      PushListPosition(\Items())
      Result = SelectElement(\Items(), Item) 
      If Result 
        \Items()\Index[1] = \Items()\Index
        \Text\Caret = State
        \Text\Caret[1] = \Text\Caret
      EndIf
      PopListPosition(\Items())
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetState(*This.Widget_S, State.i)
    Protected String.s
    
    With *This
      PushListPosition(\Items())
      ForEach \Items()
        If String.s
          String.s +#LF$+ \Items()\Text\String.s 
        Else
          String.s + \Items()\Text\String.s
        EndIf
      Next : String.s+#LF$
      PopListPosition(\Items())
      
      If \Text\String.s <> String.s
        \Text\String.s = String.s
        \Text\Len = Len(String.s)
        Debug 4444
        Text::Redraw(*This, \Canvas\Gadget)
      EndIf
      
      If State <> #PB_Ignore
        \Focus = *This
        If GetActiveGadget() <> \Canvas\Gadget
          SetActiveGadget(\Canvas\Gadget)
        EndIf
        
        If State =- 1
          \Index[1] = \Text\Count - 1
          LastElement(\Items())
          \Text\Caret = \Items()\Text\Len
        Else
          \Index[1] = CountString(Left(String, State), #LF$)
          SelectElement(\Items(), \Index[1])
          \Text\Caret = State-\Items()\Text\Pos
        EndIf
        
        \Items()\Text[1]\String = Left(\Items()\Text\String, \Text\Caret)
        \Items()\Text[1]\Change = 1
        \Text\Caret[1] = \Text\Caret
        
        \Items()\Index[1] = \Items()\Index 
        ;PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint)
        Scroll::SetState(\Scroll\v, ((\Index[1] * \Text\Height)-\Scroll\v\Height) + \Text\Height) : \Scroll\Y =- \Scroll\v\page\Pos
      EndIf
    EndWith
  EndProcedure
  
  Procedure GetState(*This.Widget_S)
    Protected Result
    
    With *This
      PushListPosition(\Items())
      ForEach \Items()
        If \Items()\Index[1] = \Items()\Index
          Result = \Items()\Text\Pos + \Text\Caret
        EndIf
      Next
      PopListPosition(\Items())
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure ClearItems(*This.Widget_S)
    Text::ClearItems(*This)
    ProcedureReturn 1
  EndProcedure
  
  Procedure.i CountItems(*This.Widget_S)
    ProcedureReturn Text::CountItems(*This)
  EndProcedure
  
  Procedure.i RemoveItem(*This.Widget_S, Item.i)
    Text::RemoveItem(*This, Item)
  EndProcedure
  
  Procedure.s GetText(*This.Widget_S)
    ProcedureReturn Text::GetText(*This)
  EndProcedure
  
  Procedure.i SetText(*This.Widget_S, Text.s, Item.i=0)
    Protected Result.i, Len.i, String.s, i.i
    If Text.s="" : Text.s=#LF$ : EndIf
    
    With *This
      If \Text\String.s <> Text.s
        \Text\String.s = Text::Make(*This, Text.s)
        
        If \Text\String.s
          \Text\String.s[1] = Text.s
          
          If \Text\MultiLine Or \Type = #PB_GadgetType_Editor Or \Type = #PB_GadgetType_Scintilla  ; Or \Type = #PB_GadgetType_ListView
            Text.s = ReplaceString(Text.s, #LFCR$, #LF$)
            Text.s = ReplaceString(Text.s, #CRLF$, #LF$)
            Text.s = ReplaceString(Text.s, #CR$, #LF$)
            Text.s + #LF$
            \Text\String.s = Text.s
          Else
            \Text\String.s = RemoveString(\Text\String.s, #LF$) + #LF$
          EndIf
          
;           \Text\Len = Len(\Text\String.s)
           \Text\Change = #True
          Text::ReDraw(*This, *This\Canvas\Gadget)
          Result = #True
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure.i SetFont(*This.Widget_S, FontID.i)
    
    If Text::SetFont(*This, FontID)
      Text::ReDraw(*This, *This\Canvas\Gadget)
      ProcedureReturn 1
    EndIf
    
  EndProcedure
  
  ;-
  Procedure.i Editable(*This.Widget_S, EventType.i)
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s
    
    With *This
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
        Control = Bool((\Canvas\Key[1] & #PB_Canvas_Control) Or (\Canvas\Key[1] & #PB_Canvas_Command))  ; Bool(*This\Canvas\Key[1] & #PB_Canvas_Command)
      CompilerElse
        Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Control)
      CompilerEndIf
      
      Select EventType
        Case #PB_EventType_Input ;- Input (key)
          If Not Control
            Repaint = ToInput(*This)
          EndIf
          
        Case #PB_EventType_KeyUp
          If \items()\Text\Numeric
            \items()\Text\String.s[1]=\items()\Text\String.s 
          EndIf
          Repaint = #True 
          
        Case #PB_EventType_KeyDown
          Select \Canvas\Key
            Case #PB_Shortcut_Home : \items()\Text[2]\String.s = "" : \items()\Text[2]\Len = 0 : \Text\Caret = 0 : \Text\Caret[1] = \Text\Caret : Repaint =- 1
            Case #PB_Shortcut_End : \items()\Text[2]\String.s = "" : \items()\Text[2]\Len = 0 : \Text\Caret = \items()\Text\Len : \Text\Caret[1] = \Text\Caret : Repaint =- 1 
              
            Case #PB_Shortcut_Up     : Repaint = ToUp(*This)      ; Ok
            Case #PB_Shortcut_Left   : Repaint = ToLeft(*This)    ; Ok
            Case #PB_Shortcut_Right  : Repaint = ToRight(*This)   ; Ok
            Case #PB_Shortcut_Down   : Repaint = ToDown(*This)    ; Ok
            Case #PB_Shortcut_Back   : Repaint = ToBack(*This)
            Case #PB_Shortcut_Return : Repaint = ToReturn(*This) 
            Case #PB_Shortcut_Delete : Repaint = ToDelete(*This)
              
            Case #PB_Shortcut_C, #PB_Shortcut_X
              If Control
                SetClipboardText(\Text[2]\String)
                
                If \Canvas\Key = #PB_Shortcut_X
                  Repaint = Cut(*This)
                EndIf
              EndIf
              
            Case #PB_Shortcut_V
              If \Text\Editable And Control
                Repaint = Insert(*This, GetClipboardText())
              EndIf
              
          EndSelect 
          
      EndSelect
      
      If Repaint
        ;\Text[3]\Change = Bool(Repaint =- 1)
        If Repaint =- 1
          SelectionText(*This) 
        EndIf
        
        If Repaint = 2
          \Text[0]\Change = Repaint
          \items()\Text[1]\Change = Repaint
          \items()\Text[2]\Change = Repaint
          \items()\Text[3]\Change = Repaint
        EndIf
        ; *This\Text\CaretLength = \Text\CaretLength
        \Text[2]\String.s[1] = \items()\Text[2]\String.s[1]
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i _Events(*This.Widget_S, EventType.i)
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s
    
    With *This
      Repaint | Scroll::CallBack(\Scroll\v, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y)
      Repaint | Scroll::CallBack(\Scroll\h, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y)
    EndWith
    
    If *This And (Not *This\Scroll\v\at And Not *This\Scroll\h\at)
      If ListSize(*This\items())
        With *This
          If Not \Hide And Not \Disable And \Interact
            CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Command)
            CompilerElse
              Control = Bool(*This\Canvas\Key[1] & #PB_Canvas_Control)
            CompilerEndIf
            
            Select EventType 
              Case #PB_EventType_LeftClick : PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_LeftClick)
              Case #PB_EventType_RightClick : PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_RightClick)
              Case #PB_EventType_LeftDoubleClick : PostEvent(#PB_Event_Widget, \Canvas\Window, \Canvas\Gadget, #PB_EventType_LeftDoubleClick)
                
              Case #PB_EventType_MouseLeave
                \index[1] =- 1
                Repaint = 1
                
              Case #PB_EventType_LeftButtonDown
                PushListPosition(\items()) 
                ForEach \items()
                  If \index[1] = \items()\index 
                    \Index[2] = \index[1]
                    
                    If \Flag\ClickSelect
                      \items()\Color\State ! 2
                    Else
                      \items()\Color\State = 2
                    EndIf
                    
                    ; \items()\Focus = \items()\index 
                  ElseIf ((Not \Flag\ClickSelect And \items()\Focus = \items()\index) Or \Flag\MultiSelect) And Not Control
                    \items()\index[1] =- 1
                    \items()\Color\State = 1
                    \items()\Focus =- 1
                  EndIf
                Next
                PopListPosition(\items()) 
                Repaint = 1
                
              Case #PB_EventType_LeftButtonUp
                PushListPosition(\items()) 
                ForEach \items()
                  If \index[1] = \items()\index 
                    \items()\Focus = \items()\index 
                  Else
                    If (Not \Flag\MultiSelect And Not \Flag\ClickSelect)
                      \items()\Color\State = 1
                    EndIf
                  EndIf
                Next
                PopListPosition(\items()) 
                Repaint = 1
                
              Case #PB_EventType_MouseMove  
                If \Canvas\Mouse\Y < \Y Or \Canvas\Mouse\X > Scroll::X(\Scroll\v)
                  Item.i =- 1
                ElseIf \Text\Height
                  Item.i = ((\Canvas\Mouse\Y-\Y-\Text\Y-\Scroll\Y) / \Text\Height)
                EndIf
                
                If \index[1] <> Item And Item =< ListSize(\items())
                  If isItem(\index[1], \items()) 
                    If \index[1] <> ListIndex(\items())
                      SelectElement(\items(), \index[1]) 
                    EndIf
                    
                    If \Canvas\Mouse\buttons & #PB_Canvas_LeftButton 
                      If (\Flag\MultiSelect And Not Control)
                        \items()\Color\State = 2
                      ElseIf Not \Flag\ClickSelect
                        \items()\Color\State = 1
                      EndIf
                    EndIf
                  EndIf
                  
                  If \Canvas\Mouse\buttons & #PB_Canvas_LeftButton And itemSelect(Item, \items())
                    If (Not \Flag\MultiSelect And Not \Flag\ClickSelect)
                      \items()\Color\State = 2
                    ElseIf Not \Flag\ClickSelect And (\Flag\MultiSelect And Not Control)
                      \items()\index[1] = \items()\index
                      \items()\Color\State = 2
                    EndIf
                  EndIf
                  
                  \index[1] = Item
                  Repaint = #True
                  
                  If \Canvas\Mouse\buttons & #PB_Canvas_LeftButton
                    If (\Flag\MultiSelect And Not Control)
                      PushListPosition(\items()) 
                      ForEach \items()
                        If  Not \items()\Hide
                          If ((\Index[2] =< \index[1] And \Index[2] =< \items()\index And \index[1] >= \items()\index) Or
                              (\Index[2] >= \index[1] And \Index[2] >= \items()\index And \index[1] =< \items()\index)) 
                            If \items()\index[1] <> \items()\index
                              \items()\index[1] = \items()\index
                              \items()\Color\State = 2
                            EndIf
                          Else
                            \items()\index[1] =- 1
                            \items()\Color\State = 1
                            \items()\Focus =- 1
                          EndIf
                        EndIf
                      Next
                      PopListPosition(\items()) 
                    EndIf
                    
                  EndIf
                EndIf
                
              Default
                itemSelect(\Index[2], \items())
            EndSelect
          EndIf
        EndWith    
        
        With *This\items()
          If *Focus = *This
            Repaint | Editable(*This.Widget_S, EventType.i)
          EndIf
        EndWith
      EndIf
    Else
      *This\index[1] =- 1
    EndIf
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i Events(*This.Widget_S, EventType.i)
    Static DoubleClick.i
    Protected Repaint.i, Control.i, Caret.i, Item.i, String.s
    
    With *This
      Repaint | Scroll::CallBack(\Scroll\v, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y)
      Repaint | Scroll::CallBack(\Scroll\h, EventType, \Canvas\Mouse\X, \Canvas\Mouse\Y)
      
      If *This And (Not *This\Scroll\v\at And Not *This\Scroll\h\at)
        If ListSize(*This\items())
          If Not \Hide And Not \Disable And \Interact
            ; Get line & caret position
            If \Canvas\Mouse\buttons
              If \Canvas\Mouse\Y < \Y
                Item.i =- 1
              Else
                Item.i = ((\Canvas\Mouse\Y-\Y-\Text\Y-\Scroll\Y) / \Text\Height)
              EndIf
            EndIf
            
            Select EventType 
              Case #PB_EventType_LeftButtonDown
                Text::SelReset(*This)
                
                If \Items()\Text[2]\Len > 0
                  \Text[2]\Len = 1
                Else
                  \Text\Caret = Caret(*This, Item) 
                  \Index[1] = ListIndex(*This\Items()) 
                  \Index[2] = Item
                  
                  PushListPosition(\Items())
                  ForEach \Items() 
                    If \Index[2] <> ListIndex(\Items())
                      \Items()\Text[1]\String = ""
                      \Items()\Text[2]\String = ""
                      \Items()\Text[3]\String = ""
                    EndIf
                  Next
                  PopListPosition(\Items())
                  
                  \Text\Caret[1] = \Text\Caret
                  
                  If \Text\Caret = DoubleClick
                    DoubleClick =- 1
                    \Text\Caret[1] = \Items()\Text\Len
                    \Text\Caret = 0
                  EndIf 
                  
                  SelectionText(*This)
                  Repaint = #True
                  
                  
                EndIf
                
              Case #PB_EventType_MouseMove  
                If \Canvas\Mouse\buttons & #PB_Canvas_LeftButton 
                  
                  If \Index[1] <> Item And Item =< ListSize(\Items())
                    If isItem(\Index[1], \Items()) 
                      If \Index[1] <> ListIndex(\Items())
                        SelectElement(\Items(), \Index[1]) 
                      EndIf
                      
                      If \Index[1] > Item
                        \Text\Caret = 0
                      Else
                        \Text\Caret = \Items()\Text\Len
                      EndIf
                      
                      SelectionText(*This)
                    EndIf
                    
                    \Index[1] = Item
                  EndIf
                  
                  If isItem(Item, \Items()) 
                    \Text\Caret = Caret(*This, Item) 
                    SelectionText(*This)
                  EndIf
                  
                  Repaint = #True
                  
                  Protected SelectionLen
                  PushListPosition(\Items()) 
                  ForEach \Items()
                    If \Index[1] = \Items()\Index Or \Index[2] = \Items()\Index
                      
                    ElseIf ((\Index[2] < \Index[1] And \Index[2] < \Items()\Index And \Index[1] > \Items()\Index) Or
                            (\Index[2] > \Index[1] And \Index[2] > \Items()\Index And \Index[1] < \Items()\Index)) 
                      
                      If \Items()\Text[2]\String <> \Items()\Text\String
                        \Items()\Text[2]\Len = \Items()\Text\Len
                        If Not \Items()\Text\Len : \Items()\Text[2]\Len = 1 : EndIf
                        \Items()\Text[1]\String = "" : \Items()\Text[1]\Len = 0 : \Items()\Text[1]\Change = 1
                        \Items()\Text[3]\String = "" : \Items()\Text[3]\Len = 0 : \Items()\Text[3]\Change = 1
                        \Items()\Text[2]\String = \Items()\Text\String : \Items()\Text[2]\Change = 1
                      EndIf
                      
                      SelectionLen=Bool(Not \Flag\FullSelection)*7
                      ; \Items()\Text[2]\X = 0;\Items()\Text\X+\Items()\Text\Width
                      
                      If Not SelectionLen
                        \Items()\Text[2]\Width[2] = \Items()\Width-\Items()\Text\Width
                      Else
                        \Items()\Text[2]\Width[2] = SelectionLen
                      EndIf
                      
                      ;\Items()\Index[1] = \Items()\Index
                    Else  
                      ;\Items()\Index[1] =- 1
                      \Items()\Text[2]\String =  "" : \Items()\Text[2]\Len = 0 : \Items()\Text[2]\Change = 1
                    EndIf
                  Next
                  PopListPosition(\Items()) 
                  
                  CompilerIf Defined(Scroll, #PB_Module)
                    If \Canvas\Mouse\Y > \Height[2]
                      ;                       If \Scroll\v And \Scroll\v\max <> \Scroll\Height And 
                      ;                          Scroll::SetAttribute(\Scroll\v, #PB_ScrollBar_Maximum, \Scroll\Height - Bool(\Flag\GridLines))
                      Scroll::SetState(\Scroll\v, (\items()\y-(Scroll::Y(\Scroll\h)-\items()\height)))
                      ;                         Scroll::Resizes(\Scroll, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                      ;                       EndIf
                    EndIf
                  CompilerEndIf
                EndIf
                
              Default
                itemSelect(\Index[2], \Items())
            EndSelect
          EndIf
          
          ; edit events
          If *Focus = *This And (*This\Text\Editable Or \Text\Editable)
            Repaint | Editable(*This, EventType)
          EndIf
        EndIf
      EndIf
    EndWith
    
    ProcedureReturn Repaint
  EndProcedure
  
  Procedure.i CallBack(*This.Widget_S, EventType.i, Canvas.i=-1, CanvasModifiers.i=-1)
    ProcedureReturn Text::CallBack(@Events(), *This, EventType, Canvas, CanvasModifiers)
  EndProcedure
  
;   Procedure Widget_CallBack()
;     Protected String.s, *This.Widget_S = EventGadget()
;     
;     With *This
;       Select EventType() 
;         Case #PB_EventType_Create
;          ; SetState(*This, #PB_Ignore)
;          Debug \text\len   
;       EndSelect
;     EndWith
;   EndProcedure
  
  Procedure.i Widget(*This.Widget_S, Canvas.i, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    If *This
      With *This
        \Type = #PB_GadgetType_Editor
        \Cursor = #PB_Cursor_IBeam
        ;\DrawingMode = #PB_2DDrawing_Default
        \Canvas\Gadget = Canvas
        If Not \Canvas\Window
          \Canvas\Window = GetGadgetData(Canvas)
        EndIf
        \Radius = Radius
        \color\alpha = 255
        \Interact = 1
        \Text\Caret[1] =- 1
        \Index[1] =- 1
        \X =- 1
        \Y =- 1
        
        ; Set the Default widget flag
        If Bool(Flag&#PB_Text_WordWrap)
          Flag&~#PB_Text_MultiLine
        EndIf
        
        If Bool(Flag&#PB_Text_MultiLine)
          Flag&~#PB_Text_WordWrap
        EndIf
        
        If Not \Text\FontID
          \Text\FontID = GetGadgetFont(#PB_Default) ; Bug in Mac os
        EndIf
        
        \fSize = Bool(Not Flag&#PB_Flag_BorderLess)+1
        \bSize = \fSize
        
        \flag\buttons = Bool(flag&#PB_Flag_NoButtons)
        \Flag\Lines = Bool(flag&#PB_Flag_NoLines)
        \Flag\FullSelection = Bool(flag&#PB_Flag_FullSelection)*7
        \Flag\AlwaysSelection = Bool(flag&#PB_Flag_AlwaysSelection)
        \Flag\CheckBoxes = Bool(flag&#PB_Flag_CheckBoxes)*12 ; Это еще будет размер чек бокса
        \Flag\GridLines = Bool(flag&#PB_Flag_GridLines)
        
        \Text\Vertical = Bool(Flag&#PB_Flag_Vertical)
        \Text\Editable = Bool(Not Flag&#PB_Text_ReadOnly)
        
        If Bool(Flag&#PB_Text_WordWrap)
          \Text\MultiLine = 1
        ElseIf Bool(Flag&#PB_Text_MultiLine)
          \Text\MultiLine = 2
        Else
          \Text\MultiLine =- 1
        EndIf
        
        \Flag\MultiSelect = 1
        \Text\Numeric = Bool(Flag&#PB_Text_Numeric)
        \Text\Lower = Bool(Flag&#PB_Text_LowerCase)
        \Text\Upper = Bool(Flag&#PB_Text_UpperCase)
        \Text\Pass = Bool(Flag&#PB_Text_Password)
        
        \Text\Align\Horizontal = Bool(Flag&#PB_Text_Center)
        \Text\Align\Vertical = Bool(Flag&#PB_Text_Middle)
        \Text\Align\Right = Bool(Flag&#PB_Text_Right)
        \Text\Align\Bottom = Bool(Flag&#PB_Text_Bottom)
        
        If \Text\Vertical
          \Text\X = \fSize 
          \Text\y = \fSize+3
        Else
          \Text\X = \fSize+2
          \Text\y = \fSize
        EndIf
        
        
        \Color = Colors
        \Color\Fore[0] = 0
        
        \Row\color\alpha = 255
        \Row\Color = Colors
        \Row\Color\Fore[0] = 0
        \Row\Color\Fore[1] = 0
        \Row\Color\Fore[2] = 0
        \Row\Color\Back[0] = \Row\Color\Back[1]
        \Row\Color\Frame[0] = \Row\Color\Frame[1]
        ;\Color\Back[1] = \Color\Back[0]
        
        If \Text\Editable
          \Color\Back[0] = $FFFFFFFF 
        Else
          \Color\Back[0] = $FFF0F0F0  
        EndIf
        
      EndIf
      
      ; create scrollbars
      Scroll::Bars(\Scroll, 16, 7, Bool(\Text\MultiLine <> 1))
      
      Resize(*This, X,Y,Width,Height)
    EndWith
    
    ProcedureReturn *This
  EndProcedure
  
  Procedure.i Create(Canvas.i, Widget, X.i, Y.i, Width.i, Height.i, Text.s, Flag.i=0, Radius.i=0)
    Protected *Widget, *This.Widget_S = AllocateStructure(Widget_S)
    
    If *This
      add_widget(Widget, *Widget)
      
      *This\Index = Widget
      *This\Handle = *Widget
      List()\Widget = *This
      
      Widget(*This, Canvas, x, y, Width, Height, Text.s, Flag, Radius)
      ;PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_Create)
      PostEvent(#PB_Event_Gadget, *This\Canvas\Window, *This\Canvas\Gadget, #PB_EventType_Repaint)
      ;BindEvent(#PB_Event_Widget, @Widget_CallBack(), *This\Canvas\Window, *This, #PB_EventType_Create)
    EndIf
    
    ProcedureReturn *This
  EndProcedure
  
  
  Procedure Canvas_CallBack()
    Protected Repaint, String.s, *This.Widget_S = GetGadgetData(EventGadget())
    
    With *This
      Select EventType()
        Case #PB_EventType_Repaint 
          
         ; If *This\Repaint ;: *This\Repaint = 0
            
            Repaint = 1
            
         ; EndIf
          
        Case #PB_EventType_Resize : ResizeGadget(\Canvas\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore) ; Bug (562)
          Repaint | Resize(*This, #PB_Ignore, #PB_Ignore, GadgetWidth(\Canvas\Gadget), GadgetHeight(\Canvas\Gadget))
;           Debug PeekS(*Buffer)
;           \Text\String.s = PeekS(*Buffer)
;           \Text\Change = 1
;           
;           If ListSize(\Lines())
;          ;   Editor::Make(*This)
;           EndIf
          
      EndSelect
      
      Repaint | CallBack(*This, EventType())
      
      If Repaint 
;         If ListSize(\Lines())
;           Editor::Make(*This)
;         EndIf
        
       Text::ReDraw(*This)
      EndIf
      
    EndWith
  EndProcedure
  
  Procedure.i Gadget(Gadget.i, X.i, Y.i, Width.i, Height.i, Flag.i=0)
    Protected *This.Widget_S = AllocateStructure(Widget_S)
    Protected g = CanvasGadget(Gadget, X, Y, Width, Height, #PB_Canvas_Keyboard) : If Gadget=-1 : Gadget=g : EndIf
    
    If *This
      With *This
        Widget(*This, Gadget, 0, 0, Width, Height, "", Flag)
;         PostEvent(#PB_Event_Widget, *This\Canvas\Window, *This, #PB_EventType_Create)
;         BindEvent(#PB_Event_Widget, @Widget_CallBack(), *This\Canvas\Window, *This, #PB_EventType_Create)
        
        SetGadgetData(Gadget, *This)
        BindGadgetEvent(Gadget, @Canvas_CallBack())
      EndWith
    EndIf
    
    ProcedureReturn g
  EndProcedure
  
EndModule


;- EXAMPLE
CompilerIf #PB_Compiler_IsMainFile
  
  Define a,i
  Define g, Text.s
  ; Define m.s=#CRLF$
  Define m.s=#LF$
  
  Text.s = "This is a long line." + m.s +
           "Who should show." + m.s +
           "I have to write the text in the box or not." + m.s +
           "The string must be very long." + m.s +
           "Otherwise it will not work." ;+ m.s +
;            m.s +
;            "Schol is a beautiful thing." + m.s +
;            "You ned it, that's true." + m.s +
;            "There was a group of monkeys siting on a fallen tree."
  ; Text.s = "This is a long line. Who should show, i have to write the text in the box or not. The string must be very long. Otherwise it will not work."
        
  Procedure SplitterCallBack()
    PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
  EndProcedure
  
  Procedure ResizeCallBack()
    ResizeGadget(100, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-127, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-30, #PB_Ignore, #PB_Ignore)
    ResizeGadget(10, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-135, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16)
    
    CompilerIf #PB_Compiler_Version =< 546 : SplitterCallBack() : CompilerEndIf
  EndProcedure
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
    LoadFont(0, "Arial", 16)
  CompilerElse
    LoadFont(0, "Arial", 11)
  CompilerEndIf 
  
  If OpenWindow(0, 0, 0, 422, 491, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    ButtonGadget(100, 490-60,490-30,125,25,"~wrap")
    
    EditorGadget(0, 8, 8, 306, 233, #PB_Editor_WordWrap) : SetGadgetText(0, Text.s) 
    Define time = ElapsedMilliseconds()
    For a = 0 To 2
      AddGadgetItem(0, a, "Line "+Str(a))
      If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
      EndIf
      If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
        Debug a
      EndIf
    Next
    Debug Str(ElapsedMilliseconds()-time) + " - add gadget items time count - " + CountGadgetItems(0)
    
    AddGadgetItem(0, a, "")
    For a = 4 To 6
      AddGadgetItem(0, -1, "Line "+Str(a))
    Next
    ;SetGadgetFont(0, FontID(0))
    ;SetGadgetState(0, 9)
    
    g=16
    Editor::Gadget(g, 8, 133+5+8, 306, 233, #PB_Text_WordWrap|#PB_Flag_GridLines);|#PB_Text_Right) #PB_Flag_FullSelection|
    *w.Widget_S=GetGadgetData(g)
    
    Editor::SetText(*w, Text.s) : Len = Len(text) : Count = CountString(Text, #LF$)
;     Debug Len
;     Debug Len(*w\text\string)
      
    Define time = ElapsedMilliseconds()
    For a = 0 To 2
      Count + 1
      Len + Len("Line "+Str(a)+#LF$)
      Editor::AddItem(*w, -1, "Line "+Str(a))
      If A & $f=$f:WindowEvent() ; это нужно чтобы раздет немного обновлялся
      EndIf
      If A & $8ff=$8ff:WindowEvent() ; это позволяет показывать скоко циклов пройшло
        Debug a
      EndIf
    Next
    Debug Str(ElapsedMilliseconds()-time) + " - add widget items time count - " + Editor::CountItems(*w)
     
    Editor::AddItem(*w, a, "") : Count + 1 : Len + Len(#LF$)
    
    For a = 4 To 6
      Count + 1
      Len + Len("Line "+Str(a)+#LF$)
      Editor::AddItem(*w, a, "Line "+Str(a))
    Next
    
    ;Editor::SetFont(*w, FontID(0))
    ;editor::SetState(*w, -1) ; 119) ; set caret pos    
   
;    Debug 555
;    editor::SetState(*w, #PB_Ignore) ; 119) ; set caret pos    
    
;     Define time = ElapsedMilliseconds()
     Editor::Make(*w)
;     Debug Str(ElapsedMilliseconds()-time) + " - add widget items time count - " + Editor::CountItems(*w)
 ;   Editor::Update(*w)
 ;   Text::Redraw(*w)
  
;     Debug *w\text\string
;     
;     Debug " "+Len
;     Debug "  "+*w\text\Len
;     Debug "   "+Len(*w\text\string)
;     
;     Debug " "+Count
;     Debug "  "+*w\text\Count
;     Debug "   "+CountString(*w\text\string, #LF$)
    
    SplitterGadget(10,8, 8, 250, 491-16, 0,g)
    CompilerIf #PB_Compiler_Version =< 546
      BindGadgetEvent(10, @SplitterCallBack())
    CompilerEndIf
    PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug no linux
    BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
    
    ;Debug ""+GadgetHeight(0) +" "+ GadgetHeight(g)
    Repeat 
      Define Event = WaitWindowEvent()
      
      Select Event
        Case #PB_Event_Gadget
          If EventGadget() = 100
            Select EventType()
              Case #PB_EventType_LeftClick
                Define *E.Widget_S = GetGadgetData(g)
                
                Editor::RemoveItem(g, 5)
                RemoveGadgetItem(0,5)
                
            EndSelect
          EndIf
          
        Case #PB_Event_LeftClick  
          SetActiveGadget(0)
        Case #PB_Event_RightClick 
          SetActiveGadget(10)
      EndSelect
    Until Event = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -------------------0f-f----------------------------
; EnableXP
; ; ; ;- EXAMPLE
; ; ; CompilerIf #PB_Compiler_IsMainFile
; ; ;   
; ; ;   Define a,i
; ; ;   Define g, Text.s
; ; ;   ; Define m.s=#CRLF$
; ; ;   Define m.s=#LF$
; ; ;   
; ; ;   Text.s = "This is a long line." + m.s +
; ; ;            "Who should show." + m.s +
; ; ;            "I have to write the text in the box or not." + m.s +
; ; ;            "The string must be very long." + m.s +
; ; ;            "Otherwise it will not work." + m.s +
; ; ;            m.s +
; ; ;            "Schol is a beautiful thing." + m.s +
; ; ;            "You ned it, that's true." + m.s +
; ; ;            "There was a group of monkeys siting on a fallen tree."
; ; ;         
; ; ;   Procedure ResizeCallBack()
; ; ;     ResizeGadget(100, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-62, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-30, #PB_Ignore, #PB_Ignore)
; ; ;     ResizeGadget(10, #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow(), #PB_Window_InnerCoordinate)-65, WindowHeight(EventWindow(), #PB_Window_InnerCoordinate)-16)
; ; ;     CompilerIf #PB_Compiler_Version =< 546
; ; ;       PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
; ; ;     CompilerEndIf
; ; ;   EndProcedure
; ; ;   
; ; ;   Procedure SplitterCallBack()
; ; ;     PostEvent(#PB_Event_Gadget, EventWindow(), 16, #PB_EventType_Resize)
; ; ;   EndProcedure
; ; ;   
; ; ;   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
; ; ;     LoadFont(0, "Arial", 16)
; ; ;   CompilerElse
; ; ;     LoadFont(0, "Arial", 11)
; ; ;   CompilerEndIf 
; ; ;   
; ; ;   If OpenWindow(0, 0, 0, 422, 491, "EditorGadget", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
; ; ;     ButtonGadget(100, 490-60,490-30,67,25,"~wrap")
; ; ;     
; ; ;     EditorGadget(0, 8, 8, 306, 233, #PB_Editor_WordWrap) : SetGadgetText(0, Text.s) 
; ; ;     For a = 0 To 2
; ; ;       AddGadgetItem(0, a, "Line "+Str(a))
; ; ;     Next
; ; ;     AddGadgetItem(0, a, "")
; ; ;     For a = 4 To 6
; ; ;       AddGadgetItem(0, a, "Line "+Str(a))
; ; ;     Next
; ; ;     SetGadgetFont(0, FontID(0))
; ; ;     
; ; ;     
; ; ;     g=16
; ; ;     Editor::Gadget(g, 8, 133+5+8, 306, 233, #PB_Text_WordWrap|#PB_Flag_GridLines);|#PB_Text_Right) #PB_Flag_FullSelection|
; ; ;     *w.Widget_S=GetGadgetData(g)
; ; ;     
; ; ;     Editor::SetText(*w, Text.s) 
; ; ;     
; ; ; ;     ;*w\text\count = CountString(*w\text\string)
; ; ; ;     *w\text\change = 1
; ; ; ;     Debug *w\text\string
; ; ;     
; ; ;     For a = 0 To 2
; ; ;       Editor::AddItem(*w, a, "Line "+Str(a))
; ; ;     Next
; ; ;     Editor::AddItem(*w, a, "")
; ; ;     For a = 4 To 6
; ; ;       Editor::AddItem(*w, a, "Line "+Str(a))
; ; ;     Next
; ; ;     Editor::SetFont(*w, FontID(0))
; ; ;     
; ; ;     
; ; ;     SplitterGadget(10,8, 8, 306, 491-16, 0,g)
; ; ;     CompilerIf #PB_Compiler_Version =< 546
; ; ;       BindGadgetEvent(10, @SplitterCallBack())
; ; ;     CompilerEndIf
; ; ;     PostEvent(#PB_Event_SizeWindow, 0, #PB_Ignore) ; Bug no linux
; ; ;     BindEvent(#PB_Event_SizeWindow, @ResizeCallBack(), 0)
; ; ;     
; ; ;     ;Debug ""+GadgetHeight(0) +" "+ GadgetHeight(g)
; ; ;     Repeat 
; ; ;       Define Event = WaitWindowEvent()
; ; ;       
; ; ;       Select Event
; ; ;         Case #PB_Event_Gadget
; ; ;           If EventGadget() = 100
; ; ;             Select EventType()
; ; ;               Case #PB_EventType_LeftClick
; ; ;                 Define *E.Widget_S = GetGadgetData(g)
; ; ;                 
; ; ;                 Editor::RemoveItem(g, 5)
; ; ;                 RemoveGadgetItem(0,5)
; ; ;                 
; ; ;             EndSelect
; ; ;           EndIf
; ; ;           
; ; ;         Case #PB_Event_LeftClick  
; ; ;           SetActiveGadget(0)
; ; ;         Case #PB_Event_RightClick 
; ; ;           SetActiveGadget(10)
; ; ;       EndSelect
; ; ;     Until Event = #PB_Event_CloseWindow
; ; ;   EndIf
; ; ; CompilerEndIf
; ; ; ; IDE Options = PureBasic 5.62 (MacOS X - x64)
; ; ; ; Folding = -------------------0f-f----------------------------
; ; ; ; EnableXP
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = ----------------------------------------
; EnableXP