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

			current_rules = [];//目前已建的规则
			current_comments = [];

			rule_symptom_list = [];
			rule_dataobj_list = [];
			rule_disease_list = [];
			rule_test_list = [];

			symptom_list = ['牙痛', '头痛', '咳嗽'];
			symptom_list_en = ['toothache', 'headache', 'cough'];
			dataobj_list = ['血压', '体温'];
			dataobj_list_en = ['pressure', 'temperature'];
			dataobj_priority_list = ['has_test_pressure', 'has_test_temperature'];
			disease_list = ['diseaseA', 'diseaseB'];
			disease_list_en = ['diseaseA', 'diseaseB'];
			test_list = ['testA', 'testB', 'testC'];
			test_list_en = ['testA', 'testB', 'testC'];
			degree_list = ['未选择', '轻度', '中度', '重度'];
			degree_list_en = ['unselected', 'light', 'medium', 'heavy'];


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

			function list_rules(){
				$.ajax( {
					type : "GET",
					url : 'ajax/get_rules.do',
					dataType:"json",
					success : function(json) {
						current_rules = json.rules;
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
											<input onchange="" id="input_rule_name" class="form-control input-large" type="text" placeholder="输入规则名"></input>
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
														if (spt[2] != "" || spt[3] != ""){
															if (spt[2] != "" && spt[3] != ""){
																str += "持续" + spt[2] + "~" + spt[3] + "天";
															}
															else if (spt[2] != ""){
																str += "持续" + spt[2] + "天以上";
															}
															else if (spt[3] != ""){
																str += "持续不足" + spt[3] + "天";
															}
														}
														if (spt[1] != 0){
															str += degree_list[spt[1]] + " ";
														}
														str += symptom_list[spt[0]];
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
														gen_readable_rule();
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
												</div>
												<br />
												<div class="control-group row">
													<label class="control-label col-sm-2">程度：</label>
													<div class="col-sm-10">
														<select id="degree_select" class="form-control select select-primary col-sm-4">
															<option value="0">未选择</option>
															<option value="1">轻度</option>
															<option value="2">中度</option>
															<option value="3">重度</option>
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
													gen_readable_rule();
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
									<script type="text/javascript">
										function update_disease_select(){
											str = "";
											for (var i = 0; i < disease_list.length; ++i){
												str += "<option value=" + i + " > " + disease_list[i] + "</option>";
											}
											$('#disease_select').html(str);
										}

										function update_test_select(){
											str = "";
											for (var i = 0; i < test_list.length; ++i){
												str += "<option value=" + i + " > " + test_list[i] + "</option>";
											}
											$('#test_select').html(str);
										}

										function update_possible_disease(){
											if ($('#disease_select').val() != null)
												rule_disease_list = $('#disease_select').val();
											else
												rule_disease_list = [];
										}

										function update_test(){
											if ($('#test_select').val() != null)
												rule_test_list = $('#test_select').val();
											else
												rule_test_list = [];
										}
									</script>
									<div class="control-group row">
										<label class="control-label col-sm-2" ><strong>结论:</strong></label>
										<div class="col-sm-10">
											<div class="control-group row">
												<label class="control-label col-sm-2">可能疾病：</label>
												<div class="col-sm-10">
													<select id="disease_select" multiple="multiple" class="form-control multiselect multiselect-primary" onchange="gen_readable_rule();">
													</select>
												</div>
											</div>
											<br />
											<div class="control-group row">
												<label class="control-label col-sm-2">推荐诊断：</label>
												<div class="col-sm-10">
													<select id="test_select" multiple="multiple" class="form-control multiselect multiselect-primary" onchange="gen_readable_rule();">
													</select>
												</div>
											</div>
										</div>
									</div>
									<br />
									<br />
									<script type="text/javascript">
										function symptom2termstr(spt){
											str = "";
											str += "(?p ns:hassymptomof ns:" + symptom_list_en[spt[0]] + ")";
											if (spt[1] != 0){
												str += "(ns:" + symptom_list_en[spt[0]] + " ns:has_degree_of ns:" + degree_list_en[spt[1]] + ")";
											}
											if (spt[2] != "" || spt[3] != ""){
												str += "(ns:" + symptom_list_en[spt[0]] + " ns:has_duration_day ?time)";
											}
											if (spt[2] != ""){
												str += "ge(?time " + spt[2] + ")";
											}
											if (spt[3] != ""){
												str += "le(?time " + spt[3] + ")";
											}
											return str;
										}

										function dataobj2termstr(dobj){
											str = "";
											str += "(?p ns:" + dataobj_priority_list[dobj[0]] + " ?" + dataobj_list_en[dobj[0]] + ")";
											if (dobj[1] != ""){
												str += "ge(?" + dataobj_list_en[dobj[0]] + " " + dobj[1] + ")";
											}
											if (dobj[2] != ""){
												str += "le(?" + dataobj_list_en[dobj[0]] + " " + dobj[2] + ")";
											}
											return str;
										}

										function disease2htermstr(dis){
											str = "";
											str += "(?p ns:hasdiseaseof ns:" + disease_list_en[dis] + ")";
											return str;
										}

										function test2htermstr(test){
											str = "";
											str += "(?p ns:get_advice_of " + test_list_en[test] + ")";
											return str;
										}

										function gen_rule(){
											rules = [];
											name = $('#input_rule_name').val();
											if (name != ""){
												name = name + ": ";
											}
											termsstr = "";
											for (var i = 0; i < rule_symptom_list.length; ++i){
												termsstr += symptom2termstr(rule_symptom_list[i]);
											}
											for (var i = 0; i < rule_dataobj_list.length; ++i){
												termsstr += dataobj2termstr(rule_dataobj_list[i]);
											}
											for (var i = 0; i < rule_disease_list.length; ++i){
												str = "[" + name + termsstr;
												str += "->";
												str += disease2htermstr(rule_disease_list[i]);
												str += "]";
												rules.push(str);
											}
											for (var i = 0; i < rule_test_list.length; ++i){
												str = "[" + name + termsstr;
												str += "->";
												str += test2htermstr(rule_test_list[i]);
												str += "]";
												rules.push(str);
											}
											return rules;
										}

										function gen_rstr(arr1, arr2, arr3, arr4){
											str = "如果 ";
											for (var i = 0; i < arr1.length; ++i){
												if (i != 0) str += ", ";
												str += symptom2rstr(arr1[i]);					
											}
											if (arr1.length != 0){
												str += ", ";
											}
											for (var i = 0; i < arr2.length; ++i){
												if (i != 0) str += ", ";
												str += dataobj2rstr(arr2[i]);
											}
											str += ", 那么 ";
											if (arr3.length != 0){
												str += "可能患有 ";
												for (var i = 0; i < arr3.length; ++i){
													if (i != 0) str += "|";
													str += disease_list[arr3[i]];
												}
												str += " ";
											}
											if (arr4.length != 0){
												str += "建议 ";
												for (var i = 0; i < arr4.length; ++i){
													if (i != 0) str += "|";
													str += test_list[arr4[i]];
												}
											}
											return str;
										}

										function gen_readable_rule(){
											update_test();
											update_possible_disease();

											gen_rstr(rule_symptom_list, rule_dataobj_list, rule_disease_list, rule_test_list);
											
											$('#readable_rule').html(str);

										}
									</script>
									<div class="control-group row">
										<label class="control-label col-sm-2" ><strong>生成的规则:</strong></label>
										<div class="col-sm-10">
											<div>
												<p id="readable_rule"></p>
											</div>
										</div>
									</div>
									<script type="text/javascript">
										function gen_rule_comment(){
											new_rule_comment = [];
											for (var i = 0; i < rule_disease_list.length; ++i){
												d_list = [];
												d_list.push(rule_disease_list[i]);
												str = gen_rstr(rule_symptom_list, rule_dataobj_list, d_list, []);
												new_rule_comment.push(str);
											}
											for (var i = 0; i < rule_test_list.length; ++i){
												t_list = [];
												t_list.push(rule_test_list[i]);
												str = gen_rstr(rule_symptom_list, rule_dataobj_list, [], t_list);
												new_rule_comment.push(str);
											}
											return new_rule_comment;
										}

										function check_rule(){
											if (rule_symptom_list.length == 0 && rule_dataobj_list.length == 0){
												alert('请填写完整');
												return false;
											}
											if (rule_disease_list.length == 0 && rule_test_list.length == 0){
												alert('请填写完整');
												return false;
											}
											return true;
										}

										function post_new_rule(){
											arr1 = gen_rule();
											arr2 = gen_rule_comment();
											if (check_rule() == false){
												return;
											}
											console.log(arr1);
											console.log(arr2);
											jQuery.ajax( {
												type : 'POST',
												contentType : 'application/json',
												url : 'ajax/post_new_rule',
												data : JSON.stringify ({rules:arr1, comments:arr2}),
												dataType : 'json',
												success : function(data) {
													window.location.href="";
												},
												error : function(data) {
													alert("error");
												}
											});  
										}
									</script>
									<div class="control-group row">
										<label for="" class="control-label col-sm-2"></label>
										<div class="col-sm-10">
											<div>
												<p>
													<button type="button" onclick="post_new_rule();" class="btn btn-info">提交</button>
												</p>
											</div>
										</div>
									</div>
								</form>
							</div>
							<br />
						</div>
						<div class="bs-docs-section">
							<h4 class="page-header">浏览规则</h4>
							<script type="text/javascript">
								function get_rules(partId){
									json = {};
									json.partId = partId;
									json.partSize = 10;
									$.ajax({
									  type: 'POST',
									  url: "ajax/get_rules",
									  data: JSON.stringify (json), // or JSON.stringify ({name: 'jonas'}),
									  success: function(d) { console.log(d);},
									  contentType: "application/json",
									  dataType: 'json'
									});
								}

								start_index = 1;
								choosed_index = 1;

								function del_rule(rule_id, i){
									json = {};
									json.rule = current_rules[i];
									json.ruleId = rule_id;
									console.log(rule_id);
									console.log(current_rules[i]);
									$.ajax({
										type : "POST",
										url : "ajax/del_rule",
										data : JSON.stringify (json),
										success : function(d){console.log(d);},
										contentType : "application/json",
										dataType : 'json'
									});
								}

								function update_rules_table(){
									str = "";
									for (var i = 0; i < current_comments.length; ++i){
										str += "<tr><td>";
										str += current_comments[i];
										str += "</td><td>";
										str += "<a href=\"javascript:void(0)\" onclick=\"del_rule(" + ((choosed_index-1) * 10 + 3 + i) + "," + i + ");\">删除</a>";
										str += "</td></tr>";
									}
									$('#rules_table').html(str);
								}

								function change_index(id){
									choosed_index = id;
									$('li.active').removeClass("active");
									$('#index' + id).addClass("active");
									json = {};
									json.partId = (id - 1) * 10 + 3;
									json.partSize = 10;
									$.ajax({
									  type: 'POST',
									  url: "ajax/get_rules",
									  data: JSON.stringify (json), // or JSON.stringify ({name: 'jonas'}),
									  success: function(d) {
									  		current_rules = d.rules;
									  		current_comments = d.comments;
									  		update_rules_table();
									  	},
									  contentType: "application/json",
									  dataType: 'json'
									});
								}

								function update_index(delta){
									str = "";
									if (start_index + delta > 0){
										start_index += delta;
									}
									str += "<li class=\"previous\">\
								    			<a href=\"javascript:;\" onclick=\"update_index(-1);\">Previous</a>\
								  			</li>";
								  	for (var i = 0; i < 10; ++i){
								  		tmp = start_index + i;
								  		str += "<li id=\"index" + tmp + "\">\
								  					<a href=\"javascript:;\" onclick=\"change_index(" + tmp + ")\">" + tmp + "</a>\
								  				</li>";
								  	}
								  	str += "<li class=\"next\">\
								    			<a href=\"javascript:;\" onclick=\"update_index(1);\">Newer</a>\
								  			</li>";
								  	$('#index_list').html(str);

								  	if (choosed_index + delta > 0){
								  		choosed_index += delta;
								  		change_index(choosed_index);
								  	}
								}
							</script>
							<div class="col-sm-8 col-sm-offset-2">
								<table class="table table-bordered table-hover table-striped" id="rules_table">
									
								</table>
								<ul class="pagination-plain" id="index_list">
								</ul>
								<script type="text/javascript">
									update_index(0);
								</script>
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
			update_symptom();
			update_symptom_table();
			update_dataobj_name_select();
			update_dataobj_table();
			update_disease_select();
			update_test_select();

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
