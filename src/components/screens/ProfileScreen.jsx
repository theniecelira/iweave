import { MAROON, ORANGE, WHITE } from "../../constants/theme";
import { weaverStories } from "../../data";
import StatusBar from "../shared/StatusBar";

const stats = [
  { value: "826",  label: "Weavers"    },
  { value: "21",   label: "Barangays"  },
  { value: "875+", label: "Tourists"   },
  { value: "200+", label: "Products"   },
];

const footerLinks = [
  "Home", "Product Catalog", "Book a Tour",
  "About Us", "FAQs", "Contact Us",
];

export default function ProfileScreen() {
  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", background: "#fff" }}>
      <StatusBar />

      <div style={{ flex: 1, overflowY: "auto" }}>
        {/* ── iWeave Stories header ── */}
        <div
          style={{
            background: `linear-gradient(135deg, ${MAROON} 0%, #b03050 100%)`,
            padding: "20px 16px",
            textAlign: "center",
            position: "relative",
            overflow: "hidden",
          }}
        >
          <div style={{ position: "absolute", inset: 0, backgroundImage: "url('https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400')", backgroundSize: "cover", opacity: 0.15 }} />
          <div style={{ position: "relative", zIndex: 1 }}>
            <h2 style={{ color: WHITE, fontSize: 20, fontFamily: "'Georgia', serif", fontStyle: "italic", margin: "0 0 4px" }}>
              iWEAVE STORIES
            </h2>
            <p style={{ color: "rgba(255,255,255,0.8)", fontSize: 11, fontFamily: "sans-serif", margin: 0 }}>
              Get to know the people behind every customized product
            </p>
          </div>
        </div>

        {/* ── Weaver cards ── */}
        <div style={{ padding: "12px 16px" }}>
          {weaverStories.map((w, i) => (
            <div
              key={i}
              style={{
                background: "#f9f7ff",
                borderRadius: 12,
                padding: 12,
                marginBottom: 12,
                border: "1px solid #e0ddf0",
                display: "flex",
                gap: 12,
                alignItems: "flex-start",
              }}
            >
              <div
                style={{
                  width: 60,
                  height: 60,
                  borderRadius: "50%",
                  background: `linear-gradient(135deg, ${MAROON} 0%, #c0392b 100%)`,
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  flexShrink: 0,
                  fontSize: 26,
                }}
              >
                {i === 0 ? "👵" : "👩"}
              </div>
              <div>
                <div style={{ fontFamily: "sans-serif", fontWeight: 700, fontSize: 13, color: "#222" }}>
                  {w.name}
                </div>
                <div style={{ fontFamily: "sans-serif", fontSize: 11, color: "#777", marginBottom: 4 }}>
                  Age {w.age} · {w.years} years weaving
                </div>
                <div style={{ fontFamily: "sans-serif", fontSize: 10, color: MAROON, fontWeight: 700, marginBottom: 6 }}>
                  {w.specialty}
                </div>
                <p style={{ fontFamily: "sans-serif", fontSize: 10, color: "#555", lineHeight: 1.5, margin: "0 0 8px" }}>
                  {i === 0
                    ? "Lola Nena has been weaving banig since she was a young girl, learning from her mother and grandmother. Her intricate traditional patterns tell stories of the rich culture of Basey, Samar."
                    : "Maria learned weaving from her grandmother and has modernized traditional techniques to create contemporary bag designs that appeal to younger generations while honoring tradition."}
                </p>
                <button
                  style={{
                    background: ORANGE,
                    color: WHITE,
                    border: "none",
                    borderRadius: 4,
                    padding: "5px 12px",
                    fontSize: 10,
                    fontFamily: "sans-serif",
                    fontWeight: 700,
                    cursor: "pointer",
                  }}
                >
                  READ STORY
                </button>
              </div>
            </div>
          ))}
        </div>

        {/* ── Platform stats ── */}
        <div style={{ margin: "0 16px 16px", background: MAROON, borderRadius: 12, padding: 16 }}>
          <h3 style={{ color: WHITE, fontSize: 14, fontFamily: "'Georgia', serif", fontStyle: "italic", textAlign: "center", margin: "0 0 12px" }}>
            iWeave Impact
          </h3>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10 }}>
            {stats.map((s) => (
              <div
                key={s.label}
                style={{
                  background: "rgba(255,255,255,0.12)",
                  borderRadius: 8,
                  padding: "10px",
                  textAlign: "center",
                }}
              >
                <div style={{ color: ORANGE, fontSize: 22, fontFamily: "sans-serif", fontWeight: 900 }}>
                  {s.value}
                </div>
                <div style={{ color: "rgba(255,255,255,0.8)", fontSize: 10, fontFamily: "sans-serif" }}>
                  {s.label}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* ── Newsletter ── */}
        <div style={{ margin: "0 16px 16px", background: "#f9f7ff", borderRadius: 12, padding: 14, border: "1px solid #e0ddf0" }}>
          <h3 style={{ fontSize: 12, fontFamily: "'Georgia', serif", margin: "0 0 4px", color: MAROON }}>
            Stay Updated
          </h3>
          <p style={{ fontSize: 10, color: "#777", fontFamily: "sans-serif", margin: "0 0 10px" }}>
            Subscribe to receive news about new products, tours, and weaver stories.
          </p>
          <div style={{ display: "flex", gap: 6 }}>
            <input
              placeholder="Your email address"
              style={{ flex: 1, padding: "7px 10px", borderRadius: 4, border: "1px solid #ddd", fontSize: 11, fontFamily: "sans-serif", outline: "none" }}
            />
            <button
              style={{ background: MAROON, color: WHITE, border: "none", borderRadius: 4, padding: "7px 12px", fontSize: 11, fontFamily: "sans-serif", fontWeight: 700, cursor: "pointer" }}
            >
              Subscribe
            </button>
          </div>
        </div>

        {/* ── Footer links ── */}
        <div style={{ margin: "0 16px 8px" }}>
          <div style={{ display: "flex", flexWrap: "wrap", gap: 6 }}>
            {footerLinks.map((link) => (
              <button
                key={link}
                style={{ background: "none", border: "none", color: MAROON, fontSize: 10, fontFamily: "sans-serif", cursor: "pointer", textDecoration: "underline" }}
              >
                {link}
              </button>
            ))}
          </div>
          <div style={{ fontSize: 9, color: "#aaa", fontFamily: "sans-serif", marginTop: 8 }}>
            © 2024 iWeave · Est. 2024 · Basey, Samar, Philippines
          </div>
        </div>

        <div style={{ height: 16 }} />
      </div>
    </div>
  );
}
