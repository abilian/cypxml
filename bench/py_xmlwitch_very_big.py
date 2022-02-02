#!/usr/bin/env python

import xmlwitch
from time import perf_counter


def gen_xml_xw():
    xml = xmlwitch.Builder(version="1.0")
    for world in range(8):
        with xml.World(zone=str(world)):
            for geo in range(4):
                with xml.Geo(zone=str(geo)):
                    for area in range(8):
                        with xml.Area(where=str(area)):
                            for city in range(40):
                                with xml.City:
                                    xml.Name(f"name of city {city}")
                                    xml.Location(f"location of city {city}")
                                    for item in range(50):
                                        xml.item(
                                            ref=str(item), number="10", date="2022-1-1"
                                        )
    return xml


def main():
    print("-------------------------------------")
    print("0 - Test very big file - pure python using xmlwitch")

    t0 = perf_counter()
    xml = gen_xml_xw()
    dt_generate = (perf_counter() - t0) * 1000

    t0 = perf_counter()
    content = str(xml)
    dt_dump = (perf_counter() - t0) * 1000

    print(f"Duration total (ms): {dt_dump+dt_generate:.0f}")
    print(f"  - dump xml (ms): {dt_dump:.0f}")
    print(f"  - gen xml  (ms): {dt_generate:.0f}")
    print("-------------------------------------")
    print(f"Size (MB): {len(content)/(2**20):.2f}")
    print("...")
    print("\n".join(content.splitlines()[:3]))
    print("...")
    print("-------------------------------------")
    print()


if __name__ == "__main__":
    main()
