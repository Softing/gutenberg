Inprint.calendar.issues.Context = function(parent, panels) {

    var tree = panels.tree;
    var grid = panels.grid;

    var showMenu = function (access, grid, node) {

        node.select();

        var oid     = node.id;
        var text    = node.text;
        var fastype = node.attributes.fastype;
        var edition = node.attributes.edition;

        var menu = new Ext.menu.Menu();
        var callback = grid.cmpReloadWithMenu.createDelegate(grid);

        if (fastype == "issue") {

            if (access["editions.fascicle.manage"]) {
                menu.add(_("Issue"));
                menu.add( Inprint.fx.btn.Create(Inprint.calendar.actions.fascicleCreate.createDelegate(grid, [oid])) );
                menu.add( Inprint.fx.btn.Edit(Inprint.calendar.actions.fascicleUpdate.createDelegate(grid, [oid])) );
                menu.add( Inprint.fx.btn.Copy(Inprint.calendar.actions.copy.createDelegate(grid, [oid, callback])) );
                menu.add( "-" );
                menu.add( Inprint.fx.btn.Delete(Inprint.calendar.actions.remove.createDelegate(grid, [null, null, null, oid, callback])) );
            }

            if (access["editions.attachment.manage"]) {
                menu.add(_("Attachment"));
                menu.add( Inprint.fx.btn.Create(Inprint.calendar.actions.attachmentCreate.createDelegate(grid, [oid])) );
            }
        }

        if (fastype == "attachment") {
            menu.add(_("Attachment"));
            if (access["editions.attachment.manage"]) {
                menu.add( Inprint.fx.btn.Create(Inprint.calendar.actions.attachmentCreate.createDelegate(grid, [oid])) );
                menu.add( Inprint.fx.btn.Edit(Inprint.calendar.actions.attachmentUpdate.createDelegate(grid, [oid])) );
                menu.add( Inprint.fx.btn.Copy(Inprint.calendar.actions.copy.createDelegate(grid, [oid, callback])) );
                menu.add( "-" );
                menu.add( Inprint.fx.btn.Delete(Inprint.calendar.actions.remove.createDelegate(grid, [oid])) );
            }
        }

        menu.add(_("View"));

        if (access["editions.fascicle.view"] || access["editions.attachment.view"] ) {
            menu.add( Inprint.fx.Button(false, "Open Plan", "", "table", Inprint.ObjectResolver.resolve.createCallback({ aid:'fascicle-plan', oid: oid, text: text })).render() );
        }
        if (access["editions.fascicle.manage"] || access["editions.attachment.manage"] ) {
            menu.add( Inprint.fx.Button(false, "Open Composer", "", "clock", Inprint.ObjectResolver.resolve.createCallback({ aid:'fascicle-planner', oid: oid, text: text })).render() );
            menu.add( _("Cycle") );
            menu.add( Inprint.fx.Button(false, "Move to Approve", "", "arrow-join", Inprint.calendar.actions.statusApproval.createDelegate(grid, [null, oid])).render() );
            menu.add( Inprint.fx.Button(false, "Move to Work", "", "arrow", Inprint.calendar.actions.statusWork.createDelegate(grid, [null, oid])).render() );
            menu.add( Inprint.fx.Button(false, "Move to Archive", "", "blue-folder-zipper", Inprint.calendar.actions.archive.createDelegate(grid, [null, oid])).render() );
            menu.add( _("Tools") );
            menu.add( Inprint.fx.Button(false, "Pause", "", "control-pause", Inprint.calendar.actions.disable.createDelegate(grid, [null, oid])).render() );
            menu.add( Inprint.fx.Button(false, "Enable", "", "control", Inprint.calendar.actions.enable.createDelegate(grid, [null, oid])).render() );
            menu.add( _("-") );
            menu.add( Inprint.fx.Button(false, "Format", "", "puzzle", Inprint.calendar.actions.format.createDelegate(grid, [null, oid])).render() );
        }

        menu.show(node.ui.getAnchor());
    }

    grid.on("contextmenu", function(node) {
        _a([    "editions.fascicle.view:*", "editions.attachment.view:*",
                "editions.fascicle.manage:*", "editions.attachment.manage:*" ],
            node.attributes.edition,
            function(access) {
                showMenu(access, grid, node);
            });
    });

};
