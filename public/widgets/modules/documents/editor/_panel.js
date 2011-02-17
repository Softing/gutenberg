Inprint.documents.Editor = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.children = {};

        this.children["form"]     = new Inprint.documents.editor.FormPanel({
            parent:this,
            oid: this.oid
        });

        this.children["versions"] = new Inprint.documents.editor.Versions({
            title: _("Hot save"),
            url: _url("/documents/hotsave"),
            parent:this,
            oid: this.oid
        });

        this.children["hotsaves"] = new Inprint.documents.editor.Versions({
            title: _("Versions"),
            url: _url("/documents/versions"),
            parent:this,
            oid: this.oid
        });

        this.tabpanel = new Ext.TabPanel({
            activeTab: 0,
            border:false,
            defaults: { autoScroll: true, border:false },
            items: [
                this.children["versions"],
                this.children["hotsaves"]
            ],
            listeners: {
                "tabchange": function(tabpanel, panel) {
                    panel.cmpReload();
                }
            }
        });

        Ext.apply(this, {
            border:false,
            layout: "border",
            defaults: {
                collapsible: false,
                split: true
            },
            items: [
                {
                    region: "center",
                    layout:"fit",
                    items: this.children["form"]
                },
                {   region: "east",
                    layout:"fit",
                    split:true,
                    width:"50%",
                    items: this.tabpanel
                }
            ]
        });

        Inprint.documents.Editor.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.documents.Editor.superclass.onRender.apply(this, arguments);
        Inprint.documents.Editor.Interaction(this, this.children);
    },

    cmpReload: function() {
        if (this.children["versions"].cmpReload) { this.children["versions"].cmpReload(); }
        if (this.children["hotsaves"].cmpReload) { this.children["hotsaves"].cmpReload(); }
    }

});

Inprint.registry.register("document-editor", {
    icon: "document-word-text",
    text: _("Text editor"),
    description: _("Text editing"),
    xobject: Inprint.documents.Editor
});
