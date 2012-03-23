//Inprint.calendar.templates.Context = function(parent, panels) {
//
//    var tree = panels.tree;
//    var grid = panels.grid;
//
//    grid.on("rowcontextmenu", function(thisGrid, rowIndex, evtObj) {
//
//        evtObj.stopEvent();
//
//        var rowCtxMenuItems = [];
//
//        var record   = thisGrid.getStore().getAt(rowIndex);
//        var selcount = thisGrid.getSelectionModel().getCount();
//
//        var fasid   = record.get("id");
//        var edition = record.get("edition");
//        var fasname = record.get("shortuct");
//        var fastype = record.get("fastype");
//
//        thisGrid.body.mask(_("Loading..."));
//
//        _a(
//            "editions.templates.manage:*",
//            edition,
//            function(access) {
//
//                thisGrid.body.unmask();
//
//                rowCtxMenuItems.push({
//                    icon: _ico("puzzle--pencil"),
//                    cls: 'x-btn-text-icon',
//                    text: _("Edit template"),
//                    scope: thisGrid,
//                    handler: thisGrid.cmpUpdateTemplate
//                });
//
//                rowCtxMenuItems.push({
//                    icon: _ico("layout-design"),
//                    cls: 'x-btn-text-icon',
//                    text    : _('Compose template'),
//                    handler : function() {
//                        Inprint.ObjectResolver.resolve({
//                            aid:'fascicle-template-composer',
//                            oid: fasid,
//                            text: fasname });
//                    }
//                });
//
//                rowCtxMenuItems.push("-");
//
//                rowCtxMenuItems.push({
//                    icon: _ico("puzzle--minus"),
//                    cls: 'x-btn-text-icon',
//                    text    : _('Delete template'),
//                    scope: thisGrid,
//                    handler: thisGrid.cmpRemoveTemplate
//                });
//
//                rowCtxMenuItems.push('-', {
//                    icon: _ico("arrow-circle-double"),
//                    cls: "x-btn-text-icon",
//                    text: _("Reload"),
//                    scope: thisGrid,
//                    handler: thisGrid.cmpReload
//                });
//
//                thisGrid.rowCtxMenu = new Ext.menu.Menu({
//                    items : rowCtxMenuItems
//                });
//
//                thisGrid.rowCtxMenu.showAt(evtObj.getXY());
//
//        });
//
//    }, grid);
//
//};
