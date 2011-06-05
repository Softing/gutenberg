Inprint.catalog.indexes.Panel = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.access = {};

        this.panels = {
            editions: new Inprint.panel.tree.Editions({
                parent: this
            }),
            headlines: new Inprint.catalog.indexes.TreeHeadlines({
                parent: this
            }),
            rubrics: new Inprint.catalog.indexes.Rubrics({
                parent: this
            }),
            help: new Inprint.panels.Help({
                hid: this.xtype
            })
        };

        Ext.apply(this, {
            layout: "border",
            defaults: {
                collapsible: false,
                split: true
            },
            items: [
                {
                    region: "center",
                    border:false,
                    layout: "hbox",
                    margins: "3 0 3 0",
                    layoutConfig: {
                        align : 'stretch',
                        pack  : 'start'
                    },
                    items: [
                        {
                            flex:1,
                            layout:"fit",
                            margins: "0 1 0 0",
                            width: 200,
                            collapsible: false,
                            split: true,
                            items: this.panels.headlines
                        },
                        {
                            flex:2,
                            layout:"fit",
                            margins: "0 0 0 1",
                            items: this.panels.rubrics
                        }
                    ]
                },
                {
                    region:"west",
                    margins: "3 0 3 3",
                    width: 200,
                    minSize: 200,
                    maxSize: 600,
                    layout:"fit",
                    items: this.panels.editions
                },
                {
                    region:"east",
                    margins: "3 3 3 0",
                    width: 400,
                    minSize: 200,
                    maxSize: 600,
                    collapseMode: 'mini',
                    layout:"fit",
                    items: this.panels.help
                }
            ]
        });

        Inprint.catalog.indexes.Panel.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.catalog.indexes.Panel.superclass.onRender.apply(this, arguments);
        Inprint.catalog.indexes.Interaction(this, this.panels);
    },

    cmpReload: function() {
        if ( this.panels.rubrics.disabled === false ) {
            this.panels.rubrics.cmpReload();
        }
    }

});

Inprint.registry.register("settings-index", {
    icon: "marker",
    text: _("Index"),
    xobject: Inprint.catalog.indexes.Panel
});
