Inprint.edition.calendar.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};

        this.panels.tree = new Inprint.edition.calendar.Tree();
        this.panels.grid = new Inprint.edition.calendar.Grid();
        this.panels.help = new Inprint.edition.calendar.HelpPanel();

        Ext.apply(this, {

            layout: "border",

            defaults: {
                collapsible: false,
                split: true
            },

            items: [
                {
                    title: _("Fascicles"),
                    region: "center",
                    layout:"fit",
                    margins: "3 0 3 0",
                    items: this.panels.grid
                },
                {
                    title: _("Editions"),
                    region:"west",
                    margins: "3 0 3 3",
                    width: 200,
                    minSize: 200,
                    maxSize: 600,
                    layout:"fit",
                    items: this.panels.tree
                },
                {
                    region:"east",
                    margins: "3 3 3 0",
                    width: 400,
                    minSize: 200,
                    maxSize: 600,
                    layout:"fit",
                    collapseMode: 'mini',
                    items: this.panels.help
                }
            ]
        });

        Inprint.edition.calendar.Panel.superclass.initComponent.apply(this, arguments);
        Inprint.edition.calendar.Interaction(this.panels);
    },

    onRender: function() {
        Inprint.edition.calendar.Panel.superclass.onRender.apply(this, arguments);
    },

    getRow: function() {
        return this.panels.grid.getSelectionModel().getSelected().data;
    },

    cmpReload:function() {
        this.panels.grid.cmpReload();
    }

});
