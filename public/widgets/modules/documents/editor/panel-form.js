Inprint.documents.Editor.Form = Ext.extend(Ext.form.HtmlEditor,
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
            fontFamilies: ['Times New Roman'],
            defaultFont: 'times new roman',
            plugins: [
                new Ext.ux.form.HtmlEditor.RemoveFormat(),
                new Ext.ux.form.HtmlEditor.Word(),
                new Ext.ux.form.HtmlEditor.UndoRedo(),
                new Ext.ux.form.HtmlEditor.Divider(),
                new Ext.ux.form.HtmlEditor.SpecialCharacters(),
            ]
        });

        Inprint.documents.Editor.Form.superclass.initComponent.apply(this, arguments);
    },

    // Override other inherited methods
    onRender: function() {
        Inprint.documents.Editor.Form.superclass.onRender.apply(this, arguments);
    }

});
