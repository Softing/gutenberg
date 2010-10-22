Inprint.documents.Profile.Files = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.tbar = [
            {
                icon: _ico("document--plus"),
                cls: "x-btn-text-icon",
                text: _("Create"),
                disabled:true,
                ref: "../../btnCreate",
                scope:this,
                handler: this.cmpUpdate
            },
            {
                icon: _ico("document-globe"),
                cls: "x-btn-text-icon",
                text: _("Upload"),
                disabled:true,
                ref: "../../btnUpload",
                scope:this,
                handler: this.cmpUpload
            },
            {
                icon: _ico("document-shred"),
                cls: "x-btn-text-icon",
                text: _("Delete"),
                disabled:true,
                ref: "../../btnDelete",
                scope:this,
                handler: this.cmpDelete
            }
        ];

        Ext.apply(this, {
            border: false
        });

        // Call parent (required)
        Inprint.documents.Profile.Files.superclass.initComponent.apply(this, arguments);
    },

    // Override other inherited methods
    onRender: function() {
        // Call parent (required)
        Inprint.documents.Profile.Files.superclass.onRender.apply(this, arguments);
    }

});
