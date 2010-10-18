Inprint.catalog.organization.Interaction = function(panels) {

    var acl_view   = _a(null, "settings.edition.view");
    var acl_manage = _a(null, "settings.edition.manage");
    var acl_remove = _a(null, "settings.edition.remove");

    var tree = panels.tree;
    var grid = panels.grid;
    var help = panels.help;

    // Tree

    tree.on("contextmenu", function(node) {

            this.selection = node;

            var items = [];

            items.push({
                icon: _ico("plus-button"),
                cls: "x-btn-text-icon",
                text: _("Create"),
                ref: "../btnCreate",
                scope:this,
                handler: function() { this.cmpCreate(node); }
            }, {
                icon: _ico("pencil"),
                cls: "x-btn-text-icon",
                text: _("Edit"),
                ref: "../btnEdit",
                scope:this,
                handler: function() { this.cmpUpdate(node); }
            });

            if (node.attributes.id != NULLID) {
                items.push({
                    icon: _ico("bin--arrow"),
                    cls: "x-btn-text-icon",
                    text: _("Remove"),
                    ref: "../btnRemove",
                    scope:this,
                    handler: function() { this.cmpDelete(node); }
                });
            }

            items.push('-',{
                icon: _ico("arrow-circle-double"),
                cls: "x-btn-text-icon",
                text: _("Reload"),
                scope: this,
                handler: function() { this.cmpReload(node); }
            });

            new Ext.menu.Menu({ items : items }).show(node.ui.getAnchor());

    }, tree);

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
            grid.setTitle(_("Members") +' - '+ node.text);
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
    },

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
    },

    grid.btnManageRules.handler = function() {
        var win = new Inprint.cmp.memberRulesForm.Window({
            memberId: grid.getValue("id")
        });
        win.show();
    }

    // Grid

    if (acl_manage) {
        grid.btnAdd.enable();
        grid.btnAddToGroup.enable();
    }

    grid.getStore().on("load", function(store) {
        if (tree.cmpCurrentNode())
            grid.setTitle(_("Members") +' - '+ tree.cmpCurrentNode().text +' ('+ store.getCount() +')');
    });

    grid.getSelectionModel().on("selectionchange", function(sm) {

        var count = sm.getCount();

        _disable( grid.btnDelete, grid.btnDeleteFromGroup );
        _disable( grid.btnViewProfile, grid.btnUpdateProfile, grid.btnManageRules);

        if (count > 0) {

            _enable( grid.btnDelete, grid.btnDeleteFromGroup );

            if (count == 1) {
                _enable( grid.btnViewProfile, grid.btnUpdateProfile, grid.btnManageRules);
            }
        }

    });

}
