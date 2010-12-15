Inprint.advert.modules.Main = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};
        this.panels["editions"]  = new Inprint.advert.modules.Editions();
        this.panels["pages"] = new Inprint.advert.modules.Grid();

        Ext.apply(this, {
            layout: "border",
            items: [
                {
                    region:"west",
                    width: 300,
                    minSize: 100,
                    maxSize: 600,
                    split: true,
                    layout:"fit",
                    margins: "3 0 3 3",
                    items: this.panels["editions"]
                },
                {
                    region: "center",
                    border:false,
                    margins: "3 3 3 0",
                    layout:"fit",
                    items: this.panels["pages"]
                }
            ]
        });
        Inprint.advert.modules.Main.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.advert.modules.Main.superclass.onRender.apply(this, arguments);
        Inprint.advert.modules.Access(this, this.panels);
        Inprint.advert.modules.Context(this, this.panels);
        Inprint.advert.modules.Interaction(this, this.panels);
    }

});

Inprint.registry.register("advert-modules", {
    icon: "table-select-cells",
    text: _("Advertizing modules"),
    xobject: Inprint.advert.modules.Main
});