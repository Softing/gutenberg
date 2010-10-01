Inprint.exchange.Context = function(panels) {

    var grid = panels.grid;

    var items = [
        {   icon: _ico("plus-button"),
            cls: "x-btn-text-icon",
            text: _("Create chain"),
            handler: grid.actions.createChain
        },
        "-",
        {   icon: _ico("arrow-circle-double"),
            cls: "x-btn-text-icon",
            text: _("Reload"),
            scope: this,
            handler: function() {
                alert(2);
            }
        }
    ];

    var menu = new Ext.menu.Menu({ items : items });

    grid.on("contextmenu", function(e) {
        menu.showAt(e.getXY())
        e.preventDefault();
    }, grid);

}
