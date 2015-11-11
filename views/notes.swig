{% extends "layout.swig" %}
{% block body %}
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.7/angular.min.js"></script>
<script>
angular.module('NoteApp',[],function($locationProvider){
        $locationProvider.html5Mode({enabled:true,  requireBase: false });
}).controller('NoteListController',['$scope','$http','$location', function($scope, $http,$location) {
    var noteList = this;
    noteList.notes = [
    ]
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
        return json; 
    }


    $http.get('/note/',{params:$location.search() }).success(function (data){
        noteList.notes = data     
    });

}]);
          
</script>
<br>
<br>
<div class="container" ng-app='NoteApp'>
<div class="row" ng-controller='NoteListController as noteList'>
    <h1>Notas cadastradas</h1>
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
        </tr>
    </tbody>
    </table>
        {% endraw %}
    </ul>

</div>
</div>
{% endblock %}

{% block scriptsloaded %}
<script>
$('a.link-remover').click(function (){
      
      $.ajax({
         url: "/mashup/"+$(this).data('mashupid'),
         type: "DELETE",
         crossDomain: true,
         success: function(){
             window.location='/mashup/html';
             }
      } )
    
    });
</script>
{% endblock %}
