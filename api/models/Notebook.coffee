 # Notebook.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =

  attributes: {
    afterDestroy: (notebooksDestroyed,next)->
      ids = _.pluck(destroyedCompany, 'id')

      if(ids and ids.length)
        Note.destroy({notebook: ids}).exec(
          (e,r)->
            next()
        )
      else
        next()
        
    name:
      type: 'string'
      unique: true
      required: true

    notes:
      collection: 'note'
      via: 'notebook'
  
 
      
      }

# vim: set ts=2 sw=2 sts=2 expandtab:
