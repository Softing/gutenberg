package Inprint::Models::Documents;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

sub search {

    my ($c, $params) = @_;

    my @params;

    # Pagination
    my $start    = $c->param("start")        || $params->{"start"}          || 0;
    my $limit    = $c->param("limit")        || $params->{"limit"}          || 60;
    my $paginate = $c->param("paginate")     || $params->{"paginate"}       || "yes";

    # Grid mode
    my $mode     = $c->param("gridmode")     || $params->{"gridmode"}       || "all";

    # Sorting
    my $dir      = $c->param("dir")          || $params->{"dir"}            || "DESC";
    my $sort     = $c->param("sort")         || $params->{"sort"}           || "uploaded";

    # Filters
    my $edition  = $c->param("flt_edition")  || $params->{"flt_edition"}    || undef;
    my $group    = $c->param("flt_group")    || $params->{"flt_group"}      || undef;
    my $title    = $c->param("flt_title")    || $params->{"flt_title"}      || undef;
    my $fascicle = $c->param("flt_fascicle") || $params->{"flt_fascicle"}   || undef;
    my $headline = $c->param("flt_headline") || $params->{"flt_headline"}   || undef;
    my $rubric   = $c->param("flt_rubric")   || $params->{"flt_rubric"}     || undef;
    my $manager  = $c->param("flt_manager")  || $params->{"flt_manager"}    || undef;
    my $holder   = $c->param("flt_holder")   || $params->{"flt_holder"}     || undef;
    my $progress = $c->param("flt_progress") || $params->{"flt_progress"}   || undef;

    my $current_member = $c->getSessionValue("member.id");

    # Create Query headers
    my $sql_query = "
        SELECT
            dcm.id,

            dcm.edition, dcm.edition_shortcut,
            dcm.fascicle, dcm.fascicle_shortcut,
            dcm.headline, dcm.headline_shortcut,
            dcm.rubric, dcm.rubric_shortcut,

            dcm.group_id, dcm.fs_folder,
            dcm.maingroup, dcm.maingroup_shortcut,
            dcm.workgroup, dcm.workgroup_shortcut,
            dcm.inworkgroups, dcm.copygroup,

            dcm.holder,  dcm.holder_shortcut,
            dcm.creator, dcm.creator_shortcut,
            dcm.manager, dcm.manager_shortcut,

            dcm.islooked, dcm.isopen,
            dcm.branch, dcm.branch_shortcut,
            dcm.stage, dcm.stage_shortcut,
            dcm.color, dcm.progress,
            dcm.title, dcm.author,
            dcm.pages,

            to_char(dcm.pdate,    'YYYY-MM-DD HH24:MI:SS') as pdate,
            to_char(dcm.fdate,    'YYYY-MM-DD HH24:MI:SS') as fdate,

            dcm.psize,  dcm.rsize,
            dcm.images, dcm.files,

            to_char(dcm.created,  'YYYY-MM-DD HH24:MI:SS') as created,
            to_char(dcm.updated,  'YYYY-MM-DD HH24:MI:SS') as updated,
            to_char(dcm.uploaded, 'YYYY-MM-DD HH24:MI:SS') as uploaded,
            to_char(dcm.moved,    'YYYY-MM-DD HH24:MI:SS') as moved

        FROM documents dcm, fascicles fsc
        WHERE fsc.id = dcm.fascicle

    ";

    my $sql_total = "
        SELECT count(dcm.id)
        FROM documents dcm, fascicles fsc
        WHERE fsc.id = dcm.fascicle
    ";

    my $sql_filters = " ";

    # Set view restrictions
    my $editions    = $c->objectBindings("editions.documents.work:*");
    my $departments = $c->objectBindings("catalog.documents.view:*");

    $sql_filters .= " AND ( ";
    $sql_filters .= "    dcm.edition = ANY(?) ";
    $sql_filters .= "    AND ";
    $sql_filters .= "    ( dcm.workgroup = ANY(?) OR dcm.maingroup = ANY(?) )";
    $sql_filters .= " ) ";
    push @params, $editions;
    push @params, $departments;
    push @params, $departments;

    # Set Filters

    if ($mode eq "todo") {
        # get documents fpor departments
        my @holders;
        $sql_filters .= " AND dcm.holder = ANY(?) ";
        my $departments = $c->Q(" SELECT catalog FROM map_member_to_catalog WHERE member=? ", [ $current_member ])->Values;
        foreach (@$departments) {
            push @holders, $_;
        }
        push @holders, $current_member;
        push @params, \@holders;

        $sql_filters .= " AND fsc.enabled = true ";
        $sql_filters .= " AND dcm.fascicle <> '99999999-9999-9999-9999-999999999999' ";
    }

    if ($mode eq "all") {
        $sql_filters .= " AND fsc.enabled = true ";
        $sql_filters .= " AND dcm.fascicle <> '99999999-9999-9999-9999-999999999999' ";
        if ($fascicle && $fascicle ne "all" && $fascicle ne '00000000-0000-0000-0000-000000000000') {
            $sql_filters .= " AND dcm.fascicle <> '00000000-0000-0000-0000-000000000000' ";
        }
    }

    if ($mode eq "archive") {
        $sql_filters .= " AND fsc.enabled  <> true ";
        $sql_filters .= " AND dcm.fascicle <> '99999999-9999-9999-9999-999999999999' ";
        $sql_filters .= " AND dcm.fascicle <> '00000000-0000-0000-0000-000000000000' ";
    }

    if ($mode eq "briefcase") {
        $sql_filters .= " AND dcm.fascicle = '00000000-0000-0000-0000-000000000000' ";
    }

    if ($mode eq "recycle") {
        $sql_filters .= " AND dcm.fascicle = '99999999-9999-9999-9999-999999999999' ";
    }

    # Set Filters

    if ($title) {
        $sql_filters .= " AND dcm.title ILIKE ? ";
        push @params, "%$title%";
    }

    if ($edition && $edition ne "all") {
        $sql_filters .= " AND ? = ANY(dcm.ineditions) ";
        push @params, $edition;
    }

    if ($group && $group ne "all") {
        #$sql_filters .= " AND ? = ANY(dcm.inworkgroups) ";
        $sql_filters .= " AND dcm.maingroup = ? ";
        push @params, $group;
    }

    if ($fascicle && $fascicle ne "all") {
        $sql_filters .= " AND dcm.fascicle = ? ";
        push @params, $fascicle;
    }

    if ($headline && $headline ne "all") {
        $sql_filters .= " AND dcm.headline_shortcut = ? ";
        push @params, $headline;
    }

    if ($rubric && $rubric ne "all") {
        $sql_filters .= " AND dcm.rubric_shortcut = ? ";
        push @params, $rubric;
    }

    if ($manager && $manager ne "all") {
        $sql_filters .= " AND dcm.manager=? ";
        push @params, $manager;
    }

    if ($holder && $holder ne "all") {
        $sql_filters .= " AND dcm.holder=? ";
        push @params, $holder;
    }

    if ($progress && $progress ne "all") {
        $sql_filters .= " AND dcm.readiness=? ";
        push @params, $progress;
    }

    $sql_total .= $sql_filters;
    $sql_query .= $sql_filters;

    # Calculate total param
    my $total = $c->Q($sql_total, \@params)->Value || 0;

    # Setup soting
    if ($dir && $sort) {

        my @sortModes = ("ASC", "DESC");
        my @sortColumns= ("title", "maingroup_shortcut", "fascicle_shortcut",
            "headline_shortcut", "created", "updated", "uploaded", "moved",
            "rubric_shortcut", "pages", "manager_shortcut", "progress",
            "holder_shortcut", "images", "rsize");

        if ( $dir ~~ @sortModes ) {
            if ( $sort ~~ @sortColumns ) {

                if ($sort eq "pages") {
                    $sort = "firstpage";
                }

                $sql_query .= " ORDER BY ";

                if( $params->{baseSort} ) {
                    $sql_query .=  "dcm." . $params->{baseSort} .", " ;
                }

                $sql_query .=  " dcm.$sort $dir ";
            }
        }

    } else {
        if( $params->{baseSort} ) {
            $sql_query .=  " ORDER BY dcm." . $params->{baseSort};
        }
    }

    # Select rows with pagination
    if ($paginate eq "yes" && $limit > 0 && $start >= 0) {
        $sql_query .= " LIMIT ? OFFSET ? ";
        push @params, $limit;
        push @params, $start;
    }

    # Do sql query
    my $result = $c->Q($sql_query, \@params)->Hashes;

    # Postprocess query
    my $cacheAccess = {};
    foreach my $document (@$result) {

        $document->{title} =~ s/"/&quot;/ig;

        # Get files list
        my $fs_relative = $document->{fs_folder};
        my $fs_folder = $c->config->get("store.path") . $fs_relative;

        my $files  = Inprint::Store::Cache::getRecordsByPath($c, $fs_relative, "all", [ 'doc', 'rtf', 'odt', 'txt' ]);

        foreach my $file (@$files) {
            push @{ $document->{links} }, {
                id => $file->{id},
                name => $file->{name}
            };
        }

        # Fix filepath
        my $relativePath = $document->{fs_folder};

        # TODO Update images count
        my @images = ("jpg", "jpeg", "png", "gif", "bmp", "tiff" );
        my $imgCount = $c->Q(" SELECT count(*) FROM cache_files WHERE file_path=? AND file_exists = true AND file_extension=ANY(?) ", [ $relativePath, \@images ])->Value;
        $c->Do("UPDATE documents SET images=? WHERE fs_folder=? ", [ $imgCount || 0, $relativePath ]);

        # TODO Update rsize count
        my @documents = ("doc", "docx", "odt", "rtf", "txt" );
        my $lengthCount = $c->Q(" SELECT sum(file_length) FROM cache_files WHERE file_path=? AND file_exists = true AND file_extension=ANY(?) ", [ $relativePath, \@documents ])->Value;
        $c->Do("UPDATE documents SET rsize=? WHERE fs_folder=? ", [ $lengthCount || 0, $relativePath ]);

        # Get document pages
        $document->{pages} = __collapsePagesToString($document->{pages});

        # get copyes count
        my $copy_count = $c->Q("
            SELECT count(*) FROM documents
            WHERE 1=1
                AND copygroup=?
                AND fascicle <> '99999999-9999-9999-9999-999999999999'
            ", [ $document->{copygroup} ])->Value;
        if ($copy_count > 1) {
            $document->{title} = $document->{title} . " ($copy_count)";
        }

        $document->{access} = {};
        my @rules = qw(update capture move transfer briefcase delete recover fupload fedit fdelete);

        foreach (@rules) {

            undef my $term;

            if ($document->{holder} eq $current_member) {
                $term = "catalog.documents.$_:*";
            }

            if ($document->{holder} ne $current_member) {
                $term = "catalog.documents.$_:group";
            }

            if ( defined $cacheAccess->{$term ."::". $document->{workgroup}} ) {
                $document->{access}->{$_} = $cacheAccess->{$term ."::". $document->{workgroup}};
                next;
            }

            my $access = $c->objectAccess($term, $document->{workgroup});

            if ($access) {
                $cacheAccess->{$term ."::". $document->{workgroup}} = $c->json->true;
                $document->{access}->{$_} = $c->json->true;
            } else {
                $cacheAccess->{$term ."::". $document->{workgroup}} = $c->json->false;
                $document->{access}->{$_} = $c->json->false;
            }

        }

    }

    return { "result" => $result, "total" => $total };
}

sub __collapsePagesToString {

    my $data = shift;

    return "" unless $data;

    my @pages;
    my @string;

    if (ref $data eq 'ARRAY') {
        @pages = @$data;
    } else {
        @pages = split(/[^\d]+/, $data );
    }

    for ( my $i = 0; $i <= $#pages; $i++ ) {

        my $currentPage = int( $pages[$i] );

        next unless $currentPage;

        if (! int( $pages[$i-1] ) ) {
            push @string, $currentPage;
        }

        elsif (! $pages[$i+1] ) {
            push @string, $currentPage;
        }

        elsif ( int( $pages[$i-1] ) && $pages[$i+1] && $currentPage-1 == int( $pages[$i-1] ) && $currentPage+1 == $pages[$i+1] ) {
            push @string, "-";
        }

        else {
            push @string, $currentPage;
        }

    };

    my $string = join (',',@string);
    $string =~ s/,-,/-/g;
    $string =~ s/-,/-/g;
    $string =~ s/-+/-/g;
    $string =~ s/,/, /g;

    return $string;
}

1;
