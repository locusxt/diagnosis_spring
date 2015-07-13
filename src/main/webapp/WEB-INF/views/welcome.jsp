<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>HelloWorld page</title>
<script src="http://libs.baidu.com/jquery/1.9.0/jquery.js"></script>
</head>
<body>
    Greeting : ${greeting}
<script type="text/javascript">
$(function() {
	getjson();
});

function getjson() {
	$.ajax( {
		type : "get",
		url : "json.do",
		dataType:"json",
		success : function(msg) {
			alert("Data Saved: " + msg.name+"--"+msg.staffName);
		}
	});
}
</script>
</body>
</html>

