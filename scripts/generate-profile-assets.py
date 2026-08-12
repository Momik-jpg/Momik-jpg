from pathlib import Path
import sys

from PIL import Image, ImageDraw, ImageEnhance, ImageFont


WIDTH, HEIGHT = 2400, 600
BLUE = (88, 166, 255)
FONT_REGULAR = Path(r"C:\Windows\Fonts\segoeui.ttf")
FONT_BOLD = Path(r"C:\Windows\Fonts\segoeuib.ttf")


def cover_crop(image: Image.Image, size: tuple[int, int]) -> Image.Image:
    target_ratio = size[0] / size[1]
    source_ratio = image.width / image.height
    if source_ratio > target_ratio:
        crop_width = int(image.height * target_ratio)
        left = (image.width - crop_width) // 2
        box = (left, 0, left + crop_width, image.height)
    else:
        crop_height = int(image.width / target_ratio)
        top = int((image.height - crop_height) * 0.62)
        top = max(0, min(top, image.height - crop_height))
        box = (0, top, image.width, top + crop_height)
    return image.crop(box).resize(size, Image.Resampling.LANCZOS)


def draw_header(source: Image.Image, output: Path, dark: bool) -> None:
    base = cover_crop(source, (WIDTH, HEIGHT)).convert("RGB")
    base = ImageEnhance.Contrast(base).enhance(1.06)
    base = ImageEnhance.Color(base).enhance(0.88 if dark else 0.96)
    if dark:
        base = ImageEnhance.Brightness(base).enhance(0.72)

    overlay = Image.new("RGBA", base.size, (0, 0, 0, 0))
    overlay_pixels = overlay.load()
    for x in range(WIDTH):
        position = x / WIDTH
        if position < 0.18:
            alpha = 24 if dark else 10
        else:
            progress = (position - 0.18) / 0.82
            alpha = int((24 if dark else 10) + (progress ** 0.5) * (214 if dark else 216))
        for y in range(HEIGHT):
            overlay_pixels[x, y] = (5, 10, 17, alpha)
    base = Image.alpha_composite(base.convert("RGBA"), overlay)

    draw = ImageDraw.Draw(base)
    name_font = ImageFont.truetype(str(FONT_BOLD), 112)
    role_font = ImageFont.truetype(str(FONT_REGULAR), 44)
    stack_font = ImageFont.truetype(str(FONT_REGULAR), 31)
    text_x = 1300
    draw.rounded_rectangle((text_x, 104, text_x + 84, 114), radius=5, fill=BLUE)
    draw.text((text_x, 152), "Andrin Maag", font=name_font, fill=(248, 250, 252))
    draw.text(
        (text_x + 3, 302),
        "IMS Student  ·  Software Developer",
        font=role_font,
        fill=(220, 226, 234),
    )
    draw.text(
        (text_x + 3, 394),
        "C#  ·  Kotlin  ·  Android  ·  Python",
        font=stack_font,
        fill=(133, 213, 255),
    )
    draw.rounded_rectangle((text_x + 3, 470, text_x + 258, 476), radius=3, fill=BLUE)
    base.convert("RGB").save(output, "PNG", optimize=True)


def draw_focus_animation(output: Path) -> None:
    width, height = 1600, 96
    background = (13, 17, 23)
    font = ImageFont.truetype(str(FONT_REGULAR), 34)
    messages = (
        "Building clear, practical software.",
        "C#  ·  Kotlin  ·  Android  ·  Python",
    )
    frames: list[Image.Image] = []
    durations: list[int] = []
    for message in messages:
        for opacity in (255, 220, 180, 140, 100, 60, 100, 140, 180, 220, 255):
            frame = Image.new("RGB", (width, height), background)
            draw = ImageDraw.Draw(frame)
            box = draw.textbbox((0, 0), message, font=font)
            text_width = box[2] - box[0]
            x = (width - text_width) // 2
            colour = tuple(int(background[i] + (target - background[i]) * opacity / 255) for i, target in enumerate((184, 213, 255)))
            draw.text((x, 25), message, font=font, fill=colour)
            frames.append(frame)
            durations.append(85)
        durations[0 if len(frames) == 11 else len(frames) - 11] = 1800
        durations[-1] = 1800
    frames[0].save(
        output,
        save_all=True,
        append_images=frames[1:],
        duration=durations,
        loop=0,
        optimize=True,
        disposal=2,
    )


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit("Usage: generate-profile-assets.py SOURCE_IMAGE OUTPUT_DIRECTORY")
    source_path = Path(sys.argv[1])
    output_dir = Path(sys.argv[2])
    output_dir.mkdir(parents=True, exist_ok=True)
    source = Image.open(source_path)
    draw_header(source, output_dir / "profile-header-workspace-light.png", dark=False)
    draw_header(source, output_dir / "profile-header-workspace-hq.png", dark=True)
    draw_focus_animation(output_dir / "profile-focus.gif")


if __name__ == "__main__":
    main()
