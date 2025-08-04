B4J=true
Group=Classes
ModulesStructureVersion=1
Type=StaticCode
Version=10.3
@EndOfDesignText@
' Reference: https://www.rapidtables.com/code/text/ascii-table.html
Sub Process_Globals
	Public NUL As String = Chr(0)
	Public SOH As String = Chr(1)
	Public STX As String = Chr(2)
	Public ETX As String = Chr(3)
'	Public EOT As String = Chr(4)
'	Public ENQ As String = Chr(5)
'	Public ACK As String = Chr(6)
'	Public BEL As String = Chr(7)
'	Public BS As String = Chr(8)
	Public HT As String = Chr(9)
	Public LF As String = Chr(10)
'	Public VT As String = Chr(11)
'	Public FF As String = Chr(12)
	Public CR As String = Chr(13)
'	Public SO As String = Chr(14)
'	Public SI As String = Chr(15)
'	Public DLE As String = Chr(16)
'	Public DC1 As String = Chr(17)
'	Public DC2 As String = Chr(18)
'	Public DC3 As String = Chr(19)
'	Public DC4 As String = Chr(20)
'	Public NAK As String = Chr(21)
'	Public SYN As String = Chr(22)
'	Public ETB As String = Chr(23)
'	Public CAN As String = Chr(24)
'	Public EM As String = Chr(25)
'	Public SUB As String = Chr(26)
	Public ESC As String = Chr(27)
	Public FS As String = Chr(28)
	Public GS As String = Chr(29)
'	Public RS As String = Chr(30)
'	Public US As String = Chr(31)
	Public Space As String = Chr(32) ' " "
	Public Exclamation As String = Chr(33) ' !
'	Public QUOTE As String = Chr(34) ' "
	Public Hash As String = Chr(35) ' #
	Public Dollar As String = Chr(36) ' $
	Public Percent As String = Chr(37) ' %
	Public Ampersand As String = Chr(38) ' &
	Public SingleQuote As String = Chr(39) ' '
	Public OpenBracket As String = Chr(40) ' (
	Public CloseBracket As String = Chr(41) ' )
	Public Astericks As String = Chr(42) ' *
	'Public Plus As String = Chr(43) ' +
	'Public Comma As String = Chr(44) ' ,
	'Public Minus As String = Chr(45) ' -
	'Public Period As String = Chr(46) ' .
	'Public Slash As String = Chr(47) ' /
	Public Num0 As String = Chr(48) ' 0
	Public Num1 As String = Chr(49) ' 1
	Public Num2 As String = Chr(50) ' 2
	Public Num3 As String = Chr(51) ' 3
	Public Num4 As String = Chr(52) ' 4
	Public Num5 As String = Chr(53) ' 5
	
	Public Question As String = Chr(63) ' ?
	Public At As String = Chr(64) ' @
	Public A As String = Chr(65) ' A
	Public B As String = Chr(66) ' B
	Public C As String = Chr(67) ' C
	Public D As String = Chr(68) ' D
	Public E As String = Chr(69) ' E
	Public F As String = Chr(70) ' F
	Public G As String = Chr(71) ' G
	Public H As String = Chr(72) ' H
	Public I As String = Chr(73) ' I
	Public J As String = Chr(74) ' J
	Public K As String = Chr(75) ' K
	Public L As String = Chr(76) ' L
	Public M As String = Chr(77) ' M
	Public W As String = Chr(87) ' W
	Public X As String = Chr(88) ' X
	Public Y As String = Chr(89) ' Y
	Public Z As String = Chr(90) ' Z
	
	Public BackSlash As String = Chr(92) ' \
	Public LC_a As String = Chr(97) ' a
	Public LC_b As String = Chr(98) ' b
	Public LC_c As String = Chr(99) ' c
	Public LC_d As String = Chr(100) ' d
	Public LC_t As String = Chr(116) ' t
End Sub

