Inprint.settings.editions.HelpPanel = Ext.extend(Ext.Panel, {
    initComponent: function() {

        this.oid = "Inprint.settings.editions";

        Ext.apply(this, {
            title: _("Help"),
            bodyCssClass: "help-panel",
            preventBodyReset: true
        });

        Inprint.settings.editions.HelpPanel.superclass.initComponent.apply(this, arguments);
    },
    onRender: function() {
        
        Inprint.settings.editions.HelpPanel.superclass.onRender.apply(this, arguments);

        this.load({
            url: "/help/" + this.oid + "/",
//            discardUrl: false,
//            nocache: false,            
//            timeout: 30,
//            scripts: false
            text: _("Loading...")
        });

    }
});
