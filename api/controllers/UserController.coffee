# UserController
#
# @description :: Server-side logic for managing users
# @help        :: See http://links.sailsjs.org/docs/controllers

jsonSchemaGenerator = require('json-schema-generator')
module.exports =
  _config:
    populate:false

  logout: (req, res) ->
    req.session.authenticated = false
    req.session.destroy()
    if req.param('redirect')
        res.redirect('/') 
    else
        res.json {  ok:true}

  schema: (req,res)->
    id = req.param('id')
    User.findOne({id:id}).then((user)->
      schema = jsonSchemaGenerator(user.toJSON())
      res.json({schema:schema,data:user}) 
    ).catch((err)->
      res.json(err)
    )

  html: (req,res)->
    res.view('users')

  edit: (req,res)->
    res.view('userEdit')

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
            return
          if match
            # password match
            req.session.user = user.id
            req.session.username = user.username
            req.session.isRoot = user.isRoot
            req.session.isAdmin = user.isAdmin || user.isRoot
            req.session.authenticated = true
            res.json user
          else
            # invalid password
            if req.session.user
              req.session.user = null
            res.json { error: 'Invalid password' }, 400
      else
        res.json { error: 'User not found' }, 404

# vim: set ts=2 sw=2 sts=2 expandtab:
