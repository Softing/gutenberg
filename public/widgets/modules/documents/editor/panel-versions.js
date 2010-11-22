Inprint.documents.Editor.Versions = Ext.extend( Ext.Panel, 
{
   
   initComponent: function()
   {
      
      var clsFontFamily = 'font-family-times';
      var clsFontSize   = 'font-size-14';
      var clsFontMargin = 'text-margin-4';
      
      // Create Panel
      Ext.apply(this, 
      {
         layout:'fit',
         border:false,
         autoScroll:true,
         cls: clsFontFamily +' '+ clsFontSize +' '+ clsFontMargin,
         bodyCfg: {
            cls: 'inprint-panel-article-version-body'
         },
         tbar:[ 
            //{
            //   
            //   width : 300,
            //   baseParams: {
            //      id: this.oid
            //   },
            //   listeners: {
            //      scope:this,
            //      select: function(combo, record) 
            //      {
            //         
            //         this.body.mask('Загружается версия');
            //         
            //         Ext.Ajax.request({
            //            url : '/document/file/versions/get/',
            //            params : {
            //               uuid : record.data.uuid
            //            },
            //            scope : this,
            //            callback : 
            //               function(options, success, response) 
            //               {
            //                  var record = Ext.decode(response.responseText);
            //                  
            //                  this.versionText = record.text;
            //                  this.body.update(this.versionText);
            //                  this.body.unmask();
            //                  
            //               }
            //         });
            //         
            //      }
            //   }
            //   
            //}
         ]
      });
      
      Inprint.documents.Editor.Versions.superclass.initComponent.apply(this, arguments);
      
    },
    
    // Override other inherited methods
    onRender: function()
    {
        Inprint.documents.Editor.Versions.superclass.onRender.apply(this, arguments);
        
    }
    
});
