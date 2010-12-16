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
    
    setGrid : function(panel, id, w, h) {
        var form = Ext.getCmp(panel).getForm();
        if (form) {
            if (form.baseParams) {
                form.baseParams["w"] = w;
                form.baseParams["h"] = h;
            } else {
                alert("Can't find form baseParams!");
            }
        } else {
            alert("Can't find form object!");
        }
    },
    
    setModule : function(panel, id, hash) {
        var form = Ext.getCmp(panel).getForm();
        if (form) {
            if (form.baseParams) {
                if(hash.x) {
                    form.baseParams["x"] = hash.x;
                }
                if(hash.y) {
                    form.baseParams["y"] = hash.y;
                }
                if(hash.w) {
                    form.baseParams["w"] = hash.w;
                }
                if(hash.h) {
                    form.baseParams["h"] = hash.h;
                }
            } else {
                alert("Can't find form baseParams!");
            }
        } else {
            alert("Can't find form object!");
        }
    }
    
};