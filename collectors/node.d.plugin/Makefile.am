# SPDX-License-Identifier: GPL-3.0-or-later

MAINTAINERCLEANFILES = $(srcdir)/Makefile.in
CLEANFILES = \
    node.d.plugin \
    $(NULL)

include $(top_srcdir)/build/subst.inc
SUFFIXES = .in

dist_libconfig_DATA = \
    node.d.conf \
    $(NULL)

dist_plugins_SCRIPTS = \
    node.d.plugin \
    $(NULL)

dist_noinst_DATA = \
    node.d.plugin.in \
    README.md \
    $(NULL)

usernodeconfigdir=$(configdir)/node.d
dist_usernodeconfig_DATA = \
    $(NULL)

# Explicitly install directories to avoid permission issues due to umask
install-exec-local:
	$(INSTALL) -d $(DESTDIR)$(usernodeconfigdir)

nodeconfigdir=$(libconfigdir)/node.d
dist_nodeconfig_DATA = \
    $(NULL)

dist_node_DATA = \
    $(NULL)

include snmp/Makefile.inc

nodemodulesdir=$(nodedir)/node_modules
dist_nodemodules_DATA = \
    node_modules/netdata.js \
    node_modules/extend.js \
    node_modules/pixl-xml.js \
    node_modules/net-snmp.js \
    node_modules/asn1-ber.js \
    $(NULL)

nodemoduleslibberdir=$(nodedir)/node_modules/lib/ber
dist_nodemoduleslibber_DATA = \
    node_modules/lib/ber/index.js \
    node_modules/lib/ber/errors.js \
    node_modules/lib/ber/reader.js \
    node_modules/lib/ber/types.js \
    node_modules/lib/ber/writer.js \
    $(NULL)
