Inprint.advert.advertisers.Main = Ext.extend(Ext.Panel, {

    initComponent: function() {
        Ext.apply(this, {
        });
        Inprint.panels.Stub.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.panels.Stub.superclass.onRender.apply(this, arguments);
    }

});

Inprint.registry.register("advert-advertisers", {
    icon: "user-silhouette",
    text: _("Advertisers"),
    xobject: Inprint.advert.advertisers.Main
});