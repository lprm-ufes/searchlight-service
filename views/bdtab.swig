<fieldset>
<legend>Fontes de dados</legend>
  <div class='form-group'>
    <ul class='list-group'>
        {% raw%}<li ng-repeat="ds in mashup.dataSources" class='list-group-item'><span class='pull-right'><a class='link-alterar' ng-click='mashupEditor.BDtab.alterar($index)' href='#'>Alterar</a> | <a class='link-remover' ng-click="mashupEditor.BDtab.remover($index,ds.url)" href='#'>Remover</a></span> <a href='{{ds.url}}' target='_blank'>{{ds.url}}</a></span></li> {% endraw %}
     </ul>

    <button type='button' class='btn btn-primary searchlight-btn-add-fonte' ng-click="mashupEditor.BDtab.alterar(-1)">Adicionar fonte</button>
  </div>
</fieldset>

<div id="bdtabpopup" class="modal fade" data-role='dialog'>
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h4 class="modal-title">Cadastrar fonte de dados</h4>
          </div>
          <div class="modal-body">
                <div class='form-group'>
                <label for='#{@idUrl}' class='control-label'>URL</label>
                <input type='url' class='form-control'  ng-model="modal.url" id='#{@idUrl}' placeholder='informe o endereço público dos dados'>
                <p class='help-block'>Formatos aceitos: json, jsonp, csv e google spreadsheet.</p>

                <label for='#{@idFunc}' class='control-label'>Código da função de conversão</label>
                <textarea ui-codemirror ui-codemirror-opts="editorOptions" ui-refresh='modal.refreshV' rows='6' type='text' class='form-control' id='#{@idFunc}' placeholder='código para converter os dados no formato do searchlight' ng-model="modal.func_code"></textarea>
                <br/>
                </div>
          </div> <!-- fim popup body-->
          <div class="modal-footer">
            <button type="button" class="btn btn-default cancelar" data-dismiss="modal">Cancelar</button>
            <button type="button" class="btn btn-primary ok" data-dismiss="modal" ng-click="mashupEditor.BDtab.save($event)">OK</button>
          </div>
        </div><!-- /.modal-content -->
      </div><!-- /.modal-dialog -->
</div> <!-- bdtabpopup -->

