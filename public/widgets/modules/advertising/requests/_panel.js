Inprint.advert.requests.Main = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};
        this.panels["tree"]  = new Inprint.advert.requests.Tree();
        this.panels["grid"]  = new Inprint.advert.requests.Grid();

        Ext.apply(this, {
            layout: "border",
            defaults: {
                collapsible: false,
                split: true
            },
            items: [
                {   region:"west",
                    margins: "3 0 3 3",
                    width: 150,
                    minSize: 50,
                    maxSize: 300,
                    layout:"fit",
                    collapseMode: 'mini',
                    items: this.panels["tree"]
                },
                {   region: "center",
                    margins: "3 3 3 0",
                    layout:"fit",
                    items: this.panels["grid"]
                }
            ]
        });
        Inprint.advert.requests.Main.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.advert.requests.Main.superclass.onRender.apply(this, arguments);
        Inprint.advert.requests.Interaction(this, this.panels);
    }

});

Inprint.registry.register("advert-requests", {
    icon: "money",
    text: _("Advertizing requests"),
    xobject: Inprint.advert.requests.Main
});