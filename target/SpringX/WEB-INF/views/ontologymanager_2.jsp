<!DOCTYPE html>
<HTML>
<HEAD>
    <TITLE> ZTREE DEMO - beforeEditName / beforeRemove / onRemove / beforeRename / onRename</TITLE>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="./css/demo.css" type="text/css">
    <!-- <link rel="stylesheet" href="./css/zTreeStyle/zTreeStyle.css" type="text/css"> -->
    <!-- // <script type="text/javascript" src="./js/jquery-1.4.4.min.js"></script> -->
    <!-- // <script type="text/javascript" src="./js/jquery.ztree.core-3.5.js"></script> -->
    <!-- // <script type="text/javascript" src="./js/jquery.ztree.excheck-3.5.js"></script> -->
    <!-- // <script type="text/javascript" src="./js/jquery.ztree.exedit-3.5.js"></script> -->
    <link rel="stylesheet" type="text/css" href="/SpringX/static/zTree/css/metroStyle/metroStyle.css">
    <script src="/SpringX/static/zTree/js/jquery.ztree.all-3.5.min.js"></script>
    <SCRIPT type="text/javascript">
        <!--
        var setting = {
            view: {
                addHoverDom: addHoverDom,
                removeHoverDom: removeHoverDom,
                selectedMulti: false
            },
            edit: {
                enable: true,
                editNameSelectAll: true,
                showRemoveBtn: showRemoveBtn,
                showRenameBtn: showRenameBtn
            },
            data: {
                simpleData: {
                    enable: true
                }
            },
            callback: {
                beforeDrag: beforeDrag,
                beforeEditName: beforeEditName,
                beforeRemove: beforeRemove,
                beforeRename: beforeRename,
                onRemove: onRemove,
                onRename: onRename,
                onClick: zTreeOnClick
            }
        };
        var x;
        var y;

        /*var zNodes =[
            { id:1, pId:0, name:"disease", open:true},
            { id:11, pId:1, name:"上呼吸道感染"},
            { id:111, pId:11, name:"普通感冒"},
            { id:112, pId:11, name:"流行性感冒"},
            { id:113, pId:11, name:"咽炎感染"},
            { id:1121, pId:112, name:"单纯型"},
            { id:1122, pId:112, name:"肺炎型"},
            { id:2, pId:0, name:"症状", open:false},
            { id:21, pId:2, name:"咽干"},
            { id:22, pId:2, name:"咽痒"},
            { id:23, pId:2, name:"灼烧"},
            { id:24, pId:2, name:"发热"},
            { id:25, pId:2, name:"鼻塞"},
            { id:26, pId:2, name:"流涕"},


        ];*/

        var OntModel={
                zNodes:[
                    { id:1, pId:0, name:"disease", open:true},
                    { id:11, pId:1, name:"上呼吸道感染"},
                    { id:111, pId:11, name:"普通感冒"},
                    { id:112, pId:11, name:"流行性感冒"},
                    { id:113, pId:11, name:"咽炎感染"},
                    { id:1121, pId:112, name:"单纯型流行性感冒"},
                    { id:1122, pId:112, name:"肺炎型流行性感冒"},
                    { id:2, pId:0, name:"症状", open:false},
                    { id:21, pId:2, name:"咽干"},
                    { id:22, pId:2, name:"咽痒"},
                    { id:23, pId:2, name:"灼烧"},
                    { id:24, pId:2, name:"发热"},
                    { id:25, pId:2, name:"鼻塞"},
                    { id:26, pId:2, name:"流涕"}
                ],
                Ontschema:[
                    {subject:"普通感冒",property:"has_sympotom_of",object:"咽干"},
                    {subject:"普通感冒",property:"has_sympotom_of",object:"发热"}
                ]
        }
        var log, className = "dark";

        function zTreeOnClick(event,treeId,treeNode)       //双击一个树节点
        {

            alert(treeNode.tId + ", " + treeNode.name);
            $("#treeid").val(treeNode.name); //显示树节点名字
            $(function(){
                $.each(OntModel.zNodes,function(i,item){
                    //alert(val);
                    $("#object").append("<option>"+item.name+"</option>"); //遍历其他节点作为下拉菜单
                })
            })
            var temp=[];
            for (var i=0;i<OntModel.Ontschema.length;i++)
            {
                if (treeNode.name==OntModel.Ontschema[i].subject)
                {
                    temp=temp+(OntModel.Ontschema[i].subject+OntModel.Ontschema[i].property+OntModel.Ontschema[i].object);
                    //$("#show_record").text(OntModel.Ontschema[i].property);
                    //$("#show_record").text(OntModel.Ontschema[i].object);

                }


                $("#show_record").text(temp); //显示之前的关系记录
            }

        };
       $( function buildOntModel()
        {
            $("#buildOntModel").click(function(){


                //alert("mm");
                var selectProperty = $("#property").find("option:selected").text();
                var inputSubject =$("#treeid").attr("value");
                var selectObject = $("#object").find("option:selected").text();
                //alert(inputSubject);
                //var arrayjson=JSON.parse(OntSchema);
                OntModel.Ontschema.push({"subject":inputSubject,"property":selectProperty,"object":selectObject});

                //OntSchema=JSON.stringify(arrayjson);

            });
        })



        function beforeDrag(treeId, treeNodes) {
            return false;
        }
        function beforeEditName(treeId, treeNode) {
            className = (className === "dark" ? "":"dark");
            showLog("[ "+getTime()+" beforeEditName ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name);
            var zTree = $.fn.zTree.getZTreeObj("treeDemo");
            zTree.selectNode(treeNode);
            return confirm("进入节点 -- " + treeNode.name + " 的编辑状态吗？");
        }
        function beforeRemove(treeId, treeNode) {
            className = (className === "dark" ? "":"dark");
            showLog("[ "+getTime()+" beforeRemove ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name);
            var zTree = $.fn.zTree.getZTreeObj("treeDemo");
            zTree.selectNode(treeNode);
            return confirm("确认删除 节点 -- " + treeNode.name + " 吗？");
        }
        function onRemove(e, treeId, treeNode) {
            showLog("[ "+getTime()+" onRemove ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name);
        }
        function beforeRename(treeId, treeNode, newName, isCancel) {
            className = (className === "dark" ? "":"dark");
            showLog((isCancel ? "<span style='color:red'>":"") + "[ "+getTime()+" beforeRename ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name + (isCancel ? "</span>":""));
            if (newName.length == 0) {
                alert("节点名称不能为空.");
                var zTree = $.fn.zTree.getZTreeObj("treeDemo");
                setTimeout(function(){zTree.editName(treeNode)}, 10);
                return false;
            }
            return true;
        }
        function onRename(e, treeId, treeNode, isCancel) {
            showLog((isCancel ? "<span style='color:red'>":"") + "[ "+getTime()+" onRename ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name + (isCancel ? "</span>":""));
        }
        function showRemoveBtn(treeId, treeNode) {
            return true;
        }
        function showRenameBtn(treeId, treeNode) {
            return true;
        }
        function showLog(str) {
            if (!log) log = $("#log");
            log.append("<li class='"+className+"'>"+str+"</li>");
            if(log.children("li").length > 8) {
                log.get(0).removeChild(log.children("li")[0]);
            }
        }
        function getTime() {
            var now= new Date(),
                    h=now.getHours(),
                    m=now.getMinutes(),
                    s=now.getSeconds(),
                    ms=now.getMilliseconds();
            return (h+":"+m+":"+s+ " " +ms);
        }

        var newCount = 1;
        function addHoverDom(treeId, treeNode) {
            var sObj = $("#" + treeNode.tId + "_span");
            if (treeNode.editNameFlag || $("#addBtn_"+treeNode.tId).length>0) return;
            var addStr = "<span class='button add' id='addBtn_" + treeNode.tId
                    + "' title='add node' onfocus='this.blur();'></span>";
            sObj.after(addStr);
            var btn = $("#addBtn_"+treeNode.tId);
            if (btn) btn.bind("click", function(){
                var zTree = $.fn.zTree.getZTreeObj("treeDemo");
                 x=zTree.addNodes(treeNode, {id:(100 + newCount), pId:treeNode.id, name:"new node" + (newCount++)});
                var m = $.merge(zNodes,x);

                return false;
            });
        };
        function removeHoverDom(treeId, treeNode) {
            $("#addBtn_"+treeNode.tId).unbind().remove();
        };
        function selectAll() {
            var zTree = $.fn.zTree.getZTreeObj("treeDemo");
            zTree.setting.edit.editNameSelectAll =  $("#selectAll").attr("checked");
        }

        $(document).ready(function(){
            $.fn.zTree.init($("#treeDemo"), setting, OntModel.zNodes);
            $("#selectAll").bind("click", selectAll);
            //var zTree = $.fn.zTree.getZTreeObj("treeDemo");
            //zNodes=zTree.getNodes();
        })
        //-->
    </SCRIPT>
    <style type="text/css">
        .ztree li span.button.add {margin-left:2px; margin-right: -1px; background-position:-144px 0; vertical-align:top; *vertical-align:middle}
    </style>
</HEAD>

<BODY>
<h1>高级 增 / 删 / 改 节点</h1>
<h6>[ 文件路径: exedit/edit_super.html ]</h6>
<div class="content_wrap">
    <div class="zTreeDemoBackground left">
        <ul id="treeDemo" class="ztree"></ul>
    </div>
    <div class="right">

            <!-- <ul id="log" class="log"></ul> -->
        <p class="ridge">
                <input id="treeid" type="text">


        </p>
        <form>
            <select name="Property" id="property">
                <option value="sympotom">has_symptom_of</option>
                <option value="diease">has_diease_of</option>
                <p></p>
                <input id="buildOntModel" type="button" value="生成本体模型"/>
            </select>
        </form>
        <form>
            <select name="object" id="object">

            </select>
        </form>


    </div>

</div>
<div class="middle" >
    <form>
    <textarea rows="20" cols="40" name="usrtxt" wrap="hard" id="show_record">

    </textarea>

    </form>
</div>

</BODY>
</HTML>