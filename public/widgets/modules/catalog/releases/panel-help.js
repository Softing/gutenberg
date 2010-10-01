Inprint.catalog.releases.HelpPanel = Ext.extend(Ext.Panel, {
    initComponent: function() {

        this.oid = "Inprint.catalog.releases";

        Ext.apply(this, {
            title: "Help",
            border:false,
            bodyCssClass: "help-panel",
            preventBodyReset: true
        });

        Inprint.catalog.releases.HelpPanel.superclass.initComponent.apply(this, arguments);
    },
    onRender: function() {

        Inprint.catalog.releases.HelpPanel.superclass.onRender.apply(this, arguments);

        this.load({
            method: 'get',
            url: "/help/" + this.oid + "/",
            text: _("Loading...")
        });

    }
});
