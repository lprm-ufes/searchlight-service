{% extends "layout.swig" %}
{% block body %}
<br>
<br>
<div class="container">
<div class="row">
    <h1>Notebooks cadastrados</h1>
    <ul class="list-group">
        {% for notebook in notebooks %}
            <li class="list-group-item"><a target="_blank" href="/note/?notebook={{notebook.id}}">{{ notebook.name}}</a>
            {% if notebook.isNoteCache %}
            <span class='pull-right'>
                <a class='link-remover' data-notebookid='{{ notebook.id }}' href='#'>Remover</a></span>
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
         url: "/notebook/"+$(this).data('notebookid'),
         type: "DELETE",
         crossDomain: true,
         success: function(){
             window.location='/notebook/html';
             }
      } )
    
    });
</script>
{% endblock %}
