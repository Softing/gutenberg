Inprint.cmp.Uploader = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.panels = {};

        this.panels.flash = new Inprint.cmp.uploader.Flash({
            config: this.config
        });

        this.panels.html = new Inprint.cmp.uploader.Html({
            config: this.config
        });

        Ext.apply(this, {
            title: _("Upload document"),
            modal: true,
            layout: "fit",
            closeAction: "hide",
            width:520, height:280,
            items: {
                xtype: 'tabpanel',
                activeTab: 0,
                border: false,
                items: [
                    this.panels.flash,
                    this.panels.html
                ]
            }
        });
        Inprint.cmp.Uploader.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.cmp.Uploader.superclass.onRender.apply(this, arguments);
        Inprint.cmp.uploader.Interaction(this, this.panels);

        this.relayEvents(this.panels.flash, ['fileUploaded']);
        this.relayEvents(this.panels.html,  ['fileUploaded']);

    }

});
