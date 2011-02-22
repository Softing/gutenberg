Inprint.plugins.rss.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        var actions = new Inprint.documents.GridActions();
        var columns = new Inprint.documents.GridColumns();

        this.components = {};

        this.urls = {
            "list": _url("/plugin/rss/list/")
        };

        var fields = Inprint.factory.StoreFields["/documents/list/"];
        fields.push("rss_id", "rss_published");

        this.store = new Ext.data.JsonStore(Ext.apply(
            Inprint.factory.StoreDefaults, {
                autoLoad:true,
                remoteSort: true,
                totalProperty: 'total',
                url: this.urls.list,
                baseParams: { flt_rssonly: false },
                fields: fields
            })
        );

        this.sm = new Ext.grid.CheckboxSelectionModel();

        this.columns = [
            this.sm,
            {
                id:"publihed",
                width: 32,
                dataIndex: "rss_published",
                sortable: false,
                renderer: function(v) {
                    var image = '';
                    if (v==1) { image = '<img src="'+ _ico("light-bulb") +'"/>'; }
                    return image;
                }

            },
            {
                id:"title",
                width: 32,
                header:_("Titl"),
                dataIndex: "title",
                sortable: false,
                renderer: function(v) {
                    return '<b>'+ v +'</b>';
                }

            },
            //columns.title,
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
            {
                icon: _ico("funnel"),
                cls: "x-btn-text-icon",
                text: _("Show only with RSS"),
                ref: "../btnSwitch",
                pressed: false,
                enableToggle: true,
                scope:this,
                toggleHandler: function(btn, tgle) {
                    this.store.baseParams.flt_rssonly = tgle;
                    this.store.reload();
                }
            }
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

                    //if (Inprint.session.member && Inprint.session.member.id == record.get("manager") ) {
                    //    css = 'inprint-document-grid-current-manager-bg';
                    //}

                    if (record.get("rss_id") ) {
                        css = 'inprint-document-grid-current-department-bg';
                    }

                    if (record.get("rss_published") ) {
                        css = 'inprint-document-grid-current-user-bg';
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

    cmpPublish: function() {
        Ext.MessageBox.confirm(
            _("Irreversible removal"),
            _("You can't cancel this action!"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: _url("/plugin/rss/publish/"),
                        scope:this,
                        success: this.cmpReload,
                        params: { id: this.getValues("id") }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    },

    cmpUnpublish: function() {
        Ext.MessageBox.confirm(
            _("Irreversible removal"),
            _("You can't cancel this action!"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: _url("/plugin/rss/unpublish/"),
                        scope:this,
                        success: this.cmpReload,
                        params: { id: this.getValues("id") }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    }
});
