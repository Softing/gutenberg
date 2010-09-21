/*
 * Inprint Content 4.5
 * Copyright(c) 2001-2010, Softing, LLC.
 * licensing@softing.ru
 * 
 * http://softing.ru/license
 */

Inprint.Portal = Ext.extend(Ext.ux.Portal, {
    id:'inprint-portal',
    initComponent: function() {
      
        //var width  = Ext.getBody().getViewSize().width - 20;
        //var height = Ext.getBody().getViewSize().height - 85;
        
        var tools = [{
            id:'gear',
            handler: function(){
                Ext.Msg.alert('Message', 'The Settings tool was clicked.');
            }
        },{
            id:'close',
            handler: function(e, target, panel){
                panel.ownerCt.remove(panel, true);
            }
        }];
        
        Ext.apply(this, {
            border:false,
            bodyBorder: false,
            items: [{
                columnWidth:.70,
                style:'padding:8px 6px 0 8px',
                items:[{
                    title: _("Company news"),
                    layout:'fit',
                    tools: tools,
                    html: "test"
                },{
                    title: _("My alerts"),
                    tools: tools,
                    html: "test"
                }]
            },{
                columnWidth:.30,
                style:'padding:8px 8px 0 6px',
                items:[{
                    title: _("Empoyees online"),
                    tools: tools,
                    html: "test"
                }]
            }]
            
        });
        
        Inprint.Portal.superclass.initComponent.apply(this, arguments);
    }
});


//
//,listeners: {
//    'drop': function(e){
//        Ext.Msg.alert('Portlet Dropped', e.panel.title + '<br />Column: ' + 
//            e.columnIndex + '<br />Position: ' + e.position);
//    }
//}