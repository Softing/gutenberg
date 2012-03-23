//Inprint.calendar.fascicles.Context = function(parent, panels) {
//
//    var tree = panels.tree;
//    var grid = panels.grid;
//
//    var showMenu = function (access, grid, node) {
//
//        var items   = [];
//
//        var id      = node.id;
//        var text    = node.text;
//        var fastype = node.attributes.fastype;
//
//        if (access["editions.fascicle.manage"] && fastype == "issue") {
//
//            items.push({
//                icon: _ico("blue-folder--pencil"),
//                cls: 'x-btn-text-icon',
//                text: _("Edit issue"),
//                scope: grid,
//                handler: function() {
//                    grid.cmpUpdateFascicle(id);
//                }
//            });
//
//            //items.push({
//            //    icon: _ico("blue-folder--minus"),
//            //    cls: 'x-btn-text-icon',
//            //    text    : _('Archive'),
//            //    scope: grid,
//            //    handler: function() {
//            //        grid.cmpArchive(id);
//            //    }
//            //});
//
//            items.push({
//                icon: _ico("blue-folder--minus"),
//                cls: 'x-btn-text-icon',
//                text    : _('Delete issue'),
//                scope: grid,
//                handler: function() {
//                    grid.cmpRemove(id);
//                }
//            });
//
//        }
//
//        if (access["editions.attachment.manage"] && fastype == "issue") {
//            if (items.length) items.push('-');
//            items.push({
//                icon: _ico("folder--plus"),
//                cls: 'x-btn-text-icon',
//                text: _("Create attachment"),
//                scope: grid,
//                handler: function() {
//                    grid.cmpCreateAttachment(id);
//                }
//            });
//        }
//
//        if (access["editions.attachment.manage"] && fastype == "attachment") {
//
//            items.push({
//                icon: _ico("folder--pencil"),
//                cls: 'x-btn-text-icon',
//                text    : _('Edit attachment'),
//                scope: grid,
//                handler: function() {
//                    grid.cmpUpdateAttachment(id);
//                }
//            });
//
//            //items.push({
//            //    icon: _ico("blue-folder--minus"),
//            //    cls: 'x-btn-text-icon',
//            //    text    : _('Archive'),
//            //    scope: grid,
//            //    handler: function() {
//            //        grid.cmpArchive(id);
//            //    }
//            //});
//
//            items.push({
//                icon: _ico("folder--minus"),
//                cls: 'x-btn-text-icon',
//                text    : _('Delete attachment'),
//                scope: grid,
//                handler: function() {
//                    grid.cmpRemove(id);
//                }
//            });
//
//        }
//
//        if (items.length) items.push('-');
//
//        if (access["editions.fascicle.view"] || access["editions.attachment.view"] ) {
//            items.push({
//                icon: _ico("table"),
//                cls: 'x-btn-text-icon',
//                text    : _('View plan'),
//                handler : function() {
//                    Inprint.ObjectResolver.resolve({
//                        aid:'fascicle-plan',
//                        oid: id,
//                        text: text });
//                }
//            });
//        }
//
//        if (access["editions.fascicle.manage"] || access["editions.attachment.manage"] ) {
//            items.push({
//                icon: _ico("clock"),
//                cls: 'x-btn-text-icon',
//                text    : _('View composer'),
//                handler : function() {
//                    Inprint.ObjectResolver.resolve({
//                        aid:'fascicle-planner',
//                        oid: id,
//                        text: text });
//                }
//            });
//        }
//
//        new Ext.menu.Menu({ items : items }).show(node.ui.getAnchor());
//
//    }
//
//    grid.on("contextmenu", function(node) {
//
//        _a([    "editions.fascicle.view:*", "editions.attachment.view:*",
//                "editions.fascicle.manage:*", "editions.attachment.manage:*" ],
//            node.attributes.edition,
//            function(access) {
//                showMenu(access, grid, node);
//            });
//
//    });
//
//};
