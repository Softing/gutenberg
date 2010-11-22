Inprint.documents.Profile.Interaction = function(parent, panels) {
    
    var oid = parent.oid;
    
    var profile  = panels["profile"];
    var files    = panels["files"];
    var comments = panels["comments"];
    
    parent.on("render", function() {
        
        Ext.Ajax.request({
            url: "/documents/profile/read/",
            scope:this,
            params: { id: oid },
            success: function(result) {
                var response = Ext.util.JSON.decode(result.responseText);
                profile.cmpFill(response.data);
                files.cmpFill(response.data);
                comments.cmpFill(response.data);
            },
            failure: function () {
                
            }
        });
        
    });
    
};
