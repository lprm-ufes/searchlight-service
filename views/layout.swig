<!DOCTYPE html>
<html>
  <head>
    <title>New Sails App</title>

    <!-- Viewport mobile tag for sensible mobile support -->
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

    
    <!--  
        Stylesheets and Preprocessors
        ==============================

        You can always bring in CSS files manually with `<link>` tags, or asynchronously
        using a solution like AMD (RequireJS).  Or, if you like, you can take advantage 
        of Sails' conventional asset pipeline (boilerplate Gruntfile).

        By default, stylesheets from your `assets/styles` folder are included
        here automatically (between STYLES and STYLES END). Both CSS (.css) and LESS (.less)
        are supported. In production, your styles will be minified and concatenated into
        a single file.
        
        To customize any part of the built-in behavior, just edit `tasks/pipeline.js`.
        For example, here are a few things you could do:
            
            + Change the order of your CSS files
            + Import stylesheets from other directories
            + Use a different or additional preprocessor, like SASS, SCSS or Stylus
    -->

    <!--STYLES-->
    <link rel="stylesheet" href="/bower_components/bootstrap/dist/css/bootstrap.css">
    <!--STYLES END-->
  </head>

  <body>
    {% block navbar %}  
    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
        <a class="navbar-brand" href="/">Searchlight</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
        <ul class="nav navbar-nav navbar-right">

            {% if req.session.isAdmin %}
             <li><a href="/user/html">Usuários</a></li>
            {% endif %}
          
          <li><a href="/mashup/html">Mashups</a></li>
          <li><a href="/note/html?sort=updatedAt DESC">Notas</a></li>
            {% if req.session.authenticated %}
            <li class="dropdown">
              <a href="/user/html/{{req.session.user}}/" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">{{ req.session.username }} <span class="caret"></a>
              <ul class="dropdown-menu">
                <li><a href="/note/html?user={{req.session.user}}&sort=updatedAt DESC">Minhas anotações</a></li>
                <li role="separator" class="divider"></li>
                <li><a href="/user/logout?redirect=true">Sair</a></li>
              </ul>
            </li>
            {% else %}
          <li><a href="/user/login">login</a></li>
            {% endif %}
        </ul>
</div>
</div>
    </div>
    {% endblock %}
    {% block body %}
    {% endblock %}

    {% block footer %}
    <div class="container">
    <br>
    <footer class="footer">
        <div class="pull-right">
            <a href="spaces.wancharle.com.br/sl">Searchlight</a>
            <div>Uma plataforma para prototipagem de aplicações de crowdsourcing.</div>
        </div>
    </footer>
    </div>
    {% endblock %}

    <!--
        Client-side Templates
        ========================

        HTML templates are important prerequisites of modern, rich client applications.
        To work their magic, frameworks like Backbone, Angular, Ember, and Knockout require
        that you load these templates client-side.

        By default, your Gruntfile is configured to automatically load and precompile
        client-side JST templates in your `assets/templates` folder, then
        include them here automatically (between TEMPLATES and TEMPLATES END).
        
        To customize this behavior to fit your needs, just edit `tasks/pipeline.js`.
        For example, here are a few things you could do:

            + Import templates from other directories
            + Use a different template engine (handlebars, jade, dust, etc.)
            + Internationalize your client-side templates using a server-side
              stringfile before they're served.
    -->

    <!--TEMPLATES-->
    
    <!--TEMPLATES END-->


    <!--

      Client-side Javascript
      ========================

      You can always bring in JS files manually with `script` tags, or asynchronously
      on the client using a solution like AMD (RequireJS).  Or, if you like, you can 
      take advantage of Sails' conventional asset pipeline (boilerplate Gruntfile).

      By default, files in your `assets/js` folder are included here
      automatically (between SCRIPTS and SCRIPTS END).  Both JavaScript (.js) and
      CoffeeScript (.coffee) are supported. In production, your scripts will be minified
      and concatenated into a single file.
      
      To customize any part of the built-in behavior, just edit `tasks/pipeline.js`.
      For example, here are a few things you could do:
          
          + Change the order of your scripts
          + Import scripts from other directories
          + Use a different preprocessor, like TypeScript

    -->

    <!--SCRIPTS-->
    <script src="/bower_components/jquery/dist/jquery.js"></script>
    <script src="/bower_components/jquery.qrcode/dist/jquery.qrcode.min.js"></script>
    <script src="/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
    <script src="/js/dependencies/sails.io.js"></script>
    <!--SCRIPTS END-->

    {% block scriptsloaded %}
    {% endblock %}
  </body>
</html>
