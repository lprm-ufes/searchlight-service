{% extends "layout.swig" %}
{% block body %}
<br>
<br>
<div class="container">
<div class="row">
    <h1>Mapas cadastrados</h1>
    <ul class="list-group">
        {% for mashup in mashups %}
            <li class="list-group-item"><a target="_blank" href="/mashup/mapa/{{mashup.id}}">{{ mashup.title}}</a>
            {% if not mashup.notdelete %}
            <span class='pull-right'>
                <a class='link-remover' data-mashupid='{{ mashup.id }}' href='#'>Remover</a></span>
            {% endif %}
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
         url: "/mashup/"+$(this).data('mashupid'),
         type: "DELETE",
         crossDomain: true,
         success: function(){
             window.location='/mashup/maps';
             }
      } )
    
    });
</script>
{% endblock %}
