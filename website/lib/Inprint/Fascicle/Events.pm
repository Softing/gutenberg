package Inprint::Fascicle::Events;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use Inprint::Database;

use base 'Mojolicious::Controller';


sub onCompositionChanged {
    my ($c, $fascicle) = @_;

    # Update revision
    $c->Do(" UPDATE fascicles SET variation = uuid_generate_v4() WHERE id=? ", $fascicle->{id});

    # Clear image cache
    my $tempPath = $c->config->get("store.temp");
    my $cachedir = "$tempPath/fascicles/$fascicle->{id}";

    if (-w $cachedir) {
        opendir(DIR, $cachedir) or die $!;
        while (my $file = readdir(DIR)) {
            next if ($file =~ m/^\./);
            unlink "$cachedir/$file";
        }
    }

    # Update page's cache
    $c->Do("
            UPDATE documents SET
                pages = array_to_string(
                    ARRAY( SELECT seqnum FROM fascicles_pages as pages, fascicles_map_documents as mapping
                        WHERE mapping.page = pages.id AND mapping.entity = documents.id ORDER BY pages.seqnum )
                    , ','),
                firstpage = ( SELECT min(seqnum) FROM fascicles_pages as pages, fascicles_map_documents as mapping
                        WHERE mapping.page = pages.id AND mapping.entity = documents.id
                )
            WHERE fascicle = ? ",
        [ $fascicle->{id} ]);

    # Update request's cache
    $c->Do("
            UPDATE fascicles_requests source
                SET
                    pages = array_to_string(
                        ARRAY(
                            SELECT seqnum
                            FROM
                                fascicles_pages as pages,
                                fascicles_requests as requests,
                                fascicles_map_modules as mappings
                            WHERE 1=1
                                AND mappings.page = pages.id
                                AND requests.module = mappings.module
                                AND requests.id = source.id
                            ORDER BY pages.seqnum ), ','),
                    firstpage = (
                        SELECT min(seqnum)
                        FROM
                            fascicles_pages as pages,
                            fascicles_requests as requests,
                            fascicles_map_modules as mappings
                        WHERE 1=1
                            AND mappings.page = pages.id
                            AND requests.module = mappings.module
                            AND requests.id = source.id )
            WHERE fascicle = ? ",
        [ $fascicle->{id} ]);
}

1;
