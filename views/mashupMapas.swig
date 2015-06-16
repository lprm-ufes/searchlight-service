{% extends "layout.swig" %}
{% block body %}
<br>
<br>
<div class="container">
<div class="row">
    <h1>Mashaps cadastrados</h1>
    <ul class="list-group">
        {% for mashup in mashups %}
            <li class="list-group-item"><a target="_blank" href="/mashup/mapa/{{mashup.id}}">{{ mashup.title}}</a>

            <span class='pull-right'>
                {% if not mashup.notdelete %}
                <a class='link-remover' data-mashupid='{{ mashup.id }}' href='#'>Remover</a>
                | {% endif %}
                <a href='/mashup/qrcode/{{mashup.id}}'>QRCODE</a>
                </span>
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
             window.location='/mashup/html';
             }
      } )
    
    });
</script>
{% endblock %}
