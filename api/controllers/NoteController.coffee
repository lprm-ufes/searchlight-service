 # NoteController
 #
 # @description :: Server-side logic for managing notes
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports = {
  anotar: (req,res) ->
    res.writeHead 200, {'content-type': 'text/html'}
    res.end '<form action="/note/create" enctype="multipart/form-data" method="post">
    <input type="text" name="title"><br>
    <input type="text" name="latitude" value="1"><br>
    <input type="text" name="longitude" value="1"><br>
    <input type="file" name="foto" multiple="multiple"><br>
    <input type="submit" value="upload">
    </form>'

  create: (req,res, next) ->
    cb_create = (params) =>
      Note.create params, (err, note) =>
        if (err) 
          return next(err)
        res.status(201)
        res.json(note)

    if req.param('fotoURL')
      S3Service.fotoUpload(req,res,cb_create,'foto','note')
    else
      cb_create(req.params.all())

lista: (req,res) ->
    ObjectId = require('mongodb').ObjectID;
    extend = require('node.extend')
    res.status(201)

    q = req.param('where')
    if q
      q = JSON.parse(q)
    else
      q = {}
    where = extend({},q)
    if req.param('notebook')
      where.notebook = req.param('notebook')
    console.log(req.query)
    if not req.param('lat')
      Note.find()
      .populate('user')
      .where(where)
      .sort({createdAt:'desc'})
      .exec (err,docxs)->
              res.jsonp(docxs)
    else
      pos = [ parseFloat(req.query.lng), parseFloat(req.query.lat)]
      console.log(pos)
      Note.native (err,collection)->
        collection.find(
          geo:
            $near:
              $geometry:
                type: 'Point'
                coordinates: pos
              $maxDistance:1000 
              $distanceMultiplier: 6371

        ).toArray (mongoErr,docs)->
          if (mongoErr) 
            console.error(mongoErr)
            res.send('geoProximity failed with error='+mongoErr)
          else
            where.id= (new ObjectId(""+d._id) for d in docs )
            console.log(where)
            Note.find()
            .populate('user')
            .where(where)
            .exec (err,docxs)->
              res.jsonp(docxs)
              
}
# vim: set ts=2 sw=2 sts=2 expandtab:
