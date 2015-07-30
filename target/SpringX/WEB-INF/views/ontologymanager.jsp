<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
   "http://www.w3.org/TR/html4/strict.dtd">

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>本体管理</title>
		<script src="/SpringX/static/basic_js/jquery.min.js"></script>
		<!-- // <script src="/SpringX/static/bootstrap/js/bootstrap.min.js"></script> -->
		<link href="/SpringX/static/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
		<link href="/SpringX/static/flat_ui/dist/css/vendor/bootstrap.min.css" rel="stylesheet">
		<link href="/SpringX/static/flat_ui/dist/css/flat-ui.min.css" rel="stylesheet">
		<script src="/SpringX/static/flat_ui/dist/js/vendor/video.js"></script>
		<!-- // <script src="/SpringX/static/flat_ui/dist/js/flat-ui.min.js"></script> -->
		<script src="/SpringX/static/basic_js/jsrender.min.js"></script>

		<script src="/SpringX/static/jstree/dist/jstree.min.js"></script>

		<script type="text/javascript">
			
		</script>
	</head>

	<body style="padding:0px; background-color:#f4f6f4">
		<nav class="navbar navbar-inverse" role="navigation">
			<div class="container-fluid">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
						<span class="sr-only">Toggle navigation</span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
					<a class="navbar-brand" href="/">Logo</a>
				</div>
				<div id="navbar" class="navbar-collapse collapse">
					<ul class="nav navbar-nav navbar-left">
						<li><a href="">在线问诊</a></li>
						<li><a href="">规则管理</a></li>
						<li><a href="">使用指南</a></li>
					</ul>
					<ul class="nav navbar-nav navbar-right">
						<li><a href="">建议</a></li>
						<li><a href="">关于</a></li>
					</ul>
				</div>
			</div>
		</nav>

		<div class="container bs-docs-container">
			<div class="row">
				<div class="panel panel-default col-md-12">
					<div class="panel-body" role="main" id="top">
						<div id="add_rule_section" class="bs-docs-section">
							<h4 id="add_rule_title" class="page-header">添加规则</h4>
							<div id="test">

							</div>
							<br />
						</div>
						<div class="bs-docs-section">
							<h4 class="page-header">浏览规则</h4>
							
							<div class="col-sm-8 col-sm-offset-2">
								
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<!-- /.container -->
		<!--script src="/SpringX/static/flat_ui/dist/js/vendor/jquery.min.js"></script-->
		<script src="/SpringX/static/flat_ui/dist/js/flat-ui.min.js"></script>
		<script src="/SpringX/static/flat_ui/docs/assets/js/application.js"></script>
		<script src="/SpringX/static/flat_ui/js/jquery-ui-1.10.0.custom.min.js"></script>
		<script src="/SpringX/static/flat_ui/js/jquery.dropkick-1.0.0.js"></script>
		<script src="/SpringX/static/flat_ui/js/custom_checkbox_and_radio.js"></script>
		<script src="/SpringX/static/flat_ui/js/custom_radio.js"></script>
		<!-- <script src="/SpringX/static/flat_ui/js/bootstrap-tooltip.js"></script> -->
		<script src="/SpringX/static/flat_ui/js/jquery.tagsinput.js"></script>
		
		<footer class="footer">
			 <div class="container">
				<div class="row footer-bottom">
				  <ul class="list-inline text-center">
					<li><a href="">PKU SEI</a> Version : 0.4</li>
				  </ul>
				</div>
			 </div>
		</footer>
		<script type="text/javascript">

			$(':checkbox').radiocheck();
			$(':radio').radiocheck('check');
			$("select").select2({dropdownCssClass: 'dropdown-inverse'});
			$(".tagsinput").tagsinput();

		</script>

		<script>
		videojs.options.flash.swf = "/SpringX/static/flat_ui/dist/js/vendors/video-js.swf";
		</script>
	</body>
</html>
