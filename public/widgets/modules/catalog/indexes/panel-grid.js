Inprint.catalog.indexes.Rubrics = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.store = Inprint.factory.Store.json("/catalog/indexes/rubrics/");
        
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        Ext.apply(this, {
            border: false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "description",
            columns: [
                this.selectionModel,
                {
                    id:"name",
                    header: _("Shortcut"),
                    width: 160,
                    sortable: true,
                    dataIndex: "shortcut"
                },
                {
                    id:"description",
                    header: _("Description"),
                    dataIndex: "description"
                }
            ],

            tbar: [
                '->',
                {
                    xtype:"searchfield",
                    width:200,
                    store: this.store
                }
            ]
        });

        Inprint.catalog.indexes.Rubrics.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.catalog.indexes.Rubrics.superclass.onRender.apply(this, arguments);
    }

});
