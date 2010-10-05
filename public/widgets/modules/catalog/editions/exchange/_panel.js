Inprint.catalog.exchange.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};

        this.panels.grid   = new Inprint.catalog.exchange.Grid();

        Ext.apply(this, {

            layout: "border",
            border: false,

            defaults: {
                collapsible: false,
                split: true
            },

            items: [
                {   region: "center",
                    layout:"fit",
                    bodyStyle:"background:transparent",
                    items: this.panels.grid
                }
            ]
        });

        Inprint.catalog.exchange.Panel.superclass.initComponent.apply(this, arguments);

        Inprint.catalog.exchange.Actions(this.panels);
        Inprint.catalog.exchange.Interaction(this.panels);
        Inprint.catalog.exchange.Context(this.panels);

    },

    onRender: function() {
        Inprint.catalog.exchange.Panel.superclass.onRender.apply(this, arguments);
    },

    cmpReload:function() {
        this.panels.grid.cmpReload();
    }

});
