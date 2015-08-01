<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
   "http://www.w3.org/TR/html4/strict.dtd">

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>辅助诊断</title>
		<script src="/SpringX/static/basic_js/jquery.min.js"></script>
		<!-- // <script src="/SpringX/static/bootstrap/js/bootstrap.min.js"></script> -->
		<link href="/SpringX/static/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
		<link href="/SpringX/static/flat_ui/dist/css/vendor/bootstrap.min.css" rel="stylesheet">
		<link href="/SpringX/static/flat_ui/dist/css/flat-ui.min.css" rel="stylesheet">
        <script src="/SpringX/static/flat_ui/dist/js/vendor/video.js"></script>
        <!-- // <script src="/SpringX/static/flat_ui/dist/js/flat-ui.min.js"></script> -->
        <script src="/SpringX/static/basic_js/jsrender.min.js"></script>

		<script type="text/javascript">
			var patient_info = {};
			var chief_complaint_list = [];
			var chief_complaint_last_time = ["一两天", "一周", "一个月", "几个月"];

			patient_info.complaint = [];
			patient_info.complaint_time = [];
			patient_info.phy_exam = [];
			patient_info.phy_exam_result = [];

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

			function get_complaint_list(){
				$.ajax( {
					type : "get",
					url : "ajax/get_complaints.do",
					dataType:"json",
					success : function(json) {
						chief_complaint_list = json.complaintList;
						update_chief_complaint_list();
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

			function update_basic_info(){
				$('#patient_name').html($('#input_name').val());
				$('#patient_gender').html($("input:radio[name='input_gender'][checked]").val());
				$('#patient_age').html($('#input_age').val());
				$('#case_office').html($('#input_office').val());
				$('#case_id').html($('#input_id').val());
			}

			function get_phy_exam(){
				$.ajax({
				  type: 'POST',
				  url: "ajax/phy_exam",
				  data: JSON.stringify (patient_info), // or JSON.stringify ({name: 'jonas'}),
				  success: function(d) { alert('data: ' + d); },
				  contentType: "application/json",
				  dataType: 'json'
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
						<div id="basic_info_section" class="bs-docs-section row">
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
							<script type="text/javascript">
								function gen_text_input(chname, egname){
									str = "<div class=\"control-group row\">\
											<label class=\"control-label col-md-2\"><strong>" + chname + "</strong></label>\
											<div class=\"col-md-8\">\
												<div id=\"" + egname + "_show\">\
													<p id=\"" + egname + "\"></p>\
													<a id=\"" + egname + "_edit\" onclick=\"$('#" + egname + "_show').hide(); $('#" + egname +"_update').show()\"><span class=\"glyphicon glyphicon-pencil\" aria-hidden=\"true\"></span></a>\
												</div>\
												<div id=\"" + egname + "_update\" style=\"display:none;\">\
													<textarea rows=\"3\" id=\"input_" + egname + "\" class=\"form-control\" placeholder=\"" + chname + "\" aria-describedby=\"sizing-addon1\"></textarea>\
													<a id=\"" + egname + "_confirm\" onclick=\"$('#" + egname+ "').html($('#input_" + egname + "').val()); $('#" + egname + "_show').show(); $('#" + egname + "_update').hide()\"><span class=\"glyphicon glyphicon-ok\" aria-hidden=\"true\"></span></a>\
													&nbsp;&nbsp;&nbsp;&nbsp;\
													<a id=\"" + egname + "_cancel\" onclick=\" $('#" + egname + "_show').show(); $('#" + egname + "_update').hide()\"><span class=\"glyphicon glyphicon-remove\" aria-hidden=\"true\"></span></a>\
													&nbsp;&nbsp;&nbsp;&nbsp;\
													<a id=\"" + egname + "_cancel\" onclick=\"$('#input_" + egname + "').val(''); $('#" + egname + "').html(''); $('#" + egname + "_show').show(); $('#" + egname + "_update').hide()\"><span class=\"glyphicon glyphicon-trash\" aria-hidden=\"true\"></span></a>\
												</div>\
											</div>\
										</div>\
										<br />";
									document.write(str);
								}
							</script>
							<div id="patient_log" class="form-horizontal">
								<script type="text/javascript">
									gen_text_input("现病史", "current_log");
									gen_text_input("既往史", "past_log");
									gen_text_input("个人史", "personal_log");
									gen_text_input("家族史", "family_log");
								</script>
							</div>
						</div>

						<script type="text/javascript">
						function add_chief_complaint(){
							patient_info.complaint.push(chief_complaint_list[$('#input_chief_complaint').val()]);
							patient_info.complaint_time.push(chief_complaint_last_time[$('#input_chief_complaint_time').val()]);
							update_chief_complaint_table();
						}

						function del_chief_complaint(id){
							patient_info.complaint.splice(id, 1);
							patient_info.complaint_time.splice(id, 1);
							update_chief_complaint_table();
						}

						function update_chief_complaint_table(){
							str = "<tr>\
									<th>症状</th>\
									<th>持续时间</th>\
									<th>删除</th>\
								   </th>";
							for (var i = 0; i < patient_info.complaint.length; i++){
								str += "<tr>\
											<td>" + patient_info.complaint[i] + "</td>\
											<td>" + patient_info.complaint_time[i] + "</td>\
											<td> <a href=\"javascript:void(0)\" onclick=\"del_chief_complaint(" + i + ");\">delete</a></td>\
										</tr>";
							}
							$('#chief_complaint_table').html(str);
						}

						function update_chief_complaint_list(){
							str = "";
							for (var i = 0; i < chief_complaint_list.length; i++){
								str += "<option value=\"" + i + "\">" + chief_complaint_list[i] + "</option>";
							}
							$('#input_chief_complaint').html(str);
							$('#input_chief_complaint').val(0);
							$("select").select2({dropdownCssClass: 'dropdown-inverse'});
						}

						</script>

						<div id="chief_complaint_section" class="bs-docs-section row">
							<h4 id="chief_complaint_title" class="page-header">主诉</h4>
							<div class="col-sm-offset-1">
								<select id="input_chief_complaint" class="form-control select select-primary select-block mbl">
  								</select>
  								&nbsp;&nbsp;
  								<select id="input_chief_complaint_time" class="form-control select select-primary select-block mbl">
									<option value="0">一两天</option>
									<option value="1">一周</option>
									<option value="2">一月</option>
									<option value="3">几个月</option>
  								</select>
  								&nbsp;&nbsp;
  								<select id="input_chief_complaint_degree" class="form-control select select-primary select-block mbl">
									<option value="0">一两天</option>
									<option value="1">一周</option>
									<option value="2">一月</option>
									<option value="3">几个月</option>
  								</select>
  								&nbsp;&nbsp;&nbsp;&nbsp;
  								<button type="button" class="btn btn-info" onclick="add_chief_complaint();">添加</button>
							</div>
							<div class="col-sm-offset-1 col-sm-9">
								<table id="chief_complaint_table" class="table">
								</table>
							</div>
						</div>

						<script type="text/javascript">
							function update_phy_exam_table(){
								str = "";
								for (var i = 0; i < patient_info['phy_exam'].length; i++){
									str += "<div class=\"control-group row\">\
												<label class=\"control-label col-md-2\">\
													<strong>" + patient_info['phy_exam'][i] + "</strong>\
												</label>\
												<div class=\"col-md-8\">\
													<input id=\"phy" + i + "\" class=\"form-control input-large\" type=\"text\"></input>\
												</div>\
											</div>";
								}
								$('#phy_exam_content').html(str);
							}
						</script>

						<div id="phy_exam_section" class="bs-docs-section row">
							<h4 id="phy_exam_title" class="page-header">体格检查</h4>
							<div id="phy_exam_content" class="col-sm-offset-1">
								
							</div>
							<br />
							<div class="col-sm-offset-1">
  								<button type="button" class="btn btn-info" onclick="">更新</button>
							</div>
						</div>

						<div id="recommend_exam_section" class="bs-docs-section row">
							<h4 id="recommend_exam_title" class="page-header">推荐检查</h4>
							<div class="col-sm-offset-1">

							</div>
						</div>

						<div id="diagnosis_result_section" class="bs-docs-section row">
							<h4 id="diagnosis_result_title" class="page-header">初步诊断结果</h4>
							<div class="col-sm-offset-1">

							</div>
						</div>

						<div id="solution_section" class="bs-docs-section row">
							<h4 id="solution_title" class="page-header">处理意见</h4>
							<div class="col-sm-offset-1">

							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- basic info Modal -->
		<script type="text/javascript">
			function gen_input(chname, egname){
				str = "<div class=control-group><label class='control-label col-sm-2' for='input_" + egname + "'/>" + chname + "</label><div class=col-sm-10><input id='input_" + egname + "' class='form-control input-large' type=text placeholder='输入" + chname + "' /></div></div><br /><br />";
				document.write(str);
			}
		</script>
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
						<script type="text/javascript">
							gen_input("姓名", "name");
						</script>
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
						<script type="text/javascript">
							gen_input("科室", "office");
							gen_input("ID号", "id");
						</script>
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

		<script type="text/javascript" id="my_init">
			get_complaint_list();
			update_chief_complaint_table();
		</script>

		<script type="text/javascript" id="flat_ui_init">
			$(':checkbox').radiocheck();
			$(':radio').radiocheck('check');
			$("select").select2({dropdownCssClass: 'dropdown-inverse'});
			$(".tagsinput").tagsinput();
        	videojs.options.flash.swf = "/SpringX/static/flat_ui/dist/js/vendors/video-js.swf";
		</script>
	</body>
</html>