Inprint.calendar.fascicles.Grid = Ext.extend(Ext.ux.tree.TreeGrid, {

    initComponent: function() {

        this.access = {};

        this.tbar = [

            {
                xtype: 'buttongroup',
                columns: 1,
                defaults: {
                    scale: 'small'
                },
                items: [
                    {
                        id: 'create',
                        disabled: true,
                        text: _("Create issue"),
                        ref: "../../btnCreate",
                        cls: 'x-btn-text-icon',
                        icon: _ico("blue-folder--plus"),
                        scope: this,
                        handler: this.cmpCreateFascicle
                    },
                    {
                        id: 'createAttachment',
                        disabled: true,
                        text: _("Create attachment"),
                        ref: "../../btnCreateAttachment",
                        cls: 'x-btn-text-icon',
                        icon: _ico("folder--plus"),
                        scope: this,
                        handler: this.cmpCreateAttachment
                    }
                ]
            },

            {
                xtype: 'buttongroup',
                columns: 3,
                defaults: {
                    scale: 'small'
                },
                items: [
                    {
                        id: 'deadline',
                        disabled: true,
                        text: _("Deadline"),
                        ref: "../../btnDeadline",
                        icon: _ico("clock-select"),
                        cls: 'x-btn-text-icon',
                        scope: this,
                        handler: this.cmpDeadline
                    },
                    {
                        id: "enable",
                        disabled: true,
                        ref: "../../btnEnable",
                        icon: _ico("plug-connect"),
                        cls: 'x-btn-text-icon',
                        text    : _('Enable'),
                        scope: this,
                        handler : this.cmpEnable
                    },
                    {
                        id: 'template',
                        disabled: true,
                        text: _("Make template"),
                        ref: "../../btnTemplate",
                        icon: _ico("puzzle"),
                        cls: 'x-btn-text-icon',
                        scope: this,
                        handler: this.cmpTemplate
                    },
                    {
                        id: 'archive',
                        disabled: true,
                        text: _("Archive"),
                        ref: "../../btnArchive",
                        icon: _ico("gear"),
                        cls: 'x-btn-text-icon',
                        scope: this,
                        handler: this.cmpArchive
                    },
                    {
                        id: "disable",
                        disabled: true,
                        ref: "../../btnDisable",
                        icon: _ico("plug-disconnect"),
                        cls: 'x-btn-text-icon',
                        text    : _('Disable'),
                        scope: this,
                        handler : this.cmpDisable
                    },
                    {
                        id: 'format',
                        disabled: true,
                        text: _("Format"),
                        ref: "../../btnFormat",
                        icon: _ico("eraser"),
                        cls: 'x-btn-text-icon',
                        scope: this,
                        handler: this.cmpFormat
                    }
                ]
            }

        ];

        this.columns = [
            Inprint.calendar.GridColumns.shortcut,
            Inprint.calendar.GridColumns.num,
            Inprint.calendar.GridColumns.circulation,
            Inprint.calendar.GridColumns.template,
            Inprint.calendar.GridColumns.docdate,
            Inprint.calendar.GridColumns.advdate,
            Inprint.calendar.GridColumns.printdate,
            Inprint.calendar.GridColumns.releasedate
        ];

        Ext.apply(this, {
            border:false,
            disabled:true,
            dataUrl: _source("fascicle.list")
        });

        Inprint.calendar.fascicles.Grid.superclass.initComponent.apply(this, arguments);
    },

    onRender: function() {
        Inprint.calendar.fascicles.Grid.superclass.onRender.apply(this, arguments);
    },

    /* Getters */

    getAccess: function(id) {
        return this.access[id];
    },
    setAccess: function(id, value) {
        this.access[id] = value;
    },

    /* Functions */
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

    cmpCreateFascicle: function() {

        var form = new Inprint.calendar.fascicles.Create({
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

    cmpUpdateFascicle: function(id) {

        if (!id) id = this.cmpGetSelectedNode().id;

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

        form.cmpSetValue("edition", this.currentEdition);

        var wndw = this.cmpCreateWindow(
            360,250, form, _("Adding attachment"), [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ]
        ).show();

        form.on('actioncomplete', function(form, action) {
            if (action.type == "submit") {
                wndw.close();
                this.cmpReloadWithMenu();
            }
        }, this);

    },

    cmpUpdateAttachment: function(id) {

        if (!id) id = this.cmpGetSelectedNode().id;

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

    cmpFormat: function() {

        var form = new Inprint.calendar.fascicles.Format({
            parent: this
        });

        //form.cmpSetValue("edition", this.currentEdition);

        var wndw = this.cmpCreateWindow(
            300, 140, form, _("Format issue"), [ _BTN_WNDW_OK, _BTN_WNDW_CLOSE ]
        ).show();

        form.on('actioncomplete', function(form, action) {
            if (action.type == "submit") {
                wndw.close();
                this.cmpReload();
            }
        }, this);

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
