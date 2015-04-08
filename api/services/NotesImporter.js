var request = require('request')
var Promise = require("bluebird");

module.exports = {
  fromNote: function (req,res,noteid){
      Note.findOne({id:noteid}).exec(function (err,found){
          fonte = found.config.fontes[0] 
          NotesImporter.json(req,res,fonte,found.user)
          
          })
  },

  convertData: function (json,fonte){
    conversionFunc = eval("exports="+fonte.func_code)
   
    var itens = json.map(function (item){
                return conversionFunc(item)
            });
      
    return Promise.settle(itens)
  },

  importData: function (req,res,itens, fonte,force,notebookId,userId){
    if (force==true){
        Note.destroy({notebook:notebookId}).then(function (){
           Note.create(itens.map(function(i){v=i.value();v.notebook=notebookId;v.user=userId;return v;})).exec(function (){
            res.redirect('/note/lista?notebook='+notebookId)
           });
           
        }).catch(function (err){ console.log(err);res.json(err);});

    }else{
      Notebook.create({name:fonte.url}).exec(function (err,notebook){
          if (!err){
            Note.create(itens.map(function(i){v=i.value();v.notebook=notebook.id;v.user=userId; return v;})).exec(function (){
                res.redirect('/note/lista?notebook='+notebook.id)
              });
          }else{
              res.json(err)
          }
      })
    }
  },

  json: function (req,res,fonte,userId) {
    var force = req.param('force');
    //if (fonte.url.indexOf(req.host) == -1){
    Notebook.findOne({name:fonte.url}).then(function (item){
      if (force){
        NotesImporter.jsonDownload(req,res,fonte,true,item.id,userId);    
      }else{
        res.redirect('/note/lista?notebook='+item.id)
      }
    }).catch(function (err){
        NotesImporter.jsonDownload(req,res,fonte,false,null,userId);    
        console.log(err);
    });
   // }else{    res.json({error:'Nao é permitido importar dados do proprio servidor de destino'})}        
  }, 

  jsonDownload: function (req,res,fonte,force,notebookId,userId){
    request(fonte.url, function(error,response,body) {
        if (!error) {
            json = JSON.parse(body);
            NotesImporter.convertData(json,fonte).then(function (itens){
                NotesImporter.importData(req,res,itens,fonte,force,notebookId,userId);
             });
        }
    });
  }

}

