 # MashupController
 #
 # @description :: Server-side logic for managing mashups
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports = {
   removeField: (req,res)->
    model = req.param('model')
    if not model
      return res.serverError({error:'informe o model'})
    model.toLowerCase()
    fields = {$unset:{}}
    fields.$unset[req.param('field')]=""
    sails.models[model].native((err,collection)->
      if err
        return res.serverError(err)
      collection.update({},fields,{ multi:true},(err, results) ->
          if (err)
            return res.serverError(err)
          return res.json(results)
      )
    )
  getCachedUrl: (req,res)->
    NotesImporter.getCachedURL(req,res)
 
  qrcode: (req,res) ->
    res.view('mashupQRcode')

  html: (req,res) ->
    Mashup.find().then( (mashups)->
      res.view('mashupMapas',{mashups:mashups})
  )

  mapa: (req,res) ->
    id = req.param('id')
    height = req.param('height')
    Mashup.findOne({id:id}).then((note)->
      if not note.container_id
          note.container_id = 'map'
      res.view('mashupMapa',{note:note,height:height})
    ).catch((err)->
      res.json(err)
    )

  flat: (req,res)->
    id = req.param('id')
    if id
        Mashup.findOne({id:id}).then((note)->
          res.json(note)
        ).catch((err)->
          res.json(err)
        )
    else
        Mashup.find( (err, users) ->
            if (err)
                return res.serverError(err)
            return res.json(users)
        )
    


}
