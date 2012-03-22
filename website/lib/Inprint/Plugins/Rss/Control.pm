package Inprint::Plugins::Rss::Control;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub tree {
    my $c = shift;

    my @errors, my @result;

    my $i_node = $c->param("node");
    $i_node = '00000000-0000-0000-0000-000000000000' unless ($i_node);
    $i_node = '00000000-0000-0000-0000-000000000000' if ($i_node eq "root-node");

    $c->check_uuid( \@errors, "id", $i_node);

    unless (@errors) {

        my $data = $c->Q(
            "SELECT t1.* FROM plugins_rss.rss_feeds t1 ORDER BY title "
            )->Hashes;

        foreach my $item (@$data) {
            my $record = {
                id   => $item->{id},
                text => $item->{title} . " (". $item->{url} .")",
                leaf => $c->json->true,
                icon => "feed",
                data => $item
            };
            push @result, $record;
        }
    }

    $c->render_json( \@result );
}

sub list {
    my $c = shift;

    my @errors;
    my $success = $c->json->false;

    my $result;

    unless (@errors) {

        # Find editions
        my $editions = $c->Q("
                SELECT editions.*,
                    (
                        SELECT COUNT(*) FROM indx_headlines indx
                        WHERE true
                            AND indx.edition = editions.id
                            AND indx.id <> '00000000-0000-0000-0000-000000000000'
                    ) as leaf
                FROM editions
                ORDER BY shortcut
            ")->Hashes;

        foreach my $edition (@$editions) {

            my $record = {
                id => $edition->{id} . "::edition",
                title => $edition->{shortcut},
                description => $edition->{description},
                level => 1
            };

            push @$result, $record;

            # Find headlines
            my $headlines = $c->Q("
                    SELECT *,
                        (
                            SELECT COUNT(*) FROM indx_rubrics indx
                            WHERE true
                                AND indx.headline = indx_headlines.id
                                AND indx.id <> '00000000-0000-0000-0000-000000000000'
                        ) as leaf
                    FROM indx_headlines
                    WHERE edition=?
                    ORDER BY title ",
                $edition->{id})->Hashes;

            # Find rubrics for eah headline
            foreach my $headline (@$headlines) {

                my $record2 = {
                    id => $headline->{tag} . "::headline",
                    title => $headline->{title},
                    description => $headline->{description},
                    level => 2
                };

                push @$result, $record2;

                my $rubrics = $c->Q("
                        SELECT *
                        FROM indx_rubrics
                        WHERE headline=?
                        ORDER BY title ",
                    $headline->{id})->Hashes;

                foreach my $rubric (@$rubrics) {

                    my $record3 = {
                        id => $rubric->{tag} . "::rubric",
                        title => $rubric->{title},
                        description => $rubric->{description},
                        level => 3
                    };

                    push @$result, $record3;
                }
            }

        }
    }

    $c->smart_render(\@errors, $result);
}

sub create {
    my $c = shift;

    my @errors;

    my $id            = $c->uuid();
    my $i_url         = $c->param("url");
    my $i_title       = $c->param("title");
    my $i_description = $c->param("description");

    $c->check_url( \@errors,  "url", $i_url);
    $c->check_text( \@errors, "title", $i_title);
    $c->check_text( \@errors, "description", $i_description, 1);
    #$c->check_access( \@errors,  "");

    unless (@errors) {
        $c->Do("
            INSERT INTO plugins_rss.rss_feeds (id, url, title, description)
                VALUES (?, ?, ?, ?)
        ", [ $id, $i_url, $i_title, $i_description ]);
    }

    $c->smart_render(\@errors);
}

sub read {
    my $c = shift;

    my @errors;
    my $result = [];

    my $i_id = $c->param("id");
    $c->check_uuid( \@errors,  "id", $i_id);

    unless (@errors) {
        $result = $c->Q("
                SELECT *
                FROM plugins_rss.rss_feeds
                WHERE id=? ",
            [ $i_id ])->Hash;
    }

    $c->smart_render(\@errors, $result);
}

sub update {
    my $c = shift;

    my @errors;

    my $i_id          = $c->param("id");
    my $i_url         = $c->param("url");
    my $i_title       = $c->param("title");
    my $i_description = $c->param("description");

    $c->check_uuid( \@errors, "id", $i_id);
    $c->check_url(  \@errors, "url", $i_url);
    $c->check_text( \@errors, "title", $i_title);
    $c->check_text( \@errors, "description", $i_description, 1);

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        if ($i_id eq "00000000-0000-0000-0000-000000000000");

    unless (@errors) {

        $c->Do("
                UPDATE plugins_rss.rss_feeds
                SET url=?, title=?, description=?
                WHERE id=? ",
            [ $i_url, $i_title, $i_description, $i_id ]);
    }

    $c->smart_render(\@errors);
}

sub delete {
    my $c = shift;

    my @errors;

    my $i_id = $c->param("id");

    $c->check_uuid( \@errors,  "id", $i_id);
    #$c->check_access( \@errors,  "");
    push @errors, { id => "id", msg => "Incorrectly filled field"}
        if ($i_id eq "00000000-0000-0000-0000-000000000000");

    unless (@errors) {
        $c->Do(" DELETE FROM plugins_rss.rss_feeds WHERE id=? ", [ $i_id ]);
    }

    $c->smart_render(\@errors);
}

sub fill {
    my $c = shift;
    my $i_feed = $c->param("feed");

    my @errors;

    $c->check_uuid( \@errors,  "feed", $i_feed);
    #$c->check_access( \@errors,  "");

    my $result = []; unless (@errors) {
        $result = $c->Q("
                SELECT tag || '::' || nature
                FROM plugins_rss.rss_feeds_mapping
                WHERE feed=? ",
            $i_feed)->Values;
    }

    $c->smart_render(\@errors, $result);
}


sub save {
    my $c = shift;

    my @errors;

    my $i_feed    = $c->param("feed");
    my @i_rubrics = $c->param("rubrics");

    $c->check_uuid( \@errors,  "feed", $i_feed);
    #$c->check_access( \@errors,  "");

    $c->Do(" DELETE FROM plugins_rss.rss_feeds_mapping WHERE feed=? ", [ $i_feed ]);

    foreach my $rubric_str (@i_rubrics) {

        my ($tag, $nature) = split '::', $rubric_str;

        next unless $tag || $nature;

        $c->Do("
                INSERT INTO plugins_rss.rss_feeds_mapping (feed, nature, tag)
                VALUES (?, ?, ?)
            ", [ $i_feed, $nature, $tag ]);

    }

    $c->smart_render(\@errors);
}

1;
