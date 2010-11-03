Inprint.cmp.memberRules.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.store = Inprint.factory.Store.json("/catalog/members/rules/", {
            autoLoad: true
        });
        
        this.columns = [
            {
                id:"shortcut",
                width: 28,
                sortable: true,
                dataIndex: "area",
                renderer: function(value, p, record) {
                    if (value == "domain")
                        return '<img src="'+ _ico("building") +'">';
                    if (value == "edition")
                        return '<img src="'+ _ico("book") +'">';
                    if (value == "group")
                        return '<img src="'+ _ico("folder") +'">';
                    if (value == "member")
                        return '<img src="'+ _ico("user-business") +'">';
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
        ];
        
        Ext.apply(this, {
            border:false,
            stripeRows: true,
            columnLines: true,
            autoExpandColumn: "rules"
        });

        Inprint.cmp.memberRules.Grid.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.cmp.memberRules.Grid.superclass.onRender.apply(this, arguments);
    }
});
