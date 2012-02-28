/*
 * Inprint Content 4.5
 * Copyright(c) 2001-2010, Softing, LLC.
 * licensing@softing.ru
 *
 * http://softing.ru/license
 */

Ext.onReady(function() {
    Ext.BLANK_IMAGE_URL = '/ext-3.4.0/resources/images/default/s.gif';
    Ext.data.Connection.prototype._handleFailure = Ext.data.Connection.prototype.handleFailure;
    Ext.data.Connection.prototype.handleFailure = function(response, e) {
        var jsonData = Ext.util.JSON.decode(response.responseText);
        var errorText = jsonData.error;
        errorText = errorText.replace(/%br%/g, "<br/>");
        Ext.Msg.show({
            title:_("Communication error"),
            minWidth:900,
            maxWidth:900,
            msg: errorText,
            buttons: Ext.Msg.OK
        });
        Ext.data.Connection.prototype._handleFailure.call(this, response, e);
    };

    Passport();
});

var Passport =  function ()
{

    var cookie = new Ext.state.CookieProvider({
        path: "/",
        expires: new Date(new Date().getTime()+(1000*60*60*24*30))
    });

    var url_params = Ext.urlDecode(window.location.search.substring(1));

    var params = {
        request: url_params.request,
        ajax:true
    };

    var items = [
        // error box
        {
            id: 'error-box',
            xtype: 'box',
            autoEl: { tag:'div' },
            hidden:true,
            cls: 'error-box'
        },

        // Login and Password's boxes
        {
            name: 'login',
            fieldLabel: _("Login"),
            listeners: {
                scope:this,
                render: function( cmp ) {
                    if ( cookie.get('passport.login') ) {
                        cmp.setValue( cookie.get('passport.login') );
                    }
                },
                blur: function( cmp ) {
                    cookie.set('passport.login',  cmp.getValue() );
                }
            }
        },
        {
            name: 'password',
            inputType:'password',
            fieldLabel: _("Password")
        }
    ];

    // Creating form
    this.form = new Ext.FormPanel({
        url:'/login/',
        labelWidth: 60,
        baseParams: params,
        bodyStyle:'padding:15px',
        defaults: {
            anchor:'100%',
            allowBlank:false,
            xtype:'textfield'
        },
        items: items
    });

    // creating window
    var win = new Ext.Window({

        title : "Inprint Content 5.0",

        width: 300,
        height:190,

        layout: 'fit',
        closable:false,

        items: this.form,

        buttons: [{
            text: _("Enter"),
            scope:this,
            handler: function(){
               this.form.getForm().submit();
            }
        }],
        keys: [{
            key: 13,
            scope:this,
            fn: function(){
               this.form.getForm().submit();
            }
        }]
    });

    this.form.on('beforeaction', function() {
        win.body.mask(_("Loading"));
    });

    this.form.on('actionfailed', function() {
        win.body.unmask();
    });

    this.form.on('actioncomplete', function(form, action) {

        win.body.unmask();

        var r = Ext.decode( action.response.responseText );

        // Error handle
        if ( r.success == 'false' ) {

            var errorBox = this.form.findById('error-box');
            errorBox.show();

            Ext.each( r.errors , function (c) {
                this.getEl().update(_(c.msg));
            }, errorBox);

        }

        // all fine, go to main page
        if ( r.success == 'true' )
        {
            window.location = url_params.request || '/workspace/';
        }

    }, this);

    win.show();
};
