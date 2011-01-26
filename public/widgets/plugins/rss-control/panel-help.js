Inprint.plugins.rss.control.HelpPanel = Ext.extend(Ext.Panel, {
    initComponent: function() {

        this.oid = "Inprint.plugins.rss.control";

        Ext.apply(this, {
            title: _("Help"),
            border:false,
            bodyCssClass: "help-panel",
            preventBodyReset: true
        });

        Inprint.plugins.rss.control.HelpPanel.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {

        Inprint.plugins.rss.control.HelpPanel.superclass.onRender.apply(this, arguments);

        //this.load({
        //    method: 'get',
        //    url: "/help/" + this.oid + "/index.html",
        //    text: _("Loading...")
        //});

    }
});
