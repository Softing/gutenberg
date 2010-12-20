Inprint.fascicle.places.Main = Ext.extend(Ext.Panel, {
    
    initComponent: function() {
        
        this.fascicle = this.oid;
        this.panels = {};
        
        this.panels["places"]   = new Inprint.fascicle.places.Places({
            parent: this
        });
        
        this.panels["modules"]   = new Inprint.fascicle.places.Modules({
            parent: this
        });
        
        this.panels["headlines"] = new Inprint.fascicle.places.Headlines({
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
                    items: this.panels["places"]
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
                            items: this.panels["modules"]
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
                        }
                    ]
                }
            ]
        });
        Inprint.fascicle.places.Main.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.fascicle.places.Main.superclass.onRender.apply(this, arguments);
        Inprint.fascicle.places.Access(this, this.panels);
        Inprint.fascicle.places.Context(this, this.panels);
        Inprint.fascicle.places.Interaction(this, this.panels);
    },
    
    cmpReload: function() {
        this.panels["modules"].cmpReload();
        this.panels["headlines"].cmpReload();
    }

});

Inprint.registry.register("fascicle-places", {
    icon: "table-select-cells",
    text: _("Advertizing positions"),
    xobject: Inprint.fascicle.places.Main
});