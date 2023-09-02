import shlex
import subprocess
from pprint import pprint
import json
from typing import Optional, List, Tuple, Callable
from collections.abc import Iterable

try:
    from bases.FrameworkServices.SimpleService import SimpleService

    _in_netdata = True
except Exception:
    _in_netdata = False

    class SimpleService:
        def __init__(self, *args, **kwargs) -> None:
            pass

        def error(self, msg: str):
            print(f"ERROR: {msg}")


update_every = 1


class TinChangeException(Exception):
    pass


class Command:
    def __init__(self, exe: str, intf: str):
        self._cmd = shlex.split(_stats_command.format(exe=exe, interface=intf))
        self._intf_name = intf
        self._intf_id = intf.replace("-", "_")
        self._num_tins = 0

    @property
    def cmd(self) -> str:
        return self._cmd

    @property
    def intf_name(self) -> str:
        return self._intf_name

    @property
    def intf_id(self) -> str:
        return self._intf_id

    @property
    def num_tins(self) -> str:
        return self._num_tins

    def update_num_tins(self):
        self._num_tins = len(get_data(self._cmd).get("tins") or [])


class Tin:
    def __init__(self, tin: str):
        self._name = tin.replace("_", " ").title()
        self._id = tin

    @property
    def name(self) -> str:
        return self._name

    @property
    def ident(self) -> str:
        return self._id


_stats_command = "{exe} -s -j qdisc show dev {interface}"


_tins = {
    1: [Tin(name) for name in ("best_effort",)],
    3: [Tin(name) for name in ("bulk", "best_effort", "voice")],
    4: [Tin(name) for name in ("bulk", "best_effort", "video", "voice")],
    8: [Tin(f"t{ii}") for ii in range(8)],
}


def get_tins(num_tins: int) -> List[Tin]:
    tins = _tins.get(num_tins)
    if not tins:
        tins = [Tin(f"t{ii}") for ii in range(num_tins)]
    return tins


def convert(cmd: Command, data: dict) -> Tuple[int, dict]:
    ret = {}
    for key in (
        "backlog",
        "bytes",
        "packets",
        "drops",
        "qlen",
        "requeues",
        "overlimits",
        "memory_used",
    ):
        ret[f"{cmd.intf_id}_{key}"] = data[key]
    ret.update(convert_tins(cmd, data))
    return ret


def convert_tins(cmd: Command, data: dict) -> dict:
    ret = {}
    tins_data = data.get("tins")
    if not tins_data:
        return ret
    if len(tins_data) != cmd.num_tins:
        raise TinChangeException()
    tins = _tins.get(len(tins_data))
    for ii, tin_data in enumerate(tins_data):
        tin = tins[ii]
        for key in (
            "sent_bytes",
            "backlog_bytes",
            "avg_delay_us",
            "base_delay_us",
            "peak_delay_us",
            "sent_packets",
            "ecn_mark",
            "ack_drops",
            "drops",
            "bulk_flows",
            "sparse_flows",
            "unresponsive_flows",
            "way_collisions",
            "way_indirect_hits",
            "way_misses",
        ):
            ret[f"{cmd.intf_id}_{tin.ident}_{key}"] = tin_data[key]
    return ret


def get_data(cmd: List[str]) -> dict:
    proc = subprocess.run(cmd, capture_output=True, text=True, timeout=1, check=True)
    for data in json.loads(proc.stdout):
        if data["kind"] == "cake":
            return data
    return {}


def get_stats(cmd: Command) -> dict:
    return convert(cmd, get_data(cmd.cmd))


def generate_bw_chart(cmd: Command) -> Tuple[str, dict]:
    return f"{cmd.intf_id}_bandwidth", {
        "options": [
            None,
            "Bandwidth",
            "bits/s",
            "overall",
            "CAKE.bandwidth",
            "line",
        ],
        "lines": [
            [f"{cmd.intf_id}_bytes", "bytes", "incremental", 8, 1],
            [f"{cmd.intf_id}_backlog", "backlog", "incremental", 8, 1],
        ],
    }


