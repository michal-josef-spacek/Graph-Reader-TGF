package Graph::Reader::TGF;

# Pragmas.
use base qw(Graph::Reader);
use strict;
use warnings;

# Modules.
use Encode qw(decode_utf8);

# Version.
our $VERSION = 0.01;

# Edge callback.
sub _edge_callback {
	my ($self, $graph, $id1, $id2, $edge_label) = @_;
	$graph->set_edge_attribute($id1, $id2, 'label', $edge_label);
	return;
}

# Init.
sub _init {
	my ($self, $param_hr) = @_;
	$self->SUPER::_init();
	$self->{'edge_callback'} = $param_hr->{'edge_callback'} || \&_edge_callback;
	$self->{'vertex_callback'} = $param_hr->{'vertex_callback'} || \&_vertex_callback;
	return;
}

# Read graph subroutine.
sub _read_graph {
	my ($self, $graph, $fh) = @_;
	my $vertexes = 1;
	while (my $line = decode_utf8(<$fh>)) {
		chomp $line;

		# End of vertexes section.
		if ($line =~ m/^#/ms) {
			$vertexes = 0;
			next;
		}

		# Vertexes.
		if ($vertexes) {
			my ($id, $vertex_label) = split m/\s+/ms, $line, 2;
			if (! defined $vertex_label) {
				$vertex_label = $id;
			}
			$graph->add_vertex($id);
			$self->{'vertex_callback'}->($self, $graph,
				$id, $vertex_label);

		# Edges.
		} else {
			my ($id1, $id2, $edge_label) = split m/\s+/ms, $line, 3;
			$graph->add_edge($id1, $id2);
			$self->{'edge_callback'}->($self, $graph, $id1, $id2, $edge_label);
		}
		
	}
	return;
}

# Vertex callback.
sub _vertex_callback {
	my ($self, $graph, $id, $vertex_label) = @_;
	$graph->set_vertex_attribute($id, 'label', $vertex_label);
	return;
}

1;

__END__
