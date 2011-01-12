Ext.namespace("Inprint.flash");
Inprint.flash.Proxy = {

    onEvent : function(id, e) {
        var fp = Ext.getCmp(id);
        if(fp){
            fp.onFlashEvent(e);
        }else{
            arguments.callee.defer(10, this, [id, e]);
        }
    },

    setGrid: function(panel, id, w, h) {
        var form = Ext.getCmp(panel).getForm();
        if (form) {

            if (!form.baseParams) {
                form.baseParams = {};
            }

            form.baseParams["w"] = w;
            form.baseParams["h"] = h;

        } else {
            alert("Can't find form object!");
        }
    },

    setModule : function(panel, id, hash) {

        var form = Ext.getCmp(panel).getForm();

        if (form) {

            if (!form.baseParams) {
                form.baseParams = {};
            }

            if (hash){
                if(hash.x) {
                    form.baseParams["x"] = hash.x;
                } else {
                    alert ("Can't find x!");
                }
                if(hash.y) {
                    form.baseParams["y"] = hash.y;
                } else {
                    alert ("Can't find y!");
                }
                if(hash.w) {
                    form.baseParams["w"] = hash.w;
                } else {
                    alert ("Can't find w!");
                }
                if(hash.h) {
                    form.baseParams["h"] = hash.h;
                } else {
                    alert ("Can't find h!");
                }

            } else {
                alert ("Can't find hash!");
            }

        } else {
            alert("Can't find form object!");
        }

    },

    savePage: function(panel, data) {
        Ext.getCmp(panel).cmpSaveProxy(data);
    }

};
