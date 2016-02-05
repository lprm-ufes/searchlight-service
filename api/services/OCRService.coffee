exec = require('child_process').exec
fs = require('fs')
request = require('request')

module.exports = {
  processOCR: (req,res,next,privado)->
      req.file('file').upload (err,uploaded)->
        console.log("erro=",err,"\nuploaded=",uploaded)
        if err
          res.badRequest(err)
          return
        if uploaded.length==0
          res.badRequest("nao recebi o arquivo do upload")
          return 
        filename = uploaded[0].fd
        try
          ocr  = req.param('ocr')
          if ocr
            ocrjson = ocr #JSON.parse(ocr)
            nome = req.param('name')
            fs.writeFileSync("/tmp/#{nome}.json",ocrjson)
            exec("bash /home/wancharle/searchlight-webapp/processaOCR.sh '#{filename+''}' #{nome}",(error,stdout,stderr)->
              console.log('[[[',stdout,']]]',stderr,error)
              stdout = stdout.substr(stdout.indexOf('g\n')+1)
              try
                ocr_result = JSON.parse(stdout)
              catch ex
                res.serverError(ex)
                return 
              res.json(ocr_result)
            )
          else
            if req.param('privado')
              auth = "fernando:80463F29-76B9-497E-B009-A10F738F636D"
              url = "http://"+auth+"@www.ocrwebservice.com/restservices/processDocument?language=brazilian&gettext=true"
              formData = { file: fs.createReadStream(filename+'') }
              request.post {url:url, formData: formData},  (err, httpResponse, body) ->
                if (err)
                  res.serverError('upload failed:', err)
                console.log(body)
                fs.unlinkSync(filename+'')
                res.json(JSON.parse(body))
            else
              res.badRequest("request malfeito")

        catch ex
          res.serverError(ex)

}
 
# vim: set ts=2 sw=2 sts=2 expandtab:
