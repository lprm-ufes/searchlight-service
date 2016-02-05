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
.controller('LoginController',['$scope','$http',function($scope, $http) {
    var login = this;
    login.user = null;

    login.do = function(user){

        $http.post('/user/login',{username:user.name,password:user.password}).then(
            function (data){
                window.location = "/"
            },function (error){
               $('#alerta').show();
            });
    }

}]);
</script> 

<style>.form-signin {
  max-width: 380px;
  padding: 15px;
  margin: 0 auto;
}
.form-signin .form-signin-heading,
.form-signin .checkbox {
  margin-bottom: 10px;
}
.form-signin .checkbox {
  font-weight: normal;
}
.form-signin .form-control {
  position: relative;
  height: auto;
  -webkit-box-sizing: border-box;
     -moz-box-sizing: border-box;
          box-sizing: border-box;
  padding: 10px;
  font-size: 16px;
}
.form-signin .form-control:focus {
  z-index: 2;
}
.form-signin input[type="email"] {
  margin-bottom: -1px;
  border-bottom-right-radius: 0;
  border-bottom-left-radius: 0;
}
.form-signin input[type="password"] {
  margin-bottom: 10px;
  border-top-left-radius: 0;
  border-top-right-radius: 0;
}

</style>
<div class="container" ng-app='NoteApp'>
<div ng-controller='LoginController as login'> 

      <form class="form-signin">
        <h2 class="form-signin-heading">Por favor identifique-se</h2>

 <div style="display:none" class="alert alert-danger" role="alert" id="alerta"> <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button><strong>Atenção!</strong> Usuário ou Senha incorretos</div>
        <label for="inputEmail" class="sr-only">Usuário</label>
        <input type="user" id="inputUser" class="form-control" placeholder="Usuario" required autofocus ng-model="user.name">
        <label for="inputPassword" class="sr-only">Senha</label>
        <input type="password" id="inputPassword" class="form-control" placeholder="Senha" required ng-model="user.password">
        <div class="checkbox">
          <label>
            <input type="checkbox" value="remember-me"> Permanecer conectado
          </label>
        </div>

        <button class="btn btn-lg btn-primary btn-block" type="submit" ng-click="login.do(user)">Entrar</button>
      </form>


</div>
{% endblock %}

{% block scriptsloaded %}
{% endblock %}
