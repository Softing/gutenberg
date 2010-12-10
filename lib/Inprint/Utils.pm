package Inprint::Utils;

use strict;

sub GetEditionById {
    my $c  = shift;
    my %params = ( @_ );
    
    return undef unless $params{id};
    
    my @params = ($params{id});
    my $sql = " SELECT id, shortcut FROM editions WHERE id=? ";
    
    my $result = $c->sql->Q($sql, \@params)->Hash;
    
    return $result || undef;
}

sub GetFascicleById {
    my $c  = shift;
    my %params = ( @_ );
    
    return undef unless $params{id};
    
    my @params = ($params{id});
    my $sql = " SELECT id, edition, shortcut FROM fascicles WHERE id=? ";
    
    if ($params{edition}) {
        $sql .= " AND edition=? ";
        push @params, $params{id};
    }
    
    my $result = $c->sql->Q($sql, \@params)->Hash;
    
    return $result || undef;
}

sub GetHeadlineById {
    my $c  = shift;
    my %params = ( @_ );
    
    return undef unless $params{id};
    
    my @params = ();
    my $sql = "
        SELECT t1.id, t1.shortcut FROM index_fascicles t1
        WHERE nature='headline'
    ";
    
    
    if ($params{id}) {
        $sql .= " AND t1.id=?  ";
        push @params, $params{id};
    }
    
    if ($params{fascicle} && $params{fascicle} ne '00000000-0000-0000-0000-000000000000') {
        $sql .= " AND t1.fascicle=?  ";
        push @params, $params{fascicle};
    }
    
    my $result = $c->sql->Q($sql, \@params)->Hash;
    
    return $result || undef;
}

sub GetRubricById {
    my $c  = shift;
    my %params = ( @_ );
    
    return undef unless $params{id};
    
    my @params = ();
    
    my $sql = "
        SELECT t1.id, t1.shortcut FROM index_fascicles t1
        WHERE nature='rubric'
    ";
    
    if ($params{id}) {
        $sql .= " AND t1.id=?  ";
        push @params, $params{id};
    }
    
    if ($params{fascicle} && $params{fascicle} ne '00000000-0000-0000-0000-000000000000') {
        $sql .= " AND t1.fascicle=?  ";
        push @params, $params{fascicle};
    }
    
    if ($params{headline}) {
        $sql .= " AND t1.parent=?  ";
        push @params, $params{headline};
    }
    
    my $result = $c->sql->Q($sql, \@params)->Hash;
    
    return $result || undef;
}

sub GetDocumentById {
    my $c  = shift;
    my %params = ( @_ );
    
    return undef unless $params{id};
    
    my @params = ();
    my $sql = "
        SELECT
            t1.id,
            t1.workgroup,
            t1.filepath,
            t1.edition, t1.fascicle, t1.headline, t1.rubric,
            t1.manager, t1.holder,
            t1.filepath
        FROM documents t1 WHERE 1=1 ";
    
    $sql .= " AND t1.id=?  ";
    push @params, $params{id};
    
    my $result = $c->sql->Q($sql, \@params)->Hash;
    
    return $result || undef;
}

sub UpdateHeadline {
    my $c  = shift;
    my %params = ( @_ );
}

sub UpdateRubric {
    my $c  = shift;
    my %params = ( @_ );
}

sub CollapsePagesToString {

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

        my $cp = int( $pages[$i] );
        my $pp = int( $pages[$i-1] );
        my $fp = int( $pages[$i+1] );

        next unless $cp;

        if ( !$pp ) {
                push @string, $cp;
        } elsif (!$fp ) {
                push @string, $cp;
        } elsif ( $pp && $fp && $cp-1 == $pp && $cp+1 == $fp ) {
                push @string, "-";
        } else {
                push @string, $cp;
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