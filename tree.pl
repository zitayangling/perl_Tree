#!/usr/bin/perl
use Tree;
use strict;

my $tree = Tree->new;
while (<STDIN>) {
    chomp($_);
    $tree->add_node($_);
}
$tree->print_tree;
print "\n";

print "delete data:\n";
chomp(my $data = <STDIN>);
$tree->delete($data);

$tree->print_tree;
print "\n";



