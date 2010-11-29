Inprint.advert.advertisers.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.store = Inprint.factory.Store.json("/advertising/advertisers/list/", {
            totalProperty: 'total'
        });
        
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        this.columns = [
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
                id:"shortcut",
                header: _("Shortcut"),
                sortable: true,
                dataIndex: "shortcut"
            },
            {
                id:"address",
                header: _("Address"),
                sortable: true,
                dataIndex: "address"
            },
            {
                id:"contact",
                header: _("Contact"),
                sortable: true,
                dataIndex: "contact"
            },
            {
                id:"phones",
                header: _("Phones"),
                sortable: true,
                dataIndex: "phones"
            },
            {
                id:"inn",
                header: _("INN"),
                sortable: true,
                dataIndex: "inn"
            },
            {
                id:"kpp",
                header: _("KPP"),
                sortable: true,
                dataIndex: "kpp"
            },
            {
                id:"bank",
                header: _("Bank"),
                sortable: true,
                dataIndex: "bank"
            },
            {
                id:"rs",
                header: _("RS"),
                sortable: true,
                dataIndex: "rs"
            },
            {
                id:"ks",
                header: _("KS"),
                sortable: true,
                dataIndex: "ks"
            },
            {
                id:"bik",
                header: _("BIK"),
                sortable: true,
                dataIndex: "bik"
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

        this.bbar = new Ext.PagingToolbar({
            pageSize: 100,
            store: this.store,
            displayInfo: true,
            plugins: new Ext.ux.SlidingPager()
        });

        Ext.apply(this, {
            border: false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "title"
        });

        Inprint.advert.advertisers.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.advert.advertisers.Grid.superclass.onRender.apply(this, arguments);
    }

});
