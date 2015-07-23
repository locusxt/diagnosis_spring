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
			dataobj_list = ['blood_pressure', 'temperature'];
			dataobj_priority_list = ['has_test_pressure', 'has_test_temperature'];


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
										<label class="control-label col-sm-2" for="input_rule_name"><strong>规则名:</strong></label>
										<div class="col-sm-6">
											<input onchange="gen_rule();" id="input_rule_name" class="form-control input-large" type="text" placeholder="输入规则名"></input>
										</div>
									</div>
									<br />
									<br />
									<div class="control-group row">
										<label class="control-label col-sm-2" ><strong>条件:</strong></label>
										<div class="col-sm-10">
											<div>
												<div>
													同时有以下症状:
												</div>
												<script type="text/javascript">
													function update_symptom(){
														str = "";
														for (var i = 0; i < symptom_list.length; i++){
															str += "<option value=\"" + i + "\">" + symptom_list[i] + "</option>";
														}
														$('#symptom_select').html(str);
													}

													function add_symptom(){
														str = "";
														name = $('#symptom_select').val();
														degree = $('#degree_select').val();
														last_time1 = $('#last_time_ipt1').val();
														last_time2 = $('#last_time_ipt2').val();
														if (last_time1 != "" && last_time2 != "" && parseInt(last_time1) > parseInt(last_time2)){
															alert('下界应该小于等于上界');
															return;
														}
														rule_symptom_list.push([name, degree, last_time1, last_time2]);
														update_symptom_table();
													}

													function del_symptom(id){
														rule_symptom_list.splice(id, 1);
														update_symptom_table();
													}

													function symptom2rstr(spt){
														str = "";
														if (spt[1] != "unselectd"){
															str += spt[1] + " ";
														}
														str += symptom_list[spt[0]];
														if (spt[2] != "" || spt[3] != ""){
															str += ", ";
															if (spt[2] != ""){
																str += spt[2] + " < ";
															}
															str += "last_time";
															if (spt[3] != ""){
																str += " < " + spt[3];
															}
														}
														return str;
													}

													function update_symptom_table(){
														str = "<tr><th>症状描述</th><th>删除</th></tr>";
														for (var i = 0; i < rule_symptom_list.length; ++i){
															str += "<tr>";
															str += "<td>";
															str += symptom2rstr(rule_symptom_list[i]);
															str += "</td>";
															str += "<td>";
															str += "<a href=\"javascript:void(0)\" onclick=\"del_symptom(" + i + ")\">删除</a>"
															str += "</td>"
															str += "</tr>";
														}
														$('#symptom_table').html(str);
													}
												</script>
												<div class="row">
													<div class="col-sm-8">
														<table id="symptom_table" class="table table-bordered table-hover table-striped">
															
														</table>
													</div>
												</div>
												<br />
												<div class="control-group row">
													<label class="control-label col-sm-2">症状名称：</label>
													<div class="col-sm-10">
														<select id="symptom_select" class="form-control select select-primary col-sm-4">
														</select>
													</div>
													<script type="text/javascript">
														update_symptom();
														update_symptom_table();
													</script>
												</div>
												<br />
												<div class="control-group row">
													<label class="control-label col-sm-2">程度：</label>
													<div class="col-sm-10">
														<select id="degree_select" class="form-control select select-primary col-sm-4">
															<option value="unselectd">unselectd</option>
															<option value="light">light</option>
															<option value="medium">medium</option>
															<option value="heavy">heavy</option>
														</select>
													</div>
												</div>
												<br />
												<div class="control-group row">
													<label class="control-label col-sm-2">持续时间（天）：</label>
													<div class="col-sm-10">
														<div class="input-group col-sm-4">
															<input id="last_time_ipt1" type="text" class="form-control">
											  				<span class="input-group-addon">~</span>
											  				<input id="last_time_ipt2" type="text" class="form-control">
														</div>
													</div>
												</div>
												<br />
												<div class="contrpl-group row">
													<label class="control-label col-sm-2"></label>
													<div class="col-sm-10">
														<div class="input-group">
															<button onclick="add_symptom();" type="button" class="btn btn-info">添加</button>
														</div>
													</div>
												</div>
											</div>
											<br />
											<div class="row">
												<div class="col-sm-8"><hr /></div>
											</div>
											<script type="text/javascript">
												function update_dataobj_name_select(){
													str = "";
													for (var i = 0; i < dataobj_list.length; ++i){
														str += "<option value=\"" + i + "\">" + dataobj_list[i] + "</option>";
													}
													$('#dataobj_name_select').html(str);
												}

												function add_dataobj(){
													name = $('#dataobj_name_select').val();
													dataobj_range1 = $('#dataobj_ipt1').val();
													dataobj_range2 = $('#dataobj_ipt2').val();
													if (dataobj_range1 == "" && dataobj_range2 == ""){
														alert("至少给出上界和下界中的一个");
														return;
													}
													if (dataobj_range1 != "" && dataobj_range2 != "" && parseInt(dataobj_range1) > parseInt(dataobj_range2)){
														alert("下界应该小于等于上界");
														return;
													}
													rule_dataobj_list.push([name, dataobj_range1, dataobj_range2]);
													update_dataobj_table();
												}

												function dataobj2rstr(dobj){
													str = "";
													if (dobj[1] != ""){
														str += dobj[1] + " < ";
													}
													str += dataobj_list[dobj[0]];
													if (dobj[2] != ""){
														str += " < " + dobj[2];
													}
													return str;
												}

												function update_dataobj_table(){
													str = "<tr><th>约束描述</th><th>删除</th></tr>";
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
												<div class="row">
													<div class="col-sm-8">
														<table id="dataobj_table" class="table table-bordered table-hover table-striped">
															
														</table>
													</div>
												</div>
												<br />
												<div class="control-group row">
													<label class="control-label col-sm-2">
														参数名：
													</label>
													<div class="col-sm-10">
														<select id="dataobj_name_select" class="form-control select select-primary col-sm-4">
														</select>
													</div>
												</div>
												<script type="text/javascript">
													update_dataobj_name_select();
													update_dataobj_table();
												</script>
												
												<br />
												<div class="control-group row">
													<label class="control-label col-sm-2">
														范围：
													</label>
													<div class="col-sm-10">
														<div class="input-group col-sm-4">
															<input id="dataobj_ipt1" type="text" class="form-control">
											  				<span class="input-group-addon">~</span>
											  				<input id="dataobj_ipt2" type="text" class="form-control">
														</div>
													</div>
												</div>

												<br />
												<div class="contrpl-group row">
													<label class="control-label col-sm-2"></label>
													<div class="col-sm-10">
														<div class="input-group">
															<button onclick="add_dataobj();" type="button" class="btn btn-info">添加</button>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
									<br />
									<br />
									<div class="control-group row">
										<label class="control-label col-sm-2" ><strong>结论:</strong></label>
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
										<label class="control-label col-sm-2" ><strong>生成的规则:</strong></label>
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