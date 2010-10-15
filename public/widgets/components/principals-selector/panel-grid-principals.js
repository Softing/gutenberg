Inprint.cmp.PrincipalsSelector.Principals = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.store = Inprint.factory.Store.json("/catalog/principals/list/");
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        Ext.apply(this, {
            stripeRows: true,
            columnLines: true,
            enableDragDrop: true,
            ddGroup: 'principals-selector',
            sm: this.selectionModel,
            autoExpandColumn: "description",
            columns: [
                this.selectionModel,
                {
                    id:"icon",
                    width: 28,
                    dataIndex: "type",
                    renderer: function(v) {
                        var icon;
                        switch (v) {
                            case "group":
                                icon = _ico("folder");
                            break;
                            case "member":
                                icon = _ico("user");
                            break;
                        }
                        return "<img src=\""+ icon +"\">";
                    }
                },
                {
                    id:"name",
                    header: _("Title"),
                    width: 160,
                    sortable: true,
                    dataIndex: "title",
                    renderer: function(v, p, record) {
                        var text;
                        switch (record.data.type) {
                            case "group":
                                text = "<b>" + v +"</b>";
                            break;
                            case "member":
                                text = v;
                            break;
                        }
                        return text;
                    }
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

        Inprint.cmp.PrincipalsSelector.Principals.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.PrincipalsSelector.Principals.superclass.onRender.apply(this, arguments);
    }

});
