#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew ansible
try pinstall brew dnsmasq

dnsmasqconf_source="$DOT/ansible/dnsmasq.conf"
dnsmasqconf_target="/usr/local/etc/dnsmasq.conf"
if [[ ! $(checklink "${dnsmasqconf_target}" "${dnsmasqconf_source}") ]]; then
  pprint info-go "Installing dnsmasq configuration"
  mksymlink "${dnsmasqconf_source}" "${dnsmasqconf_target}"
fi

exit $TRY_CODE
