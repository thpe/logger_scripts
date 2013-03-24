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


my @hardware_type_ids = ( 
    "", 
    "AC module, 1600W",
    "AC module, 3200W",
    "AC module, 4800W",
    "DC module, Medium Voltage",
    "DC module, High Voltage",
    "10kW inverter",
    "12,5kW inverter",
    "15kW inverter",
);

my @tlx_op_modes = ( 
    "Shutdown",
    "Connecting: booting",
    "Connecting: monitoring grid",
    "On Grid",
    "Fail safe",
    "Off Grid",
    "Unkown"
);

sub tlx_op_mode_id {
    my $val = $_[0];
    if ($val < 10) {
        return 0;
    } elsif ($val < 50) {
        return 1;
    } elsif ($val < 60) {
        return 2;
    } elsif ($val < 70) {
        return 3;
    } elsif ($val < 80) {
        return 4;
    } elsif ($val < 90) {
        return 5;
    }   
    return 6;
}



my $val = 0;

my ($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
$yearOffset += 1900;

my $tot   = <>;
my $power = <>;
my $ytot  = <>;
my $mode  = 0;
if ($power >= 0) {
    $mode = 60;
}
my $etoday = $tot - $ytot;

printf "<TR><TH align=\"right\"> %d/%02d/%02d %d:%02d</TH>", $yearOffset, $month, $dayOfMonth, $hour, $minute;
print "<TH align=\"right\"> 8kW inverter</TH>";
printf("<TH align=\"right\"> %dW</TH>", $power);
printf("<TH align=\"right\"> %.1fkWh</TH>", $etoday);
printf("<TH align=\"right\"> %.1fkWh</TH>", $tot);
$val = $mode;
my $r = ((tlx_op_mode_id($val) == 4) or (tlx_op_mode_id($val) == 1) or (tlx_op_mode_id($val) == 2)) ? 255 : 0;
my $g = ((tlx_op_mode_id($val) == 3) or (tlx_op_mode_id($val) == 1) or (tlx_op_mode_id($val) == 2)) ? 255 : 0;
my $b = (tlx_op_mode_id($val) == 0) ? 255 : 0;
printf "<TH bgcolor=\"#%.2X%.2X%.2X\">%s</TH></TR>\n", $r,$g,$b, $tlx_op_modes[tlx_op_mode_id($val)];
