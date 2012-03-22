Inprint.documents.editor.FormPanel = Ext.extend( Ext.form.FormPanel,
{

    initComponent: function()
    {

        this.editor = new Inprint.documents.editor.Form();

        this.charCounter = new Ext.Toolbar.TextItem('Знаков: 0');

        Ext.apply(this,  {
            border:false,
            layout:'fit',
            items: this.editor,
            bbar: {
                xtype: "statusbar",
                statusAlign : 'right',
                items : [
                    {
                        scope : this,
                        disabled:true,
                        ref: "../btnSave",
                        text : _("Save"),
                        cls : 'x-btn-text-icon',
                        icon: _ico("disk-black"),
                        handler : function() {
                            this.getForm().submit();
                        }
                    },
                    '->',
                    this.charCounter
                ]
            }
        });

        Inprint.documents.editor.FormPanel.superclass.initComponent.apply(this, arguments);
    },

    // Override other inherited methods
    onRender: function() {

        Inprint.documents.editor.FormPanel.superclass.onRender.apply(this, arguments);

        this.getForm().timeout = 15;
        this.getForm().url = '/documents/text/set/';
        this.getForm().baseParams = {
            file: this.file,
            document: this.document
        };

        this.on('beforeaction', function() {
            this.body.mask(_("Saving text") + '...');
            this.btnSave.disable();
        }, this);

        this.on('actionfailed', function() {
            this.body.unmask();
            var rspns = Ext.util.JSON.decode(action.response.responseText);
            if (rspns.data.error) {
                Ext.MessageBox.alert( _("Error"), rspns.data.error);
            } else {
                Ext.MessageBox.alert(_("Error"), _("Unable to save text"));
            }
            if (rspns.data.access ) {
                rspns.data.access.fedit? this.btnSave.enable() : this.btnSave.disable();
            }

        }, this);

        this.on('actioncomplete', function(form, action) {
            this.body.unmask();
            this.parent.cmpReload();
            var rspns = Ext.util.JSON.decode(action.response.responseText);
            if (rspns.data.error) {
                Ext.MessageBox.alert( _("Error"), rspns.data.error);
            }
            if (rspns.data.access ) {
                rspns.data.access.fedit? this.btnSave.enable() : this.btnSave.disable();
            }

        }, this);

        this.editor.on('sync', function( editor, html ) {
            var count = this.cmpGetCharCount(html);
            Ext.fly( this.charCounter.getEl()).update('Знаков: ' + count );
        }, this);

        this.editor.on('initialize', function() {

            this.body.mask(_("Loading data..."));

            Ext.Ajax.request({
                url : '/documents/text/get/',
                scope : this,
                params : {
                    file : this.file,
                    document: this.document
                },
                callback:  function(options, success, response) {
                    this.body.unmask();
                    var rspns = Ext.util.JSON.decode(response.responseText);
                    if (rspns.data.error) {
                        Ext.MessageBox.alert( _("Error"), rspns.data.error);
                    }
                    if (rspns.data.access ) {
                        rspns.data.access.fedit? this.btnSave.enable() : this.btnSave.disable();
                    }
                },
                success: function(response, options) {
                    var rspns = Ext.util.JSON.decode(response.responseText);
                    this.editor.setValue(rspns.data.text);
                },
                failure : function(response, options) {
                    Ext.MessageBox.alert( _("Error"), _("Operation failed"));
                }
            }, this);

        }, this);

    },

    cmpGetCharCount: function(html) {
        html = html.replace(/\s+$/, "");
        html = html.replace(/&nbsp;/g, "-");
        html = html.replace(/[\xD]?\xA/g, "");
        html = html.replace(/&(lt|gt);/g,
            function(strMatch, p1) {
               return (p1 == "lt") ? "<" : ">";
            });

        html = html.replace(/<\/?[^>]+(>|$)/g, "");

        var cc = html.length ? html.length : 0;
        return cc;
    }
});
