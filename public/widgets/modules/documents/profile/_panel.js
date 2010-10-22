Inprint.documents.Profile = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};
        this.panels["view"]     = new Inprint.documents.Profile.View(this);
        this.panels["comments"] = new Inprint.documents.Profile.Comments(this);
        this.panels["files"]    = new Inprint.documents.Profile.Files(this);

        Ext.apply(this, {

            disabled: true,
            border:true,
            layout: "border",
            defaults: {
                collapsible: false,
                split: true
            },

            items: [
                {   region: "north",
                    layout:"fit",
                    split:true,
                    height:200,
                    items: this.panels["view"]
                },
                {   region: "center",
                    layout:"fit",
                    items: this.panels["files"]
                },
                {   region: "east",
                    layout:"fit",
                    split:true,
                    width:200,
                    items: this.panels["comments"]
                }

            ]
        });

        Inprint.documents.Profile.superclass.initComponent.apply(this, arguments);
        Inprint.documents.Profile.Interaction(this.panels);

    },

    onRender: function() {
        Inprint.documents.Profile.superclass.onRender.apply(this, arguments);
        this.cmpReload();
    },

    cmpReload: function() {

        this.disable();

        Ext.Ajax.request({
            url: "/documents/read/",
            scope:this,
            success: function () {
                this.enable();
            },
            failure: function () {
                this.enable();
            },
            params: { id: this.oid }
        });
    }

});
