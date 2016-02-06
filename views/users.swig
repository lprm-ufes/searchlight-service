{% extends "layout.swig" %}
{% block body %}
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.7/angular.min.js"></script>
<script>
angular.module('UserApp',[],function($locationProvider){
        $locationProvider.html5Mode({enabled:true,  requireBase: false });
}).controller('UserListController',['$scope','$http','$location', function($scope, $http,$location) {
    var userList = this;
    userList.users = [];
    userList.printUser = function (user){
        var json =  JSON.parse(angular.toJson(user));
        delete json.id;
        delete json.createdAt;
        delete json.updatedAt;
        for (var k in json){
           if (json.hasOwnProperty(k)){
                json[k]=JSON.stringify(json[k]);     
           }
        }
        return json; 
    }

    userList.deleteImg = function(user,next){
        img = user.fotoInfo
        console.log(img);
        if (img)
            $http.get('/user/deleteImg/',{params:{ key: img[0].extra.Key, bucket: img[0].extra.Bucket}}).success(function (data){
                next()
            });     
        else
            next();

    }

    userList.editar = function(user){
          query = $location.search()
          query.id = user.id
        $location.path('/user/edit/').search(query)
       window.location = $location.absUrl();
    }

    userList.viewNotes = function(user){
       window.location = '/note/html?user='+user.id
    }


    userList.remover = function(user){
        if ( confirm("tem certeza que deseja remover essa anotação? "))
        if ( confirm("tem certeza mesmo? "))
        userList.deleteImg(user,function(){ 
               $http.delete('/user/',{params:{id:user.id }}).success(function (data){ userList.update() });
        });
    }

    userList.update = function(){
        $http.get('/user/',{params:$location.search() }).success(function (data){
            userList.users = data     
        });
    }
    userList.update();

}]);
          
</script>
<br>
<br>
<div class="container" ng-app='UserApp'>
<div class="row" ng-controller='UserListController as userList'>
    <h1>Usuários </h1>
    <ul class="list-group">
     {% raw %}
     <table class="table">
    <thead>
      <tr>
        <th>Usuário</th>
        <th>Super</th>
        <th>Admin</th>
        <th>Ações </th>
      </tr>
    </thead>
    <tbody> 
        <tr ng-repeat='user in userList.users'>
          <td><a target="_blank" href="/user/{{user.id}}">{{ user.username | limitTo:20 }}</a></td>
          <td>
            <span ng-hide="user.isRoot" class="text-danger glyphicon glyphicon-minus-sign"></span> 
            <span ng-show="user.isRoot" class="text-success glyphicon glyphicon-ok-sign"/></td>
          <td>
            <span ng-hide="user.isAdmin" class="text-danger glyphicon glyphicon-minus-sign"></span> 
            <span ng-show="user.isAdmin" class="text-success glyphicon glyphicon-ok-sign"/></td>
        {% endraw %}{% if req.session.authenticated %}{% raw %}
          <td><button ng-click="userList.viewNotes(user)" class="btn btn-primary" title="visualizar nota"><span class="glyphicon glyphicon-th-list"/> Exibir anotações</button></td>
          <td><button ng-click='userList.editar(user)' class="btn btn-default" title="editar"><span class="glyphicon glyphicon-edit"/> Editar</button></td>
          <td><button ng-click='userList.remover(user)' class="btn btn-danger" title="remover"><span class="glyphicon glyphicon-trash"/> Apagar</button></td>
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
