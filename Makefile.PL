use inc::Module::Install;
name 'WinPB';
all_from 'lib/WinPB.pm';

requires 'Router::Simple';
requires 'Plack';
requires 'Win32::Clipboard';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
