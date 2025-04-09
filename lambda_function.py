import json
import urllib.parse
import boto3
import os
from PIL import Image
import io

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    source_bucket = os.environ['SOURCE_BUCKET']
    destination_bucket = os.environ['DESTINATION_BUCKET']

    for record in event['Records']:
        s3_event = record['s3']
        object_key = urllib.parse.unquote_plus(s3_event['object']['key'])

        if not object_key.lower().endswith('.jpg') and not object_key.lower().endswith('.jpeg'):
            continue

        try:
            response = s3_client.get_object(Bucket=source_bucket, Key=object_key)
            image_content = response['Body'].read()

            with io.BytesIO(image_content) as image_file:
                img = Image.open(image_file)

                file_name = os.path.splitext(object_key)[0]

                formats = [
                    {'ext': 'bmp', 'format': 'BMP'},
                    {'ext': 'gif', 'format': 'GIF'},
                    {'ext': 'png', 'format': 'PNG'}
                ]

                for format_info in formats:
                    output = io.BytesIO()
                    img.save(output, format=format_info['format'])
                    output.seek(0)

                    output_key = f"{file_name}.{format_info['ext']}"
                    s3_client.put_object(
                        Bucket=destination_bucket,
                        Key=output_key,
                        Body=output.getvalue(),
                        ContentType=f"image/{format_info['ext']}"
                    )

            return {
                'statusCode': 200,
                'body': json.dumps('Image conversion completed successfully!')
            }

        except Exception as e:
            print(f"Error: {str(e)}")
            return {
                'statusCode': 500,
                'body': json.dumps(f'Error processing image: {str(e)}')
            }