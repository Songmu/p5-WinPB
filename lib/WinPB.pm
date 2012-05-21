package WinPB;
use strict;
use warnings;
use utf8;
our $VERSION = '0.01';

use Encode qw/encode_utf8/;
use Any::Moose;
use Router::Simple;
use Plack::Request;
use namespace::autoclean;
use Tkx;

has router => (
    is => 'ro',
    isa => 'Router::Simple',
    default => sub { Router::Simple->new },
    handles => [qw/connect match/],
);

sub register {
    my $self = shift;
    $self->connect( '/' => {
        action  => sub {
            my $req = shift;
            my $text = $req->param('pb');
            return 'NG' unless defined $text;
            Tkx::clipboard('clear');
            Tkx::clipboard('append', $text);
            'OK';
        },
    }, {method  => 'POST'});

    $self->connect( '/' => {
        action  => sub {
            my $req = shift;
            Tkx::clipboard('get');
        },
    }, {method  => 'GET'});

}

sub to_app {
    my $self = shift;
    return sub {
        $self->process(@_);
    };
}

sub process {
    my ($self, $env) = @_;
    $self->register;
    my $matched = $self->match($env);

    return [404, [], ['NOT FOUND']] unless $matched;

    my $req = Plack::Request->new($env);
    my $res = $req->new_response(200);
    $res->content_type('text/plain; charset="UTF-8"');
    $res->body(
        encode_utf8 $matched->{action}->($req)
    );
    $res->finalize;
}


__PACKAGE__->meta->make_immutable;
__END__

=head1 NAME

WinPB -

=head1 SYNOPSIS

  use WinPB;

=head1 DESCRIPTION

WinPB is

=head1 AUTHOR

Masayuki Matsuki E<lt>y.songmu@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
