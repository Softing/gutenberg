"use strict";

Inprint.calendar.CreateIssueAction = function() {

    var form = new Inprint.calendar.forms.CreateIssueForm();

    form.on('actioncomplete', function(basicForm, action) {
        if (action.type == "submit") {
            this.cmpReload();
            Inprint.layout.getMenu().CmpQuery();
            form.findParentByType("window").close();
        }
    }, this);

    Inprint.fx.Window(
        400, 500, _("New issue"),
        form, [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ]
    ).build().show();
}

Inprint.calendar.UpdateIssueAction = function() {

    var form = new Inprint.calendar.forms.UpdateIssueForm();

    form.cmpFill( this.getRecord().get("id") );

    form.on('actioncomplete', function(basicForm, action) {
        if (action.type == "submit") {
            this.cmpReload();
            Inprint.layout.getMenu().CmpQuery();
            form.findParentByType("window").close();
        }
    }, this);

    Inprint.fx.Window(
        400, 500, _("Issue parameters"),
        form, [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ]
    ).build().show();

};


Inprint.calendar.DeleteIssueAction = function(btn) {

    if (btn == 'yes') {
        Ext.Ajax.request({
            url:     _source("issue.delete"),
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
        fn: Inprint.calendar.DeleteIssueAction.createDelegate(this)
    });

    return true;
};


/* Attachments */

Inprint.calendar.CreateAttachmentAction = function() {

    var form = new Inprint.calendar.forms.AttachmentCreate();

    form.setParent( this.getStore().lastOptions.params.issue );

    form.on('actioncomplete', function(basicForm, action) {
        if (action.type == "submit") {
            this.cmpReload();
            Inprint.layout.getMenu().CmpQuery();
            form.findParentByType("window").close();
        }
    }, this);

    Inprint.fx.Window(
        360, 180, _("New attachment"),
        form, [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ]
    ).build().show();
};

Inprint.calendar.UpdateAttachmentAction = function(oid) {

    var form = new Inprint.calendar.forms.AttachmentUpdate();

    form.cmpFill( this.getRecord().get("id") );

    form.on('actioncomplete', function(basicForm, action) {
        if (action.type == "submit") {
            this.cmpReload();
            Inprint.layout.getMenu().CmpQuery();
            form.findParentByType("window").close();
        }
    }, this);

    Inprint.fx.Window(
        360, 320, _("Attachment parameters"),
        form, [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ]
    ).build().show();
};

Inprint.calendar.DeleteAttachmentAction = function(btn, var1, var2, oid, callback) {

    if (btn == 'yes') {
        Ext.Ajax.request({
            url:     _source("attachment.delete"),
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
        fn: Inprint.calendar.DeleteAttachmentAction.createDelegate(this)
    });

    return true;
};
