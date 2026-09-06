import base64
import cv2
import numpy as np
import torch
from pathlib import Path
import os
import shutil
import uuid
from fastapi import APIRouter, HTTPException, File, UploadFile
from fastapi.responses import JSONResponse

from src.core.constants import PUBLIC_TEMP_DIR
from src.pipelines.prediction_pipeline import PredictionPipeline
from src.domain.config_entity import Model_prediction_config

router = APIRouter()

prediction_pipeline = PredictionPipeline(model_prediction_config=Model_prediction_config())


def numpy_to_base64(img_np: np.ndarray, format: str = ".jpg") -> str:
    """NumPy image array ko base64 data URI string me convert karta hai."""
    if img_np is None:
        return ""
    success, buffer = cv2.imencode(format, img_np)
    if not success:
        return ""
    b64_str = base64.b64encode(buffer).decode("utf-8")
    mime = "image/jpeg" if format.lower() in [".jpg", ".jpeg"] else "image/png"
    return f"data:{mime};base64,{b64_str}"


@router.post("/predict")
async def predict(
    image1: UploadFile = File(..., description="Reference image"),
    image2: UploadFile = File(..., description="Source image")
):
    os.makedirs(PUBLIC_TEMP_DIR, exist_ok=True)
    dest_dir = os.path.join(PUBLIC_TEMP_DIR, str(uuid.uuid4()))
    os.makedirs(dest_dir, exist_ok=True)
    
    ref_img = os.path.join(dest_dir, f"0_{image1.filename}")
    src_img = os.path.join(dest_dir, f"1_{image2.filename}")
    
    with open(ref_img, "wb") as f:
        shutil.copyfileobj(image1.file, f)
    with open(src_img, "wb") as f:
        shutil.copyfileobj(image2.file, f)

    matches, H, inlier_mask, vis_img0, vis_img1, vis_matches, warped_img1, overlay = (
        prediction_pipeline.predict({
            "reference": ref_img,
            "source": src_img,
        })
    )

    keypoints0 = matches["keypoints0"].cpu().numpy().tolist() if isinstance(matches.get("keypoints0"), torch.Tensor) else []
    keypoints1 = matches["keypoints1"].cpu().numpy().tolist() if isinstance(matches.get("keypoints1"), torch.Tensor) else []
    confidence = matches["confidence"].cpu().numpy().tolist() if isinstance(matches.get("confidence"), torch.Tensor) else []
    
    homography_matrix = H.tolist() if isinstance(H, np.ndarray) else None
    inliers = inlier_mask.tolist() if isinstance(inlier_mask, np.ndarray) else []

    response_payload = {
        "status": "success",
        "metrics": {
            "total_matches": len(keypoints0),
            "inliers_count": int(sum(inliers)) if inliers else 0,
        },
        "homography": homography_matrix,
        "keypoints": {
            "reference": keypoints0,
            "source": keypoints1,
            "confidence": confidence,
            "inlier_mask": inliers
        },
        "visualizations": {
            "ref_points": numpy_to_base64(vis_img0),
            "src_points": numpy_to_base64(vis_img1),
            "match_lines": numpy_to_base64(vis_matches),
            "warped_source": numpy_to_base64(warped_img1),
            "registered_overlay": numpy_to_base64(overlay),
        }
    }


    output_dir = Path(__file__).resolve().parents[2]
    images_to_save = {
        "vis_img0.jpg": vis_img0,
        "vis_img1.jpg": vis_img1,
        "vis_matches.jpg": vis_matches,
        "warped_img1.jpg": warped_img1,
        "overlay.jpg": overlay,
    }
    for filename, image in images_to_save.items():
        saved = cv2.imwrite(str(output_dir / filename), image)
        if not saved:
            raise HTTPException(status_code=500, detail=f"Could not save {filename}.")

    # Cleanup temporary files
    if os.path.exists(ref_img): os.remove(ref_img)
    if os.path.exists(src_img): os.remove(src_img)
    if os.path.exists(dest_dir): os.rmdir(dest_dir)

    return JSONResponse(content=response_payload, status_code=200)