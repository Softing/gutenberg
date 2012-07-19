Inprint.fascicle.planner.Access = function(parent, panels, access) {

    parent.access = access;

    var pages     = panels.pages;
    var documents = panels.documents;
    var requests  = panels.requests;

    //Seance
    _hide(parent.btnCaptureSession, parent.btnBeginSession, parent.btnEndSession);

    _disable(parent.btnCaptureSession, parent.btnBeginSession, parent.btnEndSession, parent.btnSave);

    _disable(documents.btnUpdate, documents.btnCapture, documents.btnTransfer,
        documents.btnMove, documents.btnBriefcase, documents.btnCopy,
        documents.btnDuplicate, documents.btnRecycle, documents.btnRestore,
        documents.btnDelete);

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

    // Composition
    if (access.save) {

        parent.btnSave.show();
        parent.btnSave.enable();

        parent.btnPageCreate.enable();

        documents.btnCreate.enable();
        documents.btnFromBriefcase.enable();
    }
    
    // Advert
    if (access.advert_create == 0) {
        _disable(requests.btnCreate);
    }
    if (access.advert_create == 1) {
        _enable(requests.btnCreate);
    }
    
    if (access.advert_update == 0) {
        _disable(requests.btnUpdate, requests.btnMove, requests.btnDelete);
    }

};
