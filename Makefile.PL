use inc::Module::Install;
name 'WinPB';
all_from 'lib/WinPB.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
