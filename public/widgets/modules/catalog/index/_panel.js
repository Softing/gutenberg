Inprint.catalog.indexes.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.access = {};

        this.edition  = null;
        this.headline = null;
        
        this.panels = {};
        this.panels["editions"]  = new Inprint.catalog.indexes.TreeEditions({
            parent: this
        });
        this.panels["headlines"] = new Inprint.catalog.indexes.TreeHeadlines({
            parent: this
        });
        this.panels["rubrics"]   = new Inprint.catalog.indexes.Rubrics({
            parent: this
        });

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
                    margins: "3 0 3 3",
                    width: 130,
                    collapsible: false,
                    split: true,
                    items: this.panels["editions"]
                },
                {
                    flex:2,
                    layout:"fit",
                    margins: "3 3 3 3",
                    width: 200,
                    collapsible: false,
                    split: true,
                    items: this.panels["headlines"]
                },
                {
                    flex:3,
                    layout:"fit",
                    margins: "3 3 3 0",
                    items: this.panels["rubrics"]
                }
            ]
        });
        Inprint.catalog.indexes.Panel.superclass.initComponent.apply(this, arguments);
        
    },

    onRender: function() {
        
        Inprint.catalog.indexes.Panel.superclass.onRender.apply(this, arguments);
        
        Inprint.catalog.indexes.Access(this, this.panels);
        Inprint.catalog.indexes.Context(this, this.panels);
        Inprint.catalog.indexes.Interaction(this, this.panels);
    }

});

Inprint.registry.register("settings-index", {
    icon: "marker",
    text: _("Index"),
    xobject: Inprint.catalog.indexes.Panel
});
