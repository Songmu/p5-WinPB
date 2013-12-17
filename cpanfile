requires 'Plack';
requires 'Router::Simple';
requires 'Win32::Clipboard';

on build => sub {
    requires 'ExtUtils::MakeMaker', '6.36';
};
