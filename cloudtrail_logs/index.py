'''

That function aims to parse cloudtrail logs, which stored in S3 and push to slack
if there is any manual operation, is done on aws console.

Variables:
    HOOK_URL string -- Slack webhook URL
    SLACK_CHANNEL string -- Slack webhook channel
    EXCLUDE_ACCOUNT_IDS string -- Excluded Account IDs
    USER_AGENT_LIST string -- User agent list to be analyzed
'''

import io
import re
import gzip
import json
import boto3
import os
import logging

from base64 import b64decode
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

HOOK_URL = os.environ['SLACK_HOOK_URL']
SLACK_CHANNEL = os.environ['SLACK_CHANNEL']
EXCLUDE_ACCOUNT_IDS = os.environ['EXCLUDE_ACCOUNT_IDS'].split(",")
USER_AGENT_LIST = os.environ['USER_AGENT'].split(",")

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def print_short_record(record):
    """
    Prints out an abbreviated, one-line representation of a CloudTrail record.
    
    :return: always False since not a real scan
    """
    print('[{timestamp}] {username}\t{region}\t{ip}\t{service}:{action}'.format(
        username=record["userIdentity"]["principalId"],
        timestamp=record['eventTime'],
        region=record['awsRegion'],
        ip=record['sourceIPAddress'],
        service=record['eventSource'].split('.')[0],
        action=record['eventName']
    ))
    
    return False

def get_records(session, bucket, key):
    """
    Loads a CloudTrail log file, decompresses it, and extracts its records.
    :param session: Boto3 session
    :param bucket: Bucket where log file is located
    :param key: Key to the log file object in the bucket
    :return: list of CloudTrail records
    """
    s3 = session.client('s3')
    response = s3.get_object(Bucket=bucket, Key=key)

    with io.BytesIO(response['Body'].read()) as obj:
        with gzip.GzipFile(fileobj=obj) as logfile:
            loadedJson = json.load(logfile)
            records = loadedJson["Records"]
            sorted_records = sorted(records, key=lambda r: r['eventTime']) 
            return sorted_records


def get_log_file_location(event):
    """
    Generator for the bucket and key names of each CloudTrail log 
    file contained in the event sent to this function from S3.
    (usually only one but this ensures we process them all).
    :param event: S3:ObjectCreated:Put notification event
    :return: yields bucket and key names
    """
    for event_record in event['Records']:
        bucket = event_record['s3']['bucket']['name']
        key = event_record['s3']['object']['key']
        yield bucket, key

def sendSlackMessage(record):
    slack_message = {
        "attachments": [
            {
                "color": "danger",
                "title": "Manual " + record["eventName"] + " by " + record["userIdentity"]["userName"] + " on " + record["eventSource"],
                "text": "",
                "fields": [
                    {
                        "title": "Request Parameters",
                        "value": '"' + json.dumps(record["requestParameters"]) + '"',
                        "short": False
                    },
                    {
                        "title": "Account ID",
                        "value": record["recipientAccountId"],
                        "short": False
                    }
                ],
                "footer": "CloudDrove",
                "footer_icon": "https://is5-ssl.mzstatic.com/image/thumb/Purple113/v4/70/dd/7c/70dd7cf3-be82-f6a2-9746-e7362a00aa2f/AppIcon-0-1x_U007emarketing-0-0-GLES2_U002c0-512MB-sRGB-0-0-0-85-220-0-0-0-7.png/600x600wa.png",
            }
        ]
    }

    req = Request(HOOK_URL, json.dumps(slack_message).encode('utf-8'))
    try:
        response = urlopen(req)
        response.read()
        logger.info("Message posted to %s", SLACK_CHANNEL)
    except HTTPError as e:
        logger.error("Request failed: %s", e)
    except URLError as e:
        logger.error("Server connection failed: %s", e)
    


def handler(event, context):
    # Create a Boto3 session that can be used to construct clients
    session = boto3.session.Session()
    cloudwatch = session.client('cloudwatch')

    # Get the S3 bucket and key for each log file contained in the event 
    for bucket, key in get_log_file_location(event):
        
        # Load the CloudTrail log file and extract its records
        print('Loading CloudTrail log file s3://{}/{}'.format(bucket, key))
        records = get_records(session, bucket, key)
        print('Number of records in log file: {}'.format(len(records)))

        # Process the CloudTrail records
        for record in records:  
            if record["recipientAccountId"] not in EXCLUDE_ACCOUNT_IDS and record['userAgent'] in USER_AGENT_LIST and ("Describe" not in record['eventName'] and "Get" not in record['eventName'] and "List" not in record['eventName'] and "View" not in record['eventName'] and "Validate" not in record['eventName'] and "Look" not in record['eventName'] and "Retrieve" not in record['eventName']):
                print_short_record(record)
                sendSlackMessage(record)