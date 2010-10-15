Inprint.membersBrowser.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {
            tree: new Inprint.catalog.Tree(),
            view: new Inprint.membersBrowser.PrincipalsView()
        };

        Ext.apply(this, {

            layout: "border",

            defaults: {
                collapsible: false,
                split: true
            },

            items: [
                {   title: _("Employees"),
                    region: "center",
                    margins: "3 0 3 0",
                    layout:"fit",
                    bodyStyle:"background:transparent",
                    items: this.panels.view
                },
                {   title:_("Catalog"),
                    region:"west",
                    margins: "3 0 3 3",
                    width: 200,
                    minSize: 100,
                    maxSize: 400,
                    layout:"fit",
                    items: this.panels.tree
                }
            ]
        });

        Inprint.membersBrowser.Panel.superclass.initComponent.apply(this, arguments);

        Inprint.membersBrowser.Interaction(this.panels);
    },

    onRender: function() {
        Inprint.membersBrowser.Panel.superclass.onRender.apply(this, arguments);
    },

    cmpReload:function() {

    }

});

Inprint.membersBrowser.Window = function(config) {

    var mywindow = new Ext.Window({
        title: _("Employees browser"),
        layout: "fit",
        width:800, height:400,
        items: new Inprint.membersBrowser.Panel(config)
    });

    mywindow.show();

}
