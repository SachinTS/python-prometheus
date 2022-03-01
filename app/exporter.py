from typing import Counter
from prometheus_client import start_http_server, Gauge, Summary
from time import sleep
import requests
import random
import signal
import sys



urls = ["https://httpstat.us/503", "https://httpstat.us/200"]

CHECK_STATUS_CODE = Gauge('sample_external_url_up',
                          'Check if url is up', ['url'])
REQUEST_TIME = Summary('sample_external_url_response_ms',
                       'Time spent processing request', ['url'])

def signal_handler(sig, frame):
    print('You pressed Ctrl+C!')
    sys.exit(0)


def query(url):
    
    response = requests.get(url)
    REQUEST_TIME.labels(url).observe(response.elapsed.microseconds//1000)
    if response.status_code == 200:
        CHECK_STATUS_CODE.labels(url).set(0)
    else:
        CHECK_STATUS_CODE.labels(url).set(1)

def main():
    start_http_server(8000)
    while True:
        for a in urls:
            sleep(random.randint(0, 5))
            query(a)

if __name__ == '__main__':
    signal.signal(signal.SIGINT, signal_handler)
    main()
