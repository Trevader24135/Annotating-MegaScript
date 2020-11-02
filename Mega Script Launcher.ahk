;Cargill Mega Script V1.4
;October 24, 2020
;Trevor Klingler

;TODOS
;always on top ID number counter?
;GUI based label generator / loading system
;default answers for select fields in label questions
#SingleInstance Force
SetDefaultMouseSpeed, 2

InitializeScript()
;LoadConfigVariables()

InitializeScript() {
	global ProjectChosen
	AvailableConfigs =
	Loop, *.mscfg
	   AvailableConfigs = %AvailableConfigs%||%A_LoopFileName%
	   
	Gui, new, -MaximizeBox -MinimizeBox +AlwaysOnTop, Available Projects

	Gui, Add, DropDownList, vProjectChosen x5 y2 w160, %AvailableConfigs%
	
	Gui, Add, Button, gLaunchCalibrator x170 y1 w53, Calibrate
	
	if FileExist(".MegaScriptCalibration.ahk") {
		Gui, Add, Button, gLaunchChosenConfig x5 y27, Choose Config
	} else {
		Gui, Add, Button, gLaunchCalibrator x5 y27, Calibrate
	}
	
	Gui, Add, Button, gEditChosenConfig x85 y27, Edit Config
	Gui, Add, Button, gCreateConfig x147 y27, Create Config

	Gui, show, w228
}
LaunchCalibrator() {
	Gui, Submit
	if not FileExist(".MegaScriptCalibration.ahk") {
		locations = locations:={"LabelID":[0,0],"CharReadable":[0,0],"LabelTypeOne":[0,0],"LabelTypeTwo":[0,0],"LabelSave":[0,0],"CornerSave":[0,0],"FieldType":[0,0],"FieldText":[0,0],"FieldSave":[0,0],"WindowTL":[0,0],"WindowTR":[0,0],"WindowBL":[0,0],"WindowBR":[0,0]}`ndeltaLabelType:=0`nDesiredHotKey:="NumpadAdd"
		FileAppend, %locations%,.MegaScriptCalibration.ahk
	}
	Run ".MegaScriptCalibrator.ahk"
	ExitApp
}
LaunchChosenConfig() {
	global ProjectChosen
	Gui, Submit
	FileCopy %ProjectChosen%, temp.ahk
	Run ".MegaScriptClient.ahk"
	ExitApp
}
EditChosenConfig() {
	global ProjectChosen
	Gui, Submit
	FileCopy %ProjectChosen%, temp.ahk
	Run ".MegaScriptEditor.ahk"
	ExitApp
}
CreateConfig() {
	Gui, Submit
	Run ".MegaScriptCreator.ahk"
	ExitApp
}