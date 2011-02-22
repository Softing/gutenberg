Inprint.advert.requests.Grid = Ext.extend(Ext.grid.GridPanel, {

    initComponent: function() {

        this.components = {};
        this.urls = {
            "create": _url("/advertising/requests/create/"),
            "read":   _url("/advertising/requests/read/"),
            "update": _url("/advertising/requests/update/"),
            "delete": _url("/advertising/requests/delete/")
        }

        this.store = Inprint.factory.Store.json("/advertising/requests/list/");
        
        this.selectionModel = new Ext.grid.CheckboxSelectionModel();

        Ext.apply(this, {
            border: false,
            stripeRows: true,
            columnLines: true,
            sm: this.selectionModel,
            autoExpandColumn: "title",
            columns: [
                this.selectionModel,
                {
                    id:"searial",
                    header: _("Serial"),
                    width: 40,
                    sortable: true,
                    dataIndex: "serialnum"
                },
                {
                    id:"fascicle",
                    header: _("Fascicle"),
                    width: 60,
                    sortable: true,
                    dataIndex: "fascicle_shortcut"
                },
                {
                    id:"manager",
                    header: _("Manager"),
                    width: 100,
                    sortable: true,
                    dataIndex: "manager_shortcut"
                },
                {
                    id:"advertiser",
                    header: _("Advertiser"),
                    width: 150,
                    sortable: true,
                    dataIndex: "advertiser_shortcut"
                },
                {
                    id:"title",
                    header: _("Title"),
                    width: 350,
                    sortable: true,
                    dataIndex: "title"
                },
                {
                    id:"position",
                    header: _("Position"),
                    width: 90,
                    sortable: true,
                    dataIndex: "place_shortcut"
                },
                {
                    id:"page",
                    header: _("Page"),
                    width: 50,
                    sortable: true,
                    dataIndex: "seqnum"
                },
                {
                    id:"modsize",
                    header: _("Module size"),
                    width: 90,
                    sortable: true,
                    dataIndex: "x"
                },
                {
                    id:"modified",
                    header: _("Last Modified"),
                    width: 90,
                    sortable: true,
                    dataIndex: "updated"
                },

                {
                    id:"status",
                    header: _("Status"),
                    width: 90,
                    sortable: true,
                    dataIndex: "status"
                },
                {
                    id:"payment",
                    header: _("Payment"),
                    width: 90,
                    sortable: true,
                    dataIndex: "payment"
                },
                {
                    id:"readiness",
                    header: _("Readiness"),
                    width: 90,
                    sortable: true,
                    dataIndex: "readiness"
                }
            ],

            tbar: [
                {
                    icon: _ico("plus-button"),
                    cls: "x-btn-text-icon",
                    text: _("Add"),
                    ref: "../btnCreate",
                    scope:this,
                    handler: this.cmpCreate
                },
                {
                    icon: _ico("pencil"),
                    cls: "x-btn-text-icon",
                    text: _("Update"),
                    disabled:true,
                    ref: "../btnUpdate",
                    scope:this,
                    handler: this.cmpUpdate
                },
                '-',
                {
                    icon: _ico("minus-button"),
                    cls: "x-btn-text-icon",
                    text: _("Remove"),
                    disabled:true,
                    ref: "../btnDelete",
                    scope:this,
                    handler: this.cmpDelete
                }
            ]
        });

        Inprint.advert.requests.Grid.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.advert.requests.Grid.superclass.onRender.apply(this, arguments);
    },
    
    cmpCreate: function() {

        var xc = Inprint.factory.Combo;

        var win = this.components["create-window"];
        if (!win) {

            var form = new Ext.FormPanel({
                border:false,
                labelWidth: 75,
                url: this.urls.create,
                bodyStyle: "padding:5px 5px",
                plugins: new Ext.ux.DataTip(),
                defaults: {
                    anchor: "100%",
                    allowBlank:false
                },
                items: [
                    _FLD_HDN_EDITION,
                    {
                        xtype: "textfield",
                        allowBlank:false,
                        hideLabel:true,
                        name: "title",
                        fieldLabel: _("Title"),
                        emptyText: _("Title"),
                        tooltip: 'Название заявки'
                    },
                    {
                        xtype: "textarea",
                        allowBlank:true,
                        name: "description",
                        hideLabel:true,
                        fieldLabel: _("Description"),
                        emptyText: _("Description"),
                        tooltip: 'Описание заявки'
                    },
                    
                    {
                        xtype: "titlefield",
                        value: "Заявка"
                    },
                    
                    //xc.getConfig("/advertising/combo/managers/", {
                    //    hideLabel:true,
                    //    editable:true,
                    //    typeAhead: true,
                    //    minChars: 2,
                    //    allowBlank:true,
                    //    listeners: {
                    //        scope: this,
                    //        beforequery: function(qe) {
                    //            delete qe.combo.lastQuery;
                    //        }
                    //    }
                    //}),
                    
                    xc.getConfig("/advertising/combo/advertisers/", {
                        hideLabel:true,
                        editable:true,
                        typeAhead: true,
                        minChars: 2,
                        allowBlank:false,
                        //tooltip: 'Рекламодатель',
                        listeners: {
                            scope: this,
                            beforequery: function(qe) {
                                delete qe.combo.lastQuery;
                            }
                        }
                    }),
                    
                    {
                        xtype: "titlefield",
                        value: "Расположение"
                    },
                    
                    xc.getConfig("/advertising/combo/fascicles/", {
                        hideLabel:true,
                        allowBlank:true,
                        tooltip: 'Выпуск',
                        listeners: {
                            scope: this,
                            select: function(combo) {
                                var form = combo.ownerCt.getForm();
                                form.findField("place").enable();
                                form.findField("place").reset();
                            },
                            beforequery: function(qe) {
                                delete qe.combo.lastQuery;
                            }
                        }
                    }),
                    xc.getConfig("/advertising/combo/places/", {
                        hideLabel:true,
                        disabled:true,
                        allowBlank:true,
                        listeners: {
                            scope: this,
                            select: function(combo) {
                                var form = combo.ownerCt.getForm();
                                form.findField("module").enable();
                                form.findField("module").reset();
                            },
                            beforequery: function(qe) {
                                var form = qe.combo.ownerCt.getForm();
                                qe.combo.getStore().baseParams.fascicle = 
                                    form.findField("fascicle").getValue();
                                delete qe.combo.lastQuery;
                            }
                        }
                    }),
                    xc.getConfig("/advertising/combo/modules/", {
                        hideLabel:true,
                        disabled:true,
                        allowBlank:true,
                        listeners: {
                            scope: this,
                            beforequery: function(qe) {
                                var form = qe.combo.ownerCt.getForm();
                                qe.combo.getStore().baseParams.place = 
                                    form.findField("place").getValue();
                                delete qe.combo.lastQuery;
                            }
                        }
                    }),
                    
                    {
                        xtype: "titlefield",
                        value: "Свойства"
                    },
                    
                    {
                        xtype: "combo",
                        hiddenName: "status",
                        hideLabel:true,
                        editable:false,
                        allowBlank:true,
                        emptyText: _("Select a request status..."),
                        store: {
                            xtype: "arraystore",
                            fields: ['id', 'text'],
                            data : [
                                ["possible ", _("Possible request")],
                                ["active", _("Active request")],
                                ["reservation", _("Reservation")]
                            ]
                        },
                        valueField: "id",
                        displayField:'text',
                        typeAhead: true,
                        mode: 'local',
                        forceSelection: true,
                        triggerAction: 'all',
                        selectOnFocus:true
                    },
                    {
                        xtype: "combo",
                        hiddenName: "payment",
                        hideLabel:true,
                        editable:false,
                        allowBlank:true,
                        emptyText: _("Select a paid status..."),
                        store: {
                            xtype: "arraystore",
                            fields: ['id', 'text'],
                            data : [
                                [ "yes", _("Yes") ],
                                [ "no", _("No") ]
                            ]
                        },
                        valueField: "id",
                        displayField:'text',
                        typeAhead: true,
                        mode: 'local',
                        forceSelection: true,
                        triggerAction: 'all',
                        selectOnFocus:true
                    },
                    {
                        xtype: "combo",
                        hiddenName: "readiness",
                        hideLabel:true,
                        editable:false,
                        allowBlank:true,
                        emptyText: _("Select a willingness..."),
                        store: {
                            xtype: "arraystore",
                            fields: ['id', 'text'],
                            data : [
                                [ "yes", _("Approved") ],
                                [ "no", _("Not approved") ]
                            ]
                        },
                        
                        valueField: "id",
                        displayField:'text',
                        typeAhead: true,
                        mode: 'local',
                        forceSelection: true,
                        triggerAction: 'all'
                    }
                ]
            });

            var view = new Inprint.advert.requests.View({ parent:this.parent });

            win = new Ext.Window({
                border:false,
                title: _("Create request"),
                layout: "border",
                closeAction: "hide",
                width:800, height:510,
                modal:true,
                items: [
                    {
                        title: "Формуляр заявки",
                        region:"west",
                        margins: "0 3 0 0",
                        width: 200,
                        layout:"fit",
                        items: form
                    },
                    {
                        title: "Привязка к полосе",
                        region: "center",
                        margins: "0 0 0 0",
                        layout:"fit",
                        items: view
                    }
                ],
                keys: [ _KEY_ENTER_SUBMIT ],
                buttons: [
                    {
                        text: _("Save"),
                        handler: function() {
                            var win = this.findParentByType('window');
                            var form = win.findByType('form')[0];
                            form.getForm().submit();
                        }
                    },
                    _BTN_CLOSE
                ]
            });

            form.on("actioncomplete", function (form, action) {
                if (action.type == "submit") {
                    win.hide();
                    this.cmpReload();
                }
            }, this);

            this.components["create-window"] = win;
        }

        var form = win.findByType("form")[0].getForm();
        form.reset();
        
        form.findField("edition").setValue( this.parent.currentEdition );
        
        //form.findField("manager").getStore().baseParams.edition = this.parent.currentEdition;
        //form.findField("manager").getStore().baseParams.fascicle = this.parent.currentFascicle;
        //form.findField("manager").setValue(Inprint.session.member.id, Inprint.session.member.shortcut);
        
        form.findField("advertiser").getStore().baseParams.edition = this.parent.currentEdition;
        form.findField("advertiser").getStore().baseParams.fascicle = this.parent.currentFascicle;
        
        form.findField("fascicle").getStore().baseParams.edition = this.parent.currentEdition;
        if (this.parent.currentFascicle) {
            form.findField("fascicle").loadValue( this.parent.currentFascicle );
            form.findField("place").enable();
        }

        win.show();
    },

    cmpUpdate: function() {

        var xc = Inprint.factory.Combo;

        var win = this.components["update-window"];
        if (!win) {

            var form = new Ext.FormPanel({
                border:false,
                labelWidth: 75,
                url: this.urls.update,
                bodyStyle: "padding:5px 5px",
                defaults: {
                    anchor: "100%",
                    allowBlank:false
                },
                items: [
                    _FLD_HDN_ID,
                    {
                        xtype: "textfield",
                        allowBlank:false,
                        hideLabel:true,
                        name: "title",
                        fieldLabel: _("Title"),
                        emptyText: _("Title")
                    },
                    {
                        xtype: "textfield",
                        allowBlank:false,
                        hideLabel:true,
                        name: "shortcut",
                        fieldLabel: _("Shortcut"),
                        emptyText: _("Shortcut")
                    },
                    {
                        xtype: "textarea",
                        allowBlank:true,
                        name: "description",
                        hideLabel:true,
                        fieldLabel: _("Description"),
                        emptyText: _("Description")
                    },
                    
                    {
                        xtype: "titlefield",
                        value: "Заявка"
                    },
                    
                    xc.getConfig("/advertising/combo/managers/", {
                        hideLabel:true,
                        editable:true,
                        typeAhead: true,
                        minChars: 2,
                        allowBlank:true,
                        listeners: {
                            scope: this,
                            beforequery: function(qe) {
                                delete qe.combo.lastQuery;
                            }
                        }
                    }),
                    
                    xc.getConfig("/advertising/combo/advertisers/", {
                        hideLabel:true,
                        editable:true,
                        typeAhead: true,
                        minChars: 2,
                        allowBlank:false,
                        listeners: {
                            scope: this,
                            beforequery: function(qe) {
                                delete qe.combo.lastQuery;
                            }
                        }
                    }),
                    
                    {
                        xtype: "titlefield",
                        value: "Расположение"
                    },
                    
                    xc.getConfig("/advertising/combo/fascicles/", {
                        hideLabel:true,
                        allowBlank:true,
                        listeners: {
                            scope: this,
                            select: function(combo) {
                                var form = combo.ownerCt.getForm();
                                form.findField("place").enable();
                                form.findField("place").reset();
                            },
                            beforequery: function(qe) {
                                delete qe.combo.lastQuery;
                            }
                        }
                    }),
                    xc.getConfig("/advertising/combo/places/", {
                        hideLabel:true,
                        disabled:true,
                        allowBlank:true,
                        listeners: {
                            scope: this,
                            select: function(combo) {
                                var form = combo.ownerCt.getForm();
                                form.findField("module").enable();
                                form.findField("module").reset();
                            },
                            beforequery: function(qe) {
                                var form = qe.combo.ownerCt.getForm();
                                qe.combo.getStore().baseParams.fascicle = 
                                    form.findField("fascicle").getValue();
                                delete qe.combo.lastQuery;
                            }
                        }
                    }),
                    xc.getConfig("/advertising/combo/modules/", {
                        hideLabel:true,
                        disabled:true,
                        allowBlank:true,
                        listeners: {
                            scope: this,
                            beforequery: function(qe) {
                                var form = qe.combo.ownerCt.getForm();
                                qe.combo.getStore().baseParams.place = 
                                    form.findField("place").getValue();
                                delete qe.combo.lastQuery;
                            }
                        }
                    }),
                    
                    {
                        xtype: "titlefield",
                        value: "Свойства"
                    },
                    
                    {
                        xtype: "combo",
                        hiddenName: "status",
                        hideLabel:true,
                        editable:false,
                        allowBlank:true,
                        emptyText: _("Select a request status..."),
                        store: {
                            xtype: "arraystore",
                            fields: ['id', 'text'],
                            data : [
                                ["possible ", _("Possible request")],
                                ["active", _("Active request")],
                                ["reservation", _("Reservation")]
                            ]
                        },
                        valueField: "id",
                        displayField:'text',
                        typeAhead: true,
                        mode: 'local',
                        forceSelection: true,
                        triggerAction: 'all',
                        selectOnFocus:true
                    },
                    
                    {
                        xtype: "combo",
                        hiddenName: "payment",
                        hideLabel:true,
                        editable:false,
                        allowBlank:true,
                        emptyText: _("Select a paid status..."),
                        store: {
                            xtype: "arraystore",
                            fields: ['id', 'text'],
                            data : [
                                [ "yes", _("Yes") ],
                                [ "no", _("No") ]
                            ]
                        },
                        valueField: "id",
                        displayField:'text',
                        typeAhead: true,
                        mode: 'local',
                        forceSelection: true,
                        triggerAction: 'all',
                        selectOnFocus:true
                    },
                    {
                        xtype: "combo",
                        hiddenName: "readiness",
                        hideLabel:true,
                        editable:false,
                        allowBlank:true,
                        emptyText: _("Select a willingness..."),
                        store: {
                            xtype: "arraystore",
                            fields: ['id', 'text'],
                            data : [
                                [ "yes", _("Approved") ],
                                [ "no", _("Not approved") ]
                            ]
                        },
                        
                        valueField: "id",
                        displayField:'text',
                        typeAhead: true,
                        mode: 'local',
                        forceSelection: true,
                        triggerAction: 'all'
                    }
                ]
            });

            var view = new Ext.Panel({
                border:false
            });

            win = new Ext.Window({
                border:false,
                title: _("Edit request"),
                layout: "border",
                closeAction: "hide",
                width:800, height:510,
                modal:true,
                items: [
                    {
                        title: "Формуляр заявки",
                        region:"west",
                        margins: "0 3 0 0",
                        width: 200,
                        layout:"fit",
                        items: form
                    },
                    {
                        title: "Привязка к полосе",
                        region: "center",
                        margins: "0 0 0 0",
                        layout:"fit",
                        items: view
                    }
                ],
                keys: [ _KEY_ENTER_SUBMIT ],
                buttons: [
                    {
                        text: _("Save"),
                        handler: function() {
                            var win = this.findParentByType('window');
                            var form = win.findByType('form')[0];
                            form.getForm().submit();
                        }
                    },
                    _BTN_CLOSE
                ]
            });

            form.on("actioncomplete", function (form, action) {
                if (action.type == "submit") {
                    win.hide();
                    this.cmpReload();
                }
            }, this);

            this.components["update-window"] = win;
        }

        var form = win.findByType("form")[0].getForm();
        form.reset();

        form.load({
            url: this.urls.read,
            scope:this,
            params: {
                id: this.getValue("id")
            },
            success: function(form, action) {
                win.body.unmask();
                var data = action.result.data;
                
                form.findField("id").setValue(data.id);
                
                form.findField("manager").setValue(data.manager, data.manager_shortcut);
                form.findField("advertiser").setValue(data.advertiser, data.advertiser_shortcut);
                
                form.findField("fascicle").setValue(data.fascicle, data.fascicle_shortcut);
                form.findField("place").setValue(data.place, data.place_shortcut);
                form.findField("module").setValue(data.module, data.module_shortcut);
                
                form.findField("status").setValue(data.status);
                form.findField("payment").setValue(data.payment);
                form.findField("readiness").setValue(data.readiness);
                
                if(data.fascicle_shortcut) {
                    form.findField("place").enable();
                }
                
            },
            failure: function(form, action) {
                Ext.Msg.alert("Load failed", action.result.errorMessage);
            }
        });

        win.show(this);
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
