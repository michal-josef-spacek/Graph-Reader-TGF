# Pragmas.
use strict;
use warnings;

# Modules.
use Encode qw(decode_utf8);
use File::Object;
use Graph::Reader::TGF;
use Test::More 'tests' => 12;
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

# Test.
$ret = $obj->read_graph($data_dir->file('ex3.tgf')->s);
is($ret, '1-2', 'Get simple graph with utf8 labels.');
is($ret->get_vertex_attribute('1', 'label'), decode_utf8('עִבְרִית'),
	'Get vertex label attribute for first utf8 encoded vertex.');
is($ret->get_vertex_attribute('2', 'label'), decode_utf8('ěščřžýáíí'),
	'Get vertex label attribute for second utf8 encoded vertex.');
is($ret->get_edge_attribute('1', '2', 'label'), decode_utf8('中國'),
	'Get edge utf8 label attribute.');
