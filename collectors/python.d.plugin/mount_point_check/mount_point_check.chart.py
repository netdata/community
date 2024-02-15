# -*- coding: utf-8 -*-
# Description: mount point check netdata python.d module

import os

from bases.FrameworkServices.ExecutableService import ExecutableService

MOUNTPOINT_COMMAND = 'mountpoint /'

ORDER = []

CHARTS = {}


class Service(ExecutableService):
    def __init__(self, configuration=None, name=None):
        ExecutableService.__init__(self, configuration=configuration, name=name)
        self.configuration = configuration
        self._create_order_and_charts()
        self.order = ORDER
        self.definitions = CHARTS
        self.command = MOUNTPOINT_COMMAND

    def _create_order_and_charts(self):
        for job in self.configuration.get("jobs"):
            if job.get("name") in CHARTS:
                continue
            ORDER.append(job.get("name"))
            CHARTS[job.get("name")] = {
                "options": [None, "Mount Point Check Status", "boolean", "status", "mountpointcheck.status", "line"],
                "lines": [[f"{job.get('name')}.available", "available"]]}

    def _get_data(self):
        data = dict()
        try:
            for job in self.configuration.get("jobs"):
                self.command[1] = job.get("path")
                if os.path.exists(job.get("path")) and (
                        self._get_raw_data()[0] == f"{job.get('path')} is a mountpoint\n"):
                    data[f"{job.get('name')}.available"] = 1
                else:
                    data[f"{job.get('name')}.available"] = 0
            return data
        except (ValueError, AttributeError):
            return None
