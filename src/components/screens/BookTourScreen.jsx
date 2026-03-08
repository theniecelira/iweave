import { useState } from "react";
import { MAROON, ORANGE, WHITE } from "../../constants/theme";
import { tourPackages, hotels, restaurants } from "../../data";
import StatusBar from "../shared/StatusBar";
import TagPill from "../shared/TagPill";
import StarRating from "../shared/StarRating";

const SECTIONS   = ["Tour Packages", "Hotels & Homes", "Restaurants", "Transport", "Flights"];
const TOUR_TYPES = ["All", "Cave", "Bridge", "Church", "Weaving", "Customize Own Tour"];

export default function BookTourScreen({ onTourDetail, onItinerary }) {
  const [activeSection,  setActiveSection]  = useState("Tour Packages");
  const [activeTourType, setActiveTourType] = useState("All");

  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", background: "#fff" }}>
      <StatusBar />

      {/* Top nav */}
      <div style={{ background: MAROON }}>
        <div style={{ padding: "8px 16px", display: "flex", gap: 12, overflowX: "auto" }}>
          {SECTIONS.map((s) => (
            <button
              key={s}
              onClick={() => setActiveSection(s)}
              style={{
                background: "none", border: "none",
                color: activeSection === s ? WHITE : "rgba(255,255,255,0.55)",
                fontSize: 11, fontFamily: "sans-serif",
                fontWeight: activeSection === s ? 700 : 400,
                cursor: "pointer", whiteSpace: "nowrap",
                borderBottom: activeSection === s ? "2px solid white" : "none",
                paddingBottom: 4,
              }}
            >
              {s}
            </button>
          ))}
        </div>

        {/* Search row */}
        <div style={{ padding: "4px 16px 10px", display: "flex", gap: 8 }}>
          <div style={{ flex: 2, background: WHITE, borderRadius: 6, padding: "6px 10px", fontSize: 11, fontFamily: "sans-serif", color: "#aaa" }}>📍 Search Basey's Tourist Spots</div>
          <div style={{ flex: 1, background: WHITE, borderRadius: 6, padding: "6px 10px", fontSize: 11, fontFamily: "sans-serif", color: "#aaa" }}>📅 Add dates</div>
          <div style={{ flex: 1, background: WHITE, borderRadius: 6, padding: "6px 10px", fontSize: 11, fontFamily: "sans-serif", color: "#aaa" }}>👥 Add tourists</div>
          <button style={{ background: ORANGE, border: "none", borderRadius: 6, padding: "0 12px", cursor: "pointer", color: WHITE, fontSize: 14 }}>🔍</button>
        </div>
      </div>

      <div style={{ flex: 1, overflowY: "auto" }}>
        {/* ── Tour Packages ── */}
        {activeSection === "Tour Packages" && (
          <>
            <div style={{ padding: "10px 16px", display: "flex", gap: 8, overflowX: "auto" }}>
              {TOUR_TYPES.map((t) => (
                <TagPill key={t} label={t} active={activeTourType === t} onClick={() => setActiveTourType(t)} />
              ))}
            </div>
            <div style={{ padding: "0 16px", display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12 }}>
              {tourPackages.map((tour) => (
                <button
                  key={tour.id}
                  onClick={() => onTourDetail(tour)}
                  style={{ background: "none", border: "1px solid #e0e0e0", borderRadius: 10, overflow: "hidden", cursor: "pointer", textAlign: "left" }}
                >
                  <div style={{ height: 80, background: tour.color, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 32, position: "relative" }}>
                    {tour.img}
                    {tour.badge && (
                      <div style={{ position: "absolute", top: 4, left: 4, background: MAROON, color: WHITE, fontSize: 8, padding: "2px 6px", borderRadius: 4, fontFamily: "sans-serif" }}>
                        Tourist Favorite
                      </div>
                    )}
                    <div style={{ position: "absolute", top: 4, right: 4, background: WHITE, borderRadius: "50%", width: 20, height: 20, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 11 }}>♡</div>
                  </div>
                  <div style={{ padding: "8px" }}>
                    <div style={{ fontSize: 9, fontFamily: "sans-serif", fontWeight: 700, color: "#222", lineHeight: 1.3, marginBottom: 4 }}>{tour.name}</div>
                    <div style={{ display: "flex", alignItems: "center", gap: 2, marginBottom: 3 }}>
                      <StarRating rating={tour.rating} size={9} />
                      <span style={{ fontSize: 9, color: "#777", fontFamily: "sans-serif" }}>{tour.reviews} reviews</span>
                    </div>
                    {tour.original && <div style={{ fontSize: 9, color: "#aaa", fontFamily: "sans-serif", textDecoration: "line-through" }}>{tour.original}</div>}
                    <div style={{ fontSize: 11, color: MAROON, fontFamily: "sans-serif", fontWeight: 700 }}>{tour.price}</div>
                  </div>
                </button>
              ))}
            </div>
          </>
        )}

        {/* ── Hotels & Homes ── */}
        {activeSection === "Hotels & Homes" && (
          <div style={{ padding: "10px 16px" }}>
            <div style={{ display: "flex", gap: 8, overflowX: "auto", marginBottom: 12 }}>
              {["All", "Hostels", "Guesthouses", "Bed and Breakfast"].map((t) => (
                <TagPill key={t} label={t} active={t === "All"} onClick={() => {}} />
              ))}
            </div>
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12 }}>
              {hotels.map((h, i) => (
                <div key={i} style={{ border: "1px solid #e0e0e0", borderRadius: 10, overflow: "hidden" }}>
                  <div style={{ height: 80, background: `hsl(${i * 60 + 180}, 40%, 40%)`, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 28, position: "relative" }}>
                    🏨
                    {h.fav && <div style={{ position: "absolute", top: 4, left: 4, background: MAROON, color: WHITE, fontSize: 7, padding: "2px 4px", borderRadius: 3, fontFamily: "sans-serif" }}>Tourist Favorite</div>}
                    <div style={{ position: "absolute", top: 4, right: 4, background: WHITE, borderRadius: "50%", width: 18, height: 18, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 10 }}>♡</div>
                  </div>
                  <div style={{ padding: "6px 8px" }}>
                    <div style={{ display: "flex", alignItems: "center", gap: 4, marginBottom: 2 }}>
                      <StarRating rating={h.rating * 2} size={9} />
                      <span style={{ fontSize: 9, color: "#555", fontFamily: "sans-serif" }}>{h.rating.toFixed(1)}</span>
                    </div>
                    <div style={{ fontSize: 9, fontWeight: 700, fontFamily: "sans-serif", color: "#222", lineHeight: 1.3 }}>{h.name}</div>
                    <div style={{ fontSize: 8, color: "#777", fontFamily: "sans-serif", lineHeight: 1.3, margin: "2px 0" }}>{h.desc}</div>
                    <div style={{ fontSize: 10, color: MAROON, fontFamily: "sans-serif", fontWeight: 700 }}>{h.price}</div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* ── Restaurants ── */}
        {activeSection === "Restaurants" && (
          <div style={{ padding: "10px 16px" }}>
            <div style={{ display: "flex", gap: 8, overflowX: "auto", marginBottom: 12 }}>
              {["All", "Fast Food", "Cafe", "Buffet", "Diner"].map((t) => (
                <TagPill key={t} label={t} active={t === "All"} onClick={() => {}} />
              ))}
            </div>
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12 }}>
              {restaurants.map((r, i) => (
                <div key={i} style={{ border: "1px solid #e0e0e0", borderRadius: 10, overflow: "hidden" }}>
                  <div style={{ height: 70, background: `hsl(${i * 45 + 20}, 50%, 35%)`, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 26 }}>
                    {["🍚","🍛","☕","🏡"][i]}
                  </div>
                  <div style={{ padding: "6px 8px" }}>
                    <div style={{ fontSize: 9, fontWeight: 700, fontFamily: "sans-serif", color: "#222" }}>{r.name}</div>
                    <div style={{ fontSize: 8, color: "#777", fontFamily: "sans-serif" }}>{r.type}</div>
                    <StarRating rating={r.rating * 2} size={9} />
                    <div style={{ fontSize: 8, color: "#4CAF50", fontFamily: "sans-serif" }}>{r.hours}</div>
                    <div style={{ display: "flex", gap: 4, marginTop: 4 }}>
                      {["Directions", "Menu", "Call"].map((a) => (
                        <button key={a} style={{ flex: 1, background: "#f0f0f0", border: "none", borderRadius: 4, padding: "3px 2px", fontSize: 7, fontFamily: "sans-serif", cursor: "pointer" }}>{a}</button>
                      ))}
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* ── Transport / Flights ── */}
        {(activeSection === "Transport" || activeSection === "Flights") && (
          <div style={{ padding: "20px 16px", textAlign: "center" }}>
            <div style={{ fontSize: 40, marginBottom: 12 }}>
              {activeSection === "Transport" ? "🚗" : "✈️"}
            </div>
            <div style={{ fontFamily: "sans-serif", fontSize: 13, color: "#555" }}>
              {activeSection === "Transport"
                ? "Browse available transportation options including Toyota Vios, Toyota Wigo, and more."
                : "Book flights to Tacloban, Eastern Visayas."}
            </div>
            <button
              onClick={onItinerary}
              style={{ marginTop: 16, background: ORANGE, color: WHITE, border: "none", borderRadius: 8, padding: "10px 24px", fontSize: 12, fontFamily: "sans-serif", fontWeight: 700, cursor: "pointer" }}
            >
              Build Custom Itinerary
            </button>
          </div>
        )}

        <div style={{ height: 16 }} />
      </div>
    </div>
  );
}
