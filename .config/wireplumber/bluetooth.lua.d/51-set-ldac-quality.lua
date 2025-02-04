table.insert(bluez_monitor.rules, {
  matches = {
    {
      -- This matches all cards.
      { "device.name", "matches", "bluez_card.*" },
    },
  },
  apply_properties = {
    -- LDAC encoding quality
    -- Available values: auto (Adaptive Bitrate, default)
    --                   hq   (High Quality, 990/909kbps)
    --                   sq   (Standard Quality, 660/606kbps)
    --                   mq   (Mobile use Quality, 330/303kbps)
    ["bluez5.a2dp.ldac.quality"] = "mq",
  },
})
