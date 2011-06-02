Inprint.documents.editor.FormTinyMce = Ext.extend( Ext.form.FormPanel,
{

    initComponent: function()
    {

        var options = Inprint.session.options;

        var fontStyle  = options["default.font.style"] || "times new roman";
        var fontSize   = options["default.font.size"]  || "medium";

        var content_css = "/css/tiny/content-"+ fontSize +".css";

        var charCounter = new Ext.Toolbar.TextItem('Знаков: 0');

        this.charCounter = charCounter;

        this.editor = new Ext.ux.TinyMCE({
            border:false,
            name: "text",
            hideLabel:true,
            labelSeparator:'',
            allowBlank: true,
            tinymceSettings: {

                language : "ru",
                theme: "advanced",
                content_css: content_css,

                force_br_newlines : true,
                force_p_newlines : false,
                forced_root_block : '',

                //plugins: "pagebreak,style,layer,table,advhr,advimage,advlink,emotions,iespell,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,noneditable,visualchars,nonbreaking,xhtmlxtras,template",
                //theme_advanced_buttons1: "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,styleselect,formatselect,fontselect,fontsizeselect",
                //theme_advanced_buttons2: "cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,cleanup,help,code,|,insertdate,inserttime,preview,|,forecolor,backcolor",
                //theme_advanced_buttons3: "tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,emotions,iespell,media,advhr,|,print,|,ltr,rtl,|",
                //theme_advanced_buttons4: "insertlayer,moveforward,movebackward,absolute,|,styleprops,|,cite,abbr,acronym,del,ins,attribs,|,visualchars,nonbreaking,template,pagebreak",

                plugins: "table,iespell,searchreplace,print,paste,noneditable,visualchars",
                theme_advanced_buttons1: "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo",
                theme_advanced_buttons2: "tablecontrols,|,removeformat,cleanup,|,sub,sup,|,charmap,iespell,|,print,visualchars",
                theme_advanced_buttons3: "",

                theme_advanced_toolbar_location: "top",
                theme_advanced_toolbar_align: "left",
                theme_advanced_statusbar_location: "bottom",

                theme_advanced_path : false,

                extended_valid_elements: "font[face|size|color|style]",

                accessibility_focus: false,
                setup : function(ed) {

                    ed.onKeyUp.add(function(ed, e) {

                        var oDOM = ed.getDoc() ;

                        var iLength ;
                        if (document.all) {
                            iLength = oDOM.body.innerText.length;
                        } else {
                            var r = oDOM.createRange() ;
                            r.selectNodeContents(oDOM.body);
                            iLength = r.toString().length;
                        }

                        Ext.fly(charCounter.getEl()).update('Знаков: ' + iLength );

                    })

                }
            }
        });

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
                    charCounter
                ]
            }
        });

        Inprint.documents.editor.FormTinyMce.superclass.initComponent.apply(this, arguments);
    },

    // Override other inherited methods
    onRender: function() {

        Inprint.documents.editor.FormTinyMce.superclass.onRender.apply(this, arguments);

        this.getForm().timeout = 20;
        this.getForm().url = '/documents/text/set/';
        this.getForm().baseParams = {
            file: this.file,
            document: this.document
        };

        // Before save
        this.on('beforeaction', function() {
            this.body.mask(_("Saving text") + '...');
            //this.btnSave.disable();
        }, this);

        // Callback
        var callback = function() {
            this.body.unmask();
        };

        // Save failed
        var actionFailed = function(form, action) {

            this.body.unmask();

            var rspns = Ext.util.JSON.decode(action.response.responseText);

            if (rspns.data.error) {
                Ext.MessageBox.alert( _("Error"), rspns.data.error);
            } else {
                Ext.MessageBox.alert(_("Error"), _("Unable to save text"));
            }

            this.cmpAccess(rspns.data.access);
        };

        this.on('actionfailed', actionFailed, this);

        // Save success
        actionSuccess = function(form, action) {

            this.body.unmask();

            var rspns = Ext.util.JSON.decode(action.response.responseText);

            if (rspns.data.error) {
                Ext.MessageBox.alert( _("Error"), rspns.data.error);
            }

            this.cmpAccess(rspns.data.access);
            this.parent.cmpReload();

        };

        this.on('actioncomplete', actionSuccess, this);

        // Load text
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

                this.cmpAccess(rspns.data.access);
            },
            success: function(response, options) {

                this.body.unmask();

                var rspns = Ext.util.JSON.decode(response.responseText);
                this.cmpSetValue(rspns.data.text);
                this.cmpUpdateCharCount();
            },
            failure : function(response, options) {

                this.body.unmask();

                Ext.MessageBox.alert( _("Error"), _("Operation failed"));
            }

        }, this);

    },

    cmpAccess: function(access) {
        if (access && access.fedit ) {
            this.btnSave.enable();
        } else {
            this.btnSave.disable();
        }
    },

    cmpGetValue: function() {
        return this.editor.getValue();
    },

    cmpSetValue: function(value) {
        this.editor.setValue(value);
    },

    cmpUpdateCharCount: function() {

        var oDOM = this.editor.getEd().getDoc();
        var iLength ;

        if (document.all) {
            iLength = oDOM.body.innerText.length;
        } else {
            var r = oDOM.createRange() ;
            r.selectNodeContents(oDOM.body);
            iLength = r.toString().length;
        }

        Ext.fly( this.charCounter.getEl()).update('Знаков: ' + iLength );
    }
});
