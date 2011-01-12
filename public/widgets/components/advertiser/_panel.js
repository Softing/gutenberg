Inprint.cmp.Adverta = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.panels = {};

        this.panels["request"]   = new Inprint.cmp.adverta.Request({
            parent: this, fascicle: this.fascicle
        });

        this.items = [];

        this.items.push(this.panels["request"]);

        if ( this.selection.length == 0 ) {
            this.panels["templates"] = new Inprint.cmp.adverta.Templates({
                parent: this,
                fascicle: this.fascicle
            });
            this.items.push(this.panels["templates"]);
        }

        if ( this.selection.length > 0 ) {
            this.panels["modules"] = new Inprint.cmp.adverta.Modules({
                parent: this, fascicle: this.fascicle
            });
            this.panels["flash"]   = new Inprint.cmp.adverta.Flash({
                parent: this
            });
            this.items.push(this.panels["modules"]);
            this.items.push(this.panels["flash"]);
        }

        var winWidth = (this.selection.length*300) + 600;

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
        Inprint.cmp.Adverta.Interaction(this, this.panels);

        this.panels["request"].getForm().findField("id").setValue( this.request );
        this.panels["request"].getForm().findField("fascicle").setValue( this.fascicle );

    },

    cmpFill: function(record) {

        //var form = this.panels["request"].getForm();
        //
        //if (record.data.advertiser && record.data.advertiser_shortcut) {
        //    form.findField("advertiser").setValue(record.data.advertiser, record.data.advertiser_shortcut);
        //}
        //
        //if (record.data.shortcut) {
        //    form.findField("shortcut").setValue(record.data.shortcut);
        //}
        //
        //if (record.data.description) {
        //    form.findField("description").setValue(record.data.description);
        //}
        //
        //if (record.data.status) {
        //}
        //
        //if (record.data.squib == "yes") {
        //    form.findField("squib").setValue(true);
        //}
        //
        //if (record.data.payment) {
        //}
        //
        ////readiness
        //
        ////this.panels["modules"];
        ////this.panels["templates"];
        ////this.panels["flash"];
    },

    cmpSave: function() {

        // No pages selected
        if ( this.selection.length == 0 ) {
            this.panels["request"].getForm().baseParams = {
                template: this.panels["templates"].getValue("id")
            }
        }

        // Some pages selected
        if ( this.selection.length > 0 ) {
            this.panels["flash"].cmpSave();

            if (this.panels["modules"].panels["modules"].cmpGetSelectedNode()) {
                this.panels["request"].getForm().baseParams = {
                    module: this.panels["modules"].panels["modules"].cmpGetSelectedNode().attributes.module
                }
            }

        }

        this.panels["request"].getForm().submit();
    }

});
