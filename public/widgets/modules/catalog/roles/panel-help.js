Inprint.catalog.roles.HelpPanel = Ext.extend(Ext.Panel, {
    initComponent: function() {
        Ext.apply(this, {
            border:false,
            title: _("Help"),
            bodyCssClass: "help-panel",
            preventBodyReset: true
        });
        Inprint.catalog.roles.HelpPanel.superclass.initComponent.apply(this, arguments);
    },
    onRender: function() {
        Inprint.catalog.roles.HelpPanel.superclass.onRender.apply(this, arguments);
        this.load({
            method: "get",
            url: "/help/" + this.oid + "/index.html",
            text: _("Loading") + "...'"
        });
    }
});
