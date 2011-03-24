Inprint.cmp.memberRulesForm.Domain = Ext.extend(Ext.Panel, {

    initComponent: function() {
        this.grid = new Inprint.cmp.memberRulesForm.Domain.Restrictions();
        Ext.apply(this, {
            border:false,
            layout: "fit",
            title: _("Domain"),
            items: this.grid
        });
        Inprint.cmp.memberRulesForm.Domain.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.cmp.memberRulesForm.Domain.superclass.onRender.apply(this, arguments);
    },

    cmpGetGrid: function() {
        return this.grid;
    },

    cmpReload: function() {
        this.grid.cmpReload();
    }

});
