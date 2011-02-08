Inprint.cmp.uploader.Flash = Ext.extend(AwesomeUploader, {

    initComponent: function() {

        var cookies = document.cookie.split(";");
        var Session;

        Ext.each(cookies, function(cookie) {
            var nvp = cookie.split("=");
            if (nvp[0].trim() == 'sid') {
                Session = nvp[1];
            }
        });

        this.initialConfig.extraPostData = {
            sid: Session,
            document: this.config.document
        };

        this.initialConfig.awesomeUploaderRoot = "/plugins/uploader/";
        this.initialConfig.xhrUploadUrl      = this.config.uploadUrl;
        this.initialConfig.flashUploadUrl    = this.config.uploadUrl;
        this.initialConfig.standardUploadUrl = this.config.uploadUrl;

        this.initialConfig.gridWidth = 490;
        this.initialConfig.gridHeight = 175;

        this.addEvents( 'fileUploaded' );

        Ext.apply(this, {
            title: _("Flash mode"),
            border:false,
            listeners:{
                scope:this,
                fileupload:function(uploader, success, result){
                    if(success){
                        this.fireEvent('fileUploaded', this);
                    }
                }
            }
        });

        Inprint.cmp.uploader.Flash.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.cmp.uploader.Flash.superclass.onRender.apply(this, arguments);
    }

});
