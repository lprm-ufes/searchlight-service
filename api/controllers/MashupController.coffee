 # MashupController
 #
 # @description :: Server-side logic for managing mashups
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports = {
    
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
    Mashup.findOne({id:id}).then((note)->
      if not note.container_id
          note.container_id = 'map'
      res.view('mashupMapa',{note:note})
    ).catch((err)->
      res.json(err)
    )



}
