import numpy as np
import matplotlib.pyplot as plt
from PIL import Image


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
