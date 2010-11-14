///*
// * Inprint Content 4.0
// * Copyright(c) 2001-2009, Softing, LLC.
// * licensing@softing.ru
// *
// * http://softing.ru/license
// */
//
//Inprint.Composite2.Advert.Demands = function(parent, access)
//{
//    return {
//
//        init: function(node)
//        {
//
//            this.access = {
//                edit:true
//            };
//
//            this.fascicle = node.oid || node.id;
//
//            this.panels = {};
//
//            this.panels.form  = new Inprint.Composite2.Advert.Form(this, access);
//            this.panels.form.init( node );
//
//            this.panels.list  = new Inprint.Composite2.Advert.List(this, access);
//            this.panels.list.init( node );
//
//            this.panels.request  = new Inprint.Composite2.Advert.Request(this, access);
//            this.panels.request.init( node );
//
//            this.panel = new Ext.Panel({
//                object: this,
//                layout: 'border',
//                items: [
//                    {
//                        region: 'west',
//                        layout: 'border',
//                        split: true,
//                        width: 300,
//                        items: [
//                            {
//                                region: 'west',
//                                layout: 'fit',
//                                split: true,
//                                width: 150,
//                                items: this.panels.list.object
//                            },
//                            {
//                                region: 'center',
//                                //layout: 'fit',
//                                width: 150,
//                                bodyStyle:'padding:5px;background:#f5f5f5',
//                                items: this.panels.form.object
//
//                            }
//                        ]
//                    },
//                    {
//                        region: 'center',
//                        layout: 'fit',
//                        items: this.panels.request.object
//                    }
//                ]
//            });
//            this.object = this.panel;
//			
//            return this;
//        },
//
//        window: function( btn, scope, params )
//        {
//            return Ext.apply({
//                width: 400,
//                height: 300,
//                buttons: [{
//                    text: btn,
//                    scope: scope,
//                    handler: function() {
//                        this.dialog.current.items.itemAt(0).getForm().submit();
//                    }
//                }, {
//                    text: Inprint.str.cancel,
//                    scope: scope,
//                    handler: function() {
//                        this.dialog.current.hide();
//                        this.dialog.current = false;
//                    }
//                }],
//                keys: [{
//                    key: 27,
//                    scope:scope,
//                    fn: function() {
//                        this.dialog.current.hide();
//                        this.dialog.current = false;
//                    }
//                }]
//            }, params);
//        },
//
//        form: function( scope, params )
//        {
//            return Ext.apply({
//                baseParams: {
//                    edition: Inprint.session.edition,
//                    fascicle: this.fascicle
//                },
//                bodyStyle: 'padding:5px 5px 0;',
//                defaults: { anchor: '100%' },
//                labelWidth: 100,
//                listeners: {
//                    scope: scope,
//                    actioncomplete: function(form)
//                    {
//                        if (this.dialog.current)
//                        {
//                            this.dialog.current.hide();
//                            this.dialog.current = false;
//                        }
//                        this.refresh();
//                    }
//                }
//
//            }, params);
//        }
//
//    };
//};