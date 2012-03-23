Inprint.calendar.templates.Context = function(parent, panels) {

    var tree = panels.tree;
    var grid = panels.grid;

    grid.on("rowcontextmenu", function(grid, index, e) {

        e.stopEvent();

        grid.getSelectionModel().selectRow(index) ;

        var record   = grid.getStore().getAt(index);

        var oid     = record.get("id");
        var text    = record.get("shortuct");
        var edition = grid.currentEdition;
        var fastype = record.get("fastype");

        var callback = grid.cmpReload.createDelegate(grid);

        _a("editions.templates.manage:*", edition, function(access) {
            var menu = new Ext.menu.Menu();
            menu.add( Inprint.fx.btn.Create(Inprint.calendar.actions.templateCreate.createDelegate(grid, [1])) );
            menu.add( Inprint.fx.btn.Edit(Inprint.calendar.actions.templateUpdate.createDelegate(grid, [null, null, null, oid, callback])) );
            menu.add( Inprint.fx.Button(false, "Compose template", "", "layout-design", Inprint.ObjectResolver.resolve.createCallback({ aid:'fascicle-template-composer', oid: oid, text: text }) ).render() );
            menu.add("-");
            menu.add( Inprint.fx.btn.Delete(Inprint.calendar.actions.templateDelete.createDelegate(grid, [null, null, null, oid, callback])) );
            menu.showAt(e.getXY());
        });

    });

    grid.on("contextmenu", function(e) {
        e.stopEvent();
        if(grid.getView().findRowIndex(e.getTarget()) === false){
            _a("editions.templates.manage:*", grid.currentEdition, function(access) {
                var menu = new Ext.menu.Menu();
                menu.add( Inprint.fx.btn.Create(Inprint.calendar.actions.templateCreate.createDelegate(grid, [1])) );
                menu.showAt(e.getXY());
            });
        }
    });

};
