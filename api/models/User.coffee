module.exports =
  attributes: {
    username:
      type: 'string'
      unique: true
      required: true

    password:
      type: 'string'
      required: true
      minLength: 6

    notes:
      collection: 'note'
      via: 'user'
  }
  
  beforeCreate: (attrs,next) ->
    bcrypt = require('bcrypt')
    bcrypt.genSalt 10, (err, salt) =>
      if err
        return next(err)

      bcrypt.hash attrs.password, salt, (err, hash) =>
        if err
          return next(err)

        attrs.password = hash
        next()

# vim: set ts=2 sw=2 sts=2 expandtab:
