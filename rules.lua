-- 表盘文件解析规则 / 云脚本热更新
-- 用途：Magic 校验值、ID/名称字段偏移与尺寸、合法 ID 位数。
-- 若小米调整表盘格式，更新此文件推送到云端即可热更新，无需发版。
return {
  version = "1.0",

  -- Magic 校验值（little-endian）
  magic = 0x1234A55A,
  magicOffset = 0x00,

  -- ID 字段
  idOffset = 0x28,
  idFieldSize = 64,
  -- 合法 ID 位数（可热更：如未来出现 10/13 位 ID）
  validLengths = { 9, 12 },

  -- 名称字段
  nameOffset = 0x68,
  nameFieldSize = 64
}