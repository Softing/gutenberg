Inprint.catalog.readiness.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.store = Inprint.factory.Store.json(
            "/catalog/readiness/list/", {
                autoLoad:true
            });

        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        this.columns = [
            this.selectionModel,
            {
                id:"color",
                header: _("Color"),
                width: 40,
                sortable: true,
                dataIndex: "color",
                renderer: function(value){
                    return '<div style="background:#'+ value +'">&nbsp;</div>';
                }
            },
            {
                id:"percent",
                header: _("Percent"),
                width: 60,
                sortable: true,
                dataIndex: "percent"
            },
            {
                id:"shortcut",
                header: _("Shortcut"),
                width: 120,
                sortable: true,
                dataIndex: "shortcut"
            },
            {
                id:"title",
                header: _("Title"),
                width: 120,
                sortable: true,
                dataIndex: "title"
            },
            {
                id:"description",
                header: _("Description"),
                sortable: true,
                dataIndex: "description"
            }
        ];

        this.tbar = [
            Inprint.getButton("create.item"),
            Inprint.getButton("update.item"),
            Inprint.getButton("delete.item")
        ];

        Ext.apply(this, {
            border:false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "description"
        });

        Inprint.catalog.readiness.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.catalog.readiness.Grid.superclass.onRender.apply(this, arguments);
    }

});
