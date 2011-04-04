Inprint.calendar.fascicles.Grid = Ext.extend(Ext.ux.tree.TreeGrid, {

    initComponent: function() {

        this.url = {
            'remove':  _url('/calendar/fascicle/remove/'),
            'enable':  _url('/calendar/fascicle/enable/'),
            'disable': _url('/calendar/fascicle/disable/'),
            'archive':  _url('/calendar/fascicle/archive/')
        };

        this.tbar = [

            {
                id: 'create',
                disabled: true,
                text: _("Create"),
                ref: "../btnCreate",
                cls: 'x-btn-text-icon',
                icon: _ico("blue-folder--plus"),
                scope: this,
                handler: this.cmpCreate
            },

            {
                id: 'update',
                disabled: true,
                text: _("Edit"),
                ref: "../btnUpdate",
                icon: _ico("blue-folder--pencil"),
                cls: 'x-btn-text-icon',
                scope: this,
                handler: this.cmpUpdate
            },

            {
                id: 'delete',
                text: _("Delete"),
                disabled: true,
                icon: _ico("blue-folder--minus"),
                cls: 'x-btn-text-icon',
                ref: "../btnDelete",
                scope: this,
                handler: this.cmpRemove
            },

            "-",

            {
                id: 'deadline',
                disabled: true,
                text: _("Deadline"),
                ref: "../btnDeadline",
                icon: _ico("clock-select"),
                cls: 'x-btn-text-icon',
                scope: this,
                handler: this.cmpDeadline
            },

            "-",

            {
                id: "enable",
                disabled: true,
                ref: "../btnEnable",
                icon: _ico("plug-connect"),
                cls: 'x-btn-text-icon',
                text    : _('Enable'),
                scope: this,
                handler : this.cmpEnable
            },

            {
                id: "disable",
                disabled: true,
                ref: "../btnDisable",
                icon: _ico("plug-disconnect"),
                cls: 'x-btn-text-icon',
                text    : _('Disable'),
                scope: this,
                handler : this.cmpDisable
            },

            "-",

            {
                id: 'archive',
                disabled: true,
                text: _("Archive"),
                ref: "../btnArchive",
                icon: _ico("gear"),
                cls: 'x-btn-text-icon',
                scope: this,
                handler: this.cmpArchive
            },

            {
                id: 'template',
                disabled: true,
                text: _("Make template"),
                ref: "../btnTemplate",
                icon: _ico("puzzle"),
                cls: 'x-btn-text-icon',
                scope: this,
                handler: this.cmpTemplate
            },

            {
                id: 'format',
                disabled: true,
                text: _("Format"),
                ref: "../btnFormat",
                icon: _ico("eraser"),
                cls: 'x-btn-text-icon',
                scope: this,
                handler: this.cmpFormat
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

        Inprint.calendar.fascicles.Grid.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.fascicles.Grid.superclass.onRender.apply(this, arguments);
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

    /* -------------- */

    cmpCreateWindow: function(width, height, form, title, btns) {
        return new Ext.Window({
            modal: true,
            layout: "fit",
            closeAction: "hide",
            width: width,
            height: height,
            title: title,
            items: form,
            buttons: btns
        });
    },

    /* -------------- */

    cmpCreate: function() {

        var form = new Inprint.calendar.fascicles.Create({
            parent: this,
            url: this.url.create
        });

        form.cmpSetValue("edition", this.currentEdition);

        var wndw = this.cmpCreateWindow(
            700,350, form, _("Adding issue"), [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ]
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

        var form = new Inprint.calendar.fascicles.Update();
        form.cmpFill(id);

        var wndw = this.cmpCreateWindow(
            700,350, form, _("Editing issue"), [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ]
        ).show();

        form.on('actioncomplete', function(form, action) {
            if (action.type == "submit") {
                wndw.close();
                this.cmpReload();
            }
        }, this);

    },

    cmpCreateAttachment: function() {

        var form = new Inprint.calendar.attachments.Create();

        form.cmpSetValue("parent", this.cmpGetSelectedNode().id);

        var wndw = this.cmpCreateWindow(
            360,350, form, _("Adding attachment"), [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ]
        ).show();

        form.on('actioncomplete', function(form, action) {
            if (action.type == "submit") {
                wndw.close();
                this.cmpReloadWithMenu();
            }
        }, this);

    },

    cmpUpdateAttachment: function() {

        var id = this.cmpGetSelectedNode().id;

        var form = new Inprint.calendar.attachments.Update();
        form.cmpFill(id);

        var wndw = this.cmpCreateWindow(
            360,320, form, _("Editing attachment"), [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ]
        ).show();

        form.on('actioncomplete', function(form, action) {
            if (action.type == "submit") {
                wndw.close();
                this.cmpReload();
            }
        }, this);

    },

    cmpDeadline: function() {

        var id = this.cmpGetSelectedNode().id;

        var form = new Inprint.calendar.Deadline();
        form.cmpFill(id);

        var wndw = this.cmpCreateWindow(
            360,320, form, _("Editing deadline"), [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ]
        ).show();

        form.on('actioncomplete', function(form, action) {
            if (action.type == "submit") {
                wndw.close();
                this.cmpReload();
            }
        }, this);

    },

    /* -------------- */

    cmpTemplate: function(btn) {

        if (btn != 'yes' && btn != 'no') {
            Ext.MessageBox.show({
                scope: this,
                title: _("Important event"),
                msg: _("Save as template?"),
                fn: this.cmpDelete,
                buttons: Ext.Msg.YESNO,
                icon: Ext.MessageBox.WARNING
            });
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

    cmpFormat: function(btn) {

        if (btn != 'yes' && btn != 'no') {
            Ext.MessageBox.show({
                scope: this,
                title: _("Important event"),
                msg: _("Save as template?"),
                fn: this.cmpDelete,
                buttons: Ext.Msg.YESNO,
                icon: Ext.MessageBox.WARNING
            });
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

    cmpArchive: function(btn) {

        if (btn != 'yes' && btn != 'no') {
            Ext.MessageBox.show({
                scope: this,
                title: _("Important event"),
                msg: _("Archive the specified item?"),
                fn: this.cmpArchive,
                buttons: Ext.Msg.YESNO,
                icon: Ext.MessageBox.WARNING
            });
            return;
        }

        if (btn == 'yes') {
            Ext.Ajax.request({
                url: _source("fascicle.archive"),
                params: {
                    id: this.cmpGetSelectedNode().id
                },
                scope: this,
                success: this.cmpReloadWithMenu,
                failure: this.failure
            });
        }

    },

    cmpEnable: function(btn) {

        if (btn != 'yes' && btn != 'no') {
            Ext.MessageBox.show({
                scope: this,
                title: _("Important event"),
                msg: _("Enable the specified item?"),
                fn: this.cmpEnable,
                buttons: Ext.Msg.YESNO,
                icon: Ext.MessageBox.WARNING
            });
            return;
        }

        if (btn == 'yes') {
            Ext.Ajax.request({
                url: _source("fascicle.enable"),
                params: {
                    id: this.cmpGetSelectedNode().id
                },
                scope: this,
                success: this.cmpReloadWithMenu,
                failure: this.failure
            });
        }

    },

    cmpDisable: function(btn) {

        if (btn != 'yes' && btn != 'no') {
            Ext.MessageBox.show({
                scope: this,
                title: _("Important event"),
                msg: _("Disable the specified item?"),
                fn: this.cmpDisable,
                buttons: Ext.Msg.YESNO,
                icon: Ext.MessageBox.WARNING
            });
            return;
        }

        if (btn == 'yes') {
            Ext.Ajax.request({
                url: _source("fascicle.disable"),
                params: {
                    id: this.cmpGetSelectedNode().id
                },
                scope: this,
                success: this.cmpReloadWithMenu,
                failure: this.failure
            });
        }

    },

    cmpRemove: function(btn) {

        if (btn != 'yes' && btn != 'no') {
            Ext.MessageBox.show({
                scope: this,
                title: _("Important event"),
                msg: _("Delete the specified item?"),
                fn: this.cmpRemove,
                buttons: Ext.Msg.YESNO,
                icon: Ext.MessageBox.WARNING
            });
            return;
        }

        if (btn == 'yes') {
            Ext.Ajax.request({
                url: this.url.remove,
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
