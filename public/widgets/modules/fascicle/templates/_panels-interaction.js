Inprint.fascicle.template.composer.Interaction = function(parent, panels) {

    var pages  = panels.pages;

    // Pages view
    pages.view.on("selectionchange", function(view, data) {

        _disable(
            parent.btnPageUpdate,
            parent.btnPageDelete,
            parent.btnPageMove,
            parent.btnPageMoveLeft,
            parent.btnPageMoveRight,
            parent.btnPageResize);

        if (parent.access.manage) {

            if (data.length == 1) {
                _enable(
                    parent.btnPageMoveLeft,
                    parent.btnPageMoveRight
                );
            }

            if (data.length >= 1) {
                _enable(
                    parent.btnPageUpdate,
                    parent.btnPageDelete,
                    parent.btnPageMove,
                    parent.btnPageResize
                );
            }
        }

    });


};
