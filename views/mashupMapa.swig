{% extends "layout.swig" %}
{% block body %}
<style>
#{{note.container_id}} {height:85%; width:100%;}
#map-{{note.container_id}} {width:100%; height:inherit;}
.tab-content { height:inherit;}
#lista-{{note.container_id}},#tab-{{note.container_id}} { height: 100%; overflow: auto}
html, body { height:100%;margin:0; margin-top:0px; padding:0;}
</style>
<div class="container" style="height:100%">
    <h2 style="text-align:center">{{ note.config.viewerTitle}}</h2>
    <div id="{{note.container_id}}"></div>
</div>
{% endblock %}


{% block scriptsloaded %}
<script> window.scriptFolder = 'http://wancharle.com.br/sl/' </script>
<script src="http://wancharle.com.br/sl/searchlight.min.js"></script>
<script>
var conf = {{ note|safe|json }};
L.Icon.Default.imagePath = "http://wancharle.com.br/sl/images/leaflet"                                                                                                          
var slv = new Searchlight(conf);
</script>
{% endblock %}
{% block footer %}{% endblock %}
{% block navbar %}{% endblock %}
