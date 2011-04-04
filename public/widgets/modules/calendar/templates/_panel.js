Inprint.calendar.templates.Main = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};
        this.panels.tree = new Inprint.calendar.templates.Tree();
        this.panels.grid = new Inprint.calendar.templates.Grid();

        Ext.apply(this, {
            border:false,
            title: _("Templates"),
            layout: "border",
            defaults: {
                collapsible: false,
                split: true
            },
            items: [
                {
                    region: "center",
                    layout:"fit",
                    border:false,
                    margins: "3 3 3 0",
                    items: this.panels.grid
                },
                {
                    region:"west",
                    layout:"fit",
                    border:false,
                    margins: "3 0 3 3",
                    width: 200,
                    items: this.panels.tree
                }
            ]
        });
        Inprint.calendar.templates.Main.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.templates.Main.superclass.onRender.apply(this, arguments);
        Inprint.calendar.templates.Context(this, this.panels);
        Inprint.calendar.templates.Interaction(this, this.panels);
    },

    cmpGetTree: function() {
        return this.panels.tree;
    },

    cmpGetGrid: function() {
        return this.panels.grid;
    },

    cmpReload: function() {
        this.panels.grid.cmpReload();
    }

});
