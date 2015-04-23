request = require('request')
Promise = require("bluebird")
dms2decPTBR = require("dms2dec-ptbr")
require('string.prototype.endswith')
BABY = require('babyparse')
TABLETOP = require('tabletop')

module.exports = {
  fromNote: (req,res,noteid,fonteIndex)->
      Note.findOne({id:noteid}).exec (err,found) ->
        if not err and found
          NotesImporter.json(req,res, found.config.fontes[fonteIndex], found.user)
        else
          res.json({error: "Nota nao encontrada", log:err})

  convertData: (json,fonte) ->
    conversionFunc = eval("exports="+fonte.func_code)

    itens = json.map (item) ->
      return conversionFunc(item)
        
    return Promise.settle(itens)
  

  importData: (req,res,itens,fonte,force,notebookId,userId) ->
    if force
      # força importação apagando dados anteriores
      Note.destroy({notebook:notebookId}).then ()->
        Note.create itens.map( (i)->
          v=i.value()
          if v
            v.notebook=notebookId
            v.user=userId
            return v
          else
            return null).filter((i,e,a)-> if i then true else false )
        .exec ()->
          res.redirect('/note/lista?&limit=1000&notebook='+notebookId)

      .catch( (err)->  console.log(err);res.json(err))

    else
      # tenta importar se nao existir caso contrario da erro.
      Notebook.create({name:fonte.url,isNoteCache:"true"}).exec((err,notebook)->
        if (not err)
          Note.create(itens.map((i)->
            v=i.value()
            if v
              v.notebook=notebook.id
              v.user=userId
              return v
            else
              return null
          ).filter((i,e,a)-> if i then true else false )).exec(()->
            res.redirect('/note/lista?notebook='+notebook.id)
          )
        else
          res.json(err)
       
      )
  

  json:  (req,res,fonte,userId) ->
    # checa se url é interna ou externa
    if (fonte.url.indexOf(req.host) == -1)
        force = req.param('force');
        Notebook.findOne({name:fonte.url}).then( (item) ->
          if (force)
            NotesImporter.download(req,res,fonte,true,item.id,userId)
          else
            res.redirect('/note/lista?notebook='+item.id)
          
        ).catch( (err)->
            NotesImporter.download(req,res,fonte,false,null,userId)
            console.log(err)
        )
    else
      # ao tentar criar cache para dados do proprio servidor
      # redirecione para o endereço original no servidor
      res.redirect(fonte.url)

  download: (req,res,fonte,force,notebookId,userId) ->
    if fonte.url.endsWith('.csv')
      console.log('importando CSV',fonte.url)
      NotesImporter.csvDownload(req,res,fonte,force,notebookId,userId)
    else if fonte.url.endsWith('.json') or fonte.url.endsWith('.js')
      console.log('importando JSON',fonte.url)
      NotesImporter.jsonDownload(req,res,fonte,force,notebookId,userId)
    else
      console.log('importando google',fonte.url)
      NotesImporter.googleDownload(req,res,fonte,force,notebookId,userId)

  jsonDownload:  (req,res,fonte,force,notebookId,userId) ->
    request(fonte.url, (error,response,body) ->
      if ( not error)
        json = JSON.parse(body)
        NotesImporter.convertData(json,fonte).then( (itens) ->
          NotesImporter.importData(req,res,itens,fonte,force,notebookId,userId)
        )
    )
  
  csvDownload:  (req,res,fonte,force,notebookId,userId) ->
    request(fonte.url, (error,response,body) ->
      if ( not error)
        parsed = BABY.parse(body,{header:true})
        json = parsed.data
        console.log('csv baixado')
        NotesImporter.convertData(json,fonte).then( (itens) ->
          NotesImporter.importData(req,res,itens,fonte,force,notebookId,userId)
        )
      else
        console.log('error ao baixar CSV',error)
    )

  googleDownload:  (req,res,fonte,force,notebookId,userId) ->
    TABLETOP.init { key:fonte.url,parseNumbers:true, simpleSheet: true, callback: (data,tabletop) ->
        if ( data)
          NotesImporter.convertData(data,fonte).then( (itens) ->
            NotesImporter.importData(req,res,itens,fonte,force,notebookId,userId)
          )
        else
          res.json(tabletop)
    }
  
}

# vim: set ts=2 sw=2 sts=2 expandtab:
