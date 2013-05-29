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

use Fcntl qw( :flock );
use Scalar::Util qw(looks_like_number);

my $slogger = "slogger";
my $lines = `$slogger`;


my $tot;
my $pow;


if ($lines =~ m/Current Value of 'E-Total' is '(.*)'/) {
    $tot = $pow;
}
if ($lines =~ m/Current Value of 'Pac' is '(.*)'/) {
    $pow = $1;
}

open(FH, "+< $ARGV[0]")                 or die "Opening: $!";
flock(FH, LOCK_EX)                      or die "Locking: $!";
my @ARRAY = <FH>;

if (looks_like_number($tot) and $tot > $ARRAY[0]) {
    $ARRAY[0] = $tot;
}
if (looks_like_number($pow)) {
    $ARRAY[1] = $pow;
}
# change ARRAY here
seek(FH,0,0)                        or die "Seeking: $!";
print FH @ARRAY                     or die "Printing: $!";
truncate(FH,tell(FH))               or die "Truncating: $!";
close(FH)                           or die "Closing: $!";
