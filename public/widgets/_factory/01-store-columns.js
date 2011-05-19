// Inprint Content 5.0
// Copyright(c) 2001-2011, Softing, LLC.
// licensing@softing.ru
// http://softing.ru/license

Inprint.store.Columns = {

    advertisers: {
        list:       [
            "id", "serialnum",
            "edition", "edition_shortcut",
            "title", "shortcut", "description",
            "address", "contact", "phones",
            "inn", "kpp", "bank",
            "rs", "ks", "bik",
            { name: "created", type: "date", dateFormat: "c" },
            { name: "updated", type: "date", dateFormat: "c" }
        ]
    },

    advertising: {

        modules: [
            "id",
            "edition", "page",
            "title", "shortcut", "description",
            "width", "height", "fwidth", "fheight",
            "amount", "area", "x", "y", "w", "h",
            { name: "created", type: "date", dateFormat: "c" },
            { name: "updated", type: "date", dateFormat: "c" }
        ],

        pages: [
            "id", "edition", "title", "description", "w", "h",
            { name: "created", type: "date", dateFormat: "c" },
            { name: "updated", type: "date", dateFormat: "c" }
        ],

        requests: [
            "id",
            "serialnum", "title", "shortcut", "status", "payment", "readiness",
            "edition", "edition_shortcut",
            "fascicle", "fascicle_shortcut",
            "advertiser", "advertiser_shortcut",
            "place", "place_shortcut",
            "module", "module_shortcut",
            "manager", "manager_shortcut",
            "x", "y", "h", "w", "seqnum", "pages",
            "check_status", "anothers_layout", "imposed",
            { name: "created", type: "date", dateFormat: "c" },
            { name: "updated", type: "date", dateFormat: "c" }
        ],

        index: {
            headlines: [
                "id", "selected", "title", "description",
                { name: "created", type: "date", dateFormat: "c" },
                { name: "updated", type: "date", dateFormat: "c" }
            ],
            modules: [
                "id", "selected", "title", "description", "page", "page_title", "amount", "area", "x", "y", "w", "h",
                { name: "created", type: "date", dateFormat: "c" },
                { name: "updated", type: "date", dateFormat: "c" }
            ]
        }

    },

    common: {
        combo: [
            "id",
            "icon", "color", "spacer", "bold", "nlevel", "title", "shortcut", "description"
        ],
        transfer: [
            "id", "principal", "type", "title", "description"
        ]
    },

    calendar: {
        list: [
            'id', 'edition', 'edition_shortcut', 'is_enabled', 'title', 'shortcut', 'description', 'begindate', 'enddate', 'totaldays', 'passeddays'
        ]
    },

    documents: {
        list:         [
            'id', 'access',

            'edition',  'edition_shortcut',
            'fascicle', 'fascicle_shortcut',
            'headline', 'headline_shortcut',
            'rubric', 'rubric_shortcut',
            'copygroup',

            'holder','creator','manager','holder_shortcut','creator_shortcut','manager_shortcut',
            'maingroup','maingroup_shortcut',
            'workgroup','workgroup_shortcut','ingroups',
            'islooked','isopen',
            'branch','branch_shortcut','stage','stage_shortcut','color','progress',
            'title','author','pages',
            'pdate','psize','rdate','rsize',
            'images','files', 'links',
            { name: "created", type: "date", dateFormat: "c" },
            { name: "updated", type: "date", dateFormat: "c" },
            { name: "uploaded", type: "date", dateFormat: "c" },
            { name: "moved", type: "date", dateFormat: "c" }
        ],

        fascicles: [
            "id", "edition", "edition_shortcut", "shortcut", 'description', "fastype", "headline", "headline_shortcut", "rubric", "rubric_shortcut"
        ],

        files: [
            "id", "preview", "filename", "extension", "description", "mimetype", "digest", "draft", "size",
            { name: "created", type: "date", dateFormat: "c" },
            { name: "updated", type: "date", dateFormat: "c" }
        ]
    },

    catalog: {

        readiness: [
            "id",
            "color", "percent", "title", "shortcut", "description"
        ],

        roles: [
            "id",
            "title", "shortcut", "description", "rules"
        ],

        rules: [
            "id",
            "rule",  "icon", "title", "groupby", "limit", "selection"
        ],

        members: [
            "id",
            "login", "password", "position", "email", "title", "shortcut",
            { name: "created", type: "date", dateFormat: "c" },
            { name: "updated", type: "date", dateFormat: "c" }
        ],

        members_rules: [
            "id",
            "binding", "binding_shortcut", "area", "area_shortcut", "rules"
        ],

        stages: [
            "id",
            "chain", "readiness_shortcut", "readiness_color", "weight", "title", "shortcut", "description", "members"
        ],

        stages_mapping: [
            "id",
            "type", "catalog", "stage", "principal", "title", "description", "catalog_shortcut", "stage_shortcut"
        ],

        principals: [
            "id",
            "type", "title", "description"
        ],

        rubrics: [
            "id",
            "title", "shortcut", "description"
        ]
    },

    fascicle: {

        composer_templates:
            [ "id", "fascicle", "page", "mapping", "place", "place_title", "title", "description", "amount", "area", "x", "y", "w", "h",
            { name: "created", type: "date", dateFormat: "c" },
            { name: "updated", type: "date", dateFormat: "c" }
        ],

        composer_modules: [
            "id",
            "fascicle", "page", "mapping", "place", "place_title", "title", "description", "amount", "area", "x", "y", "w", "h",
            { name: "created", type: "date", dateFormat: "c" },
            { name: "updated", type: "date", dateFormat: "c" }
        ],

        modules: [
            "id",
            "fascicle", "page", "place", "place_title",
            "title", "description",
            "amount", "area",
            "x", "y", "w", "h",
            "width", "height", "fwidth", "fheight",
            { name: "created", type: "date", dateFormat: "c" },
            { name: "updated", type: "date", dateFormat: "c" }
        ],

        requests: [
                "id",
                "serialnum", "edition", "fascicle", "advertiser", "advertiser_shortcut",
                "place", "place_shortcut", "manager", "manager_shortcut",
                "origin", "origin_shortcut", "origin_area",
                "origin_x", "origin_y", "origin_w", "origin_h",
                "module", "module_shortcut", "pages", "firstpage", "amount", "shortcut", "description", "status", "payment", "readiness",
                { name: "created", type: "date", dateFormat: "c" },
                { name: "updated", type: "date", dateFormat: "c" }
            ],

        rubrics: [
            "id",
            "title", "shortcut", "description"
        ],

        summary: [
            "id",
            "shortcut", "pages", "place", "module", "place_shortcut", "holes", "requests", "free"
        ]

    },

    // Fascicle templates
    tfascicle: {

        pages: [
            "id",
            "fascicle", "title", "shortcut", "description", "w", "h",
            { name: "created", type: "date", dateFormat: "c" },
            { name: "updated", type: "date", dateFormat: "c" }
        ],

        modules: [
            "id",
            "fascicle", "page", "place", "place_title",
            "title", "description",
            "amount", "area",
            "x", "y", "w", "h",
            "width", "height", "fwidth", "fheight",
            { name: "created", type: "date", dateFormat: "c" },
            { name: "updated", type: "date", dateFormat: "c" }
        ],

        index_headlines: [
            "id",
            "selected", "title", "shortcut", "description",
            { name: "created", type: "date", dateFormat: "c" },
            { name: "updated", type: "date", dateFormat: "c" }
        ],

        index_modules: [
            "id",
            "selected", "title", "shortcut", "description", "page", "page_shortcut", "amount", "area", "x", "y", "w", "h",
            { name: "created", type: "date", dateFormat: "c" },
            { name: "updated", type: "date", dateFormat: "c" }
        ]

    },

    system: {
        events: [
            "id",
            "initiator", "initiator_login", "initiator_shortcut", "initiator_position",
            "entity", "entity_type", "message", "message_type", "message_variables",
            { name: "created", type: "date", dateFormat: "c" },
        ]
    }

};
