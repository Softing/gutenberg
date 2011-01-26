Inprint.plugins.rss.control.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {


        this.panels = {};

        this.panels.tree = new Inprint.plugins.rss.control.Tree();
        this.panels.grid = new Inprint.plugins.rss.control.Grid();
        this.panels.help = new Inprint.plugins.rss.control.HelpPanel();

        Ext.apply(this, {

            layout: "border",

            defaults: {
                collapsible: false,
                split: true
            },

            items: [
                {
                    title: _("Feeds"),
                    region:"west",
                    margins: "3 0 3 3",
                    width: 200,
                    minSize: 200,
                    maxSize: 600,
                    layout:"fit",
                    items: this.panels.tree
                },
                {
                    title: _("Indexation"),
                    region: "center",
                    layout:"fit",
                    margins: "3 0 3 0",
                    items: this.panels.grid
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

        Inprint.plugins.rss.control.Panel.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.plugins.rss.control.Panel.superclass.onRender.apply(this, arguments);

        Inprint.plugins.rss.control.Access(this, this.panels);
        Inprint.plugins.rss.control.Interaction(this, this.panels);
        Inprint.plugins.rss.control.Context(this, this.panels);

    },

    getRow: function() {
        return this.panels.grid.getSelectionModel().getSelected().data;
    },

    cmpReload:function() {
        this.panels.tree.cmpReload();
    }

});

Inprint.registry.register("plugin-rss-control", {
    icon: "feed",
    text:  _("RSS feeds"),
    xobject: Inprint.plugins.rss.control.Panel
});