def generate_packets_chart(cmd: Command) -> Tuple[str, dict]:
    return f"{cmd.intf_id}_packets", {
        "options": [
            None,
            "Packets",
            "packets/s",
            "overall",
            "CAKE.packets",
            "line",
        ],
        "lines": [
            [f"{cmd.intf_id}_packets", "total", "incremental", 1, 1],
            [f"{cmd.intf_id}_drops", "drops", "incremental", 1, 1],
            [f"{cmd.intf_id}_qlen", "qlen", "incremental", 1, 1],
            [f"{cmd.intf_id}_requeues", "requeues", "incremental", 1, 1],
            [f"{cmd.intf_id}_overlimits", "overlimits", "incremental", 1, 1],
        ],
    }


def generate_memory_chart(cmd: Command) -> Tuple[str, dict]:
    return f"{cmd.intf_id}_memory", {
        "options": [
            None,
            "Memory",
            "bytes",
            "overall",
            "CAKE.memory",
            "line",
        ],
        "lines": [
            [f"{cmd.intf_id}_memory_used", "used", "abolute", 1, 1],
        ],
    }


def generate_tin_bw_chart(tin: Tin, cmd: Command) -> Tuple[str, dict]:
    key = f"{cmd.intf_id}_{tin.ident}_bandwidth"

    chart = {
        "options": [
            None,
            f"{tin.name} Bandwidth",
            "bits/s",
            f"{tin.ident}",
            f"CAKE.{tin.ident}_bandwidth",
            "line",
        ],
        "lines": [
            [f"{cmd.intf_id}_{tin.ident}_sent_bytes", "bytes", "incremental", 8, 1],
            [
                f"{cmd.intf_id}_{tin.ident}_backlog_bytes",
                "backlog",
                "incremental",
                8,
                1,
            ],
        ],
    }

    return key, chart


def generate_tin_delay_chart(tin: Tin, cmd: Command) -> Tuple[str, dict]:
    key = f"{cmd.intf_id}_{tin.ident}_delay"

    chart = {
        "options": [
            None,
            f"{tin.name} Delay",
            "seconds",
            f"{tin.ident}",
            f"CAKE.{tin.ident}_delay",
            "line",
        ],
        "lines": [
            [
                f"{cmd.intf_id}_{tin.ident}_base_delay_us",
                "base",
                "absolute",
                1,
                1000000,
            ],
            [
                f"{cmd.intf_id}_{tin.ident}_avg_delay_us",
                "average",
                "absolute",
                1,
                1000000,
            ],
            [
                f"{cmd.intf_id}_{tin.ident}_peak_delay_us",
                "peak",
                "absolute",
                1,
                1000000,
            ],
        ],
    }

    return key, chart


def generate_tin_flows_chart(tin: Tin, cmd: Command) -> Tuple[str, dict]:
    key = f"{cmd.intf_id}_{tin.ident}_flows"

    chart = {
        "options": [
            None,
            f"{tin.name} Flows",
            "flows",
            f"{tin.ident}",
            f"CAKE.{tin.ident}_flows",
            "line",
        ],
        "lines": [
            [f"{cmd.intf_id}_{tin.ident}_bulk_flows", "bulk", "absolute", 1, 1],
            [f"{cmd.intf_id}_{tin.ident}_sparse_flows", "sparse", "absolute", 1, 1],
            [
                f"{cmd.intf_id}_{tin.ident}_unresponsive_flows",
                "unresponsive",
                "absolute",
                1,
                1,
            ],
        ],
    }

    return key, chart


