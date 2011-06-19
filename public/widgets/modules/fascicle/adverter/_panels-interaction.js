Inprint.fascicle.adverter.Interaction = function(parent, panels) {

    var access = parent.access;

    var pages       = panels.pages;
    var requests    = panels.requests;
    var summary     = panels.summary;

    // Set Actions
    requests.btnCreateItem.on("click", Inprint.getAction("request.create") .createDelegate(parent, [requests]));
    requests.btnUpdateItem.on("click", Inprint.getAction("request.update") .createDelegate(parent, [requests]));
    requests.btnDeleteItem.on("click", Inprint.getAction("request.delete") .createDelegate(parent, [requests]));
    requests.btnLayoutItem.on("click", Inprint.getAction("request.layout") .createDelegate(parent, [requests]));
    requests.btnPlacingItem.on("click", Inprint.getAction("request.placing") .createDelegate(parent, [requests]));

    // Pages view
    pages.view.on("selectionchange", function(view, data) {

        _disable(parent.btnPageUpdate, parent.btnPageDelete, parent.btnPageMove, parent.btnPageMoveLeft, parent.btnPageMoveRight, parent.btnPageClean, parent.btnPageResize);

        if (parent.access.manage) {

            _disable(requests.btnMove);

            if ( requests.getSelectionModel().getCount() == 1 ) {
                var record = requests.getSelectionModel().getSelected();
                if (record.get("amount") == data.length) {
                    _enable(requests.btnMove);
                }
            }

            if (data.length == 1) {
                _enable(parent.btnPageUpdate, parent.btnPageDelete, parent.btnPageMove, parent.btnPageMoveLeft, parent.btnPageMoveRight, parent.btnPageClean, parent.btnPageResize);
            }

            if (data.length > 1) {
                _enable(parent.btnPageUpdate, parent.btnPageDelete, parent.btnPageMove, parent.btnPageClean, parent.btnPageResize);
            }

        }

    });

    // Advert table
    requests.getSelectionModel().on("selectionchange", function(sm) {

        _disable(requests.btnCreateItem, requests.btnUpdateItem, requests.btnLayoutItem, requests.btnPlacingItem, requests.btnDeleteItem);

        if (parent.access.manage) {

            requests.btnCreateItem.enable();

            if (sm.getCount() > 0 ) {
                _enable(requests.btnDelete);
            }

            if (sm.getCount() == 1) {
                _enable(requests.btnUpdateItem, requests.btnDeleteItem, requests.btnLayoutItem, requests.btnPlacingItem);
            }

        }

    });

};
