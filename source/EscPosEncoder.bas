B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=10.3
@EndOfDesignText@
Sub Class_Globals
	'Private Printer1 As EscPosPrinter
	Public E_RESET As String = EscPos.ESC & EscPos.AT
	Public E_JUSTIFY_LEFT As String = EscPos.ESC & EscPos.LC_a & EscPos.Num0
	Public E_JUSTIFY_RIGHT As String = EscPos.ESC & EscPos.LC_a & EscPos.Num2
	Public E_JUSTIFY_CENTER As String = EscPos.ESC & EscPos.LC_a & EscPos.Num1
End Sub

Public Sub Initialize
	
End Sub