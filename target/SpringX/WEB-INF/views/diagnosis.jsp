<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
   "http://www.w3.org/TR/html4/strict.dtd">

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>主页</title>
		<script src="/SpringX/static/basic_js/jquery.min.js"></script>
		<!-- // <script src="/SpringX/static/bootstrap/js/bootstrap.min.js"></script> -->
		<link href="/SpringX/static/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
		<link href="/SpringX/static/flat_ui/dist/css/vendor/bootstrap.min.css" rel="stylesheet">
		<link href="/SpringX/static/flat_ui/dist/css/flat-ui.min.css" rel="stylesheet">
        <script src="/SpringX/static/flat_ui/dist/js/vendor/video.js"></script>
        <!-- // <script src="/SpringX/static/flat_ui/dist/js/flat-ui.min.js"></script> -->
        <script src="/SpringX/static/basic_js/jsrender.min.js"></script>
<script type="text/javascript">
	var data_rec = {};
	var ms_res = {};
	var question_res = {};
	var choosed_module;
	var choosed_disease;
	var adv_question_res = {};
	var basic_info = {};


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

	function get_ms_states(){
		$.getJSON("ajax/get_states/", function(json){
			data_rec['states'] = json['states'];
		});
	}


	function send_ms_checks(){
		$('#predict_result').html('Loading...');
		$.ajax({
		  type: 'POST',
		  url: "ajax/get_modules/",
		  data: JSON.stringify (ms_res), // or JSON.stringify ({name: 'jonas'}),
		  complete: function(d) { 
				d = eval("("+d.responseText+")"); 
				data_rec['modules'] = d['modules']; 
				modules = d['modules'];
				$('#predict_result').html('');
				for (var i = 0; i < modules.length; ++i){
					$('#predict_result').append(
						"<li><a onclick=\"$('#search_module').val('" + modules[i] + "');\">" + modules[i] + "</a></li>"
					);
				}
		  },
		  contentType: "application/json",
		  dataType: 'text'
		});
	}

	function update_recommend_tests(module_name){
		$.ajax({
		  type: 'POST',
		  url: "ajax/get_module_questions/",
		  data: JSON.stringify ({"module" : module_name}), // or JSON.stringify ({name: 'jonas'}),
		  complete: function(d) { 
				d = eval("("+d.responseText+")"); 
				data_rec['questions'] = d['questions']; 
				questions = d['questions'];
				$('#recommend_tests').html('');
				for (var i = 0; i < questions.length; ++i){
					p = $("<p></p>").text(questions[i]['question']);

					select = $("<select></select>").attr({
						"id" : "q" + i,
						"class" : " select select-primary select-block mbl"
					});
					options = questions[i]['options'];
					for (var j = 0; j < options.length; ++j){
						$(select).append("<option value=" + j + ">" + options[j] + "</option>")
					}
					li = $("<li></li>").append(p, select);

					$('#recommend_tests').append(li);
					$("select").select2({dropdownCssClass: 'dropdown-inverse'});
				}
		  },
		  contentType: "application/json",
		  dataType: 'text'
		});
	}

	function add_custom_test(test_name){
		p = $("<p></p>").text(test_name);
		input = $("<input></input>").attr({
			"id":test_name + "_res",
			"type":"text",
			"placeholder":"输入检查结果",
			"class":"input-large form-control"
		});
		li = $("<li></li>").append(p, input);
		$('#custom_tests').append(li);
	}

	function update_recommend_auxiliarys(){
		$.ajax({
		  type: 'POST',
		  url: "ajax/get_disease_questions/",
		  data: JSON.stringify ({}), // or JSON.stringify ({name: 'jonas'}),
		  complete: function(d) { 
				d = eval("("+d.responseText+")"); 
				data_rec['adv_questions'] = d['adv_questions']; 
				adv_questions = d['adv_questions'];
				$('#recommend_auxiliarys').html('');
				for (var i = 0; i < adv_questions.length; ++i){
					p = $("<p></p>").text(adv_questions[i]['question']);

					select = $("<select></select>").attr({
						"id" : "advq" + i,
						"class" : " select select-primary select-block mbl"
					});
					options = adv_questions[i]['options'];
					for (var j = 0; j < options.length; ++j){
						$(select).append("<option value=" + j + ">" + options[j] + "</option>")
					}
					li = $("<li></li>").append(p, select);

					$('#recommend_auxiliarys').append(li);
					$("select").select2({dropdownCssClass: 'dropdown-inverse'});
				}  
			},
		  contentType: "application/json",
		  dataType: 'text'
		});
	}

	function add_custom_auxiliary(auxiliary_name){
		p = $("<p></p>").text(auxiliary_name);
		input = $("<input></input>").attr({
			"id":auxiliary_name + "_res",
			"type":"text",
			"placeholder":"输入检查结果",
			"class":"input-large form-control"
		});
		li = $("<li></li>").append(p, input);
		$('#custom_auxiliarys').append(li);
	}


	function update_possible_diseases(){
		$.ajax({
		  type: 'POST',
		  url: "ajax/get_res/",
		  data: JSON.stringify ({}), // or JSON.stringify ({name: 'jonas'}),
		  complete: function(d) { 
				d = eval("("+d.responseText+")"); 
				data_rec['diseases'] = d['diseases']; 
				diseases = d['diseases'];
				$('#possible_diseases').html('');
				for (var i = 0; i < diseases.length; ++i){
					button = $("<button></button>").attr({
						"type":"button",
						"class":"btn btn-primary",
						"onclick":"choose_disease('" + diseases[i]['name'] + "');"
					});
					text = diseases[i]['name'] + "<span class='badge'>" + diseases[i]['prob']*100 + "%</span>";
					$(button).html(text);
					$('#possible_diseases').append(button);
					$('#possible_diseases').append("&nbsp;&nbsp;");
				}
		  },
		  contentType: "application/json",
		  dataType: 'text'
		});
	}

	function choose_disease(disease_name){
		$('#input_disease_name').val(disease_name);
		$.ajax({
		  type: 'POST',
		  url: "ajax/get_treatment/",
		  data: JSON.stringify ({}), // or JSON.stringify ({name: 'jonas'}),
		  complete: function(d) { 
				d = eval("("+d.responseText+")"); 
				data_rec['treatment'] = d['treatment']; 
				treatment = d['treatment'];
				$('#input_prescribe').val(treatment);
				$('#input_treatment').val(treatment);
				$('#input_entrust').val(treatment);
		  },
		  contentType: "application/json",
		  dataType: 'text'
		});
	}

	function update_result(){
		disease_name = $('#input_disease_name').val();
		prescribe = $('#input_prescribe').val();
		treatment = $('#input_treatment').val();
		entrust = $('#input_entrust').val();

		$('#disease_name').html(disease_name);
		$('#prescribe').html(prescribe);
		$('#treatment').html(treatment);
		$('#entrust').html(entrust);
	}

	
	

	

	/*
	 * 该函数用于更新用户基本信息的显示
	 */
	function update_basic_info(){
		name = $('#input_name').val();
		gender = $("input:radio[name='input_gender'][checked]").val()
		age = $('#input_age').val();
		office = $('#input_office').val();
		id = $('#input_id').val();

		$('#patient_name').html(name);
		$('#patient_gender').html(gender);
		$('#patient_age').html(age);
		$('#case_office').html(office);
		$('#case_id').html(id);
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
                        <li><a href="">添加规则</a></li>
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
		<div class="panel panel-default col-md-9">
			<div class="panel-body" role="main" id="top">
				<div id="basic_info_section" class="bs-docs-section">
					<h4 id="basic_info_title" class="page-header">基本信息</h4>
					<div>
						<p>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<strong>姓名：</strong><span id="patient_name">&nbsp;&nbsp;&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;
							<strong>性别：</strong><span id="patient_gender">&nbsp;&nbsp;&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;
							<strong>年龄：</strong><span id="patient_age">&nbsp;&nbsp;&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;
							<strong>科室：</strong><span id="case_office">&nbsp;&nbsp;&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;
							<strong>ID号：</strong><span id="case_id">&nbsp;&nbsp;&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<a href="" data-toggle="modal" data-target="#basic_info_modal"><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span></a>
							<br />
						</p>
					</div>
					<br />
					<div id="patient_log" class="form-horizontal">
						<div class="control-group row">
							<label class="control-label col-md-2"><strong>既往病史：</strong></label>
							<div class="col-md-8">
								<div id="past_log_show">
									<p id="past_log"></p>
									<a id="past_log_edit" onclick="$('#past_log_show').hide(); $('#past_log_update').show()"><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span></a>
								</div>
								
								<div id="past_log_update" style="display:none;">
									<textarea rows="3" id="input_past_log" class="form-control" placeholder="既往病史" aria-describedby="sizing-addon1"></textarea>
									<a id="past_log_confirm" onclick="$('#past_log').html($('#input_past_log').val()); $('#past_log_show').show(); $('#past_log_update').hide()"><span class="glyphicon glyphicon-ok" aria-hidden="true"></span></a>
									&nbsp;&nbsp;&nbsp;&nbsp;
									<a id="past_log_cancel" onclick=" $('#past_log_show').show(); $('#past_log_update').hide()"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span></a>
									&nbsp;&nbsp;&nbsp;&nbsp;
									<a id="past_log_cancel" onclick="$('#input_past_log').val(''); $('#past_log').html(''); $('#past_log_show').show(); $('#past_log_update').hide()"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></a>
								</div>
							</div>
						</div>
						<br />
						<div class="control-group row">
							<label class="control-label col-md-2"><strong>个人史：</strong></label>
							<div class="col-md-8">
								<div id="person_log_show">
									<p id="person_log"></p>
									<a id="person_log_edit" onclick="$('#person_log_show').hide(); $('#person_log_update').show()"><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span></a>
								</div>
								
								<div id="person_log_update" style="display:none;">
									<textarea rows="3" id="input_person_log" class="form-control" placeholder="既往病史" aria-describedby="sizing-addon1"></textarea>
									<a id="person_log_confirm" onclick="$('#person_log').html($('#input_person_log').val()); $('#person_log_show').show(); $('#person_log_update').hide()"><span class="glyphicon glyphicon-ok" aria-hidden="true"></span></a>
									&nbsp;&nbsp;&nbsp;&nbsp;
									<a id="person_log_cancel" onclick=" $('#person_log_show').show(); $('#person_log_update').hide()"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span></a>
									&nbsp;&nbsp;&nbsp;&nbsp;
									<a id="person_log_cancel" onclick="$('#input_person_log').val(''); $('#person_log').html(''); $('#person_log_show').show(); $('#person_log_update').hide()"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></a>
								</div>
							</div>
						</div>
						<br />
						<div class="control-group row">
							<label class="control-label col-md-2"><strong>家族史：</strong></label>
							<div class="col-md-8">
								<div id="family_log_show">
									<p id="family_log"></p>
									<a id="family_log_edit" onclick="$('#family_log_show').hide(); $('#family_log_update').show()"><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span></a>
								</div>
								
								<div id="family_log_update" style="display:none;">
									<textarea rows="3" id="input_family_log" class="form-control" placeholder="既往病史" aria-describedby="sizing-addon1"></textarea>
									<a id="family_log_confirm" onclick="$('#family_log').html($('#input_family_log').val()); $('#family_log_show').show(); $('#family_log_update').hide()"><span class="glyphicon glyphicon-ok" aria-hidden="true"></span></a>
									&nbsp;&nbsp;&nbsp;&nbsp;
									<a id="family_log_cancel" onclick=" $('#family_log_show').show(); $('#family_log_update').hide()"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span></a>
									&nbsp;&nbsp;&nbsp;&nbsp;
									<a id="family_log_cancel" onclick="$('#input_family_log').val(''); $('#family_log').html(''); $('#family_log_show').show(); $('#family_log_update').hide()"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></a>
								</div>
							</div>
						</div>
					</div>
					
				</div>
				<br />
				<div id="symptom_section" class="bs-docs-section">
					<div class="form-horizontal">
						<h4 class="page-header">初步检查</h4>
						<div class="control-group row">
							<label class="control-label col-md-2"><strong>症状：</strong></label>
							<div class="tagsinput-primary col-md-8">
								<input id="symptoms" class="tagsinput" data-role="tagsinput" value="" />
							</div>
						</div>
						<div class="control-group row">
							<label class="control-label col-md-2"> </label>
							<div id="symptom_options" class="tagsinput-primary col-md-8">

							</div>
						</div>
						<script type="text/javascript">
							$.getJSON("ajax/get_states/", function(json){
								data_rec['states'] = json['states'];
								states = json['states'];
								for (var i = 0; i < states.length; ++i){
									$('#symptom_options').append(
										"<div class='col-md-2'><a class='btn btn-primary' role='button' onclick=\"$('#symptoms').tagsinput('add', '" + states[i] + "');\">" + states[i] + "</a></div>"
									);
								}
							});
						</script>
						<div class="control-group row">
							<label class="control-label col-md-2"><strong>初步检查结果：</strong></label>
							<div class="tagsinput-primary col-md-8">
								<p id="basic_check_result">
									
								</p>
								<a onclick="send_ms_checks();" data-toggle="modal" data-target="#choose_module_modal"><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span></a>
							</div>
						</div>
					</div>
				</div>
				<br />
				<div id="detail_diagnosis_section" class="bs-docs-section">
					<h4 class="page-header">进一步检查</h4>
					<div class="row col-md-offset-1">
						<strong>推荐的诊断项目</strong>
						<ul id="recommend_tests">
							
						</ul>
						<strong>自定义诊断项目</strong>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a id="custom_tests_add" onclick="" data-toggle="modal" data-target="#add_custom_test_modal"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span></a>
						&nbsp;&nbsp;
						<a id="custom_tests_clear" onclick=""><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></a>
						<ul id="custom_tests">
							
						</ul>
					</div>
					<br />
					<br />
					<div class="row col-md-offset-1">
						<p><a onclick="update_recommend_auxiliarys();" class="btn btn-primary btn-lg" onclick="" role="button">确认</a></p>
					</div>
				</div>
				<br />
				<div id="auxiliary_section" class="bs-docs-section">
					<h4 class="page-header">辅助检查</h4>
					<div class="row col-md-offset-1">
						<strong>推荐的辅助检查</strong>
						<ul id="recommend_auxiliarys">
							
						</ul>
						<strong>自定义辅助检查项目</strong>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a id="custom_auxiliarys_add" onclick="" data-toggle="modal" data-target="#add_custom_auxiliary_modal"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span></a>
						&nbsp;&nbsp;
						<a id="custom_auxiliarys_clear" onclick=""><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></a>
						<ul id="custom_auxiliarys">
							
						</ul>
						
					</div>
					<br />
					<br />
					<div class="row col-md-offset-1">
						<p><a class="btn btn-primary btn-lg" onclick="" role="button">确认</a></p>
					</div>
				</div>
				<br />
				<div id="diagnosis_result" class="bs-docs-section">
					<h4 class="page-header">处理意见&nbsp;&nbsp;<small><a href="#" onclick="update_possible_diseases();" data-toggle="modal" data-target="#result_modal"><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span></a></small></h4>
					<div class="form-horizontal">
						<div class="control-group row">
							<label class="control-label col-md-2"><strong>病名：</strong></label>
							<div class="col-md-8">
								<p id="disease_name">
									
								</p>
							</div>
						</div>
						<br />
						<div class="control-group row">
							<label class="control-label col-md-2"><strong>处方：</strong></label>
							<div class="col-md-8">
								<p id="prescribe">
									
								</p>
							</div>
						</div>
						<br />
						<div class="control-group row">
							<label class="control-label col-md-2"><strong>治疗手段：</strong></label>
							<div class="col-md-8">
								<p id="treatment">
									
								</p>
							</div>
						</div>
						<br />
						<div class="control-group row">
							<label class="control-label col-md-2"><strong>嘱托：</strong></label>
							<div class="col-md-8">
								<p id="entrust">
									
								</p>
							</div>
						</div>

					</div>
					<br />
					<br />
					<div class="row col-md-offset-1">
						<p><a class="btn btn-primary btn-lg" onclick="" role="button">确认</a></p>
					</div>
				</div>
			</div>
		</div>
		<div class="col-md-3" role="complementary">
			<nav class="bs-docs-sidebar hidden-print hidden-xs hidden-sm" id="navbar-example" data-spy="affix" data-offset-top="20">
				<ul class="nav bs-docs-sidenav">
					<li>
						<a href="#basic_info_section">基本信息</a>
					</li>
					<li>
						<a href="#symptom_section">初步检查</a>
					</li>
					<li>
						<a href="#detail_diagnosis_section">进一步诊断</a>
					</li>
					<li>
						<a href="#auxiliary_section">辅助检查</a>
					</li>
					<li>
						<a href="#diagnosis_result">处理意见</a>
					</li>
					<li>
						<a href="#top" class="back-to-top">返回顶部</a>
					</li>
				</ul>
			</nav>
		</div>
	</div>	
</div>



<!-- basic info Modal -->
<div class="modal fade" id="basic_info_modal" tabindex="-1" role="dialog" aria-labelledby="basic_info_modal_label" aria-hidden="true">
  <div class="modal-dialog">
	<div class="modal-content">
	  <div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		<h4 class="modal-title" id="basic_info_modal_label">基本信息</h4>
	  </div>
	  <div class="modal-body" id="basic_info_modal_body">
		<div>
			<form class="form-horizontal">
				<div class="control-group">
					<label class="control-label col-sm-2" for="input_name">姓名</label>
					<div class="col-sm-10">
						<input id="input_name" class="form-control" type="text" placeholder="输入姓名" class="input-large" />
					</div>
				</div>
				<br />
				<br />
				<div class="control-group">
					<label class="control-label col-sm-2" for="input_gender">性别</label>
					<div class="col-sm-10">
						<label class="radio" onclick="$('#gender_male').attr('checked', true);$('#gender_female').attr('checked', false);">
							<input id="gender_male" type="radio" value="男" name="input_gender" />
								男
						</label>
						<label class="radio checked" onclick="$('#gender_female').attr('checked', true);$('#gender_male').attr('checked', false);">
							<input id="gender_female" type="radio" value="女" name="input_gender" checked="checked" />
								女
						</label>
					</div>
				</div>
				<br />
				<br />
				<div class="control-group">
					<label class="control-label col-sm-2" for="input_age">年龄</label>
					<div class="col-sm-10">
						<select id="input_age" class="form-control select select-primary select-block mbl">
  						</select>
  						<script type="text/javascript">
							for (var i = 0; i < 100; ++i){
    							$('#input_age').append("<option value=" + i + ">" + i + "</option>");
    						}
    					</script>
					</div>
				</div>
				<br />
				<br />
				<div class="control-group">
					<label class="control-label col-sm-2" for="input_office">科室</label>
					<div class="col-sm-10">
						<input id="input_office" class="form-control" type="text" placeholder="输入科室" class="input-large" />
					</div>
				</div>
				<br />
				<br />
				<div class="control-group">
					<label class="control-label col-sm-2" for="input_id">ID号</label>
					<div class="col-sm-10">
						<input id="input_id" class="form-control" type="text" placeholder="输入ID号" class="input-large" />
					</div>
				</div>
				<br />
				<br />
			</form>
		</div>
	  </div>
	  <div class="modal-footer">
		<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
		<button type="button" class="btn btn-primary" onclick="update_basic_info();" data-dismiss="modal">保存</button>
	  </div>
	</div>
  </div>
</div>

<!-- choosle possible module Modal -->
<div class="modal fade" id="choose_module_modal" tabindex="-1" role="dialog" aria-labelledby="choose_module_modal_label" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="choose_module_modal_label">初步诊断结果</h4>
      </div>
      <div class="modal-body" id="choose_module_modal_body">
      	<div class="row">
	        <div class="input-group col-md-6 col-md-offset-3">
	  			<input type="text" class="form-control" placeholder="Search" id="search_module">
	  			<span class="input-group-btn">
	    			<button type="submit" class="btn"><span class="fui-search"></span></button>
	  			</span>
			</div>
		</div>
		<br />
		<div class="row">
			<div class="col-md-6 col-md-offset-3">
				<strong>预测的结果</strong>
				<ul id="predict_result">
					
				</ul>
				<strong>搜索的结果</strong>
				<ul id="search_result">
					
				</ul>

			</div>
		</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
		<button type="button" class="btn btn-primary" onclick="var choosed = $('#search_module').val(); $('#basic_check_result').html(choosed); update_recommend_tests(choosed);" data-dismiss="modal">确认</button>
      </div>
    </div>
  </div>
</div>

<!-- add custom test Modal -->
<div class="modal fade" id="add_custom_test_modal" tabindex="-1" role="dialog" aria-labelledby="add_custom_test_modal_label" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="add_custom_test_modal_label">增加自定义检查</h4>
      </div>
      <div class="modal-body" id="add_custom_test_modal_body">
        <form class="form-horizontal">
        	<div class="control-group">
        		<label class="control-label col-sm-2" for="input_test_name">检查项目</label>
        		<div class="col-sm-10">
					<input id="input_test_name" class="form-control" type="text" placeholder="输入检查项目" class="input-large" />
				</div>
				<br />
				<br />
        	</div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
		<button type="button" class="btn btn-primary" onclick="add_custom_test($('#input_test_name').val());" data-dismiss="modal">确认</button>
      </div>
    </div>
  </div>
</div>

<!-- add custom auxiliary Modal -->
<div class="modal fade" id="add_custom_auxiliary_modal" tabindex="-1" role="dialog" aria-labelledby="add_custom_auxiliary_modal_label" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="add_custom_auxiliary_modal_label">增加自定义检查</h4>
      </div>
      <div class="modal-body" id="add_custom_auxiliary_modal_body">
        <form class="form-horizontal">
        	<div class="control-group">
        		<label class="control-label col-sm-2" for="input_auxiliary_name">检查项目</label>
        		<div class="col-sm-10">
					<input id="input_auxiliary_name" class="form-control" type="text" placeholder="输入检查项目" class="input-large" />
				</div>
				<br />
				<br />
        	</div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
		<button type="button" class="btn btn-primary" onclick="add_custom_auxiliary($('#input_auxiliary_name').val());" data-dismiss="modal">确认</button>
      </div>
    </div>
  </div>
</div>

<!-- result Modal -->
<div class="modal fade" id="result_modal" tabindex="-1" role="dialog" aria-labelledby="result_modal_label" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="result_modal_label">处理意见</h4>
      </div>
      <div class="modal-body" id="result_modal_body">
        <div class="form-horizontal">
			<div class="control-group row">
				<label class="control-label col-md-2"><strong>病名：</strong></label>
				<div class="col-md-8">
					<input id="input_disease_name" class="form-control" type="text" placeholder="输入病名" class="input-large" />
				</div>
			</div>
			<br />
			<div class="control-group row">
				<div class="col-md-8 col-md-offset-2" id="possible_diseases">
					<button class="btn btn-primary" type="button">
  						Messages <span class="badge">90%</span>
					</button>
				</div>
			</div>
			<br />
			<div class="control-group row">
				<label class="control-label col-md-2"><strong>处方：</strong></label>
				<div class="col-md-8">
					<textarea rows="3" id="input_prescribe" class="form-control" placeholder="处方" aria-describedby="sizing-addon1"></textarea>
				</div>
			</div>
			<br />
			<div class="control-group row">
				<label class="control-label col-md-2"><strong>治疗：</strong></label>
				<div class="col-md-8">
					<textarea rows="3" id="input_treatment" class="form-control" placeholder="治疗方式" aria-describedby="sizing-addon1"></textarea>
				</div>
			</div>
			<br />
			<div class="control-group row">
				<label class="control-label col-md-2"><strong>嘱托：</strong></label>
				<div class="col-md-8">
					<textarea rows="3" id="input_entrust" class="form-control" placeholder="嘱托" aria-describedby="sizing-addon1"></textarea>
				</div>
			</div>

		</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
		<button type="button" class="btn btn-primary" onclick="update_result();" data-dismiss="modal">确认</button>
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
