# pyright: reportMissingTypeStubs=false, reportUnknownParameterType=false, reportMissingParameterType=false, reportUnknownArgumentType=false, reportUnknownMemberType=false, reportAttributeAccessIssue=false

import logging
import time
import requests
from client import ChaosClient, FakerClient
from flask import Flask, make_response
from logging_utils import handler

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(process)d - %(levelname)s - %(message)s",
)

# global variables
app = Flask(__name__)
logger = logging.getLogger()
logger.addHandler(handler)

@app.route("/users", methods=["GET"])
def get_user():
    user, status = db.get_user(123)
    logger.info(f"Found user {user!s} with status {status}")
    data = {}
    if user is not None:
        data = {"id": user.id, "name": user.name, "address": user.address}
    else:
        logger.warning(f"Could not find user with id {123}")
    logger.debug(f"Collected data is {data}")
    response = make_response(data, status)
    logger.debug(f"Generated response {response}")
    return response


def do_stuff():
    time.sleep(0.1)
    url = "http://localhost:6000/"
    response = requests.get(url)
    return response


@app.route("/")
def index():
    logger.info("Info from the index function")
    do_stuff()
    current_time = time.strftime("%a, %d %b %Y %H:%M:%S", time.gmtime())
    return f"Hello, World! It's currently {current_time}"


if __name__ == "__main__":
    db = ChaosClient(client=FakerClient())
    app.run(host="0.0.0.0", debug=True)
