 # NoteController
 #
 # @description :: Server-side logic for managing notes
 # @help        :: See http://links.sailsjs.org/docs/controllers

exec = require('child_process').exec
SLSAPI = require('slsapi')
parseFloatPTBR = SLSAPI.utils.parseFloatPTBR

jsonSchemaGenerator = require('json-schema-generator')
module.exports = {
  thumbnail: (req,res)->
    Thumbnail.process(req,res,req.param('id'))

  deleteImg: (req,res)->
    bucket=req.param('bucket')
    key=req.param('key')
    exec("s3cmd rm s3://#{bucket}/#{key}", (error,stdout,stderr)->
      if (error) 
        res.send(error)
      else
        res.send(stdout)
    ) 

  html: (req,res) ->
    res.view('notes')

  edit: (req,res)->
    res.view('noteEdit')

  schema: (req,res)->
    id = req.param('id')
    Note.findOne({id:id}).then((note)->
      schema = jsonSchemaGenerator(note.toJSON())
      res.json({schema:schema,data:note}) 
    ).catch((err)->
      res.json(err)
    )

  anotar: (req,res) ->
    res.writeHead 200, {'content-type': 'text/html'}
    res.end '<form action="/note/create" enctype="multipart/form-data" method="post">
    <input type="text" name="title"><br>
    <input type="text" name="latitude" value="1"><br>
    <input type="text" name="longitude" value="1"><br>
    <input type="file" name="foto" multiple="multiple"><br>
    <input type="submit" value="upload">
    </form>'


  destroyOrphans: (req,res) ->
    Notebook.find().then( (notebooks)->
       ids = _.pluck(notebooks,'id')
       Note.destroy({notebook:{'!':ids}}).then((notes)-> 
        res.json(notes)
      )
    )
     

  lista: (req,res) ->
    ObjectId = require('mongodb').ObjectID;
    extend = require('node.extend')
    res.status(201)
    limite = if req.param('limit') then parseInt(req.param('limit')) else 10000

    q = req.param('where')
    if q
      q = JSON.parse(q)
    else
      q = {}
    where = extend({},q)
    if req.param('notebook')
      where.notebook = req.param('notebook')
    if not req.param('lat')
      Note.find()
      .populate('user')
      .where(where)
      .limit(limite)
      .sort({createdAt:'desc'})
      .exec (err,docxs)->
              res.jsonp(docxs)
    else
      pos = [ parseFloatPTBR(req.query.lng), parseFloatPTBR(req.query.lat)]
      distance=parseInt(req.query.distance or 1000)
      Note.native (err,collection)->
        collection.find(
          geo:
            # metodo sem ordenacao que permite buscar por mais de 100 resultados ao contrario do $near
            #$geoWithin: 
            #  $centerSphere: [ pos, distance/6371000]
            $near:
              $geometry:
                type: 'Point'
                coordinates: pos
              $maxDistance:distance 
              $distanceMultiplier: 6371

        ).toArray (mongoErr,docs)->
          if (mongoErr) 
            console.error(mongoErr)
            res.send('geoProximity failed with error='+mongoErr)
          else
            where.id= (new ObjectId(""+d._id) for d in docs )
            # ordem eh perdida aqui
            Note.find()
            .populate('user')
            .where(where).limit(limite)
            .exec (err,docxs)->
              res.jsonp(docxs)

  ocr: (req,res)->
    OCRService.processOCR(req,res)
             
}
# vim: set ts=2 sw=2 sts=2 expandtab:
