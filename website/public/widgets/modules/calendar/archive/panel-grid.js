Inprint.calendar.archive.Grid = Ext.extend(Ext.ux.tree.TreeGrid, {

    initComponent: function() {

        this.columns = [
            Inprint.calendar.ux.Columns.shortcut,
            Inprint.calendar.ux.Columns.num,
            Inprint.calendar.ux.Columns.circulation,
            Inprint.calendar.ux.Columns.docdate,
            Inprint.calendar.ux.Columns.advdate,
            Inprint.calendar.ux.Columns.printdate,
            Inprint.calendar.ux.Columns.releasedate
        ];

        Ext.apply(this, {
            border:false,
            disabled:true,
            dataUrl: _url('/calendar/list/')
        });

        Inprint.calendar.archive.Grid.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.archive.Grid.superclass.onRender.apply(this, arguments);
    },

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
