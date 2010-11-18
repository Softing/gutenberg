Inprint.catalog.readiness.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};

        this.panels.grid = new Inprint.catalog.readiness.Grid();
        this.panels.help = new Inprint.catalog.readiness.HelpPanel();

        Ext.apply(this, {
            layout: "border",
            defaults: {
                collapsible: false,
                split: true
            },
            items: [
                {
                    layout:"fit",
                    region: "center",
                    margins: "3 0 3 3",
                    items: this.panels.grid
                },
                {
                    layout:"fit",
                    region:"east",
                    margins: "3 3 3 0",
                    width: 400,
                    minSize: 200,
                    maxSize: 600,
                    collapseMode: 'mini',
                    items: this.panels.help
                }
            ]
        });

        Inprint.catalog.readiness.Panel.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.catalog.readiness.Panel.superclass.onRender.apply(this, arguments);
        
        Inprint.catalog.readiness.Access(this, this.panels);
        Inprint.catalog.readiness.Interaction(this, this.panels);
    },

    getRow: function() {
        return this.panels.grid.getSelectionModel().getSelected().data;
    },

    cmpReload:function() {
        this.panels.grid.cmpReload();
    }

});

Inprint.registry.register("settings-readiness", {
    icon: "category",
    text: _("Readiness"),
    xobject: Inprint.catalog.readiness.Panel
});