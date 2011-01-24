Inprint.documents.profile.rss.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.store = new Ext.data.JsonStore({
            idProperty: 'id',
            fields: ['id','name','size','status','progress']
        });

        this.columns = [
            {header:'File Name',dataIndex:'name', width:150},
            {header:'Size',dataIndex:'size', width:60, renderer:Ext.util.Format.fileSize},
            {header:'Status',dataIndex:'status', width:60},
        ];

        Ext.apply(this, {
            xtype:'grid',
            width:300,
            border:false,
            enableHdMenu:false,
            bodyStyle: "padding:5px 5px"
        });

        // Call parent (required)
        Inprint.documents.profile.rss.Grid.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.documents.profile.rss.Grid.superclass.onRender.apply(this, arguments);
    }

});
