Inprint.documents.Profile.Interaction = function(parent, panels) {

    var oid = parent.oid;

    var profile  = panels.profile;
    var files    = panels.files;
    var comments = panels.comments;

    parent.on("render", function() {
        parent.cmpReload();
    });

};
