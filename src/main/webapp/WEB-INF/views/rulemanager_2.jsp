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

			rule_symptom_list = [];
			rule_dataobj_list = [];

			symptom_list = ['toothache', 'headache', 'cough'];
			dataobj_priority_list = ['blood_pressure', 'temperature']


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
									<div class="control-group row">
										<label class="control-label col-sm-2" for="input_rule_name">规则名:</label>
										<div class="col-sm-6">
											<input onchange="gen_rule();" id="input_rule_name" class="form-control input-large" type="text" placeholder="输入规则名"></input>
										</div>
									</div>
									<br />
									<br />
									<div class="control-group row">
										<label class="control-label col-sm-2" >条件:</label>
										<div class="col-sm-10">
											<div>
												同时有以下症状:
												<br />
												<script type="text/javascript">
													function update_symptom(){
														str = "";
														for (var i = 0; i < symptom_list.length; i++){
															str += "<option value=\"" + symptom_list[i] + "\">" + symptom_list[i] + "</option>";
														}
														$('#symptom_select').html(str);
													}
												</script>
												<select id="symptom_select" multiple="multiple" class="form-control multiselect multiselect-primary">
												</select> 
												<script type="text/javascript">
													update_symptom();
												</script>
											</div>
											<br />
											<script type="text/javascript">
												function update_dataobj_priority_select(){
													str = "";
													for (var i = 0; i < dataobj_priority_list.length; ++i){
														str += "<option value=\"" + dataobj_priority_list[i] + "\">" + dataobj_priority_list[i] + "</option>";
													}
													$('#dataobj_priority_select').html(str);
												}

												function update_dataobj_input(){
													data_type = $('#dataobj_type_select').val();
													str = "";
													if (data_type == "range"){
														str = "<input id=\"dataipt1\" type=\"text\" class=\"form-control\">\
											  					<span class=\"input-group-addon\">~</span>\
											  					<input id=\"dataipt2\"type=\"text\" class=\"form-control\">";
													}
													else if(data_type == "lt"){
														str = "<span class=\"input-group-addon\">&lt;</span>\
											  					<input id=\"dataipt\" type=\"text\" class=\"form-control\">";
													}
													else if(data_type == "gt"){
														str = "<span class=\"input-group-addon\">&gt;</span>\
											  					<input id=\"dataipt\" type=\"text\" class=\"form-control\">";
													}
													$('#dataobj_input').html(str);
												}

												function add_dataobj(){
													new_dataobj = [];
													priority = $('#dataobj_priority_select').val();
													dataobj_type = $('#dataobj_type_select').val();
													new_dataobj.push(priority);
													new_dataobj.push(dataobj_type);
													if (dataobj_type == "range"){
														if ($('#dataipt1').val() == "" || $('#dataipt2').val() == ""){
															alert("请填写完整再添加");
															return;
														}
														d1 = $('#dataipt1').val();
														d2 = $('#dataipt2').val();
														if ( parseInt(d1) > parseInt(d2) ){
															alert("下界应小于上界");
															return;
														}
														new_dataobj.push($('#dataipt1').val());
														new_dataobj.push($('#dataipt2').val());
													}
													else{
														if ($('#dataipt').val() == ""){
															alert("请填写完成再添加");
															return;
														}
														new_dataobj.push($('#dataipt').val());
													}
													rule_dataobj_list.push(new_dataobj);
													update_dataobj_table();
												}

												function dataobj2rstr(dobj){
													str = dobj[0];
													if (dobj[1] == "range"){
														str += " : " + dobj[2] + " ~ " + dobj[3];
													}
													else if (dobj[1] == "lt"){
														str += " < " + dobj[2];
													}
													else if (dobj[1] == "gt"){
														str += " > " + dobj[2];
													}
													return str;
												}

												function update_dataobj_table(){
													str = "";
													for (var i = 0; i < rule_dataobj_list.length; ++i){
														str += "<tr><td>";
														str += dataobj2rstr(rule_dataobj_list[i]);
														str += "</td><td>"
														str += "<a href=\"javascript:void(0);\" onclick=\"del_dataobj(" + i +");\">删除</a>";
														str += "</td></tr>";
													}
													$('#dataobj_table').html(str);
												}

												function del_dataobj(id){
													rule_dataobj_list.splice(id, 1);
													update_dataobj_table();
												}
											</script>
											<div>
												同时满足以下条件：
												<div id="dataobj_content">
													<table id="dataobj_table" class="table">
														
													</table>
												</div>
												<br />
												<div>
													<select id="dataobj_priority_select" class="form-control select select-primary col-sm-4">
													</select>
													
													<div class="col-sm-7">
														<select onchange="update_dataobj_input();" id="dataobj_type_select" class="form-control select select-primary col-sm-6">
															<option value="range">范围</option>
															<option value="gt">大于</option>
															<option value="lt">小于</option>
														</select>
														<div id="dataobj_input" class="input-group col-sm-6">
														</div>
													</div>
													<button type="button" class="btn btn-info" onclick="add_dataobj();">增加</button>
													<script type="text/javascript">
														update_dataobj_priority_select();
														update_dataobj_input();
													</script>
												</div>
											</div>
										</div>
									</div>
									<br />
									<br />
									<div class="control-group row">
										<label class="control-label col-sm-2" >结论:</label>
										<div class="col-sm-10">
											<div>
												<select id="result_priority_select" class="form-control select select-primary col-sm-4">
												</select>
												<select id="result_select" class="form-control select select-primary col-sm-4">
												</select>
											</div>
										</div>
									</div>
									<br />
									<br />
									<div class="control-group row">
										<label class="control-label col-sm-2" >生成的规则:</label>
										<div class="col-sm-10">
											<div>
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
        </script>

	</body>
</html>