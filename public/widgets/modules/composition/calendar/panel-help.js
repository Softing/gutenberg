Inprint.edition.calendar.HelpPanel = Ext.extend(Ext.Panel, {
    initComponent: function() {

        this.oid = "Inprint.edition.calendar";

        Ext.apply(this, {
            title: _("Help"),
            border:false,
            bodyCssClass: "help-panel",
            preventBodyReset: true
        });

        Inprint.edition.calendar.HelpPanel.superclass.initComponent.apply(this, arguments);
    },
    onRender: function() {

        Inprint.edition.calendar.HelpPanel.superclass.onRender.apply(this, arguments);

        this.load({
            method: 'get',
            url: "/help/" + this.oid + "/index.html",
            text: _("Loading...")
        });

    }
});
