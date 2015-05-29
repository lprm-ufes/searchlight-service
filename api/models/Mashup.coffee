 # Mashup.coffee
 #
 # @description :: Model who is responsible by store the settings of a mashup 
 # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =
  beforeCreate: (values,cb)->
    Mashup.findOne({title:values.title,user:values.user}).exec  (err,result)->
      if not err and result
        cb('already exists mashup with this combination of title and user')
      else
        cb()


  attributes: {

    user:
      model: 'user'
      required: true

    storageNotebook:
      model: 'notebook'
      required: false

    title:
      type: 'string'
      required: true
}

# vim: set ts=2 sw=2 sts=2 expandtab:
