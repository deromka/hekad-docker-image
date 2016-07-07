#!/usr/bin/env python

import os, sys
from jinja2 import Environment, FileSystemLoader, StrictUndefined

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
print "Current Dir = {}".format(CURRENT_DIR)
TEMPLATE_ENVIRONMENT = Environment(
    autoescape=False,
    loader=FileSystemLoader(CURRENT_DIR),
    undefined=StrictUndefined,
    trim_blocks=False)


def render_template(template_filename, context):
    return TEMPLATE_ENVIRONMENT.get_template(template_filename).render(context)

def get_context():
    context = {}

    # read env vars
    for k, v in os.environ.items():
        context[k] = v

    # read context.properties file and override the env values
    with open("env.properties", 'r') as context_file:
        for line in context_file:
            line = line.rstrip() #removes trailing whitespace and '\n' chars

            if "=" not in line: continue #skips blanks and comments w/o =
            if line.startswith("#"): continue #skips comments which contain =

            else:
                k, v = line.split("=", 1)
            context[k.strip()] = v.strip()
    return context

def create_file(fileTemplate, fileOutput):
    print "Generating file in {} from template {}".format(fileOutput, fileTemplate)
    context = get_context()
    #print context
    #
    with open(fileOutput, 'w') as f:
        file = render_template(fileTemplate, context)
        f.write(file)
    print "Done."


def main(argv):
    if (len(sys.argv)<3):
        print "Usage: evaluate-template-file.py <Jinja2 Template> <file to be created>"
    fileTemplate = argv[1]
    fileOutput = argv[2]
    create_file(fileTemplate, fileOutput)

########################################

if __name__ == "__main__":
    main(sys.argv)