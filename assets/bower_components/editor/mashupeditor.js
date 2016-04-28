angular.module('MashupApp',['ui.codemirror'],function($locationProvider){
        $locationProvider.html5Mode({enabled:true,  requireBase: false });
})
.controller('MashupEditorController',['$scope','$http','$location', '$filter','$sce', function($scope, $http,$location,$filter,$sce) {
    var editor= this;
    var mashup = {};
    var modal = {};
    var coletorTab = {};
    mashup.title = "";
    $scope.mashup = mashup;
    $scope.modal = modal;
    $scope.editorOptions = {
        lineNumbers: true,
        mode: 'javascript',
            gutters: ["CodeMirror-lint-markers"],
        lint:true,
    onLoad: function(_editor){
            $scope.codemirror = _editor;
            $scope.codemirror.refresh();
        }
    };
    editor.mashup = mashup;
    editor.data = null;

    editor.click = function(continuar){
       ColetorTab.save()
       editor.save()
        
    };
    editor.save = function (){
        params = JSON.parse(angular.toJson(mashup))
        console.log('para;',params)
        $http.post('/mashup/update/' +  params.id,params).success(function (data){
            ColetorTab.updateSimulador();
        })
 
    }
    // ColetorTab
    var ColetorTab = {
        iAction : 0,
        updateSimulador: function(){
            $('#colframe').html('<iframe scrolling="no" style="width:320px;height:568px;border:0px;margin-top:216px;margin-left:135px;" src="/slc/?mashup=http://sl.wancharle.com.br/mashup/'+mashup.id+'"></iframe>')
        },
        createActionEditor: function(){
           schema2 =  {
              type: "array",
              title: "Ações",
              format: "tabs",
              items: {
                title: "Ação",
                headerTemplate: "{{i}}",
                oneOf: [
                  {
                    $ref: "/bower_components/editor/form.json",
                    title: "Básico"
                  },
                  {
                    $ref: "/bower_components/editor/form_dynamic.json",
                    title: "Customizado"
                  }
                ]
              }
            }

            console.log(mashup.acoes)
            startval =  JSON.parse(angular.toJson(mashup.acoes))

            console.log(startval)
            if (ColetorTab.editor)
                ColetorTab.editor.destroy()
            ColetorTab.editor = new JSONEditor(document.getElementById('actionEditor2'),{ schema: schema2,
 ajax: true,
                startval:startval,
                form_name_root:'note',
                disable_properties: true,
                disable_edit_json: true,
                disable_array_reorder:true,
                no_additional_properties: true,
                        required_by_default: true,
                         
                disable_collapse: true,
                theme : 'bootstrapTheme'
            });
        },

        identificaAction: function(actions){
            for (i=0;i<actions.length;i++){
            if (actions[i].perguntas){
                actions[i].tipo = "dynamic-form"
            }}

            return actions
            
         },
        save: function ($event){
            errors = ColetorTab.editor.validate()
            if (errors.length){
                console.log("erros",errors.length,errors);
                return;
             }
            action = ColetorTab.editor.getValue()
            action = ColetorTab.identificaAction(action)
            mashup.acoes = action
            console.log(action)
            ColetorTab.createActionEditor();

        },
        load: function(data){
           if (data.acoes)
               mashup.acoes = data.acoes
           else
               mashup.acoes = []
           ColetorTab.createActionEditor();
        }
    }
    $scope.ColetorTab = ColetorTab;

    // ViewTab 
    var ViewTab = {
        click: function(){
            window.open("http://sl.wancharle.com.br/mashup/mapa/"+mashup.id )
        },
        load : function(data){
            if (data.viewExtra)
                mashup.viewExtra = data.viewExtra
            else
                mashup.viewExtra = "function main(html,data){ };" 
        },
        updateMirror: function(){
            setTimeout(function(){ $scope.codemirror.refresh();},600); // fix bug nao aparece no modo bootstrap modal
        }
    }
    $scope.ViewTab = ViewTab;

    // BDtab 
    editor.BDtab = {
        save: function($event){
            var popupValido = false
            if (modal.url){
              func_code = modal.func_code 
              try{
                func_name = "sl"+(new Date()).getTime()
                eval(func_name+" = "+func_code)
                func_code = eval(func_name)
                    
                popupValido = true
                editor.BDtab.saveDs()
              }catch(e){
                alert("ERRO no código da função de conversão:\n\n"+e.toString());
              }
            }else{
                alert("URL inválida!\n\nPor favor, informe uma url válida para a fonte de dados.");
            }
          
            if (!popupValido){
              $event.preventDefault()
              $event.stopImmediatePropagation()
              return false 
            }else{ 
              return true
            }
        },
        saveDs: function(){
            console.log(modal)
            if (modal.dsindex == -1){
                if (!mashup.dataSources)
                    mashup.dataSources = [];
                    mashup.dataSources.push({url:modal.url,func_code:modal.func_code});    
                
            }else{
                mashup.dataSources[modal.dsindex].url = modal.url
                mashup.dataSources[modal.dsindex].func_code = modal.func_code
            }
            console.log(angular.toJson(mashup.dataSources))
        }, 
        openPopup: function(id_fonte){
                editor.BDtab.loadFonte(id_fonte);
                $('#bdtabpopup').modal('show');
                setTimeout(function(){ $scope.codemirror.refresh();},600); // fix bug nao aparece no modo bootstrap modal
        },

        alterar: function(id_fonte){
           console.log(id_fonte);
           editor.BDtab.openPopup(id_fonte);
        },
        remover: function(index,url){
          if (confirm("Tem certeza que deseja remover esta fonte de dados ("+url+") ?"))
              mashup.dataSources.splice(index, 1);
        },
        loadFonte: function (i){
            modal.dsindex = i;
            console.log(i)
            if (i == -1){
                modal.url = "" 
                modal.func_code = ""
            }else{
                modal.url = mashup.dataSources[i].url
                modal.func_code = mashup.dataSources[i].func_code
            }
            //$scope.$apply();
        },
        load: function(data){
            mashup.dataSources = data.dataSources
        }
    }
    editor.load = function(){
        $http.get('/mashup/',{params:$location.search() }).success(function (data){
            console.log(data)
            editor.data = data
            mashup.title = data.title
            mashup.id = data.id
            ViewTab.load(data)
            editor.BDtab.load(data)
            ColetorTab.load(data)
        });
    }
    editor.load();
}]);

