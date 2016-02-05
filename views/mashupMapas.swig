{% extends "layout.swig" %}
{% block body %}
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.7/angular.min.js"></script>
<script>
angular.module('MashupApp',[],function($locationProvider){
        $locationProvider.html5Mode({enabled:true,  requireBase: false });
}).controller('MashupListController',['$scope','$http','$location', function($scope, $http,$location) {
    var mashupList = this;
    mashupList.mashups = [];

    mashupList.delete = function(mashup){
          if (confirm('Vc tem certeza que deseja apagar esse mashup?'))
            if (confirm('TEM CERTEZA MESMO?'))
               $http.delete('/mashup/',{params:{id:mashup.id }}).success(function (data){ mashupList.update() });
    }

    mashupList.update = function(){
        $http.get('/mashup/',{params:$location.search() }).success(function (data){
            mashupList.mashups = data     
        });
    }
    mashupList.update();

}]);
</script> 
<br>
<br>
<div class="container" ng-app='MashupApp'>
<div class="row" ng-controller='MashupListController as mashupList'>

    <h1>Mashups</h1>
    <ul class="list-group">
     {% raw %}
     <table class="table">
    <thead>
      <tr>
        <th>Título</th>
        <th>Visualizar</th>
        <th>Vincular</th>
        <th>Remover </th>
      </tr>
    </thead>
    <tbody> 
        <tr ng-repeat='mashup in mashupList.mashups'>
          <td><a target="_blank" href="/mashup/{{mashup.id}}">{{ mashup.title }}</a></td>
            <td><a target="_self" href="/mashup/mapa/{{ mashup.id }}" title='Visualizar mashup {{mashup.title}}' class=""><span class="glyphicon glyphicon-eye-open"></span> Visualizar</a></td>
            <td><a target="_self" href="/mashup/qrcode/{{ mashup.id }}" title='Vincular mashup {{mashup.title}}'><span class="glyphicon glyphicon-qrcode"></span> Vincular</a></td>
            <td><a ng-hide='mashup.notdelete' ng-click='mashupList.delete(mashup)' class="text-danger"><span class="glyphicon glyphicon-trash"></span> Remover</a> </td>
        </tr>
    </tbody>
    </table>
        {% endraw %}
    </ul>

</div>
</div>
{% endblock %}

