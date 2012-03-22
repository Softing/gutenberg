# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

package Inprint::Options;

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub update {

    my $c = shift;

    my @errors;

    my $member_id     = $c->getSessionValue("member.id");

    my $i_edition           = $c->param("edition");
    my $i_workgroup         = $c->param("workgroup");

    my $i_font_size         = $c->param("font-size");
    my $i_font_style        = $c->param("font-style");

    $c->check_uuid( \@errors, "node", $i_edition);
    $c->check_uuid( \@errors, "node", $i_workgroup);

    my $edition   = $c->check_record(\@errors, "editions", "edition", $i_edition);
    my $workgroup = $c->check_record(\@errors, "catalog", "workgroup", $i_workgroup);

    unless (@errors) {

        $c->Do("DELETE FROM options WHERE member=?", [$member_id]);

        $c->Do("INSERT INTO OPTIONS (member, option_name, option_value) VALUES (?, ?, ?)", [$member_id, "default.edition", $edition->{id} ]);
        $c->Do("INSERT INTO OPTIONS (member, option_name, option_value) VALUES (?, ?, ?)", [$member_id, "default.edition.name", $edition->{shortcut} ]);

        $c->Do("INSERT INTO OPTIONS (member, option_name, option_value) VALUES (?, ?, ?)", [$member_id, "default.workgroup", $workgroup->{id} ]);
        $c->Do("INSERT INTO OPTIONS (member, option_name, option_value) VALUES (?, ?, ?)", [$member_id, "default.workgroup.name", $workgroup->{shortcut} ]);

        if ($i_font_style ~~ [ "times new roman" ]) {
            $c->Do("INSERT INTO OPTIONS (member, option_name, option_value) VALUES (?, ?, ?)", [$member_id, "default.font.style", $i_font_style ]);
        }

        if ($i_font_size ~~ [ "small", "medium", "large" ]) {
            $c->Do("INSERT INTO OPTIONS (member, option_name, option_value) VALUES (?, ?, ?)", [$member_id, "default.font.size", $i_font_size ]);
        }

    }

    $c->smart_render(\@errors);

}


1;
