<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NumFirmantes.aspx.cs" Inherits="LockiproTest.NumFirmantes" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server" action="Default.aspx">
        <div>
            <h1>Número de firmantes</h1>
            <input type="number"  max="10" min="1" value="1"/>
            <br />
            <input type="submit" value="Siguiente"/>
        </div>
    </form>
</body>
</html>
