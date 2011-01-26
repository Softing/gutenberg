Inprint.plugins.rss.profile.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.store = new Ext.data.JsonStore({
            autoLoad:false,
            url: _url('/plugin/rss/files/'),
            fields: ['id','name','size','status','progress']
        });

        this.columns = [
            {header:'File Name',dataIndex:'name', width:150},
            {header:'Size',dataIndex:'size', width:60, renderer:Ext.util.Format.fileSize},
            {header:'Status',dataIndex:'status', width:60},
        ];

        Ext.apply(this, {
            flex:1,
            xtype:'grid',
            border:false,
            enableHdMenu:false,
            maskDisabled: true,
            loadMask: false,
            bodyStyle: "padding:5px 5px"
        });

        // Call parent (required)
        Inprint.plugins.rss.profile.Grid.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.plugins.rss.profile.Grid.superclass.onRender.apply(this, arguments);
    }

});
