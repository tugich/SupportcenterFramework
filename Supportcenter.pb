
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
;- Variables, Enumerations and Maps
;------------------------------------------------------------------------------------
Global Event = #Null, Quit = #False
Global IndexFile.s = "file://" + GetCurrentDirectory() + "Web/src/index.html"
Global TeamViewerQuickSupport.s = "https://download.teamviewer.com/download/TeamViewerQS_x64.exe"

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

Procedure ShowHome()
  SetGadgetText(WebView_Index, IndexFile)
EndProcedure

Procedure WebView_Home(EventType)
  Debug "Inject JavaScript in WebView..."
  FreeGadget(WebView_Index)
  WebView_Index = WebViewGadget(#PB_Any, 0, 0, WindowWidth(MainWindow), WindowHeight(MainWindow)-3, #PB_WebView_Debug)
  ShowHome()
EndProcedure

Procedure StartQuickAssist(EventType)
  Debug "Starting Microsoft Quick Assist by Protocol..."
  RunProgram("ms-quick-assist://")
EndProcedure

Procedure StartTeamViewerQS(EventType)
  RunProgram(TeamViewerQuickSupport)
EndProcedure

Procedure QuitApplication(EventType)
  End
EndProcedure

;------------------------------------------------------------------------------------
;- Main Loop
;------------------------------------------------------------------------------------
ShowMainWindow()
ShowHome()

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
; CursorPosition = 47
; FirstLine = 22
; Folding = --
; EnableXP
; DPIAware