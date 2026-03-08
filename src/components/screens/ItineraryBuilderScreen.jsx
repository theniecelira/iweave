import { useState } from "react";
import { MAROON, ORANGE, WHITE } from "../../constants/theme";
import { hotels, restaurants, calendarData } from "../../data";
import StatusBar from "../shared/StatusBar";
import StarRating from "../shared/StarRating";

const MAP_PINS = [
  { top: "10%", left: "50%", label: "Corsega Islands" },
  { top: "35%", left: "30%", label: "Saob Cave"       },
  { top: "45%", left: "55%", label: "Sohoton Cave"    },
  { top: "60%", left: "25%", label: "Natural Bridge"  },
  { top: "70%", left: "60%", label: "Basey"           },
  { top: "80%", left: "30%", label: "Brgy. Salvacion" },
];

const CARS = [
  { name: "Toyota Vios",  seats: 5, trans: "Manual" },
  { name: "Toyota Wigo",  seats: 4, trans: "Manual" },
];

export default function ItineraryBuilderScreen({ onBack }) {
  const [selectedDate, setSelectedDate] = useState(25);

  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", background: "#fff" }}>
      <StatusBar />

      {/* Header search row */}
      <div style={{ background: MAROON, padding: "8px 16px 10px", display: "flex", alignItems: "center", gap: 8 }}>
        <button onClick={onBack} style={{ background: "none", border: "none", color: WHITE, fontSize: 18, cursor: "pointer" }}>‹</button>
        <input placeholder="Search Basey's Tourist Spots" style={{ flex: 2, background: WHITE, borderRadius: 6, padding: "5px 8px", border: "none", fontSize: 11, outline: "none" }} />
        <input placeholder="Add dates"  style={{ flex: 1, background: WHITE, borderRadius: 6, padding: "5px 8px", border: "none", fontSize: 11, outline: "none" }} />
        <input placeholder="Add guests" style={{ flex: 1, background: WHITE, borderRadius: 6, padding: "5px 8px", border: "none", fontSize: 11, outline: "none" }} />
        <button style={{ background: ORANGE, border: "none", borderRadius: 6, padding: "5px 8px", cursor: "pointer", color: WHITE }}>🔍</button>
      </div>

      <div style={{ flex: 1, overflowY: "auto" }}>
        {/* Title */}
        <div style={{ background: ORANGE, margin: "10px 16px", borderRadius: 8, padding: "6px 12px", textAlign: "center" }}>
          <span style={{ color: WHITE, fontFamily: "sans-serif", fontSize: 12, fontWeight: 700 }}>Itinerary Builder</span>
        </div>

        {/* ── Step 1: Map View ── */}
        <Section step={1} title="Map View" subtitle="Tap on an attraction to see detailed information, images, and available tours.">
          <div style={{ margin: "8px 0 4px", height: 150, background: "#d4e4c4", borderRadius: 8, position: "relative", overflow: "hidden" }}>
            <div style={{ position: "absolute", inset: 0, background: "linear-gradient(135deg, #c8dfc0, #a8c890, #d4c4a0)", opacity: 0.8 }} />
            {MAP_PINS.map((pin, i) => (
              <div key={i} style={{ position: "absolute", top: pin.top, left: pin.left, transform: "translate(-50%,-50%)", zIndex: 1 }}>
                <div style={{ background: "#E53935", color: WHITE, borderRadius: "50% 50% 50% 0", width: 16, height: 16, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 7, transform: "rotate(-45deg)" }}>
                  <span style={{ transform: "rotate(45deg)" }}>●</span>
                </div>
                <div style={{ background: "rgba(255,255,255,0.9)", borderRadius: 4, padding: "1px 4px", fontSize: 7, fontFamily: "sans-serif", whiteSpace: "nowrap", marginTop: 2 }}>{pin.label}</div>
              </div>
            ))}
            <div style={{ position: "absolute", bottom: 6, right: 6, display: "flex", flexDirection: "column", gap: 2 }}>
              {["+", "−"].map((s) => (
                <button key={s} style={{ background: WHITE, border: "1px solid #ccc", width: 20, height: 20, display: "flex", alignItems: "center", justifyContent: "center", cursor: "pointer", fontSize: 12, borderRadius: 4 }}>{s}</button>
              ))}
            </div>
          </div>
          <div style={{ display: "flex", gap: 8, alignItems: "center", marginTop: 8 }}>
            <span style={{ background: ORANGE, color: WHITE, borderRadius: 12, padding: "3px 10px", fontSize: 10, fontFamily: "sans-serif", fontWeight: 700 }}>DAY 1</span>
            <button style={{ background: "#f0f0f0", border: "none", borderRadius: 12, padding: "3px 8px", fontSize: 9, fontFamily: "sans-serif", cursor: "pointer" }}>⇄ Rearrange</button>
            <button style={{ background: MAROON, color: WHITE, border: "none", borderRadius: 12, padding: "3px 8px", fontSize: 9, fontFamily: "sans-serif", cursor: "pointer" }}>+ New Event</button>
          </div>
        </Section>

        {/* ── Step 2: Activities ── */}
        <Section step={2} title="Activities" subtitle="Add activities to your itinerary and edit details like duration and start time.">
          {[0, 1].map((i) => (
            <div key={i} style={{ marginBottom: 8 }}>
              <div style={{ display: "flex", gap: 6, alignItems: "center" }}>
                <span style={{ fontSize: 14 }}>🚶</span>
                <select style={{ flex: 1, background: WHITE, border: "1px solid #ddd", borderRadius: 4, padding: "5px 8px", fontSize: 10, fontFamily: "sans-serif" }}>
                  <option>Select Activity to do in Basey...</option>
                  <option>Banig Weaving Workshop</option>
                  <option>Saob Cave Tour</option>
                  <option>Natural Bridge Trek</option>
                </select>
                <span style={{ fontSize: 12 }}>▼</span>
              </div>
              <div style={{ display: "flex", gap: 6, marginTop: 4 }}>
                <div style={{ display: "flex", gap: 4, alignItems: "center", fontSize: 10, fontFamily: "sans-serif", color: "#777" }}>
                  📅 Duration: <input placeholder="no. of hours" style={{ width: 60, border: "1px solid #ddd", borderRadius: 4, padding: "2px 4px", fontSize: 10 }} />
                </div>
                <div style={{ display: "flex", gap: 4, alignItems: "center", fontSize: 10, fontFamily: "sans-serif", color: "#777" }}>
                  ⏰ Start: <input placeholder="time" style={{ width: 50, border: "1px solid #ddd", borderRadius: 4, padding: "2px 4px", fontSize: 10 }} />
                </div>
              </div>
            </div>
          ))}
          <button style={{ background: "none", border: "none", color: ORANGE, fontSize: 10, fontFamily: "sans-serif", fontWeight: 700, cursor: "pointer" }}>+ ADD MORE ACTIVITIES</button>
        </Section>

        {/* ── Step 3: Accommodation ── */}
        <Section step={3} title="Accommodation" subtitle="Browse and select from a list of local accommodations.">
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 8, marginBottom: 6 }}>
            {hotels.slice(0, 2).map((h, i) => (
              <div key={i} style={{ border: "1px solid #ddd", borderRadius: 8, overflow: "hidden" }}>
                <div style={{ height: 60, background: `hsl(${i * 60 + 180}, 40%, 40%)`, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 24 }}>🏨</div>
                <div style={{ padding: "4px 6px" }}>
                  <div style={{ fontSize: 8, fontFamily: "sans-serif", fontWeight: 700, lineHeight: 1.3 }}>{h.name}</div>
                  <div style={{ fontSize: 8, color: "#777", fontFamily: "sans-serif" }}>{h.desc.split("|")[0]}</div>
                  <div style={{ fontSize: 9, color: MAROON, fontFamily: "sans-serif", fontWeight: 700 }}>{h.price}</div>
                </div>
              </div>
            ))}
          </div>
          <button style={{ background: "none", border: "none", color: ORANGE, fontSize: 10, fontFamily: "sans-serif", fontWeight: 700, cursor: "pointer" }}>SEE MORE</button>
        </Section>

        {/* ── Step 4: Transportation ── */}
        <Section step={4} title="Transportation" subtitle="Choose from available transportation options.">
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 8 }}>
            {CARS.map((car, i) => (
              <div key={i} style={{ border: "1px solid #ddd", borderRadius: 8, overflow: "hidden" }}>
                <div style={{ height: 70, background: `hsl(${i * 30 + 200}, 20%, 70%)`, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 30 }}>🚗</div>
                <div style={{ padding: "4px 6px" }}>
                  <div style={{ fontSize: 10, fontFamily: "sans-serif", fontWeight: 700 }}>{car.name}</div>
                  <div style={{ fontSize: 9, color: "#777", fontFamily: "sans-serif" }}>👤 {car.seats} seats | ⚙️ {car.trans}</div>
                </div>
              </div>
            ))}
          </div>
        </Section>

        {/* ── Step 5: Restaurants ── */}
        <Section step={5} title="Restaurants" subtitle="View recommendations for restaurants in Basey, Samar.">
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 8, marginBottom: 6 }}>
            {restaurants.slice(0, 2).map((r, i) => (
              <div key={i} style={{ border: "1px solid #ddd", borderRadius: 8, overflow: "hidden" }}>
                <div style={{ height: 55, background: `hsl(${i * 45 + 20}, 50%, 35%)`, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 22 }}>
                  {["🍚","🍛"][i]}
                </div>
                <div style={{ padding: "4px 6px" }}>
                  <div style={{ fontSize: 9, fontFamily: "sans-serif", fontWeight: 700 }}>{r.name}</div>
                  <StarRating rating={r.rating * 2} size={8} />
                  <div style={{ fontSize: 8, color: "#4CAF50", fontFamily: "sans-serif" }}>{r.hours}</div>
                </div>
              </div>
            ))}
          </div>
          <button style={{ background: "none", border: "none", color: ORANGE, fontSize: 10, fontFamily: "sans-serif", fontWeight: 700, cursor: "pointer" }}>SEE MORE</button>
        </Section>

        {/* ── Step 6: Book and Confirm ── */}
        <Section step={6} title="Book and Confirm">
          {/* Mini calendar */}
          <div style={{ background: WHITE, borderRadius: 8, padding: 8, marginBottom: 8, border: "1px solid #eee" }}>
            <div style={{ textAlign: "center", fontSize: 11, fontFamily: "sans-serif", fontWeight: 700, marginBottom: 6, color: MAROON }}>
              {calendarData.month}
            </div>
            <div style={{ display: "grid", gridTemplateColumns: "repeat(7, 1fr)", gap: 2, fontSize: 9, fontFamily: "sans-serif", textAlign: "center", marginBottom: 4 }}>
              {["Su","Mo","Tu","We","Th","Fr","Sa"].map((d) => (
                <div key={d} style={{ fontWeight: 700, color: "#777" }}>{d}</div>
              ))}
              {calendarData.days.map((d, i) => (
                <button
                  key={i}
                  onClick={() => d && setSelectedDate(d)}
                  style={{
                    background: d === selectedDate ? MAROON : d === 27 ? "#ffd0d0" : "none",
                    color: d === selectedDate ? WHITE : "#333",
                    border: "none", borderRadius: "50%",
                    width: 20, height: 20,
                    display: "flex", alignItems: "center", justifyContent: "center",
                    cursor: d ? "pointer" : "default",
                    margin: "auto", fontSize: 9,
                  }}
                >
                  {d}
                </button>
              ))}
            </div>
          </div>

          {/* Booking fields */}
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 8, marginBottom: 8 }}>
            {[
              { label: "📅 Travel Dates", el: <select style={{ fontSize: 10, fontFamily: "sans-serif", border: "none", width: "100%", marginTop: 2 }}><option>May 25 - May 27</option></select> },
              { label: "👥 Tourists",     el: <select style={{ fontSize: 10, fontFamily: "sans-serif", border: "none", width: "100%", marginTop: 2 }}><option>2 tourists</option></select> },
              { label: "⏰ Starting time",el: <select style={{ fontSize: 10, fontFamily: "sans-serif", border: "none", width: "100%", marginTop: 2 }}><option>9:00 A.M.</option></select> },
            ].map(({ label, el }) => (
              <div key={label} style={{ background: WHITE, borderRadius: 6, padding: "6px 8px", border: "1px solid #eee" }}>
                <div style={{ fontSize: 9, color: "#777", fontFamily: "sans-serif" }}>{label}</div>
                {el}
              </div>
            ))}
            <button style={{ background: ORANGE, color: WHITE, border: "none", borderRadius: 6, fontSize: 10, fontFamily: "sans-serif", fontWeight: 700, cursor: "pointer" }}>
              Check availability
            </button>
          </div>

          <div style={{ fontSize: 10, fontFamily: "sans-serif", color: "#555", marginBottom: 8 }}>
            ⚠️ Cancellation Policy: This reservation is non-refundable.
          </div>
          <div style={{ display: "flex", gap: 8, justifyContent: "flex-end", marginBottom: 10, fontSize: 10, fontFamily: "sans-serif" }}>
            {["⬇ Download","📤 Share","💾 Save"].map((a) => (
              <button key={a} style={{ background: "none", border: "none", cursor: "pointer", color: "#555" }}>{a}</button>
            ))}
          </div>

          {/* Book now row */}
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", background: WHITE, borderRadius: 8, padding: "10px 12px", border: "1px solid #eee" }}>
            <div>
              <div style={{ fontSize: 14, color: ORANGE, fontFamily: "sans-serif", fontWeight: 700 }}>₱8,270.00</div>
              <div style={{ fontSize: 9, color: "#777", fontFamily: "sans-serif" }}>May 25-27</div>
            </div>
            <button style={{ background: MAROON, color: WHITE, border: "none", borderRadius: 8, padding: "10px 24px", fontSize: 13, fontFamily: "sans-serif", fontWeight: 700, cursor: "pointer" }}>
              BOOK NOW
            </button>
          </div>
        </Section>

        <div style={{ height: 16 }} />
      </div>
    </div>
  );
}

// ── Helper: numbered section wrapper ──────────────────────────────────────────
function Section({ step, title, subtitle, children }) {
  return (
    <div style={{ margin: "0 16px 12px", background: "#f9f7ff", borderRadius: 10, border: "1px solid #e0ddf0", padding: "10px 12px" }}>
      <div style={{ display: "flex", gap: 8, alignItems: "center", marginBottom: subtitle ? 4 : 8 }}>
        <span style={{ background: MAROON, color: "#fff", borderRadius: "50%", width: 22, height: 22, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 11, fontWeight: 700, fontFamily: "sans-serif", flexShrink: 0 }}>
          {step}
        </span>
        <span style={{ fontFamily: "sans-serif", fontSize: 12, fontWeight: 700 }}>{title}</span>
      </div>
      {subtitle && <div style={{ fontSize: 10, color: "#777", fontFamily: "sans-serif", marginBottom: 8 }}>{subtitle}</div>}
      {children}
    </div>
  );
}
