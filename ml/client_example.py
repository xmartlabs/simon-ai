import json
import requests
import cv2
import numpy as np
import random

classes = ['I', 'K', 'L', 'O']
error_count = 0
ITERATIONS = 3000
for letter in classes:
    for i in range(1, ITERATIONS):
        image_path = f'asl_alphabet_train/{letter}/{letter}{i}.jpg'
        image_content = cv2.imread(f"/home/maxi/simon_ai/datasets/{image_path}", 1).astype('uint8').tolist()
        data = json.dumps({"signature_name": "serving_default","inputs": [image_content]})
        headers = {"content-type": "application/json"}
        json_response = requests.post('http://localhost:8501/v1/models/tf_model:predict',
                                      data=data,
                                      headers=headers,
                                      timeout=10)
        prediction = json.loads(json_response.text)['outputs'][0]
        prediction_index = np.argmax(prediction)
        label_prediction = classes[prediction_index]
        if letter != label_prediction:
            error_count += 1
            print(f'(Real, Prediction)= ({letter}, {label_prediction}). Image: {image_path}')
print(f'Error count: {error_count}. Accuracy: f{1- error_count/(ITERATIONS*4)}')
