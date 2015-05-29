 # MashupController
 #
 # @description :: Server-side logic for managing mashups
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports = {
    
  getCachedUrl: (req,res)->
    NotesImporter.getCachedURL(req,res)
 
}
