Inprint.cmp.memberProfile.Window = Ext.extend(Ext.Window, {

    initComponent: function() {
        this.panel = new Inprint.cmp.memberProfile.Panel();
        Ext.apply(this, {
            title: _("Profile of the employee"),
            modal: true,
            layout: "fit",
            closeAction: "hide",
            width:600, height:400,
            items: this.panel
        });
        Inprint.cmp.memberProfile.Window.superclass.initComponent.apply(this, arguments);
        Inprint.cmp.memberProfile.Interaction(this.panels);
    },

    onRender: function() {
        Inprint.cmp.memberProfile.Window.superclass.onRender.apply(this, arguments);
    },

    cmpFill: function(id) {
        Ext.Ajax.request({
            scope:this,
            params: { id: id },
            url: "/profile/read/",
            success: function(result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                this.panel.tpl.overwrite(this.panel.body, jsonData.data);
            }
        });
    }

});
