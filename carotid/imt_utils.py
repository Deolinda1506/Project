"""
Intima-Media Thickness (IMT) calculation from segmentation masks.
Pixel-to-millimeter conversion using spatial resolution for stroke risk triage benchmarks.
"""

from __future__ import annotations

import numpy as np
from typing import Tuple, Optional


def get_interfaces_from_mask(
    mask: np.ndarray,
    lumen_label: int = 1,
    wall_label: int = 2,
) -> Tuple[Optional[np.ndarray], Optional[np.ndarray]]:
    """
    Identify Lumen-Intima (inner wall) and Media-Adventitia (outer wall) interfaces.
    mask: (H, W) with labels e.g. 0=background, 1=lumen, 2=wall (intima-media).
    Returns (lumen_intima_y_per_column, media_adventitia_y_per_column) for each x.
    Assumes vessel is roughly horizontal; interfaces are top/bottom boundaries of the wall.
    """
    h, w = mask.shape
    lumen_intima = np.full(w, np.nan)   # inner boundary (lumen side)
    media_adventitia = np.full(w, np.nan)  # outer boundary (adventitia side)

    for x in range(w):
        col = mask[:, x]
        lumen_idx = np.where(col == lumen_label)[0]
        wall_idx = np.where(col == wall_label)[0]
        if len(lumen_idx) and len(wall_idx):
            # Lumen-Intima: wall pixel closest to lumen (inner edge of wall)
            lumen_center = np.mean(lumen_idx)
            wall_inner = wall_idx[np.argmin(np.abs(wall_idx - lumen_center))]
            lumen_intima[x] = float(wall_inner)
            # Media-Adventitia: wall pixel farthest from lumen (outer edge)
            wall_outer = wall_idx[np.argmax(np.abs(wall_idx - lumen_center))]
            media_adventitia[x] = float(wall_outer)
        elif len(wall_idx) >= 2:
            # Binary wall mask: inner = min, outer = max (vertical extent)
            lumen_intima[x] = float(np.min(wall_idx))
            media_adventitia[x] = float(np.max(wall_idx))

    return lumen_intima, media_adventitia


def imt_pixels_per_column(
    lumen_intima: np.ndarray,
    media_adventitia: np.ndarray,
) -> np.ndarray:
    """Average vertical distance (in pixels) between inner and outer wall per column."""
    valid = np.isfinite(lumen_intima) & np.isfinite(media_adventitia)
    thickness = np.abs(media_adventitia - lumen_intima)
    thickness[~valid] = np.nan
    return thickness


def imt_mm_from_mask(
    mask: np.ndarray,
    spacing_mm_per_pixel: float,
    lumen_label: int = 1,
    wall_label: int = 2,
) -> float:
    """
    Compute mean IMT in millimeters from segmentation mask.
    spacing_mm_per_pixel: from dataset metadata (e.g. physical spacing in mm/pixel).
    Returns mean IMT in mm, or NaN if interfaces cannot be determined.
    """
    li, ma = get_interfaces_from_mask(mask, lumen_label=lumen_label, wall_label=wall_label)
    thickness_px = imt_pixels_per_column(li, ma)
    valid = np.isfinite(thickness_px)
    if not np.any(valid):
        return np.nan
    mean_px = np.nanmean(thickness_px)
    return float(mean_px * spacing_mm_per_pixel)


def imt_mae_mm(
    pred_masks: np.ndarray,
    gt_masks: np.ndarray,
    spacing_mm_per_pixel: float,
    lumen_label: int = 1,
    wall_label: int = 2,
) -> float:
    """
    Mean Absolute Error of IMT (mm) across a batch.
    pred_masks: (N, H, W), gt_masks: (N, H, W).
    """
    n = pred_masks.shape[0]
    errors = []
    for i in range(n):
        pred_imt = imt_mm_from_mask(
            pred_masks[i], spacing_mm_per_pixel,
            lumen_label=lumen_label, wall_label=wall_label,
        )
        gt_imt = imt_mm_from_mask(
            gt_masks[i], spacing_mm_per_pixel,
            lumen_label=lumen_label, wall_label=wall_label,
        )
        if np.isfinite(pred_imt) and np.isfinite(gt_imt):
            errors.append(abs(pred_imt - gt_imt))
    return float(np.mean(errors)) if errors else np.nan
