Inprint.calendar.issues.Main = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};
        this.panels.tree = new Inprint.calendar.issues.Tree();
        this.panels.grid = new Inprint.calendar.issues.Grid();

        Ext.apply(this, {
            border:false,
            layout: "border",
            defaults: {
                collapsible: false,
                split: true
            },
            items: [
                {
                    region:"west",
                    layout:"fit",
                    width: 200,
                    margins: "3 0 3 3",
                    items: this.panels.tree
                },
                {
                    region: "center",
                    layout:"fit",
                    margins: "3 0 3 0",
                    items: this.panels.grid
                }
            ]
        });
        Inprint.calendar.issues.Main.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.issues.Main.superclass.onRender.apply(this, arguments);
        Inprint.calendar.issues.Context(this, this.panels);
        Inprint.calendar.issues.Interaction(this, this.panels);
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
