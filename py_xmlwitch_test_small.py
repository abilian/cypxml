#!/usr/bin/env python

import xmlwitch
from time import perf_counter


def gen_xml_xw(ref):
    xml = xmlwitch.Builder(version="1.0")
    for geo in range(4):
        with xml.Geo(zone=str(geo), ref=str(ref)):
            for area in range(4):
                with xml.Area(where=str(area)):
                    for city in range(4):
                        with xml.City:
                            xml.Name(f"name of city {city}")
    return xml


def main():
    print("-------------------------------------")
    print("0 - Small file (x100) - pure python using xmlwitch")

    lst_xml = []
    t0 = perf_counter()
    for ref in range(100):
        lst_xml.append(gen_xml_xw(ref))
    dt_generate = (perf_counter() - t0) * 1000

    lst_content = []
    t0 = perf_counter()
    for xml in lst_xml:
        lst_content.append(str(xml))
    dt_dump = (perf_counter() - t0) * 1000

    content = lst_content[0]

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
