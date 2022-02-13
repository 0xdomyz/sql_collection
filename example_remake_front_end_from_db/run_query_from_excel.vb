Sub invoice_title()
Call runqry("sql", 1, 2, "invoice", 6, 2)
End Sub


Sub runqry( _
  ByVal ipt_t As String, ByVal ipt_r As Integer, ByVal ipt_c As Integer, _
  ByVal opt_t As String, ByVal opt_r As Integer, ByVal opt_c As Integer)

Dim conn As Object, rst As Object

Set conn = CreateObject("ADODB.Connection")
Set rst = CreateObject("ADODB.Recordset")

' OPEN CONNECTION
conn.Open "DRIVER=SQLite3 ODBC Driver;Database=D:\sqlite\sqlite_tute\chinook.db;"

strSQL = ThisWorkbook.Sheets(ipt_t).Cells(ipt_r, ipt_c).Value

' OPEN RECORDSET
rst.Open strSQL, conn, 1, 1

' OUTPUT TO WORKSHEET
Worksheets(opt_t).Cells(opt_r, opt_c).CopyFromRecordset rst
rst.Close

' FREE RESOURCES
Set rst = Nothing: Set conn = Nothing


End Sub

