use strict;
use warnings;
use utf8;
use lib '../lib';

use Plack::Builder;
use Plack::Middleware::Auth::QueryString;

use WinPB;

my $conf = do 'config.pl' || {};
my $passwd = $conf->{password} || 'change_on_install';
my $app = WinPB->new->to_app;

builder {
    enable 'Auth::QueryString', password => $passwd;
    $app;
};
