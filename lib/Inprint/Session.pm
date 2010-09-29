package Inprint::Session;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use base 'Inprint::BaseController';

sub login
{
    my $c = shift;

    if (defined $c->param('ajax') && $c->param('ajax') eq 'true') {

        my $i_login    = $c->param('login') || "";
        my $i_password = $c->param('password') || "";

        my $sid = undef;
        my $json = {
            success => ""
        };

        unless ($i_login ) {
           $json->{success} = 'false';
           push @{ $json->{errors} }, { msg => 'The login is not specified' }
        }

        unless ( $i_password ) {
           $json->{success} = 'false';
           push @{ $json->{errors} }, { msg => 'The password is not specified' }
        }

        # пытаемся найти сотрудника с таким логином
        unless($json->{success} eq 'false'){
           my $exist = $c->sql->Q(" SELECT count(*) FROM members WHERE login=?", [ $i_login ])->Value;
           if ( $exist != 1 ){
              $json->{success} = 'false';
              push @{ $json->{errors} }, { msg => 'The empoyee not found' }
           }
        }

        # пытаемся провести утентификацию
        unless($json->{success} eq 'false') {

            my $member = $c->sql->Q(
                "   SELECT t1.id, t1.login
                    FROM members t1
                        LEFT JOIN profiles t2 ON t1.id = t2.id
                    WHERE
                        t1.login =? AND t1.password =encode( digest(?, 'sha256'), 'hex') ",
                [ $i_login, $i_password ]
            )->Hash;

            # сотрудник найден, создаем сесссию
            if ($member->{id}) {

                $sid = $c->uuid();

                # Мультилогин выключен, удаляем все предыдущие сессии для юзера
                unless ( $c->config->{'core.multilogin'}) {
                    $c->sql->Do("DELETE FROM sessions WHERE member =? ", [ $member->{id} ]);
                }

                # Insert session
                $c->sql->Do("
                    INSERT INTO sessions(id, member, ipaddress)
                        VALUES (?,?,'');
                ",
                    [ $sid, $member->{id} ]
                );

                $c->session( sid=>$sid );
                $c->session( member=>$member->{id} );

                $json->{success}   = 'true';

            } else {
                $json->{success} = 'false';
                push @{ $json->{errors} }, { msg => 'Wrong password' }
            }

        }

        $c->render_json($json);
    }
}

sub logout {
    my $c = shift;
    $c->sql->Do("DELETE FROM sessions WHERE id=?", [ $c->session("sid") ] );
    $c->redirect_to("/");
}

1;
