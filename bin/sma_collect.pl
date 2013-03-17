#!/usr/bin/perl -i
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

my $slogger = "slogger";


my $lines = `$slogger`;

my $file_line = <>;
if ($lines =~ m/Current Value of 'E-Total' is '(.*)'/) {
    if ($1 > 0) {
        print "$1\n";
    } else {
        print $file_line;
    }
}
if ($lines =~ m/Current Value of 'Pac' is '(.*)'/) {
    print "$1\n";
}
