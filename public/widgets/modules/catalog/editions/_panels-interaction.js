Inprint.catalog.editions.Interaction = function(parent, panels) {

    var tree = panels.tree;
    var grid = panels.grid;
    var help = panels.help;

    // Set defaults
    grid.disable();

    // Set Actions
    grid.btnCreateItem.on("click",       Inprint.getAction("stage.create")    .createDelegate(parent, [grid]));
    grid.btnUpdateItem.on("click",       Inprint.getAction("stage.update")    .createDelegate(parent, [grid]));
    grid.btnDeleteItem.on("click",       Inprint.getAction("stage.delete")    .createDelegate(parent, [grid]));
    grid.btnSelectPrincipals.on("click", Inprint.getAction("stage.principals").createDelegate(parent, [grid]));

    // Tree Events
    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node) {
            grid.enable();
            grid.setEdition(node.id);
            grid.cmpLoad({ branch: node.id });
        }
    });

    tree.on("contextmenu", function(edition) {

        var items = [];
        var disabled = true;

        if (parent.access["domain.editions.manage"]) {
            disabled = false;
        }

        if (edition && edition.id != NULLID) {

            var btnCreate = Inprint.getButton("create.item");
            btnCreate.handler = Inprint.getAction("edition.create").createDelegate(parent, [edition]);
            btnCreate.disabled = disabled;
            items.push( btnCreate );

            var btnUpdate = Inprint.getButton("update.item");
            btnUpdate.handler = Inprint.getAction("edition.update").createDelegate(parent, [edition]);
            btnUpdate.disabled = disabled;
            items.push( btnUpdate );

            var btnDelete = Inprint.getButton("delete.item");
            btnDelete.handler = Inprint.getAction("edition.delete").createDelegate(parent, [edition]);
            btnDelete.disabled = disabled;
            items.push( btnDelete );

            new Ext.menu.Menu({ items : items }).show(edition.ui.getAnchor());

        }

    });

    tree.on("containercontextmenu", function(tree, e) {

        var edition  = tree.getSelectionModel().getSelectedNode();

        var items = [];
        var disabled = true;

        if (parent.access["domain.editions.manage"]) {
            disabled = false;
        }

        if (edition && edition.id != NULLID) {

            var btnCreate = Inprint.getButton("create.item");
            btnCreate.handler = Inprint.getAction("edition.create").createDelegate(parent, [edition]);
            btnCreate.disabled = disabled;

            items.push( btnCreate );

            items.push('-');
            items.push({
                icon: _ico("arrow-circle-double"),
                cls: "x-btn-text-icon",
                text: _("Reload"),
                handler: tree.cmpReload
            });

            new Ext.menu.Menu({ items : items }).showAt(e.getXY());

        }

    });

    // Grid Events
    grid.getSelectionModel().on("selectionchange", function(sm) {
        _disable(grid.btnUpdateItem, grid.btnSelectPrincipals, grid.btnDeleteItem);
        if (parent.access["domain.exchange.manage"]) {
            if (sm.getCount() > 0) {
                _enable(grid.btnDeleteItem);
            }
            if (sm.getCount() == 1) {
               _enable(grid.btnUpdateItem, grid.btnSelectPrincipals);
            }
        }
    });

    // Set Access
    _a(["domain.editions.manage", "domain.exchange.manage"], null,
        function(terms) {

            parent.access = terms;

            if (parent.access["domain.exchange.manage"]) {
                grid.btnCreateItem.enable();
            }

        });

};
