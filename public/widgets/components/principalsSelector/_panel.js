Inprint.cmp.PrincipalsSelector = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.panels = {};
        this.panels.tree = new Inprint.cmp.PrincipalsSelector.Tree();
        this.panels.principals = new Inprint.cmp.PrincipalsSelector.Principals();
        this.panels.selection  = new Inprint.cmp.PrincipalsSelector.Selection({
            urlLoad: this.urlLoad
        });

        Ext.apply(this, {
            title: _("Principals list"),
            layout: "border",
            width:800, height:500,
            items: [
                {
                    region: "center",
                    border:false,
                    layout:"border",
                    margins: "3 3 3 0",
                    items: [
                        {
                            region: "center",
                            layout:"fit",
                            margins: "3 3 3 0",
                            border:false,
                            items: this.panels.principals
                        },
                        {
                            region:"south",
                            layout:"fit",
                            margins: "3 0 3 3",
                            height: 180,
                            minSize: 50,
                            maxSize: 600,
                            collapsible: false,
                            split: true,
                            items: this.panels.selection
                        }
                    ]
                },
                {
                    region:"west",
                    layout:"fit",
                    margins: "3 0 3 3",
                    width: 200,
                    minSize: 100,
                    maxSize: 600,
                    collapsible: false,
                    split: true,
                    items: this.panels.tree
                }
            ]
        });
        Inprint.cmp.PrincipalsSelector.superclass.initComponent.apply(this, arguments);
        Inprint.cmp.PrincipalsSelector.Interaction(this.panels);

        this.relayEvents(this.panels.selection, ['save', 'delete']);

    },

    onRender: function() {
        Inprint.cmp.PrincipalsSelector.superclass.onRender.apply(this, arguments);
    }

});
