///*
// * Inprint Content 4.0
// * Copyright(c) 2001-2009, Softing, LLC.
// * licensing@softing.ru
// *
// * http://softing.ru/license
// */
//
//Inprint.Composite2.Advert.Settings = function(parent, access)
//{
//    return {
//
//        init: function( node )
//        {
//
//            this.fascicle = node.oid   || node.id;
//
//            // Create places
//            this.places = new Inprint.Factory.Tree();
//            this.places.init({
//                base: {
//                    fascicle: this.fascicle
//                },
//                url:{
//                    load:'/advert/settings/places/',
//                    add:'/advert/settings/places/add/',
//                    edit:'/advert/settings/places/edit/',
//                    remove:'/advert/settings/places/remove/'
//                },
//                access: {
//                    edit:true
//                },
//                locale:{
//                    cmpTitle:       "Позиция",
//                    btnAdd:         Inprint.str.add,
//                    ttpAdd:         Inprint.str['addition of the catchword'],
//                    btnEdit:        Inprint.str.edit,
//                    ttpEdit:        Inprint.str['editing of the catchword'],
//                    btnRemove:      Inprint.str.remove,
//                    ttpRemove:      Inprint.str['addition of the rubric'],
//                    dlgRemoveTitle: 'Удаление рекламного места',
//                    dlgRemoveBody:  'Удалить рекламное место? Все размеры для этого места будут удалены!'
//                }
//            });
//
//            // Create sizes
//            this.sizes = new Inprint.Factory.Tree();
//            this.sizes.init({
//                base: {
//                    fascicle: this.fascicle
//                },
//                url:{
//                    load:'/advert/settings/sizes/',
//                    add:'/advert/settings/sizes/add/',
//                    edit:'/advert/settings/sizes/edit/',
//                    remove:'/advert/settings/sizes/remove/'
//                },
//                access: {
//                    edit:true
//                },
//                locale:{
//                    cmpTitle:       "Размеры"
//                }
//            });
//
//            // Create matrix grid
//            this.matrix = new Inprint.Factory.Grid();
//            this.matrix.extend = function()
//            {
//                
//                this.config.cm = [
//                    {   header: Inprint.str.name,
//                        width: 130,
//                        dataIndex: 'size'
//                    }, {
//                        header: Inprint.str.description,
//                        width: 300,
//                        dataIndex: 'description'
//                    }, {
//                        header: 'place',
//                        dataIndex: 'place',
//                        hidden:true
//                    }, {
//                        header: 'group',
//                        dataIndex: 'group',
//                        hidden:true
//                    }
//                ];
//
//                this.config.view = new Ext.grid.GroupingView({
//                    forceFit: false,
//                    hideGroupedColumn:true,
//                    showGroupName: false
//                });
//
//                //this.config.store.autoLoad = true;
//                this.config.store.type = 'group';
//                this.config.store.groupField ='place';
//                this.config.store.sortInfo = { field: 'place', direction: 'ASC' };
//                this.config.store.reader = { id: 'uuid', fields: [ 'uuid', 'group', 'selected', 'place', 'size', 'title','description'] };
//
//                this.config.store.listeners.load = function()
//                {
//
//                    if ( this.cmp.getTopToolbar().items ) 
//                    {
//                        if (this.access.edit) 
//                        {
//                            this.cmp.getTopToolbar().items.get('save').enable();
//                        }
//                        else 
//                        {
//                            this.cmp.getTopToolbar().items.get('save').disable();
//                        }
//                    }
//                    
//                    this.fill();
//                };
//                
//                this.config.tbar = [
//                    {
//                        id: 'save',
//                        text: Inprint.str.save,
//                        tooltip:Inprint.str['save'],
//                        disabled: true,
//                        icon: _icon("disk-black"),
//                        cls: 'x-btn-text-icon',
//                        scope: this,
//                        handler: function()
//                        {
//
//                            var data = [];
//                            Ext.each(this.cmp.getSelectionModel().getSelections(), function(record)
//                            {
//                                this.push(record.data.uuid);
//                            }, data);
//
//                            var query = new Inprint.Factory.Query({
//                                url: this.params.url.save,
//                                params: Ext.apply(this.params.base, {
//                                    matrix: data
//                                }),
//                                scope: this,
//                                success: function()
//                                {
//                                    this.fireEvent('saved', this);
//                                    this.reload();
//                                }
//                            });
//                            
//                        }
//                    }
//                ];
//                
//            };
//            this.matrix.init({
//                base: {
//                    fascicle: this.fascicle
//                },
//                url:{
//                    load:'/advert/settings/matrix/',
//                    save:'/advert/settings/matrix/save/'
//                },
//                access: {
//                    edit:true
//                },
//                locale:{
//                    cmpTitle:       "Grid",
//                    cmpEmptyText:   'Размеры не найдены или не были добавлены, пожалуйста добавьте размеры',
//                    btnAdd:         Inprint.str.add,
//                    ttpAdd:         Inprint.str['addition of the catchword'],
//                    btnEdit:        Inprint.str.edit,
//                    ttpEdit:        Inprint.str['editing of the catchword'],
//                    btnRemove:      Inprint.str.remove,
//                    ttpRemove:      Inprint.str['addition of the rubric'],
//                    dlgRemoveTitle: 'Удаление рекламного места',
//                    dlgRemoveBody:  'Удалить рекламное место? Все размеры для этого места будут удалены!'
//                }
//            });
//
//            // link events
////            this.places.on('clicked', function(obj, node)
////            {
////                this.matrix.params.base.place = node.attributes.id;
////                this.matrix.reload();
////            }, this);
////
////            this.places.on('reloaded', function(obj, node)
////            {
////                this.matrix.params.base.place = null;
////                this.matrix.reload();
////            }, this);
////
////            this.sizes.on('added', function(obj, node)
////            {
////                this.matrix.params.base.place = node.attributes.id;
////                this.matrix.reload();
////            }, this);
////
////            this.sizes.on('edited', function(obj, node)
////            {
////                this.matrix.params.base.place = null;
////                this.matrix.reload();
////            }, this);
////
////            this.sizes.on('removed', function(obj, node)
////            {
////                this.matrix.params.base.place = null;
////                this.matrix.reload();
////            }, this);
//
//            // Create object
//            this.object = new Ext.Panel({
//                layout: 'border',
//                items: [
//                    {
//                        region: 'west',
//                        split: true,
//                        width: '20%',
//                        layout: 'border',
//                        items: [
//                            {
//                                region: 'north',
//                                split: true,
//                                height: 300,
//                                layout: 'fit',
//                                items: this.places.cmp
//                            }, {
//                                region: 'center',
//                                layout: 'fit',
//                                items: this.sizes.cmp
//                            }
//                        ]
//                    }, {
//                        region: 'center',
//                        layout: 'fit',
//                        items: this.matrix.cmp
//                    }
//                ]
//            });
//
//            return this;
//        }
//
//    }
//};