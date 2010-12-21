Inprint.cmp.Composer = Ext.extend(Ext.Window, {

    initComponent: function() {
        
        this.panels = {};
        
        this.selLength = this.selection.length;
        
        this.panels["modules"] = new Inprint.cmp.composer.Modules({
            parent: this
        });
        
        this.panels["templates"] = new Inprint.cmp.composer.GridTemplates({
            parent: this
        });
        
        this.panels["flash"]   = new Inprint.cmp.composer.Flash({
            parent: this
        });
        
        Ext.apply(this, {
            
            border:false,
            
            modal:true,
            layout: "border",
            closeAction: "hide",
            title: _("Разметка полос"),
            
            width: (this.selLength*300) + 400,
            height:450,
            
            defaults: {
                collapsible: false,
                split: true
            },
            
            items: [
                {
                    border:false,
                    region: "center",
                    layout: "border",
                    defaults: {
                        collapsible: false,
                        split: true
                    },
                    items: [
                        this.panels["modules"],
                        this.panels["templates"]
                    ]
                },
                this.panels["flash"]
            ],
            buttons: [
                {
                    text: _("Save"),
                    scope:this,
                    handler: this.cmpSave
                },
                {
                    text: _("Close"),
                    scope:this,
                    handler: function() {
                        this.hide();
                    }
                }
            ]
            
        });
        
        Inprint.cmp.Composer.superclass.initComponent.apply(this, arguments);
        
    },
    
    onRender: function() {
        Inprint.cmp.Composer.superclass.onRender.apply(this, arguments);
        Inprint.cmp.composer.Interaction(this, this.panels);
    },
    
    cmpSave: function() {
        this.panels["flash"].cmpSave();
    }

});