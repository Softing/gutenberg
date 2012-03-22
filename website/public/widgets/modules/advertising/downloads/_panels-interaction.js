Inprint.advertising.downloads.Interaction = function(parent, panels) {

    var fascicles = panels.fascicles;
    var requests  = panels.requests;
    var summary   = panels.summary;
    var files     = panels.files;
    var comments  = panels.comments;

    var fascicle  = null;

    // Tree
    fascicles.getSelectionModel().on("selectionchange", function(sm, node) {

        _disable( requests, summary, files, comments );

        if (node) {
            fascicle = node.id;

            requests.enable();
            requests.setFascicle(fascicle);
            requests.cmpLoad({ flt_fascicle: fascicle });

            summary.enable();
            summary.setFascicle(fascicle);
            summary.cmpLoad({ flt_fascicle: fascicle });
        }
    });

    //Grids
    requests.getSelectionModel().on("rowselect", function(sm, index, record) {

        files.enable();
        files.setPkey(record.get("id"));
        files.btnUpload.enable();
        files.cmpLoad({
            request: record.get("id")
            });

        comments.enable();
        comments.btnSay.enable();
        comments.cmpLoad(record.get("id"));

    });


};
