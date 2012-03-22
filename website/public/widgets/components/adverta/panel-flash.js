Inprint.cmp.adverta.Flash = Ext.extend(Ext.Panel, {

    initComponent: function() {

        this.urls = {
            "init": _url("/fascicle/composer/initialize/"),
            "save": _url("/fascicle/composer/save/")
        };

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

        selLength = selection.length;

        var flashWidth = 260 * selLength;

        this.flashid = Ext.id();
        var flash =  {
            id: this.flashid,
            xtype: "flash",
            swfWidth:flashWidth,
            swfHeight:290,
            //hideMode: 'offsets',
            url: '/flash/Dispose3.swf',
            expressInstall: true,
            flashParams: {
                scale:"noscale"
            },
            flashVars: {
                src: "/flash/Dispose3.swf",
                autostart:"yes",
                loop: "yes"
            }
        };

        Ext.apply(this, {
            region:"east",
            //margins: "3 3 3 0",
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

        Inprint.cmp.adverta.Flash.superclass.initComponent.apply(this, arguments);

    },

    onRender: function() {
        Inprint.cmp.adverta.Flash.superclass.onRender.apply(this, arguments);
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
            url: this.urls.init,
            scope:this,
            callback : function() {
                this.body.unmask();
            },
            success: function ( result, request ) {
                var responce = Ext.util.JSON.decode(result.responseText);
                this.cmpInitFlash(responce);
            },
            params: { page: this.pages }
        });
    },

    cmpInitFlash: function(responce) {

        var flash = this.cmpGetFlashById(this.flashid);

        if (!flash) {
            return;
        }

        var init = function() {
            if (flash.reset) {

                flash.reset();

                Ext.each(responce.data.pages, function(c) {
                    flash.setField(c.id, "letter", 0, 0 );
                    flash.setGrid(c.id, c.w, c.h);
                }, this);

                Ext.each(responce.data.modules, function(c) {
                    flash.setBlock(c.page, c.id, c.title, c.x, c.y, c.w, c.h );
                }, this);

            } else {
                init.defer(10, this);
            }
        };

        init.defer(100, this);

    },

    cmpMoveBlocks: function(composition) {
        var flash = this.cmpGetFlashById(this.flashid);
        if (!flash) {
            return;
        }
        flash.moveBlock( composition.page, composition.module );
    },

    cmpSave: function() {
        var flash = this.cmpGetFlashById(this.flashid);
        if (!flash) {
            return;
        }
        flash.getAllBlocks( "Inprint.flash.Proxy.savePage", this.id );
    },

    cmpSaveProxy: function(records) {

        var data = [];

        for (var p=0;p<records.length;p++) {
            var modules = records[p].arr;
            for (var m=0;m<modules.length;m++) {
                var module = modules[m];
                var string = module.id +'::'+ module.fid +'::'+ module.x  +'::'+ module.y  +'::'+ module.w  +'::'+ module.h;
                data.push(string);
            }
        }

        Ext.Ajax.request({
            url: this.urls.save,
            scope:this,
            success: function ( result, request ) {
                var responce = Ext.util.JSON.decode(result.responseText);
                //this.parent.fireEvent("actioncomplete", this);
            },
            params: {
                modules: data,
                fascicle: this.parent.fascicle
            }
        });

    }

});
