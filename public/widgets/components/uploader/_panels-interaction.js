Inprint.cmp.uploader.Interaction = function(parent, panels) {

    var flash = panels.flash;
    var html  = panels.html;

    flash.on("fileupload", function(uploader, success, result){
        if(success){
            this.fireEvent("fileUploaded", this);
        }
    }, flash);

    html.getForm().on("beforeaction", function ( form, action ) {
        parent.body.mask();
    }, html.getForm());

    html.on("actioncomplete", function ( form, action ) {
        parent.body.unmask();
        this.fireEvent("fileUploaded", this);
    }, html);

};
