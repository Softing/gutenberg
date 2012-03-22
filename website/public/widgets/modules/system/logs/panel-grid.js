Inprint.system.logs.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.sm    = new Ext.grid.CheckboxSelectionModel();
        this.store = Inprint.factory.Store.json("/catalog/stages/list/");

        this.columns = [
            this.sm
        ];

        Ext.apply(this, {
            border:false,
            stripeRows: true,
            columnLines: true
        });

        Inprint.system.logs.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.system.logs.Grid.superclass.onRender.apply(this, arguments);
    }

});
