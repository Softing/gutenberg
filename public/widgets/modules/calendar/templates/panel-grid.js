Inprint.calendar.templates.Grid = Ext.extend(Ext.ux.tree.TreeGrid, {

    initComponent: function() {

        this.url = {
            'load':    _url('/calendar/list/'),
            'create':  _url('/calendar/create/'),
            'read':    _url('/calendar/read/'),
            'update':  _url('/calendar/update/'),
            'delete':  _url('/calendar/delete/'),
            'enable':  _url('/calendar/enable/'),
            'disable': _url('/calendar/disable/')
        };

        this.tbar = [

            {
                id: 'delete',
                text: _("Delete"),
                disabled: true,
                icon: _ico("minus-button"),
                cls: 'x-btn-text-icon',
                ref: "../../btnDelete",
                scope: this,
                handler: this.cmpDelete
            }

        ];

        this.columns = [
            Inprint.calendar.GridColumns.shortcut,
            Inprint.calendar.GridColumns.num,
            Inprint.calendar.GridColumns.circulation,
            Inprint.calendar.GridColumns.docdate,
            Inprint.calendar.GridColumns.advdate,
            Inprint.calendar.GridColumns.printdate,
            Inprint.calendar.GridColumns.releasedate
        ];

        Ext.apply(this, {
            border:false,
            disabled:true,
            dataUrl: _url('/calendar/list/')
        });

        Inprint.calendar.templates.Grid.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.templates.Grid.superclass.onRender.apply(this, arguments);
    },

    cmpGetSelectedNode: function() {
        return this.getSelectionModel().getSelectedNode();
    },

    cmpLoad: function(params) {
        Ext.apply(this.getLoader().baseParams, params);
        this.getRootNode().reload();
    },

    cmpReload: function() {
        this.getRootNode().reload();
    },

    cmpReloadWithMenu: function() {
        this.getRootNode().reload();
        Inprint.layout.getMenu().CmpQuery();
    },

    cmpCreateWindow: function(form, title, btns) {
        return new Ext.Window({
            modal: true,
            layout: "fit",
            closeAction: "hide",
            width: 800,
            height: 420,
            title: title,
            items: form,
            buttons: btns
        });
    },

    /* -------------- */

    cmpArchive: function(btn) {

        if (btn != 'yes' && btn != 'no') {
            Ext.MessageBox.confirm(
                _("Important event"),
                _("Archive the specified release?"),
                this.cmpArchive, this);
            return;
        }

        if (btn == 'yes') {
            Ext.Ajax.request({
                url: this.url["archive"],
                params: {
                    id: this.cmpGetSelectedNode().id
                },
                scope: this,
                success: this.cmpReloadWithMenu,
                failure: this.failure
            });
        }

    },

    /* -------------- */

    cmpCreate: function() {

        var form = new Inprint.calendar.templates.Create();

        form.cmpSetValue("edition", this.currentEdition);

        var wndw = this.cmpCreateWindow(
            form, _("Adding issue"), [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ]
        ).show();

        form.on('actioncomplete', function(form, action) {
            if (action.type == "submit") {
                wndw.close();
                this.cmpReloadWithMenu();
            }
        }, this);

    },

    cmpUpdate: function() {

        var id = this.cmpGetSelectedNode().id;

        var form = new Inprint.calendar.templates.Update();

        form.cmpFill(id);

        var wndw = this.cmpCreateWindow(
            form, _("Editing issue"), [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ]
        ).show();

        form.on('actioncomplete', function(form, action) {
            if (action.type == "submit") {
                wndw.close();
                this.cmpReload();
            }
        }, this);

    },

    cmpDelete: function(btn) {

        if (btn != 'yes' && btn != 'no') {
            Ext.MessageBox.confirm(
                _("Important event"),
                _("Delete the specified issue?"),
                this.cmpDelete, this);
            return;
        }

        if (btn == 'yes') {
            Ext.Ajax.request({
                url: this.url["delete"],
                params: {
                    id: this.cmpGetSelectedNode().id
                },
                scope: this,
                success: this.cmpReloadWithMenu,
                failure: this.failure
            });
        }

    },

    cmpCreateAttachment: function() {

        var form = new Inprint.calendar.attachments.Create({
            parent: this,
            url: this.url.create
        });

        form.getForm().findField("edition").setValue(this.currentEdition);

        var wndw = this.cmpCreateWindow(
            form, _("Adding attachment"), [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ]
        ).show();

        form.on('actioncomplete', function(form, action) {
            if (action.type == "submit") {
                wndw.close();
                this.cmpReloadWithMenu();
            }
        }, this);

    },

    cmpUpdateAttachment: function() {

        var form = new Inprint.calendar.attachments.Update({
            parent: this,
            url: this.url.create
        });

        form.load({
            url: this.url.read,
            scope:this,
            params: {
                id: this.cmpGetSelectedNode().id
            },
            failure: function(form, action) {
                Ext.Msg.alert("Load failed", action.result.errorMessage);
            }
        });

        var wndw = this.cmpCreateWindow(
            form, _("Editing attachment"), [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ]
        ).show();

        form.on('actioncomplete', function(form, action) {
            if (action.type == "submit") {
                wndw.close();
                this.cmpReload();
            }
        }, this);

    },

    cmpDeleteAttachment: function(btn) {

        if (btn != 'yes' && btn != 'no') {
            Ext.MessageBox.confirm(
                _("Warning"),
                _("You really want to do it?"),
                this.cmpDelete, this);
            return;
        }

        if (btn == 'yes') {
            Ext.Ajax.request({
                url: this.url["delete"],
                params: {
                    id: this.cmpGetSelectedNode().id
                },
                scope: this,
                success: this.cmpReloadWithMenu,
                failure: this.failure
            });
        }

    }

});
