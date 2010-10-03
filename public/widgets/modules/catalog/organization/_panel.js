Inprint.catalog.organization.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};

        this.panels.tree = new Inprint.catalog.organization.Tree();
        this.panels.grid = new Inprint.catalog.organization.Grid({
            title: _("Members")
        });
        this.panels.help = new Inprint.catalog.organization.HelpPanel();

        this.panels.profile = new Inprint.member.Profile();
        this.panels.edit    = new Inprint.member.profile.Form();
        this.panels.access  = new Inprint.member.profile.Access();

        this.panels.tab = new Ext.TabPanel({
            border:false,
            activeItem: 0,
            items: [
                this.panels.help,
                this.panels.profile,
                this.panels.edit,
                this.panels.access
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
                    collapseMode: 'mini',
                    layout:"fit",
                    items: this.panels.tab
                }
            ]
        });

        Inprint.catalog.organization.Panel.superclass.initComponent.apply(this, arguments);
        Inprint.catalog.organization.Interaction(this.panels);
    },

    onRender: function() {
        Inprint.catalog.organization.Panel.superclass.onRender.apply(this, arguments);
    },

    getRow: function() {
        return this.panels.grid.getSelectionModel().getSelected().data;
    },

    cmpReload:function() {
        this.panels.grid.cmpReload();
    }

});
