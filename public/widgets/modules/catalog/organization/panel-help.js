Inprint.catalog.organization.HelpPanel = Ext.extend(Ext.Panel, {
    initComponent: function() {

        this.oid = "Inprint.catalog.organization";

        Ext.apply(this, {
            title: "Help",
            border:false,
            bodyCssClass: "help-panel",
            preventBodyReset: true
        });

        Inprint.catalog.organization.HelpPanel.superclass.initComponent.apply(this, arguments);
    },
    onRender: function() {

        Inprint.catalog.organization.HelpPanel.superclass.onRender.apply(this, arguments);

        this.load({
            method: 'get',
            url: "/help/" + this.oid + "/index.html",
            text: _("Loading...")
        });

    }
});
