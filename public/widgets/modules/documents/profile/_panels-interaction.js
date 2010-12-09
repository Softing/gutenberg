Inprint.documents.Profile.Interaction = function(parent, panels) {
    
    var oid = parent.oid;
    
    var profile  = panels["profile"];
    var files    = panels["files"];
    var comments = panels["comments"];
    
    parent.on("render", function() {
        parent.cmpReload();
    });
    
    
    files.on("rowdblclick", function(grid, index, e) {
        Inprint.ObjectResolver.resolve({
            aid: "document-editor",
            oid: this.oid,
            text: this.record.title,
            description: _("Text editing")
        });
    }, this);
};
