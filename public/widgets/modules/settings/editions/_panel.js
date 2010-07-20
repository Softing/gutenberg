Inprint.settings.editions.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};

        this.panels.grid = new Inprint.settings.editions.Grid();
        this.panels.help = new Inprint.settings.editions.HelpPanel();
        this.panels.edit = new Inprint.settings.editions.EditPanel();
        
        this.panels.tab = new Ext.TabPanel({
            border:false,
            activeItem: 0,
            items: [ this.panels.help, this.panels.edit ],
            listeners: {
                scope:this,
                tabchange: function(tabpanel, panel){
                    if (panel.cmpFill)
                        panel.cmpFill();
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
                {
                    region: "center",
                    margins: "3 0 3 3",
                    layout:"fit",
                    items: this.panels.grid
                },
                {
                    region:"east",
                    margins: "3 3 3 0",
            
                    width: 300,
                    minSize: 200,
                    maxSize: 600,
            
                    layout:"fit",
            
                    items: this.panels.tab
                }
            ]
        });

        Inprint.settings.editions.Panel.superclass.initComponent.apply(this, arguments);
        Inprint.settings.editions.Interaction(this.panels);
    },

    onRender: function() {
        Inprint.settings.editions.Panel.superclass.onRender.apply(this, arguments);
    },

    getRow: function() {
        return this.panels.grid.getSelectionModel().getSelected().data;
    },

    cmpReload:function() {
        this.panels.grid.cmpReload();
    }

});