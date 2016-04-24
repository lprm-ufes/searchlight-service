{% extends "layout.swig" %}
{% block body %}

<script src="http://rawgit.com/wancharle/json-editor/master/dist/jsoneditor.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.7/angular.min.js"></script>
<link rel="stylesheet" type="text/css" href="/bower_components/codemirror/lib/codemirror.css">
<link rel="stylesheet" href="/bower_components/codemirror/addon/lint/lint.css">
<style>
.CodeMirror-lint-tooltip {
    z-index:10000!important;
}
</style>
<script type="text/javascript" src="/bower_components/codemirror/lib/codemirror.js"></script>
<script type="text/javascript" src="/bower_components/codemirror/mode/javascript/javascript.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jshint/r07/jshint.js"></script>
<script src="/bower_components/codemirror/addon/lint/lint.js"></script>
<script src="/bower_components/codemirror/addon/lint/javascript-lint.js"></script>
<script type="text/javascript" src="/bower_components/angular-ui-codemirror/ui-codemirror.js"></script>
<script>
angular.module('MashupApp',['ui.codemirror'],function($locationProvider){
        $locationProvider.html5Mode({enabled:true,  requireBase: false });
})
.controller('MashupEditorController',['$scope','$http','$location', '$filter','$sce', function($scope, $http,$location,$filter,$sce) {
    var editor= this;
    var mashup = {};
    var modal = {};
    var coletorTab = {};
    mashup.title = "";
    $scope.mashup = mashup;
    $scope.modal = modal;
    $scope.editorOptions = {
        lineNumbers: true,
        mode: 'javascript',
            gutters: ["CodeMirror-lint-markers"],
        lint:true,
    onLoad: function(_editor){
            $scope.codemirror = _editor;
            $scope.codemirror.refresh();
        }
    };
    editor.mashup = mashup;
    editor.data = null;

    editor.click = function(continuar){
        //console.log(angular.toJson(mashup));
    }
    // ColetorTab
    var ColetorTab = {
        iAction : 0,
        updateSimulador: function(){
            $('#colframe').html('<iframe scrolling="no" style="width:320px;height:568px;border:0px;margin-top:216px;margin-left:135px;" src="/slc/?mashup=http://sl.wancharle.com.br/mashup/'+mashup.id+'"></iframe>')
        },
        createActionEditor: function(){
            schema = {}
            schema.title = 'Açao'
            schema.properties = {}
            schema.properties.tipo = { "type":"string","enum":["simple", "normal", "tracking"]}
            schema.properties.legenda= { "type":"string","minLength":3}
            schema.properties.valor= { "type":"string","minLength":3}
            schema.properties.extra= { "type":"string"}
            schema.required =  [ "tipo", "legenda", "valor", "extra" ]

            //schema.properties.action = { "type":"object",format:"tab","oneOf":[ {"$ref":"#/definitions/pess"},{"$ref":"#/definitions/pessoa2"}]}
            //schema.definitions = {"pess":{"title":"pess","required":["name"],"properties":{"name":{"type":"string"}}},"pessoa2":{"required":["nome2"],"properties":{"nome2":{"type":"string"}},"title":"pess2"}}
            if (ColetorTab.iAction == -1)
                startval = {}
            else
                startval = JSON.parse(angular.toJson(mashup.acoes[ColetorTab.iAction]))

            console.log(startval)
            if (ColetorTab.editor)
                ColetorTab.editor.setValue(startval)
            else
                ColetorTab.editor = new JSONEditor(document.getElementById('actionEditor'),{ schema: schema,
                startval:startval,
                form_name_root:'note',
                disable_properties: true,
                no_additional_properties: true,
                         
                disable_collapse: true,
                theme : 'bootstrap3'
            });
        },
        alterar: function(iAction){
           ColetorTab.iAction = iAction
           $('#coletortabpopup').modal('show');
           ColetorTab.createActionEditor();
        },
        remover: function(iAction){
          if (confirm("Tem certeza que deseja remover esta ação ("+mashup.acoes[iAction].legenda+") ?"))
              mashup.acoes.splice(iAction, 1);
        },
        save: function ($event){
            errors = ColetorTab.editor.validate()
            if (errors.length){
                alert(erros)
                return;
             }
            action = ColetorTab.editor.getValue()
            if (ColetorTab.iAction==-1)  mashup.acoes.push(action)
            else mashup.acoes[ColetorTab.iAction]=action;
            $('#coletortabpopup').modal('hide');
        },
        load: function(data){
            mashup.acoes = data.acoes
        }
    }
    $scope.ColetorTab = ColetorTab;
    
    // BDtab 
    editor.BDtab = {
        save: function($event){
            var popupValido = false
            if (modal.url){
              func_code = modal.func_code 
              try{
                func_name = "sl"+(new Date()).getTime()
                eval(func_name+" = "+func_code)
                func_code = eval(func_name)
                    
                popupValido = true
                editor.BDtab.saveDs()
              }catch(e){
                alert("ERRO no código da função de conversão:\n\n"+e.toString());
              }
            }else{
                alert("URL inválida!\n\nPor favor, informe uma url válida para a fonte de dados.");
            }
          
            if (!popupValido){
              $event.preventDefault()
              $event.stopImmediatePropagation()
              return false 
            }else{ 
              return true
            }
        },
        saveDs: function(){
            console.log(modal)
            if (modal.dsindex == -1){
                mashup.dataSources.push({url:modal.url,func_code:modal.func_code});    
            }else{
                mashup.dataSources[modal.dsindex].url = modal.url
                mashup.dataSources[modal.dsindex].func_code = modal.func_code
            }
            console.log(angular.toJson(mashup.dataSources))
        }, 
        openPopup: function(id_fonte){
                editor.BDtab.loadFonte(id_fonte);
                $('#bdtabpopup').modal('show');
                setTimeout(function(){ $scope.codemirror.refresh();},600); // fix bug nao aparece no modo bootstrap modal
        },

        alterar: function(id_fonte){
           console.log(id_fonte);
           editor.BDtab.openPopup(id_fonte);
        },
        remover: function(index,url){
          if (confirm("Tem certeza que deseja remover esta fonte de dados ("+url+") ?"))
              mashup.dataSources.splice(index, 1);
        },
        loadFonte: function (i){
            modal.dsindex = i;
            console.log(i)
            if (i == -1){
                modal.url = "" 
                modal.func_code = ""
            }else{
                modal.url = mashup.dataSources[i].url
                modal.func_code = mashup.dataSources[i].func_code
            }
            //$scope.$apply();
        },
        load: function(data){
            mashup.dataSources = data.dataSources
        }
    }

    editor.load = function(){
        $http.get('/mashup/',{params:$location.search() }).success(function (data){
            console.log(data)
            editor.data = data
            mashup.title = data.title
            mashup.id = data.id
            editor.BDtab.load(data)
            ColetorTab.load(data)
        });
    }
    editor.load();
}]);
</script> 
<br/><br/>
<div class="container" ng-app='MashupApp'>
<div class="row" ng-controller='MashupEditorController as mashupEditor'> 

<h1>Mashup Editor</h1>
<!-- editor  -->
<div id="editor">
    <ul class="nav nav-tabs">
        <li class="active"><a data-toggle="tab" href="#mashuptab">Mashup</a></li>
        <li><a data-toggle="tab" href="#bdtab">Dados</a></li>
        <li><a data-toggle="tab" ng-click="ColetorTab.updateSimulador()" href="#coletortab">Coletor</a></li>
        <li><a data-toggle="tab" href="#servicotab">Serviço</a></li>
        <li><a data-toggle="tab" href="#viewtab">Visualização</a></li>
    </ul>

    <div class="tab-content">
      <div id="mashuptab" style="padding:15px" class="tab-pane fade in active">
        <div class='form-group'>
        <label for='urlosm'>Título</label>
        <input type="text" class='form-control' ng-model="mashup.title" placeholder='Informe o título do mashup'>
        </div>
      </div>

      <div id="bdtab" style="padding:15px;" class="tab-pane fade">
        {% include "./bdtab.swig" %}
     </div> <!-- fim bdTAB -->

      <div id="coletortab" style="padding:15px;" class="tab-pane fade">
        {% include "./coletortab.swig" %}
      </div>
      <div id="servicotab" style="padding:15px;"  class="tab-pane fade">
        <p>serviço</p>
      </div>
      <div id="viewtab" style="padding:15px;" class="tab-pane fade">
        <p>visualização</p>
      </div>
    </div>
</div> <!-- fim editor -->
   <button type="button" ng-click='mashupEditor.click()' class="btn btn-primary">Salvar</button>
   <button type="button" ng-click='noteEditor.click(true)' class="btn btn-primary">Salvar e continuar editando</button>
</div>
</div>
{% endblock %}

{% block scriptsloaded %}
{% endblock %}
