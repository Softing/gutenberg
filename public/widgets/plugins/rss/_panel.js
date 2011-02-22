Inprint.plugins.rss.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {
        this.panels = {
            grid: new Inprint.plugins.rss.Grid({
                parent:this,
                oid: this.oid
            }),
            profile: new Inprint.plugins.rss.Profile({
                parent:this,
                oid: this.oid
            })
        }
        Ext.apply(this, {
            border:true,
            layout: "border",
            defaults: {
                collapsible: false,
                split: true
            },
            items: [
                {   region: "center",
                    layout:"fit",
                    items: this.panels["grid"]
                },
                {   region: "south",
                    layout:"fit",
                    split:true,
                    height:354,
                    items: this.panels["profile"]
                }
            ]
        });
        Inprint.plugins.rss.Panel.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.plugins.rss.Panel.superclass.onRender.apply(this, arguments);
        Inprint.plugins.rss.Access(this, this.panels);
        Inprint.plugins.rss.Interaction(this, this.panels);
    },

    cmpReload: function() {
        this.panels["grid"].cmpReload();
    }

});

Inprint.registry.register("plugin-rss", {
    icon: "feed",
    text:  _("RSS feeds"),
    xobject: Inprint.plugins.rss.Panel
});
