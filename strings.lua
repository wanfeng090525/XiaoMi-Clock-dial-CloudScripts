-- 云端文案表 / 云脚本热更新
-- 用途：让部分界面文案可随脚本热更新（不重装 APK）。
-- key 与 Kotlin 侧约定一致，App 读取时若命中则用脚本文案覆盖内置默认。
return {
  version = "1.0",
  strings = {
    { "nav_home", "主页" },
    { "nav_modify", "修改" },
    { "nav_history", "记录" },
    { "about_title", "表盘 ID 工具" },
    { "about_subtitle", "WATCHFACE ID TOOL" },
    { "update_title", "检查更新" }
  }
}