Inprint.calendar.Main = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};

        this.panels.archive   = new Inprint.calendar.archive.Main();
        this.panels.templates = new Inprint.calendar.templates.Main();
        this.panels.fascicles = new Inprint.calendar.fascicles.Main();

        this.panels.help      = new Inprint.panels.Help({ hid: this.xtype });

        this.panels.tabs = new Ext.TabPanel({
            border:false,
            activeTab: 2,
            items:[
                this.panels.fascicles,
                this.panels.archive,
                this.panels.templates
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
                    layout:"fit",
                    border:false,
                    region: "center",
                    margins: "0 0 0 0",
                    items: this.panels.tabs
                },

                {
                    region:"east",
                    margins: "3 3 3 0",
                    width: 400,
                    minSize: 200,
                    maxSize: 600,
                    layout:"fit",
                    collapsed: true,
                    collapseMode: 'mini',
                    items: this.panels.help
                }
            ]
        });

        Inprint.calendar.Main.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.Main.superclass.onRender.apply(this, arguments);
        Inprint.calendar.Access(this, this.panels);
        Inprint.calendar.Context(this, this.panels);
        Inprint.calendar.Interaction(this, this.panels);
    },

    getRow: function() {
        return this.panels.grid.getSelectionModel().getSelected().data;
    },

    cmpReload:function() {
        this.panels.tabs.getActiveTab().cmpReload();
    }

});

Inprint.registry.register("composition-calendar", {
    icon: "calendar-day",
    text:  _("Calendar"),
    xobject: Inprint.calendar.Main
});
