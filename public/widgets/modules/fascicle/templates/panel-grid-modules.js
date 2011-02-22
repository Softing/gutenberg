Inprint.fascicle.templates.Modules = Ext.extend(Ext.grid.GridPanel, {


    initComponent: function() {

        this.pageId = null;
        this.pageW  = null;
        this.pageH  = null;

        this.params = {};
        this.components = {};

        this.urls = {
            "list":        "/fascicle/templates/modules/list/",
            "create": _url("/fascicle/templates/modules/create/"),
            "read":   _url("/fascicle/templates/modules/read/"),
            "update": _url("/fascicle/templates/modules/update/"),
            "delete": _url("/fascicle/templates/modules/delete/")
        }

        this.store = Inprint.factory.Store.json(this.urls.list);

        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        this.columns = [
            this.selectionModel,
            {
                id:"title",
                header: _("Title"),
                width: 150,
                sortable: true,
                dataIndex: "title"
            },
            {
                id:"description",
                header: _("Description"),
                sortable: true,
                dataIndex: "description"
            },
            {
                id:"amount",
                header: _("Amount"),
                sortable: true,
                dataIndex: "amount"
            },
            {
                id:"area",
                header: _("Area"),
                sortable: true,
                dataIndex: "area"
            },
            {
                id:"x",
                header: _("X"),
                sortable: true,
                dataIndex: "x"
            },
            {
                id:"y",
                header: _("Y"),
                sortable: true,
                dataIndex: "y"
            },
            {
                id:"w",
                header: _("W"),
                sortable: true,
                dataIndex: "w"
            },
            {
                id:"h",
                header: _("H"),
                sortable: true,
                dataIndex: "h"
            }
        ];

        this.tbar = [
            {
                disabled:true,
                icon: _ico("plus-button"),
                cls: "x-btn-text-icon",
                text: _("Add"),
                ref: "../btnCreate",
                scope:this,
                handler: this.cmpCreate
            },
            {
                disabled:true,
                icon: _ico("pencil"),
                cls: "x-btn-text-icon",
                text: _("Edit"),
                ref: "../btnUpdate",
                scope:this,
                handler: this.cmpUpdate
            },
            '-',
            {
                disabled:true,
                icon: _ico("minus-button"),
                cls: "x-btn-text-icon",
                text: _("Remove"),
                ref: "../btnDelete",
                scope:this,
                handler: this.cmpDelete
            }
        ];

        Ext.apply(this, {
            disabled:true,
            border:false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "description"
        });

        Inprint.fascicle.templates.Modules.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.fascicle.templates.Modules.superclass.onRender.apply(this, arguments);
    },


    cmpCreate: function() {
        var wndw = this.components["create-window"];

        if (!wndw) {
            var flash =  this.cmpCreateFlash();
            var form = this.cmpCreateForm("create", this.urls.create);
            wndw = this.cmpCreateWindow(_("Creating a new Module"), [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ], form, flash);
            this.components["create-window"] = wndw;
        }

        wndw.show(this);

        if (this.pageW && this.pageH) {
            var configure = function () {
                var flash = wndw.flash;
                if (flash.setField) {
                    flash.reset();
                    flash.setField("mypage", "letter", 0, 0 );
                    flash.setGrid( "mypage", this.pageW, this.pageH );
                    flash.setBlocks( "mypage", [ { id: "myblock", n:"New modules", x: "0/1", y: "0/1", w: "0/1", h: "0/1" } ] );
                    flash.editBlock( "mypage", "myblock", true );
                } else {
                    configure.defer(10, this);
                }
            }
            configure.defer(10, this);
        }

        var form = wndw.form.getForm();

        form.reset();

        form.findField("fascicle").setValue(this.parent.fascicle);
        form.findField("page").setValue(this.pageId);

    },

    cmpUpdate: function() {

        var wndw = this.components["update-window"];
        if (!wndw) {
            var flash =  this.cmpCreateFlash();
            var form = this.cmpCreateForm("update", this.urls.update);
            wndw = this.cmpCreateWindow(_("Editing of the Module"), [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ], form, flash);
            this.components["update-window"] = wndw;
        }

        wndw.show(this);

        var form = wndw.form.getForm();
        form.reset();

        form.load({
            url: this.urls.read,
            scope:this,
            params: {
                id: this.getValue("id")
            }
        });

    },

    cmpDelete: function() {
        Ext.MessageBox.confirm(
            _("Warning"),
            _("You really wish to do this?"),
            function(btn) {
                if (btn == "yes") {
                    Ext.Ajax.request({
                        url: this.urls["delete"],
                        scope:this,
                        success: this.cmpReload,
                        params: { id: this.getValues("id") }
                    });
                }
            }, this).setIcon(Ext.MessageBox.WARNING);
    },

    cmpCreateFlash: function() {
        return {
            xtype: "flash",
            swfWidth:380,
            swfHeight:360,
            hideMode : 'offsets',
            url      : '/flash/Dispose2.swf',
            expressInstall: true,
            flashVars: {
                src: '/flash/Dispose2.swf',
                scale :'noscale',
                autostart: 'yes',
                loop: 'yes'
            }
        };
    },

    cmpCreateForm: function(mode, url) {

        var fields = [
            {
                xtype: "titlefield",
                value: _("Basic options")
            },
            _FLD_TITLE,
            _FLD_DESCRIPTION,
            {
                xtype: "titlefield",
                value: _("More options")
            },
            {
                xtype: "numberfield",
                allowBlank:false,
                allowDecimals:false,
                minValue: 1,
                name: "amount",
                value: 1,
                fieldLabel: _("Amount")
            }
        ];

        if (mode == "create") {
            fields.unshift(_FLD_HDN_FASCICLE, _FLD_HDN_PAGE);
        }

        if (mode == "update") {
            fields.unshift(_FLD_HDN_ID);
        }

        return {
            xtype: "form",
            modal:true,
            frame:false,
            border:false,
            labelWidth: 75,
            url: url,
            bodyStyle: "padding:5px 5px",
            defaults: {
                anchor: "100%",
                allowBlank:false
            },
            baseParams: {},
            items: fields,
            listeners: {
                scope:this,
                beforeaction: function(form, action) {
                    if (action.type == "submit") {
                        var flash = form.window.flash;
                        var panelid = form.window.form.getId();
                        flash.getBlock("mypage", "Inprint.flash.Proxy.setModule", panelid, "myblock");
                    }
                },
                actioncomplete: function (form, action) {
                    if (action.type == "load") {
                        var flash = form.window.flash;
                        var load = function () {
                            if (flash.setBlocks) {
                                var record = action.result.data;
                                flash.reset();
                                flash.setField("mypage", "letter", 0, 0 );
                                flash.setGrid("mypage",  this.pageW, this.pageH );
                                flash.setBlocks("mypage", [ { id: "myblock", n:record.title, x: record.x, y: record.y, w: record.w, h: record.h } ] );
                                flash.editBlock("mypage",  "myblock", true );
                            } else {
                                load.defer(10, this);
                            }
                        };
                        load.defer(10, this);
                    }
                    if (action.type == "submit") {
                        form.window.hide()
                        this.cmpReload();
                    }
                }
            },
            keys: [ _KEY_ENTER_SUBMIT ]
        };
    },

    cmpCreateWindow: function(title, btns, form, flash) {
        return new Ext.Window({
            width:700,
            height:500,
            modal:true,
            title: title,
            layout: "border",
            defaults: {
                collapsible: false,
                split: true
            },
            items: [
                {   region: "center",
                    margins: "3 0 3 3",
                    layout:"fit",
                    items: form
                },
                {   region:"east",
                    margins: "3 3 3 0",
                    width: 380,
                    minSize: 200,
                    maxSize: 600,
                    layout:"fit",
                    collapseMode: 'mini',
                    items: flash
                }
            ],
            listeners: {
                scope:this,
                afterrender: function(panel) {
                    panel.flash = panel.findByType("flash")[0].swf;
                    panel.form  = panel.findByType("form")[0];
                    panel.form.getForm().window = panel;
                }
            },
            buttons: btns
        });
    }

    //initComponent: function() {
    //
    //    this.pageId = null;
    //    this.pageW  = null;
    //    this.pageH  = null;
    //
    //    this.params = {};
    //    this.components = {};
    //
    //    this.urls = {
    //        "list":        "/fascicle/templates/modules/list/",
    //        "create": _url("/fascicle/templates/modules/create/"),
    //        "read":   _url("/fascicle/templates/modules/read/"),
    //        "update": _url("/fascicle/templates/modules/update/"),
    //        "delete": _url("/fascicle/templates/modules/delete/")
    //    }
    //
    //    this.store = Inprint.factory.Store.json(this.urls.list);
    //
    //    this.selectionModel = new Ext.grid.CheckboxSelectionModel();
    //
    //    this.columns = [
    //        this.selectionModel,
    //        {
    //            id:"title",
    //            header: _("Title"),
    //            width: 150,
    //            sortable: true,
    //            dataIndex: "title"
    //        },
    //        {
    //            id:"description",
    //            header: _("Description"),
    //            sortable: true,
    //            dataIndex: "description"
    //        },
    //        {
    //            id:"amount",
    //            header: _("Amount"),
    //            sortable: true,
    //            dataIndex: "amount"
    //        },
    //        {
    //            id:"area",
    //            header: _("Area"),
    //            sortable: true,
    //            dataIndex: "area"
    //        },
    //        {
    //            id:"x",
    //            header: _("X"),
    //            sortable: true,
    //            dataIndex: "x"
    //        },
    //        {
    //            id:"y",
    //            header: _("Y"),
    //            sortable: true,
    //            dataIndex: "y"
    //        },
    //        {
    //            id:"w",
    //            header: _("W"),
    //            sortable: true,
    //            dataIndex: "w"
    //        },
    //        {
    //            id:"h",
    //            header: _("H"),
    //            sortable: true,
    //            dataIndex: "h"
    //        }
    //    ];
    //
    //    this.tbar = [
    //        {
    //            disabled:true,
    //            icon: _ico("plus-button"),
    //            cls: "x-btn-text-icon",
    //            text: _("Add"),
    //            ref: "../btnCreate",
    //            scope:this,
    //            handler: this.cmpCreate
    //        },
    //        {
    //            disabled:true,
    //            icon: _ico("pencil"),
    //            cls: "x-btn-text-icon",
    //            text: _("Edit"),
    //            ref: "../btnUpdate",
    //            scope:this,
    //            handler: this.cmpUpdate
    //        },
    //        '-',
    //        {
    //            disabled:true,
    //            icon: _ico("minus-button"),
    //            cls: "x-btn-text-icon",
    //            text: _("Remove"),
    //            ref: "../btnDelete",
    //            scope:this,
    //            handler: this.cmpDelete
    //        }
    //    ];
    //
    //    Ext.apply(this, {
    //        disabled:true,
    //        border:false,
    //        stripeRows: true,
    //        columnLines: true,
    //        sm: this.selectionModel,
    //        autoExpandColumn: "description"
    //    });
    //
    //    Inprint.fascicle.templates.Modules.superclass.initComponent.apply(this, arguments);
    //
    //},
    //
    //onRender: function() {
    //    Inprint.fascicle.templates.Modules.superclass.onRender.apply(this, arguments);
    //},
    //
    //
    //cmpCreate: function() {
    //    var win = this.components["create-window"];
    //
    //    if (!win) {
    //
    //        var form = {
    //            xtype: "form",
    //            modal:true,
    //            frame:false,
    //            border:false,
    //            labelWidth: 75,
    //            url: this.urls.create,
    //            bodyStyle: "padding:5px 5px",
    //            defaults: {
    //                anchor: "100%",
    //                allowBlank:false
    //            },
    //            baseParams: {},
    //            items: [
    //                _FLD_HDN_FASCICLE,
    //                _FLD_HDN_PAGE,
    //                {
    //                    xtype: "titlefield",
    //                    value: _("Basic options")
    //                },
    //
    //                _FLD_TITLE,
    //                _FLD_DESCRIPTION,
    //
    //                {
    //                    xtype: "titlefield",
    //                    value: _("More options")
    //                },
    //
    //                {
    //                    xtype: "numberfield",
    //                    allowBlank:false,
    //                    allowDecimals:false,
    //                    minValue: 1,
    //                    name: "amount",
    //                    value: 1,
    //                    fieldLabel: _("Amount")
    //                }
    //            ],
    //            listeners: {
    //                scope:this,
    //                beforeaction: function(form, action) {
    //                    var swf = this.components["create-window"].findByType("flash")[0].swf;
    //                    var id = Ext.getCmp(this.components["create-window"].getId()).form.getId();
    //                    //(function () {
    //                        swf.getBlock("Inprint.flash.Proxy.setModule", id, "new_block");
    //                    //}).defer(10);
    //                },
    //                actioncomplete: function (form, action) {
    //                    if (action.type == "submit") {
    //                        this.components["create-window"].hide()
    //                        this.cmpReload();
    //                    }
    //                }
    //            },
    //            keys: [ _KEY_ENTER_SUBMIT ]
    //        };
    //
    //        var flash =  {
    //            xtype: "flash",
    //            swfWidth:380,
    //            swfHeight:360,
    //            hideMode : 'offsets',
    //            url      : '/flash/Dispose.swf',
    //            expressInstall: true,
    //            flashVars: {
    //                src: '/flash/Dispose.swf',
    //                scale :'noscale',
    //                autostart: 'yes',
    //                loop: 'yes'
    //            },
    //            listeners: {
    //                scope:this,
    //                initialize: function(panel, flash) {
    //                    alert(2);
    //                },
    //                afterrender: function(panel) {
    //
    //                    var init = function () {
    //                        if (panel.swf.init) {
    //                            panel.swf.init(panel.getSwfId(), "letter", 0, 0);
    //                        } else {
    //                            init.defer(10, this);
    //                        }
    //                    };
    //
    //                    init.defer(10, this);
    //
    //                }
    //            }
    //        };
    //
    //        win = new Ext.Window({
    //            width:700,
    //            height:500,
    //            modal:true,
    //            layout: "border",
    //            closeAction: "hide",
    //            title: _("Adding a new category"),
    //            defaults: {
    //                collapsible: false,
    //                split: true
    //            },
    //            items: [
    //                {   region: "center",
    //                    margins: "3 0 3 3",
    //                    layout:"fit",
    //                    items: form
    //                },
    //                {   region:"east",
    //                    margins: "3 3 3 0",
    //                    width: 380,
    //                    minSize: 200,
    //                    maxSize: 600,
    //                    layout:"fit",
    //                    collapseMode: 'mini',
    //                    items: flash
    //                }
    //            ],
    //            listeners: {
    //                scope:this,
    //                afterrender: function(panel) {
    //                    panel.flash = panel.findByType("flash")[0].swf;
    //                    panel.form  = panel.findByType("form")[0];
    //                }
    //            },
    //            buttons: [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ]
    //        });
    //
    //    }
    //
    //    win.show(this);
    //    this.components["create-window"] = win;
    //
    //    if (this.pageW && this.pageH) {
    //        var configure = function () {
    //            if (win.flash.setGrid) {
    //                win.flash.setGrid( this.pageW, this.pageH );
    //                win.flash.setBlocks( [ { id: "new_block", n:"New modules", x: "0/1", y: "0/1", w: "0/1", h: "0/1" } ] );
    //                win.flash.editBlock( "new_block", true );
    //            } else {
    //                configure.defer(10, this);
    //            }
    //        }
    //        configure.defer(10, this);
    //    }
    //
    //    var form = win.form.getForm();
    //
    //    form.reset();
    //
    //    form.findField("fascicle").setValue(this.parent.fascicle);
    //    form.findField("page").setValue(this.pageId);
    //
    //},
    //
    //cmpUpdate: function() {
    //
    //    var win = this.components["update-window"];
    //    if (!win) {
    //
    //        var form = {
    //            xtype: "form",
    //            frame:false,
    //            border:false,
    //            labelWidth: 75,
    //            url: this.urls.update,
    //            bodyStyle: "padding:5px 5px",
    //            baseParams: {},
    //            defaults: {
    //                anchor: "100%",
    //                allowBlank:false
    //            },
    //            items: [
    //                _FLD_HDN_ID,
    //
    //                {
    //                    xtype: "titlefield",
    //                    value: _("Basic options")
    //                },
    //
    //                _FLD_TITLE,
    //                _FLD_DESCRIPTION,
    //
    //                {
    //                    xtype: "titlefield",
    //                    value: _("More options")
    //                },
    //
    //                {
    //                    xtype: "numberfield",
    //                    allowBlank:false,
    //                    allowDecimals:false,
    //                    minValue: 1,
    //                    name: "amount",
    //                    value: 1,
    //                    fieldLabel: _("Amount")
    //                }
    //            ],
    //            listeners: {
    //                scope:this,
    //                beforeaction: function(form, action) {
    //                    if (action.type == "submit") {
    //                        var flash = this.components["update-window"].findByType("flash")[0].swf;
    //                        var id = Ext.getCmp(this.components["update-window"].getId()).form.getId();
    //                        flash.getBlock("Inprint.flash.Proxy.setModule", id, "update_block");
    //                    }
    //                },
    //                actioncomplete: function (form, action) {
    //                    if (action.type == "load") {
    //
    //                        if (this.pageW && this.pageH) {
    //
    //                            var flash = this.components["update-window"].findByType("flash")[0].swf;
    //
    //                            var load = function () {
    //                                var record = action.result.data;
    //                                if (flash.reset) {
    //                                    flash.reset();
    //                                    flash.setField("mypage", "letter", 0, 0 );
    //                                    flash.setGrid("mypage",  this.pageW, this.pageH );
    //                                    flash.setBlocks("mypage",  [ { id: "myblock", n:record.title, x: record.x, y: record.y, w: record.w, h: record.h } ] );
    //                                    flash.editBlock("mypage",  "myblock", true );
    //                                } else {
    //                                    load.defer(10, this);
    //                                }
    //                            };
    //
    //                            load.defer(10, this);
    //
    //                        }
    //                    }
    //                    if (action.type == "submit") {
    //                        this.components["update-window"].hide()
    //                        this.cmpReload();
    //                    }
    //                }
    //            },
    //            keys: [ _KEY_ENTER_SUBMIT ]
    //        };
    //
    //        var flash =  {
    //            xtype: "flash",
    //            swfWidth:380,
    //            swfHeight:360,
    //            hideMode : 'offsets',
    //            url      : '/flash/Dispose2.swf',
    //            expressInstall: true,
    //            flashVars: {
    //                src: '/flash/Dispose2.swf',
    //                scale :'noscale',
    //                autostart: 'yes',
    //                loop: 'yes'
    //            }
    //        };
    //
    //        win = new Ext.Window({
    //            width:700,
    //            height:500,
    //            modal:true,
    //            layout: "border",
    //            closeAction: "hide",
    //            title: _("Adding a new category"),
    //            defaults: {
    //                collapsible: false,
    //                split: true
    //            },
    //            items: [
    //                {   region: "center",
    //                    margins: "3 0 3 3",
    //                    layout:"fit",
    //                    items: form
    //                },
    //                {   region:"east",
    //                    margins: "3 3 3 0",
    //                    width: 380,
    //                    minSize: 200,
    //                    maxSize: 600,
    //                    layout:"fit",
    //                    collapseMode: 'mini',
    //                    items: flash
    //                }
    //            ],
    //            listeners: {
    //                scope:this,
    //                afterrender: function(panel) {
    //                    panel.flash = panel.findByType("flash")[0].swf;
    //                    panel.form  = panel.findByType("form")[0];
    //                }
    //            },
    //            buttons: [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ]
    //        });
    //
    //    }
    //
    //    win.show(this);
    //    this.components["update-window"] = win;
    //
    //    var form = win.form.getForm();
    //    form.reset();
    //
    //    form.load({
    //        url: this.urls.read,
    //        scope:this,
    //        params: {
    //            id: this.getValue("id")
    //        }
    //    });
    //
    //},
    //
    //cmpDelete: function() {
    //    Ext.MessageBox.confirm(
    //        _("Warning"),
    //        _("You really wish to do this?"),
    //        function(btn) {
    //            if (btn == "yes") {
    //                Ext.Ajax.request({
    //                    url: this.urls["delete"],
    //                    scope:this,
    //                    success: this.cmpReload,
    //                    params: { id: this.getValues("id") }
    //                });
    //            }
    //        }, this).setIcon(Ext.MessageBox.WARNING);
    //}

});
