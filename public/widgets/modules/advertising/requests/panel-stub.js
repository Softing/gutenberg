Inprint.advert.requests.Main = Ext.extend(Ext.Panel, {

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

Inprint.registry.register("advert-requests", {
    icon: "money",
    text: _("Advertizing requests"),
    xobject: Inprint.advert.requests.Main
});