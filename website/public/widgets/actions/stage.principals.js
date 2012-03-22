Inprint.setAction("stage.principals", function(grid) {

    win = new Inprint.cmp.PrincipalsSelector({
        urlLoad: "/catalog/stages/principals-mapping/",
        urlDelete: "/catalog/stages/unmap-principals/"
    });

    win.on("show", function(win) {
        win.panels.selection.cmpLoad({
            stage: grid.getValue("id")
        });
    });

    win.on("close", function(win) {
        grid.cmpReload();
    });

    win.on("save", function(srcgrid, catalog, ids) {
        Ext.Ajax.request({
            url: "/catalog/stages/map-principals/",
            params: {
                stage: grid.getValue("id"),
                catalog: catalog,
                principals: ids
            },
            success: function() {
                srcgrid.cmpReload();
            }
        });
    });

    win.on("delete", function(srcgrid, ids) {
        Ext.Ajax.request({
            url: "/catalog/stages/unmap-principals/",
            params: {
                principals: ids
            },
            success: function() {
                srcgrid.cmpReload();
            }
        });
    });

    win.show();

});
