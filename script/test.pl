#!/usr/bin/env perl
use Mojolicious::Lite;

any '/' => sub {
    my $self = shift;
    
    my $text = '
        <form method="post">
            <input type="text" name="text" value="111">
            <input type="submit">
        </form>
        <form method="get">
            <input type="text" name="text" value="222">
            <input type="submit">
        </form>
    ';
    
    my $value = $self->param("text");
    
    $self->render_text($value . $text);
};

app->start;
