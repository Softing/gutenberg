Inprint.fascicle.template.composer.Pages = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.components = {};

        this.urls = {
            "read":   _url("/template/pages/read/"),
            "create": _url("/template/pages/create/"),
            "update": _url("/template/pages/update/"),
            "delete": _url("/template/pages/delete/"),
            "move":   _url("/template/pages/move/"),
            "left":   _url("/template/pages/left/"),
            "right":  _url("/template/pages/right/"),
            "clean":  _url("/template/pages/clean/"),
            "resize": _url("/template/pages/resize/")
        };

        this.view = new Inprint.fascicle.template.composer.View({
            parent: this.parent,
            fascicle: this.oid
        });

        Ext.apply(this, {
            border:false,
            layout: "fit",
            autoScroll:true,
            items: this.view
        });

        Inprint.fascicle.template.composer.Pages.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.fascicle.template.composer.Pages.superclass.onRender.apply(this, arguments);
    },

    getView: function() {
        return this.view;
    },

    getIdByNum: function(num) {
        var id = null;
        var nodes = this.view.getNodes();
        Ext.each(nodes, function(c){
            if (c.getAttribute("seqnum") == num) {
                id = c.id;
            }
        });
        return id;
    },

    getStore: function() {
        return this.view.getStore();
    },

    cmpGetSelected: function () {
        var result = [];
        var records = this.view.getSelectedNodes();
        Ext.each(records, function(c) {
            result.push(c.id +"::"+ c.getAttribute("seqnum"));
        }, this);
        return result;
    },

    cmpPageCreate: function() {

        var wndw = this.components.create;

        if (!wndw) {

            wndw = new Ext.Window({
                title: 'Добавление полос',
                width: 300,
                height: 160,
                modal:true,
                draggable:true,
                layout: "fit",
                closeAction: "hide",
                items: {
                    xtype: "form",
                    border: false,
                    url: this.urls.create,
                    baseParams: {
                        fascicle: this.oid
                    },
                    labelWidth: 100,
                    defaultType: 'checkbox',
                    defaults: { anchor: '100%', hideLabel: true },
                    bodyStyle: 'padding:10px;',
                    listeners: {
                        scope:this,
                        actioncomplete: function() {
                            wndw.hide();
                            this.parent.cmpReload();
                        }
                    },
                    items: [

                        {
                            xtype: 'textfield',
                            name: 'page',
                            emptyText: 'Полосы',
                            allowBlank:false
                        },

                        Inprint.factory.Combo.getConfig("/template/combos/headlines/", {
                            allowBlank:false,
                            baseParams:{
                                fascicle: this.oid
                            },
                            listeners: {
                                beforequery: function(qe) {
                                    delete qe.combo.lastQuery;
                                }
                            }
                        }),

                        Inprint.factory.Combo.getConfig("/template/combos/templates/", {
                            allowBlank:false,
                            baseParams:{
                                fascicle: this.oid
                            },
                            listeners: {
                                beforequery: function(qe) {
                                    delete qe.combo.lastQuery;
                                }
                            }
                        })
                    ]
                },
                buttons: [
                    _BTN_WNDW_ADD,
                    _BTN_WNDW_CANCEL
                ]
            });

            this.components.create = wndw;
        }

        var form = wndw.findByType("form")[0].getForm();
        form.reset();
        wndw.show();

    },

    // Редактировать
    cmpPageUpdate: function() {

        var wndw = this.components.update;

        if (!wndw) {

            wndw = new Ext.Window({
                title: 'Редактировать полосы',
                width: 300,
                height: 160,
                modal:true,
                draggable:true,
                layout: "fit",
                closeAction: "hide",
                items: {
                    xtype: "form",
                    border: false,
                    url: this.urls.update,
                    baseParams: {
                        fascicle: this.oid
                    },
                    labelWidth: 100,
                    defaultType: 'checkbox',
                    defaults: { anchor: '100%', hideLabel: true },
                    bodyStyle: 'padding:10px;',
                    listeners: {
                        scope:this,
                        actioncomplete: function() {
                            wndw.hide();
                            this.parent.cmpReload();
                        }
                    },
                    items: [
                        Inprint.factory.Combo.getConfig("/template/combos/headlines/", {
                            allowBlank:false,
                            baseParams:{
                                fascicle: this.oid
                            },
                            listeners: {
                                beforequery: function(qe) {
                                    delete qe.combo.lastQuery;
                                }
                            }
                        }),

                        Inprint.factory.Combo.getConfig("/template/combos/templates/", {
                            allowBlank:false,
                            baseParams:{
                                fascicle: this.oid
                            },
                            listeners: {
                                beforequery: function(qe) {
                                    delete qe.combo.lastQuery;
                                }
                            }
                        })
                    ]
                },
                buttons: [
                    _BTN_WNDW_OK,
                    _BTN_WNDW_CANCEL
                ]
            });

            this.components.update = wndw;
        }

        wndw.show();

        var form = wndw.findByType("form")[0].getForm();
        form.reset();
        form.baseParams.page = this.cmpGetSelected();
        wndw.show();
    },

    cmpPageCompose: function() {

        var selection = this.cmpGetSelected();

        if (selection.length > 2) {
            return;
        }

        if (selection.length <= 0) {
            return;
        }

        var wndw = new Inprint.cmp.Composer({
            fascicle: this.parent.fascicle,
            selection: selection
        });

        wndw.on("actioncomplete", function() {
            wndw.hide();
            this.parent.cmpReload();
        }, this);

        wndw.show();
    },

    //Переместить
    cmpPageMove: function(inc, text) {

        if ( inc == 'cancel') {
            return;
        }

        if ( inc == 'ok') {
            Ext.Ajax.request({
                url: this.urls.move,
                params: {
                    fascicle: this.oid,
                    after: text,
                    page: this.cmpGetSelected()
                },
                scope: this,
                success: function() {
                    this.parent.cmpReload();
                }
            });
            return;
        }

        Ext.MessageBox.prompt(
            'Перемещение полос',
            'Укажите номер полосы, после которой будут размещены выбранные полосы',
            this.cmpPageMove, this
        );

    },

    cmpPageMoveLeft: function(inc, text) {

        if ( inc == 'cancel') {
            return;
        }

        if ( inc == 'ok') {
            Ext.Ajax.request({
                url: this.urls.left,
                params: {
                    fascicle: this.oid,
                    amount: text,
                    page: this.cmpGetSelected()
                },
                scope: this,
                success: function() {
                    this.parent.cmpReload();
                }
            });
            return;
        }

        Ext.MessageBox.prompt(
            'Cмещение влево',
            'На сколько полос сместить?',
            this.cmpPageMoveLeft, this
        );

    },

    cmpPageMoveRight: function(inc, text) {

        if ( inc == 'cancel') {
            return;
        }

        if ( inc == 'ok') {
            Ext.Ajax.request({
                url: this.urls.right,
                params: {
                    fascicle: this.oid,
                    amount: text,
                    page: this.cmpGetSelected()
                },
                scope: this,
                success: function() {
                    this.parent.cmpReload();
                }
            });
            return;
        }

        Ext.MessageBox.prompt(
            'Cмещение вправо',
            'На сколько полос сместить?',
            this.cmpPageMoveRight, this
        );

    },


    //Удалить
    cmpPageDelete: function(inc) {
        if ( inc == 'no') {
            return;
        }
        if ( inc == 'yes') {
            Ext.Ajax.request({
                url: this.urls["delete"],
                params: {
                    fascicle: this.oid,
                    page: this.cmpGetSelected()
                },
                scope: this,
                success: function() {
                    this.parent.cmpReload();
                }
            });
        } else {
            Ext.MessageBox.confirm(
                'Подтверждение',
                'Вы действительно хотите безвозвратно удалить полосы?',
                this.cmpPageDelete, this
            );
        }
    }

});
