---@meta wezline.Attr

---@alias wezline.Attr.UnderlineEnum
---| "None"
---| "Single"
---| "Double"
---| "Curly"
---| "Dotted"
---| "Dashed"
---
---@alias wezline.Attr.IntensityEnum
---| "Normal"
---| "Bold"
---| "Half"

---@alias wezline.Attr.ItalicEnum boolean

---@alias wezline.Attr.AnsiColorEnum
---| "Black"
---| "Maroon"
---| "Green"
---| "Olive"
---| "Navy"
---| "Purple"
---| "Teal"
---| "Silver"
---| "Grey"
---| "Red"
---| "Lime"
---| "Yellow"
---| "Blue"
---| "Fuchsia"
---| "Aqua"
---| "White"

---@alias wezline.Attr.ColorEnum string

---@alias wezline.Attr.Text { Text: string}

---@alias wezline.Attr.Attribut.Underline
---| { Underline: wezline.Attr.UnderlineEnum }
---
---@alias wezline.Attr.Attribut.Intensity
---| { Intensity: wezline.Attr.IntensityEnum }
---@alias wezline.Attr.Attribut.Italic
---| { Italic: wezline.Attr.ItalicEnum }

---@alias wezline.Attr.Attributes
---| wezline.Attr.Attribut.Underline
---| wezline.Attr.Attribut.Intensity
---| wezline.Attr.Attribut.Italic

---@alias wezline.Attr.Foregroung
---| { Foregroung: wezline.Attr.AnsiColorEnum | wezline.Attr.ColorEnum }
---
---@alias wezline.Attr.Backgroung
---| { Backgroung: wezline.Attr.AnsiColorEnum | wezline.Attr.ColorEnum }
---
---@alias wezline.Attr.Colors
---| wezline.Attr.Backgroung
---| wezline.Attr.Foregroung

---@alias wezline.Attr.Reset "ResetAttributes"

---@alias wezline.Attr (wezline.Attr.Attributes | wezline.Attr.Colors | wezline.Attr.Reset)[]
