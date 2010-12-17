//Inprint.cmp.composer.Modules = Ext.extend(Ext.Panel, {
//
//    initComponent: function() {
//        
//        this.params = {};
//        this.components = {};
//        
//        this.urls = {
//            "read":   _url("/fascicle/pages/read/")
//        }
//
//        var selection = this.parent.selection;
//        var selLength = this.parent.selLength;
//
//        var pages = [];
//        for (var c = 1; c < selection.length+1; c++) {
//            var array = selection[c-1].split("::");
//            pages.push(array[0]);
//        }
//        
//        
//        var panelItems = [];
//        
//        var gridLeft = new Inprint.cmp.composer.GridModules({
//            parent: this.parent
//        });
//        
//        panelItems.push( gridLeft );
//        
//        //if ( selLength == 2 ) {
//        //    
//        //    flashWidth = 600;
//        //    
//        //    flashRight =  {
//        //        id: 'flash-'+ pages[1],
//        //        xtype: "flash",
//        //        width:300,
//        //        hideMode : 'offsets',
//        //        url      : '/flash/Dispose.swf',
//        //        expressInstall: true,
//        //        flashVars: {
//        //            src: '/flash/Dispose.swf',
//        //            scale :'noscale',
//        //            autostart: 'yes',
//        //            loop: 'yes'
//        //        },
//        //        listeners: {
//        //            scope:this,
//        //            afterrender: function(panel) {
//        //                 
//        //                var init = function () {
//        //                    var record = this.params[panel.id];
//        //                    if (panel.swf.init && record) {
//        //                        panel.swf.init(panel.getSwfId(), "letter", 0, 0);
//        //                        panel.swf.setGrid( record.w, record.h );
//        //                    } else {
//        //                        init.defer(10, this);
//        //                    }
//        //                };
//        //                 
//        //                init.defer(10, this);
//        //                
//        //            }
//        //        }
//        //    };
//        //    
//        //    flashItems.push( flashRight );
//        //}
//        
//        Ext.apply(this, {
//            region: "center",
//            margins: "3 0 3 3",
//            layout:"vbox",
//            layoutConfig: {
//                align : 'stretch',
//                pack  : 'start'
//            },
//            items: panelItems
//        });
//
//        Inprint.cmp.composer.Modules.superclass.initComponent.apply(this, arguments);
//
//    },
//
//    onRender: function() {
//        Inprint.cmp.composer.Modules.superclass.onRender.apply(this, arguments);
//    }
//    
//    
//
//});
