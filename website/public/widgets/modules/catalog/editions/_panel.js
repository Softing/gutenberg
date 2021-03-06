Inprint.catalog.editions.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.access = {};
        this.panels = {};

        this.panels.tree = new Inprint.panel.tree.Editions({
            baseParams: {
                options: "showRoot"
            }
        });
        this.panels.grid = new Inprint.catalog.editions.Grid();
        this.panels.help = new Inprint.panels.Help({ hid: this.xtype });

        Ext.apply(this, {

            layout: "border",

            defaults: {
                collapsible: false,
                split: true
            },

            items: [
                {
                    region: "center",
                    layout:"fit",
                    margins: "3 0 3 0",
                    items: this.panels.grid
                },
                {
                    region:"west",
                    margins: "3 0 3 3",
                    width: 200,
                    minSize: 200,
                    maxSize: 600,
                    layout:"fit",
                    items: this.panels.tree
                },
                {
                    region:"east",
                    margins: "3 3 3 0",
                    width: 400,
                    minSize: 200,
                    maxSize: 600,
                    collapseMode: 'mini',
                    layout:"fit",
                    items: this.panels.help
                }
            ]
        });

        Inprint.catalog.editions.Panel.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.catalog.editions.Panel.superclass.onRender.apply(this, arguments);

        Inprint.catalog.editions.Interaction(this, this.panels);
    },

    cmpReload:function() {
        this.panels.grid.cmpReload();
    }

});

Inprint.registry.register("settings-editions", {
    icon: "blue-folders",
    text: _("Editions"),
    xobject: Inprint.catalog.editions.Panel
});
