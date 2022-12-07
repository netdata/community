import os
import logging
import pprint
import requests
from requests import HTTPError

client_id = "INSERT_CLIENT_ID"
device_id = "INSERT_DEVICE_ID"
client_secret = os.environ["secret"]
authorisation_url = "https://accounts-api.airthings.com/v1/token"
device_url = f"https://ext-api.airthings.com/v1/devices/{device_id}/latest-samples"
token_req_payload = {
    "grant_type": "client_credentials",
    "scope": "read:device:current_values",
}

# Request Access Token from auth server
try:
    token_response = requests.post(
        authorisation_url,
        data=token_req_payload,
        allow_redirects=False,
        auth=(client_id, client_secret),
    )
except HTTPError as e:
    logging.error(e)

token = token_response.json()["access_token"]

# Get the latest data for the device from the Airthings API.
try:
    api_headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(url=device_url, headers=api_headers)
except HTTPError as e:
    logging.error(e)

print(f"{response.json()['data']['co2']},{response.json()['data']['humidity']},{response.json()['data']['pm1']},{response.json()['data']['pm25']},{response.json()['data']['pressure']},{response.json()['data']['radonShortTermAvg']},{response.json()['data']['temp']},{response.json()['data']['voc']}")
