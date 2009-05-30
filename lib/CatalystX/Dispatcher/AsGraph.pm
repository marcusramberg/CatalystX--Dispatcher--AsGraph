use MooseX::Declare;
use Graph::Easy;
use UNIVERSAL::require;

class CatalystX::Dispatcher::AsGraph {

    with 'MooseX::Getopt';

    has [qw/appname output/] => ( is => 'ro', isa => 'Str', required => 1 );
    has 'graph' => ( is => 'ro', default => sub { Graph::Easy->new } );

    method run{
        my $class  = $self->appname;
        $class->require or die $@;
        my $app    = $class->new;
        my $routes = $app->dispatcher->_tree;
        $self->_new_node($routes, '');
    }

    method _new_node($parent, $prefix) {
        my $name = $prefix . $parent->getNodeValue || '';
        my $node = $self->graph->add_node($name);

        for my $child ( $parent->getAllChildren ) {
            my $child_node = $self->_new_node( $child, $name . ' -> ' );
            $self->graph->add_edge( $node, $child_node );
        }
        my $actions = $parent->getNodeValue->actions;
        for my $action ( keys %{$actions} ) {
            next if ( ( $action =~ /^_.*/ ) );
            $self->graph->add_edge( $node, "[action] " . $action);
        }
        return $node;
    }
}


__END__

=head1 NAME

CatalystX::Dispatcher::AsGraph - Create a graph from Catalyst dispatcher

=head1 SYNOPSIS

    use CatalystX::Dispatcher::AsGraph;
    my $graph = CatalystX::Dispatcher::AsGraph->new_with_options();
    $graph->graph;

=head1 DESCRIPTION

CatalystX::Dispatcher::AsGraph create a graph for a Catalyst application
using his dispatcher.

=head1 AUTHOR

Franck Cuny E<lt>franck@lumberjaph.netE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
