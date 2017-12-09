#!/usr/bin/env python

import argparse
import json
import requests

def arg_parser():
    parser = argparse.ArgumentParser(description='Interact with the Skycoin RPC API')
    parser.add_argument('-m', '--method', type=str,
                        help='Method to send to the API')

    parser.add_argument('-p', '--params', nargs="+",
                        help='Method paramters')

    args = parser.parse_args()

    global method
    method = args.method

    global parameters
    parameters = args.params

def payload(method, parameters):
    no_param_methods = ['get_status']
    int_methods = ['get_blocks', 'get_lastblocks']
    string_methods = ['get_outputs', 'get_transaction', 'get_address_uxouts', 'inject_transaction']
    status = None
    if method in no_param_methods:
        status = False
    elif method in int_methods:
        status = True
        parameters = map(int, parameters)
    elif method in string_methods:
        status = True
        parameters = list(parameters)

    global api_payload
    if status is True:
        api_payload = {
                        "id":"1",
                        "jsonrpc":"2.0",
                        "method":method,
                        "params":parameters
                      }
    else:
        api_payload = {
                        "id":"1",
                        "jsonrpc":"2.0",
                        "method":method
                      }

def request(method, api_payload, *params):
    url = "http://127.0.0.1:6430/webrpc"
    headers = {'content-type': 'application/json-rpc'}

    payload = api_payload

    response = requests.post(
        url, data=json.dumps(payload), headers=headers)

    print response.text

def main():
    arg_parser()
    payload(method, parameters)
    request(method, api_payload, parameters)

if __name__ == "__main__":
    main()
