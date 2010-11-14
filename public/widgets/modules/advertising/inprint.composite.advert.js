///*
// * Inprint Content 4.0
// * Copyright(c) 2001-2009, Softing, LLC.
// * licensing@softing.ru
// *
// * http://softing.ru/license
// */
//
//Inprint.Composite2.Advert.Main = function(parent, access)
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
//            this.DemandsPanel = new Inprint.Composite2.Advert.Demands().init(node);
//            this.ModulesPanel = new Inprint.Composite2.Advert.Modules({
//               VarFascicle: this.fascicle
//            });
//            this.ModulesSettg = new Inprint.Composite2.Advert.Settings().init(node);
//
//            this.tabs = new Ext.TabPanel({
//                activeTab: 0,
//                bufferResize:true,
//                deferredRender:true,
//                items: [
//                    
//                    {
//                        title: 'Заявки',
//                        layout:'fit',
//                        items: this.DemandsPanel.object
//                    },
//                    this.ModulesPanel,
//                    {
//                        title: 'Настройка',
//                        layout:'fit',
//                        items: this.ModulesSettg.object
//                    }
//                ]
//            });
//
//            this.object = this.tabs;
//            return this;
//        }
//
//    };
//};