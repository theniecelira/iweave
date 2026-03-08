import { MAROON, ORANGE, WHITE } from "../../constants/theme";
import { tourPackages } from "../../data";
import StatusBar from "../shared/StatusBar";
import StarRating from "../shared/StarRating";

const HIGHLIGHTS = [
  "Discover the stunning underground formations of Saob Cave.",
  "Learn the traditional craft from skilled local weavers, creating your own unique piece to take home as a souvenir.",
  "Connect with the artisans, learn about their techniques, and appreciate the rich history behind banig weaving.",
  "Enjoy stress-free round-trip private transfers from your hotel in Basey.",
];

export default function TourDetailScreen({ onBack, tour, onItinerary }) {
  const t = tour || tourPackages[0];

  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", background: "#fff" }}>
      <StatusBar />

      {/* Header */}
      <div style={{ background: MAROON, padding: "8px 16px 10px", display: "flex", alignItems: "center", gap: 10 }}>
        <button onClick={onBack} style={{ background: "none", border: "none", color: WHITE, fontSize: 18, cursor: "pointer" }}>‹</button>
        <div style={{ flex: 1 }} />
        <span style={{ color: WHITE, fontSize: 16 }}>📤 💾</span>
      </div>

      <div style={{ flex: 1, overflowY: "auto" }}>
        {/* Hero */}
        <div style={{ height: 180, background: t.color, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 64 }}>
          {t.img}
        </div>

        {/* Thumbnail strip */}
        <div style={{ padding: "8px 16px", display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 4 }}>
          {["🏕️", "🌿", "🧺"].map((e, i) => (
            <div key={i} style={{ height: 55, background: `hsl(${i * 40 + 100}, 40%, 30%)`, borderRadius: 6, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 20 }}>
              {e}
            </div>
          ))}
        </div>

        <div style={{ padding: "0 16px 16px" }}>
          {/* Meta */}
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 6, marginBottom: 10, fontSize: 10, fontFamily: "sans-serif", color: "#555", background: "#f9f7ff", borderRadius: 8, padding: 10 }}>
            <div>⏰ Starting time: At 9:00 A.M.</div>
            <div>📅 Duration: 3 days</div>
            <div>🌐 Languages: English, Filipino, Waray</div>
            <div>🚐 Pickup offered</div>
          </div>

          {/* Rating bar */}
          <div style={{ display: "flex", gap: 8, marginBottom: 10, background: "#f0f0f0", borderRadius: 8, overflow: "hidden" }}>
            <div style={{ flex: 1, padding: "8px 10px", textAlign: "center", background: MAROON, color: WHITE }}>
              <div style={{ fontSize: 9, fontFamily: "sans-serif" }}>❤️ Tourist Favorite</div>
            </div>
            <div style={{ flex: 1, padding: "8px 10px", textAlign: "center" }}>
              <div style={{ fontSize: 14, fontWeight: 700, fontFamily: "sans-serif", color: MAROON }}>{t.rating.toFixed(1)}</div>
              <StarRating rating={t.rating} />
            </div>
            <div style={{ flex: 1, padding: "8px 10px", textAlign: "center" }}>
              <div style={{ fontSize: 13, fontWeight: 700, fontFamily: "sans-serif" }}>{t.reviews}</div>
              <div style={{ fontSize: 9, fontFamily: "sans-serif", color: "#777" }}>Reviews</div>
            </div>
          </div>

          <div style={{ fontSize: 10, color: "#777", fontFamily: "sans-serif", marginBottom: 8 }}>
            Operated by: Basey Tours
          </div>

          <h3 style={{ fontSize: 13, fontFamily: "'Georgia', serif", margin: "0 0 6px" }}>Overview</h3>
          <p style={{ fontSize: 11, color: "#555", fontFamily: "sans-serif", lineHeight: 1.6, margin: "0 0 8px" }}>
            Take a break from the hustle and bustle and immerse yourself in the serene and culturally rich
            environment of Basey, Samar. This exclusive tour offers a unique combination of natural beauty
            and hands-on cultural experience.
          </p>

          {HIGHLIGHTS.map((item, i) => (
            <div key={i} style={{ display: "flex", gap: 8, marginBottom: 6 }}>
              <span style={{ color: ORANGE, fontSize: 12 }}>•</span>
              <span style={{ fontSize: 10, fontFamily: "sans-serif", color: "#555", lineHeight: 1.5 }}>{item}</span>
            </div>
          ))}

          <button
            onClick={onItinerary}
            style={{ width: "100%", marginTop: 12, background: MAROON, color: WHITE, border: "none", borderRadius: 8, padding: "12px", fontSize: 12, fontFamily: "sans-serif", fontWeight: 700, cursor: "pointer" }}
          >
            BOOK THIS TOUR — {t.price}
          </button>
        </div>
      </div>
    </div>
  );
}
