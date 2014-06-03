# Pragmas.
use strict;
use warnings;

# Modules.
use File::Object;
use Graph::Reader::TGF;
use Test::More 'tests' => 8;
use Test::NoWarnings;

# Data dir.
my $data_dir = File::Object->new->up->dir('data')->set;

# Test.
my $obj = Graph::Reader::TGF->new;
my $ret = $obj->read_graph($data_dir->file('ex1.tgf')->s);
is($ret, '1-2', 'Get simple graph.');
is($ret->get_vertex_attribute('1', 'label'), 1,
	'Get vertex label attribute for first vertex.');
is($ret->get_vertex_attribute('2', 'label'), 2,
	'Get vertex label attribute for second vertex.');

# Test.
$ret = $obj->read_graph($data_dir->file('ex2.tgf')->s);
is($ret, '1-2', 'Get simple graph with labels.');
is($ret->get_vertex_attribute('1', 'label'), 'Node #1',
	'Get vertex label attribute for first named vertex.');
is($ret->get_vertex_attribute('2', 'label'), 'Node #2',
	'Get vertex label attribute for second named vertex.');
is($ret->get_edge_attribute('1', '2', 'label'), 'Edge',
	'Get edge label attribute.');
