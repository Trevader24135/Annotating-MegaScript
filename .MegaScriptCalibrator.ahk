#SingleInstance Force
#InstallKeybdHook
SetDefaultMouseSpeed, 2
#include .MegaScriptCalibration.ahk

;locations to collect:
;Label ID:                Y
;One Character Readable X,Y
;Label Type 1             Y  \ these two together should be enough for all label types
;Label Type 2             Y  /
;Label Save               Y
;Corner Save              Y
;Field Type               Y
;Field Text               Y
;Field Save               Y

;Variable MasterX
;Variable SecondaryX

MainGui()

MainGui() {
	global
	Gui, Main:new, -MaximizeBox -MinimizeBox +AlwaysOnTop, Project Calibrator
	Gui, Add, Text, X2 Y0 W175,Press the button below`, then `nclick the required field
	
	Y = 0
	for key, value in locations{
		Y += 25
		YY:= Y + 5
		Gui, Add, Button, gCalibrate X0 Y%Y%,%key%
		Gui, Add, Text, v%key% X100 Y%YY% W75, % "X: " value[1] " | Y: " value[2]
	}
	
	Y += 50
	YY:= Y + 5
	Gui, Add, Button, gSetHotkey X0 Y%Y% w95, Set Hotkey
	Gui, Add, Text, vSetHotkeyText X100 Y%YY% W75, % DesiredHotKey
	
	Y += 25
	YY:= Y + 5
	Gui, Add, Button, gSaveCalibration X100 Y%Y% w95,Save Calibration
	
	Gui, Show, w200,Calibrator
}

Calibrate() {
	;A_GuiControl the name of the button
	global locations
	KeyWait, LButton, D
	MouseGetPos, X, Y
	locations[A_GuiControl]:=[X,Y]
	
	GuiControl, Main:, %A_GuiControl%, % "X: " X " | Y: " Y
}

SetHotkey() {
	global DesiredHotKey
	previous:= A_PriorKey
	while A_PriorKey == previous {
		
	}
	DesiredHotKey:= A_PriorKey
}

SaveCalibration() {
	global locations, DesiredHotKey
	FileDelete, .MegaScriptCalibration.ahk
	string = locations:={
	for key, value in locations{
		string:= string " """ key """:[" value[1] "," value[2] "],"
	}
	string:= SubStr(string, 1, -1)
	string = %string%}
	FileAppend, %string%`n,.MegaScriptCalibration.ahk
	
	deltaLabelType:= locations["LabelTypeTwo"][2] - locations["LabelTypeOne"][2]
	FileAppend, deltaLabelType:= %deltaLabelType%`n,.MegaScriptCalibration.ahk
	DesiredHotKey:= " """ DesiredHotKey """ "
	FileAppend, DesiredHotKey:=%DesiredHotKey%`n,.MegaScriptCalibration.ahk
}