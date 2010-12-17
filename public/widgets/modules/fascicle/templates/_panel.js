Inprint.fascicle.templates.Main = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.fascicle = this.oid;
        this.panels = {};
        
        this.panels["pages"]     = new Inprint.fascicle.templates.Pages({
            parent: this
        });
        
        this.panels["modules"]   = new Inprint.fascicle.templates.Modules({
            parent: this
        });

        Ext.apply(this, {
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
                }
            ]
        });
        Inprint.fascicle.templates.Main.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.fascicle.templates.Main.superclass.onRender.apply(this, arguments);
        Inprint.fascicle.templates.Access(this, this.panels);
        Inprint.fascicle.templates.Context(this, this.panels);
        Inprint.fascicle.templates.Interaction(this, this.panels);
    },
    
    cmpReload: function() {
        this.panels["pages"].cmpReload();
        this.panels["modules"].cmpReload();
    }

});

Inprint.registry.register("fascicle-templates", {
    icon: "table-select-cells",
    text: _("Templates"),
    xobject: Inprint.fascicle.templates.Main
});