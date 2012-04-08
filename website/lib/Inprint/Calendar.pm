package Inprint::Calendar;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Calendar::Copy;

use base 'Mojolicious::Controller';

sub properties {
    my $c = shift;

    my @errors;

    $c->smart_render(\@errors);
}

sub format {
    my $c = shift;

    my @errors;

    my $i_id           = $c->get_uuid(\@errors, "id");
    my $i_template     = $c->get_uuid(\@errors, "template");
    my $i_confirmation = $c->get_text(\@errors, "confirmation");

    push @errors, { id => "confirmation", msg => "Incorrectly filled field"}
        unless ( $i_confirmation eq "on" );

    unless (@errors) {
        Inprint::Calendar::Copy::copyFromTemplate($c, $i_id, $i_template);
    }

    $c->smart_render(\@errors);
}

sub archive {
    my $c = shift;

    my @errors;

    my $i_id           = $c->get_uuid(\@errors, "id");

    unless (@errors) {

        $c->txBegin;

        my $fascicles = $c->Q(" SELECT id FROM fascicles WHERE parent=\$1 OR id=\$1 ", $i_id)->Values;

        $c->Do("
            UPDATE fascicles SET
                archived = true,
                enabled = false
            WHERE id= ANY(?) ", [ $fascicles ]);

        # Move linked documents to Archive
        $c->Do("
            UPDATE documents SET
                isopen=false
            WHERE 1=1
                AND fascicle = ANY(\$1)
                AND EXISTS(
                    SELECT true
                    FROM fascicles_map_documents as fasmap
                    WHERE 1=1
                        AND fasmap.fascicle=documents.fascicle
                        AND fasmap.entity = documents.id)", [ $fascicles ]);

        # Move unlinked documents to Briefcase
        $c->Do("
            UPDATE documents SET
                isopen=true,
                fascicle = \$1,
                fascicle_shortcut = \$2
            WHERE 1=1
                AND fascicle = ANY(\$3)
                AND NOT EXISTS(
                    SELECT true
                    FROM fascicles_map_documents as fasmap
                    WHERE 1=1
                        AND fasmap.fascicle=documents.fascicle
                        AND fasmap.entity = documents.id)",
            [ '00000000-0000-0000-0000-000000000000', $c->l("Briefcase"), $fascicles ]);

        $c->txCommit;

    }

    $c->smart_render(\@errors);
}

sub unarchive {
    my $c = shift;

    my @errors;

    my $i_id = $c->get_uuid(\@errors, "id");

    unless (@errors) {
        $c->txBegin;

        my $fascicles = $c->Q(" SELECT id FROM fascicles WHERE parent=\$1 OR id=\$1 ", $i_id)->Values;

        $c->Do("
            UPDATE fascicles SET
                archived = false,
                enabled = true
            WHERE id= ANY(?) ", [ $fascicles ]);

        # Move linked documents to Archive
        $c->Do("
            UPDATE documents SET
                isopen=true
            WHERE 1=1
                AND fascicle = ANY(\$1)", [ $fascicles ]);

        $c->txCommit;
    }

    $c->smart_render(\@errors);
}

sub enable {
    my $c = shift;

    my $result;
    my @errors;

    my $i_id = $c->get_uuid(\@errors, "id");

    unless (@errors) {
        $c->Do(" UPDATE fascicles SET enabled = true WHERE id=? ", [ $i_id ]);
    }

    $c->smart_render(\@errors, $result);
}

sub disable {
    my $c = shift;

    my $result;
    my @errors;

    my $i_id = $c->get_uuid(\@errors, "id");

    unless (@errors) {
        $c->Do(" UPDATE fascicles SET enabled = false WHERE id=? ", [ $i_id ]);
    }

    $c->smart_render(\@errors, $result);
}


1;
