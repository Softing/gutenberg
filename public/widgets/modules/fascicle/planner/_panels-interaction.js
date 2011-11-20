Inprint.fascicle.planner.Interaction = function(parent, panels) {

    var access      = parent.access;

    var pages       = panels.pages;
    var documents   = panels.documents;
    var requests    = panels.requests;
    var summary     = panels.summary;

    documents.btnSwitchToRequests.handler = function () {
        documents.findParentByType("panel").getLayout().setActiveItem(1);
    };

    requests.btnSwitchToDocuments.handler = function () {
        documents.findParentByType("panel").getLayout().setActiveItem(0);
    };

    // Pages view

    pages.view.on("beforeselect", function() {
        return (parent.access.save == true) ? true : false;
    });

    pages.view.on("selectionchange", function(view, data) {

        var requests = this.panels.requests;

        _disable(this.btnPageUpdate, this.btnPageDelete, this.btnPageMove, this.btnPageMoveLeft, this.btnPageMoveRight, this.btnPageClean, this.btnPageResize);

        if (this.access.save) {

            _disable(requests.btnMove);

            if ( requests.getSelectionModel().getCount() == 1 ) {
                var record = requests.getSelectionModel().getSelected();
                if (record.get("amount") == data.length) {
                    _enable(requests.btnMove);
                }
            }

            if (data.length == 1) {
                _enable(this.btnPageUpdate, this.btnPageDelete, this.btnPageMove, this.btnPageMoveLeft, this.btnPageMoveRight, this.btnPageClean, this.btnPageResize);
            }

            if (data.length > 1) {
                _enable(this.btnPageUpdate, this.btnPageDelete, this.btnPageMove, this.btnPageClean, this.btnPageResize);
            }

        }

    }, parent);

    // Documents table
    documents.getSelectionModel().on("selectionchange", function(sm) {

        var documents = this.panels.documents;

        var records = documents.getSelectionModel().getSelections();
        var doc_access = _arrayAccessCheck(records, ['delete', 'recover', 'update', 'capture', 'move', 'transfer', 'briefcase']);

        _disable(documents.btnUpdate, documents.btnCapture, documents.btnTransfer, documents.btnMove, documents.btnBriefcase, documents.btnCopy,
                documents.btnDuplicate, documents.btnRecycle, documents.btnRestore, documents.btnDelete);

        if (this.access.save) {

            if (sm.getCount() == 1) {
                if (doc_access.update    == 'enabled') {
                    documents.btnUpdate.enable();
                }
                if (doc_access.capture   == 'enabled') {
                    documents.btnCapture.enable();
                }
                if (doc_access.transfer  == 'enabled') {
                    documents.btnTransfer.enable();
                }
                if (doc_access.briefcase == 'enabled') {
                    documents.btnBriefcase.enable();
                }
                if (doc_access.move      == 'enabled') {
                    documents.btnMove.enable();
                }
                if (doc_access["delete"]    == 'enabled') {
                    documents.btnRecycle.enable();
                }
            }

            if (sm.getCount() > 0 ) {
                if (doc_access.capture   == 'enabled') {
                    documents.btnCapture.enable();
                }
                if (doc_access.transfer  == 'enabled') {
                    documents.btnTransfer.enable();
                }
                if (doc_access.briefcase == 'enabled') {
                    documents.btnBriefcase.enable();
                }
                if (doc_access.move      == 'enabled') {
                    documents.btnMove.enable();
                }
                if (doc_access["delete"]    == 'enabled') {
                    documents.btnRecycle.enable();
                }
            }
        }

    }, parent);

    // Advert table
    requests.getSelectionModel().on("selectionchange", function(sm) {

        var pages    = this.panels.pages;
        var requests = this.panels.requests;

        var selectedPages = pages.cmpGetSelected();
        var amount = requests.getValue("amount");

        _disable(requests.btnCreate, requests.btnUpdate, requests.btnMove, requests.btnDelete);

        if (this.access.advert) {
            requests.btnCreate.enable();
        }

        if (this.access.save) {

            if (sm.getCount() == 1) {

                _enable(requests.btnUpdate, requests.btnDelete);

                if (amount == selectedPages.length) {
                    _enable(requests.btnMove);
                }

            }
            if (sm.getCount() > 0 ) {
                _enable(requests.btnDelete);
            }
        }

    }, parent);

};
