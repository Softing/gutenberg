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
                        ref: "../btnSave",
                        disabled:true,
                        scope : this,
                        text : '<b>Сохранить текст</b>',
                        cls : 'x-btn-text-icon',
                        icon: _ico("disk-black"),
                        scope:this,
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

        this.on('beforeaction', function() {
            this.body.mask('Идет сохранение текста...');
            this.btnSave.disable();
        }, this);

        this.on('actionfailed', function() {
            this.body.unmask();
            this.btnSave.enable();
            Ext.MessageBox.alert('Ошибка!', 'Не удалось сохранить текст!');
        }, this);

    },

    // Override other inherited methods
    onRender: function() {

        Inprint.documents.editor.FormPanel.superclass.onRender.apply(this, arguments);

        this.getForm().timeout = 5;
        this.getForm().url = '/documents/text/set/';
        this.getForm().baseParams = {
            oid: this.oid
        };

        this.on('actioncomplete', function() {

            this.body.unmask();
            this.btnSave.enable();

            //new Ext.ux.ToastWindow({
            //    title: 'Все в порядке!',
            //    html: 'Ваш текст успешно сохранен',
            //    iconCls: 'toast-success'
            //}).show(document);

        }, this);

        this.editor.on('sync', function( editor, html ) {
            var count = this.cmpGetCharCount(html);
            Ext.fly( this.charCounter.getEl()).update('Знаков: ' + count );
        }, this);

        this.editor.on('initialize', function() {

            this.body.mask('Идет загрузка текста');

            Ext.Ajax.request({
                url : '/documents/text/get/',
                scope : this,
                params : {
                    oid : this.oid
                },
                success : function(response, options)
                {
                    var rspns = Ext.util.JSON.decode(response.responseText);
                    this.body.unmask();

                    this.editor.setValue(rspns.data);
                    this.btnSave.enable();

                },
                failure : function(response, options) {
                    this.body.unmask();
                    this.getBottomToolbar().items.get('save').enable();
                    Ext.MessageBox.alert('Ошибка!', 'Операция не удалась, текст не получен');
                }
            }, this);

            var count = this.CmpGetCharCount( this.editor.getValue() );

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
