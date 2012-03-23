Inprint.calendar.issues.Main = Ext.extend(Ext.ux.tree.TreeGrid, {

    initComponent: function() {

        this.access = {};

        this.tbar = Inprint.calendar.issues.Toolbar(this, this);

        this.columns = [
            Inprint.calendar.ux.Columns.shortcut,
            Inprint.calendar.ux.Columns.num,
            Inprint.calendar.ux.Columns.circulation,
            Inprint.calendar.ux.Columns.template,
            Inprint.calendar.ux.Columns.docdate,
            Inprint.calendar.ux.Columns.advdate,
            Inprint.calendar.ux.Columns.printdate,
            Inprint.calendar.ux.Columns.releasedate
        ];

        Ext.apply(this, {
            border:false,
            dataUrl: _source("fascicle.list")
        });

        Inprint.calendar.issues.Main.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.issues.Main.superclass.onRender.apply(this, arguments);
        Inprint.calendar.issues.Interaction(this, this.panels);
    },

    /* Getters */

    //getAccess: function(id) {
    //    return this.access[id];
    //},
    //setAccess: function(id, value) {
    //    this.access[id] = value;
    //},

    /* Functions */
    cmpGetSelectedNode: function() {
        return this.getSelectionModel().getSelectedNode();
    },

    cmpLoad: function(params) {
        Ext.apply(this.getLoader().baseParams, params);
        this.getRootNode().reload();
    },

    cmpReload: function() {
        this.getRootNode().reload();
    },

    cmpReloadWithMenu: function() {
        this.getRootNode().reload();
        Inprint.layout.getMenu().CmpQuery();
    }

});


//Inprint.calendar.issues.Main = Ext.extend(Ext.Panel, {
//
//    initComponent: function() {
//
//        this.panels = {};
//        this.panels.tree = new Inprint.calendar.issues.Tree();
//        this.panels.grid = new Inprint.calendar.issues.Grid();
//
//        this.tbar = Inprint.calendar.issues.Toolbar(this, this.panels.grid);
//
//        Ext.apply(this, {
//            border:false,
//            //layout: "border",
//            layout: "fit",
//            defaults: {
//                collapsible: false,
//                split: true
//            },
//            items: this.panels.grid
//            //items: [
//            //    {
//            //        region:"west",
//            //        layout:"fit",
//            //        width: 200,
//            //        margins: "3 0 3 3",
//            //        items: this.panels.tree
//            //    },
//            //    {
//            //        region: "center",
//            //        layout:"fit",
//            //        margins: "3 0 3 0",
//            //        items: this.panels.grid
//            //    }
//            //]
//        });
//        Inprint.calendar.issues.Main.superclass.initComponent.apply(this, arguments);
//    },
//
//    onRender: function() {
//        Inprint.calendar.issues.Main.superclass.onRender.apply(this, arguments);
//        Inprint.calendar.issues.Context(this, this.panels);
//        Inprint.calendar.issues.Interaction(this, this.panels);
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
