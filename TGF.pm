package Graph::Reader::TGF;

# Pragmas.
use base qw(Graph::Reader);
use strict;
use warnings;

# Modules.
use Encode qw(decode_utf8);

# Version.
our $VERSION = 0.02;

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
	$self->{'edge_callback'} = $param_hr->{'edge_callback'};
	$self->{'vertex_callback'} = $param_hr->{'vertex_callback'};
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
			if ($self->{'vertex_callback'}) {
				$self->{'vertex_callback'}->($self, $graph,
					$id, $vertex_label);
			} else {
				$self->_vertex_callback($graph, $id,
					$vertex_label);
			}

		# Edges.
		} else {
			my ($id1, $id2, $edge_label) = split m/\s+/ms, $line, 3;
			$graph->add_edge($id1, $id2);
			if ($self->{'edge_callback'}) {
				$self->{'edge_callback'}->($self, $graph, $id1,
					$id2, $edge_label);
			} else {
				$self->_edge_callback($graph, $id1, $id2,
					$edge_label);
			}
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

=pod

=encoding utf8

=head1 NAME

Graph::Reader::TGF - Perl class for reading a graph from TGF format.

=head1 SYNOPSIS

 use Graph::Reader::TGF;
 my $obj = Graph::Reader::TGF->new;
 my $graph = $obj->read_graph($tgf_file);

=head1 METHODS

=over 8

=item C<new()>

 Constructor.
 This doesn't take any arguments.
 Returns Graph::Reader::TGF object.

=item C<read_graph($tgf_file)>

 Read a graph from the specified file.
 The argument can either be a filename, or a filehandle for a previously opened file.
 Returns Graph object.

=back

=head1 TGF FILE FORMAT

 TGF = Trivial Graph Format
 TGF file format is described on L<https://en.wikipedia.org/wiki/Trivial_Graph_Format|English Wikipedia - Trivial Graph Format>
 Example:
 1 First node
 2 Second node
 #
 1 2 Edge between the two

=head1 EXAMPLE1

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Graph::Reader::TGF;
 use IO::Barf qw(barf);
 use File::Temp qw(tempfile);

 # Example data.
 my $data = <<'END';
 1 First node
 2 Second node
 #
 1 2 Edge between the two
 END

 # Temporary file.
 my (undef, $tempfile) = tempfile();

 # Save data to temp file.
 barf($tempfile, $data);

 # Reader object.
 my $obj = Graph::Reader::TGF->new;

 # Get graph from file.
 my $g = $obj->read_graph($tempfile);

 # Print to output.
 print $g."\n";

 # Clean temporary file.
 unlink $tempfile;

 # Output:
 # 1-2

=head1 EXAMPLE2

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Graph::Reader::TGF;
 use IO::Barf qw(barf);
 use File::Temp qw(tempfile);

 # Example data.
 my $data = <<'END';
 1 Node #1
 2 Node #2
 3 Node #3
 4 Node #4
 5 Node #5
 6 Node #6
 7 Node #7
 8 Node #8
 9 Node #9
 10 Node #10
 #
 1 2
 1 3
 1 5
 1 6
 1 10
 3 4
 6 7
 6 8
 6 9
 END

 # Temporary file.
 my (undef, $tempfile) = tempfile();

 # Save data to temp file.
 barf($tempfile, $data);

 # Reader object.
 my $obj = Graph::Reader::TGF->new;

 # Get graph from file.
 my $g = $obj->read_graph($tempfile);

 # Print to output.
 print $g."\n";

 # Clean temporary file.
 unlink $tempfile;

 # Output:
 # 1-10,1-2,1-3,1-5,1-6,3-4,6-7,6-8,6-9

=head1 DEPENDENCIES

L<Encode>,
L<Graph::Reader>.

=head1 SEE ALSO

L<Graph::Reader>,
L<Graph::Reader::Dot>,
L<Graph::Reader::HTK>,
L<Graph::Reader::LoadClassHierarchy>,
L<Graph::Reader::UnicodeTree>,
L<Graph::Reader::XML>.

=head1 REPOSITORY

L<https://github.com/tupinek/Graph-Reader-TGF>

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.02

=cut
