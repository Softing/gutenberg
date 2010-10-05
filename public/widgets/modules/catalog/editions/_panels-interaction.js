Inprint.catalog.editions.Interaction = function(panels) {
    //
    //var acl_view   = _a(null, "settings.edition.view");
    //var acl_manage = _a(null, "settings.edition.manage");
    //var acl_remove = _a(null, "settings.edition.remove");
    //
    var tree = panels.tree;
    var grid = panels.grid;
    var help = panels.help;

    //var tabs    = panels.tab;
    //var edit    = panels.edit;
    //var access  = panels.access;
    //var profile = panels.profile;
    //
    //// Tree
    //
    tree.on("contextmenu", function(node) {

        this.selection = node;

        var items = [];

        items.push({
            icon: _ico("book--plus"),
            cls: "x-btn-text-icon",
            text: _("Create"),
            ref: "../btnCreate",
            scope:this,
            handler: this.cmpCreate
        }, {
            icon: _ico("book--pencil"),
            cls: "x-btn-text-icon",
            text: _("Edit"),
            ref: "../btnEdit",
            scope:this,
            handler: this.cmpUpdate
        });

        if (node.attributes.id != NULLID) {
            items.push({
                icon: _ico("book--minus"),
                cls: "x-btn-text-icon",
                text: _("Remove"),
                ref: "../btnRemove",
                scope:this,
                handler: this.cmpDelete
            });
        }

        items.push('-', {
            text: _("Add chain"),
            icon: _ico("node-insert"),
            cls: "x-btn-text-icon",
            scope: this,
            handler: this.cmpReload
        }, {
            text: _("Change chain"),
            icon: _ico("node-design"),
            cls: "x-btn-text-icon",
            scope: this,
            handler: this.cmpReload
        }, {
            text: _("Delete chain"),
            icon: _ico("node-delete"),
            cls: "x-btn-text-icon",
            scope: this,
            handler: this.cmpReload
        });

        items.push('-', {
            icon: _ico("arrow-circle-double"),
            cls: "x-btn-text-icon",
            text: _("Reload"),
            scope: this,
            handler: this.cmpReload
        });

        new Ext.menu.Menu({ items : items }).show(node.ui.getAnchor());

    }, tree);

    //tree.on("beforenodedrop", function (e) {
    //
    //    if(Ext.isArray(e.data.selections)) {
    //        var node = this.cmpCurrentNode();
    //        e.cancel = false;
    //        var data = _get_values("id", e.data.selections);
    //    }
    //    return false;
    //}, tree);
    //
    //tree.getSelectionModel().on("selectionchange", function(sm, node) {
    //    grid.enable();
    //    grid.cmpLoad({ node: node.id });
    //    //grid.setTitle(_("Members") +' - '+ tree.cmpCurrentNode().text);
    //});
    //
    //// Grid
    //
    //if (acl_manage) {
    //    grid.btnAdd.enable();
    //}
    //
    //grid.getStore().on("load", function(store) {
    //    //grid.setTitle(_("Members") +' - '+ tree.cmpCurrentNode().text +' ('+ store.getCount() +')');
    //});
    //
    //grid.getSelectionModel().on("selectionchange", function(sm) {
    //
    //    if (sm.getCount()) {
    //        if (acl_manage) _enable(grid.btnEnable, grid.btnDisable);
    //        if (acl_remove) _enable(grid.btnRemove);
    //    } else {
    //        _disable(grid.btnEnable, grid.btnDisable, grid.btnRemove);
    //    }
    //
    //    if (acl_manage) {
    //        if (sm.getCount() == 1) {
    //            _enable(profile, edit, access);
    //            if (tabs.getActiveTab().cmpFill)
    //                tabs.getActiveTab().cmpFill();
    //        } else {
    //            _disable(profile, edit, access);
    //        }
    //    }
    //
    //});
    //
    //// Card
    //edit.cmpGetId = function() {
    //    return grid.getSelectionModel().getSelected().get("id");
    //}
    //
    //edit.on("activate", function() {
    //    edit.cmpFill();
    //});
    //
    //edit.on("actioncomplete", function(form, action) {
    //    if (action.type == "submit")
    //        grid.cmpReload();
    //});
    //
    ////Access
    //access.cmpGetCatalogId = function() {
    //    return tree.cmpCurrentNode().attributes.id;
    //}
    //
    //access.cmpGetId = function() {
    //    return grid.getSelectionModel().getSelected().get("id");
    //}
    //
    //access.on("activate", access.cmpFill);

}
