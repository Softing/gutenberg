Inprint.documents.Profile.Interaction = function(parent, panels) {
    
    var oid = parent.oid;
    
    var profile  = panels["profile"];
    var files    = panels["files"];
    var comments = panels["comments"];
    
    parent.on("render", function() {
        parent.cmpReload();
    });
    
    
    files.on("rowdblclick", function(thisGrid, rowIndex, evtObj) {
        
        thisGrid.selModel.selectRow(rowIndex);
        evtObj.stopEvent();
        
        var record = thisGrid.getStore().getAt(rowIndex);
        
        Inprint.ObjectResolver.resolve({
            aid: "document-editor",
            oid:  parent.document +"::"+ record.get("id"),
            text: record.get("filename"),
            description: _("Text editing")
        });
        
    }, this);
};
