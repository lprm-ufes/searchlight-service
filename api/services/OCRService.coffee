exec = require('child_process').exec
fs = require('fs')

module.exports = {
  # devolve o id da notebook responsavel por fazer o cache da fonte requisitada
  processOCR: (req,res,next)->
    #FIXME: nao permite OCR concorrente, eh preciso generalziar esse codigo
    #
    id = req.path.split('note/update/')[1].split('/')[0]
    Note.findOne({id:id}).exec((err, found)->
      try
        ocrjson = JSON.stringify(req.param('ocr'))
        console.log(ocrjson);
        fs.writeFileSync('/tmp/ocr.json',ocrjson)
        exec("bash /home/wancharle/searchlight-webapp/processaOCR.sh '#{found.fotoURL}' ",(error,stdout,stderr)->

          console.log(stdout,stderr,error)
          stdout = stdout.substr(stdout.indexOf('\n')+1)
          req.query.ocr_result = JSON.parse(stdout)
          return next()

         )
      catch
        return next()
    )

}
 
# vim: set ts=2 sw=2 sts=2 expandtab:
