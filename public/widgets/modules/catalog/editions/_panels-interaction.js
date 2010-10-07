Inprint.catalog.editions.Interaction = function(panels) {

    var tree = panels.tree;
    var grid = panels.grid;
    var help = panels.help;

    var currentStage;


    // Tree

    //tree.on("beforenodedrop", function (e) {
    //
    //    if(Ext.isArray(e.data.selections)) {
    //        var node = this.cmpCurrentNode();
    //        e.cancel = false;
    //        var data = _get_values("id", e.data.selections);
    //    }
    //    return false;
    //}, tree);

    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        grid.enable();
        grid.cmpLoad({ branch: node.id });
        //grid.setTitle(_("Members") +' - '+ tree.cmpCurrentNode().text);
    });

    // Grid

    grid.btnCreateStage.enable();

    grid.getSelectionModel().on("selectionchange", function(sm) {
        if (sm.getCount()) {
            _enable(grid.btnRemoveStage);
        } else {
            _disable(grid.btnRemoveStage);
        }
        if (sm.getCount() == 1) {
            currentStage = grid.getValue("id");
           _enable(grid.btnChangeStage, grid.btnSelectMembers, grid.btnManagePrincipals);
        } else {
           _disable(grid.btnChangeStage, grid.btnSelectMembers, grid.btnManagePrincipals);
        }
    });

    // Stages
    grid.btnCreateStage.on("click", grid.actions.createStage.createDelegate(this));
    grid.btnChangeStage.on("click", grid.actions.changeStage.createDelegate(this));
    grid.btnRemoveStage.on("click", grid.actions.removeStage.createDelegate(this));
    grid.btnManagePrincipals.on("click", grid.actions.managePrincipals.createDelegate(this));


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
