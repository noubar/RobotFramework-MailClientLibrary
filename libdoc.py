import os
from robot.libdoc import libdoc

DIRECTORY = "keywords"
DIRECTORY_PATH = f"./{DIRECTORY}"
HTML_PATH = f"{DIRECTORY_PATH}/keywords.html"
XML_PATH = f"{DIRECTORY_PATH}/keywords.xml"

if not os.path.exists(DIRECTORY):
    os.mkdir(DIRECTORY)

libdoc("./src/MailClientLibrary", HTML_PATH)
libdoc("./src/MailClientLibrary", XML_PATH)