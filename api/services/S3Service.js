
module.exports = {
  fotoUpload: function (req,res,create, fieldname, dirname,saveas) {
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
              params = req.params.all()
              params[fieldname+"Info"]=uploadedFiles
              params[fieldname+"URL"]=uploadedFiles[0].extra.Location
              return create(params)
              
            }
        
        }
    )

  }
}
// vim: set ts=2 sw=2 sts=2 expandtab:
