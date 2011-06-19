Inprint.fascicle.adverter.Access = function(parent, panels, access) {

    parent.access = access;

    var pages     = panels.pages;
    var documents = panels.documents;
    var requests  = panels.requests;

    //Seance
    _hide(parent.btnCaptureSession, parent.btnBeginSession, parent.btnEndSession);

    _disable(parent.btnCaptureSession, parent.btnBeginSession,
        parent.btnEndSession, parent.btnSave);

    if (access.open) {
        parent.btnBeginSession.show();
        parent.btnBeginSession.enable();
    }

    if (access.capture) {
        parent.btnCaptureSession.show();
        parent.btnCaptureSession.enable();
    }

    if (access.close) {
        parent.btnEndSession.show();
        parent.btnEndSession.enable();
    }

    if (access.save) {
        parent.btnSave.show();
        parent.btnSave.enable();
    }

    //Pages
    if (access.manage) {
        parent.btnPageCreate.enable();
        requests.btnCreateItem.enable();
    } else {
        _disable(requests.btnCreate, requests.btnUpdate, requests.btnMove, requests.btnDelete);
    }

};
