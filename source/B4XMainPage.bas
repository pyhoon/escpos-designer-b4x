B4A=true
Group=Pages
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
#Macro: Title, Export, ide://run?File=%B4X%\Zipper.jar&Args=%PROJECT_NAME%.zip
#Macro: Title, GitHub, ide://run?file=%WINDIR%\System32\cmd.exe&Args=/c&Args=github&Args=..\..\
#Macro: Title, Sync Files, ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
'#Macro: Title, JsonLayouts folder, ide://run?File=%WINDIR%\explorer.exe&Args=%PROJECT%\JsonLayouts
'#Macro: After Save, Sync Layouts, ide://run?File=%ADDITIONAL%\..\B4X\JsonLayouts.jar&Args=%PROJECT%&Args=%PROJECT_NAME%
'#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
#End Region

Sub Class_Globals
	Public DB As MiniORM
	Private Conn As ORMConnector
	Private xui As XUI
	Private Root As B4XView
	Private Icon1 As B4XView
	Private Icon2 As B4XView
	Private LblText1 As B4XView
	Private LblText As B4XView
	Private imgImage As ImageView
	Private imgBarcode As ImageView
	Private LblTitle As B4XView
	Private TxtValue As B4XView
	Private CmbValue As B4XComboBox
	Private CLV1 As CustomListView
	Private CLV2 As CustomListView
	Private CLV3 As CustomListView
	Private Justify As String
	Type LineItem (Text As String, TypeId As Int, Active As Boolean)
	Type LineProp (Title As String, TypeView As String, Values As List)
End Sub

