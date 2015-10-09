exec = require('child_process').exec
fs = require('fs')
request = require('request')

module.exports = {
  processOCR: (req,res,next,privado)->
      req.file('file').upload (err,uploaded)->
        if err
          res.badRequest(err)
          return
        filename = uploaded[0].fd
        try
          ocr  = req.param('ocr')
          if ocr
            ocrjson = JSON.stringify(req.param('ocr'))
            nome = req.param('name')
            fs.writeFileSync("/tmp/#{nome}.json",ocrjson)
            exec("bash /home/wancharle/searchlight-webapp/processaOCR.sh '#{filename}' #{nome}",(error,stdout,stderr)->
              console.log('[[[',stdout,']]]',stderr,error)
              stdout = stdout.substr(stdout.indexOf('g\n')+1)
              ocr_result = JSON.parse(stdout)
              res.json(ocr_result)
            )
          else
            if req.param('privado')
              auth = "WANCHARLE:92355384-235D-4BA7-9662-D39D4D23B600"
              url = "http://"+auth+"@www.ocrwebservice.com/restservices/processDocument?language=brazilian&gettext=true"
              formData = { file: fs.createReadStream(filename+'') }
              request.post {url:url, formData: formData},  (err, httpResponse, body) ->
                if (err)
                  res.serverError('upload failed:', err)
                fs.unlinkSync(filename+'')
                res.json(JSON.parse(body))
            else
              res.badRequest("request malfeito")

        catch ex
          res.serverError(ex)

}
 
# vim: set ts=2 sw=2 sts=2 expandtab:
