Inprint.advert.modules.Main = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.edition = null;
        this.panels = {};
        
        this.panels["editions"]  = new Inprint.advert.modules.Editions({
            parent: this
        });
        
        this.panels["pages"]     = new Inprint.advert.modules.Pages({
            parent: this
        });
        
        this.panels["modules"]   = new Inprint.advert.modules.Modules({
            parent: this
        });

        Ext.apply(this, {
            layout: "border",
            items: [
                {
                    region:"west",
                    width: 200,
                    minSize: 100,
                    maxSize: 600,
                    split: true,
                    layout:"fit",
                    margins: "3 0 3 3",
                    items: this.panels["editions"]
                },
                {
                    border:false,
                    region: "center",
                    layout: "border",
                    items: [
                        {
                            title: _("Pages"),
                            region: "center",
                            margins: "3 3 0 0",
                            layout:"fit",
                            items: this.panels["pages"]
                        },
                        {
                            title: _("Modules"),
                            region:"south",
                            height: 300,
                            minSize: 100,
                            maxSize: 600,
                            split: true,
                            layout:"fit",
                            margins: "0 3 3 0",
                            items: this.panels["modules"]
                        },
                    ]
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
    },
    
    cmpReload: function() {
        this.panels["pages"].cmpReload();
        this.panels["modules"].cmpReload();
    }

});

Inprint.registry.register("advert-modules", {
    icon: "table-select-cells",
    text: _("Advertizing modules"),
    xobject: Inprint.advert.modules.Main
});