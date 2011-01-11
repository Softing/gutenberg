Inprint.advert.modules.Modules = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.pageId = null;
        this.pageW  = null;
        this.pageH  = null;

        this.params = {};
        this.components = {};

        this.urls = {
            "list":        "/advertising/modules/list/",
            "create": _url("/advertising/modules/create/"),
            "read":   _url("/advertising/modules/read/"),
            "update": _url("/advertising/modules/update/"),
            "delete": _url("/advertising/modules/delete/")
        }

        this.store = Inprint.factory.Store.json(this.urls["list"]);

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

        Inprint.advert.modules.Modules.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.advert.modules.Modules.superclass.onRender.apply(this, arguments);
    },


    cmpCreate: function() {
        var wndw = this.components["create-window"];

        if (!wndw) {
            var flash =  this.cmpCreateFlash();
            var form = this.cmpCreateForm("create", this.urls["create"]);
            wndw = this.cmpCreateWindow(_("Creating a new Module"), [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ], form, flash);
            this.components["create-window"] = wndw;
        }

        wndw.show(this);

        if (this.pageW && this.pageH) {
            var configure = function () {
                var flash = wndw.flash;
                if (flash.setField) {
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

        form.findField("edition").setValue(this.parent.edition);
        form.findField("page").setValue(this.pageId);

    },

    cmpUpdate: function() {

        var wndw = this.components["update-window"];
        if (!wndw) {
            var flash =  this.cmpCreateFlash();
            var form = this.cmpCreateForm("update", this.urls["update"]);
            wndw = this.cmpCreateWindow(_("Editing of the Module"), [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ], form, flash);
            this.components["update-window"] = wndw;
        }

        wndw.show(this);

        if (this.pageW && this.pageH) {
            var configure = function () {
                var flash = wndw.flash;
                if (flash.setField) {
                    flash.setField("mypage", "letter", 0, 0 );
                    flash.setGrid("mypage",  this.pageW, this.pageH );
                    //flash.setBlocks("mypage",  [ { id: "myblock", n:"New modules", x: "0/1", y: "0/1", w: "0/1", h: "0/1" } ] );
                    //flash.editBlock("mypage",  "myblock", true );
                } else {
                    configure.defer(10, this);
                }
            }
            configure.defer(10, this);
        }

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
            fields.unshift(_FLD_HDN_EDITION, _FLD_HDN_PAGE);
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
                                flash.deleteAllBlocks("mypage");
                                flash.setBlocks("mypage", [ { id: "myblock", n:record.shortcut, x: record.x, y: record.y, w: record.w, h: record.h } ] );
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

});
