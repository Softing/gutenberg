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
    my $sql = " SELECT id, shortcut FROM fascicles WHERE id=? ";
    
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
            t1.manager, t1.holder
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

1;