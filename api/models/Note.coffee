 # Note.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =

  attributes: {
    user:
      model: 'user'

    category:
      type: 'string'

    # Geografics fields:
    latitude:
      type: 'float'
      required: true

    longitude:
      type: 'float'
      required: true

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
