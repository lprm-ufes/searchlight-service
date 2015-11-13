
module.exports = {
  fotoUpload: function (req,res,next, fieldname, dirname,saveas) {
    req.file(fieldname).upload({
      adapter: require('skipper-s3'),
      key: sails.config.sl.S3KEY,
      secret: sails.config.sl.S3SECRET,
      bucket: sails.config.sl.S3BUCKET,
      region: sails.config.sl.S3REGION,
      dirname: dirname,
      saveAs: saveas,
      headers: {
        'x-amz-acl':'public-read'
        }
      }, function whenDone(err, uploadedFiles){
            if (err){
              return res.negotiate(err)
            }else{
              console.log(uploadedFiles)
              if (uploadedFiles.length == 0)
              {res.status(400)
                return res.send('não foi possível acessar a variavel files')
              }
              req.query.fotoInfo=uploadedFiles
              req.query.fotoURL=uploadedFiles[0].extra.Location
              return next()
              
            }
        
        }
    )

  }
}
// vim: set ts=2 sw=2 sts=2 expandtab:
