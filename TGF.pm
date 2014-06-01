package Graph::Reader::TGF;

# Pragmas.
use base qw(Graph::Reader);
use strict;
use warnings;

# Modules.
use Encode qw(decode_utf8);

# Version.
our $VERSION = 0.01;

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
			$graph->add_vertex($id);
			$graph->set_vertex_attribute($id, 'label', $vertex_label);

		# Edges.
		} else {
			my ($id1, $id2, $edge_label) = split m/\s+/ms, $line, 3;
			$graph->add_edge($id1, $id2);
			$graph->set_edge_attribute($id1, $id2, 'label',
				$edge_label);
		}
		
	}
	return;
}

1;

__END__
