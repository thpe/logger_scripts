#!/usr/bin/perl
# Copyright 2012 Thomas Petig
#
# This file is part of rklogger.
#
# rklogger is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# rklogger is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with rklogger.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;
use Text::CSV;
use FindBin;
use Scalar::Util qw(looks_like_number);


if (@ARGV != 1) {
    print "usage: $0 <database.csv>\n";
    exit;
}

my $rklogger = "$FindBin::Bin/../src/bin/rklogger";

my $csv = Text::CSV->new();

my ($second, $minute, $hour, $dayOfMonth, $month, $year, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
$year += 1900;

my $filename = $ARGV[0];

open FILE, ">$filename.new" or die $!;
my $line = <>;
$csv->parse($line);
my @columns = $csv->fields();

my $net = $columns[0];
my $sub = $columns[1];
my $start_year = $columns[2];
my $res;
if (looks_like_number($net)) {
    $res =`$rklogger $net $sub 1 2 8`;
} else {
    open DATAFILE, $net;
    $res = <DATAFILE>;
    print "reading dat file: $res\n";
    close DATAFILE;
}

while (<>) {
    print FILE $line;
    $line = $_;
    ++$start_year;
}
for (; $start_year <= $year; ++$start_year) {
    print FILE $line;
    $line = "\n";
}
print "parsing $line\n";
$csv->parse($line);
@columns = $csv->fields();
print "@columns\n";

if (looks_like_number($res)) {
    print "looks $month\n";
    if (looks_like_number($columns[$month])) {
        if ($res > $columns[$month]) {
            $columns[$month] = $res;
        }
    } else {
        $columns[$month] = $res;
    }
}
$columns[0] = 4;
my $cret = $csv->combine(@columns);
print "@columns, comb: $cret\n";
if (not defined $csv->string()) {
    print "undef: $csv->error_input()\n";
}
print FILE $csv->string();
print $csv->string();

close FILE;
system "rm $filename";
system "mv $filename.new $filename";
