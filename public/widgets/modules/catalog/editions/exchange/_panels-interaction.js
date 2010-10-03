Inprint.exchange.Interaction = function(panels) {

    var acl_view   = _a(null, "settings.availability.view");
    var acl_manage = _a(null, "settings.availability.manage");
    var acl_remove = _a(null, "settings.availability.remove");

    var grid = panels.grid;
    var help = panels.help;
    var view = panels.chains;

    var currentChain, currentStage;

    // Getters
    this.getGrid = function() {
        return grid;
    }
    this.getView = function() {
        return view;
    }
    this.getCurrentChain = function() {
        return currentChain;
    }
    this.getCurrentStage = function() {
        return currentStage;
    }

    var components = {};

    // View
    view.on("selectionchange", function (view, nodes) {
        currentChain = view.getRecord(nodes[0]).get("id");
        grid.cmpLoad({ chain: currentChain });
        _enable(grid.btnCreateStage, grid.btnChangeChain, grid.btnRemoveChain);
    });

    view.getStore().on("load", function() {
        this.select(0);
    }, view);

    // Grid

    if (acl_manage) {
        grid.btnCreateChain.enable();
    }

    grid.getSelectionModel().on("selectionchange", function(sm) {

        if (sm.getCount()) {
            if (acl_manage) {
                _enable(grid.btnRemoveStage);
            }
        } else {
            _disable(grid.btnRemoveStage);
        }

        if (acl_manage) {
            if (sm.getCount() == 1) {
                currentStage = grid.getValue("id");
               _enable(grid.btnChangeStage, grid.btnSelectMembers);
            } else {
               _disable(grid.btnChangeStage, grid.btnSelectMembers);
            }
        }

    });

    // Chains
    grid.btnCreateChain.on("click", grid.actions.createChain.createDelegate(this));
    grid.btnChangeChain.on("click", grid.actions.changeChain.createDelegate(this));
    grid.btnRemoveChain.on("click", grid.actions.removeChain.createDelegate(this));

    // Stages
    grid.btnCreateStage.on("click", grid.actions.createStage.createDelegate(this));
    grid.btnChangeStage.on("click", grid.actions.changeStage.createDelegate(this));
    grid.btnRemoveStage.on("click", grid.actions.removeStage.createDelegate(this));

    // Browser

    grid.btnSelectMembers.on("click", Inprint.membersBrowser.Window.createDelegate(this, [{
        tbar: [
                {
                    icon: _ico("plus-button"),
                    cls: "x-btn-text-icon",
                    text: _("Add"),
                    disabled:true,
                    ref: "../btnAdd",
                    scope:this,
                    handler: function () { alert (1); }
                }
        ]
    }]));

}
