Inprint.documents.editor.Versions = Ext.extend( Ext.Panel, {

    initComponent: function() {

        this.panels = {};

        this.panels.browser = new Inprint.documents.editor.versions.Browser({
              parent:this,
              url: this.url,
              oid: this.oid
        });

        this.panels.viewer = new Inprint.documents.editor.versions.Viewer({
              parent: this,
              oid: this.oid
        });

        // Create Panel
        Ext.apply(this, {

            layout: "card",
            activeItem: 0,

            tbar:[
                {
                    icon: _ico("arrow-180"),
                    cls: "x-btn-text-icon",
                    text: _("Go back"),
                    disabled:true,
                    ref: "../btnBack",
                    scope:this,
                    handler: function() {
                        this.btnBack.disable();
                        this.btnView.enable();
                        this.layout.setActiveItem(0);
                    }
                },
                {
                    icon: _ico("eye"),
                    cls: "x-btn-text-icon",
                    text: _("View"),
                    disabled:true,
                    ref: "../btnView",
                    scope:this,
                    handler: this.cmpClick
                }
            ],

            items: [
               this.panels.browser,
               this.panels.viewer
            ]

        });

        Inprint.documents.editor.Versions.superclass.initComponent.apply(this, arguments);

    },

    cmpClick: function() {

        this.btnBack.enable();
        this.btnView.disable();
        this.layout.setActiveItem(1);

        this.panels.viewer.load({

            text: _("Loading") + "...",
            timeout: 30,

            mode: "iframe",

            url: this.url + "/read/",
            params: { version: this.panels.browser.config.selection }

        });

    },

    // Override other inherited methods
    onRender: function() {
        Inprint.documents.editor.Versions.superclass.onRender.apply(this, arguments);
    },

    cmpReload: function () {
        if (this.panels.browser.cmpReload) { this.panels.browser.cmpReload(); }
    }

});
