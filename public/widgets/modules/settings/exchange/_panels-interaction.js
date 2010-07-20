Inprint.settings.exchange.Interaction = function(panels) {

    var acl_view   = _a(null, "settings.availability.view");
    var acl_manage = _a(null, "settings.availability.manage");
    var acl_remove = _a(null, "settings.availability.remove");

    var tree = panels.tree;
    var grid = panels.grid;
    var edit = panels.edit;
    var help = panels.help;
    var tabs = panels.tabs;
    var members = panels.members;

    // Tree
    tree.cmpExpand({
        accessFilterBy: "availability"
    });

    tree.getLoader().on("load", function(tree, node) {
        node.eachChild(function(subnode) {
            subnode.leaf = false;
            subnode.appendChild([
                {   text: "Материалы",
                    icon: "clock-select.png",
                    type: "document",
                    edition:subnode.id,
                    leaf:true
                },
                {   text: "Иллюстрации",
                    icon: "clock-select.png",
                    type: "media",
                    edition:subnode.id,
                    leaf:true
                },
                {   text: "Полосы",
                    icon: "clock-select.png",
                    type: "page",
                    edition:subnode.id,
                    leaf:true
                }
            ]);

        }, this);

    });

    tree.getSelectionModel().on("selectionchange", function(sm, node) {
        if (node.leaf == true) {
            grid.cmpLoad({
                edition: node.attributes.edition,
                type: node.attributes.type
            });

        } else if (node.isExpanded() == false) {

            node.expand();
            node.item(0).select();

            grid.cmpLoad({
                edition: node.item(0).attributes.edition,
                type: node.item(0).attributes.type
            });
        }
    });

    // Grid

    if (acl_manage) {
        grid.btnAdd.enable();
    }

    grid.getSelectionModel().on("selectionchange", function(sm) {

        if (sm.getCount()) {
            if (acl_manage) {
                _enable(grid.btnEnable, grid.btnDisable);
            }
            if (acl_remove) {
                _enable(grid.btnRemove);
            }
        } else {
            _disable(grid.btnEnable, grid.btnDisable, grid.btnRemove);
        }

        if (acl_manage) {
            if (sm.getCount() == 1) {
                edit.enable();
                members.enable();
                tabs.activate(edit);
                edit.cmpFill(grid.getSelectionModel().getSelected());
            } else {
                edit.disable();
                members.disable();
                tabs.activate(help);
            }
        }

    });

    // Card
    edit.on("actioncomplete", function() {
        grid.cmpReload();
    });

    //Members
    members.on("activate", function() {
        members.params = {
            id: grid.getValue("id"),
            edition: grid.getValue("edition")            
        }
        members.cmpLoad();
    });

}