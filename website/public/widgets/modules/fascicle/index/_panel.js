Inprint.fascicle.indexes.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.access = {};

        this.fascicle = this.oid;
        this.headline = null;
        
        this.panels = {};

        this.panels.headlines = new Inprint.fascicle.indexes.TreeHeadlines({
            parent: this
        });
        this.panels.rubrics   = new Inprint.fascicle.indexes.Rubrics({
            parent: this
        });

        Ext.apply(this, {
            layout: "border",
            defaults: {
                collapsible: false,
                split: true
            },
            items: [
                {
                    region:"west",
                    margins: "3 0 3 3",
                    layout:"fit",
                    width: 200,
                    minSize: 100,
                    maxSize: 600,
                    items: this.panels.headlines
                },
                {
                    region: "center",
                    layout:"fit",
                    margins: "3 0 3 0",
                    items: this.panels.rubrics
                }
            ]
        });
        Inprint.fascicle.indexes.Panel.superclass.initComponent.apply(this, arguments);
        
    },

    onRender: function() {
        
        Inprint.fascicle.indexes.Panel.superclass.onRender.apply(this, arguments);
        
        Inprint.fascicle.indexes.Access(this, this.panels);
        Inprint.fascicle.indexes.Context(this, this.panels);
        Inprint.fascicle.indexes.Interaction(this, this.panels);
    }

});

Inprint.registry.register("fascicle-index", {
    icon: "marker",
    text: _("Fascicle index"),
    xobject: Inprint.fascicle.indexes.Panel
});

Inprint.registry.register("briefcase-index", {
    icon: "briefcase",
    text: _("Briefcase index"),
    xobject: Inprint.fascicle.indexes.Panel
});