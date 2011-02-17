Inprint.documents.editor.Form = Ext.extend(Ext.form.HtmlEditor,
{

    initComponent: function()
    {

        var clsFontFamily = 'font-family-times';
        var clsFontSize   = 'font-size-14';
        var clsFontMargin = 'text-margin-4';

        Ext.apply(this, {
            border: false,
            name: 'text',
            enableFont: false,
            enableLinks: false,
            enableColors: false,
            enableFontSize: false,
            enableAlignments: false,
            fontFamilies: ['Times New Roman'],
            defaultFont: 'times new roman',
            plugins: [
                new Ext.ux.form.HtmlEditor.RemoveFormat(),
                new Ext.ux.form.HtmlEditor.Word(),
                new Ext.ux.form.HtmlEditor.UndoRedo(),
                new Ext.ux.form.HtmlEditor.Divider(),
                new Ext.ux.form.HtmlEditor.SpecialCharacters(),
                new Ext.ux.form.HtmlEditor.SubSuperScript()
            ]
        });

        Inprint.documents.editor.Form.superclass.initComponent.apply(this, arguments);
    },

    // Override other inherited methods
    onRender: function() {
        Inprint.documents.editor.Form.superclass.onRender.apply(this, arguments);
    }

});
