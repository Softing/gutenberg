Inprint.cmp.memberRulesForm.Editions.Restrictions = Ext.extend(Ext.grid.EditorGridPanel, {

    initComponent: function() {

        var url = "/catalog/rules/list/";

        this.sm = new Ext.grid.CheckboxSelectionModel({
            checkOnly:true
        });

        this.store = Inprint.factory.Store.json(url, {
            autoLoad: false,
            baseParams: {
                section: this.cmpGetSection()
            }
        });

        this.columns = [
            this.sm,
            {
                id:"icon",
                width: 30,
                dataIndex: "icon",
                renderer: function (value, meta, record) {
                    return '<img src="'+ _ico(value) +'"/>';
                }
            },
            {
                id:"title",
                header: _("Rule"),
                width: 120,
                sortable: true,
                dataIndex: "title",
                renderer: function (value, meta, record) {
                    return _(value);
                }
            }
        ];

        Ext.apply(this, {
            disabled: true,
            stripeRows: true,
            columnLines: true,
            clicksToEdit: 1,
            autoExpandColumn: "title"
        });

        Inprint.cmp.memberRulesForm.Editions.Restrictions.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.memberRulesForm.Editions.Restrictions.superclass.onRender.apply(this, arguments);
        this.getStore().load();
    },

    cmpSetBinding: function(id) {
        this.nodeId = id;
    },

    cmpGetBinding: function() {
        return this.nodeId;
    },

    cmpGetSection: function() {
        return "editions";
    }

});
