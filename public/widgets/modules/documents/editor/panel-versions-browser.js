Inprint.documents.editor.versions.Browser = Ext.extend( Ext.list.ListView, {

    initComponent: function() {

        this.config = {};

        var store = new Ext.data.JsonStore({
            url: this.url + "/list/",
            root: 'data',
            baseParams: {
                file: this.oid
            },
            fields: [
                'id', 'creator', 'branch', 'stage', 'color', 'created'
            ]
        });

        Ext.apply(this, {

            border:false,
            store: store,
            singleSelect: true,
            emptyText: _("No versions to display"),

            columns: [
                {
                    header: _(""),
                    width: .03,
                    dataIndex: "color",
                    tpl: '<div style="background:#{color};width:20px;">&nbsp;</div>'
                },

                {
                    header: _("Stage"),
                    width: .15,
                    dataIndex: "stage"
                },
                {
                    header: _("Empoyee"),
                    width: .15,
                    dataIndex: "creator"
                },
                {
                    header: _("Date"),
                    dataIndex: "created"
                }
            ]

        });

        Inprint.documents.editor.versions.Browser.superclass.initComponent.apply(this, arguments);

    },

    // Override other inherited methods
    onRender: function(){
        Inprint.documents.editor.versions.Browser.superclass.onRender.apply(this, arguments);

        this.on("selectionchange", function(dataview, selection) {

            if (selection.length == 1){
                this.parent.btnView.enable();
                var record = this.getRecord(selection[0]);
                this.config.selection = record.get("id");
            }

            else if (selection.length != 0){
                this.parent.btnView.disable();
            }

        }, this);
    },

    cmpReload: function() {
        this.getStore().reload();
    }

});
