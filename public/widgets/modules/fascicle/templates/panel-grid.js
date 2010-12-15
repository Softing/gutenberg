Inprint.fascicle.templates.Pages = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            "create":  _url("/fascicle/rubrics/create/"),
            "read":    _url("/fascicle/rubrics/read/"),
            "update":  _url("/fascicle/rubrics/update/"),
            "delete":  _url("/fascicle/rubrics/delete/")
        };

        this.store = Inprint.factory.Store.json("/fascicle/rubrics/list/");
        
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        this.columns = [
            this.selectionModel,
            {
                id:"name",
                header: _("Shortcut"),
                width: 160,
                sortable: true,
                dataIndex: "shortcut"
            },
            {
                id:"description",
                header: _("Description"),
                dataIndex: "description"
            }
        ];

        this.tbar = [
            {
                icon: _ico("plus-button"),
                cls: "x-btn-text-icon",
                text: _("Add"),
                disabled: true,
                ref: "../btnCreate",
                scope:this,
                handler: function() { this.cmpCreate(); }
            },
            {
                icon: _ico("pencil"),
                cls: "x-btn-text-icon",
                text: _("Edit"),
                disabled: true,
                ref: "../btnUpdate",
                scope:this,
                handler: function() { this.cmpUpdate(); }
            },
            "-",
            {
                icon: _ico("minus-button"),
                cls: "x-btn-text-icon",
                text: _("Delete"),
                disabled: true,
                ref: "../btnDelete",
                scope:this,
                handler: function() { this.cmpDelete(); }
            }
        ];

        Ext.apply(this, {
            border: false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "description"
        });

        Inprint.fascicle.templates.Pages.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.fascicle.templates.Pages.superclass.onRender.apply(this, arguments);
    },
    
    cmpCreate: function() {

        var win = this.components["add-window"];

        if (!win) {

            var form = {
                
                xtype: "form",
                
                url: this.urls.create,
                frame:false,
                border:false,
                
                labelWidth: 75,
                defaults: {
                    anchor: "100%",
                    allowBlank:false
                },
                bodyStyle: "padding:5px 5px",
                items: [
                    _FLD_HDN_FASCICLE,
                    _FLD_HDN_HEADLINE,
                    _FLD_TITLE,
                    _FLD_SHORTCUT,
                    _FLD_DESCRIPTION
                ],
                listeners: {
                    scope:this,
                    beforeaction: function(form, action) {
                        var swf = this.components["add-window"].findByType("flash")[0].swf;
                        
                        var id = Ext.getCmp(this.components["add-window"].getId()).form.getId();
                        
                        var get = function () {
                            swf.get("Inprint.flash.Proxy.setGrid", id);
                        }
                        get.defer(100);
                        //alert(2);
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
                            panel.swf.init(panel.getSwfId(), "letter", 0, 0);
                        };
                        init.defer(300);
                    }
                }
            };
            
            win = new Ext.Window({
                title: _("Adding a new category"),
                closeAction: "hide",
                width:700,
                height:500,
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
                    }
                },
                buttons: [ _BTN_WNDW_ADD, _BTN_WNDW_CLOSE ]
            });
            
        }

        //var form = win.items.first().getForm();
        //form.reset();
        //
        //form.findField("fascicle").setValue(this.parent.fascicle);
        //form.findField("headline").setValue(this.parent.headline);

        win.show(this);
        this.components["add-window"] = win;
    },

    cmpUpdate: function() {

        var win = this.components["edit-window"];

        if (!win) {

            var form = new Ext.FormPanel({
                url: this.urls.update,
                frame:false,
                border:false,
                labelWidth: 75,
                defaults: {
                    anchor: "100%",
                    allowBlank:false
                },
                bodyStyle: "padding:5px 5px",
                items: [
                    _FLD_HDN_ID,
                    _FLD_TITLE,
                    _FLD_SHORTCUT,
                    _FLD_DESCRIPTION
                ],
                keys: [ _KEY_ENTER_SUBMIT ],
                buttons: [ _BTN_SAVE,_BTN_CLOSE ]
            });

            win = new Ext.Window({
                title: _("Edit category"),
                layout: "fit",
                closeAction: "hide",
                width:400, height:220,
                items: form
            });

            form.on("actioncomplete", function (form, action) {
                if (action.type == "submit") {
                    win.hide();
                    this.cmpReload();
                }
            }, this);
        }

        win.show(this);
        win.body.mask(_("Loading..."));
        this.components["edit-window"] = win;

        var form = win.items.first().getForm();
        form.reset();

        form.load({
            url: this.urls.read,
            scope:this,
            params: {
                id: this.getValue("id")
            },
            success: function(form, action) {
                win.body.unmask();
                form.findField("id").setValue(action.result.data.id);
            }
        });
    },

    cmpDelete: function() {

        var title = _("Deleting a category");

        Ext.MessageBox.confirm(
            title,
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
