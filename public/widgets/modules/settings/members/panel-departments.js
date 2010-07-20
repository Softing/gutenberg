Inprint.settings.members.DepartmentsPanel = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.components = {};
        this.params = {};

        this.store = Inprint.factory.Store.json("/edition/get/departments/list/"),
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        Ext.apply(this, {

            title: _("Departments"),
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
                    header: _("Departments"),
                    sortable: false,
                    dataIndex: "title"
                }
            ],
            tbar: [
                {
                    icon: _ico("disk-black.png"),
                    cls: "x-btn-text-icon",
                    text: _("Save"),
                    disabled:true,
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

        Inprint.settings.members.DepartmentsPanel.superclass.initComponent.apply(this, arguments);

        this.getStore().on("load", this.cmpFill, this);

    },

    onRender: function() {
        Inprint.settings.members.DepartmentsPanel.superclass.onRender.apply(this, arguments);
    },

    cmpFill: function(edition, member) {

        this.body.mask(_("Please wait..."));
        this.getSelectionModel().clearSelections();

        Ext.Ajax.request({
            url: _url("/member/get/departments/"),
            scope: this,
            params: {
                account: this.params.account
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
            url: _url("/member/set/departments/"),
            params: {
                account: this.params.account,
                department: this.getValues("id")
            },
            success: function(response, options) {
                this.body.unmask();
            }
        });
    }
});