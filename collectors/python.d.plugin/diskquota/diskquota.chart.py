# -*- coding: utf-8 -*-
# Description: disk quota netdata python.d module
# Author: je2555
# SPDX-License-Identifier: GPL-3.0-or-later

import csv
from bases.FrameworkServices.ExecutableService import ExecutableService

# You must give the netdata user root permission for the configured command
# for this plugin to work.
# It is also recommended that you disable logging of allowed sudo privilege
# escalations for the netdata user to avoid excessive repeated log entries.
# The following is an example sudoers configuration.
#
# netdata    ALL=(root)    NOPASSWD: /sbin/repquota --output=csv /
# Defaults:netdata !log_allowed

COMMAND = 'sudo repquota --output=csv /'

# Dynamically generate a series of charts per user similar to these

ORDER = [
#    'blocks',
#    'files',
]

CHARTS = {
#    'blocks': {
#        'options': [None, 'Disk Block Quota', 'KB', 'blocks', 'diskquota.blocks', 'area'],
#        'lines': [
#            ['blocks_used', None, 'absolute'],
#            ['blocks_softlimit', None, 'absolute'],
#            ['blocks_hardlimit', None, 'absolute'],
#        ]
#    },
#    'files': {
#        'options': [None, 'Disk File Quota', 'files', 'files', 'diskquota.files', 'area'],
#        'lines': [
#            ['files_used', None, 'absolute'],
#            ['files_softlimit', None, 'absolute'],
#            ['files_hardlimit', None, 'absolute'],
#        ]
#    },
}

def quota_chart_template(user):
    """
    Build chart config for a user
    :return: tuple
    """
    order = [
        user + '_blocks',
        user + '_files',
    ]

    charts = {
        order[0]: {
            'options': [None, 'Disk Block Quota', 'KB', 'blocks', 'diskquota.blocks', 'area'],
            'lines': [
                [user + '_blocks_used', None, 'absolute'],
                [user + '_blocks_softlimit', None, 'absolute'],
                [user + '_blocks_hardlimit', None, 'absolute'],
            ]
        },
        order[1]: {
            'options': [None, 'Disk File Quota', 'files', 'files', 'diskquota.files', 'area'],
            'lines': [
                [user + '_files_used', None, 'absolute'],
                [user + '_files_softlimit', None, 'absolute'],
                [user + '_files_hardlimit', None, 'absolute'],
            ]
        },
    }

    return order, charts


class Service(ExecutableService):
    def __init__(self, configuration=None, name=None):
        ExecutableService.__init__(self, configuration=configuration, name=name)
        self.order = ORDER
        self.definitions = CHARTS
        self.command = self.configuration.get('command', COMMAND)

    def _get_data(self):
        """
        Format data received from shell command
        :return: dict
        """
        raw = self._get_raw_data()
        data = csv.DictReader(raw)

        active_charts = self.charts.active_charts()

        result = {}
        for row in data:
            user = row['User']

            # Create charts that don't exist yet
            if user + '_blocks' not in active_charts:
                order, charts = quota_chart_template(user)

                for chart_name in order:
                    params = [chart_name] + charts[chart_name]['options']
                    dimensions = charts[chart_name]['lines']

                    new_chart = self.charts.add_chart(params)
                    for dimension in dimensions:
                        new_chart.add_dimension(dimension)

            # Prepare and submit the gathered data
            result.update({
                user + '_blocks_used': int(row['BlockUsed']),
                user + '_blocks_softlimit': int(row['BlockSoftLimit']),
                user + '_blocks_hardlimit': int(row['BlockHardLimit']),
                user + '_files_used': int(row['FileUsed']),
                user + '_files_softlimit': int(row['FileSoftLimit']),
                user + '_files_hardlimit': int(row['FileHardLimit']),
            })
        return result
