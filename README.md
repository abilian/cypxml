# cypxml, XML generator written in Cython+

## About

`cypxml` generates an XML content. `cypxml` provides quite the same functionalities
as the `xmlwitch` library. Both tools have quite the same performances for now:
  - For performances, see the `test_perf_*.sh` scripts and `perf_*.txt` result files.
  - `xmlwitch` writes sequentially the generated XML into a BytesIO(), which
      is quite fast. Especially, the dump method str(BytesIO) is immediate.
  - `cypxml` generates a cypclass Str() for each XML tag, from the Str() of each XML
    child, recursively. This is an algorithm slower than `xmlwitch`'s, but it permits
    some multicore implementation.

CythonPlus: https://www.cython.plus and https://pypi.org/project/cython-plus

xmlwitch: https://github.com/galvez/xmlwitch


## Installation

- Prerequisites:
    - Linux with C++ development environment (tested on Ubuntu 2020),
    - Python 3.8+,
    - CythonPlus installed (see https://pypi.org/project/cython-plus/)
    - Only for performance tests: `pip install xmlwitch`

- {fmt} library:

    `cypxml` uses the libfmt library. For convenience a copy of fmtlib version 8.1
    is included in this package and compiled locally as static library during the build
    process.
    See https://github.com/fmtlib/fmt

- build and install:

    `pip install -e .`


## Usage

Cython+ code:

    from .cypxml cimport cypXML

    cdef cypXML gen_xml() nogil:
        xml = cypXML()
        xml.init_version(Str("1.0"))
        for geo in range(4):
            g = xml.tag(Str("Geo")).attr(Str("zone"), format("{}", geo))
            for area in range(8):
                a = g.tag(Str("Area")).attr(Str("where"), format("{}", area))
                for city in range(40):
                    c = a.tag(Str("City"))
                    c.tag(Str("Name")).text(format("name of city {}", city))
                    c.tag(Str("Location")).text(format("location of city {}", city))
                    for item in range(50):
                        c.tag(format("item")).attr(Str("ref"), format("{}", item)).attr(Str("number"), Str("10")).attr(Str("date"), Str("2022-1-1"))
        return xml

    xml = gen_xml()
    content = xml.dump().bytes().decode("utf8")


Result:

    <?xml version="1.0" encoding="utf-8"?>
    <Geo zone="0">
      <Area where="0">
        <City>
          <Name>name of city 0</Name>
          <Location>location of city 0</Location>
          <item ref="0" number="10" date="2022-1-1" />
    ...


Code with the python library xmlwitch for the same result:

    import xmlwitch

    def gen_xml_xw():
        xml = xmlwitch.Builder(version="1.0")
        for geo in range(4):
            with xml.Geo(zone=str(geo)):
                for area in range(8):
                    with xml.Area(where=str(area)):
                        for city in range(40):
                            with xml.City:
                                xml.Name(f"name of city {city}")
                                xml.Location(f"location of city {city}")
                                for item in range(50):
                                    xml.item(ref=str(item), number="10", date="2022-1-1")
        return xml

    xml = gen_xml_xw()
    content = str(xml)


## Sources

https://github.com/abilian/cypxml


## License

MIT, see LICENSE file.
