from stdlib.string cimport Str
from stdlib.format cimport format
from libcythonplus.dict cimport cypdict
from libcythonplus.list cimport cyplist

from .stdlib.xml_utils cimport escaped, quotedattr, nameprep, concate


cdef cypclass cypXML:
    """A basic cypclass providing XML document API
    """
    Str version
    # cypElement root
    cyplist[cypElement] children
    cyplist[Str] content
    Str indent_space
    cyplist[Str] chunks

    __init__(self):
        self.version = Str()
        # self.root = cypElement(Str(""))
        self.children = cyplist[cypElement]()
        self.content = cyplist[Str]()
        self.indent_space = Str("  ")
        self.chunks = NULL

    void init_version(self, Str version):
        self.version = version

    void insert_content(self, Str content):
        self.content.append(content.copy())

    void set_indent_space(self, Str indent_space):
        self.indent_space = indent_space.copy()

    void _generate_header(self):
        cdef Str header

        if self.version.__len__() != 0:
            header = format(
                "<?xml version=\"{}\" encoding=\"utf-8\"?>\n",
                self.version
            )
            self.content.insert(0, header)

    cypElement tag(self, Str name):
        cdef cypElement e

        e = cypElement(name, self.indent_space)
        self.children.append(e)
        return e

    Str dump(self):
        cdef Str result
        cdef Str item
        cdef cypElement c

        self._generate_header()
        self.chunks = cyplist[Str]()
        for item in self.content:
            self.chunks.append(item)
        for c in self.children:
            self.chunks.append(c.dump(0))
        result = concate(self.chunks)
        return result

    const char * to_bytes(self):
        return self.dump()._str.c_str()


cdef cypclass cypElement:
    """A basic cypclass providing XML tag definition
    """
    Str name
    # cypElement parent  unused
    cyplist[cypElement] children
    cyplist[Str] attributes
    cyplist[Str] content
    Str indent_space
    Str spaces

    __init__(self, Str name, Str indent_space):
    # __init__(self, Str name, cypElement parent):
        self.name = nameprep(name)
        # self.parent = parent
        # self.children = cyplist[cypElement]()
        self.children = NULL
        # self.attributes = cyplist[Str]()
        self.attributes = NULL
        # self.content = cyplist[Str]()
        self.content = NULL
        self.indent_space = indent_space.copy()
        self.spaces = NULL

    Str _space_indent(self, int indent):
        # need cache and recurse
        cdef Str space
        cdef cyplist[Str] sp_indent

        if self.spaces is NULL:
            if indent > 0:
                sp_indent = cyplist[Str]()
                for _i in range(indent):
                    sp_indent.append(self.indent_space)
                self.spaces = concate(sp_indent)
            else:
                self.spaces = Str("")
        return self.spaces

    Str dump_leaf(self, int indent):
        cdef Str spaces
        cdef Str result

        spaces = self._space_indent(indent)
        if self.content is not NULL and self.content.__len__() > 0:
            if self.attributes is not NULL and self.attributes.__len__() > 0:
                result = format(
                    "{}<{}{}>{}</{}>\n",
                    spaces,
                    self.name,
                    concate(self.attributes),
                    concate(self.content),
                    self.name,
                )
            else:
                result = format(
                    "{}<{}>{}</{}>\n",
                    spaces,
                    self.name,
                    concate(self.content),
                    self.name,
                )
        else:
            if self.attributes is not NULL and self.attributes.__len__() > 0:
                result = format(
                    "{}<{}{} />\n",
                    spaces,
                    self.name,
                    concate(self.attributes)
                )
            else:
                result = format(
                    "{}<{} />\n",
                    spaces,
                    self.name
                )
        return result

    Str dump(self, int indent):
        cdef Str spaces
        cdef cypElement c
        cdef cyplist[Str] child_dump
        cdef Str result

        spaces = self._space_indent(indent)
        if self.children is not NULL and self.children.__len__() > 0:
            child_dump = cyplist[Str]()
            for c in self.children:
                child_dump.append(c.dump(indent + 1))
            if self.content is not NULL and self.content.__len__() > 0:
                if self.attributes is not NULL and self.attributes.__len__() > 0:
                    result = format(
                        "{}<{}{}>{}\n{}{}</{}>\n",
                        spaces,
                        self.name,
                        concate(self.attributes),
                        concate(self.content),
                        concate(child_dump),
                        spaces,
                        self.name,
                    )
                else:
                    result = format(
                        "{}<{}>{}\n{}{}</{}>\n",
                        spaces,
                        self.name,
                        concate(self.content),
                        concate(child_dump),
                        spaces,
                        self.name,
                    )
            else:
                if self.attributes is not NULL and self.attributes.__len__() > 0:
                    result = format(
                        "{}<{}{}>\n{}{}</{}>\n",
                        spaces,
                        self.name,
                        concate(self.attributes),
                        concate(child_dump),
                        spaces,
                        self.name,
                    )
                else:
                    result = format(
                        "{}<{}>\n{}{}</{}>\n",
                        spaces,
                        self.name,
                        concate(child_dump),
                        spaces,
                        self.name,
                    )
        else:
            result = self.dump_leaf(indent)
        return result

    cypElement tag(self, Str name):
        """Append an element as child of current element

        Return the added element
        """
        cdef cypElement e

        e = cypElement(name, self.indent_space)
        if self.children is NULL:
            self.children = cyplist[cypElement]()
        self.children.append(e)
        return e

    cypElement text(self, Str txt):
        """Append an text as content of current element

        Return the element (self, not the added text)
        """
        if self.content is NULL:
            self.content = cyplist[Str]()
        self.content.append(escaped(txt, NULL))
        return self

    cypElement attr(self, Str key, Str value):
        """Append an attribute to current element

        Return the element (self, not the added attribute)
        """
        if self.attributes is NULL:
            self.attributes = cyplist[Str]()
        self.attributes.append(format(
            " {}={}",
            nameprep(key),
            quotedattr(value, NULL)
        ))
        return self


cdef Str to_str(byte_or_string)
