 # Note.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models


SLSAPI = require('slsapi')
parseFloatPTBR = SLSAPI.utils.parseFloatPTBR

module.exports =
  beforeCreate: (values,next) ->
    if values.latitude
      values.geo = {
        type: "Point",
        coordinates: [parseFloatPTBR(values.longitude), parseFloatPTBR(values.latitude)]
      }
    next()

  beforeUpdate: (values, next) ->
    if values.latitude
      values.geo = {
        type: "Point",
        coordinates: [parseFloatPTBR(values.longitude), parseFloatPTBR(values.latitude)]
      }
    next()

  attributes: {
    # associations
    user:
      model: 'user'
      required: true

    notebook:
      model: 'notebook'
      required: true

    # attributes
    fotoURL:
      type: 'string'

    categoria:
      type: 'string'
    
    comentarios:
      type: 'string'

    data_hora:
      type: 'string'

    # Geografics fields:
    latitude:
      type: 'string'
      required: true

    longitude:
      type: 'string'
      required: true

    loc:
      type: 'array'
      require: true
      index: '2dsphere'
    geo:
      index: '2dsphere'
      require: true
      type: 'Point'


    accuracy:
      type: 'string'
      
    altitude:
      type: 'string'
      
    altitudeAccuracy:
      type: 'string'

    speed:  # The speed in meters per second
      type: 'string'

    heading:  # The heading as degrees clockwise from North
      type: 'string'


      }

# vim: set ts=2 sw=2 sts=2 expandtab:
