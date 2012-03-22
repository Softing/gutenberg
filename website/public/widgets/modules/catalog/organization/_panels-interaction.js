Inprint.catalog.organization.Interaction = function(parent, panels) {

    var tree = panels.tree;
    var grid = panels.grid;
    var help = panels.help;

    // Tree

    tree.on("beforenodedrop", function (e) {
        if(Ext.isArray(e.data.selections)) {
            var node = this.cmpCurrentNode();
            e.cancel = false;
            var data = _get_values("id", e.data.selections);
        }
        return false;
    }, tree);

    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        grid.enable();
        if (node) {
            grid.cmpLoad({ node: node.id });
            grid.setTitle(_("Employees") +' - '+ node.text);
        }
    });

    // Grid buttons

    grid.btnAddToGroup.handler = function() {
        var win = grid.components["add-to-group-window"];
        if (!win) {
            win = new Inprint.cmp.membersList.Window();
            grid.components["add-to-group-window"] = win;
            win.on("select", function(ids) {
                Ext.Ajax.request({
                    url: "/catalog/organization/map/",
                    scope: grid,
                    success: grid.cmpReload,
                    params: {
                        group: tree.cmpCurrentNode().id,
                        members: ids
                    }
                });
            });
        }
        win.show();
        win.cmpLoad();
    };

    grid.btnDeleteFromGroup.handler = function() {
        Ext.MessageBox.confirm(
            _("Termination of membership"),
            _("You really want to stop membership in group for the selected accounts?"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: "/catalog/organization/unmap/",
                        scope: grid,
                        success: grid.cmpReload,
                        params: {
                            group: tree.cmpCurrentNode().id,
                            members: grid.getValues("id")
                        }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    };

    grid.btnViewProfile.handler = function() {
        var win = grid.components["view-profile-window"];
        if (!win) {
            win = new Inprint.cmp.memberProfile.Window();
            grid.components["view-profile-window"] = win;
        }
        win.show();
        win.cmpFill(grid.getValue("id"));
    };

    grid.btnUpdateProfile.handler = function() {
        var win = grid.components["update-profile-window"];
        if (!win) {
            win = new Inprint.cmp.memberProfileForm.Window();
            grid.components["update-profile-window"] = win;
            win.on("actioncomplete", function() {
                grid.cmpReload();
            });
        }
        win.show();
        win.cmpFill(grid.getValue("id"));
    };

    grid.btnManageRules.handler = function() {
        var win = new Inprint.cmp.memberRulesForm.Window({
            memberId: grid.getValue("id")
        });
        win.show();
    };

    // Grid

    grid.getStore().on("load", function(store) {
        if (tree.cmpCurrentNode()) {
            grid.setTitle(_("Employees") +' - '+ tree.cmpCurrentNode().text +' ('+ store.getCount() +')');
        }
    });

};
