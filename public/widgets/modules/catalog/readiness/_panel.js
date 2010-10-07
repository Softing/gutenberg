Inprint.catalog.readiness.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};

        this.panels.grid = new Inprint.catalog.readiness.Grid();
        this.panels.help = new Inprint.catalog.readiness.HelpPanel();
        this.panels.edit = new Inprint.catalog.readiness.UpdateForm();

        this.panels.tab = new Ext.TabPanel({
            border:false,
            activeItem: 0,
            items: [
                this.panels.help,
                this.panels.edit
            ]
        });

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
                    border:false,
                    items: this.panels.grid
                },
                {
                    region:"east",
                    margins: "3 3 3 0",
                    width: 400,
                    minSize: 200,
                    maxSize: 600,
                    collapseMode: 'mini',
                    layout:"fit",
                    items: this.panels.tab
                }
            ]
        });

        Inprint.catalog.readiness.Panel.superclass.initComponent.apply(this, arguments);
        Inprint.catalog.readiness.Interaction(this.panels);
    },

    onRender: function() {
        Inprint.catalog.readiness.Panel.superclass.onRender.apply(this, arguments);
    },

    getRow: function() {
        return this.panels.grid.getSelectionModel().getSelected().data;
    },

    cmpReload:function() {
        this.panels.grid.cmpReload();
    }

});
