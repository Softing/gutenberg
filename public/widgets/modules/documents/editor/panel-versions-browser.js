Inprint.documents.editor.versions.Browser = Ext.extend( Ext.list.ListView, {

    initComponent: function() {

        var store = new Ext.data.JsonStore({
            url: this.url,
            root: 'data',
            fields: [
                'name', 'url',
                {name:'size', type: 'float'},
                {name:'lastmod', type:'date', dateFormat:'timestamp'}
            ]
        });

        store.load();

        Ext.apply(this, {

            border:false,
            //autoScroll:true,

            store: store,

            multiSelect: false,

            emptyText: 'No HotSave files to display',

            //reserveScrollOffset: false,

            columns: [
                {
                    header: _("Stage"),
                    width: .35,
                    dataIndex: 'stage'
                },
                {
                    header: _("Empoyee"),
                    width: .35,
                    dataIndex: 'employee'
                },
                {
                    header: _("File"),
                    width: .5,
                    dataIndex: "file"
                },
                {
                    header: _("Date"),
                    dataIndex: "date",
                    tpl: '{lastmod:date("m-d h:i a")}'
                }
            ]

        });

        Inprint.documents.editor.versions.Browser.superclass.initComponent.apply(this, arguments);

    },

    // Override other inherited methods
    onRender: function(){
        Inprint.documents.editor.versions.Browser.superclass.onRender.apply(this, arguments);
    }

});
