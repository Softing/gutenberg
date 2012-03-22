Inprint.documents.editor.versions.Viewer = Ext.extend( Ext.Panel, {

    initComponent: function() {

        // Create Panel
        Ext.apply(this, {
            layout:'fit',
            border:false,
            autoScroll:true,
            bodyStyle: "padding:20px 20px;font-size:14px;"
        });

        Inprint.documents.editor.versions.Viewer.superclass.initComponent.apply(this, arguments);

    },

    // Override other inherited methods
    onRender: function() {
        Inprint.documents.editor.versions.Viewer.superclass.onRender.apply(this, arguments);
    }

});
