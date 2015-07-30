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
		
		<!-- <link rel="stylesheet" type="text/css" href="/SpringX/static/zTree/css/zTreeStyle/zTreeStyle.css"> -->
		<link rel="stylesheet" type="text/css" href="/SpringX/static/zTree/css/metroStyle/metroStyle.css">
		<script src="/SpringX/static/zTree/js/jquery.ztree.all-3.5.min.js"></script>

		<script type="text/javascript">
			var setting = {
				showLine: true,
				data:{
					simpleData:{
						enable : true
					}
				},
				edit:{
					enable:true
				},
				view:{
					showIcon:false,
					addHoverDom: addHoverDom,
					removeHoverDom: removeHoverDom
				}
			};
			var nodes = [
				{id:1, pId:0, name:"root"},
				{id:11, pId:1, name:"疾病"},
				{id:12, pId:1, name:"症状"},
				{id:111, pId:11, name:"感冒"}
			];

			var treeA;
			var newCount = 1;
			function addHoverDom(treeId, treeNode) {
				var sObj = $("#" + treeNode.tId + "_span");
				if (treeNode.editNameFlag || $("#addBtn_"+treeNode.tId).length>0) return;
				var addStr = "<span class='button add' id='addBtn_" + treeNode.tId
					+ "' title='add node' onfocus='this.blur();'></span>";
				sObj.after(addStr);
				var btn = $("#addBtn_"+treeNode.tId);
				if (btn) btn.bind("click", function(){
					var zTree = $.fn.zTree.getZTreeObj("test");
					zTree.addNodes(treeNode, {id:(1000 + newCount), pId:treeNode.id, name:"new node" + (newCount++)});
					return false;
				});
			};
			function removeHoverDom(treeId, treeNode) {
				$("#addBtn_"+treeNode.tId).unbind().remove();
			};
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
							<h4 id="add_rule_title" class="page-header">管理本体</h4>
							<div class="row">
								<div class="col-sm-4">
									<div id="test" class="ztree">
										
									</div>
								</div>
								<div class="col-sm-8">
									<p>hahah</p>
								</div>
							</div>
							<br />
						</div>
					</div>
				</div>
			</div>
		</div>

		<script type="text/javascript">
			$(function() {  
			treeA = $.fn.zTree.init($('#test'), setting, nodes);
		 });  
		</script>
		
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