Public Sub Initialize
'	B4XPages.GetManager.LogEvents = True
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("MainPage")
	B4XPages.SetTitle(Me, "Receipt Editor")
	Conn.Initialize(CreateConnInfo)
	If Conn.DBExist = False Then
		Wait For (Conn.DBCreate) Complete (Success As Boolean)
		Log(Success)
		DB.Initialize(DBType, DBOpen)
		DB.QueryAddToBatch = True
		DB.ShowExtraLogs = True

		DB.Table = "Tags"
		DB.Columns.Add(DB.CreateColumn2(CreateMap("Name": "Text")))
		DB.Create
		DB.Columns = Array("Text")
		Dim Tags As Map = EscPos.Tags
		For Each key As String In Tags.Keys
			DB.Insert2(Array(key))
		Next
		
		DB.Table = "Types"
		DB.Columns.Add(DB.CreateColumn2(CreateMap("Name": "Text")))
		DB.Columns.Add(DB.CreateColumn2(CreateMap("Encoding": "Text")))
		DB.Create
		DB.Columns = Array("Text", "Encoding")
		DB.Insert2(Array("Ascii", "CP437"))
		DB.Insert2(Array("Unicode", "UTF8"))
		DB.Insert2(Array("Image", ""))
		DB.Insert2(Array("Barcode", "ASCII"))
		DB.Insert2(Array("QRCode", "ISO-8859-1"))
		
		DB.Table = "Settings"
		DB.Columns.Add(DB.CreateColumn2(CreateMap("Name": "Name")))
		DB.Columns.Add(DB.CreateColumn2(CreateMap("Name": "Key")))
		DB.Columns.Add(DB.CreateColumn2(CreateMap("Name": "Value")))
		DB.Columns.Add(DB.CreateColumn2(CreateMap("Name": "Active", "Type": DB.INTEGER, "Default": 1)))
		DB.Create
		DB.Columns = Array("Name", "Key", "Value", "Active")
		DB.Insert2(Array("Auto Line Feed", "LINEFEED", 1, 1))
		
		DB.Table = "Lines"
		DB.Columns.Add(DB.CreateColumn2(CreateMap("Name": "seq", "Type": DB.INTEGER)))
		DB.Columns.Add(DB.CreateColumn2(CreateMap("Name": "Text")))
		DB.Columns.Add(DB.CreateColumn2(CreateMap("Name": "Type", "Type": DB.INTEGER, "Default": 1)))
		DB.Columns.Add(DB.CreateColumn2(CreateMap("Name": "Active", "Type": DB.INTEGER, "Default": 1)))
		DB.Create
		DB.Columns = Array("seq", "Text", "Type", "Active")
		DB.Insert2(Array(1, "[CENTER]", 1, 1)) ' Auto Linefeed
		DB.Insert2(Array(2, "%LOGO%", 3, 1))
		DB.Insert2(Array(3, "R E C E I P T", 1, 1))
		DB.Insert2(Array(5, "================================", 1, 1))
		DB.Insert2(Array(6, "[LEFT]  Date: 2025-08-04", 1, 1))
		DB.Insert2(Array(7, "[RIGHT]TOTAL: MYR 99.25", 1, 1))
		DB.Insert2(Array(8, "[CENTER]中文字体", 2, 1))
		DB.Insert2(Array(9, "9236320210046", 4, 1))
		DB.Insert2(Array(10, "", 1, 1))
		DB.Insert2(Array(11, "www.b4x.com", 5, 1))
		DB.Insert2(Array(12, "[LINEFEED]", 1, 1))
		DB.Insert2(Array(13, "[LINEFEED]", 1, 1))
		DB.Insert2(Array(14, "[LINEFEED]", 1, 1))
		DB.Insert2(Array(15, "[FULLCUT]", 1, 1))
		
		Wait For (DB.ExecuteBatch) Complete (Success As Boolean)
		If Success Then
			Log(Success)
		Else
			Log(LastException)
		End If
		DBClose
	End If
	
	DB.Initialize(DBType, DBOpen)
	DB.Table = "Lines"
	DB.OrderBy = CreateMap("seq": "")
	DB.Query
	For Each row As Map In DB.Results
		Dim item As LineItem = CreateLineItem(row.Get("Text"), row.Get("Type").As(Int), row.Get("Active").As(Int) = 1)
		CLV1.Add(CreateListItem1(item, CLV1.AsView.Width, 70dip), row.Get("seq"))
		Select True
			Case item.Text.Contains("[LEFT]")
				Justify = "LEFT"
			Case item.Text.Contains("[CENTER]")
				Justify = "CENTER"
			Case item.Text.Contains("[RIGHT]")
				Justify = "RIGHT"
		End Select
		If item.Active Then CLV2.Add(CreateListItem2(item, CLV2.AsView.Width), row.Get("seq"))
	Next
	DB.Close
	Dim Values As List = Array("Ascii", "Unicode", "Image", "Barcode", "QRCode")
	CLV3.Add(CreateListItem3(CreateLineProp("Type", "Option", Values), CLV3.AsView.Width), 1)
	CLV3.Add(CreateListItem3(CreateLineProp("Visible", "Option", Array("True", "False")), CLV3.AsView.Width), 2)
	CLV3.Add(CreateListItem3(CreateLineProp("Value", "Input", Null), CLV3.AsView.Width), 3)
	CLV3.Add(CreateListItem3(CreateLineProp("", "ButtonMove", Null), CLV3.AsView.Width), 4)
	CLV3.Add(CreateListItem3(CreateLineProp("", "ButtonSave", Null), CLV3.AsView.Width), 4)
	CLV3.Add(CreateListItem3(CreateLineProp("", "ButtonPrint", Null), CLV3.AsView.Width), 4)
End Sub

Private Sub CreateConnInfo As ConnectionInfo
	Dim con As ConnectionInfo
	con.Initialize
	con.DBType = "SQLITE"
	Return con
End Sub

Private Sub DBType As String
	Return Conn.DBType
End Sub

Private Sub DBOpen As SQL
	Return Conn.DBOpen
End Sub

Private Sub DBClose
	Conn.DBClose
End Sub

#If B4A
Private Sub B4XPage_KeyPress (KeyCode As Int) As Boolean 'ignore
	Select KeyCode
		Case KeyCodes.KEYCODE_BACK
			'code to handle back key
		Case KeyCodes.KEYCODE_VOLUME_DOWN, KeyCodes.KEYCODE_VOLUME_UP
			'code to handle volume keys
		Case KeyCodes.KEYCODE_MEDIA_PLAY_PAUSE
			'code to handle media button
		Case Else
			Return False 'Pass to Android System
	End Select
