Inprint.calendar.templates.Grid = Ext.extend(Ext.ux.tree.TreeGrid, {

    initComponent: function() {

        this.tbar = Inprint.calendar.templates.Toolbar(this);

        this.columns = [
            Inprint.calendar.GridColumns.shortcut,
            Inprint.calendar.GridColumns.created
        ];

        Ext.apply(this, {
            border: false,
            disabled: true,
            dataUrl: _source("fascicle.list")
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

        var form = new Inprint.calendar.templates.Create({
            parent: this,
            url: _source("fascicle.create")
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

        var form = new Inprint.calendar.templates.Update();
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

        form.cmpSetValue("edition", this.currentEdition);

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

        var node    = this.cmpGetSelectedNode();
        var id      = this.cmpGetSelectedNode().id;
        var fastype = this.cmpGetSelectedNode().fastype;

        var form = new Inprint.calendar.Deadline().cmpInit(node);

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
                fn: this.cmpTemplate,
                buttons: Ext.Msg.YESNO,
                icon: Ext.MessageBox.WARNING
            });
            return;
        }

        if (btn == 'yes') {
            Ext.Ajax.request({
                url: _source("fascicle.template"),
                params: {
                    id: this.cmpGetSelectedNode().id
                },
                scope: this,
                success: this.cmpReloadWithMenu
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
                url: _source("fascicle.format"),
                params: {
                    id: this.cmpGetSelectedNode().id
                },
                scope: this,
                success: this.cmpReloadWithMenu
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
                success: this.cmpReloadWithMenu
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
                success: this.cmpReloadWithMenu
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
                success: this.cmpReloadWithMenu
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
                url: _source("fascicle.delete"),
                params: {
                    id: this.cmpGetSelectedNode().id
                },
                scope: this,
                success: this.cmpReloadWithMenu
            });
        }

    }

});
