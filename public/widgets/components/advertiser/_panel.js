Inprint.cmp.Adverta = Ext.extend(Ext.Window, {

    initComponent: function() {
        
        this.panels = {};
        
        this.panels["request"]   = new Inprint.cmp.adverta.Request({
            parent: this, fascicle: this.fascicle
        });
        
        this.panels["modules"] = new Inprint.cmp.adverta.Modules({
            parent: this, fascicle: this.fascicle
        });
        
        this.panels["templates"] = new Inprint.cmp.adverta.Templates({
            parent: this, fascicle: this.fascicle
        });
        
        this.panels["flash"]   = new Inprint.cmp.adverta.Flash({
            parent: this
        });
        
        this.items = [];
        
        this.items.push(this.panels["request"]);
        
        if ( this.selection.length == 0 ) {
            this.items.push(this.panels["templates"]);
        }
        
        if ( this.selection.length > 0 ) {
            this.items.push(this.panels["modules"]);
            this.items.push(this.panels["flash"]);
        }
        
        var winWidth = (this.selection.length*300) + 500;
        
        Ext.apply(this, {
            
            border:false,
            
            modal:true,
            closeAction: "hide",
            title: _("Добавление рекламной заявки"),
            
            width: winWidth,
            height:450,
            
            layout:'hbox',
            layoutConfig: {
                align : 'stretch',
                pack  : 'start'
            },
            
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
        
        this.panels["request"].getForm().on("actioncomplete", function(form, action){
            if (action.type == "submit") {
                this.hide();
                this.fireEvent("actioncomplete");
            }
        }, this);
    },
    
    cmpSave: function() {
        
        if ( this.selection.length == 0 ) {
            this.panels["request"].getForm().baseParams = {
                template: this.panels["templates"].getValue("id")
            }
        }
        
        this.panels["request"].getForm().submit();
    }

});