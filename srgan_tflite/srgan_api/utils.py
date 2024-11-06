import numpy as np
from PIL import Image
import tensorflow as tf


def preprocess_image(image_path):
    processed_image = Image.open(image_path)
    processed_image = np.array(processed_image).astype(np.float32)
    processed_image = tf.expand_dims(processed_image, 0)
    processed_image = np.reshape(processed_image, (1, processed_image.shape[1], processed_image.shape[2], 3))
    return processed_image


def save_image(image, filename):
    if not isinstance(image, Image.Image):
        image = tf.squeeze(image)
        image = tf.clip_by_value(image, 0, 255)
        image = Image.fromarray(tf.cast(image, tf.uint8).numpy())
    image.save("%s.jpg" % filename)
    print("Saved as %s.jpg" % filename)
