exec = require('child_process').exec
fs = require('fs')
request = require('request')
easyimg = require('easyimage')

module.exports = {
  process: (req,res,url)->
    match = url.match(/([^_]*)_(\d+)x(\d+)(.\w+)*/)
    if match == null
      res.notFound()
      return

    if match[4]
      key = match[1] + match[4]
    else
      key = match[1]
    urlCompleta = "http://#{sails.config.sl.S3ENDPOINT}/note/#{key}"
    urlDestino = "http://#{sails.config.sl.S3ENDPOINT}/note/#{url}"
    w = match[2]
    h = match[3]
    imgId = key
    imgThumbId = url

    srcImg = '/tmp/'+imgId
    destImg = '/tmp/'+imgThumbId
    key = 'note/'+imgThumbId

    request({uri: urlCompleta}).pipe(fs.createWriteStream(srcImg)).on('close', () ->
        easyimg.resize({
          src: srcImg, dst: destImg,
          width:w, height:h,
        }).then( (file) ->
            exec("s3cmd put #{destImg} s3://#{sails.config.sl.S3BUCKET}/#{key} --acl-public", (error,stdout,stderr)->
              if (error) 
                res.negotiate(error)
              else
               res.redirect(urlDestino)
            )
        ).fail((error)->
            res.negotiate(error)
        )
    )

    remove_imagens_antigas = "find /tmp/*.jpg -mtime +1 -exec rm {} \;" # apos 1dia

}
 
# vim: set ts=2 sw=2 sts=2 expandtab:
