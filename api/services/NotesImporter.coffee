request = require('request')
Promise = require("bluebird")

module.exports = {
  fromNote: (req,res,noteid,fonteIndex)->
      Note.findOne({id:noteid}).exec (err,found)->
        NotesImporter.json(req,res,found.config.fontes[fonteIndex],found.user)

  convertData: (json,fonte) ->
    conversionFunc = eval("exports="+fonte.func_code)
   
    itens = json.map (item) ->
        return conversionFunc(item)
        
    return Promise.settle(itens)
  

  importData: (req,res,itens,fonte,force,notebookId,userId) ->
    if force
      # força importação apagando dados anteriores
      Note.destroy({notebook:notebookId}).then ()->
        Note.create itens.map (i)->
          v=i.value()
          v.notebook=notebookId
          v.user=userId
          return v
        .exec ()->
          res.redirect('/note/lista?notebook='+notebookId)

      .catch( (err)->  console.log(err);res.json(err))

    else
      # tenta importar se nao existir caso contrario da erro.
      Notebook.create({name:fonte.url,isNoteCache:"true"}).exec((err,notebook)->
        if (not err)
          Note.create(itens.map((i)->
            v=i.value()
            v.notebook=notebook.id
            v.user=userId
            return v
          )).exec(()->
            res.redirect('/note/lista?notebook='+notebook.id)
          )
        else
          res.json(err)
       
      )
  

  json:  (req,res,fonte,userId) ->
    # if (fonte.url.indexOf(req.host) == -1){
        force = req.param('force');
        Notebook.findOne({name:fonte.url}).then( (item) ->
          if (force)
            NotesImporter.jsonDownload(req,res,fonte,true,item.id,userId)
          else
            res.redirect('/note/lista?notebook='+item.id)
          
        ).catch( (err)->
            NotesImporter.jsonDownload(req,res,fonte,false,null,userId)
            console.log(err)
        )
    # else    res.json({error:'Nao é permitido importar dados do proprio servidor de destino'})}        


  jsonDownload:  (req,res,fonte,force,notebookId,userId) ->
    request(fonte.url, (error,response,body) ->
      if ( not error)
        json = JSON.parse(body)
        NotesImporter.convertData(json,fonte).then( (itens) ->
          NotesImporter.importData(req,res,itens,fonte,force,notebookId,userId)
        )
    )
  
}

# vim: set ts=2 sw=2 sts=2 expandtab:
