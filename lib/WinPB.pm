package WinPB;
use strict;
use warnings;
use utf8;
our $VERSION = '0.01';

use Encode qw/encode_utf8 decode/;
use Plack::Request;
use Win32::Clipboard;

my $cp932   = Encode::find_encoding('cp932');
my $utf8    = Encode::find_encoding('utf-8');
my $utf16le = Encode::find_encoding('UTF16-LE');

sub to_app {
    my $class = shift;
    return sub {
        my $env = shift;
        my $req = Plack::Request->new($env);
        if ($req->method eq 'POST' and my $text = $req->param('pb')) {
            Encode::from_to($text, $utf8, $cp932);
            Win32::Clipboard::Set($text);
            return [200, [], ['OK']];
        }
        elsif ($req->method eq 'GET') {
            my $text = decode $utf16le, Win32::Clipboard::GetAs(CF_UNICODETEXT);
               $text = encode_utf8 $text;
            return [200, ['Content-Type' => 'text/plain;charset="UTF-8"'], [$text]];
        }
        return [400, [], ['BAD REQUEST']];
    };
}

1;
__END__

=head1 NAME

WinPB - clipboard sharing web api interface at windows

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
