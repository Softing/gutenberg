Inprint.catalog.exchange.HelpPanel = Ext.extend(Ext.Panel, {
    initComponent: function() {

        Ext.apply(this, {
            title: _("Help"),
            bodyCssClass: "help-panel",
            preventBodyReset: true
        });

        Inprint.catalog.exchange.HelpPanel.superclass.initComponent.apply(this, arguments);
    },
    onRender: function() {

        Inprint.catalog.exchange.HelpPanel.superclass.onRender.apply(this, arguments);

        this.load({
            method: "get",
            url: "/help/Inprint.catalog.exchange/",
            text: _("Loading...")
        });

    }
});
