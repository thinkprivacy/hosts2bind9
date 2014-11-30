#!/bin/sh
# This script will do the following 5 things:
# 1. Download Steven Black.s aggregated hosts file
# 2. Strip the leading localhost line
# 3. Convert the hosts file into bind9 format so it can be used with pixelserv/
#    apache
# 4. Check the file has no duplicate lines before saving
# 5. Restart the bind9 service
#
# This script is written by Alexander Hanff @ Think Privacy Inc. and is free to
# use, modify & distribute so long as the original author is attributed as
# Alexander Hanff @ Think Privacy Inc.
#
# If you use this script you accept that it is supplied without warranty and
# neither Alexander Hanff or Think Privacy Inc. accept any liability
# whatsoever.
#
# If you would like further information or want to suggest improvements please
# contact the author at:
#  a.hanff@think-privacy.com
#
# If you want to buy the author a beer, donations can be sent via Paypal to:
#  a.hanff@paladine.org.uk

# Download the hosts file:
wget -O /tmp/hosts.raw  https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts

# Strip the localhost line:
sed -i '/localhost$/d' /tmp/hosts.raw

# Convert the hosts file into bind9 format and output to /etc/bind/adblock
awk '/^0.0.0.0/{print "zone \42"$2"\42 { type master; notify no; file \"/etc/bind/null.zone.file\"; };"}' /tmp/hosts.raw > /tmp/ad-blacklist.raw

# Check there are no duplicate lines as this will cause bind9 to fail on
# then save the final output to /etc/bind/
sort /tmp/ad-blacklist.raw | uniq > /etc/bind/ad-blacklist

#restart bind9 service (this might be different on none Debian systems)
service bind9 restart
