import base64
import logging
from flask import Flask, jsonify, request
import os

from werkzeug.serving import WSGIRequestHandler

from tflite_helper import TfliteHelper
from utils import preprocess_image, save_image, postprocess_image

OUTPUT_PATH = "assets/output.jpg"
MODEL_PATH = "assets/mirnet.tflite"
app_dir = os.path.dirname(os.path.abspath(__file__))
asset_folder = os.path.join(app_dir, 'assets')
input_image_path = os.path.join(asset_folder, 'input.jpg')

app = Flask(__name__)
logging.basicConfig(filename='flask.log', level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')


@app.route("/enhanceImage", methods=["POST"])
def enhance_image():
    data = request.get_json()
    if 'input_image_base64' not in data:
        return jsonify({'error': 'No input image provided'}), 400

    input_image = data["input_image_base64"]
    saved_input_image_path = save_input_image(input_image)
    im = preprocess_image(saved_input_image_path)
    tflite_helper = TfliteHelper(MODEL_PATH)
    output_array = tflite_helper.predict(im)
    save_image(output_array, OUTPUT_PATH.split(".")[0])
    result_image = postprocess_image(OUTPUT_PATH, saved_input_image_path)
    save_image(result_image, OUTPUT_PATH.split(".")[0])

    with open(OUTPUT_PATH, "rb") as img_file:
        base64_str = base64.b64encode(img_file.read()).decode("utf-8")

    return jsonify({'result_image': base64_str}), 200


def save_input_image(input_image_base64):
    with open(input_image_path, 'wb') as f:
        content_image_bytes = base64.b64decode(input_image_base64)
        f.write(content_image_bytes)

    return input_image_path


if __name__ == '__main__':
    WSGIRequestHandler.protocol_version = "HTTP/1.1"
    app.run(debug=False, port=8080, host='0.0.0.0')
