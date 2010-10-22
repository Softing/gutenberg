Inprint.documents.Profile.View = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.tbar = [
            {
                icon: _ico("pencil"),
                cls: "x-btn-text-icon",
                text: _("Edit"),
                disabled:true,
                ref: "../../btnUpdate",
                scope:this,
                handler: this.cmpUpdate
            },
            '-',
            {
                icon: _ico("hand"),
                cls: "x-btn-text-icon",
                text: _("Capture"),
                disabled:true,
                ref: "../../btnCapture",
                scope:this,
                handler: this.cmpCapture
            },
            {
                icon: _ico("arrow"),
                cls: "x-btn-text-icon",
                text: _("Transfer"),
                disabled:true,
                ref: "../../btnTransfer",
                scope:this,
                handler: this.cmpTransfer
            },
            '-',
            {
                icon: _ico("blue-folder-import"),
                cls: "x-btn-text-icon",
                text: _("Move"),
                disabled:true,
                ref: "../../btnMove",
                scope:this,
                handler: this.cmpMove
            },
            {
                icon: _ico("briefcase"),
                cls: "x-btn-text-icon",
                text: _("Briefcase"),
                disabled:true,
                ref: "../../btnBriefcase",
                scope:this,
                handler: this.cmpBriefcase
            },
            "-",
            {
                icon: _ico("document-copy"),
                cls: "x-btn-text-icon",
                text: _("Copy"),
                disabled:true,
                ref: "../../btnCopy",
                scope:this,
                handler: this.cmpCopy
            },
            {
                icon: _ico("documents"),
                cls: "x-btn-text-icon",
                text: _("Duplicate"),
                disabled:true,
                ref: "../../btnDuplicate",
                scope:this,
                handler: this.cmpDuplicate
            },
            "-",
            {
                icon: _ico("bin--plus"),
                cls: "x-btn-text-icon",
                text: _("Recycle Bin"),
                disabled:true,
                ref: "../../btnRecycle",
                scope:this,
                handler: this.cmpRecycle
            },
            {
                icon: _ico("bin--arrow"),
                cls: "x-btn-text-icon",
                text: _("Restore"),
                disabled:true,
                ref: "../../btnRestore",
                scope:this,
                handler: this.cmpRestore
            },
            {
                icon: _ico("minus-button"),
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
        Inprint.documents.Profile.View.superclass.initComponent.apply(this, arguments);
    },

    // Override other inherited methods
    onRender: function() {
        // Call parent (required)
        Inprint.documents.Profile.View.superclass.onRender.apply(this, arguments);
    }

});
