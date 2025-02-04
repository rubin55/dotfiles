table.insert(bluez_monitor.rules, {
  matches = {
    {
      -- This matches all cards.
      { "device.name", "matches", "bluez_card.*" },
    },
  },
  apply_properties = {
    -- AAC variable bitrate mode
    -- Available values: 0 (cbr, default), 1-5 (quality level)
    ["bluez5.a2dp.aac.bitratemode"] = 1,
  },
})
