import { useState } from "react";
import { MAROON, MAROON_LIGHT, ORANGE, WHITE } from "../../constants/theme";
import { products } from "../../data";
import StatusBar from "../shared/StatusBar";
import SearchBar from "../shared/SearchBar";
import TagPill from "../shared/TagPill";

const productGrid = [
  { name: "Laptop & Tablet Cases", emoji: "💻" },
  { name: "Bags",                  emoji: "👜" },
  { name: "Slippers",              emoji: "🥿" },
  { name: "Wallets",               emoji: "👛" },
  { name: "Placemats",             emoji: "🍽️" },
  { name: "Banig Mats",            emoji: "🧺" },
];

export default function ProductsScreen({ onBack, category, onBagDetail }) {
  const [activeCat, setActiveCat] = useState(category || "Bags");

  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", background: "#fff" }}>
      <StatusBar />
      <SearchBar />

      {/* Category tabs */}
      <div style={{ padding: "8px 16px", display: "flex", gap: 8, overflowX: "auto", background: "#fff", borderBottom: "1px solid #eee" }}>
        {["Cases", "Bags", "Wallet", "Mats", "See All"].map((c) => (
          <TagPill key={c} label={c} active={activeCat === c} onClick={() => setActiveCat(c)} />
        ))}
      </div>

      <div style={{ flex: 1, overflowY: "auto" }}>
        {/* Banner */}
        <div
          style={{
            height: 110,
            background: `linear-gradient(135deg, ${MAROON} 0%, #b03050 100%)`,
            margin: "10px 16px",
            borderRadius: 12,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            position: "relative",
            overflow: "hidden",
          }}
        >
          <span style={{ fontSize: 48 }}>🧺</span>
          <div style={{ position: "absolute", bottom: 12, left: 16, color: "#fff", fontSize: 14, fontFamily: "'Georgia', serif", fontStyle: "italic", fontWeight: 700 }}>
            Weave your story, Craft your style!
          </div>
        </div>

        {/* This Week's Highlight */}
        <div style={{ padding: "0 16px 8px" }}>
          <div style={{ display: "flex", justifyContent: "space-between" }}>
            <h3 style={{ fontSize: 13, fontFamily: "sans-serif", margin: "0 0 10px" }}>This Week's Highlight!</h3>
            <button style={{ background: "none", border: "none", color: MAROON, fontSize: 11, cursor: "pointer", fontFamily: "sans-serif" }}>
              See All
            </button>
          </div>
          <div style={{ display: "flex", gap: 12, overflowX: "auto" }}>
            {products.map((p) => (
              <button
                key={p.id}
                onClick={() => onBagDetail(p)}
                style={{ flexShrink: 0, width: 100, background: "none", border: "none", cursor: "pointer", textAlign: "center" }}
              >
                <div
                  style={{
                    width: 90, height: 90, borderRadius: "50%",
                    background: `linear-gradient(135deg, ${MAROON}40, ${MAROON}90)`,
                    margin: "0 auto",
                    display: "flex", alignItems: "center", justifyContent: "center",
                    position: "relative",
                  }}
                >
                  <span style={{ fontSize: 36 }}>👜</span>
                  <div style={{ position: "absolute", top: 4, right: 4, background: "#fff", borderRadius: "50%", width: 18, height: 18, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 10 }}>♡</div>
                </div>
                <div style={{ display: "flex", gap: 3, justifyContent: "center", margin: "4px 0" }}>
                  {p.colors.map((c, i) => (
                    <div key={i} style={{ width: 8, height: 8, borderRadius: "50%", background: c }} />
                  ))}
                </div>
                <div style={{ fontSize: 10, fontFamily: "sans-serif", fontWeight: 700 }}>{p.name}</div>
                <div style={{ fontSize: 10, fontFamily: "sans-serif", color: "#777" }}>{p.price}</div>
              </button>
            ))}
          </div>
        </div>

        {/* New Collections heading */}
        <div style={{ padding: "0 16px 8px" }}>
          <h3 style={{ fontSize: 13, fontFamily: "sans-serif", margin: "0 0 8px" }}>New Collections!</h3>
        </div>

        {/* Product grid */}
        <div style={{ padding: "0 16px", display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12 }}>
          {productGrid.map((item) => (
            <button
              key={item.name}
              onClick={() => onBagDetail({ name: item.name })}
              style={{ background: "#f9f7ff", border: "1px solid #e0ddf0", borderRadius: 12, cursor: "pointer", overflow: "hidden", textAlign: "center" }}
            >
              <div style={{ height: 90, background: `linear-gradient(135deg, ${MAROON}20, ${MAROON}50)`, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 36 }}>
                {item.emoji}
              </div>
              <div style={{ padding: "8px", fontFamily: "sans-serif", fontSize: 11, fontWeight: 700, color: "#333" }}>
                {item.name}
              </div>
            </button>
          ))}
        </div>
        <div style={{ height: 20 }} />
      </div>
    </div>
  );
}
