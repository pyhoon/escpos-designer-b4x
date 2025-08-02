B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=10.3
@EndOfDesignText@
Sub Class_Globals
	'Private Printer1 As EscPosPrinter
	Public E_RESET As String = Code.ESC & Code.AT
	Public E_JUSTIFY_LEFT As String = Code.ESC & Code.LC_a & Code.Num0
	Public E_JUSTIFY_RIGHT As String = Code.ESC & Code.LC_a & Code.Num2
	Public E_JUSTIFY_CENTER As String = Code.ESC & Code.LC_a & Code.Num1
End Sub

Public Sub Initialize
	
End Sub