# UserController
#
# @description :: Server-side logic for managing users
# @help        :: See http://links.sailsjs.org/docs/controllers

module.exports =
  login: (req, res) ->
    bcrypt = require 'bcrypt'

    User.findOneByUsername(req.param('username')).exec (err,user) => 
      if err
        res.json { error: 'DB error'}, 500

      if user
        pass = req.param('password')
        bcrypt.compare pass, user.password, (err, match) =>
          if err  
            res.json { error: 'Server error' }, 500
          if match
            # password match
            req.session.user = user.id
            res.json user
          else
            # invalid password
            if req.session.user
              req.session.user = null
            res.json { error: 'Invalid password' }, 400
      else
        res.json { error: 'User not found' }, 404

#vim: set ts=2 sw=2 sts=2 expandtab:
