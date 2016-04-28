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
[data-schemaid="multipla"] > h3,
[data-schemaid="texto-simples"] > h3,
[data-schemaid="formulario"] > h3{ display:none!important;margin:0px}
[data-schemaid="opcoes"] > h3{ margin:0px}
[data-schemaid="opcao"] > h3{ margin:0px}
</style>
<script type="text/javascript" src="/bower_components/codemirror/lib/codemirror.js"></script>
<script type="text/javascript" src="/bower_components/codemirror/mode/javascript/javascript.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jshint/r07/jshint.js"></script>
<script src="/bower_components/codemirror/addon/lint/lint.js"></script>
<script src="/bower_components/codemirror/addon/lint/javascript-lint.js"></script>
<script type="text/javascript" src="/bower_components/angular-ui-codemirror/ui-codemirror.js"></script>
<script type="text/javascript" src="/bower_components/editor/bootstrap-theme.js"></script>
<script type="text/javascript" src="/bower_components/editor/mashupeditor.js"></script>
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
        <li><a data-toggle="tab" ng-click="ViewTab.updateMirror()" href="#viewtab">Visualização</a></li>
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
        <div class="row">
            <div class="col-md-9" style="padding-right:0px;">
                <div id="actionEditor2"></div>
            </div>

            <div class="col-md-3" style="padding-left:0px">
                <div id="colframe" style="position:absolute;left:-100px;top:-200px;width:640px;height:1136px;margin-left:auto;background:URL(/images/iPhone_5.png) no-repeat;"></div>
            </div>
          </div>
      </div>

      <div id="servicotab" style="padding:15px;"  class="tab-pane fade">
        <p>serviço</p>
      </div>
      <div id="viewtab" style="padding:15px;" class="tab-pane fade">
        <p><a target="_blank" ng-click="ViewTab.click()">Visualização</a></p>
        <label for='view-extra' class='control-label'>Código da visualização Extra</label>
                <textarea ui-codemirror ui-codemirror-opts="editorOptions" ui-refresh='modal.refreshV' rows='6' type='text' class='form-control' id='view-extra' placeholder='código para visualização extra do searchlight' ng-model="mashup.viewExtra"></textarea>
 
      </div>
    </div>
</div> <!-- fim editor -->
   <button type="button" ng-click='mashupEditor.click()' class="btn btn-primary">Salvar</button>
   <button type="button" ng-click='noteEditor.click(true)' class="btn btn-primary">Salvar e continuar editando</button>
</div>
</div>
</br>
</br>
</br>
</br>
</br>
</br>
</br>
</br>
{% endblock %}

{% block scriptsloaded %}
{% endblock %}
