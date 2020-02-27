#! /usr/bin/env python
# -*- coding: utf-8 -*-
# pylint: disable=bad-whitespace, superfluous-parens
"""
    Cookiecutter post-gen hook.

    This gets called with no arguments, and with the project directory
    as the working directory. All templates are expanded and copied,
    and the post hook can add, modify, or delete files.

    Copyright (c) 2015 Juergen Hermann <jh@web.de>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
"""
from __future__ import absolute_import, unicode_literals, print_function
from collections import OrderedDict

import io
import os
import sys
import json
import pprint

DEBUG = False


def get_context():
    """Return context as a dict."""
    cookiecutter = None  # Make pylint happy
    return {{ cookiecutter | pprint }}


def dump_context(context, filename):
    """Dump JSON context to given file."""
    with io.open(filename, 'w', encoding='ascii') as handle:
        data = json.dumps(context, indent=4, sort_keys=True, ensure_ascii=True)
        handle.write(data + '\n')


def run():
    """Main loop."""
    context = get_context()
    dump_context(context, 'cookiecutter.json')


if __name__ == '__main__':
    run()
