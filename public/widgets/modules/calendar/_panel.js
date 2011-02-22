Inprint.edition.calendar.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {


        this.panels = {};

        this.panels.tree    = new Inprint.edition.calendar.Tree();
        this.panels.archive = new Inprint.edition.calendar.TreeArchive();

        this.panels.grid    = new Inprint.edition.calendar.Grid();
        this.panels.help    = new Inprint.panels.Help({ hid: this.xtype });

        Ext.apply(this, {

            layout: "border",

            defaults: {
                collapsible: false,
                split: true
            },

            items: [
                {
                    region:"west",
                    layout:'accordion',
                    width: 200,
                    minSize: 200,
                    maxSize: 600,
                    defaults: {
                        //bodyStyle: 'padding:15px',
                        //margins: "3 0 3 3"
                    },
                    layoutConfig: {
                        animate: true
                    },
                    items: [
                        this.panels.tree,
                        this.panels.archive
                    ]
                },

                {
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

        Inprint.edition.calendar.Panel.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.edition.calendar.Panel.superclass.onRender.apply(this, arguments);

        Inprint.edition.calendar.Interaction(this, this.panels);

    },

    getRow: function() {
        return this.panels.grid.getSelectionModel().getSelected().data;
    },

    cmpReload:function() {
        this.panels.tree.cmpReload();
    }

});

Inprint.registry.register("composition-calendar", {
    icon: "calendar-day",
    text:  _("Calendar"),
    xobject: Inprint.edition.calendar.Panel
});
