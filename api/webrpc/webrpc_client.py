#!/usr/bin/env python

import requests
import json

def main():
    url = "http://127.0.0.1:6430/webrpc"
    headers = {'content-type': 'application/json-rpc'}

    payload = {
                "id":"1",
                "jsonrpc":"2.0",
                "method":"get_lastblocks",
                "params":[3]
              }

    response = requests.post(
        url, data=json.dumps(payload), headers=headers)

    print response.text

if __name__ == "__main__":
    main()
