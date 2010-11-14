///*
// * Inprint Content 4.0
// * Copyright(c) 2001-2009, Softing, LLC.
// * licensing@softing.ru
// *
// * http://softing.ru/license
// */
//
//Inprint.Composite2.Advert.Form = function(parent, access)
//{
//    return {
//
//        init: function( node )
//        {
//
//            this.fascicle = node.oid || node.id;
//
//            this.url = {
//                form:   '/advert/request/add/'
//            };
//
//            this.hash = {
//                fascicle: this.fascicle
//            }
//
//            this.form = new Ext.FormPanel({
//                url: this.url.form,
//                labelAlign:'top',
//                hideLabels:true,
//                bodyStyle:'background:#f5f5f5',
//                items: [
//                    Inprint.combo.create('advertiser', {
//                        xtype: 'clearablecombo',
//                        anchor:'100%',
//                        pageSize:13
//                    }),
//                    Inprint.combo.create('fascicle', {
//                        xtype: 'clearablecombo',
//                        anchor:'100%',
//                        baseParams: {
//                            nobriefcase: true
//                        },
//                        listeners: {
//                            scope: this,
//                            select: function(field, record, index)
//                            {
//
//                                var form = this.form.getForm();
//
//                                var page = form.findField('advpage');
//                                page.enable();
//
//                                page.resetStore({
//                                    fascicle: this.fascicle
//                                });
//
//                                var place = form.findField('advplace');
//                                place.enable();
//
//                                place.resetStore({
//                                    fascicle: this.fascicle
//                                });
//
//                                var size = form.findField('advsize');
//                                size.enable();
//
//                                size.resetStore({
//                                    fascicle: this.fascicle
//                                });
//
//                            },
//                            clear: function(combo)
//                            {
//                                this.fascicle = null;
//                                Inprint.form.disable(this.form.getForm(), [ 'advpage', 'advplace', 'advsize' ]);
//                                Inprint.form.reset(this.form.getForm(),   [ 'advpage', 'advplace', 'advsize' ]);
//                            },
//                            render: function(combo)
//                            {
//                                if ( Inprint.session.access['edition.fascicle.composition.manage'] )
//                                {
//                                    combo.enable();
//                                }
//                            }
//                        }
//                    }),
//                    Inprint.combo.create('adv.page', {
//                        xtype: 'clearablecombo',
//                        anchor:'100%',
//                        disabled:true,
//                        listeners: {
//                            scope: this,
//                            beforequery: function(field)
//                            {
//                                var form = this.form.getForm();
//
//                                var hash = {};
//                                hash.fascicle = this.fascicle;
//                                hash.place = form.findField('advplace').getValue();
//                                hash.size  = form.findField('advsize').getValue();
//
//                                form.findField('advpage').resetStore(hash);
//                            },
//                            render: function(field)
//                            {
//                                var form = this.form.getForm();
//                                field.enable();
//                                field.resetStore({
//                                    fascicle: this.fascicle
//                                });
//                            }
//                        }
//                    }),
//                    Inprint.combo.create('adv.place', {
//                        xtype: 'clearablecombo',
//                        anchor:'100%',
//                        disabled:true,
//                        listeners: {
//                            scope: this,
//                            render: function(field)
//                            {
//                                var form = this.form.getForm();
//                                field.enable();
//                                field.resetStore({
//                                    fascicle: this.fascicle
//                                });
//                            }
//                        }
//                    }),
//                    Inprint.combo.create('adv.size', {
//                        xtype: 'clearablecombo',
//                        anchor:'100%',
//                        disabled:true,
//                        listeners: {
//                            scope: this,
//                            render: function(field)
//                            {
//                                field.enable();
//                                field.resetStore({
//                                    fascicle: this.fascicle
//                                });
//                            }
//                        }
//                    }),
//                    {
//                        xtype: 'textarea',
//                        anchor:'100%',
//                        name: 'description',
//                        emptyText: 'Примечания'
//                    }
//                ],
//                buttons: [{
//                    text: 'Добавить заявку',
//                    scope: this,
//                    handler: function() {
//                        this.form.getForm().submit();
//                    }
//                }],
//                listeners: {
//                    scope:this,
//                    actioncomplete: function(form)
//                    {
//                        parent.panels.request.refresh();
//                    },
//                    render: function(panel) {
//                        var form = panel.getForm();
//
//                        form.findField('fascicle').loadValue( this.fascicle );
//
//
//                    }
//                }
//            });
//
//            this.object = this.form;
//            return this;
//        }
//
//    };
//};