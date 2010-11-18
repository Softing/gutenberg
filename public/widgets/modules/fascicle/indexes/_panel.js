Inprint.fascicle.indexes.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {
        
        this.panels = {};
        this.panels["headlines"] = new Inprint.fascicle.indexes.TreeHeadlines({
            oid: this.oid
        });
        this.panels["rubrics"]   = new Inprint.fascicle.indexes.Rubrics({
            oid: this.oid
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
                    flex:2,
                    layout:"fit",
                    margins: "0 3 0 0",
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
        Inprint.fascicle.indexes.Panel.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.fascicle.indexes.Panel.superclass.onRender.apply(this, arguments);
        Inprint.fascicle.indexes.Interaction(this, this.panels);
    }

});

Inprint.registry.register("fascicle-indexes", {
    icon: "marker",
    text: _("Index"),
    xobject: Inprint.fascicle.indexes.Panel
});