<div class="col-md-6">
<fieldset>
<legend>Ações</legend>
  <div class='form-group'>
    <ul class='list-group'>
        {% raw%}<li ng-repeat="action in mashup.acoes" class='list-group-item'><span class='pull-right'><a class='link-alterar' ng-click='ColetorTab.alterar($index)' href='#'>Alterar</a> | <a class='link-remover' ng-click="ColetorTab.remover($index)" href='#'>Remover</a></span> {{action.legenda}}</span></li> {% endraw %}
     </ul>

    <button type='button' class='btn btn-primary searchlight-btn-add-action' ng-click="ColetorTab.alterar(-1)">Adicionar ação</button>
  </div>
</fieldset>
</div>

<div class="col-md-6">
    <div id="colframe" style="position:relative;top:-200px;width:640px;height:1136px;margin-left:auto;background:URL(/images/iPhone_5.png) no-repeat;"></div>
</div>

<div id="coletortabpopup" class="modal fade" data-role='dialog'>
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h4 class="modal-title">Cadastrar fonte de dados</h4>
          </div>
          <div class="modal-body">
            <div id="actionEditor"></div>
          </div> <!-- fim popup body-->
          <div class="modal-footer">
            <button type="button" class="btn btn-default cancelar" data-dismiss="modal">Cancelar</button>
            <button type="button" class="btn btn-primary ok" ng-click="ColetorTab.save($event)">OK</button>
          </div>
        </div><!-- /.modal-content -->
      </div><!-- /.modal-dialog -->
</div> <!-- bdtabpopup -->

