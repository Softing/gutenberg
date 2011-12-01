package Inprint::Database::Service::Fascicle;

use Moose;

use utf8;
use strict;
use warnings;

use Inprint::Database::Model::Edition;
use Inprint::Database::Service::Requests;

extends "Inprint::Database::Model::Fascicle";

sub Edition {
    my ($self) = @_;
    my $sqldata = $self->sql->Q(" SELECT * FROM editions WHERE id = ? ", $self->edition)->Hash;
    return new Inprint::Database::Model::Edition( app => $self->app )->map($sqldata);
}

sub Pages {
    my ($self) = @_;
    my $sqldata = $self->sql->Q(" SELECT * FROM fascicles_pages WHERE fascicle = ? ORDER BY seqnum", $self->id)->Hashes;
    my @pages;
    foreach (@$sqldata) {
        push @pages, new Inprint::Database::Service::Page( app => $self->app )->map($_);
    }
    return \@pages;
}

sub Requests {
    my ($self) = @_;
    return Inprint::Database::Service::Requests->new( app => $self->app )->list( fascicle => $self->id )->json;
}

sub Access {

    my ($self) = @_;

    my $member = $self->app->getSessionValue("member.id");

    my $canCompose = 0;

    if ($self->fastype eq "fascicle") {
        $canCompose = $self->app->objectAccess("editions.fascicle.manage:*", $self->edition);
    }

    if ($self->fastype eq "attachment") {
        $canCompose = $self->app->objectAccess("editions.attachment.manage:*", $self->edition);
    }

    my $canAdvert  = $self->app->objectAccess("editions.advert.manage:*",   $self->edition);

    my $access = {};

    $access->{open}     = $canCompose;
    $access->{capture}  = 0;
    $access->{close}    = 0;
    $access->{save}     = 0;
    $access->{advert}   = $canAdvert;

    if ($self->manager) {

        $access->{open}  = 0;
        $access->{capture}  = 1;

        $access->{manager} = $self->manager;
        $access->{manager_shortcut} = $self->sql->Q("SELECT shortcut FROM profiles WHERE id=?", $self->manager)->Value;

        if ($self->manager eq $member) {
            $access->{open}    = 0;
            $access->{capture} = 0;
            $access->{close}   = 1;
            $access->{save}    = 1;
        }

    }

    return $access;
}

sub Summary {

    my ($self) = @_;

    my $statusbar_all = $self->sql->Q("
        SELECT count(*)
        FROM fascicles_pages
        WHERE fascicle=? AND seqnum is not null ", [ $self->id ])->Value;

    my $statusbar_adv = $self->sql->Q("
            SELECT sum(t1.area)
            FROM fascicles_modules t1, fascicles_map_modules t2, fascicles_pages t3
            WHERE
                t2.module = t1.id AND t2.page = t3.id AND t3.fascicle=?
        ", [ $self->id ]
    )->Value || 0;

    my $statusbar_doc = $statusbar_all - $statusbar_adv;

    my $statusbar_doc_average = 0;

    if ($statusbar_all > 0) {
        $statusbar_doc_average = $statusbar_doc/ $statusbar_all * 100 ;
    }

    my $statusbar_adv_average = 0;
    if ($statusbar_all > 0) {
        $statusbar_adv_average = $statusbar_adv/ $statusbar_all * 100 ;
    }

    my $summary = {};

    $summary->{pc}  = $statusbar_all || 0;
    $summary->{dc}  = sprintf "%.2f", $statusbar_doc || 0;
    $summary->{ac}  = sprintf "%.2f", $statusbar_adv || 0;
    $summary->{dav} = sprintf "%.2f", $statusbar_doc_average || 0;
    $summary->{aav} = sprintf "%.2f", $statusbar_adv_average || 0;

    return $summary;
}

1;
