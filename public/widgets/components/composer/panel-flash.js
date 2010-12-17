Inprint.cmp.composer.Flash = Ext.extend(Ext.Panel, {

    initComponent: function() {
        
        this.params = {};
        this.components = {};
        
        this.urls = {
            "read":   _url("/fascicle/pages/read/")
        }

        var selection = this.parent.selection;
        var selLength = this.parent.selLength;

        var pages = [];
        for (var c = 1; c < selection.length+1; c++) {
            var array = selection[c-1].split("::");
            pages.push(array[0]);
        }
        
        var selLength = selection.length;
        var flashItems = [];
        var flashWidth = 300;
        var flashLeft;
        var flashRight;
    
        flashLeft =  {
            id: 'flash-'+ pages[0],
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
                     
                    var init = function () {
                        if (panel.swf.init) {
                            var record = this.params[panel.id];
                            panel.swf.init(panel.getSwfId(), "letter", 0, 0);
                            panel.swf.setGrid( record.w, record.h );
                        } else {
                            init.defer(10, this);
                        }
                    };
                     
                    init.defer(10, this);
                    
                }
            }
        };
        
        flashItems.push( flashLeft );
        
        if ( selLength == 2 ) {
            
            flashWidth = 600;
            
            flashRight =  {
                id: 'flash-'+ pages[1],
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
                         
                        var init = function () {
                            if (panel.swf.init) {
                                var record = this.params[panel.id];
                                panel.swf.init(panel.getSwfId(), "letter", 0, 0);
                                panel.swf.setGrid( record.w, record.h );
                            } else {
                                init.defer(10, this);
                            }
                        };
                         
                        init.defer(10, this);
                        
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
        
        Ext.Ajax.request({
            url: this.urls["read"],
            params: {
                page: this.parent.selection
            },
            scope: this,
            success: function(result, request) {
                
                var responce = Ext.util.JSON.decode(result.responseText);
                
                for (var c = 0; c < responce.data.length; c++) {
                    
                    var id = responce.data[c].id;
                    var swf = this.findById('flash-'+ id).swf;
                    var record = responce.data[c];
                    
                    this.params['flash-'+id] = record;
                    
                }
            }
        });
        
    }
    
    

});
