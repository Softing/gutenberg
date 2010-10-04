Inprint.cmp.membersList.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.store = Inprint.factory.Store.json("/members/list/");
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        Ext.apply(this, {
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "name",

            enableDragDrop: true,
            ddGroup:'member2catalog',

            columns: [
                this.selectionModel,
                {
                    id:"login",
                    header: _("Login"),
                    width: 80,
                    sortable: true,
                    dataIndex: "login"
                },
                {
                    id:"position",
                    header: _("Position"),
                    width: 160,
                    sortable: true,
                    dataIndex: "position"
                },
                {
                    id:"shortcut",
                    header: _("Shortcut"),
                    width: 120,
                    sortable: true,
                    dataIndex: "shortcut"
                },
                {
                    id:"name",
                    header: _("Title"),
                    width: 120,
                    sortable: true,
                    dataIndex: "title"
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

        Inprint.cmp.membersList.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.membersList.Grid.superclass.onRender.apply(this, arguments);
    }

});
