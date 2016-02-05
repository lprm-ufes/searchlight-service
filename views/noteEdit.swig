{% extends "layout.swig" %}
{% block body %}
<script src="http://rawgit.com/wancharle/json-editor/master/dist/jsoneditor.js"></script>
<br>
<br>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.7/angular.min.js"></script>
<script>
angular.module('NoteApp',[],function($locationProvider){
        $locationProvider.html5Mode({enabled:true,  requireBase: false });
})
.filter('removeSchemaFields', function() {
  return function(schema) {
    var json = JSON.parse(JSON.stringify(schema)) 
    delete json.properties.geo ;
    delete json.properties.user;
    delete json.properties.notebook;
    delete json.properties.id;
    delete json.properties.hashid;
    delete json.properties.fotoInfo;
    delete json.properties.createdAt;
    delete json.properties.updatedAt;
    delete json.required;
    return json;
  };
})
.filter('removeFields', function() {
  return function(data) {
    var json = JSON.parse(JSON.stringify(data)) 
        delete json.geo ;
        delete json.user;
        delete json.notebook;
        delete json.id;
        delete json.hashid;
        delete json.fotoInfo;
        delete json.createdAt;
        delete json.updatedAt;
    return json;
  };
})
.controller('NoteEditorController',['$scope','$http','$location', '$filter', function($scope, $http,$location,$filter) {
    var note = this;
    note.data = null;
    note.editor = null;

    note.click = function(continuar){
        $http.post('/note/update/'+note.data.data.id,note.editor.getValue()).success(function (data){
            if (continuar)
             window.location = "/note/edit?id="+note.data.data.id
            else
             window.location = "/note/html?notebook="+note.data.data.notebook
        })
    }

    note.createEditor = function(){
        var star = $filter('removeFields')(note.data.data) 
        var schema = $filter('removeSchemaFields')(note.data.schema)
        schema.title = 'Note'
        note.editor = new JSONEditor(document.getElementById('editor'),{ schema: schema,
            startval:star,
            form_name_root:'note',
            disable_properties: true,
            disable_collapse: true,
            theme : 'bootstrap3'
        })
    }

    note.load = function(){
        $http.get('/note/schema/',{params:$location.search() }).success(function (data){
            note.data = data
            note.createEditor()
        });
    }
    note.load();
}]);
</script> 

<div class="container" ng-app='NoteApp'>
<div class="row" ng-controller='NoteEditorController as noteEditor'> 
    <div id="editor"></div>

   <button type="button" ng-click='noteEditor.click()' class="btn btn-primary">Salvar</button>
   <button type="button" ng-click='noteEditor.click(true)' class="btn btn-primary">Salvar e continuar editando</button>
</div>
</div>
{% endblock %}

{% block scriptsloaded %}
{% endblock %}
