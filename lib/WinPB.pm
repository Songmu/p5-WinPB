package WinPB;
use strict;
use warnings;
use utf8;
our $VERSION = '0.01';

use Encode qw/encode_utf8 decode/;
use Router::Simple;
use Plack::Request;
use Win32::Clipboard;

sub new {
    bless +{ _router => Router::Simple->new }, shift;
}
sub router  {shift->{_router}}
sub connect {shift->router->connect(@_)}
sub match   {shift->router->match(@_)}

my $cp932   = Encode::find_encoding('cp932');
my $utf8    = Encode::find_encoding('utf-8');
my $utf16le = Encode::find_encoding('UTF16-LE');

sub register {
    my $self = shift;
    $self->connect( '/' => {
        action  => sub {
            my $req = shift;
            my $text = $req->param('pb');
            return 'NG' unless defined $text;
            Encode::from_to($text, $utf8, $cp932);
            Win32::Clipboard::Set($text);
            'OK';
        },
    }, {method  => 'POST'});

    $self->connect( '/' => {
        action  => sub {
            my $req = shift;
            my $text = Win32::Clipboard::GetAs(CF_UNICODETEXT);
            decode($utf16le, $text);
        },
    }, {method  => 'GET'});
}

sub to_app {
    my $self = shift;
    $self->register;
    return sub {
        $self->process(@_);
    };
}

sub process {
    my ($self, $env) = @_;
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

1;
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
