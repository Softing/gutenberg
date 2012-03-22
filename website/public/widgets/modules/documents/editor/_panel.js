Inprint.documents.Editor = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.panels = {};

        //this.panels.form     = new Inprint.documents.editor.FormPanel({
        //    parent: this,
        //    file: this.oid,
        //    document: this.pid
        //});

        this.panels.form     = new Inprint.documents.editor.FormTinyMce({
            parent: this,
            file: this.oid,
            document: this.pid
        });

        this.panels.versions = new Inprint.documents.editor.Versions({
            title: _("Hot save"),
            url: _url("/documents/hotsave"),
            parent:this,
            oid: this.oid
        });

        this.panels.hotsaves = new Inprint.documents.editor.Versions({
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
                this.panels.versions,
                this.panels.hotsaves
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
                    items: this.panels.form
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
        Inprint.documents.Editor.Interaction(this, this.panels);
    },

    cmpReload: function() {
        if (this.panels.versions.cmpReload) { this.panels.versions.cmpReload(); }
        if (this.panels.hotsaves.cmpReload) { this.panels.hotsaves.cmpReload(); }
    }

});

Inprint.registry.register("document-editor", {
    icon: "document-word-text",
    text: _("Text editor"),
    description: _("Text editor"),
    xobject: Inprint.documents.Editor
});
