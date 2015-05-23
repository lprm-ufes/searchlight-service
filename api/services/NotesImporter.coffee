SLSAPI = require('slsapi')

module.exports = {
  # devolve o id da notebook responsavel por fazer o cache da fonte requisitada
  getCachedURL: (req,res)->
    NotesImporter.fromNote req, req.param('noteid'), req.param('fonteIndex'), (err,notebookId)->
      if err
        res.badRequest(err)
        console.log(err)
      else
        res.json({cachedUrl:"http://#{req.host}/note/lista?notebook=#{notebookId}"})

  fromNote: (req,noteid,fonteIndex,next)->
      Note.findOne({id:noteid}).exec (err,found) ->
        if not err and found
          if not found.config.dataSources
            found.config.dataSources = found.config.fontes
          fonte = found.config.dataSources[fonteIndex]
          # checa se url é interna ou externa
          if (fonte.url.indexOf(req.host) == -1)
              force = req.param('forceImport')
              Notebook.findOne({name:fonte.url}).then( (notebook) ->
                if (force)
                  NotesImporter.download(found,fonteIndex,notebook.id,next)
                else
                  next(null,notebook.id)
              ).catch( (err)->
                  NotesImporter.download(found,fonteIndex,false,next)
              )
          else
            # ao tentar criar cache para dados do proprio servidor
            # redirecione para o endereço original no servidor
            next({error:'tentando criar cache com dados do mesmo servidor'})
        else
          next({error: "Nota '#{noteid}'nao encontrada"})
 
  download: (noteconfig,fonteIndex,notebookId,next)->
        api = new SLSAPI(noteconfig.config)
        api.on SLSAPI.Config.EVENT_READY,()->
          dataPool = SLSAPI.dataPool.createDataPool(api.config)
          dataPool.loadOneData(fonteIndex)
          api.on SLSAPI.dataPool.DataPool.EVENT_LOAD_STOP, (dataPool)->
              dataSource = dataPool.dataSources[fonteIndex] 
              NotesImporter.importData(
                dataSource,
                notebookId,
                noteconfig.user,
                next)

  importData: (dataSource,notebookId,userId,next) ->
    if notebookId
      # força importação apagando dados anteriores
      Note.destroy({notebook:notebookId})
      .then ()->
        NotesImporter.createNotes(dataSource.notes,notebookId,userId,next)
      .catch(
        (err)->  console.log(err);next(err))

    else
      # tenta importar se nao existir caso contrario da erro.
      Notebook.create({name:dataSource.url,isNoteCache:"true"}).exec((err,notebook)->
        if (not err)
          NotesImporter.createNotes(dataSource.notes,notebook.id,userId,next)
        else
          next(err)
       
      )

  createNotes:(itens,notebookId, userId,next)->
    Note.create itens.map( (i)->
          v=i
          if v
            v.notebook=notebookId
            v.user=userId
            return v
          else
            return null).filter((i,e,a)-> if i then true else false )
    .exec (err,notes)->
      next(err,notebookId)


    }
 
# vim: set ts=2 sw=2 sts=2 expandtab:
