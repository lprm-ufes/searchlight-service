{% extends "layout.swig" %}
{% block body %}
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
.controller('MashupEditorController',['$scope','$http','$location', '$filter', function($scope, $http,$location,$filter) {
    var editor= this;
    var mashup = {};
    var modal = {};
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
        remover: function(index){
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
            editor.BDtab.load(data)
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
        <li><a data-toggle="tab" href="#coletortab">Coletor</a></li>
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
        <div id="bdtabpopup" class="modal fade" data-role='dialog'>
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                  <div class="modal-header">
                    <h4 class="modal-title">Cadastrar fonte de dados</h4>
                  </div>
                  <div class="modal-body">
                        <div class='form-group'>
                        <label for='#{@idUrl}' class='control-label'>URL</label>
                        <input type='url' class='form-control'  ng-model="modal.url" id='#{@idUrl}' placeholder='informe o endereço público dos dados'>
                        <p class='help-block'>Formatos aceitos: json, jsonp, csv e google spreadsheet.</p>

                        <label for='#{@idFunc}' class='control-label'>Código da função de conversão</label>
                        <textarea ui-codemirror ui-codemirror-opts="editorOptions" ui-refresh='modal.refreshV' rows='6' type='text' class='form-control' id='#{@idFunc}' placeholder='código para converter os dados no formato do searchlight' ng-model="modal.func_code"></textarea>
                        <br/>
                        </div>
                  </div> <!-- fim popup body-->
                  <div class="modal-footer">
                    <button type="button" class="btn btn-default cancelar" data-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-primary ok" data-dismiss="modal" ng-click="mashupEditor.BDtab.save($event)">OK</button>
                  </div>
                </div><!-- /.modal-content -->
              </div><!-- /.modal-dialog -->
            </div> <!-- bdtabpopup -->
        <fieldset>
        <legend>Fontes de dados</legend>
          <div class='form-group'>
            <ul class='list-group'>
                {% raw%}<li ng-repeat="ds in mashup.dataSources" class='list-group-item'><span class='pull-right'><a class='link-alterar' ng-click='mashupEditor.BDtab.alterar($index)' href='#'>Alterar</a> | <a class='link-remover' ng-click="mashupEditor.BDtab.remover($index)" href='#'>Remover</a></span> <a href='{{ds.url}}' target='_blank'>{{ds.url}}</a></span></li> {% endraw %}
             </ul>

            <button type='button' class='btn btn-primary searchlight-btn-add-fonte' ng-click="mashupEditor.BDtab.alterar(-1)">Adicionar fonte</button>
          </div>
        </fieldset>
      </div> <!-- fim bdTAB -->

      <div id="coletortab" style="padding:15px;" class="tab-pane fade">
        <p>coletor</p>
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
