Inprint.cmp.memberRulesForm.Domain.Restrictions = Ext.extend(Ext.grid.EditorGridPanel, {

    initComponent: function() {

        this.uid = null;
        this.record = null;

        this.components = {};

        var url = "/catalog/rules/list/";

        this.sm = new Ext.grid.CheckboxSelectionModel({
            checkOnly:true
        });

        this.store = Inprint.factory.Store.json(url, {
            autoLoad: false,
            baseParams: {
                section: 'domain'
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

        this.tbar = [
            {
                icon: _ico("disk-black"),
                cls: "x-btn-text-icon",
                text: _("Save"),
                ref: "../btnSave",
                scope:this
            }
        ];

        Ext.apply(this, {
            disabled: false,
            stripeRows: true,
            columnLines: true,
            clicksToEdit: 1,
            autoExpandColumn: "title"
        });

        Inprint.cmp.memberRulesForm.Domain.Restrictions.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.memberRulesForm.Domain.Restrictions.superclass.onRender.apply(this, arguments);
        this.getStore().load();
    },

    cmpGetBinding: function() {
        return "00000000-0000-0000-0000-000000000000";
    },

    cmpGetSection: function() {
        return "domain";
    }

});
