# cypxml, XML generator written in Cython+

## About

`cypxml` generates an XML content. `cypxml` provides quite the same functionalities
as the `xmlwitch` library. Both tools have quite the same performances for now:
  - see: `test_perf.sh`
  - `xmlwitch` writes sequentially the generated XML into a BytesIO(), which
      is quite fast.
  - `cypxml` generates a Str() for each XML Tag, from the Str() of each XML child,
    recursively. This is an algorithm slower than `xmlwitch`'s, but it will permit
    some multicore implementation in the future versions.

CythonPlus: https://www.cython.plus and https://pypi.org/project/cython-plus

xmlwitch: https://github.com/galvez/xmlwitch


## Installation

- Prerequisites:
    - Linux with C++ development environment (tested on Ubuntu 2020),
    - Python 3.8+,
    - CythonPlus installed (see https://pypi.org/project/cython-plus/)

- {fmt} library:

    `cypxml` uses the libfmt library. For convenience a copy of fmtlib version 8.1
    is included in this package and compiled locally as static library during the build
    process.
    See https://github.com/fmtlib/fmt

- build:

    `./make.sh`


## Usage

Cython+ code:

    from .cypxml cimport cypXML

    cdef bytes test_large():
        cdef cypXML xml
        cdef int geo, area, city, item
        cdef bytes result

        ### code to test
        xml = cypXML()
        xml.init_version(Str("1.0"))
        for geo in range(5):
            g = xml.tag(Str("Geo")).attr(Str("zone"), format("{}", geo))
            for area in range(5):
                a = g.tag(Str("Area")).attr(Str("where"), format("{}", area))
                for city in range(40):
                    c = a.tag(Str("City"))
                    c.tag(Str("Name")).text(format("name of city {}", city))
                    c.tag(Str("Location")).text(format("location of city {}", city))
                    for item in range(50):
                        c.tag(format("item")).attr(Str("ref"), format("{}", item)).attr(Str("number"), Str("10")).attr(Str("date"), Str("2022-1-1"))
        result = xml.dump().bytes()
        return result

Result:

    <?xml version="1.0" encoding="utf-8"?>
    <Geo zone="0">
      <Area where="0">
        <City>
          <Name>name of city 0</Name>
          <Location>location of city 0</Location>
          <item ref="0" number="10" date="2022-1-1" />
          <item ref="1" number="10" date="2022-1-1" />

Code with the python library xmlwitch for the same result:

    import xmlwitch

    def test_large():
        xml = xmlwitch.Builder(version="1.0")
        for geo in range(5):
            with xml.Geo(zone=str(geo)):
                for area in range(5):
                    with xml.Area(where=str(area)):
                        for city in range(40):
                            with xml.City:
                                xml.Name(f"name of city {city}")
                                xml.Location(f"location of city {city}")
                                for item in range(50):
                                    xml.item(ref=str(item), number="10", date="2022-1-1")
        return str(xml)


## Bench

Quick test:

```
date; ./test_perf.sh
Fri Jan 28 10:25:41 UTC 2022
======== bench ========
-------------------------------------
Test large - python xmlwitch
Duration (ms): 919
-------------------------------------
Size (MB): 2.57
<?xml version="1.0" encoding="utf-8"?>
<Geo zone="0">
  <Area where="0">
    <City>
      <Name>name of city 0</Name>
      <Location>location of city 0</Location>
      <item date="2022-1-1" number="10" ref="0" />
      <item date="2022-1-1" number="10" ref="1" />
...
-------------------------------------

-------------------------------------
Test large - cythonplus cypXML
Duration (ms): 825
-------------------------------------
Size (MB): 2.57
<?xml version="1.0" encoding="utf-8"?>
<Geo zone="0">
  <Area where="0">
    <City>
      <Name>name of city 0</Name>
      <Location>location of city 0</Location>
      <item ref="0" number="10" date="2022-1-1" />
      <item ref="1" number="10" date="2022-1-1" />
...
-------------------------------------
```

## Sources

https://github.com/abilian/cypxml


## License

MIT, see LICENSE file.
