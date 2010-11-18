Inprint.fascicle.advert.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        Inprint.fascicle.advert.Panel.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.fascicle.advert.Panel.superclass.onRender.apply(this, arguments);
    }
});

Inprint.registry.register("fascicle-advert", {
    icon: "currency",
    text: _("Advertising"),
    xobject: Inprint.fascicle.advert.Panel
});