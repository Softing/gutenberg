Inprint.advert.advertisers.Main = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};
        this.panels["tree"]  = new Inprint.advert.advertisers.Tree();
        this.panels["grid"]  = new Inprint.advert.advertisers.Grid();

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
        Inprint.advert.advertisers.Main.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.advert.advertisers.Main.superclass.onRender.apply(this, arguments);
        Inprint.advert.advertisers.Interaction(this, this.panels);
    }

});

Inprint.registry.register("advert-advertisers", {
    icon: "user-silhouette",
    text: _("Advertisers"),
    xobject: Inprint.advert.advertisers.Main
});