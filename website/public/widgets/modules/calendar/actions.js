/* Actions */

Inprint.calendar.actions.remove = function(btn, var1, var2, oid, callback) {
    if (btn == 'no') {
        return;
    }
    if (btn == 'yes') {
        Ext.Ajax.request({
            url:     _source("fascicle.remove"),
            params:  { id: oid },
            success: callback
        });
    }
    if (btn == null) {
        Ext.MessageBox.show({
            title: _("Important event"),
            msg: _("Delete selected item?"),
            buttons: Ext.Msg.YESNO,
            icon: Ext.MessageBox.WARNING,
            fn: Inprint.calendar.actions.remove.createDelegate(this, [oid, callback], true)
        });
    }
    return;
};

Inprint.calendar.actions.copy = function() {

    var form = new Inprint.calendar.forms.Copy({
        parent: this
    });

    form.setId(
        this.cmpGetSelectedNode().id
    );

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

Inprint.calendar.actions.properties = function() {

    var form = new Inprint.calendar.forms.Properties({
        parent: this
    });

    //form.setId(
    //    this.cmpGetSelectedNode().id
    //);

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

Inprint.calendar.actions.format = function() {

    var form = new Inprint.calendar.issues.FormatForm({
        parent: this
    });

    form.setId(
        this.cmpGetSelectedNode().id
    );

    form.on('actioncomplete', function(form, action) {
        if (action.type == "submit") {
            wndw.close();
            this.cmpReload();
        }
    }, this);

    Inprint.fx.Window(
        400, 170, _("Format issue"),
        form, [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ]
    ).build().show();
};

Inprint.calendar.actions.deadline = function() {
    //var node    = this.cmpGetSelectedNode();
    //var id      = this.cmpGetSelectedNode().id;
    //var fastype = this.cmpGetSelectedNode().fastype;
    //
    //var form = new Inprint.calendar.Deadline().cmpInit(node);
    //
    //var wndw = this.cmpCreateWindow(
    //    360,320, form, _("Editing deadline"), [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ]
    //).show();
    //
    //form.on('actioncomplete', function(form, action) {
    //    if (action.type == "submit") {
    //        wndw.close();
    //        this.cmpReload();
    //    }
    //}, this);
}

Inprint.calendar.actions.template = function() {
    //if (btn != 'yes' && btn != 'no') {
    //    Ext.MessageBox.show({
    //        scope: this,
    //        title: _("Important event"),
    //        msg: _("Save as template?"),
    //        fn: this.cmpTemplate,
    //        buttons: Ext.Msg.YESNO,
    //        icon: Ext.MessageBox.WARNING
    //    });
    //    return;
    //}
    //
    //if (btn == 'yes') {
    //    Ext.Ajax.request({
    //        url: _source("fascicle.template"),
    //        params: {
    //            id: this.cmpGetSelectedNode().id
    //        },
    //        scope: this,
    //        success: this.cmpReloadWithMenu
    //    });
    //}
}

Inprint.calendar.actions.statusApproval = function(btn, var1, var2, oid, callback) {
    if (btn == 'no') {
        return;
    }
    if (btn == 'yes') {
        Ext.Ajax.request({
            url: _source("fascicle.approval"),
            params:  { id: oid },
            success: callback
        });
    }
    if (btn == null) {
        Ext.MessageBox.confirm(
            _("Important event"),
            _("Send for approval?"),
            Inprint.calendar.actions.archive.createDelegate(this, [oid, callback], true));
    }
}

Inprint.calendar.actions.statusWork = function(btn, var1, var2, oid, callback) {
    if (btn == 'no') {
        return;
    }
    if (btn == 'yes') {
        Ext.Ajax.request({
            url: _source("fascicle.work"),
            params:  { id: oid },
            success: callback
        });
    }
    if (btn == null) {
        Ext.MessageBox.confirm(
            _("Important event"),
            _("Begin work?"),
            Inprint.calendar.actions.archive.createDelegate(this, [oid, callback], true));
    }
}

/* Archive trigger*/

Inprint.calendar.actions.archive = function(btn, var1, var2, oid, callback) {
    if (btn == 'no') {
        return;
    }
    if (btn == 'yes') {
        Ext.Ajax.request({
            url:     _url('/calendar/fascicle/archive/'),
            params:  { id: oid },
            success: callback
        });
    }
    if (btn == null) {
        Ext.MessageBox.confirm(
            _("Important event"),
            _("Archive the specified release?"),
            Inprint.calendar.actions.archive.createDelegate(this, [oid, callback], true));
    }
};

Inprint.calendar.actions.unarchive = function(btn, var1, var2, oid, callback) {
    if (btn == 'no') {
        return;
    }
    if (btn == 'yes') {
        Ext.Ajax.request({
            url:     _url('/calendar/fascicle/unarchive/'),
            params:  { id: oid },
            success: callback
        });
    }
    if (btn == null) {
        Ext.MessageBox.confirm(
            _("Important event"),
            _("Unarchive the specified release?"),
            Inprint.calendar.actions.unarchive.createDelegate(this, [oid, callback], true));
    }
};

/* Enable trigger */

Inprint.calendar.actions.enable = function(oid, callback) {
    Ext.Ajax.request({
        url: _source("fascicle.enable"),
        params: { id: oid },
        success: callback
    });
}

Inprint.calendar.actions.disable = function(oid, callback) {
    Ext.Ajax.request({
        url: _source("fascicle.disable"),
        params: { id: oid },
        success: callback
    });
}

/* Issues */

Inprint.calendar.actions.fascicleCreate = function() {

    var form = new Inprint.calendar.issues.CreateFascicleForm({
        parent: this,
        url: _source("fascicle.create")
    });

    form.cmpSetValue("edition", this.currentEdition);

    //var wndw = this.cmpCreateWindow(
    //    600, 300,
    //    form, _("New issue"),
    //    [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ]
    //).show();

    form.on('actioncomplete', function(form, action) {
        if (action.type == "submit") {
            wndw.close();
            this.cmpReloadWithMenu();
        }
    }, this);

    Inprint.fx.Window(
        600, 300, _("New issue"),
        form, [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ]
    ).build().show();
}

Inprint.calendar.actions.fascicleUpdate = function(oid) {
    //if (!id) id = this.cmpGetSelectedNode().id;

    var form = new Inprint.calendar.issues.UpdateFascicleForm();
    form.cmpFill(oid);

    //var wndw = this.cmpCreateWindow(
    //    700, 350,
    //    form, _("Issue parameters"),
    //    [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ]
    //).show();

    form.on('actioncomplete', function(form, action) {
        if (action.type == "submit") {
            wndw.close();
            this.cmpReload();
        }
    }, this);

    Inprint.fx.Window(
        700, 350, _("Issue parameters"),
        form, [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ]
    ).build().show();

};

/* Attachments */

Inprint.calendar.actions.attachmentCreate = function() {

    var form = new Inprint.calendar.issues.CreateFascicleFormAttachmentForm();

    //form.setParent(this.cmpGetSelectedNode().id);
    //
    //var wndw = this.cmpCreateWindow(
    //    360, 180,
    //    form, _("New attachment"),
    //    [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ]
    //).show();

    form.on('actioncomplete', function(form, action) {
        if (action.type == "submit") {
            wndw.close();
            this.cmpReloadWithMenu();
        }
    }, this);

    Inprint.fx.Window(
        360, 180, _("New attachment"),
        form, [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ]
    ).build().show();
};

Inprint.calendar.actions.attachmentUpdate = function(oid) {
    //
    //if (!id) id = this.cmpGetSelectedNode().id;

    var form = new Inprint.calendar.issues.UpdateFascicleFormAttachmentForm();
    form.cmpFill(oid);

    //var wndw = this.cmpCreateWindow(
    //    360,320,
    //    form, _("Attachment parameters"),
    //    [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ]
    //).show();

    form.on('actioncomplete', function(form, action) {
        if (action.type == "submit") {
            wndw.close();
            this.cmpReload();
        }
    }, this);

    Inprint.fx.Window(
        360, 320, _("Attachment parameters"),
        form, [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ]
    ).build().show();
};


/* Templates */

Inprint.calendar.actions.templateCreate = function() {

    var form = new Inprint.calendar.templates.CreateForm();

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

Inprint.calendar.actions.templateUpdate = function() {
    var form = new Inprint.calendar.templates.UpdateForm();

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

Inprint.calendar.actions.templateDelete = function(btn, var1, var2, oid, callback) {
    if (btn == 'no') {
        return;
    }
    if (btn == 'yes') {
        Ext.Ajax.request({
            url: _source("template.remove"),
            params:  { id: oid },
            success: callback
        });
    }
    if (btn == null) {
        Ext.MessageBox.show({
            title: _("Important event"),
            msg: _("Delete selected item?"),
            buttons: Ext.Msg.YESNO,
            icon: Ext.MessageBox.WARNING,
            fn: Inprint.calendar.actions.templateDelete.createDelegate(this, [oid, callback], true)
        });
    }
    return;
}
