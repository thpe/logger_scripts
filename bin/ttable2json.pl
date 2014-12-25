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
use JSON;

my ($second, $minute, $hour, $dayOfMonth, $month, $act_year, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
$act_year += 1900;

my %data = ();

my $csv = Text::CSV->new();
my $line = <>;
$csv->parse($line);
my @columns = $csv->fields();
my $net = $columns[0];
my $sub = $columns[1];
my $year = $columns[2];
my $last_prod = 0;
my $last = 0;

my @array = (0,1,2);
while (<>) {
    if ($csv->parse($_)) {
        my @columns = $csv->fields();
        my $max_month = 12;
        if ($year == $act_year) {
            $max_month = @columns;
        }
        my $tot_prod = 0;
        if (looks_like_number($columns[-1])) {
            $tot_prod = $columns[-1] - $last_prod;
            $last_prod = $columns[-1];
        }
        #$data{ $year } = { 'prod' => $tot_prod, };
        $data{ $year } = { 'label' => $year };

        for (my $i = 0; $i < $max_month; ++$i) {
            my $val = $columns[$i];
            if (!looks_like_number($val)) {
                $val = 0;
            } else {
                $val -= $last;
                $last = $columns[$i];
            }
            $data{ $year }{ data }[$i][0] = $i+1;
            $data{ $year }{ data }[$i][1] = $val;
        }
        ++$year;
    } else {
        my $err = $csv->error_input;
        print "Failed to parse line: $err";
    }
}
my $string = encode_json \%data;
print $string."\n";
