Inprint.catalog.editions.Actions = function(parent, panels) {

    var tree = panels.tree;
    var grid = panels.grid;

    var components = {};
    grid.actions = {};

    // Stages
    grid.actions.createStage = function() {
        var win = components["create-stage-window"];
        if (!win) {
            win = Inprint.catalog.editions.CreateStagePanel();
            win.on("actioncomplete", function (form, action) {
                if (action.type == "submit") {
                    win.hide();
                    grid.cmpReload();
                }
            });
            components["create-stage-window"] = win;
        }
        var form = win.items.first().getForm();
        form.reset();

        form.findField("branch").setValue(tree.cmpCurrentNode().id);

        win.show();
    };

    grid.actions.changeStage = function() {

        var win = components["change-stage-window"];
        if (!win) {
            win = Inprint.catalog.editions.ChangeStagePanel();
            win.on("actioncomplete", function (form, action) {
                if (action.type == "submit") {
                    win.hide();
                    grid.cmpReload();
                }
            });
            components["change-stage-window"] = win;
        }
        win.show();
        win.body.mask(_("Loading..."));
        var form = win.items.first().getForm();
        form.reset();

        form.load({
            scope:this,
            url: _url("/catalog/stages/read/"),
            params: { id: grid.getValue("id") },
            success: function(form, action) {
                win.body.unmask();
            },
            failure: function(form, action) {
                Ext.Msg.alert("Load failed", action.result.errorMessage);
            }
        });


    };

    grid.actions.removeStage = function() {
        Ext.MessageBox.confirm(_("Edition removal"), _("You really wish to do this?"), function(btn) {
            if (btn == "yes") {
                Ext.Ajax.request({
                    scope:this,
                    url: _url("/catalog/stages/delete/"),
                    params: { id: grid.getValues("id") },
                    success: function(form, action) {
                        grid.cmpReload();
                    }
                });
            }
        }, this);
    };

    grid.actions.managePrincipals = function() {

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
    };

};
