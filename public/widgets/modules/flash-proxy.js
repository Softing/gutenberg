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
                form.baseParams["w"] = hash.w;
                form.baseParams["h"] = hash.h;
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
                form.baseParams["x"] = hash.x;
                form.baseParams["y"] = hash.y;
                form.baseParams["w"] = hash.w;
                form.baseParams["h"] = hash.h;
            } else {
                alert("Can't find form baseParams!");
            }
        } else {
            alert("Can't find form object!");
        }
    }
    
};