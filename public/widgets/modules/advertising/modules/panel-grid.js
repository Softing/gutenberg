Inprint.advert.modules.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.store = Inprint.factory.Store.json("/advertising/requests/list/");
        
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        Ext.apply(this, {
            border: false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "title",
            columns: [
                this.selectionModel,
                {
                    id:"searial",
                    header: _("Serial"),
                    width: 40,
                    sortable: true,
                    dataIndex: "serialnum"
                },
                {
                    id:"title",
                    header: _("Title"),
                    width: 350,
                    sortable: true,
                    dataIndex: "title"
                },
                {
                    id:"advertiser",
                    header: _("Advertiser"),
                    width: 150,
                    sortable: true,
                    dataIndex: "advertiser_shortcut"
                },
                {
                    id:"fascicle",
                    header: _("Fascicle"),
                    width: 60,
                    sortable: true,
                    dataIndex: "fascicle_shortcut"
                },
                {
                    id:"position",
                    header: _("Position"),
                    width: 90,
                    sortable: true,
                    dataIndex: "place_shortcut"
                },
                {
                    id:"page",
                    header: _("Page"),
                    width: 50,
                    sortable: true,
                    dataIndex: "seqnum"
                },
                {
                    id:"modsize",
                    header: _("Module size"),
                    width: 90,
                    sortable: true,
                    dataIndex: "x"
                },
                {
                    id:"modified",
                    header: _("Last Modified"),
                    width: 90,
                    sortable: true,
                    dataIndex: "updated"
                },
                {
                    id:"manager",
                    header: _("Manager"),
                    width: 100,
                    sortable: true,
                    dataIndex: "manager_shortcut"
                },
                {
                    id:"status",
                    header: _("Status"),
                    width: 90,
                    sortable: true,
                    dataIndex: "status"
                },
                {
                    id:"payment",
                    header: _("Payment"),
                    width: 90,
                    sortable: true,
                    dataIndex: "payment"
                },
                {
                    id:"readiness",
                    header: _("Readiness"),
                    width: 90,
                    sortable: true,
                    dataIndex: "readiness"
                }
            ],

            tbar: [
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
            ]
        });

        Inprint.advert.modules.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.advert.modules.Grid.superclass.onRender.apply(this, arguments);
    }

});
