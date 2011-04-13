Inprint.cmp.memberRulesForm.Domain = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};
        this.panels.grid = new Inprint.cmp.memberRulesForm.Domain.Restrictions();

        Ext.apply(this, {
            border:false,
            layout: "fit",
            title: _("Company"),
            items: this.panels.grid
        });
        Inprint.cmp.memberRulesForm.Domain.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.cmp.memberRulesForm.Domain.superclass.onRender.apply(this, arguments);
    },

    cmpGetGrid: function() {
        return this.panels.grid;
    },

    cmpReload: function() {
        this.grid.cmpReload();
    }

});
