{% extends "layout.swig" %}
{% block body %}
<br>
<br>
<div class="container">
<div class="row">
<h1>Código QR de vinculamento</h1>
<div id='qrcode'></div>
</div>
</div>
{% endblock %}

{% block scriptsloaded %}
<script>
$(document).ready(function(){
$('#qrcode').empty().qrcode({ width:300,height:300,mode:0,'text': (""+window.location).replace('/qrcode','') });
})
</script>
{% endblock %}
