Inprint.settings.exchange.MembersPanel = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.urls = {
            list: "/common/passport/mixed/list/",
            save: _url("/settings/exchange/accounts/set/"),
            fill: _url("/settings/exchange/accounts/get/")
        }

        this.components = {};
        this.params = {};

        this.store = Inprint.factory.Store.json(this.urls.list),
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        Ext.apply(this, {
            title: _("Employees"),
            disabled:true,
            border:false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "title",
            columns: [
                this.selectionModel,
                {
                    id:"title",
                    header: _("Departments and employees"),
                    sortable: false,
                    dataIndex: "stitle",
                    renderer: function(value, p, r) {
                        return '<div style="padding-left:20px;background:url(' + _ico(r.get("icon")) + ') no-repeat;">' + value + '</div>';
                    }
                }
            ],
            tbar: [
                {
                    icon: _ico("disk-black.png"),
                    cls: "x-btn-text-icon",
                    text: _("Save"),
                    disabled:false,
                    ref: "../btnSave",
                    scope:this,
                    handler: this.cmpSave
                },
                '->',
                {
                    icon: _ico("arrow-circle-double.png"),
                    cls: "x-btn-icon",
                    scope:this,
                    handler: this.cmpReload
                }
            ]
        });
        Inprint.settings.exchange.MembersPanel.superclass.initComponent.apply(this, arguments);
        this.getStore().on("load", this.cmpFill, this);
    },

    onRender: function() {
        Inprint.settings.exchange.MembersPanel.superclass.onRender.apply(this, arguments);
    },

    cmpFill: function(edition, member) {

        this.body.mask(_("Please wait..."));
        this.getSelectionModel().clearSelections();

        Ext.Ajax.request({
            url: this.urls.fill,
            scope: this,
            params: {
                id: this.params.id
            },
            success: function(response) {
                var cache = {};
                var ds = this.getStore();
                var sm = this.getSelectionModel();
                var responce = Ext.util.JSON.decode(response.responseText);
                for (var i = 0; i < responce.data.length; i++) {
                    cache[ responce.data[i] ] = true;
                }
                for (i = 0; i < ds.getCount(); i++) {
                    if (cache[ ds.getAt(i).data.id ])
                        sm.selectRow(i, true);
                }

                this.body.unmask();
            }
        });
    },

    cmpSave: function() {

        this.body.mask(_("Please wait..."));

        Ext.Ajax.request({
            scope:this,
            url: this.urls.save,
            params: {
                id: this.params.id,
                account: this.getValues("id")
            },
            success: function(response, options) {
                this.body.unmask();
            }
        });
    }
});