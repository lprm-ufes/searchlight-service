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
    delete json.properties.id;
    delete json.properties.createdAt;
    delete json.properties.updatedAt;
    delete json.required;
    return json;
  };
})
.filter('removeFields', function() {
  return function(data) {
    var json = JSON.parse(JSON.stringify(data)) 
        delete json.id;
        delete json.createdAt;
        delete json.updatedAt;
    return json;
  };
})
.controller('UserEditorController',['$scope','$http','$location', '$filter', function($scope, $http,$location,$filter) {
    var user = this;
    user.data = null;
    user.editor = null;

    user.click = function(continuar){
        $http.post('/user/update/'+user.data.data.id,user.editor.getValue()).success(function (data){
            if (!continuar){
                $location.search('id', null);
                $location.path('/user/html');
            }
            window.location = $location.absUrl(); 
        })
    }

    user.createEditor = function(){
        var star = $filter('removeFields')(user.data.data) 
        var schema = $filter('removeSchemaFields')(user.data.schema)
        schema.title = 'Usuário'
        schema.properties.isRoot = { format:'checkbox', type:'boolean'}
        schema.properties.isAdmin = { format:'checkbox', type:'boolean'}
        schema.required = ["isRoot","isAdmin"];
        user.editor = new JSONEditor(document.getElementById('editor'),{ schema: schema,
            startval:star,
            form_name_root:'user',
            disable_properties: true,
            disable_collapse: true,
            theme : 'bootstrap3'
        })
    }

    user.load = function(){
        $http.get('/user/schema/',{params:$location.search() }).success(function (data){
            user.data = data
            user.createEditor()
        });
    }
    user.load();
}]);
</script> 

<div class="container" ng-app='NoteApp'>
<div class="row" ng-controller='UserEditorController as userEditor'> 
    <div id="editor"></div>

   <button type="button" ng-click='userEditor.click()' class="btn btn-primary">Salvar</button>
   <button type="button" ng-click='userEditor.click(true)' class="btn btn-primary">Salvar e continuar editando</button>
</div>
</div>
{% endblock %}

{% block scriptsloaded %}
{% endblock %}
