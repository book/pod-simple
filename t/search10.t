use strict;
use warnings;

#sub Pod::Simple::Search::DEBUG () {5};

use Pod::Simple::Search;
use Test;
BEGIN { plan tests => 11 }

print "# ", __FILE__,
 ": Testing the surveying of a single specified docroot...\n";

my $x = Pod::Simple::Search->new;
die "Couldn't make an object!?" unless ok defined $x;

print "# Testing the surveying of a single docroot...\n";

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
ok $names, "Blorm|Zonk::Pronk|hinkhonk::Glunk|hinkhonk::Vliff|perlflif|perlthng|squaa|squaa::Glunk|squaa::Vliff|zikzik";
}

{
my $names = join "|", sort ascii_order keys %$name2where;
ok $names, "Blorm|Zonk::Pronk|hinkhonk::Glunk|hinkhonk::Vliff|perlflif|perlthng|squaa|squaa::Glunk|squaa::Vliff|zikzik";
}

ok( ($name2where->{'squaa'} || 'huh???'), '/squaa\.pm$/');

ok grep( m/squaa\.pm/, keys %$where2name ), 1;

###### Now with recurse(0)

print "# Testing the surveying of a single docroot without recursing...\n";

$x->recurse(0);
($name2where, $where2name) = $x->survey($here);

$p = pretty( $where2name, $name2where )."\n";
$p =~ s/, +/,\n/g;
$p =~ s/^/#  /mg;
print $p;

{
my $names = join "|", sort ascii_order values %$where2name;
ok $names, "Blorm|squaa|zikzik";
}

{
my $names = join "|", sort ascii_order keys %$name2where;
ok $names, "Blorm|squaa|zikzik";
}

ok( ($name2where->{'squaa'} || 'huh???'), '/squaa\.pm$/');

ok grep( m/squaa\.pm/, keys %$where2name ), 1;

ok 1;

__END__

