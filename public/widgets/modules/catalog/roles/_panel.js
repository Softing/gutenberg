Inprint.roles.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.oid = "Inprint.roles";

        this.panels = {};

        this.panels.grid    = new Inprint.roles.Grid();
        this.panels.help    = new Inprint.roles.HelpPanel({ oid: this.oid });
        this.panels.edit    = new Inprint.roles.EditPanel();
        this.panels.access  = new Inprint.roles.RestrictionsPanel();

        this.panels.tab = new Ext.TabPanel({
            border:false,
            activeItem: 0,
            items: [ this.panels.help, this.panels.edit, this.panels.access ]
        });

        Ext.apply(this, {

            layout: "border",

            defaults: {
                collapsible: false,
                split: true
            },

            items: [
                {   region: "center",
                    margins: "3 0 3 3",
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

        Inprint.roles.Panel.superclass.initComponent.apply(this, arguments);

        Inprint.roles.Interaction(this.panels);

    },

    onRender: function() {
        Inprint.roles.Panel.superclass.onRender.apply(this, arguments);
    },

    cmpReload:function() {
        this.panels.grid.cmpReload();
    }

});
