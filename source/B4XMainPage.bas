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
	Private fx As JFX
	Private Root As B4XView
	Private Icon1 As B4XView
	Private Icon2 As B4XView
	Private LblText1 As B4XView
	Private LblText As B4XView
	Private imgImage As ImageView
	Private imgBarcode As ImageView
	Private LblLine As B4XView
	Private LblTitle2 As B4XView
	Private LblTitle3 As B4XView
	Private LblTitle4 As B4XView
	Private TxtValue4 As B4XView
	Private CmbValue2 As B4XComboBox
	Private CmbValue3 As B4XComboBox
	Private CLV1 As CustomListView
	Private CLV2 As CustomListView
	Private CLV3 As CustomListView
	Private DragSceneY As Double
	Private SBV As JavaObject
	Private Justify As String
	Private SelectedLine As Int
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
		DB.Insert2(Array(12, "", 1, 1))
		DB.Insert2(Array(13, "", 1, 1))
		DB.Insert2(Array(14, "", 1, 1))
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
		CLV1.Add(CreateListItem1(item, CLV1.AsView.Width, 70dip), item)
		Select True
			Case item.Text.Contains("[LEFT]")
				Justify = "LEFT"
			Case item.Text.Contains("[CENTER]")
				Justify = "CENTER"
			Case item.Text.Contains("[RIGHT]")
				Justify = "RIGHT"
		End Select
		If item.Active Then CLV2.Add(CreateListItem2(item, CLV2.AsView.Width), item)
	Next
	DB.Close
	EnableDragScroll(CLV2)
	Dim Values As List = Array As String("Ascii", "Unicode", "Image", "Barcode", "QRCode")
	Dim Titles As List = Array As String("Line: Not selected", "Type", "Visible", "Value", "", "", "", "")
	Dim TypeViews As List = Array As String("Label", "Option1", "Option2", "Input", "ButtonAddDelete", "ButtonMove1", "ButtonMove2", "ButtonSavePrint")
	For i = 0 To 7
		If i = 1 Then
			CLV3.Add(CreateListItem3(CreateLineProp(Titles.Get(i), TypeViews.Get(i), Values), CLV3.AsView.Width), i)
		Else If i = 2 Then
			CLV3.Add(CreateListItem3(CreateLineProp(Titles.Get(i), TypeViews.Get(i), Array("False", "True")), CLV3.AsView.Width), i)
		Else
			CLV3.Add(CreateListItem3(CreateLineProp(Titles.Get(i), TypeViews.Get(i), Null), CLV3.AsView.Width), i)
		End If
	Next
End Sub

' Enable click-and-drag scrolling for a CustomListView
Private Sub EnableDragScroll (clv As CustomListView)
	Dim spJO As JavaObject = clv.sv
	'Attach all event filters in one go
    AddEventFilter(spJO, "MOUSE_PRESSED", "SPPressed")
    AddEventFilter(spJO, "MOUSE_RELEASED", "SPReleased")
    AddEventFilter(spJO, "MOUSE_DRAGGED", "SPDragged")
	'Cache the vertical scrollbar for later calculations
    Sleep(0) ' wait for UI to build
    SBV = GetScrollBar(spJO, "VERTICAL")
End Sub

' Utility to attach JavaFX event filters
Private Sub AddEventFilter (target As JavaObject, eventName As String, handlerName As String)
    Dim EventHandler As Object = target.CreateEvent("javafx.event.EventHandler", handlerName, Null)
    Dim MouseEvent As JavaObject
    MouseEvent.InitializeStatic("javafx.scene.input.MouseEvent")
    target.RunMethod("addEventFilter", Array(MouseEvent.GetField(eventName), EventHandler))
End Sub

' Utility to get a ScrollBar JavaObject
Public Sub GetScrollBar (Node As JavaObject, Orientation As String) As JavaObject
    Dim SBSet As JavaObject = Node.RunMethod("lookupAll", Array(".scroll-bar"))
    Dim Iterator As JavaObject = SBSet.RunMethod("iterator", Null)
    Do While Iterator.RunMethod("hasNext", Null)
        Dim SB As JavaObject = Iterator.RunMethod("next", Null)
        Dim SBOrientation As String = SB.RunMethodJO("getOrientation", Null).RunMethod("toString", Null)
        If SBOrientation = Orientation.ToUpperCase Then Return SB
    Loop
    Return SB
End Sub

' Event Handlers
Private Sub SPPressed_Event (MethodName As String, Args() As Object)
    Dim Event As JavaObject = Args(0)
    DragSceneY = Event.RunMethod("getY", Null)
End Sub

Private Sub SPReleased_Event (MethodName As String, Args() As Object)
    Dim SP As ScrollPane = Sender
    'SP.MouseCursor = fx.Cursors.DEFAULT
    If Initialized(SP.MouseCursor) And SP.MouseCursor = fx.Cursors.MOVE Then SP.MouseCursor = fx.Cursors.DEFAULT
End Sub

Private Sub SPDragged_Event (MethodName As String, Args() As Object)
    Dim SP As ScrollPane = Sender
    SP.MouseCursor = fx.Cursors.MOVE
    Dim Event As JavaObject = Args(0)
    Dim ThisY As Double = Event.RunMethod("getY", Null)
    Dim contentHeight As Double = SP.InnerNode.PrefHeight
    Dim visibleHeight As Double = SBV.RunMethod("getVisibleAmount", Null) * contentHeight
    SP.VPosition = SP.VPosition + (DragSceneY - ThisY) / (contentHeight - visibleHeight)
    DragSceneY = ThisY
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
		Case "Label"
			p.LoadLayout("Property1")
			LblLine.Text = Data.Title
			Height = 40dip
		Case "Option1"
			p.LoadLayout("Property2")
			LblTitle2.Text = Data.Title
			CmbValue2.SetItems(Data.Values)
			Height = 40dip
		Case "Option2"
			p.LoadLayout("Property3")
			LblTitle3.Text = Data.Title
			CmbValue3.SetItems(Data.Values)
			Height = 40dip
		Case "Input"
			p.LoadLayout("Property4")
			LblTitle4.Text = Data.Title
			TxtValue4.Text = ""
			Height = 40dip
		Case "ButtonMove1"
			p.LoadLayout("Property5")
			Height = 70dip
		Case "ButtonMove2"
			p.LoadLayout("Property6")
			Height = 70dip
		Case "ButtonAddDelete"
			p.LoadLayout("Property7")
			Height = 70dip
		Case "ButtonSavePrint"
			p.LoadLayout("Property8")
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

Private Sub BtnMoveTop_Click
	
End Sub

Private Sub BtnMoveBottom_Click
	
End Sub

Private Sub CLV1_ItemClick (Index As Int, Value As Object)
	CLV1.GetPanel(SelectedLine).Color = xui.Color_Transparent
	CLV1.GetPanel(Index).Color = xui.Color_RGB(126, 180, 250)
	SelectedLine = Index
	LblLine.Text = "Line: " & (Index + 1)
	Dim Data As LineItem = Value 
	CmbValue2.SelectedIndex = Data.TypeId - 1
	CmbValue3.SelectedIndex = IIf(Data.Active, 1, 0)
	TxtValue4.Text = Data.Text
End Sub

Private Sub CLV2_ItemClick (Index As Int, Value As Object)
	CLV1_ItemClick(Index, Value)
	'Log(Value)
End Sub