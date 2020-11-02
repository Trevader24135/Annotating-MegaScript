#SingleInstance Force
SetDefaultMouseSpeed, 2
#include temp.ahk
FileDelete temp.ahk

SortArrayByValue(array,options="",delimiter="`n"){
   If InStr(Options,"ByKey"){
      StringReplace,options,options,ByKey
      for k in array
         out.= k delimiter
      StringTrimRight,out,out,1
      Sort,out,%options%
      Loop,Parse,out,%delimiter%
         out_.=Array[A_LoopField] Delimiter
      out:=out_
   } else {
      for k, v in array
         out.= v delimiter
      StringTrimRight,out,out,1
      Sort,out,%options%
   }
   return out
}

temp:= {}
for key, value in LabelTypes {
	temp:= {}
	for key2, value2 in %key% {
		temp:= temp "    """ value2[1] """," ArrayToString(value2[2]) "`n"
	}
	%key%Data:=SubStr(temp, 1, -1)
	LabelDefinitionsTexts:=LabelDefinitionsTexts key "`n" temp
}
LabelDefinitionsTexts:=SubStr(LabelDefinitionsTexts, 1, -1)

temp:={}
for key, value in LabelTypes {
	temp:= temp key "`n"
}
temp:= SubStr(temp, 1, -1)
LabelTypes:=temp

temp:={}
for key, value in FieldTypes {
	temp:= temp key "`n"
}
temp:= SubStr(temp, 1, -1)
FieldTypes:=temp


Width = 640
Height = 480

MainGui()

EditToArrayString(EditText) {
	TempArray = [
	for key,line in StrSplit(EditText,"`n") {
		TempArray = %TempArray%"%line%",
	}
	TempArray:= SubStr(TempArray, 1, -1)
	TempArray = %TempArray%]
	return TempArray
}

EditToDictString(EditText) {
	TempArray = {
	for key,line in StrSplit(EditText,"`n") {
		keynum:= key
		TempArray = %TempArray%"%line%":%keynum%,
	}
	TempArray:= SubStr(TempArray, 1, -1)
	TempArray = %TempArray%}
	return TempArray
}

EditToDictStringZero(EditText) {
	TempArray = {
	for key,line in StrSplit(EditText,"`n") {
		keynum:= key - 1
		TempArray = %TempArray%"%line%":%keynum%,
	}
	TempArray:= SubStr(TempArray, 1, -1)
	TempArray = %TempArray%}
	return TempArray
}

EditToList(EditText) {
	TempArray = [
	for key,line in StrSplit(EditText,"`n") {
		TempArray = %TempArray%[%line%],
	}
	TempArray:= SubStr(TempArray, 1, -1)
	TempArray = %TempArray%]
	return TempArray
}

ArrayToString(Arra) {
	temp = [
	for key, value in Arra {
		temp:= temp value ","
	}
	temp:= SubStr(temp, 1, -1)
	temp:= temp "]"
	return temp
}

StrList(STR) {
	;STR:= SubStr(STR, 2)
	;STR:= SubStr(STR, 1, -1)
	;STR:= StrReplace(STR, ",", "`n")
	;STR:= StrReplace(STR, """", "")
	STR:= StrReplace(STR, " ", "")
	return STR
}

MainGUI() {
	global
	Gui, Main:new, -MaximizeBox -MinimizeBox, Project Configurator - %ProjectName%

	Gui, Add, Text, X5 Y5, Types of Labels
	Gui, Add, Edit, X5 Y25 W90 H150 vLabelTypesText ReadOnly, %LabelTypes%
	Gui, Add, Button, X5 Y180 W90 gEditLabelTypes, Edit Label Types
	
	Gui, Add, Text, X100 Y5, Label Definitions
	Gui, Add, Edit, X100 Y25 W535 H150 vLabelDefinitionsText ReadOnly, %LabelDefinitionsTexts%
	Gui, Add, Button, X100 Y180 W535 gEditLabelDefinitions, Edit Label Definitions
	
	Gui, Add, Text, X5 Y215, Types of Fields
	Gui, Add, Edit, X5 Y235 W90 H150 vFieldTypesText ReadOnly, %FieldTypes%
	Gui, Add, Button, X5 Y390 W90 gEditFieldTypes, Edit Field Types
	
	Gui, Add, Text, X100 Y215, Field Defaults
	Gui, Add, Edit, X100 Y235 W535 H150 vFieldDefaultsText ReadOnly, %FieldDefaultsTexts%
	Gui, Add, Button, X100 Y390 W535 gEditFieldDefaults, Edit Field Defaults
	
	Gui, Add, Button, gSave X560 Y450 W35 H25 , Save
	Gui, Add, Button, gExit X600 Y450 W35 H25 , Exit

	Gui, Show, W%Width% H%Height%
}

Save() {
	;global ProjectName, LabelTypes, FieldTypes
	global
	Gui, Submit, NoHide
	FileDelete %ProjectName%.mscfg
	
	FileAppend ProjectName:=%ProjectName%,%ProjectName%.mscfg
	
	LabelTypesSave:= "LabelTypes:="EditToDictStringZero(LabelTypes)"`n"
	FileAppend %LabelTypesSave%,%ProjectName%.mscfg
	
	FieldTypesSave:= "FieldTypes:="EditToDictStringZero(FieldTypes)"`n"
	FileAppend %FieldTypesSave%,%ProjectName%.mscfg
	
	local temp, tempstr
	temp = 0
	for index, value in StrSplit(LabelDefinitionsText, "`n") { 
		if (SubStr(value, 1, 4) == "    ") {
			tempstr:=tempstr "["SubStr(value, 5)"],"
		}
		else {
			tempstr:= SubStr(tempstr, 1, -1)
			tempstr:= tempstr "]"
			if (tempstr != "" and tempstr != "[[]]" and tempstr != "]") {
				tempstr:= StrSplit(LabelTypes, "`n")[temp] ":=" tempstr "`n"
				FileAppend %tempstr%,%ProjectName%.mscfg
			}
			tempstr = [
			temp += 1
		}
	}
	
}

Exit() {
	MsgBox, 308, Exit Creator?, Any unsaved progress will be lost!
	IfMsgBox Yes
		ExitApp
}

EditLabelTypes() {
	global LabelTypes
	Gui, new, -MaximizeBox -MinimizeBox, Edit Label Types
	
	Gui, Add, Text, X5 Y5, Label Types
	Gui, Add, Edit, vLabelTypes X5 Y20 W110 H188, %LabelTypes%
	Gui, Add, Button, X5 Y213 W55 gEditLabelTypesCancel, Cancel
	Gui, Add, Button, X60 Y213 W55 gEditLabelTypesSave, Save
	
	Gui, show, W120 H240
}
EditLabelTypesCancel() {
	Gui, Destroy
}
EditLabelTypesSave() {
	global
	Gui, Submit
	GuiControl Main:, LabelTypesText, %LabelTypes%
}

EditFieldTypes() {
	global FieldTypes
	Gui, new, -MaximizeBox -MinimizeBox, Edit Field Types
	
	Gui, Add, Text, X5 Y5, Field Types
	Gui, Add, Edit, vFieldTypes X5 Y20 W110 H188, %FieldTypes%
	Gui, Add, Button, X5 Y213 W55 gEditFieldTypesCancel, Cancel
	Gui, Add, Button, X60 Y213 W55 gEditFieldTypesSave, Save
	
	Gui, show, W120 H240
}
EditFieldTypesCancel() {
	Gui, Destroy
}
EditFieldTypesSave() {
	global
	Gui, Submit
	GuiControl Main:, FieldTypesText, %FieldTypes%
}

EditLabelDefinitions() {
	global LabelTypes, FieldTypes
	Gui, LabelDefinitions:new, -MaximizeBox -MinimizeBox, Edit Label Definitions
	
	global SelectedLabelType
	LabelTypeSelections:= StrReplace(LabelTypes, "`n", "||")
	Gui, Add, DropDownList, gEditLabelDefinitionsLabelTypeChange vSelectedLabelType x5 y4 w290, %LabelTypeSelections%	
	
	Gui, Add, Button, X300 Y3 W95 gEditLabelDefinitionsSetLabelCorners, Set Label Corners
	
	global SelectedFieldType
	FieldTypeSelections:= StrReplace(FieldTypes, "`n", "||")
	Gui, Add, DropDownList, vSelectedFieldType x5 y236 w190, %FieldTypeSelections%
	
	Gui, Add, Button, X200 Y235 W140 gEditLabelDefinitionsMarkField, Mark Field
	Gui, Add, Button, X345 Y235 W50 gEditLabelDefinitionsAddField, Add
	
	global LabelDefinitionText
	Gui, Add, Edit, vLabelDefinitionText X5 Y30 W390 H200
	
	
	Gui, Add, Button, X270 Y273 W65 gEditLabelDefinitionsSave, Save Label
	Gui, Add, Button, X340 Y273 W55 gEditLabelDefinitionsCancel, Exit
	
	Gui, show, W400 H300
}

EditLabelDefinitionsLabelTypeChange() {
	global
	Gui, Submit, NoHide
	GuiControl LabelDefinitions:, LabelDefinitionText, % StrList(%SelectedLabelType%data)
}
EditLabelDefinitionsSetLabelCorners() {
	Gui, Submit, NoHide
	global CX1,CY1,CX2,CY2,CX3,CY3,CX4,CY4
	MsgBox, 4096, Set Label Size,1) Click into your annotating browser window`n2) Click OK`n3) Click all four corners of the label
	sleep 200
	KeyWait, LButton, D
	MouseGetPos CX1, CY1
	sleep 200
	KeyWait, LButton, D
	MouseGetPos CX2, CY2
	sleep 200
	KeyWait, LButton, D
	MouseGetPos CX3, CY3
	sleep 200
	KeyWait, LButton, D
	MouseGetPos CX4, CY4
	sleep 200
	msgbox Corners Set! don't pan the screen`nuntil all the fields have been marked
	;Corners:= [[CX1,CY1],[CX2,CY2],[CX3,CY3],[CX4,CY4]]
	;Width:= (Sqrt((CX1-CX2) * (CX1-CX2) + (CY1-CY2) * (CY1-CY2)) + Sqrt((CX3-CX4) * (CX3-CX4) + (CY3-CY4) * (CY3-CY4))) / 2
	;Height:= (Sqrt((CX1-CX3) * (CX1-CX3) + (CY1-CY3) * (CY1-CY3)) + Sqrt((CX2-CX4) * (CX2-CX4) + (CY2-CY4) * (CY2-CY4))) / 2
	
	;global LabelDefinitionText
	;if (LabelDefinitionText == "") {
	;	GuiControl LabelDefinitions:, LabelDefinitionText, ["Size",[%Width%,%Height%]]
	;} 
	;else {
	;	GuiControl LabelDefinitions:, LabelDefinitionText, %LabelDefinitionText%`nSize,[%Width%,%Height%]
	;}
}
EditLabelDefinitionsMarkField(){
	global FX1,FY1,FX2,FY2,FX3,FY3,FX4,FY4
	
	MsgBox, 4096, Set Label Size,1) Click into your annotating browser window`n2) Click OK`n3) Click all four corners of the Field
	sleep 200
	KeyWait, LButton, D
	MouseGetPos FX1, FY1
	sleep 200
	KeyWait, LButton, D
	MouseGetPos FX2, FY2
	sleep 200
	KeyWait, LButton, D
	MouseGetPos FX3, FY3
	sleep 200
	KeyWait, LButton, D
	MouseGetPos FX4, FY4
	sleep 200
	Msgbox Field Marked!
}
EditLabelDefinitionsAddField(){
	global CX1,CY1,CX2,CY2,CX3,CY3,CX4,CY4
	global FX1,FY1,FX2,FY2,FX3,FY3,FX4,FY4
	global LabelDefinitionText, SelectedFieldType
	Gui, Submit, NoHide
	width:= CX2 - CX1
	DX1:= Round((FX1-CX1)/width,3)
	DY1:= Round((FY1-CY1)/width,3)
	DX2:= Round((FX2-CX1)/width,3)
	DY2:= Round((FY2-CY1)/width,3)
	DX3:= Round((FX3-CX1)/width,3)
	DY3:= Round((FY3-CY1)/width,3)
	DX4:= Round((FX4-CX1)/width,3)
	DY4:= Round((FY4-CY1)/width,3)
	if (LabelDefinitionText == "") {
		GuiControl LabelDefinitions:, LabelDefinitionText, "%SelectedFieldType%",[%DX1%,%DY1%,%DX2%,%DY2%]
	} 
	else {
		GuiControl LabelDefinitions:, LabelDefinitionText, %LabelDefinitionText%`n"%SelectedFieldType%",[%DX1%,%DY1%,%DX2%,%DY2%]
	}
}
EditLabelDefinitionsCancel() {
	Gui, Destroy
}
EditLabelDefinitionsSave() {
	global
	Gui, Submit, NoHide
	if (LabelDefinitionText != "") {
		%SelectedLabelType%data:=strreplace(LabelDefinitionText,"`n","`n    ")
	} else {
		%SelectedLabelType%data:=""
	}
	local temp
	temp:={}
	loop, parse, LabelTypes, "`n"
	{
		temp:= temp A_LoopField "`n    " %A_LoopField%data "`n"
	}
	GuiControl Main:, LabelDefinitionsText, %temp%
}

EditFieldDefaults() {
	global LabelTypes
	Gui, new, -MaximizeBox -MinimizeBox, Edit Field Defaults
	
	Gui, show, W120 H240
}
EditFieldDefaultsCancel() {
	Gui, Destroy
}
EditFieldDefaultsSave() {
	global
	Gui, Submit
}








