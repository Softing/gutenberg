Inprint.calendar.CreateTemplateAction = function() {

    var form = new Inprint.calendar.forms.CreateTemplateForm();

    form.setEdition(this.currentEdition);

    form.on('actioncomplete', function(basicForm, action) {
        if (action.type == "submit") {
            this.cmpReload();
            Inprint.layout.getMenu().CmpQuery();
            form.findParentByType("window").close();
        }
    }, this);

    Inprint.fx.Window(
        300, 170, _("New template"),
        form, [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ]
    ).build().show();
}

Inprint.calendar.UpdateTemplateAction = function() {
    var form = new Inprint.calendar.forms.UpdateTemplateForm();

    form.setId(this.getValue("id"));
    form.cmpFill(this.getValue("id"));

    form.on('actioncomplete', function(basicForm, action) {
        if (action.type == "submit") {
            this.cmpReload();
            Inprint.layout.getMenu().CmpQuery();
            form.findParentByType("window").close();
        }
    }, this);

    Inprint.fx.Window(
        300, 170, _("Edit template"),
        form, [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ]
    ).build().show();
}

Inprint.calendar.DeleteTemplateAction = function(btn) {

    if (btn == 'yes') {
        Ext.Ajax.request({
            url:     _source("template.delete"),
            scope: this,
            params:  { id: this.getRecord().get("id") },
            success: function() {
                this.cmpReload();
                Inprint.layout.getMenu().CmpQuery();
            }
        });
        return false;
    }

    if (btn == 'no') {
        return false;
    }

    Ext.MessageBox.show({
        title: _("Important event"),
        msg: _("Delete selected item?"),
        buttons: Ext.Msg.YESNO,
        icon: Ext.MessageBox.WARNING,
        fn: Inprint.calendar.DeleteTemplateAction.createDelegate(this)
    });

    return true;

    //if (btn == 'no') {
    //    return;
    //}
    //if (btn == 'yes') {
    //    Ext.Ajax.request({
    //        url: _source("template.remove"),
    //        params:  { id: oid },
    //        success: callback
    //    });
    //}
    //if (btn == null) {
    //    Ext.MessageBox.show({
    //        title: _("Important event"),
    //        msg: _("Delete selected item?"),
    //        buttons: Ext.Msg.YESNO,
    //        icon: Ext.MessageBox.WARNING,
    //        fn: Inprint.calendar.actions.templateDelete.createDelegate(this, [oid, callback], true)
    //    });
    //}
    //return;
}
