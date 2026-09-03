-- 设备型号 → 显示名映射 / 云脚本热更新
-- 用途：提取 Token 时若日志缺失设备名，用此表回退识别显示名。
-- 新机型只需在此追加一条，随后把 cloudscripts/ 同步到云端源即可热更新，
-- 无需重新打包安装 APK。
return {
  version = "1.0",
  models = {
    { "miwear.watch.p65", "REDMI Watch 6" },
    { "miwear.watch.m67", "Xiaomi Watch S4" },
    { "miwear.watch.n67", "Xiaomi Watch S4 Sport" },
    { "zhizao.watch.n67", "Xiaomi Watch S4 Sport" },
    { "miwear.watch.l62", "Redmi Watch 4" },
    { "miwear.watch.m62", "Xiaomi Watch S3" },
    { "miwear.watch.n62", "Xiaomi Watch S3" }
  }
}