 # NotebookController
 #
 # @description :: Server-side logic for managing Notebooks
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports = {
  _config:
    populate:false

  html: (req,res) ->
    Notebook.find().then( (notebooks)->
      res.view('notebookStorages',{notebooks:notebooks})
    )

  populateNotes: (req,res) ->
    # retorna a lista de notas de uma notebook
    Notebook.findOne({name:req.param('name')}).populate('notes').then( (notebook)->
      res.json(notebook) 
    )

}
# vim: set ts=2 sw=2 sts=2 expandtab:
