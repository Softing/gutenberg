//Inprint.calendar.archive.Main = Ext.extend(Ext.Panel, {
//
//    initComponent: function() {
//
//        this.panels = {};
//        this.panels.tree = new Inprint.calendar.archive.Tree();
//        this.panels.grid = new Inprint.calendar.archive.Grid();
//
//        Ext.apply(this, {
//            border:false,
//            title: _("Archive"),
//            layout: "border",
//            defaults: {
//                collapsible: false,
//                split: true
//            },
//            items: [
//                {
//                    layout:"fit",
//                    region: "center",
//                    margins: "3 3 3 0",
//                    items: this.panels.grid
//                },
//                {
//                    layout:"fit",
//                    region:"west",
//                    margins: "3 0 3 3",
//                    width: 200,
//                    items: this.panels.tree
//                }
//            ]
//        });
//        Inprint.calendar.archive.Main.superclass.initComponent.apply(this, arguments);
//    },
//
//    onRender: function() {
//        Inprint.calendar.archive.Main.superclass.onRender.apply(this, arguments);
//        Inprint.calendar.archive.Context(this, this.panels);
//        Inprint.calendar.archive.Interaction(this, this.panels);
//    },
//
//    cmpGetTree: function() {
//        return this.panels.tree;
//    },
//
//    cmpGetGrid: function() {
//        return this.panels.grid;
//    },
//
//    cmpReload: function() {
//        this.panels.grid.cmpReload();
//    }
//
//});
