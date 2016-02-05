/**
 * sessionAuth
 *
 * @module      :: Policy
 * @description :: Simple policy to allow any authenticated user
 *                 Assumes that your login action in one of your controllers sets `req.session.authenticated = true;`
 * @docs        :: http://sailsjs.org/#!documentation/policies
 *
 */
module.exports = function(req, res, next) {

  // User is allowed, proceed to the next policy, 
  // or if this is the last policy, the controller
  if (req.session.isAdmin ) {
    return next();
  }else{
    model = req.options.model;

    if (model){
        var Model = req._sails.models[model];
        var id = req.param('id')
        Model.findOne({id:id}).exec(function(err,found){
            if (err) return res.serverError(err)
            if (found.user.id === req.session.user)
                return next()
            else
               return res.forbidden('You are not permitted to perform this action. You are not the owner of this data.');
        })
    }else{

    return next() // desconsidera  policie caso o controle nao for de model
    }
  }

  // User is not allowed
  // (default res.forbidden() behavior can be overridden in `config/403.js`)
};
