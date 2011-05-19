Inprint.documents.Profile = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.document = this.oid;

        this.panels = {};
        this.panels.profile  = new Inprint.documents.Profile.View({
            oid: this.oid,
            parent: this
        });
        this.panels.files    = new Inprint.documents.Profile.Files({
            oid: this.oid,
            parent: this
        });
        this.panels.comments = new Inprint.documents.Profile.Comments({
            oid: this.oid,
            parent: this
        });

        Ext.apply(this, {
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
                    height:220,
                    items: this.panels.profile
                },
                {   region: "center",
                    layout:"fit",
                    items: {
                        activeTab: 0,
                        border: false,
                        xtype: "tabpanel",
                        items:[
                            this.panels.files
                        ]
                    }
                },
                {   region: "east",
                    layout:"fit",
                    split:true,
                    width:400,
                    items: this.panels.comments
                }
            ]
        });

        Inprint.documents.Profile.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.documents.Profile.superclass.onRender.apply(this, arguments);
        Inprint.documents.Profile.Access(this, this.panels);
        Inprint.documents.Profile.Interaction(this, this.panels);
    },

    getValues: function() {
        return [ this.oid ];
    },

    getValue: function() {
        return this.oid;
    },

    cmpLoad: function() {

        Ext.Ajax.request({
            url: "/documents/profile/read/",
            scope:this,
            params: { id: this.oid },
            success: function(result) {
                var response = Ext.util.JSON.decode(result.responseText);
                if (response.data) {
                    this.document = response.data.id;
                    this.panels.profile.cmpFill(response.data);
                    if (response.data.access["discuss"] === true) {
                        this.panels.comments.btnSay.enable();
                    }
                }
            }
        });
        this.panels.comments.cmpLoad(this.oid);
    },

    cmpReload: function() {
        this.cmpLoad();
        this.panels.files.cmpReload(this.oid);
    }

});

Inprint.registry.register("document-profile", {
    icon: "folder-open-document",
    text: _("Document profile"),
    description: _("Document profile"),
    xobject: Inprint.documents.Profile
});
