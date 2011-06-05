Inprint.catalog.indexes.Rubrics = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.headline = null;

        this.store = Inprint.factory.Store.json("/catalog/rubrics/list/");
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        this.columns = [
            this.selectionModel,
            {
                id:"title",
                header: _("Title"),
                width: 160,
                sortable: true,
                dataIndex: "title"
            },
            {
                id:"description",
                header: _("Description"),
                dataIndex: "description"
            }
        ];

        this.tbar = [
            Inprint.getButton("create.item"),
            Inprint.getButton("update.item"),
            Inprint.getButton("delete.item")
        ];

        Ext.apply(this, {
            title: _("Rubrics"),
            border: false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "description"
        });

        Inprint.catalog.indexes.Rubrics.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.catalog.indexes.Rubrics.superclass.onRender.apply(this, arguments);
    },

    getHeadline: function() {
        return this.edition;
    },

    setHeadline: function(id) {
        this.edition = id;
    }

});
