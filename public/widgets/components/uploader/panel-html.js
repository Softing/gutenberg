Inprint.cmp.uploader.Html = Ext.extend(Ext.FormPanel, {

    initComponent: function() {

        this.addEvents( 'fileUploaded' );

        this.items = [];

        if(this.config.pkey) {
            this.items.push({
                xtype: "hidden",
                name: "pkey",
                value: this.config.pkey
            });
        }

        if (this.config.document) {
            this.items.push({
                xtype: "hidden",
                name: "document",
                value: this.config.document
            });
        }

        this.items.push({
            xtype: "fileuploadfield",
            emptyText: _("Select an file"),
            fieldLabel: _("File") + " 1",
            name: "file",
            buttonText: _("Select"),
            buttonCfg: {
                width: 100
            }
        });

        Ext.apply(this, {
            border:false,
            title: _("Html mode"),
            //fileUpload: true,
            autoHeight: true,
            bodyStyle: 'padding: 10px 10px 0 10px;',
            labelWidth: 50,
            defaults: {
                anchor: '100%',
                allowBlank: true,
                msgTarget: 'side'
            },
            buttons: [
                {
                    text: _("Save"),
                    scope:this,
                    handler: function(){
                        this.getForm().submit({
                            submitEmptyText: false
                        });
                    }
                },{
                    text: _("Reset"),
                    scope:this,
                    handler: function(){
                        this.getForm().reset();
                    }
                }
            ]
        });

        Inprint.cmp.uploader.Html.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.uploader.Html.superclass.onRender.apply(this, arguments);
        this.getForm().url = this.config.uploadUrl;
    }

});
