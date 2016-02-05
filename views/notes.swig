{% extends "layout.swig" %}
{% block body %}
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.7/angular.min.js"></script>
<script>
angular.module('NoteApp',[],function($locationProvider){
        $locationProvider.html5Mode({enabled:true,  requireBase: false });
}).controller('NoteListController',['$scope','$http','$location', function($scope, $http,$location) {
    var noteList = this;
    noteList.notes = [];
    noteList.printNote = function (note){
        var json =  JSON.parse(angular.toJson(note));
        delete json.geo ;
        delete json.user;
        delete json.notebook;
        delete json.id;
        delete json.fotoInfo;
        delete json.fotoURL;
        delete json.createdAt;
        delete json.updatedAt;
        delete json.hashid;
        delete json.latitude;
        delete json.longitude;
        for (var k in json){
           if (json.hasOwnProperty(k)){
                json[k]=JSON.stringify(json[k]);     
           }
        }
        return json; 
    }

    noteList.deleteImg = function(note,next){
        img = note.fotoInfo
        console.log(img);
        if (img)
            $http.get('/note/deleteImg/',{params:{ key: img[0].extra.Key, bucket: img[0].extra.Bucket}}).success(function (data){
                next()
            });     
        else
            next();

    }

    noteList.editar = function(note){
        window.location = "/note/edit/?id="+note.id
    }

    noteList.remover = function(note){
        if ( confirm("tem certeza que deseja remover essa anotação? "))
        noteList.deleteImg(note,function(){ 
               $http.delete('/note/',{params:{id:note.id }}).success(function (data){ noteList.update() });
        });
    }

    noteList.update = function(){
        $http.get('/note/',{params:$location.search() }).success(function (data){
            noteList.notes = data     
        });
    }
    noteList.update();

}]);
          
</script>
<br>
<br>
<div class="container" ng-app='NoteApp'>
<div class="row" ng-controller='NoteListController as noteList'>
    <h1>Notas </h1>
    <ul class="list-group">
     {% raw %}
     <table class="table">
    <thead>
      <tr>
        <th>Notebook</th>
        <th>User</th>
        <th>GeoLocation</th>
        <th>Media</th>
        <th>Conteúdo Dinâmico</th>
        <th>Ações </th>
      </tr>
    </thead>
    <tbody> 
        <tr ng-repeat='note in noteList.notes'>
          <td><a target="_blank" href="/notebook/{{note.notebook.id}}">{{ note.notebook.name }}</a></td>
          <td><a target="_blank" href="/user/{{note.user.id}}">{{ note.user.username }}</a></td>
          <td><a target="_blank" href="https://www.google.com.br/maps/place/{{ note.latitude}}+{{ note.longitude}}/@{{ note.latitude}},{{ note.longitude}},15z">{{ note.latitude | limitTo: 5}},{{ note.longitude | limitTo: 5}}</a></td>
          <td>
            <a ng-show="note.fotoURL" target="_blank" href="{{ note.fotoURL}}" ><span class="glyphicon glyphicon-picture" aria-hidden="true"></span></a>
          </td>
          <td><a target="_blank" href="/note/{{note.id}}"><pre><span ng-repeat="(key, value) in  noteList.printNote(note)">{{key}}: {{value | limitTo : 50}}
</span></pre></a></td>
        {% endraw %}
        {% if req.session.authenticated %}{% raw %}
          <td><button type="button" ng-click='noteList.editar(note)' class="btn btn-default">Editar</button></td>
          <td><button type="button" ng-click='noteList.remover(note)' class="btn btn-danger">Remover</button></td>
        {% endraw %}
        {% endif %}
        </tr>
    </tbody>
    </table>
    </ul>

</div>
</div>
{% endblock %}

{% block scriptsloaded %}
{% endblock %}
