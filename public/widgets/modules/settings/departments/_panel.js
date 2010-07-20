Inprint.settings.departments.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.oid = "Inprint.settings.departments";

        this.panels = {};
        this.panels.tree = new Inprint.settings.EditionsTree();
        this.panels.grid = new Inprint.settings.departments.Grid();
        this.panels.help = new Inprint.settings.departments.HelpPanel({ oid: this.oid });
        this.panels.edit = new Inprint.settings.departments.EditPanel();
        this.panels.members = new Inprint.settings.departments.MembersPanel();

        this.panels.tab = new Ext.TabPanel({
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
                    width: 120,
                    minSize: 100,
                    maxSize: 200,
                    layout:"fit",
                    items: this.panels.tree
                },
                {   region: "center",
                    margins: "3 0 3 0",
                    layout:"fit",
                    items: this.panels.grid
                },
                {   region:"east",
                    margins: "3 3 3 0",
                    width: 380,
                    minSize: 200,
                    maxSize: 600,
                    layout:"fit",
                    items: this.panels.tab
                }
            ]
        });

        Inprint.settings.departments.Panel.superclass.initComponent.apply(this, arguments);

        Inprint.settings.departments.Interaction(this.panels);

    },

    onRender: function() {
        Inprint.settings.departments.Panel.superclass.onRender.apply(this, arguments);
    },

    cmpReload:function() {
        this.panels.grid.cmpReload();
    }

});