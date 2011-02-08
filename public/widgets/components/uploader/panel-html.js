Inprint.cmp.uploader.Html = Ext.extend(Ext.FormPanel, {

    initComponent: function() {

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
                    xtype: "fileuploadfield",
                    emptyText: _("Select an file"),
                    fieldLabel: _("File") + " 1",
                    name: "file-1",
                    buttonText: _("Select"),
                    buttonCfg: {
                        width: 100
                    }
                },
                {
                    xtype: "fileuploadfield",
                    emptyText: _("Select an file"),
                    fieldLabel: _("File") + " 2",
                    name: "file-2",
                    buttonText: _("Select"),
                    buttonCfg: {
                        width: 100
                    }
                },
                {
                    xtype: "fileuploadfield",
                    emptyText: _("Select an file"),
                    fieldLabel: _("File") + " 3",
                    name: "file-3",
                    buttonText: _("Select"),
                    buttonCfg: {
                        width: 100
                    }
                },
                {
                    xtype: "fileuploadfield",
                    emptyText: _("Select an file"),
                    fieldLabel: _("File") + " 4",
                    name: "file-4",
                    buttonText: _("Select"),
                    buttonCfg: {
                        width: 100
                    }
                },
                {
                    xtype: "fileuploadfield",
                    emptyText: _("Select an file"),
                    fieldLabel: _("File") + " 5",
                    name: "file-5",
                    buttonText: _("Select"),
                    buttonCfg: {
                        width: 100
                    }
                }
            ],
            buttons: [
                {
                    text: 'Save',
                    handler: function(){
                        //if(fp.getForm().isValid()){
                        //        fp.getForm().submit({
                        //            url: 'file-upload.php',
                        //            waitMsg: 'Uploading your photo...',
                        //            success: function(fp, o){
                        //                msg('Success', 'Processed file "'+o.result.file+'" on the server');
                        //            }
                        //        });
                        //}
                    }
                },{
                    text: 'Reset',
                    handler: function(){
                        //fp.getForm().reset();
                    }
                }
            ]
        });

        Inprint.cmp.uploader.Html.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.cmp.uploader.Html.superclass.onRender.apply(this, arguments);
    }
});
