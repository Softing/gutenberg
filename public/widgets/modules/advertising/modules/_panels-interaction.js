Inprint.advert.modules.Interaction = function(parent, panels) {

    var tree    = panels["editions"];
    var pages   = panels["pages"];
    var modules = panels["modules"];

    // Tree
    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        pages.disable();
        if (node) {
            parent.edition = node.attributes.id;
            pages.enable();
            pages.btnCreate.enable();
            pages.cmpLoad({ edition: node.attributes.id });
        }
    });

    //Grids
    pages.getSelectionModel().on("selectionchange", function(sm) {
        
        _disable(modules.btnCreate, pages.btnUpdate, pages.btnDelete);
        
        if (sm.getCount() == 0) {
            modules.disable();
        }
        
        if (sm.getCount() == 1) {
            
            modules.enable();
            
            modules.pageId = pages.getValue("id");
            modules.pageW  = pages.getValue("w");
            modules.pageH  = pages.getValue("h");
            
            if (modules.pageId && modules.pageW.length > 1 && modules.pageH.length > 1) {
                modules.btnCreate.enable();
            }
            
            modules.cmpLoad({ page: modules.pageId });
        }
        
        if (sm.getCount() == 1) {
            _enable(pages.btnUpdate, pages.btnDelete);
        } else if (sm.getCount() > 1) {
            _enable(pages.btnDelete);
        }
        
    }, parent);

    modules.getSelectionModel().on("selectionchange", function(sm) {
        
        _disable(modules.btnUpdate, modules.btnDelete);
        
        if (sm.getCount() == 1) {
            _enable(modules.btnUpdate, modules.btnDelete);
        } else if (sm.getCount() > 1) {
            _enable(modules.btnDelete);
        }
    }, parent);

}
