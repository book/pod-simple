use strict;
use warnings;
use Test::More tests => 11;

use Pod::Simple::Search;

print "# ", __FILE__,
 ": Testing the surveying of the current directory...\n";

my $x = Pod::Simple::Search->new;
die "Couldn't make an object!?" unless ok defined $x;

$x->inc(0);

use File::Spec;
use Cwd ();
use File::Basename ();

my $t_dir = File::Basename::dirname(Cwd::abs_path(__FILE__));

my $here = File::Spec->catdir($t_dir, 'testlib1');

print "# OK, found the test corpus as $here\n";
ok 1;

print $x->_state_as_string;
#$x->verbose(12);

use Pod::Simple;
*pretty = \&Pod::Simple::BlackBox::pretty;

my($name2where, $where2name) = $x->survey($here);

my $p = pretty( $where2name, $name2where )."\n";
$p =~ s/, +/,\n/g;
$p =~ s/^/#  /mg;
print $p;

require File::Spec->catfile($t_dir, 'ascii_order.pl');

{
my $names = join "|", sort ascii_order values %$where2name;
is $names, "Blorm|Zonk::Pronk|hinkhonk::Glunk|hinkhonk::Vliff|perlflif|perlthng|squaa|squaa::Glunk|squaa::Vliff|zikzik";
}

{
my $names = join "|", sort ascii_order keys %$name2where;
is $names, "Blorm|Zonk::Pronk|hinkhonk::Glunk|hinkhonk::Vliff|perlflif|perlthng|squaa|squaa::Glunk|squaa::Vliff|zikzik";
}

like( ($name2where->{'squaa'} || 'huh???'), qr/squaa\.pm$/);

is grep( m/squaa\.pm/, keys %$where2name ), 1;

###### Now with recurse(0)

print "# Testing the surveying of a subdirectory with recursing off...\n";

$x->recurse(0);
($name2where, $where2name) = $x->survey(
                             File::Spec->catdir($t_dir, 'testlib2'));

$p = pretty( $where2name, $name2where )."\n";
$p =~ s/, +/,\n/g;
$p =~ s/^/#  /mg;
print $p;

{
my $names = lc join "|", sort ascii_order values %$where2name;
is $names, "suzzle";
}

{
my $names = lc join "|", sort ascii_order keys %$name2where;
is $names, "suzzle";
}

is( ($name2where->{'Vliff'} || 'huh???'), 'huh???');

is grep( m/Vliff\.pm/, keys %$where2name ), 0;

ok 1;

__END__


