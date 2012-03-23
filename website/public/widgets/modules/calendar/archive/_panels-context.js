Inprint.calendar.archive.Context = function(parent, panels) {

    var tree = panels.tree;
    var grid = panels.grid;

    grid.on("contextmenu", function(node) {

        node.select();

        var oid     = node.id;
        var text    = node.text;
        var fastype = node.attributes.fastype;
        var edition = node.attributes.edition;
        var parent  = node.attributes.parent;

        var callback = grid.cmpReloadWithMenu.createDelegate(grid);

        var items = [
            Inprint.fx.Button(false, "Open Plan", "", "layout-hf-3", Inprint.ObjectResolver.resolve.createCallback({ aid:'fascicle-plan', oid: oid, text: text })).render(),
            Inprint.fx.Button(false, "Copy", "", "blue-folder-export", Inprint.calendar.actions.copy.createDelegate(grid, [oid, callback])).render(),
            Inprint.fx.Button(false, "Move to Work", "", "blue-folder-zipper", Inprint.calendar.actions.unarchive.createDelegate(grid, [null, null, null, oid, callback])).render()
        ];

        new Ext.menu.Menu({ items : items }).show(node.ui.getAnchor());

    });

};
