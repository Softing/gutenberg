Inprint.cmp.Adverta = Ext.extend(Ext.Window, {

    initComponent: function() {

        this.panels = {};

        this.panels.request   = new Inprint.cmp.adverta.Request({
            parent: this,
            fascicle: this.fascicle
        });

        this.items = [];

        this.items.push(this.panels.request);

        if ( this.selection.length === 0 ) {
            this.panels.templates = new Inprint.cmp.adverta.Templates({
                parent: this,
                fascicle: this.fascicle
            });
            this.items.push(this.panels.templates);
        }

        if ( this.selection.length > 0 ) {
            this.panels.modules = new Inprint.cmp.adverta.Modules({
                parent: this, fascicle: this.fascicle
            });
            this.panels.flash   = new Inprint.cmp.adverta.Flash({
                parent: this
            });
            this.items.push(this.panels.modules);
            this.items.push(this.panels.flash);
        }

        var winWidth = 600 + (this.selection.length*260);

        var title;
        var btn;
        if (this.mode == "create") {
            title = _("Добавление рекламной заявки");
            btn = _("Add");
        }

        if (this.mode == "update") {
            title = _("Редактирование заявки");
            btn = _("Save");
        }

        Ext.apply(this, {

            border:false,

            modal:true,
            closeAction: "hide",
            title: title,

            width: winWidth,
            height:600,

            layout:'hbox',
            layoutConfig: {
                align : 'stretch',
                pack  : 'start'
            },

            buttons: [
                {
                    text: btn,
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

        this.panels.request.getForm().findField("id").setValue( this.request );
        this.panels.request.getForm().findField("fascicle").setValue( this.fascicle );

    },

    cmpFill: function(record) {

        var form = this.panels.request.getForm();

        if (this.panels.modules) {
            var modules = this.panels.modules.panels.modules;
            if (record.data.module) {
                if(modules.getNodeById(record.data.module)) {
                    modules.getNodeById(record.data.module).select();
                }
            }
        }

        if (record.data.id) {
            form.findField("id").setValue(record.data.id);
        }

        if (record.data.advertiser && record.data.advertiser_shortcut) {
            form.findField("advertiser").setValue(record.data.advertiser, record.data.advertiser_shortcut);
        }

        if (record.data.shortcut) {
            form.findField("shortcut").setValue(record.data.shortcut);
        }

        if (record.data.description) {
            form.findField("description").setValue(record.data.description);
        }

        if (record.data.status) {
            form.findField("status").setValue(record.data.status);
        }

        if (record.data.squib) {
            form.findField("squib").setValue(record.data.squib);
        }

        if (record.data.payment) {
            form.findField("payment").setValue(record.data.payment);
        }

        if (record.data.readiness) {
            form.findField("approved").setValue(record.data.readiness);
        }

    },

    cmpSave: function() {

        var form = this.panels.request.getForm();

        // No pages selected
        if ( this.selection.length === 0 ) {
            form.baseParams = {
                template: this.panels.templates.cmpGetValue()
            };
        }

        // Some pages selected
        if ( this.selection.length > 0 ) {
            this.panels.flash.cmpSave();

            if (this.panels.modules.panels.modules.cmpGetSelectedNode()) {
                form.baseParams = {
                    module: this.panels.modules.panels.modules.cmpGetSelectedNode().attributes.module
                };
            }

        }

        if ( this.mode == "create") {
            form.url = _url("/fascicle/requests/create/");
        }

        if ( this.mode == "update") {
            form.url = _url("/fascicle/requests/update/");
        }

        form.submit();
    }

});
