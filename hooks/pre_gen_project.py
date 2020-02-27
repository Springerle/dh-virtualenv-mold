#! /usr/bin/env python
# -*- coding: utf-8 -*-
# pylint: disable=bad-whitespace, superfluous-parens
"""
    Cookiecutter pre-gen hook.

    This gets called with no arguments, and with the project directory
    as the working directory. That is empty on the first run, but might
    also already be populated when Cookiecutter is called on a pre-
    existing project.

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

import os
import sys
import pprint

DEBUG = False


def run():
    """Main loop."""
    # Fallback for working with older Cookiecutter versions
    Undefined = None # pylint: disable=invalid-name, unused-variable

    # Make pylint happy
    version = verbose = checkout = repo_dir = context_file = cookiecutter = None

    version = {{ version | pprint }}
    try:
        version_info = tuple(int(i) for i in (version or '').split('.'))
    except (ValueError, TypeError):
        version_info = ()

    verbose = {{ verbose | pprint }}
    checkout = {{ checkout | pprint }}
    repo_dir = {{ repo_dir | pprint }}
    context_file = {{ context_file | pprint }}
    context = {{ cookiecutter | pprint }}

    if verbose or DEBUG:
        print('*' * 78)
        print('{} "{}"'.format(__doc__.split('.', 1)[0].strip(), sys.argv[0]))
        print('')
        print(u"    verbose={}".format(verbose))
        print(u"    checkout={}".format(checkout))
        print(u"    version={}".format(version))
        print(u"    version_info={}".format(version_info))
        print(u"    repo_dir={}".format(repo_dir))
        print(u"    context_file={}".format(context_file))
        print(u"    context={}".format(context))
        print(u"""    context[pprint]={{ cookiecutter | pprint }}""")
        print(u"    argv={}".format(sys.argv))
        print(u"    cwd={}".format(os.getcwd()))
        print(u"    ls={}".format(os.listdir('.')))
        print('*' * 78)


if __name__ == '__main__':
    run()
