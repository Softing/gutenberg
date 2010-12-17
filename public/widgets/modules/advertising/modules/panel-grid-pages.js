Inprint.advert.modules.Pages = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.params = {};
        this.components = {};
        
        this.urls = {
            "list":        "/advertising/pages/list/",
            "create": _url("/advertising/pages/create/"),
            "read":   _url("/advertising/pages/read/"),
            "update": _url("/advertising/pages/update/"),
            "delete": _url("/advertising/pages/delete/")
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
                id:"shortcut",
                header: _("Shortcut"),
                width: 150,
                sortable: true,
                dataIndex: "shortcut"
            },
            {
                id:"description",
                header: _("Description"),
                sortable: true,
                dataIndex: "description"
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

        Inprint.advert.modules.Pages.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.advert.modules.Pages.superclass.onRender.apply(this, arguments);
    },
    
    
    cmpCreate: function() {
        var win = this.components["create-window"];

        if (!win) {

            var form = {
                xtype: "form",
                
                frame:false,
                border:false,
                labelWidth: 75,
                url: this.urls["create"],
                bodyStyle: "padding:5px 5px",
                defaults: {
                    anchor: "100%",
                    allowBlank:false
                },
                items: [
                    _FLD_HDN_FASCICLE,
                    _FLD_HDN_HEADLINE,
                    _FLD_SHORTCUT,
                    _FLD_TITLE,
                    _FLD_DESCRIPTION
                ],
                listeners: {
                    scope:this,
                    beforeaction: function(form, action) {
                        var swf = this.components["create-window"].findByType("flash")[0].swf;
                        var id = Ext.getCmp(this.components["create-window"].getId()).form.getId();
                        (function () {
                            swf.get("Inprint.flash.Proxy.setGrid", id);
                        }).defer(10);
                    },
                    actioncomplete: function (form, action) {
                        if (action.type == "submit") {
                            this.components["create-window"].hide()
                            this.cmpReload();
                        }
                    }
                },
                keys: [ _KEY_ENTER_SUBMIT ]
            };

            var flash =  {
                xtype: "flash",
                swfWidth:380,
                swfHeight:360,
                hideMode : 'offsets',
                url      : '/flash/Grid.swf',
                expressInstall: true,
                flashVars: {
                    src: '/flash/Grid.swf',
                    scale :'noscale',
                    autostart: 'yes',
                    loop: 'yes'
                },
                listeners: {
                    scope:this,
                    initialize: function(panel, flash) {
                        alert(2);
                    },
                    afterrender: function(panel) {
                        
                        var init = function () {
                            if (panel.swf.init) {
                                panel.swf.init(panel.getSwfId(), "letter", 0, 0);
                            } else {
                                init.defer(100, this);
                            }
                        };
                        
                        init.defer(100, this);
                        
                    }
                }
            };
            
            win = new Ext.Window({
                width:700,
                height:500,
                modal:true,
                layout: "border",
                closeAction: "hide",
                title: _("Adding a new category"),
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
                    }
                },
                buttons: [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ]
            });
            
        }
        
        win.show(this);
        this.components["create-window"] = win;
        
        var form = win.form.getForm();
        form.reset();
        
        form.baseParams = {
            edition: this.parent.edition
        };
    },

    cmpUpdate: function() {

        var win = this.components["update-window"];
        if (!win) {

            var form = {
                xtype: "form",
                frame:false,
                border:false,
                labelWidth: 75,
                url: this.urls["update"],
                bodyStyle: "padding:5px 5px",
                baseParams: {
                    edition: this.parent.edition
                },
                defaults: {
                    anchor: "100%",
                    allowBlank:false
                },
                items: [
                    _FLD_HDN_ID,
                    _FLD_HDN_FASCICLE,
                    _FLD_HDN_HEADLINE,
                    _FLD_SHORTCUT,
                    _FLD_TITLE,
                    _FLD_DESCRIPTION
                ],
                listeners: {
                    scope:this,
                    beforeaction: function(form, action) {
                        if (action.type == "submit") {
                            var swf = this.components["update-window"].findByType("flash")[0].swf;
                            var id = Ext.getCmp(this.components["update-window"].getId()).form.getId();
                            (function () {
                                swf.get("Inprint.flash.Proxy.setGrid", id);
                            }).defer(10);
                        }
                    },
                    actioncomplete: function (form, action) {
                        if (action.type == "load") {
                            
                            var swf = this.components["update-window"].findByType("flash")[0].swf;
                            
                            var load = function () {
                                if (swf.init) {
                                    swf.set(action.result.data.w, action.result.data.h);
                                } else {
                                    load.defer(100, this);
                                }
                            };
                            
                            load.defer(100, this);
                            
                        }
                        if (action.type == "submit") {
                            this.components["update-window"].hide()
                            this.cmpReload();
                        }
                    }
                },
                keys: [ _KEY_ENTER_SUBMIT ]
            };

            var flash =  {
                xtype: "flash",
                swfWidth:380,
                swfHeight:360,
                hideMode : 'offsets',
                url      : '/flash/Grid.swf',
                expressInstall: true,
                flashVars: {
                    src: '/flash/Grid.swf',
                    scale :'noscale',
                    autostart: 'yes',
                    loop: 'yes'
                },
                listeners: {
                    scope:this,
                    initialize: function(panel, flash) {
                        alert(2);
                    },
                    afterrender: function(panel) {
                        
                        var init = function () {
                            if (panel.swf.init) {
                                panel.swf.init(panel.getSwfId(), "letter", 0, 0);
                            } else {
                                init.defer(100, this);
                            }
                        };
                        
                        init.defer(100, this);
                        
                    }
                }
            };
            
            win = new Ext.Window({
                width:700,
                height:500,
                modal:true,
                layout: "border",
                closeAction: "hide",
                title: _("Adding a new category"),
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
                    }
                },
                buttons: [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ]
            });
            
        }

        win.show(this);
        this.components["update-window"] = win;

        var form = win.form.getForm();
        form.reset();
        
        form.load({
            url: this.urls.read,
            scope:this,
            params: {
                id: this.getValue("id")
            },
            failure: function(form, action) {
                Ext.Msg.alert("Load failed", action.result.errorMessage);
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
    }

});
