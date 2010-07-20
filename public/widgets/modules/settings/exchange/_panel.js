Inprint.settings.exchange.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};
        this.panels.tree = new Inprint.settings.EditionsTree();
        this.panels.grid = new Inprint.settings.exchange.Grid();
        this.panels.help = new Inprint.settings.exchange.HelpPanel({ oid: this.oid });
        this.panels.edit = new Inprint.settings.exchange.EditPanel();
        this.panels.members = new Inprint.settings.exchange.MembersPanel();

        this.panels.tabs = new Ext.TabPanel({
            border:false,
            activeItem: 0,
            items: [ this.panels.help, this.panels.edit, this.panels.members ]
        });

        Ext.apply(this, {

            layout: "border",

            defaults: {
                collapsible: false,
                split: true
            },

            items: [
                {   region:"west",
                    margins: "3 0 3 3",
                    width: 180,
                    minSize: 100,
                    maxSize: 200,
                    layout:"fit",
                    items: this.panels.tree
                },
                {   region: "center",
                    margins: "3 0 3 0",
                    layout:"fit",
                    border:false,
                    bodyStyle:"background:transparent",
                    items: this.panels.grid
                },
                {   region:"east",
                    margins: "3 3 3 0",
                    width: 380,
                    minSize: 200,
                    maxSize: 600,
                    layout:"fit",
                    items: this.panels.tabs
                }
            ]
        });

        Inprint.settings.exchange.Panel.superclass.initComponent.apply(this, arguments);
        Inprint.settings.exchange.Interaction(this.panels);
    },

    onRender: function() {
        Inprint.settings.exchange.Panel.superclass.onRender.apply(this, arguments);
    },

    cmpReload:function() {
        this.panels.grid.cmpReload();
    }

});