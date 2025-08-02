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
	Public DB As SQL
	Private xui As XUI
	Private Root As B4XView
	Private DBDir As String
	Private DBFile As String
	'Private chkItem As B4XView
	'Private imgItem As B4XImageView
	'Private lblFirstLine As B4XView
	'Private lblSecondLine As B4XView
	Private Label1 As B4XView
	Private Label2 As B4XView
	Private Label3 As B4XView
	Private CLV1 As CustomListView
End Sub

Public Sub Initialize
'	B4XPages.GetManager.LogEvents = True
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("MainPage")
	For i = 0 To 9
		CLV1.Add(CreateListItem("", CLV1.AsView.Width, 70dip), i)
	Next
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

'Private Sub CreateListItem (FirstLine As String, SecondLine As String, Width As Int, Height As Int) As B4XView
'	Dim p As B4XView = xui.CreatePanel("")
'	p.LoadLayout("ListItem")
'	p.SetLayoutAnimated(0, 0, 0, Width, Height)
'	imgItem.Bitmap = xui.LoadBitmapResize(File.DirAssets, "icon.png", 40dip, 40dip, True)
'	lblFirstLine.Text = FirstLine
'	lblSecondLine.Text = SecondLine
'	Return p
'End Sub

Private Sub CreateListItem (FirstLine As String, Width As Int, Height As Int) As B4XView
	Dim p As B4XView = xui.CreatePanel("")
	p.LoadLayout("LineItem")
	p.SetLayoutAnimated(0, 0, 0, Width, Height)
	Label2.Text = FirstLine
	Return p
End Sub