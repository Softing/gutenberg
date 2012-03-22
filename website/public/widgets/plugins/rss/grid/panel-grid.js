Inprint.plugins.rss.Grid = Ext.extend(Ext.grid.EditorGridPanel, {

    initComponent: function() {

        var actions = new Inprint.documents.GridActions();
        var columns = new Inprint.documents.GridColumns();

        this.components = {};

        this.urls = {
            "list": _url("/plugin/rss/list/")
        };

        var fields = Inprint.store.Columns.documents.list;
        fields.push("rss_id", "rss_published", "rss_sortorder");

        this.store = Inprint.factory.Store.json( "/documents/list/" , {
            autoLoad:true,
            remoteSort: true,
            totalProperty: 'total',
            url: this.urls.list,
            baseParams: { flt_rssonly: false },
            fields: fields
        });

        this.sm = new Ext.grid.CheckboxSelectionModel();

        this.columns = [
            this.sm,
            {
                width: 32,
                id:"publihed",
                sortable: false,
                dataIndex: "rss_published",
                renderer: function(v) {
                    var image = '';
                    if (v==1) { image = '<img src="'+ _ico("light-bulb") +'"/>'; }
                    return image;
                }
            },
            {
                width: 40,
                id:"sortorder",
                sortable: false,
                dataIndex: "rss_sortorder",
                editor: new Ext.form.TextField({
                    allowBlank: true
                })
            },
            {
                id:"title",
                header:_("Title"),
                dataIndex: "title",
                sortable: false,
                renderer: function(v) {
                    return '<b>'+ v +'</b>';
                }
            },
            columns.edition,
            columns.workgroup,
            columns.fascicle,
            columns.headline,
            columns.rubric,
            columns.pages,
            columns.manager,
            columns.progress,
            columns.holder,
            columns.images,
            columns.size
        ];

        this.tbar = [
            {
                icon: _ico("disk-black"),
                cls: "x-btn-text-icon",
                text: _("Save"),
                ref: "../btnSave",
                disabled:true,
                scope:this,
                handler: this.cmpSave
            },
            "-",
            {
                icon: _ico("light-bulb"),
                cls: "x-btn-text-icon",
                text: _("Publish"),
                ref: "../btnPublish",
                disabled:true,
                scope:this,
                handler: this.cmpPublish
            },
            {
                icon: _ico("light-bulb-off"),
                cls: "x-btn-text-icon",
                text: _("Unpublish"),
                ref: "../btnUnpublish",
                disabled:true,
                scope:this,
                handler: this.cmpUnpublish
            },
            "-",
            new Ext.form.ComboBox({
                editable:false,
                clearable:false,
                triggerAction: "all",
                forceSelection: true,
                valueField: "id",
                displayField: "title",
                emptyText: _("Show..."),
                store: new Ext.data.JsonStore({
                    autoDestroy: true,
                    url: _url("/plugin/rss/filter/"),
                    root: 'data',
                    fields: [ "id", "title" ]
                }),
                listeners: {
                    scope:this,
                    select: function (combo, record) {
                        this.store.baseParams.filter = record.get("id");
                        this.store.reload();
                    }
                }
            })
        ];

        this.bbar = new Ext.PagingToolbar({
            pageSize: 60,
            store: this.store,
            displayInfo: true,
            displayMsg: _("Displaying documents {0} - {1} of {2}"),
            emptyMsg: _("No documents to display")
        });

        Ext.apply(this, {
            border:false,
            stripeRows: true,
            columnLines: true,
            autoExpandColumn: "title",
            stateful: true,
            stateId: 'documents.plugins.rss.list',
            viewConfig: {
                getRowClass: function(record, rowIndex, rp, ds) {

                    var css = '';

                    if (record.get("rss_id") ) {
                        css = "inprint-grid-yellow-bg";
                    }

                    if (record.get("rss_published") ) {
                        css = "inprint-grid-green-bg";
                    }

                    return css;
                }
            }
        });

        Inprint.plugins.rss.Grid.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.plugins.rss.Grid.superclass.onRender.apply(this, arguments);
    },

    cmpSave: function() {

        // get modules changes
        var data = [];
        var records = this.getStore().getModifiedRecords();
        if(records.length) {
            Ext.each(records, function(r, i) {
                var page = r.get("id");
                var sortorder = r.get("rss_sortorder");
                data.push(page +'::'+ sortorder);
            }, this);
        }

        var o = {
            url: _url("/plugin/rss/save/"),
            params:{
                documents: data
            },
            scope:this,
            success: function () {
                this.getStore().commitChanges();
                this.cmpReload();
            }
        };

        Ext.Ajax.request(o);

    },

    cmpPublish: function() {
        Ext.Ajax.request({
            url: _url("/plugin/rss/publish/"),
            scope:this,
            success: this.cmpReload,
            params: { id: this.getValues("id") }
        });
    },

    cmpUnpublish: function() {
        Ext.Ajax.request({
            url: _url("/plugin/rss/unpublish/"),
            scope:this,
            success: this.cmpReload,
            params: { id: this.getValues("id") }
        });
    }
});
