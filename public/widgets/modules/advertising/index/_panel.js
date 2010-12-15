Inprint.advert.index.Main = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};
        this.panels["places"]  = new Inprint.advert.index.Places();
        this.panels["modules"] = new Inprint.advert.index.Grid();

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
                    items: this.panels["places"]
                },
                {
                    region: "center",
                    border:false,
                    margins: "3 3 3 0",
                    layout:"fit",
                    items: this.panels["modules"]
                }
            ]
        });
        Inprint.advert.index.Main.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.advert.index.Main.superclass.onRender.apply(this, arguments);
        Inprint.advert.index.Access(this, this.panels);
        Inprint.advert.index.Context(this, this.panels);
        Inprint.advert.index.Interaction(this, this.panels);
    }

});

Inprint.registry.register("advert-index", {
    icon: "table-select-cells",
    text: _("Advertizing index"),
    xobject: Inprint.advert.index.Main
});