
;------------------------------------------------------------------------------------
;- Notes
;------------------------------------------------------------------------------------
;-- See TODO.txt

;------------------------------------------------------------------------------------
;- Compiler Settings
;------------------------------------------------------------------------------------
EnableExplicit
UsePNGImageDecoder()

;------------------------------------------------------------------------------------
;- Structures
;------------------------------------------------------------------------------------
Structure Menu
  OpenIn.s
  Url.s
  Title.s
EndStructure

Structure Configuration
  List Menus.Menu()
EndStructure

;------------------------------------------------------------------------------------
;- Variables, Enumerations, Lists and Maps
;------------------------------------------------------------------------------------
Global Event = #Null, Quit = #False
Global Customization.Configuration
#JSON_Parser = 0

; Files
Global IndexFile.s = "file://" + GetCurrentDirectory() + "Web/src/index.html"
Global ConfigurationFile.s = GetCurrentDirectory() + "Configuration.json"

;------------------------------------------------------------------------------------
;- Forms
;------------------------------------------------------------------------------------
XIncludeFile "Forms/MainWindow.pbf"

;------------------------------------------------------------------------------------
;- Functions
;------------------------------------------------------------------------------------
Procedure ShowMainWindow()
  OpenMainWindow()
  WindowBounds(MainWindow, WindowWidth(MainWindow)-200, WindowHeight(MainWindow), #PB_Ignore, #PB_Ignore)
  BindEvent(#PB_Event_SizeWindow, @ResizeGadgetsMainWindow(), MainWindow)
EndProcedure

Procedure LoadConfiguration()
  If LoadJSON(#JSON_Parser, ConfigurationFile)
    ;Debug "JSON object data from file:"
    ;Debug ComposeJSON(#JSON_Parser, #PB_JSON_PrettyPrint)
    ExtractJSONStructure(JSONValue(#JSON_Parser), Customization, Configuration)
    FreeJSON(#JSON_Parser)
  Else
    Debug "Can't read the configuration or the file is empty: " + ConfigurationFile
  EndIf
EndProcedure

Procedure WebView_Home()
  Debug "WebView: Show Local File: " + IndexFile 
  If IsGadget(WebView_Index) : SetGadgetText(WebView_Index, IndexFile) : EndIf
EndProcedure

Procedure Menu_Quit()
  End
EndProcedure

Procedure Menu_EventHandler()
  Protected Entry = EventGadget(), i = 1
  Protected OpenIn.s, Url.s
  
  ForEach Customization\Menus()
    If Entry = i
      OpenIn = Customization\Menus()\OpenIn
      Url = Customization\Menus()\Url
    EndIf
    
    ; Counter
    i+1
  Next
  
  Debug "Open-in ("+OpenIn+") with url: " + Url
  Select OpenIn
    Case "process":
      RunProgram(Url)
    Case "browser":
      If IsGadget(WebView_Index) : SetGadgetText(WebView_Index, Url) : EndIf
  EndSelect
  
EndProcedure

Procedure BuildMenu()
  Protected i = 1
  
  If CreateMenu(0, WindowID(MainWindow))
    MenuTitle("File")
    
      ForEach Customization\Menus()
        MenuItem(i, Customization\Menus()\Title)
        BindMenuEvent(0, i, @Menu_EventHandler())
        
        ; Counter
        i+1
      Next 
      
      MenuBar()
      MenuItem(98, "&Quit")
      BindMenuEvent(0, 98, @Menu_Quit())

    MenuTitle("Browse")
      MenuItem(99, "Home")
      BindMenuEvent(0, 99, @WebView_Home())
  EndIf
EndProcedure

;------------------------------------------------------------------------------------
;- Main Loop
;------------------------------------------------------------------------------------
ShowMainWindow()
LoadConfiguration()
BuildMenu()
WebView_Home()

;------------------------------------------------------------------------------------
;- Event Loop
;------------------------------------------------------------------------------------
Repeat
  Event = WaitWindowEvent()

  Select EventWindow()
    Case MainWindow
      If Event = #PB_Event_CloseWindow
        End
      Else
        MainWindow_Events(Event)
      EndIf
  EndSelect
  
Until Quit = #True

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 89
; FirstLine = 44
; Folding = 1-
; EnableXP
; DPIAware