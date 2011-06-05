// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Ext.ns("Inprint");
Ext.ns("Inprint.documents");
Ext.ns("Inprint.panel.tree");
Ext.ns("Inprint.grid.columns");

// Catalog
Ext.namespace("Inprint.catalog.editions");
Ext.namespace("Inprint.catalog.indexes");
Ext.namespace("Inprint.catalog.readiness");

Ext.BLANK_IMAGE_URL = '/ext-3.3.2/resources/images/default/s.gif';

var EXTJS_VERSION   = "3.3.2";
var EXTJS_PATH      = "/ext-3.3.2";
var NULLID          = "00000000-0000-0000-0000-000000000000";

Inprint.log = function() {
    if(console) {
         console.log.apply(console, arguments);
    }
}

Ext.onReady(function() {

    Ext.QuickTips.init();

    // Enable State Manager

    var stateProvider = new Ext.ux.state.HttpProvider({
        url:'/state/',
        autoRead:false,
        readBaseParams: {
            cmd: 'read'
        },
        saveBaseParams: {
            cmd: 'save'
        }
    });
    Ext.state.Manager.setProvider(
        stateProvider
    );

    Inprint.session = {
        options: {}
    };

    Inprint.checkInProgress = false;
    Inprint.checkSettings = function() {

        if (Inprint.checkInProgress) {
            return;
        }

        if (
            !Inprint.session.member.title ||
            !Inprint.session.member.shortcut ||
            !Inprint.session.member.position ||
            !Inprint.session.options ||
            !Inprint.session.options["default.edition"] ||
            !Inprint.session.options["default.edition.name"] ||
            !Inprint.session.options["default.workgroup"] ||
            !Inprint.session.options["default.workgroup.name"]
        ) {
            if (Inprint.session.member.login != "root") {
                Inprint.checkInProgress = true;
                var setupWindow = new Inprint.cmp.memberSetupWindow();
                setupWindow.on("hide", function() {
                    Inprint.checkInProgress = false;
                });
                setupWindow.show();
            }
        }

    };

    // Start session manager
    Inprint.startSession = function(defer) {
        Ext.Ajax.request({
            url: '/workspace/startsession/',
            scope: this,
            success: function(response) {

                Inprint.session = Ext.util.JSON.decode( response.responseText );
                // Restore state data

                var stateProvider = Ext.state.Manager.getProvider();

                Ext.each(Inprint.session.state, function(item) {
                    stateProvider.state[item.name] = stateProvider.decodeValue(item.value);
                }, this);

                // Enable layout
                Inprint.layout   = new Inprint.Workspace();

                // Remove loading mask
                Ext.get('loading').remove();
                Ext.get('loading-mask').fadeOut({remove:true});

                // Resolve url
                var params = Ext.urlDecode( window.location.search.substring( 1 ) );

                if (Inprint.registry[ params.aid ]){
                    Inprint.ObjectResolver.resolve({
                        aid: params.aid,
                        oid: params.oid,
                        pid: params.pid,
                        text: params.text,
                        description: params.description
                    });
                }

                Inprint.checkSettings();

                Inprint.updateSession.defer( 90000, this, [ true ]);

            }
        });
    };

    Inprint.updateSession = function(defer) {
        Ext.Ajax.request({
            url: '/workspace/updatesession/',
            scope: this,
            success: function(response) {

                Inprint.session = Ext.util.JSON.decode( response.responseText );

                if (Inprint.session && Inprint.session.member.id ){
                    if (defer) {
                        Inprint.updateSession.defer( 90000, this, [ true ]);
                    }
                    return;
                }

                Ext.MessageBox.alert(
                    _("Your session is closed"),
                    _("Probably someone has entered in Inprint with your login on other computer. <br/> push F5 what to pass to authorization page"),
                    function() {});
            }
        });
    };

    Inprint.startSession(true);

});
