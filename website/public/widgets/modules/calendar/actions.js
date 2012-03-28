"use strict";

Inprint.calendar.ViewPlanAction = function() {
    var record = this.getRecord();
    Inprint.ObjectResolver.resolve({ aid:'fascicle-plan', oid: record.get("id"), text: record.get("shortcut") });
};

Inprint.calendar.ViewComposerAction = function() {
    var record = this.getRecord();
    Inprint.ObjectResolver.resolve({ aid:'fascicle-planner', oid: record.get("id"), text: record.get("shortcut") });
};

Inprint.calendar.TemplateComposerAction = function() {
    var record = this.getRecord();
    Inprint.ObjectResolver.resolve({ aid:'fascicle-template-composer', oid: record.get("id"), text: record.get("shortcut") });
};

/* Enable trigger */

Inprint.calendar.EnableAction = function() {
    var record = this.getRecord();
    Ext.Ajax.request({
        url: _source("calendar.enable"),
        params: { id: record.get("id") },
        success: function() {
            this.cmpReload();
            Inprint.layout.getMenu().CmpQuery();
        }.createDelegate(this)
    });
}

Inprint.calendar.DisableAction = function() {
    var record = this.getRecord();
    Ext.Ajax.request({
        url: _source("calendar.disable"),
        params: { id: record.get("id") },
        success: function() {
            this.cmpReload();
            Inprint.layout.getMenu().CmpQuery();
        }.createDelegate(this)
    });
}

/* Copy */

Inprint.calendar.CopyIssueAction = function() {

    var form = new Inprint.calendar.forms.CopyIssueForm({
        parent: this
    });

    form.setId( this.getRecord().get("id") );

    form.on('actioncomplete', function(basicForm, action) {
        if (action.type == "submit") {
            this.cmpReload();
            form.findParentByType("window").close();
        }
    }, this);

    Inprint.fx.Window(
        400, 170, _("Copy issue"),
        form, [ _BTN_WNDW_OK, _BTN_WNDW_CLOSE ]
    ).build().show();
};

Inprint.calendar.CopyAttachmentAction = function() {

    var form = new Inprint.calendar.forms.CopyAttachmentForm({
        parent: this
    });

    form.setId( this.getRecord().get("id") );

    form.on('actioncomplete', function(basicForm, action) {
        if (action.type == "submit") {
            this.cmpReload();
            form.findParentByType("window").close();
        }
    }, this);

    Inprint.fx.Window(
        400, 170, _("Copy attachment"),
        form, [ _BTN_WNDW_OK, _BTN_WNDW_CLOSE ]
    ).build().show();
};

/* Properties*/

Inprint.calendar.PropertiesAction = function() {

    var form = new Inprint.calendar.forms.Properties({
        parent: this
    });

    form.setId( this.getRecord().get("id") );

    form.on('actioncomplete', function(form, action) {
        if (action.type == "submit") {
            wndw.close();
            this.cmpReload();
        }
    }, this);

    Inprint.fx.Window(
        400, 170, _("Copy issue"),
        form, [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ]
    ).build().show();
};

Inprint.calendar.FormatAction = function() {

    var form = new Inprint.calendar.forms.FormatForm({
        parent: this
    });

    form.setId( this.getRecord().get("id") );

    form.on('actioncomplete', function(basicForm, action) {
        if (action.type == "submit") {
            this.cmpReload();
            form.findParentByType("window").close();
        }
    }, this);

    Inprint.fx.Window(
        400, 170, _("Format issue"),
        form, [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ]
    ).build().show();
};


/* Archive trigger*/

Inprint.calendar.ArchiveAction = function(btn) {

    if (btn == 'yes') {
        Ext.Ajax.request({
            url:     _source("calendar.archive"),
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
        msg: _("Archive the specified release?"),
        buttons: Ext.Msg.YESNO,
        icon: Ext.MessageBox.WARNING,
        fn: Inprint.calendar.ArchiveAction.createDelegate(this)
    });

    return true;
};

Inprint.calendar.UnarchiveAction = function(btn) {

    if (btn == 'yes') {
        Ext.Ajax.request({
            url: _source("calendar.unarchive"),
            scope: this,
            params: { id: this.getRecord().get("id") },
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
        msg: _("Unarchive the specified release?"),
        buttons: Ext.Msg.YESNO,
        icon: Ext.MessageBox.WARNING,
        fn: Inprint.calendar.UnarchiveAction.createDelegate(this)
    });

    return true;
};
