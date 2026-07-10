import { Controller } from "@hotwired/stimulus";

const MAX_FILE_SIZE_MB = 5;

export default class extends Controller {
  static targets = [
    "uploadedImage",
    "originalImage",
    "downloadLink",
    "existingIcon",
    "originalImageFrame",
  ];
  static outlets = ["preview", "canvas"];

  connect() {
    if (this.hasExistingIconTarget)
      this.setup({ existingIcon: this.existingIconTarget });
  }

  upload() {
    const uploadFile = this.uploadedImageTarget.files[0];
    if (!this.validateFile(uploadFile)) {
      alert(`${this.errorMessage}`);
      throw new Error(this.errorMessage);
    }

    this.setup({ uploadFile });
  }

  setup({ uploadFile, existingIcon }) {
    this.originalImageUrl = this.setupOriginalImageUrl(
      uploadFile,
      existingIcon,
    );
    const originalImage = this.originalImageTarget;
    originalImage.src = this.originalImageUrl;

    const originalImageFrame =
      this.originalImageFrameTarget.getBoundingClientRect();
    originalImage.width = originalImageFrame.width - 20;
    originalImage.height = originalImageFrame.height - 20;

    originalImage.style.display = "inline";

    originalImage.onload = () => {
      this.dispatch("setup", { detail: { originalImage } });
    };
  }

  setupOriginalImageUrl(uploadFile, existingIcon) {
    if (uploadFile) return URL.createObjectURL(uploadFile);

    if (existingIcon) return existingIcon.dataset.imageUrl;
  }

  validateFile(file) {
    this.errorMessage = null;
    const allowedExtensions = [".jpg", ".jpeg", ".png", ".webp"];
    const fileExtension = file.name.split(".").pop().toLowerCase();

    if (fileExtension === "heic" || fileExtension === "heif") {
      this.errorMessage =
        "HEIC / HEIF形式の画像には現在対応していません。\nJPG、JPEG、PNG、WebPなどに変換してからアップロードをお願いします。";
      return false;
    }

    if (
      !file.type.startsWith("image/") ||
      !allowedExtensions.includes(`.${fileExtension}`)
    ) {
      this.errorMessage = `"${file.name}" は画像ではありません。画像ファイルのみアップロードできます。`;
      return false;
    }

    if (!validateByteSize(file)) {
      this.errorMessage = `画像は${MAX_FILE_SIZE_MB}MB以下にしてください`;
      return false;
    }

    return true;
  }

  download(e) {
    if (this.downloadLinkTarget.classList.contains("is-disabled")) return;

    disableLink(this.downloadLinkTarget);
    const selectedText = this.canvasOutlet.selectedText;
    const previewImageUrl = this.previewOutlet.previewImageUrl;
    const combinedIconName = `${selectedText}のアイコン.webp`;
    e.currentTarget.href = previewImageUrl;
    e.currentTarget.download = combinedIconName;

    this.triggerSubmit(combinedIconName);

    setTimeout(() => {
      enableLink(this.downloadLinkTarget);
    }, 3000);
    setTimeout(() => {
      URL.revokeObjectURL(this.originalImageUrl);
      URL.revokeObjectURL(previewImageUrl);
    }, 3000);
  }

  async triggerSubmit(combinedIconName) {
    const params = {};
    const uploadedFile = this.uploadedImageTarget.files?.[0];
    if (uploadedFile) {
      params.originalIconFile = uploadedFile;
    } else if (this.hasExistingIconTarget) {
      params.originalIconId = this.existingIconTarget.dataset.id;
    }
    params.combinedIconFile = this.canvasOutlet.canvasBlob;
    params.combinedIconName = combinedIconName;
    params.renderPlan = this.canvasOutlet.renderPlan;

    this.dispatch("download", {
      detail: { params },
    });
  }

  // dispatchでのみ呼ばれる
  enableDownload() {
    enableLink(this.downloadLinkTarget);
  }
}

function enableLink(link) {
  link.classList.remove("is-disabled");
  link.setAttribute("aria-disabled", "false");
}

function disableLink(link) {
  link.classList.add("is-disabled");
  link.setAttribute("aria-disabled", "true");
}

function validateByteSize(file) {
  const limitSizeMB = MAX_FILE_SIZE_MB * 1024 * 1024;
  return file.size < limitSizeMB;
}
