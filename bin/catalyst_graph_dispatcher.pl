#!/usr/bin/perl -w
use strict;
use lib('/home/franck/code/git/CatalystX-Dispatcher-AsGraph/lib');
use CatalystX::Dispatcher::AsGraph;

my $graph = CatalystX::Dispatcher::AsGraph->new_with_options();
$graph->run;
if ( open( my $png, '|-', 'dot -Tpng -o ' . $graph->output ) ) {
    print $png $graph->graph->as_graphviz;
    close($png);
}
