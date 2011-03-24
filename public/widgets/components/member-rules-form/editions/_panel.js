Inprint.cmp.memberRulesForm.Editions = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};
        this.panels.tree = new Inprint.cmp.memberRulesForm.Editions.Tree();
        this.panels.grid = new Inprint.cmp.memberRulesForm.Editions.Restrictions();

        Ext.apply(this, {
            border:false,
            title: _("Editions"),
            layout: "border",
            defaults: {
                collapsible: false,
                split: true
            },
            items: [
                {
                    region: "center",
                    layout:"fit",
                    border:false,
                    margins: "3 3 3 0",
                    items: this.panels.grid
                },
                {
                    region:"west",
                    layout:"fit",
                    border:false,
                    margins: "3 0 3 3",
                    width: 200,
                    items: this.panels.tree
                }
            ]
        });

        Inprint.cmp.memberRulesForm.Editions.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.cmp.memberRulesForm.Editions.superclass.onRender.apply(this, arguments);
    },

    cmpGetTree: function() {
        return this.panels.tree;
    },

    cmpGetGrid: function() {
        return this.panels.grid;
    },

    cmpReload: function() {
        this.panels.grid.cmpReload();
    }

});
