Inprint.catalog.indexes.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};
        this.panels["editions"]  = new Inprint.catalog.indexes.TreeEditions();
        this.panels["headlines"] = new Inprint.catalog.indexes.TreeHeadlines();
        this.panels["rubrics"]   = new Inprint.catalog.indexes.Rubrics();

        Ext.apply(this, {
            border:false,
            layout: "hbox",
            layoutConfig: {
                align : 'stretch',
                pack  : 'start'
            },
            items: [
                {
                    flex:1,
                    layout:"fit",
                    margins: "0 0 0 0",
                    width: 130,
                    collapsible: false,
                    split: true,
                    items: this.panels["editions"]
                },
                {
                    flex:2,
                    layout:"fit",
                    margins: "0 3 0 3",
                    width: 200,
                    collapsible: false,
                    split: true,
                    items: this.panels["headlines"]
                },
                {
                    flex:3,
                    layout:"fit",
                    margins: "0 0 0 0",
                    items: this.panels["rubrics"]
                }
            ]
        });
        Inprint.catalog.indexes.Panel.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.catalog.indexes.Panel.superclass.onRender.apply(this, arguments);
        Inprint.catalog.indexes.Interaction(this, this.panels);
    }

});

Inprint.registry.register("settings-indexes", {
    icon: "marker",
    text: _("Index"),
    xobject: Inprint.catalog.indexes.Panel
});