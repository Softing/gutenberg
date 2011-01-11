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

        selection.sort(function(a, b){
            var array1 = a.split("::");
            var array2 = b.split("::");
            return array1[1] - array2[1];
        });

        this.pages = [];
        for (var c = 1; c < selection.length+1; c++) {
            var array = selection[c-1].split("::");
            this.pages.push(array[0]);
        }

        var selLength = selection.length;

        var flashWidth = 300 * selLength;

        this.flashid = Ext.id();
        var flash =  {
            id: this.flashid,
            xtype: "flash",
            width:flashWidth,
            hideMode : 'offsets',
            url      : '/flash/Dispose2.swf',
            expressInstall: true,
            flashVars: {
                src: '/flash/Dispose2.swf',
                scale :'noscale',
                autostart: 'yes',
                loop: 'yes'
            }
        };

        Ext.apply(this, {
            region:"east",
            margins: "3 3 3 0",
            width: flashWidth,
            minSize: 200,
            maxSize: 600,
            layout:"hbox",
            layoutConfig: {
                align : 'stretch',
                pack  : 'start'
            },
            items: flash
        });

        Inprint.cmp.composer.Flash.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.composer.Flash.superclass.onRender.apply(this, arguments);
        this.cmpInit();
    },

    cmpGetFlashById: function(id) {
        var panel = this.findById(id);
        if (panel) {
            return panel.swf;
        }
        return null;
    },

    cmpInit: function() {

        this.body.mask(_("Loading..."));

        Ext.Ajax.request({
            url: this.urls["init"],
            scope:this,
            callback : function() {
                this.body.unmask();
            },
            success: function ( result, request ) {

                var responce = Ext.util.JSON.decode(result.responseText);

                var flash = this.cmpGetFlashById(this.flashid);

                if (!flash) {
                    return;
                }

                var init = function() {
                    if (flash.reset) {
                        flash.reset();
                    } else {
                        init.defer(10, this);
                    }
                    init.defer(100, this);
                }

                Ext.each(responce.data.pages, function(c) {
                    var configure = function() {
                        if (flash.setField) {
                            flash.setField(c.id, "letter", 0, 0 );
                            flash.setGrid(c.id, c.w, c.h);
                        } else {
                            configure.defer(10, this);
                        }
                    }
                    configure.defer(100, this);
                }, this);

                //flash.setBlocks("mypage", [ { id: "myblock", n:record.title, x: record.x, y: record.y, w: record.w, h: record.h } ] );
                //flash.editBlock("mypage",  "myblock", true );

                Ext.each(responce.data.modules, function(c) {
                    var setmodules = function() {
                        if (flash.setBlock) {
                            flash.setBlock(c.page, c.id, c.title, c.x, c.y, c.w, c.h );
                        } else {
                            setmodules.defer(10, this);
                        }
                    }
                    setmodules.defer(100, this);
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
