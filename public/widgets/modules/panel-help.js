Inprint.panels.Help = Ext.extend(Ext.Panel, {

    initComponent: function() {

        Ext.apply(this, {
            title: _("Help"),
            border:false,
            bodyCssClass: "help-panel",
            preventBodyReset: true
        });

        Inprint.panels.Help.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {

        Inprint.panels.Help.superclass.onRender.apply(this, arguments);

        if ( this.hid ) {
            //this.load({
            //    method: 'get',
            //    url: "/help/" + this.hid + "/index.html",
            //    text: _("Loading...")
            //});
        }

    }
});
