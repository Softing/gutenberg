Inprint.advert.index.Main = Ext.extend(Ext.Panel, {
    
    initComponent: function() {
        
        this.edition = null;
        this.panels = {};
        
        this.panels.editions  = new Inprint.advert.index.Editions({
            parent: this
        });
        this.panels.modules   = new Inprint.advert.index.Modules({
            parent: this
        });
        this.panels["headlines"] = new Inprint.advert.index.Headlines({
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
                    items: this.panels.editions
                },
                {
                    border:false,
                    region: "center",
                    layout: "border",
                    items: [
                        {
                            title: _("Modules"),
                            region: "center",
                            margins: "3 3 0 0",
                            layout:"fit",
                            items: this.panels.modules
                        },
                        {
                            title: _("Headlines"),
                            region:"south",
                            height: 300,
                            minSize: 100,
                            maxSize: 600,
                            split: true,
                            layout:"fit",
                            margins: "0 3 3 0",
                            items: this.panels["headlines"]
                        },
                    ]
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
    },
    
    cmpReload: function() {
        this.panels.modules.cmpReload();
        this.panels["headlines"].cmpReload();
    }

});

Inprint.registry.register("advert-index", {
    icon: "table-select-cells",
    text: _("Advertizing positions"),
    xobject: Inprint.advert.index.Main
});