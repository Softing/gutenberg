Inprint.settings.departments.MembersPanel = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.urls = {
            list: "/edition/get/accounts/list/",
            save: _url("/department/set/accounts/"),
            fill: _url("/department/get/accounts/")
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
                    header: _("Departments"),
                    sortable: false,
                    dataIndex: "stitle"
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
            url: this.urls.fill,
            scope: this,
            params: {
                department: this.params.department
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
                department: this.params.department,
                account: this.getValues("id")
            },
            success: function(response, options) {
                this.body.unmask();
            }
        });
    }
});