Inprint.settings.exchange.HelpPanel = Ext.extend(Ext.Panel, {
    initComponent: function() {

        Ext.apply(this, {
            title: _("Help"),
            bodyCssClass: "help-panel",
            preventBodyReset: true
        });

        Inprint.settings.exchange.HelpPanel.superclass.initComponent.apply(this, arguments);
    },
    onRender: function() {

        Inprint.settings.exchange.HelpPanel.superclass.onRender.apply(this, arguments);

        this.load({
            url: "/help/Inprint.settings.exchange/",
//            discardUrl: false,
//            nocache: false,
//            timeout: 30,
//            scripts: false
            text: _("Loading...")
        });

    }
});
