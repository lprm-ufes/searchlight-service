/**
 * Bootstrap
 * (sails.config.bootstrap)
 *
 * An asynchronous bootstrap function that runs before your Sails app gets lifted.
 * This gives you an opportunity to set up your data model, run jobs, or perform some special logic.
 *
 * For more information on bootstrapping your app, check out:
 * http://sailsjs.org/#/documentation/reference/sails.config/sails.config.bootstrap.html
 */

module.exports.bootstrap = function(cb) {

   sails.models.note.native(function (err, collection) {
        collection.ensureIndex({ loc: '2dsphere' }, function () {

            collection.ensureIndex({ geo: '2dsphere' }, function () {
                cb();
            });
        });
    });
};
