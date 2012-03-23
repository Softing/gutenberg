//Inprint.calendar.issues.Grid = Ext.extend(Ext.ux.tree.TreeGrid, {
//
//    initComponent: function() {
//
//        this.access = {};
//
//        this.columns = [
//            Inprint.calendar.ux.Columns.shortcut,
//            Inprint.calendar.ux.Columns.num,
//            Inprint.calendar.ux.Columns.circulation,
//            Inprint.calendar.ux.Columns.template,
//            Inprint.calendar.ux.Columns.docdate,
//            Inprint.calendar.ux.Columns.advdate,
//            Inprint.calendar.ux.Columns.printdate,
//            Inprint.calendar.ux.Columns.releasedate
//        ];
//
//        Ext.apply(this, {
//            border:false,
//            disabled:true,
//            dataUrl: _source("fascicle.list")
//        });
//
//        Inprint.calendar.issues.Grid.superclass.initComponent.apply(this, arguments);
//    },
//
//    onRender: function() {
//        Inprint.calendar.issues.Grid.superclass.onRender.apply(this, arguments);
//    },
//
//    /* Getters */
//
//    getAccess: function(id) {
//        return this.access[id];
//    },
//    setAccess: function(id, value) {
//        this.access[id] = value;
//    },
//
//    /* Functions */
//    cmpGetSelectedNode: function() {
//        return this.getSelectionModel().getSelectedNode();
//    },
//
//    cmpLoad: function(params) {
//        Ext.apply(this.getLoader().baseParams, params);
//        this.getRootNode().reload();
//    },
//
//    cmpReload: function() {
//        this.getRootNode().reload();
//    },
//
//    cmpReloadWithMenu: function() {
//        this.getRootNode().reload();
//        Inprint.layout.getMenu().CmpQuery();
//    }
//
//});
