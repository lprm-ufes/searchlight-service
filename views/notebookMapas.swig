{% extends "layout.swig" %}
{% block body %}
<br>
<br>
<div class="container">
<div class="row">
    <h1>Mapas cadastrados</h1>
    <ul class="list-group">
        {% for note in notebook.notes %}
            <li class="list-group-item"><a target="_blank" href="/note/mapa/{{note.id}}">{{ note.config.viewerTitle}}</a>
            <span class='pull-right'>
                <a class='link-remover' data-noteid='{{ note.id }}' href='#'>Remover</a></span>
            </li>
        {% endfor %}
    </ul>

</div>
</div>
{% endblock %}

{% block scriptsloaded %}
<script>
$('a.link-remover').click(function (){
      
      $.ajax({
         url: "/note/"+$(this).data('noteid'),
         type: "DELETE",
         crossDomain: true,
         success: function(){
             window.location='/notebook/maps';
             }
      } )
    
    });
</script>
{% endblock %}
