import os
from robot.libdoc import libdoc
# from src.MailClientLibrary.version import VERSION

DIRECTORY = "docs"
DIRECTORY_PATH = f"./{DIRECTORY}"
HTML_PATH = f"{DIRECTORY_PATH}/index.html"
# XML_PATH = f"{DIRECTORY_PATH}/{VERSION}.xml"

if not os.path.exists(DIRECTORY):
    os.mkdir(DIRECTORY)

libdoc("./src/MailClientLibrary", HTML_PATH)
# libdoc("./src/MailClientLibrary", XML_PATH)