Inprint.fascicle.adverta.Requests = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.components = {};
        this.urls = {
            "create": _url("/fascicle/requests/create/"),
            "read":   _url("/fascicle/requests/read/"),
            "update": _url("/fascicle/requests/update/"),
            "delete": _url("/fascicle/requests/delete/")
        };

        this.store = Inprint.factory.Store.json("/fascicle/requests/list/");

        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        this.columns = [
            this.selectionModel,
            {
                id:"searial",
                header: _("#"),
                width: 30,
                sortable: true,
                dataIndex: "serialnum"
            },
            {
                id:"advertiser",
                header: _("Advertiser"),
                width: 120,
                sortable: true,
                dataIndex: "advertiser_shortcut"
            },
            {
                id:"manager",
                header: _("Manager"),
                width: 120,
                sortable: true,
                dataIndex: "manager_shortcut"
            },
            {
                id:"title",
                header: _("Title"),
                width: 350,
                sortable: true,
                dataIndex: "shortcut"
            },

            {
                id:"position",
                header: _("Place"),
                width: 100,
                sortable: true,
                dataIndex: "place_shortcut"
            },
            {
                id:"template",
                header: _("Template"),
                width: 100,
                sortable: true,
                dataIndex: "origin_shortcut"
            },
            {
                id:"module",
                header: _("Module"),
                width: 100,
                sortable: true,
                dataIndex: "module_shortcut"
            },
            {
                id:"pages",
                header: _("Pages"),
                width: 60,
                sortable: true,
                dataIndex: "pages"
            },
            {
                id:"status",
                header: _("Status"),
                width: 70,
                sortable: true,
                dataIndex: "status"
            },
            {
                id:"payment",
                header: _("Payment"),
                width: 60,
                sortable: true,
                dataIndex: "payment"
            },
            {
                id:"readiness",
                header: _("Readiness"),
                width: 80,
                sortable: true,
                dataIndex: "readiness"
            },

            {
                id:"modified",
                header: _("Modified"),
                width: 110,
                sortable: true,
                xtype: 'datecolumn',
                format: "Y-m-d H:i",
                dataIndex: "updated"
            }

        ];

        this.tbar = [
            {
                icon: _ico("plus-button"),
                cls: "x-btn-text-icon",
                text: _("Add"),
                ref: "../btnCreate",
                scope:this,
                handler: this.cmpCreate
            },
            {
                icon: _ico("pencil"),
                cls: "x-btn-text-icon",
                text: _("Update"),
                disabled:true,
                ref: "../btnUpdate",
                scope:this,
                handler: this.cmpUpdate
            },
            '-',
            {
                icon: _ico("minus-button"),
                cls: "x-btn-text-icon",
                text: _("Remove"),
                disabled:true,
                ref: "../btnDelete",
                scope:this,
                handler: this.cmpDelete
            }
        ];

        Ext.apply(this, {
            border: false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "title"
        });

        Inprint.fascicle.adverta.Requests.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.fascicle.adverta.Requests.superclass.onRender.apply(this, arguments);
    },

    cmpCreate: function() {

        var pages       = this.parent.panels.pages;
        var selection   = pages.cmpGetSelected();

        if (selection.length > 2) {
            return;
        }

        var wndw = new Inprint.cmp.Adverta({
            fascicle: this.parent.fascicle,
            selection: selection
        });

        wndw.on("actioncomplete", function() {
            this.parent.cmpReload();
        }, this);

        wndw.show();
    },

    cmpUpdate: function() {
        alert("update");
    },

    cmpDelete: function() {
        alert("delete");
    }

});
