#! /usr/bin/env python
# -*- coding: utf-8 -*-
"""
    Cookiecutter pre-gen hook.

    This gets called with no arguments, and with the project directory
    as the working directory. That is empty on the first run, but might
    also already be populated when Cookiecutter is called on a pre-
    existing project.
"""
import os
import sys
import pprint

DEBUG = False


def run():
    """Main loop."""
    Undefined = None # fallback for working with older Cookiecutter versions

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
        print(u"*** verbose={}".format(verbose))
        print(u"*** checkout={}".format(checkout))
        print(u"*** version={}".format(version))
        print(u"*** version_info={}".format(version_info))
        print(u"*** repo_dir={}".format(repo_dir))
        print(u"*** context_file={}".format(context_file))
        print(u"*** context={}".format(context))
        print(u"""*** context[pprint]={{ cookiecutter | pprint }}""")
        print(u"*** argv={}".format(sys.argv))
        print(u"*** cwd={}".format(os.getcwd()))
        print(u"*** ls={}".format(os.listdir('.')))


if __name__ == '__main__':
    run()
