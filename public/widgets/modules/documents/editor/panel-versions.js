Inprint.documents.editor.Versions = Ext.extend( Ext.Panel, {

    initComponent: function() {

        this.children = {};

        this.children["browser"] = new Inprint.documents.editor.versions.Browser({
              parent:this,
              url: this.url,
              oid: this.oid
        });

        this.children["viewer"] = new Inprint.documents.editor.versions.Viewer({
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
                    handler: function() {

                        this.btnBack.enable();
                        this.btnView.disable();
                        this.layout.setActiveItem(1);

                        this.children["viewer"].load({

                            scripts: false,
                            nocache: true,
                            text: _("Loading") + "...",
                            timeout: 30,

                            url: this.url + "/read/",
                            params: { version: this.children["browser"].config.selection }
                        });

                    }
                }
            ],

            items: [
               this.children["browser"],
               this.children["viewer"]
            ]

        });

        Inprint.documents.editor.Versions.superclass.initComponent.apply(this, arguments);

    },

    // Override other inherited methods
    onRender: function() {
        Inprint.documents.editor.Versions.superclass.onRender.apply(this, arguments);
    },

    cmpReload: function () {
        if (this.children["browser"].cmpReload) { this.children["browser"].cmpReload(); }
    }

});
