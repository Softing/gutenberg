// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Ext.namespace("Inprint.factory.windows");

Inprint.factory.windows.create = function (title, width, height, item) {

    var wn = new Ext.Window({
        title: _(title),
        layout: "fit",
        width: width,
        height: height,
        modal:true
    });

    wn.add(item);

    return wn;
};

Inprint.createModalWindow = function(width, height, title, form, btns) {
    return new Ext.Window({
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
    });
};
