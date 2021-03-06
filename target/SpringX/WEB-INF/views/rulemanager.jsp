<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
   "http://www.w3.org/TR/html4/strict.dtd">

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>规则管理</title>
		<script src="/SpringX/static/basic_js/jquery.min.js"></script>
		<!-- // <script src="/SpringX/static/bootstrap/js/bootstrap.min.js"></script> -->
		<link href="/SpringX/static/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
		<link href="/SpringX/static/flat_ui/dist/css/vendor/bootstrap.min.css" rel="stylesheet">
		<link href="/SpringX/static/flat_ui/dist/css/flat-ui.min.css" rel="stylesheet">
        <script src="/SpringX/static/flat_ui/dist/js/vendor/video.js"></script>
        <!-- // <script src="/SpringX/static/flat_ui/dist/js/flat-ui.min.js"></script> -->
        <script src="/SpringX/static/basic_js/jsrender.min.js"></script>

		<script type="text/javascript">
			var new_rule = {};
			var new_rule_name;
			var new_rule_terms = [];
			var new_rule_hterms = [];

			var add_term_type = "term";
			var gen_term_type = "standard";


			function tmpl_render_html(tmpl, target, d){
				var html = $(tmpl).render(d);
				$(target).html(html);
			}

			function ajax_post_json(target, json){
				$.ajax({
				  type: 'POST',
				  url: target,
				  data: JSON.stringify (json), // or JSON.stringify ({name: 'jonas'}),
				  //success: function(d) { alert('data: ' + d); },
				  contentType: "application/json",
				  dataType: 'text'
				});
			}

			function get_complaints(){
				$.ajax( {
					type : "get",
					url : "ajax/get_complaints.do",
					dataType:"json",
					success : function(json) {
						chief_complaint_list = json.complaintList;
					}
				});
			}

			function post_basicinfo(){
				$.ajax({
				  type: 'POST',
				  url: "ajax/post_basicinfo",
				  data: JSON.stringify ({name: 'haha'}), // or JSON.stringify ({name: 'jonas'}),
				  //success: function(d) { alert('data: ' + d); },
				  contentType: "application/json",
				  dataType: 'json'
				});
			}

			function node2str(n){
				switch (n[0]){
					case 'VAR':
						return "?" + n[1];
					case 'TYPE':
						if (n[1].indexOf(':') < 0)
							return 'ns:' + n[1];
						else
							return n[1];
					default:
						return n[1];
				}
			}

			function term2str(t){
				switch (t[0]){
					case "builtin":
						str = t[1];
						varlist = t[2].split(",");
						str += "(";
						for (var i = 0; i < varlist.length; i++){
							if (isNaN(varlist[i]))
								str += "?";
							str += varlist[i];
							if (i != varlist.length - 1) str += ",";
						}
						str += ")";
						break;
					case "custom":
						str = t[1];
						break;
					default:
						str = "(";
						for (var i = 0; i < 3; ++i){
							str += node2str(t[i]);
							if (i != 2) str += ", ";
						}
						str += ")";
				}
				return str;
			}

			function term2rstr(t){
				switch (t[0]){
					case "builtin":
						str = t[1];
						varlist = t[2].split(",");
						str += "(";
						for (var i = 0; i < varlist.length; i++){
							str += varlist[i];
							if (i != varlist.length - 1) str += ",";
						}
						str += ")";
						break;
					case "custom":
						str = t[1];
						break;
					default:
						str = "";
						for (var i = 0; i < 3; ++i){
							str += t[i][1];
							if (i != 2) str += " "; 
						}
				}
				return str;
			}

			function refresh_terms_table(){
				$('#terms_table').html('');
				str = "<tr><th>term</th><th>原型</th><th>删除</th></tr>";
				for (var i = 0; i < new_rule_terms.length; i++){
					str += "<tr><td>";
					str += term2str(new_rule_terms[i]);
					str += "</td><td>";
					str += term2rstr(new_rule_terms[i]);
					str += "</td><td>";
					str += "<a href='#' onclick='del_term(" + i + ");'><span>delete</span></a>"
					str += "</td></tr>";
					// console.log(str);
				}
				$('#terms_table').html(str);
				$('#hterms_table').html('');
				str = "<tr><th>hterm</th><th>原型</th><th>删除</th></tr>";
				for (var i = 0; i < new_rule_hterms.length; i++){
					str += "<tr><td>";
					str += term2str(new_rule_hterms[i]);
					str += "</td><td>";
					str += term2rstr(new_rule_hterms[i]);
					str += "</td><td>";
					str += "<a onclick='del_hterm(" + i + ");'><span>delete</span></a>"
					str += "</td></tr>";
				}
				$('#hterms_table').html(str);
				gen_rule();
			}

			function gen_rule(){
				str = "[";
				rule_name = $('#input_rule_name').val();
				if (rule_name != '')
					str += rule_name + ": ";
				for (var i = 0; i < new_rule_terms.length; i++){
					str += term2str(new_rule_terms[i]);
				}
				str += "->";
				for (var i = 0; i < new_rule_hterms.length; i++){
					str += term2str(new_rule_hterms[i]);
				}
				str += "]";
				$('#preview_rule').html(str);
				return str;
			}

			function del_term(id){
				new_rule_terms.splice(id, 1);
				refresh_terms_table();
			}

			function del_hterm(id){
				new_rule_hterms.splice(id, 1);
				refresh_hterms_table();
			}

			function add_rule(new_rule){
				str = "{\"type\":\"add\", \"rule\":\"" + new_rule + "\"}";
				//console.log(str);
				jQuery.ajax( {  
		          type : 'POST',  
		          contentType : 'application/json',  
		          url : 'ajax/ruleManage',  
		          data : str,  
		          dataType : 'json',  
		          success : function(data) {  
		            alert("新增成功！");  
		          },  
		          error : function(data) {  
		            alert("error")  
		          }  
		        });  
			}

			function list_rules(){
				$.ajax( {
					type : "get",
					url : "ajax/get_complaints.do",
					dataType:"json",
					success : function(json) {
						chief_complaint_list = json.complaintList;
					}
				});
			}

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
							<div>
								<form class="form-horizontal">
									<div class="control-group">
										<label class="control-label col-sm-2" for="input_rule_name">name:</label>
										<div class="col-sm-6">
											<input onchange="gen_rule();" id="input_rule_name" class="form-control input-large" type="text" placeholder="输入规则名"></input>
										</div>
									</div>
									<br />
									<br />
									<div class="control-group">
										<label class="control-label col-sm-2" >terms:</label>
										<div class="col-sm-10">
											<!-- <a href="" data-toggle="modal" data-target="#new_term_modal"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span></a> -->
											<a href="" onclick="add_term_type='term';" data-toggle="modal" data-target="#new_term_modal"><span aria-hidden="true">点击新建term</span></a>
											<div>
												<div class="col-sm-9">
													<table id="terms_table" class="table">
														
													</table>
												</div>
											</div>
										</div>
									</div>
									<br />
									<br />
									<div class="control-group">
										<label class="control-label col-sm-2" >hterms:</label>
										<div class="col-sm-10">
											<!-- <a href="" data-toggle="modal" data-target="#new_term_modal"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span></a> -->
											<a href="" onclick="add_term_type='hterm';" data-toggle="modal" data-target="#new_term_modal"><span aria-hidden="true">点击新建hterm</span></a>
											<div>
												<div class="col-sm-9">
													<table id="hterms_table" class="table">
														
													</table>
												</div>
											</div>
										</div>
									</div>
									<br />
									<br />
									<div class="control-group">
										<label class="control-label col-sm-2" >preview:</label>
										<div class="col-sm-10">
											<div class="col-sm-12">
												<p id="preview_rule"></p>
											</div>
										</div>
									</div>
								</form>
							</div>
							<br />
						</div>
					</div>
				</div>
			</div>
		</div>



		<!-- add new term Modal -->
		<div class="modal fade" id="new_term_modal" tabindex="-1" role="dialog" aria-labelledby="new_term_label" aria-hidden="true">
		  <div class="modal-dialog">
			<div class="modal-content">
			  <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h4 class="modal-title" id="new_term_label">新建term</h4>
			  </div>
			  <div class="modal-body" id="new_term_body">
				<div>
				  <!-- Nav tabs -->
				  <ul class="nav nav-tabs" role="tablist">
				    <li role="presentation" class="active"><a onclick="gen_term_type='standard';" href="#standard_term" aria-controls="standard_term" role="tab" data-toggle="tab">standard</a></li>
				    <li role="presentation"><a onclick="gen_term_type='builtin';" href="#builtin_term" aria-controls="builtin_term" role="tab" data-toggle="tab">builtin</a></li>
				    <li role="presentation"><a onclick="gen_term_type='custom';" href="#custom_term" aria-controls="custom_term" role="tab" data-toggle="tab">custom</a></li>
				  </ul>

				  <!-- Tab panes -->
				  <div class="tab-content">
				    <div role="tabpanel" class="tab-pane active" id="standard_term">
				    	<br />
				    	<script type="text/javascript">
							function gen_node_input(nodeid){
								str = "<div class=col-sm-12><div class=input-group><div class=input-group-btn><select id=ntype" + nodeid + " class='form-control select select-primary'><option value=VAR >变量</option><option value=TYPE >关系</option><option value=NUM >数字</option><option value=OTHER >其他</option></select></div><input type=text class=form-control id=ncontent" + nodeid + " /></div><br /></div><br /><br />";
								document.write(str);
							}

							function gen_standard_term(){
								var nodes = new Array(3);
								for (var i = 0; i < 3; ++i){
									var type = $('#ntype' + i).val();
									var content = $('#ncontent' + i).val();
									$('#ncontent' + i).val('');
									nodes[i] = [type, content];
								}
								if (add_term_type == "term")
									new_rule_terms.push(nodes);
								else
									new_rule_hterms.push(nodes);
							}
							gen_node_input(0);
							gen_node_input(1);
							gen_node_input(2);
						</script>
				    </div>
				    <div role="tabpanel" class="tab-pane" id="builtin_term">
				    	<script type="text/javascript">
					    	function gen_builtin_term(){
					    		var nodes = new Array(3);
					    		nodes[0] = "builtin";
					    		nodes[1] = $("#builtin_type").val();
					    		nodes[2] = $("#builtin_vars").val();
					    		$("#builtin_vars").val('');
					    		if (add_term_type == "term")
									new_rule_terms.push(nodes);
								else
									new_rule_hterms.push(nodes);
					    	}
				    	</script>
				    	<br />
				    	<div class="col-sm-12">
				    		<div class="input-group">
				    			<div class="input-group-btn">
				    				<select id="builtin_type" class="form-control select select-primary">
				    					<option value="le">le</option>
				    					<option value="ge">ge</option>
				    					<option value="sum">sum</option>
				    				</select>
				    			</div>
				    			<input type="text" class="form-control" id="builtin_vars" placeholder="参数请以半角逗号分开"></input>
				    		</div>
				    	</div>
				    	<br />
				    	<br />
				    </div>
				    <div role="tabpanel" class="tab-pane" id="custom_term">
				    	<script type="text/javascript">
				    		function gen_custom_term(){
				    			var nodes = new Array(2);
				    			nodes[0] = "custom";
				    			nodes[1] = $("#input_custom_term").val();
				    			$("#input_custom_term").val("");
				    			if (add_term_type == "term")
									new_rule_terms.push(nodes);
								else
									new_rule_hterms.push(nodes);
				    		}
				    	</script>
				    	<br />
				    	<div class="col-sm-12">
				    		<div>
				    			<label>请输入自定义规则：</label>
				    			<input type="text" class="form-control" id="input_custom_term" placeholder=""></input>
				    		</div>
				    		<br />
				    	</div>
				    	<br />
				    	<br />
				    </div>
				  </div>

				</div>
			  </div>
			  <div class="modal-footer">
			  	<script type="text/javascript">
			  		function gen_new_term(){
			  			switch(gen_term_type){
			  				case "standard":
			  					gen_standard_term();
			  					break;
			  				case "builtin":
			  					gen_builtin_term();
			  					break;
			  				case "custom":
			  					gen_custom_term();
			  					break;
			  			}
			  			refresh_terms_table();
			  		}
			  	</script>
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" onclick="gen_new_term();" data-dismiss="modal">保存</button>
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
        refresh_terms_table();
        </script>

	</body>
</html>