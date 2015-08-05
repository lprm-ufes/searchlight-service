exec = require('child_process').exec

module.exports = {
  # devolve o id da notebook responsavel por fazer o cache da fonte requisitada
  processOCR: (req,res,next)->
    #FIXME: nao permite OCR concorrente, eh preciso generalziar esse codigo
    exec("wget '#{req.query.fotoURL}' -O /tmp/ocr.jpg -o /tmp/ocr.log",(error,stdout,stderr)->
      console.log(error,stdout,stderr)
      
    )
    return next()

}
 
# vim: set ts=2 sw=2 sts=2 expandtab:
