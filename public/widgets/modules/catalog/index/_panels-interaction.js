Inprint.catalog.indexes.Interaction = function(parent, panels) {

    var editions  = panels.editions;
    var headlines = panels.headlines;
    var rubrics   = panels.rubrics;

    // Set defaults
    rubrics.disable();

    // Set Actions
    rubrics.btnCreateItem.on("click",       Inprint.getAction("rubric.create")    .createDelegate(parent, [rubrics]));
    rubrics.btnUpdateItem.on("click",       Inprint.getAction("rubric.update")    .createDelegate(parent, [rubrics]));
    rubrics.btnDeleteItem.on("click",       Inprint.getAction("rubric.delete")    .createDelegate(parent, [rubrics]));

    // Tree Editions Events
    editions.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node) {
            headlines.enable();
            headlines.setEdition(node.id);
            headlines.getRootNode().id = node.id;
            headlines.getRootNode().reload();
        }
    });

    // Tree Headlines Events
    headlines.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node) {
            rubrics.enable();
            rubrics.setHeadline(node.id);
            rubrics.btnCreateItem.enable();
            rubrics.cmpLoad({ headline: node.id });
        }
    });

    headlines.on("contextmenu", function(headline) {

        var items = [];
        var disabled = true;

        if (parent.access["domain.index.manage"]) {
            disabled = false;
        }

        var btnCreate = Inprint.getButton("create.item");
        btnCreate.handler = Inprint.getAction("headline.create").createDelegate(parent, [headlines]);
        btnCreate.disabled = disabled;
        items.push( btnCreate );

        if (headline && headline.id != NULLID) {

            var btnUpdate = Inprint.getButton("update.item");
            btnUpdate.handler = Inprint.getAction("headline.update").createDelegate(parent, [headlines, headline]);
            btnUpdate.disabled = disabled;
            items.push( btnUpdate );

            var btnDelete = Inprint.getButton("delete.item");
            btnDelete.handler = Inprint.getAction("headline.delete").createDelegate(parent, [headlines, headline]);
            btnDelete.disabled = disabled;
            items.push( btnDelete );

        }

        new Ext.menu.Menu({ items : items }).show(headline.ui.getAnchor());

    });

    headlines.on("containercontextmenu", function(tree, e) {

        var items = [];
        var disabled = true;

        if (parent.access["domain.index.manage"]) {
            disabled = false;
        }

        var btnCreate = Inprint.getButton("create.item");
        btnCreate.handler = Inprint.getAction("headline.create").createDelegate(parent, [headlines]);
        btnCreate.disabled = disabled;
        items.push( btnCreate );

        items.push('-');
        items.push({
            icon: _ico("arrow-circle-double"),
            cls: "x-btn-text-icon",
            text: _("Reload"),
            handler: function() {
                tree.cmpReload();
            }
        });

        new Ext.menu.Menu({ items : items }).showAt(e.getXY());

    });

    // Grid Rubrics Events
    rubrics.getSelectionModel().on("selectionchange", function(sm) {

        _disable(rubrics.btnDeleteItem, rubrics.btnUpdateItem);

        if (parent.access["domain.index.manage"]) {
            if (sm.getCount() == 1) {
               _enable(rubrics.btnUpdateItem);
            }
            if (sm.getCount() > 0) {
                _enable(rubrics.btnDeleteItem);
            }
        }
    });

    // Set Access
    _a(["domain.index.manage"], null, function(terms) {
        parent.access = terms;
    });

};
