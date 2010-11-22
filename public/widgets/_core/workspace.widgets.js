/*
 * Inprint Content 4.5
 * Copyright(c) 2001-2010, Softing, LLC.
 * licensing@softing.ru
 * 
 * http://softing.ru/license
 */

Inprint.About = function(conf){

    var html =  '<div><b>Inprint Content 5.0</b></div><br>'+
                '<div>'+ "" +'</div><br>'+
                '<div>'+ "" +'</div>'+
                '<div>'+ "" +'</div>';
    
    var win = new Ext.Window({
        width: 360,
        height: 200,
        title: _("About this software"),
        layout: 'fit',
        closable:true,
        bodyStyle: "padding:10px;text-align:center;background:white;",
        html: html,
        keys: [{
            key: 27,
            fn: function() {
                win.hide();
            }
        }]
    });
    
    win.show();
};

Inprint.Help = Ext.extend(Ext.Panel, {
   
    initComponent:function() {
        
        Ext.apply(this, {
            title: _("Help center")
        });
        
        Inprint.Help.superclass.initComponent.apply(this, arguments);
    },
    
    onRender:function() {
        Inprint.Help.superclass.onRender.apply(this, arguments);
    },
    
    cmpReload:function() {
        //this.items.first().setSrc();
    }
    
});

Inprint.Logout = function(btn) {
    if ( btn == 'yes' ) {
        window.location = '/logout/';
    } else if ( btn == 'no' ) {
        return;
    } else {
        Ext.MessageBox.confirm(_("Logout"), _("Are you want to logout?"), Inprint.Logout);
    }
};

Inprint.registry.register("core-help", {
    icon: "lifebuoy",
    text: _("Help"),
    tooltip: "Help center",
    xobject: "Inprint.Help"
});

Inprint.registry.register("core-about", {
    icon: "information",
    text: _("About"),
    handler: function() {
        Inprint.About()
    }
});