End Sub

Private Sub B4XPage_CloseRequest As ResumableSub
	'If Drawer.LeftOpen Then
	'	Drawer.LeftOpen = False
	'	Return False
	'End If
	Return True
End Sub
#End If

Private Sub CreateListItem1 (Data As LineItem, Width As Int, Height As Int) As B4XView
	Dim p As B4XView = xui.CreatePanel("")
	p.LoadLayout("LineItem1")
	p.SetLayoutAnimated(0, 0, 0, Width, Height)
	Select Data.TypeId
		Case 5 ' QR
			Icon1.Text = Chr(0xF029)
		Case 4 ' Barcode
			Icon1.Text = Chr(0xF02A)
		Case 3 ' Image
			Icon1.Text = Chr(0xF1C5)
		Case 2 ' Unicode
			Icon1.Text = Chr(0xF1AB)
		Case Else ' Text
			Icon1.Text = Chr(0xF031)
	End Select
	If Data.Active Then
		Icon2.Text = Chr(0xF06E)
	Else
		Icon2.Text = Chr(0xF070)
	End If
	LblText1.Text = Data.Text
	Return p
End Sub

Private Sub CreateListItem2 (Data As LineItem, Width As Int) As B4XView
	Dim Value As String = Data.Text
	Value = Value.Replace("[LEFT]", "")
	Value = Value.Replace("[LEFT]", "")
	Value = Value.Replace("[CENTER]", "")
	Value = Value.Replace("[RIGHT]", "")
	Value = Value.Replace("[LINEFEED]", "")
	Dim Height As Int
	Dim p As B4XView = xui.CreatePanel("")
	Select Data.TypeId
		Case 5 ' QR
			p.LoadLayout("LineType5")
			Height = 100dip
		Case 4 ' Barcode
			p.LoadLayout("LineType4")
			Height = 60dip
		Case 3 ' Image
			p.LoadLayout("LineType3")
			Height = 100dip
		Case 2 ' Unicode
			p.LoadLayout("LineType2")
			Height = 40dip
			LblText.Text = Value
			LblText.SetTextAlignment("CENTER", Justify)
		Case Else ' Text
			p.LoadLayout("LineType1")
			Height = 40dip
			LblText.Text = Value
			LblText.SetTextAlignment("CENTER", Justify)
	End Select
	Select Justify
		Case "LEFT", "CENTER", "RIGHT"
			LblText.SetTextAlignment("CENTER", Justify)
		Case Else
			LblText.SetTextAlignment("CENTER", "LEFT")
	End Select
	p.SetLayoutAnimated(0, 0, 0, Width, Height)
	Return p
End Sub

Private Sub CreateListItem3 (Data As LineProp, Width As Int) As B4XView
	Dim Height As Int
	Dim p As B4XView = xui.CreatePanel("")
	Select Data.TypeView
		Case "Option"
			p.LoadLayout("Property1")
			LblTitle.Text = Data.Title
			CmbValue.SetItems(Data.Values)
			Height = 40dip
		Case "Input"
			p.LoadLayout("Property2")
			LblTitle.Text = Data.Title
			TxtValue.Text = "[LEFT]  Date: 2025-08-04"
			Height = 40dip
		Case "ButtonMove"
			p.LoadLayout("Property3")
			Height = 70dip
		Case "ButtonSave"
			p.LoadLayout("Property4")
			Height = 70dip
		Case "ButtonPrint"
			p.LoadLayout("Property5")
			Height = 70dip
	End Select
	p.SetLayoutAnimated(0, 0, 0, Width, Height)
	Return p
End Sub

Public Sub CreateLineItem (Text As String, TypeId As Int, Active As Boolean) As LineItem
	Dim t1 As LineItem
	t1.Initialize
	t1.Text = Text
	t1.TypeId = TypeId
	t1.Active = Active
	Return t1
End Sub

Public Sub CreateLineProp (Title As String, TypeView As String, Values As List) As LineProp
	Dim t1 As LineProp
	t1.Initialize
	t1.Title = Title
	t1.TypeView = TypeView
	t1.Values = Values
	Return t1
End Sub