import { MAROON, WHITE } from "../../constants/theme";
import { bagTypes } from "../../data";
import TagPill from "../shared/TagPill";
import StatusBar from "../shared/StatusBar";

export default function BagListScreen({ onBack, onBagDetail }) {
  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", background: "#fff" }}>
      <StatusBar />

      {/* Header */}
      <div
        style={{
          background: MAROON,
          padding: "8px 16px 10px",
          display: "flex",
          alignItems: "center",
          gap: 10,
        }}
      >
        <button
          onClick={onBack}
          style={{ background: "none", border: "none", color: "#fff", fontSize: 18, cursor: "pointer" }}
        >
          ‹
        </button>
        <input
          placeholder="Search here ..."
          style={{ flex: 1, background: "#fff", border: "none", borderRadius: 20, padding: "6px 14px", fontSize: 13, outline: "none" }}
        />
        <span style={{ color: "#fff", fontSize: 16 }}>🔍</span>
      </div>

      {/* Filter bar */}
      <div
        style={{
          padding: "10px 16px 4px",
          display: "flex",
          alignItems: "center",
          gap: 8,
          borderBottom: "1px solid #eee",
        }}
      >
        <span style={{ fontSize: 13, fontFamily: "sans-serif", fontWeight: 700 }}>
          Customize ▾
        </span>
        <TagPill label="Material ▾" active={false} onClick={() => {}} />
        <TagPill label="Color ▾"    active={false} onClick={() => {}} />
        <TagPill label="Designs ▾"  active={false} onClick={() => {}} />
      </div>

      <div style={{ flex: 1, overflowY: "auto" }}>
        <div style={{ padding: "12px 16px", fontWeight: 700, fontFamily: "sans-serif", fontSize: 14 }}>
          Bags
        </div>

        {bagTypes.map((bag) => (
          <button
            key={bag.name}
            onClick={() => onBagDetail(bag)}
            style={{
              display: "flex",
              width: "100%",
              padding: "0 16px 16px",
              background: "none",
              border: "none",
              cursor: "pointer",
              textAlign: "left",
            }}
          >
            <div
              style={{
                width: "100%",
                background: "#f9f7ff",
                borderRadius: 12,
                overflow: "hidden",
                border: "1px solid #e8e8e8",
              }}
            >
              <div
                style={{
                  height: 160,
                  background: `linear-gradient(135deg, ${MAROON}20, ${MAROON}60)`,
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  fontSize: 64,
                  position: "relative",
                }}
              >
                {bag.img}
                <div
                  style={{
                    position: "absolute",
                    top: 8,
                    right: 8,
                    background: "#fff",
                    borderRadius: "50%",
                    width: 26,
                    height: 26,
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                  }}
                >
                  ♡
                </div>
              </div>
              <div
                style={{
                  padding: "10px 12px",
                  display: "flex",
                  justifyContent: "space-between",
                  alignItems: "center",
                }}
              >
                <span style={{ fontFamily: "sans-serif", fontSize: 13, fontWeight: 700 }}>
                  {bag.name}
                </span>
                <span style={{ fontFamily: "sans-serif", fontSize: 12, color: MAROON, fontWeight: 700 }}>
                  {bag.price}
                </span>
              </div>
            </div>
          </button>
        ))}
      </div>
    </div>
  );
}
