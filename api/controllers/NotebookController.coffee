 # NotebookController
 #
 # @description :: Server-side logic for managing Notebooks
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports = {
    _config:
        populate:false
    qrcode: (req,res) ->
        res.view('notebookQrcode')
    }
