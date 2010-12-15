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

            var form = new Ext.FormPanel({
                
                flex: 1,
                
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
                keys: [ _KEY_ENTER_SUBMIT ],
                buttons: [ _BTN_ADD,_BTN_CLOSE ]
            });

            var flash =  new Ext.FlashComponent({
                flex:2,
                hideMode : 'offsets',
                url      : '/flash/Grid.swf',
                expressInstall: true,
                flashVars: {
                    src: '/flash/Grid.swf',
                    scale :'exactfit',
                    autostart: 'yes',
                    loop: 'yes'
                },
                listeners: {
                    scope:this,
                    render: function(panel, flash) {
                        alert( panel.getSwfId() );
                    }
                }
            });
            
            //{
            //    flex:2,
            //    xtype:"flashpanel",
            //    mediaCfg: {
            //        url    : '/flash/Grid.swf',
            //        style  : { width:'380px', height:'360px' },
            //        start  : true,
            //        loop   : true,
            //        controls :true,
            //        params: {
            //            wmode :'opaque',
            //            scale :'exactfit',
            //            //salign :'t',
            //            allowScriptAccess: "sameDomain"
            //        }
            //    },
            //    onFlashInit: function() {
            //        alert(1);
            //    },
            //    listeners: {
            //        scope:this,
            //        flashinit: function(panel, flash) {
            //            alert(2);
            //        }
            //    }
            //};

            win = new Ext.Window({
                title: _("Adding a new category"),
                closeAction: "hide",
                width:600, height:400,
                layout: "hbox",
                layoutConfig: {
                    align : 'stretch',
                    pack  : 'start'
                },
                items: [
                    form,
                    flash
                ]
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
