import itertools
import os

import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import vision
import pandas as pd


class KeypointGenerator:
    def __init__(self, model_path):
        self.detector = self.__initialize_detector(model_path)

    def generate_keypoints(self, output_file):
        landmarks = []
        for letter in ['L', 'O', 'K', 'I']:
            images_path = f'../datasets/asl_alphabet_train/{letter}'
            for image in os.listdir(images_path):
                path = f'{images_path}/{image}'
                data_landmark = self.create_landmark(path)
                if data_landmark is not None:
                    data_landmark.append(letter)
                    landmarks.append(data_landmark)
        columns = [f'x_{i}' for i in range(63)]
        columns.append('class')
        dataframe = pd.DataFrame(data=landmarks, columns=columns)
        dataframe.to_csv(path_or_buf=output_file)

    def create_landmark(self, image_path):
        image = mp.Image.create_from_file(image_path)
        detection_result = self.detector.detect(image)
        return self.process_landmark(detection_result)
    

    def process_landmark(self, detection_result):
        if not detection_result.hand_landmarks:
            return None
        landmarks = detection_result.hand_landmarks[0]

        landmark_extraction = lambda keypoint: [keypoint.x, keypoint.y, keypoint.z]
        landmarks = list(map(landmark_extraction, landmarks))
        landmarks = list(itertools.chain.from_iterable(landmarks))
        return landmarks
    

    def __initialize_detector(self, model_path):
        base_options = python.BaseOptions(model_asset_path=model_path)
        options = vision.HandLandmarkerOptions(base_options=base_options,
                                       num_hands=1)
        return vision.HandLandmarker.create_from_options(options)
