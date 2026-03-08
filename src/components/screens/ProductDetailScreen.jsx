import { useState } from "react";
import { MAROON, ORANGE, WHITE } from "../../constants/theme";
import StatusBar from "../shared/StatusBar";

const COLORS  = ["#FF6B00", "#4CAF50", "#9C27B0", "#E53935"];
const DESIGNS = ["🌺", "🔷", "🌿", "⬆"];
const OCCASIONS = ["Christmas", "Birthday", "Anniversary", "Graduation"];

export default function ProductDetailScreen({ onBack, product }) {
  const [selectedColor,  setSelectedColor]  = useState(0);
  const [selectedDesign, setSelectedDesign] = useState(0);
  const [giftWrap,       setGiftWrap]       = useState(true);
  const [packageOpt,     setPackageOpt]     = useState("Birthday");

  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", background: "#fff" }}>
      <StatusBar />

      {/* Header */}
      <div style={{ background: MAROON, padding: "8px 16px 10px", display: "flex", alignItems: "center", gap: 10 }}>
        <button onClick={onBack} style={{ background: "none", border: "none", color: WHITE, fontSize: 18, cursor: "pointer" }}>‹</button>
        <div style={{ flex: 1 }} />
        <span style={{ color: WHITE, fontSize: 18 }}>🛒</span>
      </div>

      <div style={{ flex: 1, overflowY: "auto" }}>
        {/* Product image area */}
        <div
          style={{
            height: 200,
            background: "linear-gradient(135deg, #2a8a6a, #7A153090)",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            position: "relative",
          }}
        >
          <span style={{ fontSize: 80 }}>👜</span>
          <div style={{ position: "absolute", top: 8, right: 8, color: WHITE, fontSize: 11, fontFamily: "sans-serif", background: "rgba(0,0,0,0.4)", padding: "2px 6px", borderRadius: 4 }}>
            360°
          </div>
          {/* Thumbnail strip */}
          <div style={{ position: "absolute", bottom: 8, left: 0, right: 0, display: "flex", gap: 6, justifyContent: "center" }}>
            {[0, 1, 2].map((i) => (
              <div
                key={i}
                style={{
                  width: 55, height: 55,
                  background: `hsl(${i * 40 + 10}, 50%, 35%)`,
                  borderRadius: 6,
                  display: "flex", alignItems: "center", justifyContent: "center",
                  fontSize: 20,
                  border: `2px solid ${i === 0 ? WHITE : "transparent"}`,
                }}
              >
                🧺
              </div>
            ))}
          </div>
        </div>

        <div style={{ padding: "12px 16px" }}>
          <div style={{ color: MAROON, fontSize: 16, fontFamily: "sans-serif", fontWeight: 700, marginBottom: 2 }}>₱2,499.00</div>
          <div style={{ fontSize: 13, fontFamily: "sans-serif", fontWeight: 700, color: "#222", marginBottom: 10 }}>Tote Bag with wood handle</div>

          {/* Material */}
          <div style={{ fontSize: 12, fontFamily: "sans-serif", color: "#444", marginBottom: 4 }}>Material:</div>
          <div style={{ display: "inline-block", background: "#f0f0f0", borderRadius: 4, padding: "3px 10px", fontSize: 11, fontFamily: "sans-serif", marginBottom: 12 }}>Tikog</div>

          {/* Color picker */}
          <div style={{ fontSize: 12, fontFamily: "sans-serif", color: "#444", marginBottom: 8 }}>Preferred color: Green ▾</div>
          <div style={{ display: "flex", gap: 8, marginBottom: 16 }}>
            {COLORS.map((c, i) => (
              <button
                key={i}
                onClick={() => setSelectedColor(i)}
                style={{ width: 36, height: 36, borderRadius: "50%", background: c, border: selectedColor === i ? "3px solid #333" : "2px solid transparent", cursor: "pointer" }}
              />
            ))}
          </div>

          {/* Design picker */}
          <div style={{ fontSize: 12, fontFamily: "sans-serif", color: "#444", marginBottom: 8 }}>Preferred design:</div>
          <div style={{ display: "flex", gap: 8, marginBottom: 16 }}>
            {DESIGNS.map((d, i) => (
              <button
                key={i}
                onClick={() => setSelectedDesign(i)}
                style={{
                  width: 44, height: 44, borderRadius: 8,
                  background: selectedDesign === i ? MAROON : "#f0f0f0",
                  display: "flex", alignItems: "center", justifyContent: "center",
                  fontSize: i < 3 ? 18 : 8,
                  color: selectedDesign === i ? WHITE : "#777",
                  cursor: "pointer", border: "none",
                }}
              >
                {i < 3 ? d : "UPLOAD OWN"}
              </button>
            ))}
          </div>

          {/* Gift wrap */}
          <div style={{ background: "#f9f7ff", borderRadius: 8, padding: 10, marginBottom: 12 }}>
            <label style={{ display: "flex", alignItems: "center", gap: 8, cursor: "pointer", fontFamily: "sans-serif", fontSize: 12 }}>
              <input type="checkbox" checked={giftWrap} onChange={(e) => setGiftWrap(e.target.checked)} />
              <span>🎁 Gift wrap this item?</span>
              <span style={{ color: "#777", fontSize: 10 }}>Regular wrapping paper: ₱25.00</span>
            </label>
            {giftWrap && (
              <div style={{ marginTop: 8, display: "grid", gridTemplateColumns: "1fr 1fr", gap: 8 }}>
                <input placeholder="Name of Receiver..." style={{ padding: "6px 10px", borderRadius: 4, border: "1px solid #ddd", fontSize: 11, fontFamily: "sans-serif" }} />
                <input placeholder="Name of Sender..."   style={{ padding: "6px 10px", borderRadius: 4, border: "1px solid #ddd", fontSize: 11, fontFamily: "sans-serif" }} />
                <textarea
                  placeholder="Write a message..."
                  style={{ gridColumn: "1/-1", padding: "6px 10px", borderRadius: 4, border: "1px solid #ddd", fontSize: 11, fontFamily: "sans-serif", resize: "none", height: 50 }}
                />
              </div>
            )}
          </div>

          {/* Package options */}
          <div style={{ marginBottom: 16 }}>
            <label style={{ display: "flex", alignItems: "center", gap: 8, cursor: "pointer", fontFamily: "sans-serif", fontSize: 12, marginBottom: 6 }}>
              <input type="checkbox" defaultChecked />
              <span>✓ Would you like to explore our special package options?</span>
            </label>
            <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
              {OCCASIONS.map((opt) => (
                <label key={opt} style={{ display: "flex", alignItems: "center", gap: 4, fontSize: 11, fontFamily: "sans-serif", cursor: "pointer" }}>
                  <input type="checkbox" checked={packageOpt === opt} onChange={() => setPackageOpt(opt)} />
                  {opt}
                </label>
              ))}
            </div>
          </div>

          <button
            style={{ width: "100%", background: MAROON, color: WHITE, border: "none", borderRadius: 8, padding: "14px", fontSize: 14, fontFamily: "sans-serif", fontWeight: 700, cursor: "pointer" }}
          >
            ADD TO CART — ₱2,499.00
          </button>
        </div>
      </div>
    </div>
  );
}
