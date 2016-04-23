<div class="col-md-6">
<fieldset>
<legend>Ações</legend>
  <div class='form-group'>
    <ul class='list-group'>
        {% raw%}<li ng-repeat="action in mashup.acoes" class='list-group-item'><span class='pull-right'><a class='link-alterar' ng-click='ColetorTab.alterar($index)' href='#'>Alterar</a> | <a class='link-remover' ng-click="ColetorTab.remover($index)" href='#'>Remover</a></span> {{action.legenda}}</span></li> {% endraw %}
     </ul>

    <button type='button' class='btn btn-primary searchlight-btn-add-action' ng-click="mashupEditor.BDtab.alterar(-1)">Adicionar ação</button>
  </div>
</fieldset>
</div>

<div class="col-md-6">
    <div id="colframe" style="position:relative;top:-200px;width:640px;height:1136px;margin-left:auto;background:URL(/images/iPhone_5.png) no-repeat;"></div>
</div>

