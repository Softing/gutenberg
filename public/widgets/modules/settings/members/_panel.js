Inprint.settings.members.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.oid = "Inprint.settings.members";
        this.panels = {};

        this.panels.members  = new Inprint.settings.members.MembersGrid();
        this.panels.accounts = new Inprint.settings.members.AccountsGrid();

        this.panels.help     = new Inprint.settings.members.HelpPanel();
        this.panels.groups   = new Inprint.settings.members.DepartmentsPanel();
        this.panels.usercard = new Inprint.settings.members.UsercardPanel();
        this.panels.access   = new Inprint.settings.members.RestrictionsPanel();

        this.panels.tab = new Ext.TabPanel({
            border:false,
            activeItem: 0,
            items: [ this.panels.help, this.panels.usercard, this.panels.groups, this.panels.access ],
            listeners: {
                scope:this,
                tabchange: function(tabpanel, panel){
//                    if (panel.cmpFill)
//                        panel.cmpFill();
                }
            }
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
                    width: 220,
                    minSize: 100,
                    maxSize: 400,

                    layout:"fit",

                    items: this.panels.members
                },
                {   region: "center",
                    margins: "3 0 3 0",
                    layout:"fit",
                    items: this.panels.accounts
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

        Inprint.settings.members.Panel.superclass.initComponent.apply(this, arguments);

        Inprint.settings.members.Interaction(this.panels);
    },

    onRender: function() {
        Inprint.settings.members.Panel.superclass.onRender.apply(this, arguments);
    },

    getRow: function() {
        return this.panels.grid.getSelectionModel().getSelected().data;
    },

    cmpReload:function() {
        this.panels.grid.cmpReload();
    }

});