import numpy as np
import matplotlib.pyplot as plt
from PIL import Image
import mediapipe as mp
from mediapipe import solutions
from mediapipe.framework.formats import landmark_pb2
import cv2


def get_worst_preds(batch_gen, Y_pred, threshold):
    rotten = []
    batch_gen.reset()
    for i, c in enumerate(batch_gen.classes):
        if Y_pred[i][c] < threshold:
            pred_c = np.argmax(Y_pred[i])
            rotten.append((batch_gen.filepaths[i], c, pred_c, Y_pred[i][pred_c]))
    return rotten


def show_worst_preds(batch_gen, Y_pred, class_names, threshold=0.1):
    """
    This function shows the images for which the model gave a probability of less than the given threshold

    Arguments:
        batch_generator {DirectoryIterator} -- Batch generator created by ImageDataGenerator.flow_from_directory, for example
        Y_pred {numpy.array} -- An array of the outputs of the model
        class_names {[str]} -- a list of strings containing the names of the classes in correct order
        threshold {float} -- Probability threshold
    """

    preds = get_worst_preds(batch_gen, Y_pred, threshold)
    print(f"Got {len(preds)} worst predictions")
    plt.figure()
    fig, axes = plt.subplots(5, 5, figsize=(20, 20))
    axes = axes.flatten()
    for pred_data, ax in zip(preds, axes):
        img = np.array(Image.open(pred_data[0]))
        ax.imshow(img.astype(np.uint8))
        ax.set_title(f'Pred: {class_names[pred_data[2]]} ({pred_data[3]:.2f}) - {class_names[pred_data[1]]}')
        ax.axis('off')
    plt.tight_layout()
    plt.show()


def crop_resize_image(img, target=(224, 224)):
    """ Crop and resize a PIL Image to a squared target size """
    width, height = img.size
    crop_size = min(width, height)

    left = (width - crop_size)/2
    top = (height - crop_size)/2
    right = (width + crop_size)/2
    bottom = (height + crop_size)/2

    # Crop the center of the image
    img = img.crop((left, top, right, bottom))
    return img.resize(target, Image.ANTIALIAS)

def draw_landmarks_on_image(rgb_image, detection_result):
    """ Draws hand landmarks on top of the image """
    margin = 10  # pixels
    font_size = 1
    font_thickness = 1
    handedness_text_color = (88, 205, 54) # vibrant green

    hand_landmarks_list = detection_result.hand_landmarks
    handedness_list = detection_result.handedness
    annotated_image = np.copy(rgb_image)

    # Check alfa channel is all 255
    if np.all(annotated_image[:, :, 3] == 255):
        annotated_image = annotated_image[:, :, :3].astype(np.uint8)
    else:
        raise ValueError('Input image must contain three channel bgr data. Not all alfa channel are 255')

    # Loop through the detected hands to visualize.
    for idx, _ in enumerate(hand_landmarks_list):
        hand_landmarks = hand_landmarks_list[idx]
        handedness = handedness_list[idx]

        # Draw the hand landmarks.
        hand_landmarks_proto = landmark_pb2.NormalizedLandmarkList()
        hand_landmarks_proto.landmark.extend([
        landmark_pb2.NormalizedLandmark(x=landmark.x, y=landmark.y, z=landmark.z) for landmark in hand_landmarks])
        solutions.drawing_utils.draw_landmarks(
            annotated_image,
            hand_landmarks_proto,
            solutions.hands.HAND_CONNECTIONS,
            solutions.drawing_styles.get_default_hand_landmarks_style(),
            solutions.drawing_styles.get_default_hand_connections_style())

        # Get the top left corner of the detected hand's bounding box.
        height, width, _ = annotated_image.shape
        x_coordinates = [landmark.x for landmark in hand_landmarks]
        y_coordinates = [landmark.y for landmark in hand_landmarks]
        text_x = int(min(x_coordinates) * width)
        text_y = int(min(y_coordinates) * height) - margin

        # Draw handedness (left or right hand) on the image.
        cv2.putText(annotated_image, f"{handedness[0].category_name}",
                    (text_x, text_y), cv2.FONT_HERSHEY_DUPLEX,
                    font_size, handedness_text_color, font_thickness, cv2.LINE_AA)

    return annotated_image
