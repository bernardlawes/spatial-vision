# 📦 SpatialMap Vision Suite

A modular, full-stack computer vision suite for training, deploying, and running object detection models across Python and C++ environments. This parent repository uses Git submodules to link tightly integrated components.

---

## 🔗 Included Submodules

| Submodule | Description |
|-----------|-------------|
| [`vision-train-py`](./vision-train-py) | Python repo for training, exporting, and evaluating YOLO and transformer-based object detection models |
| [`vision-infer-cpp`](./vision-infer-cpp) | C++ inference engine for running exported ONNX models in real-time (ONNX Runtime, OpenCV DNN) |
| [`vision-common`](./vision-common) | Shared label maps, preprocessing logic, and configuration files used across both Python and C++ |

---

## 🛠️ Setup

```bash
git clone https://github.com/bernardlawes/spatialmap-vision.git
cd spatialmap-vision
git submodule update --init --recursive

```
Make sure to run the submodule sync script after pulling:
```bash
./submodules-manage.sh sync
```

Folder Structure
```bash
spatialmap-vision/
├── vision-train-py/       # Submodule: training and model export
├── vision-infer-cpp/      # Submodule: C++ ONNX inference
├── vision-common/   # Submodule: shared logic and labels
├── models/                # Shared ONNX models
├── demos/                 # End-to-end pipelines and sample runs
├── submodules.json
└── submodules-manage.sh
```

🧠 Goals
Unified training → inference workflow

Efficient model deployment to Jetson, desktop, and cloud

Shared metadata and logic to reduce error drift


🧠 Syncing with GitHub across submodules and parent
# Real execution
./submodules-manage.sh sync

# Dry run (safe preview)
./submodules-manage.sh sync --dry-run
