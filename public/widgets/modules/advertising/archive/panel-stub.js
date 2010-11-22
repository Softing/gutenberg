Inprint.advert.archive.Main = Ext.extend(Ext.Panel, {

    initComponent: function() {
        Ext.apply(this, {
        });
        // Call parent (required)
        Inprint.panels.Stub.superclass.initComponent.apply(this, arguments);
    },

    // Override other inherited methods
    onRender: function() {
        // Call parent (required)
        Inprint.panels.Stub.superclass.onRender.apply(this, arguments);
    }

});

Inprint.registry.register("advert-archive", {
    icon: "folders-stack",
    text: _("Archive of requests"),
    xobject: Inprint.advert.archive.Main
});