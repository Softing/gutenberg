Inprint.documents.editor.Form = Ext.extend(Ext.form.HtmlEditor,
{

    initComponent: function()
    {

        var options = Inprint.session.options;

        var fontSizeTitles = {
                "small":  "1em",
                "medium": "1.2em",
                "large":  "1.4em"
            };

        var fontStyleTitles = {
                "times new roman": "Times New Roman"
            };

        var fontStyle  = fontStyleTitles[ options["default.font.style"] ] || "times new roman";
        var fontSize   = fontSizeTitles [ options["default.font.size"] ] || "1.2em";

        Ext.apply(this, {
            border: false,
            name: 'text',
            enableFont: false,
            enableLinks: false,
            enableColors: false,
            enableFontSize: false,
            enableAlignments: false,
            fontFamilies: ['Times New Roman'],
            style: 'font-family:"'+ fontStyle +'";font-size:'+ fontSize +';',
            plugins: [
                new Ext.ux.form.HtmlEditor.RemoveFormat(),
                //new Ext.ux.form.HtmlEditor.Word(),
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
