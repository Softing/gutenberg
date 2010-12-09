Inprint.documents.Editor = Ext.extend(Ext.Panel, {

    initComponent: function() {
        
        this.panels = {};
        
        this.panels["form"]     = new Inprint.documents.Editor.FormPanel({
            parent:this,
            oid: this.oid
        });
        
        this.panels["versions"] = new Inprint.documents.Editor.Versions({
            parent:this,
            oid: this.oid
        });

        this.charCounter = new Ext.Toolbar.TextItem('Знаков: 0');

        this.bbar = {
            xtype: "statusbar",
            statusAlign : 'right',
            items : [
                {
                    ref: "../btnSave",
                    disabled:true,
                    scope : this,
                    text : '<b>Сохранить текст</b>',
                    cls : 'x-btn-text-icon',
                    icon: _ico("disk-black"),
                    scope:this,
                    handler : function() {
                        this.panels["form"].getForm().submit();
                    }
                },
                '->',
                this.charCounter
            ]
        };

        Ext.apply(this, {
            border:true,
            layout: "border",
            defaults: {
                collapsible: false,
                split: true
            },
            items: [
                {
                    region: "center",
                    layout:"fit",
                    items: this.panels["form"]
                },
                {   region: "east",
                    layout:"fit",
                    split:true,
                    width:"50%",
                    items: this.panels["versions"]
                }
            ]
        });

        Inprint.documents.Editor.superclass.initComponent.apply(this, arguments);
        
    },

    onRender: function() {
        Inprint.documents.Editor.superclass.onRender.apply(this, arguments);
        Inprint.documents.Editor.Interaction(this, this.panels);
    }

});

Inprint.registry.register("document-editor", {
    icon: "document-word-text",
    text: _("Text editor"),
    description: _("Text editing"),
    xobject: Inprint.documents.Editor
});

