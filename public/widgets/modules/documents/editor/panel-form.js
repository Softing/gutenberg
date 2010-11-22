Inprint.documents.Editor.Form = Ext.extend(Ext.form.HtmlEditor, 
{
   
    initComponent: function()
    {

        var clsFontFamily = 'font-family-times';
        var clsFontSize   = 'font-size-14';
        var clsFontMargin = 'text-margin-4';

        Ext.apply(this, {
            border:false,
            name : 'text',
            enableFont : false,
            enableLinks : false,
            fontFamilies : ['Times New Roman'],
            cls: clsFontFamily +' '+ clsFontSize +' '+ clsFontMargin,
            defaultFont : 'times new roman'
        });
      
        Inprint.documents.Editor.Form.superclass.initComponent.apply(this, arguments);
    },
    
    // Override other inherited methods
    onRender: function() {
        Inprint.documents.Editor.Form.superclass.onRender.apply(this, arguments);
    },
   
    getDocMarkup : function() {

        var clsFontFamily = 'font-family-times';
        var clsFontSize   = 'font-size-14';
        var clsFontMargin = 'text-margin-4';

        return '<html>'+
            '<head>'+
                '<link type="text/css" rel="stylesheet" href="/data/css/theme.css" />'+
                '<style type="text/css">body{border:0;margin:0;padding:10px;height:98%;cursor:text;}</style>'+
            '</head>'+
            '<body class="'+ clsFontFamily +' '+ clsFontSize +' '+ clsFontMargin +'"></body></html>';
    },
   
    CmpInsertText: function( text ) {
        this.setValue( text );
    }
});
