Inprint.fascicle.template.composer.Context = function(parent, panels) {

    var view  = panels.pages.getView();

    view.on("contextmenu", function( view, index, node, e) {

        e.stopEvent();

        var selection = panels.pages.cmpGetSelected();
        var selLength = selection.length;

        var disabled = true;
        var disabled1 = true;
        var disabled2 = true;
        var items = [];

        if (parent.access.manage) {

            if (selLength == 1) {
                disabled1 = false;
            }

            if (selLength > 0 && selLength < 3) {
                disabled2 = false;
            }

            disabled = false;
        }

        items.push(
            {
                ref: "../btnCompose",
                disabled:disabled2,
                text:'Разметить',
                icon: _ico("wand"),
                cls: 'x-btn-text-icon',
                scope: panels.pages,
                handler: panels.pages.cmpPageCompose
            }
        );

        items.push('-', {
            icon: _ico("arrow-circle-double"),
            cls: "x-btn-text-icon",
            text: _("Reload"),
            scope: this,
            handler: this.cmpReload
        });

        new Ext.menu.Menu({ items : items }).showAt( e.getXY() );

    }, view);

};