Public Sub Codes As Map
	Dim M1 As Map
	M1.Initialize
	M1.Put("NUL", NUL)
	M1.Put("SOH", SOH)
	M1.Put("STX", STX)
	M1.Put("ETX", ETX)
	M1.Put("HT", HT)
	M1.Put("LF", LF)
	M1.Put("CR", CR)
	M1.Put("ESC", ESC)
	M1.Put("FS", FS)
	M1.Put("GS", GS)
	M1.Put(" ", Space)
	M1.Put("!", Exclamation)
	M1.Put("#", Hash)
	M1.Put("$", Dollar)
	M1.Put("%", Percent)
	M1.Put("&", Ampersand)
	M1.Put("'", SingleQuote)
	M1.Put("(", OpenBracket)
	M1.Put(")", CloseBracket)
	M1.Put("*", Astericks)
	M1.Put("0", Num0)
	M1.Put("1", Num1)
	M1.Put("2", Num2)
	M1.Put("3", Num3)
	M1.Put("4", Num4)
	M1.Put("5", Num5)
	M1.Put("?", Question)
	M1.Put("@", At)
	M1.Put("A", A)
	M1.Put("B", B)
	M1.Put("C", C)
	M1.Put("D", D)
	M1.Put("E", E)
	M1.Put("F", F)
	M1.Put("G", G)
	M1.Put("H", H)
	M1.Put("I", I)
	M1.Put("J", J)
	M1.Put("K", K)
	M1.Put("L", L)
	M1.Put("M", M)
	M1.Put("W", W)
	M1.Put("X", X)
	M1.Put("Y", Y)
	M1.Put("Z", Z)
	M1.Put("\", BackSlash)
	M1.Put("a", LC_a)
	M1.Put("b", LC_b)
	M1.Put("c", LC_c)
	M1.Put("d", LC_d)
	M1.Put("t", LC_t)
	Return M1
End Sub

Public Sub Tags As Map
	Dim M2 As Map
	M2.Initialize
	M2.Put("[NUL]", "NUL")
	M2.Put("[SOH]", "SOH")
	M2.Put("[STX]", "STX")
	M2.Put("[ETX]", "ETX")
	M2.Put("[HT]", "HT")
	M2.Put("[LF]", "LF")
	M2.Put("[CR]", "CR")
	M2.Put("[ESC]", "ESC")
	M2.Put("[FS]", "FS")
	M2.Put("[GS]", "GS")
	M2.Put("[ ]", " ")
	M2.Put("[!]", "!")
	M2.Put("[#]", "#")
	M2.Put("[$]", "$")
	M2.Put("[%]", "%")
	M2.Put("[&]", "&")
	M2.Put("[']", "'")
	M2.Put("[(]", "(")
	M2.Put("[)]", ")")
	M2.Put("[*]", "*")
	M2.Put("[0]", "0")
	M2.Put("[1]", "1")
	M2.Put("[2]", "2")
	M2.Put("[3]", "3")
	M2.Put("[4]", "4")
	M2.Put("[5]", "5")
	M2.Put("[?]", "?")
	M2.Put("[@]", "@")
	M2.Put("[A]", "A")
	M2.Put("[B]", "B")
	M2.Put("[C]", "C")
	M2.Put("[D]", "D")
	M2.Put("[E]", "E")
	M2.Put("[F]", "F")
	M2.Put("[G]", "G")
	M2.Put("[H]", "H")
	M2.Put("[I]", "I")
	M2.Put("[J]", "J")
	M2.Put("[K]", "K")
	M2.Put("[L]", "L")
	M2.Put("[M]", "M")
	M2.Put("[W]", "W")
	M2.Put("[X]", "X")
	M2.Put("[Y]", "Y")
	M2.Put("[Z]", "Z")
	M2.Put("[\]", "\")
	M2.Put("[a]", "a")
	M2.Put("[b]", "b")
	M2.Put("[c]", "c")
	M2.Put("[d]", "d")
	M2.Put("[t]", "t")
	Return M2
End Sub

' Combination of more than 1 tag as shortcut
Public Sub Custom As Map
	Dim M3 As Map
	M3.Initialize
	M3.Put("[CLEAR]", "[ESC][@]")
	M3.Put("[LINEFEED]", "[CR][LF]")
	M3.Put("[LEFT]", "[ESC][a][NUL]")
	M3.Put("[CENTER]", "[ESC][a][SOH]")
	M3.Put("[RIGHT]", "[ESC][a][STX]")
	M3.Put("[BOLD]", "[ESC][E][1]")
	M3.Put("[UNBOLD]", "[ESC][E][0]")
	M3.Put("[SINGLE]", "[ESC][!][0]")
	M3.Put("[HIGH]", "[ESC][!][1]")
	M3.Put("[WIDE]", "[ESC][!][2]")
	M3.Put("[HIGHWIDE]", "[ESC][!][3]")
	Return M3
End Sub

Public Sub DrawCharLine (DC As String, DL As Int) As String
	Dim DS As String
	For index = 0 To DL - 1
		DS = DS & DC
	Next
	Return DS
End Sub