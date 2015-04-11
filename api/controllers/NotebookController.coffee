 # NotebookController
 #
 # @description :: Server-side logic for managing Notebooks
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports = {
    _config:
        populate:false
    qrcode: (req,res) ->
        res.view('notebookQrcode')

    populateNotes: (req,res) ->
        # retorna a lista de notas de uma notebook
        Notebook.findOne({name:req.param('name')}).populate('notes').then( (notebook)->
          res.json(notebook) 
       )
        

    mapas: (req,res) ->
       Notebook.findOne({name:'mapas'}).populate('notes').then( (notebook)->
          res.json(notebook) 
       )
    maps: (req,res) ->
        Notebook.findOne({name:'mapas'}).populate('notes').then( (notebook)->
          res.view('notebookMapas',{notebook:notebook})
       )


    }

# vim: set ts=2 sw=2 sts=2 expandtab:
