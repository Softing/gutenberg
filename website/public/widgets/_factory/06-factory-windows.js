Inprint.fx.Window = function(width, height, title, form, btns) {

    var hash = {
        plain: true,
        modal: true,
        layout: "fit",
        closeAction: "hide",
        bodyStyle:'padding:5px 5px 5px 5px',

        title: title,
        width: width,
        height: height,

        items: form,
        buttons: btns
    };

    return {
        build: function() {
            return new Ext.Window(hash);
        }
    }
};
