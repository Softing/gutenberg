Inprint.exchange.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};

        this.panels.grid   = new Inprint.exchange.Grid();
        this.panels.help   = new Inprint.exchange.HelpPanel({ oid: this.oid });
        this.panels.chains = new Inprint.exchange.ChainsView();

        Ext.apply(this, {

            layout: "border",

            defaults: {
                collapsible: false,
                split: true
            },

            items: [
                {   region: "center",
                    margins: "3 0 3 0",
                    layout:"fit",
                    bodyStyle:"background:transparent",
                    items: this.panels.grid
                },
                {   title:_("Chains"),
                    region:"west",
                    margins: "3 0 3 3",
                    width: 100,
                    minSize: 50,
                    maxSize: 300,
                    layout:"fit",
                    items: this.panels.chains
                },
                {   region:"east",
                    margins: "3 3 3 0",
                    width: 460,
                    minSize: 200,
                    maxSize: 600,
                    layout:"fit",
                    collapseMode: 'mini',
                    collapsed:true,
                    items: this.panels.help
                }
            ]
        });

        Inprint.exchange.Panel.superclass.initComponent.apply(this, arguments);

        Inprint.exchange.Actions(this.panels);
        Inprint.exchange.Interaction(this.panels);
        Inprint.exchange.Context(this.panels);

    },

    onRender: function() {
        Inprint.exchange.Panel.superclass.onRender.apply(this, arguments);
    },

    cmpReload:function() {
        this.panels.grid.cmpReload();
    }

});
