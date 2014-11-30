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

    #S3Service.fotoUpload(req,res,blueprintCreate, 'foto', 'note', 'ss4.jpg')

  create: (req,res, next) ->
    cb_create = (params) =>
      Note.create params, (err, note) =>
        if (err) 
          return next(err)
        res.status(201)
        res.json(note)

    S3Service.fotoUpload(req,res,cb_create,'foto','note')  
}
# vim: set ts=2 sw=2 sts=2 expandtab:
