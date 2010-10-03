Inprint.exchange.HelpPanel = Ext.extend(Ext.Panel, {
    initComponent: function() {

        Ext.apply(this, {
            title: _("Help"),
            bodyCssClass: "help-panel",
            preventBodyReset: true
        });

        Inprint.exchange.HelpPanel.superclass.initComponent.apply(this, arguments);
    },
    onRender: function() {

        Inprint.exchange.HelpPanel.superclass.onRender.apply(this, arguments);

        this.load({
            method: "get",
            url: "/help/Inprint.exchange/",
            text: _("Loading...")
        });

    }
});
