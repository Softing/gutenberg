Inprint.catalog.statuses.HelpPanel = Ext.extend(Ext.Panel, {
    initComponent: function() {

        this.oid = "Inprint.catalog.editions";

        Ext.apply(this, {
            title: "Help",
            border:false,
            bodyCssClass: "help-panel",
            preventBodyReset: true
        });

        Inprint.catalog.statuses.HelpPanel.superclass.initComponent.apply(this, arguments);
    },
    onRender: function() {

        Inprint.catalog.statuses.HelpPanel.superclass.onRender.apply(this, arguments);

        this.load({
            method: 'get',
            url: "/help/" + this.oid + "/index.html",
            text: _("Loading...")
        });

    }
});
