use inc::Module::Install;
name 'CatalystX-Dispatcher-AsGraph';
all_from 'lib/CatalystX/Dispatcher/AsGraph.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
