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
	my $vert_hr = {};
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
			$graph->add_vertex($vertex_label);
			$vert_hr->{$id} = $vertex_label;

		# Edges.
		} else {
			my ($id1, $id2, $edge_label) = split m/\s+/ms, $line, 3;
			$graph->add_edge($vert_hr->{$id1}, $vert_hr->{$id2});
		}
		
	}
	return;
}

1;

__END__