def generate_tin_packets_chart(tin: Tin, cmd: Command) -> Tuple[str, dict]:
    key = f"{cmd.intf_id}_{tin.ident}_packets"

    chart = {
        "options": [
            None,
            f"{tin.name} Packets",
            "packets/s",
            f"{tin.ident}",
            f"CAKE.{tin.ident}_packets",
            "line",
        ],
        "lines": [
            [f"{cmd.intf_id}_{tin.ident}_sent_packets", f"sent", "incremental", 1, 1],
            [f"{cmd.intf_id}_{tin.ident}_ecn_mark", f"ecn_mark", "incremental", 1, 1],
            [f"{cmd.intf_id}_{tin.ident}_ack_drops", f"ack_drops", "incremental", 1, 1],
            [f"{cmd.intf_id}_{tin.ident}_drops", f"drops", "incremental", 1, 1],
        ],
    }

    return key, chart


def generate_tin_way_chart(tin: Tin, cmd: Command) -> Tuple[str, dict]:
    key = f"{cmd.intf_id}_{tin.ident}_way"

    chart = {
        "options": [
            None,
            f"{tin.name} Way",
            "count",
            f"{tin.ident}",
            f"CAKE.{tin.ident}_way",
            "line",
        ],
        "lines": [
            [
                f"{cmd.intf_id}_{tin.ident}_way_collisions",
                f"collisions",
                "incremental",
                1,
                1,
            ],
            [
                f"{cmd.intf_id}_{tin.ident}_way_indirect_hits",
                f"indirect_hits",
                "incremental",
                1,
                1,
            ],
            [f"{cmd.intf_id}_{tin.ident}_way_misses", f"misses", "incremental", 1, 1],
        ],
    }

    return key, chart


def add_chart(order, charts, func: Callable):
    key, chart = func()
    order.append(key)
    charts[key] = chart


def generate_charts(cmds: List[Command]) -> Tuple[List[str], dict]:
    order = []
    charts = {}
    for cmd in cmds:
        cmd.update_num_tins()
        for func in (generate_bw_chart, generate_packets_chart, generate_memory_chart):
            add_chart(order, charts, lambda: func(cmd))
        for tin in get_tins(cmd.num_tins):
            for func in (
                generate_tin_bw_chart,
                generate_tin_packets_chart,
                generate_tin_delay_chart,
                generate_tin_flows_chart,
                generate_tin_way_chart,
            ):
                add_chart(order, charts, lambda: func(tin, cmd))
    return order, charts


class Service(SimpleService):
    def __init__(
        self, configuration: Optional[dict] = None, name: Optional[str] = None
    ):
        super().__init__(configuration=configuration, name=name)
        self.interfaces = configuration.get("interfaces") or []
        self.exe = configuration.get("tc_executable") or "/sbin/tc"
        self.cmds = [Command(self.exe, intf) for intf in self.interfaces]
        self.order = None
        self.definitions = None

    def check(self) -> bool:
        if not self.interfaces or not isinstance(self.interfaces, Iterable):
            self.error('"interfaces" not defined in the module configuration file')
            return False
        if not self.exe:
            self.error(
                '"tc_executable" is not defined in the module configuration file'
            )
            return False

        for cmd in self.cmds:
            try:
                data = get_data(cmd.cmd)
            except Exception as exc:
                self.error(f'"{shlex.join(cmd.cmd)}" failed: {exc}')
                return False
            if not data:
                self.error(f'"{shlex.join(cmd.cmd)}" did not return any data')
                return False

        try:
            self.order, self.definitions = generate_charts(self.cmds)
        except Exception as exc:
            self.error(f"Failed to generate charts: {exc}")
            return False

        return True

    def __get_data(self) -> dict:
        stats = {}
        for cmd in self.cmds:
            stats.update(get_stats(cmd))
        return stats

    def _get_data(self) -> dict:
        try:
            return self.__get_data()
        except TinChangeException:
            self.order, self.definitions = generate_charts(self.cmds)
            return self.__get_data()


if __name__ == "__main__":
    tc_exe = "/sbin/tc" if _in_netdata else "/usr/sbin/tc"
    config = {"interfaces": ("wan", "ifb-wan"), "tc_executable": tc_exe}

    service = Service(config)
    if service.check():
        import time

        start = time.time()
        data = service._get_data()
        end = time.time()

        pprint(service.definitions)
        pprint(service.order)
        pprint(data)
        print(end - start)
