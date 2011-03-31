package Inprint::Reports::Advertising::Fascicle;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Encode;
use Inprint::Check;
use Spreadsheet::WriteExcel;

use utf8;

use base 'Inprint::BaseController';

sub index {

    my $c = shift;

    my $i_fascicle = $c->param("fascicle") || undef;

    my @errors;

    Inprint::Check::uuid($c, \@errors, "fascicle", $i_fascicle);
    my $fascicle = Inprint::Check::fascicle($c, \@errors, $i_fascicle);
    my $edition  = Inprint::Check::edition($c, \@errors, $fascicle->{edition});

    my $filename = "отчет по рекламе ". $edition->{shortcut} ."-". $fascicle->{shortcut} .".xls";

    my $filepath  = "/tmp/excel.xls";
    my $mimetype  = "application/excel";
    my $extension = "xls";

    my $workbook = Spreadsheet::WriteExcel->new($filepath);

    unless (@errors) {

        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
        $mon++;
        $year += 1900;

        my $worksheet = $workbook->add_worksheet("Cover Sheet");

        my $fmtBold = $workbook->add_format();
        $fmtBold->set_bold();

        $worksheet->write(0, 0, "Отчет по рекламе для выпуска - <". $fascicle->{shortcut} .">", $fmtBold);

        $worksheet->write(1, 0, "(От $mday/$mon/$year в $hour:$min)");
        $worksheet->write(3, 0, $edition->{shortcut} ."/". $fascicle->{shortcut});

        my $fmtHeader = $workbook->add_format();
        $fmtHeader->set_border();
        $fmtHeader->set_text_wrap();
        $fmtHeader->set_align("center");

        $worksheet->set_column(0, 0,  10);
        $worksheet->set_column(1, 1,  10);
        $worksheet->set_column(2, 2,  10);
        $worksheet->set_column(3, 3,  10);
        $worksheet->set_column(4, 4,  10);
        $worksheet->set_column(5, 5,  40);

        $worksheet->write(6, 0, "№\n п/п" . $fascicle->{title}, $fmtHeader);
        $worksheet->write(6, 1, "№\n полосы" . $fascicle->{title}, $fmtHeader);
        $worksheet->write(6, 2, "Номер\n заявки" . $fascicle->{title}, $fmtHeader);
        $worksheet->write(6, 3, "Размер\n в модулях" . $fascicle->{title}, $fmtHeader);
        $worksheet->write(6, 4, "Размер\n в полосах" . $fascicle->{title}, $fmtHeader);
        $worksheet->write(6, 5, "Описание" . $fascicle->{title}, $fmtHeader);

        my $requests = $c->Q("
            SELECT requests.*, modules.id as module, modules.title as module_title, modules.description as module_description
            FROM fascicles_requests requests
                LEFT OUTER JOIN fascicles_modules modules ON modules.id = requests.module
            WHERE requests.fascicle=?
            ", $fascicle->{id})->Hashes;

        my $fmtBody = $workbook->add_format();
        $fmtBody->set_border();
        $fmtBody->set_align("left");
        $fmtBody->set_text_wrap();
        $fmtBody->set_num_format(0);

        my $rowCounter = 7;
        foreach my $item (@$requests) {
            $worksheet->write($rowCounter, 0, $rowCounter-6, $fmtBody);
            $worksheet->write($rowCounter, 1, $item->{pages} . $fascicle->{title}, $fmtBody);
            $worksheet->write($rowCounter, 2, $item->{serialnum}, $fmtBody);
            $worksheet->write($rowCounter, 3, $item->{module_description}, $fmtBody);
            $worksheet->write($rowCounter, 4, $item->{module_title}, $fmtBody);

            $worksheet->write($rowCounter, 5, $item->{shortcut}, $fmtBody);
            $rowCounter++;
        }

    }

    $workbook->close();

    $c->tx->res->headers->content_type($mimetype);
    $c->res->content->asset(Mojo::Asset::File->new(path => $filepath));

    $filename = encode("utf8", $filename);
    $filename =~ s/\s+/_/g;

    my $headers = Mojo::Headers->new;
    $headers->add("Content-Type", "$mimetype;name=$filename");
    $headers->add("Content-Disposition", "attachment;filename=$filename");
    $headers->add("Content-Description", $extension);
    $c->res->content->headers($headers);

    $c->render_static();

}


1;
