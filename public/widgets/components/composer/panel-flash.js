Inprint.cmp.composer.Flash = Ext.extend(Ext.Panel, {

    initComponent: function() {
        
        this.params = {};
        this.components = {};
        
        this.saveCounter = 0;
        
        this.urls = {
            "init":   _url("/fascicle/composer/initialize/"),
            "save":   _url("/fascicle/composer/save/")
        }

        var selection = this.parent.selection;
        var selLength = this.parent.selLength;

        this.pages = [];
        for (var c = 1; c < selection.length+1; c++) {
            var array = selection[c-1].split("::");
            this.pages.push(array[0]);
        }
        
        var selLength = selection.length;
        var flashItems = [];
        var flashWidth = 300;
        var flashLeft;
        var flashRight;
    
        flashLeft =  {
            id: 'flash-'+ this.pages[0],
            xtype: "flash",
            width:300,
            hideMode : 'offsets',
            url      : '/flash/Dispose.swf',
            expressInstall: true,
            flashVars: {
                src: '/flash/Dispose.swf',
                scale :'noscale',
                autostart: 'yes',
                loop: 'yes'
            },
            listeners: {
                scope:this,
                afterrender: function(panel) {
                     
                    //var init = function () {
                    //    if (panel.swf.init) {
                    //        var record = this.params[panel.id];
                    //        panel.swf.init(panel.getSwfId(), "letter", 0, 0);
                    //        //panel.swf.setGrid( record.w, record.h );
                    //    } else {
                    //        init.defer(10, this);
                    //    }
                    //};
                    // 
                    //init.defer(10, this);
                    
                }
            }
        };
        
        flashItems.push( flashLeft );
        
        if ( selLength == 2 ) {
            
            flashWidth = 600;
            
            flashRight =  {
                id: 'flash-'+ this.pages[1],
                xtype: "flash",
                width:300,
                hideMode : 'offsets',
                url      : '/flash/Dispose.swf',
                expressInstall: true,
                flashVars: {
                    src: '/flash/Dispose.swf',
                    scale :'noscale',
                    autostart: 'yes',
                    loop: 'yes'
                },
                listeners: {
                    scope:this,
                    afterrender: function(panel) {
                         
                        //var init = function () {
                        //    var record = this.params[panel.id];
                        //    if (panel.swf.init && record) {
                        //        panel.swf.init(panel.getSwfId(), "letter", 0, 0);
                        //        //panel.swf.setGrid( record.w, record.h );
                        //    } else {
                        //        init.defer(10, this);
                        //    }
                        //};
                        // 
                        //init.defer(10, this);
                        
                    }
                }
            };
            
            flashItems.push( flashRight );
        }
        
        Ext.apply(this, {
            region:"east",
            margins: "3 3 3 0",
            width: this.parent.selLength*300,
            minSize: 200,
            maxSize: 600,
            layout:"hbox",
            layoutConfig: {
                align : 'stretch',
                pack  : 'start'
            },
            items: flashItems
        });

        Inprint.cmp.composer.Flash.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        
        Inprint.cmp.composer.Flash.superclass.onRender.apply(this, arguments);
        
        this.cmpInit();
        
        //Ext.Ajax.request({
        //    url: this.urls["init"],
        //    params: {
        //        page: this.parent.selection
        //    },
        //    scope: this,
        //    success: function(result, request) {
        //        
        //        var responce = Ext.util.JSON.decode(result.responseText);
        //        
        //        for (var c = 0; c < responce.data.length; c++) {
        //            
        //            var id = responce.data[c].id;
        //            var swf = this.findById('flash-'+ id).swf;
        //            var record = responce.data[c];
        //            
        //            this.params['flash-'+id] = record;
        //            
        //        }
        //    }
        //});
        
    },
    
    cmpGetFlashById: function(id) {
        var panel = this.findById('flash-'+ id)
        if (panel) {
            return panel.swf;
        }
        return null;
    },
    
    cmpInit: function() {
        
        Ext.Ajax.request({
            url: this.urls["init"],
            scope:this,
            success: function ( result, request ) {
                
                var responce = Ext.util.JSON.decode(result.responseText);
                
                Ext.each(responce.data.pages, function(c) {
                    var flash = this.cmpGetFlashById(c.id);
                    if (flash) {
                        var init = function() {
                            if (flash.init) {
                                flash.init(c.id, "letter", 0, 0);
                                flash.setGrid( c.w, c.h );
                            } else {
                                init.defer(10, this);
                            }
                        }
                        init.defer(10, this);
                    }
                }, this);
                
                Ext.each(responce.data.modules, function(c) {
                    var flash = this.cmpGetFlashById(c.page);
                    if (flash){
                        var set = function() {
                            if (flash.setBlock) {
                                flash.setBlock(c.id, c.shortcut, c.x, c.y, c.w, c.h );
                            } else {
                                set.defer(10, this);
                            }
                        }
                        set.defer(10, this);
                    }
                }, this);
                
            },
            params: { page: this.pages }
        });
        
    },
    
    cmpSetBlocks: function(records) {
        Ext.each(records, function(c) {
            //var flash = this.cmpGetFlashById(c.page);
            //alert(c.page +'-'+ flash);
            //flash.deleteAllBlocks();
        }, this);
    },
    
    cmpMoveBlocks: function(records) {
        Ext.each(records, function(c) {
            var flash = this.cmpGetFlashById(c.page);
            if (flash) {
                flash.moveBlock( c.module );
            }
        }, this);
    },
    
    cmpSave: function() {
        Ext.each(this.pages, function(c) {
            var data;
            var flash = this.cmpGetFlashById(c);
            if (flash) {
                flash.getBlocks("Inprint.flash.Proxy.savePage", this.id );
            }
        }, this);
    },
    
    cmpSaveProxy: function(page, modules) {
        
        var data = [];
        
        for (var c=0;c<modules.length;c++) {
            var record = modules[c];
            var string = record.id +'::'+ record.x  +'::'+ record.y  +'::'+ record.w  +'::'+ record.h;
            data.push(string);
        }
        
        Ext.Ajax.request({
            url: this.urls["save"],
            scope:this,
            success: function ( result, request ) {
                var responce = Ext.util.JSON.decode(result.responseText);
                this.saveCounter++;
                
                if (this.saveCounter >= this.pages.length) {
                    this.saveCounter = 0;
                    this.parent.fireEvent("actioncomplete", this);
                }
                
            },
            params: {
                page: page,
                modules: data
            }
        });
    }
    
});
