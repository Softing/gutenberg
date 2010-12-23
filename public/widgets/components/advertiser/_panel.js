Inprint.cmp.Adverta = Ext.extend(Ext.Window, {

    initComponent: function() {
        
        this.panels = {};
        
        this.panels["modules"] = new Inprint.cmp.adverta.Modules({
            parent: this
        });
        
        this.panels["templates"] = new Inprint.cmp.adverta.Templates({
            parent: this
        });
        
        this.panels["flash"]   = new Inprint.cmp.adverta.Flash({
            parent: this
        });
        
        this.panels["request"]   = new Inprint.cmp.adverta.Request({
            parent: this
        });
        
        Ext.apply(this, {
            
            border:false,
            
            modal:true,
            layout: "border",
            closeAction: "hide",
            title: _("Добавление рекламной заявки"),
            
            width: (this.selection.length*300) + 600,
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
                this.panels["request"],
                this.panels["flash"]
            ],
            buttons: [
                {
                    text: _("Add"),
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
        
        Inprint.cmp.Adverta.superclass.initComponent.apply(this, arguments);
        
    },
    
    onRender: function() {
        
        Inprint.cmp.Adverta.superclass.onRender.apply(this, arguments);
        Inprint.cmp.adverta.Interaction(this, this.panels);
        
        this.panels["request"].getForm().findField("id").setValue( this.request );
        this.panels["request"].getForm().findField("fascicle").setValue( this.fascicle );
        
    },
    
    cmpSave: function() {
        this.panels["request"].getForm().submit();
    }

});