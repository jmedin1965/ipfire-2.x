#!/bin/bash
############################################################################
#                                                                          #
# This file is part of the IPFire Firewall.                                #
#                                                                          #
# IPFire is free software; you can redistribute it and/or modify           #
# it under the terms of the GNU General Public License as published by     #
# the Free Software Foundation; either version 3 of the License, or        #
# (at your option) any later version.                                      #
#                                                                          #
# IPFire is distributed in the hope that it will be useful,                #
# but WITHOUT ANY WARRANTY; without even the implied warranty of           #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            #
# GNU General Public License for more details.                             #
#                                                                          #
# You should have received a copy of the GNU General Public License        #
# along with IPFire; if not, write to the Free Software                    #
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA #
#                                                                          #
# Copyright (C) 2009 IPFire-Team <info@ipfire.org>.                        #
#                                                                          #
############################################################################
#
. /opt/pakfire/lib/functions.sh
/usr/local/bin/backupctrl exclude >/dev/null 2>&1
#
#Stop services
#
#Set vm.mmap_min_addr to block a kernel security hole
grep -v "vm.mmap_min_addr" /etc/sysctl.conf > /var/tmp/sysctl.conf.tmp
echo "vm.mmap_min_addr = 4096" >> /var/tmp/sysctl.conf.tmp
mv /var/tmp/sysctl.conf.tmp /etc/sysctl.conf
sysctl -w vm.mmap_min_addr="4096"
#
extract_files
#
#Start services
#
#Update Language cache
perl -e "require '/var/ipfire/lang.pl'; &Lang::BuildCacheLang"
#Rebuild module dep's
depmod 2.6.27.31-ipfire
depmod 2.6.27.31-ipfire-xen
#Don't report the exitcode of depmod
exit 0
