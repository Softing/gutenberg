package Inprint::Utils;

sub GetEditionById {
    my $c  = shift;
    my %params = ( @_ );
    
    my @params = ($params{id});
    my $sql = " SELECT id, shortcut FROM editions WHERE id=? ";
    
    my $result = $c->sql->Q($sql, \@params)->Hash;
    
    return $result || undef;
}

sub GetFascicleById {
    my $c  = shift;
    my %params = ( @_ );
    
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
    
    my @params = ();
    my $sql = "
        SELECT t1.id, t1.shortcut FROM index t1, index_mapping t2
        WHERE t1.id = t2.child 
    ";
    
    if ($params{id}) {
        $sql .= " AND t1.id=?  ";
        push @params, $params{id};
    }
    
    if ($params{fascicle}) {
        $sql .= " AND t2.parent=?  ";
        push @params, $params{fascicle};
    }
    
    my $result = $c->sql->Q($sql, \@params)->Hash;
    
    return $result || undef;
}

sub GetRubricById {
    my $c  = shift;
    my %params = ( @_ );
    
    my @params = ();
    my $sql = "
        SELECT t1.id, t1.shortcut FROM index t1, index_mapping t2
        WHERE t1.id = t2.child 
    ";
    
    if ($params{id}) {
        $sql .= " AND t1.id=?  ";
        push @params, $params{id};
    }
    
    if ($params{headline}) {
        $sql .= " AND t2.parent=?  ";
        push @params, $params{headline};
    }
    
    my $result = $c->sql->Q($sql, \@params)->Hash;
    
    return $result || undef;
}

sub GetDocumentById {
    my $c  = shift;
    my %params = ( @_ );
    
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
    
    if ($params{id}) {
        $sql .= " AND t1.id=?  ";
        push @params, $params{id};
    }
    
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

sub encodePagesArray {

    my $data = shift;
    
    my @pages;
    my @string;
    
    if (ref $data eq 'ARRAY') {
        @pages = @$data;
    } else {
        @pages = split(/[^\d]+/, @$data );
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
    
    $string = join (',',@string);
    $string =~ s/,-,/-/g;
    $string =~ s/-,/-/g;
    $string =~ s/-+/-/g;
    $string =~ s/,/, /g;
    
    return $string;
}

1;