Inprint.fascicle.modules.Main = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.fascicle = this.oid;
        this.panels = {};

        this.panels.pages     = new Inprint.fascicle.modules.Pages({
            parent: this
        });

        this.panels.modules   = new Inprint.fascicle.modules.Modules({
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
                    items: this.panels.pages
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
                    items: this.panels.modules
                }
            ]
        });
        Inprint.fascicle.modules.Main.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.fascicle.modules.Main.superclass.onRender.apply(this, arguments);
        Inprint.fascicle.modules.Access(this, this.panels);
        Inprint.fascicle.modules.Context(this, this.panels);
        Inprint.fascicle.modules.Interaction(this, this.panels);
    },

    cmpReload: function() {
        this.panels.pages.cmpReload();
        this.panels.modules.cmpReload();
    }

});

Inprint.registry.register("fascicle-modules", {
    icon: "table-select-cells",
    text: _("Templates of pages"),
    xobject: Inprint.fascicle.modules.Main
});
