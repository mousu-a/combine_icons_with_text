// @ts-check
import { expect, test } from "@playwright/test";
import path from "node:path";

const SAMPLE_ICON_PATH = path.join(
  process.cwd(),
  "app",
  "assets",
  "images",
  "cat-avatar-sample.webp",
);

async function uploadIcon(page) {
  await page.getByLabel("アイコンを選択").setInputFiles(SAMPLE_ICON_PATH);

  const previewImage = page.getByRole("img", {
    name: "テキストを合成したアイコンのプレビュー画像",
  });

  return previewImage;
}

test.describe("icons#new", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("/icons/new");
  });

  test("uploading an image shows the image in the preview", async ({ page }) => {
    const previewImage = await uploadIcon(page);

    await expect(previewImage).toBeVisible();
  });

  test("dropping an image onto the drop zone shows the image in the preview", async ({ page, }) => {
    await page
      .locator('[data-ui-state-target="dropZone"]')
      .drop({ files: SAMPLE_ICON_PATH });

    const previewImage = page.getByRole("img", {
      name: "テキストを合成したアイコンのプレビュー画像",
    });

    await expect(previewImage).toBeVisible();
    await expect(page.locator('output[for="upload-icon"]')).toHaveText(
      path.basename(SAMPLE_ICON_PATH),
    );
  });

  test("can add text to the preview", async ({ page }) => {
    const previewImage = await uploadIcon(page);

    await page.getByRole("button", { name: "ラジオ参加" }).click();

    await expect(previewImage).toHaveScreenshot("text-added-preview.png");
  });

  test("can add a background to the preview", async ({ page }) => {
    const previewImage = await uploadIcon(page);

    await page.getByLabel("文字に背景をつける").check();

    await expect(previewImage).toHaveScreenshot("background-added-preview.png");
  });

  test("can change the preview text color", async ({ page }) => {
    const previewImage = await uploadIcon(page);
    await page.getByRole("button", { name: "ラジオ参加" }).click();
    await page.getByLabel("文字色").fill("#ff0000");

    await expect(previewImage).toHaveScreenshot(
      "text-color-changed-preview.png",
    );
  });

  test("can change the preview background color", async ({ page }) => {
    const previewImage = await uploadIcon(page);
    await page.getByLabel("文字に背景をつける").check();
    await page.getByLabel("背景色").fill("#00ff00");

    await expect(previewImage).toHaveScreenshot(
      "background-color-changed-preview.png",
    );
  });

  test("can change the preview opacity", async ({ page }) => {
    const previewImage = await uploadIcon(page);
    await page.getByLabel("文字に背景をつける").check();
    await page.getByRole("slider", { name: /透明度/ }).fill("0.3");

    await expect(previewImage).toHaveScreenshot("opacity-changed-preview.png");
  });

  test("can apply a preset to the preview", async ({ page }) => {
    const previewImage = await uploadIcon(page);
    await page
      .locator('[data-presets-renderer-target="presetCanvas"]')
      .first()
      .click();

    await expect(previewImage).toHaveScreenshot("preset-applied-preview.png");
  });

  test("can download the preview", async ({ page }) => {
    await uploadIcon(page);
    await page.getByRole("button", { name: "ラジオ参加" }).click();

    const downloadPromise = page.waitForEvent("download");
    await page.getByRole("link", { name: "画像をダウンロード" }).click();
    const download = await downloadPromise;

    expect(download.suggestedFilename()).toBe("ラジオ参加のアイコン.webp");
  });
});
