import { MAROON, MAROON_DARK, MAROON_LIGHT, ORANGE, WHITE } from "../../constants/theme";
import { tourPackages, products } from "../../data";
import StatusBar from "../shared/StatusBar";
import SearchBar from "../shared/SearchBar";
import StarRating from "../shared/StarRating";

const collectionItems = [
  { name: "Laptop & Tablet Cases", emoji: "💻" },
  { name: "Bags",                  emoji: "👜" },
  { name: "Slippers",              emoji: "🥿" },
  { name: "Wallets",               emoji: "👛" },
];

export default function HomeScreen({ onNav, onProduct, onTourDetail }) {
  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", background: WHITE }}>
      <StatusBar />
      <SearchBar />

      <div style={{ flex: 1, overflowY: "auto" }}>
        {/* ── Hero Banner ── */}
        <div
          style={{
            background: `linear-gradient(135deg, ${MAROON} 0%, ${MAROON_DARK} 100%)`,
            padding: "20px 16px",
            position: "relative",
            overflow: "hidden",
          }}
        >
          <div
            style={{
              position: "absolute",
              inset: 0,
              backgroundImage:
                "url('https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400')",
              backgroundSize: "cover",
              opacity: 0.2,
            }}
          />
          <div style={{ position: "relative", zIndex: 1 }}>
            <div
              style={{
                display: "inline-block",
                background: ORANGE,
                color: WHITE,
                fontSize: 9,
                fontFamily: "sans-serif",
                fontWeight: 700,
                padding: "2px 8px",
                borderRadius: 4,
                marginBottom: 6,
              }}
            >
              IWEAVE COLLECTION
            </div>
            <h2 style={{ color: WHITE, fontSize: 22, fontFamily: "'Georgia', serif", margin: "0 0 4px" }}>
              BASEY, SAMAR
            </h2>
            <p style={{ color: "rgba(255,255,255,0.8)", fontSize: 11, fontFamily: "sans-serif", margin: 0 }}>
              Discover authentic tikog weaving traditions
            </p>
          </div>
        </div>

        {/* ── Cultural Tapestry Card ── */}
        <div
          style={{
            margin: "12px 16px",
            background: "#fafafa",
            borderRadius: 12,
            padding: 12,
            border: "1px solid #eee",
            display: "flex",
            gap: 12,
          }}
        >
          <div
            style={{
              width: 90,
              height: 90,
              borderRadius: 8,
              background: `linear-gradient(135deg, ${MAROON} 0%, #c0392b 100%)`,
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              flexShrink: 0,
              fontSize: 36,
            }}
          >
            🧺
          </div>
          <div>
            <h3 style={{ fontSize: 13, fontFamily: "'Georgia', serif", margin: "0 0 4px", color: MAROON, fontWeight: 700 }}>
              Basey's Cultural Tapestry
            </h3>
            <p style={{ fontSize: 10, color: "#555", fontFamily: "sans-serif", margin: "0 0 8px", lineHeight: 1.5 }}>
              Renowned for its centuries-old tradition of banig weaving, Basey
              is home to skilled artisans who meticulously craft intricate mats
              and textiles using natural tikog grass fibers.
            </p>
            <button
              onClick={() => onNav("tour")}
              style={{
                background: MAROON, color: WHITE, border: "none",
                borderRadius: 4, padding: "5px 12px", fontSize: 10,
                fontFamily: "sans-serif", fontWeight: 700, cursor: "pointer",
              }}
            >
              LEARN MORE
            </button>
          </div>
        </div>

        {/* ── Customized Collections ── */}
        <div style={{ padding: "0 16px 8px" }}>
          <h3 style={{ fontSize: 14, fontFamily: "'Georgia', serif", color: MAROON, fontStyle: "italic", fontWeight: 700, margin: "8px 0 2px" }}>
            Our Customized Collections
          </h3>
          <p style={{ fontSize: 10, color: "#777", fontFamily: "sans-serif", margin: "0 0 10px" }}>
            Customize your own banig products or select from these pre-designed items.
          </p>
          <div style={{ display: "flex", gap: 10, overflowX: "auto", paddingBottom: 4 }}>
            {collectionItems.map((c) => (
              <button
                key={c.name}
                onClick={() => onProduct(c.name)}
                style={{
                  flexShrink: 0,
                  background: `linear-gradient(135deg, ${MAROON} 0%, ${MAROON_LIGHT} 100%)`,
                  border: "none", borderRadius: 10,
                  padding: "14px 12px", cursor: "pointer",
                  textAlign: "center", minWidth: 80,
                }}
              >
                <div style={{ fontSize: 24 }}>{c.emoji}</div>
                <div style={{ color: WHITE, fontSize: 9, fontFamily: "sans-serif", fontWeight: 700, marginTop: 4, lineHeight: 1.2 }}>
                  {c.name}
                </div>
              </button>
            ))}
          </div>
        </div>

        {/* ── This Week's Highlights ── */}
        <div style={{ padding: "8px 16px" }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 8 }}>
            <h3 style={{ fontSize: 13, fontFamily: "'Georgia', serif", margin: 0 }}>This Week's Highlight!</h3>
            <button style={{ background: "none", border: "none", color: MAROON, fontSize: 11, cursor: "pointer", fontFamily: "sans-serif" }}>
              See All
            </button>
          </div>
          <div style={{ display: "flex", gap: 10, overflowX: "auto" }}>
            {products.map((p) => (
              <button
                key={p.id}
                onClick={() => onProduct("Bags")}
                style={{ flexShrink: 0, width: 100, background: "none", border: "none", cursor: "pointer", textAlign: "center" }}
              >
                <div
                  style={{
                    width: 90, height: 90, borderRadius: "50%",
                    background: `linear-gradient(135deg, ${MAROON}30, ${MAROON}80)`,
                    margin: "0 auto",
                    display: "flex", alignItems: "center", justifyContent: "center",
                    position: "relative", overflow: "hidden",
                  }}
                >
                  <span style={{ fontSize: 36 }}>👜</span>
                  <div style={{ position: "absolute", top: 4, right: 4, background: WHITE, borderRadius: "50%", width: 18, height: 18, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 10 }}>♡</div>
                </div>
                <div style={{ display: "flex", gap: 3, justifyContent: "center", margin: "4px 0" }}>
                  {p.colors.map((c, i) => (
                    <div key={i} style={{ width: 8, height: 8, borderRadius: "50%", background: c }} />
                  ))}
                </div>
                <div style={{ fontSize: 10, fontFamily: "sans-serif", fontWeight: 700, color: "#333" }}>{p.name}</div>
                <div style={{ fontSize: 10, fontFamily: "sans-serif", color: "#555" }}>{p.price}</div>
              </button>
            ))}
          </div>
        </div>

        {/* ── Banig Weaving Experience ── */}
        <div style={{ margin: "8px 16px", background: "#f9f7ff", borderRadius: 12, overflow: "hidden" }}>
          <div style={{ background: MAROON, padding: "8px 12px", textAlign: "center" }}>
            <span style={{ color: WHITE, fontSize: 12, fontFamily: "'Georgia', serif", fontWeight: 700, fontStyle: "italic" }}>
              Banig Weaving Experience
            </span>
          </div>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 2, margin: 8 }}>
            {["🧺", "🌿", "🎨", "🏕️"].map((e, i) => (
              <div key={i} style={{ height: 55, background: `hsl(${i * 40 + 10}, 40%, ${35 + i * 5}%)`, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 22, borderRadius: 4 }}>
                {e}
              </div>
            ))}
          </div>
          <div style={{ padding: "4px 12px 8px" }}>
            <p style={{ fontSize: 10, color: "#555", fontFamily: "sans-serif", lineHeight: 1.5, margin: "0 0 8px" }}>
              Banig weaving is a cherished tradition in Basey, Samar. Tourists
              can participate in hands-on workshops to create their own
              personalized banig.
            </p>
            <button
              onClick={() => onNav("tour")}
              style={{ background: ORANGE, color: WHITE, border: "none", borderRadius: 4, padding: "7px 12px", fontSize: 10, fontFamily: "sans-serif", fontWeight: 700, cursor: "pointer", width: "100%" }}
            >
              BOOK YOUR BANIG WEAVING TOUR
            </button>
          </div>

          {/* Tour previews */}
          <div style={{ padding: "8px 12px 4px", borderTop: "1px solid #eee" }}>
            <div style={{ fontFamily: "'Georgia', serif", fontSize: 12, color: MAROON, fontStyle: "italic", fontWeight: 700, marginBottom: 6 }}>
              Explore more in Basey
            </div>
            <div style={{ display: "flex", gap: 8, overflowX: "auto" }}>
              {tourPackages.slice(0, 3).map((t) => (
                <button
                  key={t.id}
                  onClick={() => onTourDetail(t)}
                  style={{ flexShrink: 0, width: 120, background: "none", border: "1px solid #ddd", borderRadius: 8, overflow: "hidden", cursor: "pointer", textAlign: "left" }}
                >
                  <div style={{ height: 55, background: t.color, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 22 }}>
                    {t.img}
                  </div>
                  <div style={{ padding: "4px 6px" }}>
                    <div style={{ fontSize: 9, fontFamily: "sans-serif", fontWeight: 700, color: "#222", lineHeight: 1.3 }}>
                      {t.name.substring(0, 35)}...
                    </div>
                    <div style={{ display: "flex", alignItems: "center", gap: 2, marginTop: 2 }}>
                      <StarRating rating={t.rating} size={9} />
                      <span style={{ fontSize: 9, color: "#777", fontFamily: "sans-serif" }}>{t.reviews}</span>
                    </div>
                    <div style={{ fontSize: 10, color: MAROON, fontFamily: "sans-serif", fontWeight: 700 }}>{t.price}</div>
                  </div>
                </button>
              ))}
            </div>
          </div>
          <div style={{ padding: "6px 12px 10px" }}>
            <button
              onClick={() => onNav("tour")}
              style={{ background: "none", border: `1px solid ${ORANGE}`, color: ORANGE, borderRadius: 4, padding: "6px 12px", fontSize: 10, fontFamily: "sans-serif", fontWeight: 700, cursor: "pointer", width: "100%" }}
            >
              PLAN YOUR TRIP
            </button>
          </div>
        </div>

        {/* ── iWeave Stories Banner ── */}
        <div style={{ margin: "0 16px 16px", background: MAROON, borderRadius: 12, padding: "16px", textAlign: "center", position: "relative", overflow: "hidden" }}>
          <div style={{ position: "absolute", inset: 0, backgroundImage: "url('https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400')", backgroundSize: "cover", opacity: 0.15 }} />
          <div style={{ position: "relative", zIndex: 1 }}>
            <h3 style={{ color: WHITE, fontSize: 16, fontFamily: "'Georgia', serif", fontStyle: "italic", margin: "0 0 4px" }}>
              iWEAVE STORIES
            </h3>
            <p style={{ color: "rgba(255,255,255,0.8)", fontSize: 11, fontFamily: "sans-serif", margin: "0 0 10px" }}>
              Get to know the people behind every customized product
            </p>
            <button style={{ background: ORANGE, color: WHITE, border: "none", borderRadius: 4, padding: "8px 20px", fontSize: 11, fontFamily: "sans-serif", fontWeight: 700, cursor: "pointer" }}>
              READ MORE
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
