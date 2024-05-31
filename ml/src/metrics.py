from sklearn.metrics import classification_report, confusion_matrix
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt


def print_confusion_matrix(model, batch_generator, Y_pred, class_names, print_report=True):
    """
    This function shows the confusion matrix of a model's predictions given a batch generator

    Arguments:
        model {tf.keras.Model} -- model to test
        batch_generator {DirectoryIterator} -- Batch generator created by ImageDataGenerator.flow_from_directory, for example
        Y_pred {numpy.ndarray} -- Results of running model.predict
        class_names {[str]} -- a list of strings containing the names of the classes in correct order
        print_report {bool} -- whether to print the classification report
    """

    y_pred = np.argmax(Y_pred, axis=1)

    # Confusion Matrix
    cm = confusion_matrix(batch_generator.classes, y_pred)

    if print_report:
        print('Classification Report')
        print(classification_report(batch_generator.classes, y_pred, target_names=class_names))

    df_cm = pd.DataFrame(cm, class_names, class_names)
    plt.figure(figsize=(10, 8))
    sns.heatmap(df_cm, annot=True, fmt="d", cmap="YlGnBu")


def plot_accuracy(train_accuracy, val_accuracy):
    epochs = range(1, len(train_accuracy)+1)

    plt.figure(figsize=(10, 6))
    plt.plot(epochs, train_accuracy, c="red", label="Training")
    plt.plot(epochs, val_accuracy, c="blue", label="Validation")
    plt.xlabel("Epochs")
    plt.ylabel("Accuracy")
    plt.xticks(epochs)
    plt.legend()


def plot_loss(train_loss, val_loss):
    epochs = range(1, len(train_loss)+1)

    plt.figure(figsize=(10, 6))
    plt.plot(epochs, train_loss, c="red", label="Training")
    plt.plot(epochs, val_loss, c="blue", label="Validation")
    plt.xlabel("Epochs")
    plt.ylabel("Loss")
    plt.xticks(epochs)
    plt.legend()
