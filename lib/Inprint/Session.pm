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
    
    if ($c->param('ajax') eq 'true') {
        
        #my $i_edition  = $c->param('edition');
        my $i_login    = $c->param('login');
        my $i_password = $c->param('password');
        
        my $sid = undef;
        my $json = {};
        
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
           my $exist = $c->sql->Q(" SELECT count(*) FROM passport.member WHERE uid=?", [ $i_login ])->Value;
           if ( $exist != 1 ){
              $json->{success} = 'false';
              push @{ $json->{errors} }, { msg => 'The empoyee not found' }
           }
        }
        
        # пытаемся провести утентификацию
        unless($json->{success} eq 'false') {
            
            my $member = $c->sql->Q(
                "SELECT t1.uuid as id, t1.uid as login, t2.title, t2.stitle
                    FROM passport.member t1, passport.card t2
                    WHERE uid=? AND secret=encode( digest(?, 'sha256'), 'hex')
                        AND t1.uuid = t2.uuid ",
                [ $i_login, $i_password ]
            )->Hash;

            # сотрудник найден, создаем сесссию
            if ($member->{id}) {
    
                $sid = $c->uuid();
                
                # Мультилогин выключен, удаляем все предыдущие сессии для юзера
                unless ( $c->config->{'core.multilogin'}) {
                    $c->sql->Do("DELETE FROM inp_session WHERE member_id=?", [ $member->{id} ]);
                }
    
                # Insert session
                $c->sql->Do("
                    INSERT INTO inp_session(sid, member_id, member_login, member_title, member_stitle, created, updated)
                        VALUES (?,?,?,?,?, now(), now());
                ",
                    [ $sid, $member->{id}, $member->{login}, $member->{title}, $member->{stitle}  ]
                );
                
                $c->session(sid=>$sid);
                
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
    $c->sql->Do("DELETE FROM inp_session WHERE sid=?", [ $c->session("sid") ] );
    $c->redirect_to("/");
}

1;
