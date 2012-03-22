Inprint.cmp.memberRules = Ext.extend(Ext.Window, {

    initComponent: function() {
        this.panels = {};
        this.panels.grid = new Inprint.cmp.memberRules.Grid();
        Ext.apply(this, {
            title: _("Review of access rights"),
            modal: true,
            layout: "fit",
            closeAction: "hide",
            width:800, height:400,
            items: this.panels.grid
        });
        Inprint.cmp.memberRules.superclass.initComponent.apply(this, arguments);
        Inprint.cmp.memberRules.Interaction(this, this.panels);
    },

    onRender: function() {
        Inprint.cmp.memberRules.superclass.onRender.apply(this, arguments);
    }

});

Inprint.registry.register("employee-access", {
    icon: "key",
    text: _("Access"),
    handler: function() {
        new Inprint.cmp.memberRules().show();
    }
});