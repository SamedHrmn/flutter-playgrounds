import matplotlib.pyplot as plt
import tensorflow as tf
from PIL import Image
import numpy as np


def save_image(image, filename):
    if not isinstance(image, Image.Image):
        image = tf.squeeze(image) * 255.0
        image = tf.clip_by_value(image, 0, 255)
        image = Image.fromarray(tf.cast(image, tf.uint8).numpy())
    image.save("%s.jpg" % filename)
    print("Saved as %s.jpg" % filename)


def plot_image(image, title=""):
    image = np.asarray(image)
    image = tf.clip_by_value(image, 0, 255)
    image = Image.fromarray(tf.cast(image, tf.uint8).numpy())
    print(image.width, image.height)
    plt.imshow(image)
    plt.axis("off")
    plt.title(title)
    plt.show()


def preprocess_image(image_path):
    processed_image = Image.open(image_path)
    processed_image = processed_image.resize((400, 400))
    processed_image = np.array(processed_image).astype(np.float32) / 255.0
    processed_image = tf.expand_dims(processed_image, 0)
    processed_image = tf.reshape(processed_image[:, :, :, :3], (1, 400, 400, 3))
    return processed_image


def postprocess_image(output_image_path, input_image_path):
    input_image = Image.open(input_image_path)
    input_image = np.asarray(input_image)
    input_image_width, input_image_height = input_image.shape[0:2]

    max_output_size = 512

    if input_image_width > input_image_height:
        output_width = max_output_size
        output_height = int(input_image_height * (max_output_size / input_image_width))
    else:
        output_height = max_output_size
        output_width = int(input_image_width * (max_output_size / input_image_height))

    output_image = Image.open(output_image_path)
    return output_image.resize((output_height, output_width))
