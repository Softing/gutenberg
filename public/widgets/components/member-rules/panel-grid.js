Inprint.cmp.memberRules.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.store = Inprint.factory.Store.json("/catalog/members/rules/");
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        Ext.apply(this, {
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "rules",
            columns: [
                this.selectionModel,
                {
                    id:"shortcut",
                    width: 28,
                    sortable: true,
                    dataIndex: "area",
                    renderer: function(value, p, record) {
                        if (value == "edition")
                            return '<img title="Материал был просмотрен текущим владельцем" src="'+ _ico("book") +'">';
                        if (value == "group")
                            return '<img title="Материал был просмотрен текущим владельцем" src="'+ _ico("folder") +'">';
                        if (value == "member")
                            return '<img title="Материал был просмотрен текущим владельцем" src="'+ _ico("user-business") +'">';
                        return '';
                    }
                },
                {
                    id:"binding",
                    header: _("Binding"),
                    width: 80,
                    sortable: true,
                    dataIndex: "binding_shortcut"
                },
                {
                    id:"rules",
                    header: _("Rules"),
                    width: 160,
                    sortable: true,
                    dataIndex: "rules",
                    renderer: function(value, p, record) {
                        return value.join(",");
                    }
                }
            ]
        });

        Inprint.cmp.memberRules.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.memberRules.Grid.superclass.onRender.apply(this, arguments);
        this.on("afterrender", function() {
            this.cmpLoad();
        }, this);
    }

});
