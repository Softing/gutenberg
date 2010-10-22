Inprint.documents.Profile.Comments = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.tbar = [
            {
                icon: _ico("balloon-white"),
                cls: "x-btn-text-icon",
                text: _("Say"),
                disabled:true,
                ref: "../../btnSay",
                scope:this,
                handler: this.cmpSay
            }
        ];

        Ext.apply(this, {
            border: false
        });
        // Call parent (required)
        Inprint.documents.Profile.Comments.superclass.initComponent.apply(this, arguments);
    },

    // Override other inherited methods
    onRender: function() {
        // Call parent (required)
        Inprint.documents.Profile.Comments.superclass.onRender.apply(this, arguments);
    },

    cmpSay: function() {
        alert("say");
    }

});
