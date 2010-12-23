Inprint.fascicle.adverta.Context = function(parent, panels) {

    var view     = panels["pages"].getView();
    var requests = panels["requests"];
    
    view.on("contextmenu", function( view, index, node, e) {
        
        e.stopEvent();
        
        view.select(node, true);
        
        var selection = panels["pages"].cmpGetSelected();
        var selLength = selection.length;
        
        var items = [];
        var disabled = true;
        
        if (parent.access["manage"]) {
            disabled = false;
        }
        
        items.push(
            {
                ref: "../btnPageCreate",
                disabled: disabled,
                text: "Добавить заявку",
                tooltip: 'Добавить рекламную заявку в выпуск',
                icon: _ico("plus-button"),
                cls: 'x-btn-text-icon',
                scope: panels["pages"],
                handler: panels["requests"].cmpCreate
            },
            "-",
            {
                ref: "../btnCompose",
                disabled:disabled,
                text:'Разметить',
                icon: _ico("wand"),
                cls: 'x-btn-text-icon',
                scope: panels["pages"],
                handler: panels["pages"].cmpPageCompose
            }
        );
    
        new Ext.menu.Menu({ items : items }).showAt( e.getXY() );
    
    }, view);

}
