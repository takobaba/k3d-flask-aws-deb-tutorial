import os
from flask import Flask

app = Flask(__name__)
APP_NAME = os.environ.get("APP_NAME", "amazon")

@app.route("/")
def home():
    return APP_NAME

@app.route("/healthcheck")
def healthcheck():
    return "OK"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
