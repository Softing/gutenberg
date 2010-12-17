    //
    //    this.urls = {
    //        "read":   _url("/fascicle/pages/read/"),
    //        "create": _url("/fascicle/pages/create/"),
    //        "update": _url("/fascicle/pages/update/"),
    //        "delete": _url("/fascicle/pages/delete/"),
    //        "move":   _url("/fascicle/pages/move/"),
    //        "left":   _url("/fascicle/pages/left/"),
    //        "right":  _url("/fascicle/pages/right/"),
    //        "clean":  _url("/fascicle/pages/clean/"),
    //        "resize": _url("/fascicle/pages/resize/")
    //    };
    //
    //cmpPageCompose: function() {
    //    
    //    var selection = this.cmpGetSelected();
    //    
    //    if (selection.length > 2) {
    //        return;
    //    }
    //    
    //    var grid = new Inprint.fascicle.planner.Modules();
    //    
    //    var pages = [];
    //    for (var c = 1; c < selection.length+1; c++) {
    //        var array = selection[c-1].split("::");
    //        pages.push(array[0]);
    //    }
    //    
    //    var selLength = selection.length;
    //    var flashItems = [];
    //    var flashWidth = 300;
    //    var flashLeft;
    //    var flashRight;
    //
    //    flashLeft =  {
    //        id: 'flash-'+ pages[0],
    //        xtype: "flash",
    //        width:300,
    //        hideMode : 'offsets',
    //        url      : '/flash/Dispose.swf',
    //        expressInstall: true,
    //        flashVars: {
    //            src: '/flash/Dispose.swf',
    //            scale :'noscale',
    //            autostart: 'yes',
    //            loop: 'yes'
    //        },
    //        listeners: {
    //            scope:this,
    //            initialize: function(panel, flash) {
    //                alert(2);
    //            },
    //            afterrender: function(panel) {
    //                 
    //                var init = function () {
    //                    if (panel.swf.init) {
    //                        panel.swf.init(panel.getSwfId(), "letter", 0, 0);
    //                    } else {
    //                        init.defer(10, this);
    //                    }
    //                };
    //                 
    //                init.defer(10, this);
    //                
    //            }
    //        }
    //    };
    //    
    //    flashItems.push( flashLeft );
    //    
    //    if ( selLength == 2 ) {
    //        
    //        flashWidth = 600;
    //        
    //        flashRight =  {
    //            id: 'flash-'+ pages[1],
    //            xtype: "flash",
    //            width:300,
    //            hideMode : 'offsets',
    //            url      : '/flash/Dispose.swf',
    //            expressInstall: true,
    //            flashVars: {
    //                src: '/flash/Dispose.swf',
    //                scale :'noscale',
    //                autostart: 'yes',
    //                loop: 'yes'
    //            },
    //            listeners: {
    //                scope:this,
    //                initialize: function(panel, flash) {
    //                    alert(2);
    //                },
    //                afterrender: function(panel) {
    //                     
    //                    var init = function () {
    //                        if (panel.swf.init) {
    //                            panel.swf.init(panel.getSwfId(), "letter", 0, 0);
    //                        } else {
    //                            init.defer(10, this);
    //                        }
    //                    };
    //                     
    //                    init.defer(10, this);
    //                    
    //                }
    //            }
    //        };
    //        
    //        flashItems.push( flashRight );
    //    }
    //    
    //    win = new Ext.Window({
    //        width: flashWidth + 400,
    //        height:450,
    //        modal:true,
    //        layout: "border",
    //        closeAction: "hide",
    //        title: _("Adding a new category"),
    //        defaults: {
    //            collapsible: false,
    //            split: true
    //        },
    //        items: [
    //            {   region: "center",
    //                margins: "3 0 3 3",
    //                layout:"fit",
    //                items: grid
    //            },
    //            {   region:"east",
    //                margins: "3 3 3 0",
    //                width: flashWidth,
    //                minSize: 200,
    //                maxSize: 600,
    //                layout:"hbox",
    //                layoutConfig: {
    //                    align : 'stretch',
    //                    pack  : 'start'
    //                },
    //                items: flashItems
    //            }
    //        ],
    //        listeners: {
    //            scope:this,
    //            afterrender: function(panel) {
    //                panel.flashLeft = panel.findByType("flash")[0].swf;
    //                panel.flashRight = panel.findByType("flash")[0].swf;
    //                panel.grid  = panel.findByType("grid")[0];
    //            }
    //        },
    //        buttons: [ _BTN_WNDW_SAVE, _BTN_WNDW_CLOSE ]
    //    });
    //    
    //    win.show(this);
    //    this.components["compose-window"] = win;
    //
    //    Ext.Ajax.request({
    //        url: this.urls["read"],
    //        params: {
    //            page: selection
    //        },
    //        scope: this,
    //        success: function(result, request) {
    //            
    //            var responce = Ext.util.JSON.decode(result.responseText);
    //            
    //            for (var c = 0; c < responce.data.length; c++) {
    //                
    //                var id = responce.data[c].id;
    //                var swf = win.findById('flash-'+ id).swf;
    //                var record = responce.data[c];
    //                
    //                swf.setGrid( record.w, record.h );
    //            }
    //        }
    //    });
    //    
    //}
    //
