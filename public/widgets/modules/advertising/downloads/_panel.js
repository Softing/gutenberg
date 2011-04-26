// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Inprint.advertising.downloads.Main = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {

            fascicles: new Inprint.panel.tree.Fascicles({
                parent: this,
                baseParams: {
                    term: "editions.advert.manage:*"
                }}),

            requests: new Inprint.advertising.downloads.Requests({
                disabled: true,
                parent: this }),

            summary: new Inprint.advertising.downloads.Summary({
                disabled: false,
                parent: this }),

            files: new Inprint.advertising.downloads.Files({
                disabled: true,
                parent: this }),

            comments: new Inprint.panel.Comments({
                disabled: true,
                parent: this })

        };

        this.tabs = new Ext.TabPanel({
            border:false,
            activeTab: 0,
            items:[
                this.panels.summary,
                {
                    title: _("Requests"),
                    layout: "border",
                    border:false,
                    items: [
                        {   region: "center",
                            layout:"fit",
                            //border:false,
                            //margins: "3 3 0 3",
                            items: this.panels.requests
                        },
                        {
                            region: "south",
                            layout: "border",
                            split: true,
                            height: 200,
                            border: false,
                            //margins: "0 3 3 3",
                            items: [
                                {
                                    region: "center",
                                    layout:"fit",
                                    margins: "0 0 0 0",
                                    //border:false,
                                    split:true,
                                    height:220,
                                    items: this.panels.files
                                },
                                {
                                    region:"east",
                                    width: 300,
                                    minSize: 100,
                                    maxSize: 600,
                                    split: true,
                                    layout:"fit",
                                    //border:false,
                                    margins: "0 0 0 0",
                                    items: this.panels.comments
                                }
                            ]
                        }
                    ]
                }
            ]
        });

        Ext.apply(this, {
            border:false,
            layout: "border",
            items: [
                {
                    region:"west",
                    width: 200,
                    minSize: 100,
                    maxSize: 600,
                    split: true,
                    layout:"fit",
                    margins: "3 0 3 3",
                    items: this.panels.fascicles
                },
                {
                    region: "center",
                    layout: "fit",
                    border:false,
                    margins: "3 3 3 0",
                    items: this.tabs
                }

            ]
        });

        // Call parent (required)
        Inprint.advertising.downloads.Main.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.advertising.downloads.Main.superclass.onRender.apply(this, arguments);
        Inprint.advertising.downloads.Interaction(this, this.panels);
    },

    cmpShowRequests: function(fascicle, filter) {
        this.tabs.activate(1);
        this.panels.requests.cmpLoad({ flt_fascicle:fascicle, flt_checked: filter });
    }

});

Inprint.registry.register("advert-downloads", {
    icon: "money",
    text: _("Advertizing requests"),
    description: _("Management"),
    xobject: Inprint.advertising.downloads.Main
});
