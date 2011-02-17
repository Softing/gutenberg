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

    cmpLoad: function () {

    }

});
