#SingleInstance Force
SetDefaultMouseSpeed, 2
#include .MegaScriptCalibration.ahk
#include temp.ahk
FileDelete temp.ahk

corner:= 1

ClickSkewMesh(LX, LY) { ;PERFECT; NO CHANGES REQUIRED OTHER THAN EDGE DETECTION
	global CX1,CY1,CX2,CY2,CX3,CY3,CX4,CY4
	C1:=(1-lx)*(1-ly)
	C2:=(lx)*(1-ly)
	C3:=(1-lx)*(ly)
	C4:=(lx)*(ly)
	
	X:= ((CX1 * C1) + (CX2 * C2) + (CX3 * C3) + (CX4 * C4))
	Y:= ((CY1 * C1) + (CY2 * C2) + (CY3 * C3) + (CY4 * C4))
	
	Click %X%,%Y%
	Sleep 50
}

MarkLabel(LabelType, BoxIndex) { ;NEEDS TO INPUT LABEL DATA
	global locations, LabelTypes
	Send ````1
	ClickSkewMesh(-0.1,-0.1)
	ClickSkewMesh(1.1,-0.1)
	ClickSkewMesh(1.1,1.1)
	ClickSkewMesh(-0.1,1.1)
	ClickSkewMesh(-0.1,-0.1)
	
	Send %BoxIndex%
	
	tempx:= locations["CharReadable"][1]
	tempy:= locations["CharReadable"][2]
	Click %tempx%,%tempy%
	sleep 50
	
	tempx:= locations["LabelTypeOne"][1]
	temp:= LabelTypes[LabelType]
	tempy:= locations["LabelTypeOne"][2]
	tempy+= (%deltaLabelType% * temp) 
	Click %tempx%,%tempy%
	sleep 50
	
	tempx:= locations["LabelSave"][1]
	tempy:= locations["LabelSave"][2]
	Click %tempx%,%tempy%
	sleep 50
}

Corner(x,y,BoxIndex) { ;NEEDS EDGE DETECTION AND DATA INPUT
	global locations
	Send ````2
	Sleep 50
	Click %x%,%y%
	Sleep 50
	Send %BoxIndex%
	tempx:= locations["CornerSave"][1]
	tempy:= locations["CornerSave"][2]
	Click %tempx%,%tempy%
}

MarkCorners(BoxIndex) { ;NO PROBLEM
	global CX1,CY1,CX2,CY2,CX3,CY3,CX4,CY4
	corner(CX1, CY1, BoxIndex)
	corner(CX2, CY2, BoxIndex)
	corner(CX3, CY3, BoxIndex)
	corner(CX4, CY4, BoxIndex)
}

Arrow(number) { ;SHOULD be fine...
	i:= 0
	while i < number {
		Send {Down}
		i:= i + 1
	}
	Send {enter}
}

MarkFields(BoxIndex) { ; NEEDS TO INPUT LABEL DATA
	global
	Send ````3
		
	for i, element in %LabelType%
	{
		ClickSkewMesh(element[2][1],element[2][2])
		ClickSkewMesh(element[2][3],element[2][2])
		ClickSkewMesh(element[2][3],element[2][4])
		ClickSkewMesh(element[2][1],element[2][4])
		ClickSkewMesh(element[2][1],element[2][2])
		
		Send %BoxIndex%
		
		;msgbox % locations["FieldType"][1] " " locations["FieldType"][2]
		
		tempx:= locations["FieldType"][1]
		tempy:= locations["FieldType"][2]
		Click %tempx%,%tempy%
		sleep 25
		temp:=FieldTypes[element[1]]
		Arrow(temp)
		sleep 25
		tempx:= locations["FieldText"][1]
		tempy:= locations["FieldText"][2]
		Click %tempx%,%tempy%
		sleep 25
		temp:=element[1]
		temp:= %temp%
		Send %temp%
		sleep 25
		tempx:= locations["FieldSave"][1]
		tempy:= locations["FieldSave"][2]
		Click %tempx%,%tempy%
		sleep 25
	}
}

F24::
switch corner {
	case 1:
		MouseGetPos, CX1, CY1
		corner+=1
		return
	case 2:
		MouseGetPos, CX2, CY2
		corner+=1
		return
	case 3:
		MouseGetPos, CX3, CY3
		corner+=1
		return
	case 4:
		corner:= 1
		MouseGetPos, CX4, CY4
		
		;unsure if I'll need them. we'll see. they're here...
		width:=(sqrt((CX2-CX1)*(CX2-CX1) + (CY2-CY1)*(CY2-CY1)) + sqrt((CX4-CX3)*(CX4-CX3) + (CY4-CY3)*(CY4-CY3))) / 2
		height:=(sqrt((CX3-CX1)*(CX3-CX1) + (CY3-CY1)*(CY3-CY1)) + sqrt((CX4-CX2)*(CX4-CX2) + (CY4-CY2)*(CY4-CY2))) / 2
		
		LabelTypeSelectOptions:=""
		for key, value in LabelTypes {
			LabelTypeSelectOptions:=LabelTypeSelectOptions "|" key
		}
		
		LabelType:= 0
		Gui, New, ,Label Type:
		Gui -MaximizeBox -MinimizeBox
		Gui, Add, DropDownList, vLabelType, %LabelTypeSelectOptions%
		Gui, Add, Button, gBoxTypeSubmit,OK
		Gui, Show, ,Label Type:
		While (LabelType == 0) {
		}
		if (LabelType == ""){
			return
		}
		
		InputBox, BoxIndex, Label ID
		for i, element in %LabelType%{
			temp:=element[1]
			InputBox %temp% , %temp%
		}
		Sleep 100
		MarkLabel(LabelType, BoxIndex)
		MarkCorners(BoxIndex)
		MarkFields(BoxIndex)
		return
}
return

BoxTypeSubmit() {
	Gui, Submit
}