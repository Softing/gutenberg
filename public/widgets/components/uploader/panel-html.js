Inprint.cmp.uploader.Html = Ext.extend(Ext.FormPanel, {

    initComponent: function() {

        this.addEvents( 'fileUploaded' );

        Ext.apply(this, {
            border:false,
            title: _("Html mode"),
            fileUpload: true,
            autoHeight: true,
            bodyStyle: 'padding: 10px 10px 0 10px;',
            labelWidth: 50,
            defaults: {
                anchor: '100%',
                allowBlank: true,
                msgTarget: 'side'
            },
            items: [
                {
                    xtype: "hidden",
                    name: "document",
                    value: this.config.document
                },
                {
                    xtype: "fileuploadfield",
                    emptyText: _("Select an file"),
                    fieldLabel: _("File") + " 1",
                    name: "file1",
                    buttonText: _("Select"),
                    buttonCfg: {
                        width: 100
                    }
                },
                {
                    xtype: "fileuploadfield",
                    emptyText: _("Select an file"),
                    fieldLabel: _("File") + " 2",
                    name: "file2",
                    buttonText: _("Select"),
                    buttonCfg: {
                        width: 100
                    }
                },
                {
                    xtype: "fileuploadfield",
                    emptyText: _("Select an file"),
                    fieldLabel: _("File") + " 3",
                    name: "file3",
                    buttonText: _("Select"),
                    buttonCfg: {
                        width: 100
                    }
                },
                {
                    xtype: "fileuploadfield",
                    emptyText: _("Select an file"),
                    fieldLabel: _("File") + " 4",
                    name: "file4",
                    buttonText: _("Select"),
                    buttonCfg: {
                        width: 100
                    }
                },
                {
                    xtype: "fileuploadfield",
                    emptyText: _("Select an file"),
                    fieldLabel: _("File") + " 5",
                    name: "file5",
                    buttonText: _("Select"),
                    buttonCfg: {
                        width: 100
                    }
                }
            ],
            listeners: {
                actioncomplete: function() {
                    this.fireEvent('fileUploaded', this);
                },
                actionfailed: function() {

                }
            },
            buttons: [
                {
                    text: _("Save"),
                    scope:this,
                    handler: function(){
                        this.getForm().submit();
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
